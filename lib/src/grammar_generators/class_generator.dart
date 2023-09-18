import '../allocator.dart';
import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import 'production_rule_generator.dart';

class ClassGenerator {
  static const _template = '''
class {{className}} {
  {{members}}

  {{events}}

  {{methods}}

  @pragma('vm:prefer-inline')
  String? matchLiteral(
      State<StringReader> state, String string, ParseError error) {
    final input = state.input;
    state.ok = input.startsWith(string, state.pos);
    if (state.ok) {
      state.pos += input.count;
      return string;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  String? matchLiteral1(
      State<StringReader> state, int char, String string, ParseError error) {
    final input = state.input;
    state.ok = state.pos < input.length && input.readChar(state.pos) == char;
    if (state.ok) {
      state.pos += input.count;
      state.ok = true;
      return string;
    }
    state.fail(error);
    return null;
  }
}''';

  static const _templateEvents = '''
void beginEvent(String event) {
  return;
}

R? endEvent<R>(String event, R? result, bool ok) {
  return result;
}''';

  final String className;

  final Grammar grammar;

  ClassGenerator({
    required this.className,
    required this.grammar,
  }) {
    if (grammar.start == null) {
      ArgumentError.checkNotNull(grammar.start, 'grammar.start');
    }
  }

  String generate() {
    final values = <String, String>{};
    values['className'] = className;
    values['members'] = grammar.members ?? '';
    final start = grammar.start!;
    final generatedRules = <String, String>{};
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: generatedRules,
            isFast: false,
            rule: start)
        .generate();
    values['methods'] = generatedRules.values.join('\n\n');
    final hasEvents = grammar.rules.any((e) {
      if (e.metadata case final metadata?) {
        return metadata.any((e) => e.name == '@event');
      }

      return false;
    });
    values['events'] = hasEvents ? _templateEvents : '';
    return helper.render(_template, values);
  }
}

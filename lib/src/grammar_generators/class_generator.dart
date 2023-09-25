import '../allocator.dart';
import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import 'events_generator.dart';
import 'production_rule_generator.dart';

class ClassGenerator {
  static const _template = '''
class {{className}} {
  {{members}}

  {{events}}

  {{methods}}

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar(State<StringReader> state, int char, ParseError error) {
    final input = state.input;
    state.ok = input.matchChar(char, state.pos);
    if (state.ok) {
      state.pos += input.count;
      return char;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
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
  @pragma('dart2js:tryInline')
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
void beginEvent({{event_type}} event) {
  return;
}

R? endEvent<R>({{event_type}} event, R? result, bool ok) {
  return result;
}''';

  final Grammar grammar;

  final String parserName;

  ClassGenerator({
    required this.grammar,
    required this.parserName,
  }) {
    if (grammar.start == null) {
      ArgumentError.checkNotNull(grammar.start, 'grammar.start');
    }
  }

  String generate() {
    final values = <String, String>{};
    values['className'] = parserName;
    values['members'] = grammar.members ?? '';
    final start = grammar.start!;
    final generatedRules = <String, String>{};
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: generatedRules,
            isFast: false,
            parserName: parserName,
            rule: start)
        .generate();
    final methodNames = generatedRules.keys;
    final publicMethodNames =
        methodNames.where((e) => !e.startsWith('_')).toList();
    final privateMethodNames =
        methodNames.where((e) => e.startsWith('_')).toList();
    publicMethodNames.sort();
    privateMethodNames.sort();
    final methods = <String>[];
    for (final name in [...publicMethodNames, ...privateMethodNames]) {
      final source = generatedRules[name]!;
      methods.add(source);
    }

    values['methods'] = methods.join('\n\n');
    grammar.rules.any((e) => e.hasEvent());
    final hasEvents = grammar.rules.any((e) => e.hasEvent());
    if (hasEvents) {
      values['event_type'] = EventsGenerator.getEnumType(parserName);
      values['events'] = helper.render(_templateEvents, values);
    } else {
      values['events'] = '';
    }

    return helper.render(_template, values);
  }
}

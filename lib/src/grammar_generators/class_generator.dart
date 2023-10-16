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
}''';

  static const _templateEvents = '''
void beginEvent({{event_type}} event) {
  return;
}

R? endEvent<R>({{event_type}} event, R? result, bool ok) {
  return result;
}''';

  final Grammar grammar;

  final bool isAsync;

  final String parserName;

  ClassGenerator({
    required this.grammar,
    required this.isAsync,
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
    final methods = <String, String>{};
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: methods,
            isFast: false,
            isAsync: isAsync,
            parserName: parserName,
            rule: start)
        .generate();
    _addInternalMethods(methods);
    if (isAsync) {
      _addAsyncMethods(methods);
    }

    final methodNames = methods.keys;
    final publicMethodNames =
        methodNames.where((e) => !e.startsWith('_')).toList();
    final privateMethodNames =
        methodNames.where((e) => e.startsWith('_')).toList();
    publicMethodNames.sort();
    privateMethodNames.sort();
    final methodList = <String>[];
    for (final name in [...publicMethodNames, ...privateMethodNames]) {
      final source = methods[name]!;
      methodList.add(source);
    }

    values['methods'] = methodList.join('\n\n');
    grammar.rules.any((e) => e.hasEvent());
    final hasEvents = grammar.rules.any((e) => e.hasEvent());
    if (hasEvents) {
      values['event_type'] = EventsGenerator.getEnumType(parserName);
      values['events'] = helper.render(_templateEvents, values);
    } else {
      values['events'] = '';
    }

    return helper.render(_template, values, removeEmptyLines: false);
  }

  void _addInternalMethods(Map<String, String> methods) {
    const methodMap = {
      'matchLiteral': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral(State<String> state, String string, ParseError error) {
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
    final pos = state.pos;
    state.ok = pos < input.length &&
        input.codeUnitAt(pos) == string.codeUnitAt(0) &&
        input.startsWith(string, pos);
    if (state.ok) {
      state.pos += string.length;
      return string;
    } else {
      state.fail(error);
    }
    return null;
  }''',
      'matchLiteral1': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1(State<String> state, String string, ParseError error) {
    final input = state.input;
    final pos = state.pos;
    state.ok =
        pos < input.length && input.codeUnitAt(pos) == string.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
      return string;
    }
    state.fail(error);
    return null;
  }''',
      'matchLiteral2': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral2(State<String> state, String string, ParseError error) {
    final input = state.input;
    final pos = state.pos;
    final pos2 = pos + 1;
    state.ok = pos2 < input.length &&
        input.codeUnitAt(pos) == string.codeUnitAt(0) &&
        input.codeUnitAt(pos2) == string.codeUnitAt(1);
    if (state.ok) {
      state.pos += 2;
      return string;
    }
    state.fail(error);
    return null;
  }''',
      'matchLiteral1Async': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1Async(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    state.ok = pos < input.end &&
        input.data.codeUnitAt(pos - start) == string.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
      return string;
    }
    state.fail(error);
    return null;
  }''',
      'matchLiteral2Async': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral2Async(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    final start = input.start;
    final data = input.data;
    final pos = state.pos;
    final index = pos - start;
    state.ok = pos + 1 < input.end &&
        data.codeUnitAt(index) == string.codeUnitAt(0) &&
        data.codeUnitAt(index + 1) == string.codeUnitAt(1);
    if (state.ok) {
      state.pos += 2;
      return string;
    }
    state.fail(error);
    return null;
  }''',
      'matchLiteralAsync': '''
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteralAsync(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
    final start = input.start;
    final data = input.data;
    final pos = state.pos;
    final index = pos - start;
    state.ok = pos < input.end &&
        data.codeUnitAt(index) == string.codeUnitAt(0) &&
        data.startsWith(string, index);
    if (state.ok) {
      state.pos += string.length;
      return string;
    }
    state.fail(error);
    return null;
  }'''
    };
    final source = methods.values.join('\n\n');
    for (final entry in methodMap.entries) {
      final key = entry.key;
      final value = entry.value;
      if (source.contains(key)) {
        methods[key] = value;
      }
    }
  }

  void _addAsyncMethods(Map<String, String> methods) {
    //
  }
}

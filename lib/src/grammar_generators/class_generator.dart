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
    const methodMap = <String, String>{};
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

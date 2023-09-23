import '../grammar/grammar.dart';
import '../helper.dart' as helper;

class EventsGenerator {
  static const _template = '''
enum {{name}} { {{elements}} }''';

  final Grammar grammar;

  final String parserName;

  EventsGenerator({
    required this.grammar,
    required this.parserName,
  });

  String generate() {
    final rules = grammar.rules;
    final rulesWithEvents = rules.where((e) => e.hasEvent());
    if (rulesWithEvents.isEmpty) {
      return '';
    }

    final values = <String, String>{};
    final events = <String>[];
    for (final rule in rulesWithEvents) {
      final event = getElementName(rule);
      events.add(event);
    }

    values['elements'] = events.join(', ');
    values['name'] = getEnumType(parserName);
    return helper.render(_template, values);
  }

  static String getElementFullName(ProductionRule rule, String parserName) {
    final type = getEnumType(parserName);
    final element = getElementName(rule);
    return '$type.$element';
  }

  static String getElementName(ProductionRule rule) {
    final name = rule.name;
    final first = name[0].toLowerCase();
    final rest = name.substring(1);
    final result = '$first${rest}Event';
    return result;
  }

  static String getEnumType(String parserName) {
    return '${parserName}Event';
  }
}

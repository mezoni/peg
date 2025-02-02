import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import '../parser_generator_options.dart';
import 'production_rule_generator.dart';

class ClassGenerator {
  final List<String> errors;

  final Grammar grammar;

  final ParserGeneratorOptions options;

  ClassGenerator({
    required this.errors,
    required this.grammar,
    required this.options,
  });

  String generate() {
    final buffer = <String>[];
    final rules = grammar.rules.toList();
    rules.sort((a, b) => a.name.compareTo(b.name));
    for (var i = 0; i < rules.length; i++) {
      final rule = rules[i];
      final generator = ProductionRuleGenerator(
        errors: errors,
        options: options,
        rule: rule,
      );
      final code = generator.generate();
      buffer.add(code);
    }

    final values = {
      'code': buffer.join('\n\n'),
      'members': grammar.members ?? '',
      'name': options.name,
    };
    const template = '''
class {{name}} {
  {{members}}

  {{code}}
}''';
    return helper.render(template, values, removeEmptyLines: false);
  }
}

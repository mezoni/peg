import '../../parser_generator_options.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import 'production_rule_generator.dart';

class ClassGenerator {
  final List<String> errors;

  final String? members;

  final String name;

  final ParserGeneratorOptions options;

  final List<ProductionRule> rules;

  ClassGenerator({
    required this.errors,
    this.members,
    required this.name,
    required this.options,
    required this.rules,
  });

  String generate() {
    final buffer = <String>[];
    final rules2 = rules.toList();
    rules2.sort((a, b) => a.name.compareTo(b.name));
    for (var i = 0; i < rules2.length; i++) {
      final rule = rules2[i];
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
      'members': members ?? '',
      'name': name,
    };
    const template = '''
class {{name}} {
  {{members}}

  {{code}}
}''';
    return helper.render(template, values, removeEmptyLines: false);
  }
}

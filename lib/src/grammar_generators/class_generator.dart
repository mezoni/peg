import '../grammar/grammar.dart';
import '../helper.dart';
import '../parser_generator_diagnostics.dart';
import '../parser_generator_options.dart';
import 'production_rule_generator.dart';

class ClassGenerator {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  final ParserGeneratorOptions options;

  ClassGenerator({
    required this.diagnostics,
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
        diagnostics: diagnostics,
        options: options,
        rule: rule,
      );
      final code = generator.generate();
      buffer.add(code);
      if (diagnostics.hasErrors) {
        return '';
      }
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
    return render(template, values, removeEmptyLines: false);
  }
}

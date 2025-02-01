import '../../parser_generator_options.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import 'class_generator.dart';

import 'runtime_generator.dart';

class LibraryGenerator {
  final bool addReader;

  final String classname;

  final List<String> errors;

  final String? globals;

  final String? members;

  final ParserGeneratorOptions options;

  final List<ProductionRule> rules;

  LibraryGenerator({
    this.addReader = true,
    required this.classname,
    required this.errors,
    this.globals,
    this.members,
    required this.options,
    required this.rules,
  });

  String generate() {
    final classGenerator = ClassGenerator(
      errors: errors,
      members: members,
      name: classname,
      options: options,
      rules: rules,
    );

    final runtimeGenerator = RuntimeGenerator();
    final values = {
      'globals': globals ?? '',
      'parser': classGenerator.generate(),
      'runtime': runtimeGenerator.generate(),
    };

    const template = '''
{{globals}}

{{parser}}

{{runtime}}''';
    return helper.render(template, values, removeEmptyLines: false);
  }
}

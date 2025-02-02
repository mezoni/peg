import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import '../parser_generator_options.dart';
import 'class_generator.dart';
import 'parse_function_generator.dart';
import 'runtime_generator.dart';

class LibraryGenerator {
  final List<String> errors;

  final ParserGeneratorOptions options;

  final Grammar grammar;

  LibraryGenerator({
    required this.errors,
    required this.grammar,
    required this.options,
  });

  String generate() {
    final classGenerator = ClassGenerator(
      errors: errors,
      grammar: grammar,
      options: options,
    );

    final runtimeGenerator = RuntimeGenerator();
    final parseFunctionGenerator = ParseFunctionGenerator(
      errors: errors,
      grammar: grammar,
      options: options,
    );
    final values = {
      'globals': grammar.globals ?? '',
      'parser': classGenerator.generate(),
      'runtime': runtimeGenerator.generate(),
      'top_level': parseFunctionGenerator.generate(),
    };

    const template = '''
{{globals}}

{{top_level}}

{{parser}}

{{runtime}}''';
    return helper.render(template, values, removeEmptyLines: false);
  }
}

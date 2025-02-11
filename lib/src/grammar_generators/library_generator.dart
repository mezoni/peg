import '../grammar/grammar.dart';
import '../helper.dart';
import '../parser_generator_diagnostics.dart';
import '../parser_generator_options.dart';
import 'class_generator.dart';
import 'parse_function_generator.dart';
import 'runtime_generator.dart';

class LibraryGenerator {
  final ParserGeneratorDiagnostics diagnostics;

  final ParserGeneratorOptions options;

  final Grammar grammar;

  LibraryGenerator({
    required this.diagnostics,
    required this.grammar,
    required this.options,
  });

  String generate() {
    final classGenerator = ClassGenerator(
      diagnostics: diagnostics,
      grammar: grammar,
      options: options,
    );

    final values = <String, String>{};

    final runtimeGenerator = RuntimeGenerator();
    final parseFunctionGenerator = ParseFunctionGenerator(
      diagnostics: diagnostics,
      grammar: grammar,
      options: options,
    );
    values.addAll({
      'globals': grammar.globals ?? '',
      'parser': classGenerator.generate(),
      'runtime': runtimeGenerator.generate(),
      'top_level': parseFunctionGenerator.generate(),
    });

    if (diagnostics.hasErrors) {
      return '';
    }

    const template = '''
{{globals}}

{{top_level}}

{{parser}}

{{runtime}}''';
    return render(template, values, removeEmptyLines: false);
  }
}

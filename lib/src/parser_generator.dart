import 'grammar_generators/library_generator.dart';
import 'parser_generator_options.dart';
import 'peg_parser/peg_parser.dart' as peg_parser;

export 'parser_generator_options.dart';

class ParserGenerator {
  final List<String> errors;

  final ParserGeneratorOptions options;

  final String source;

  ParserGenerator({
    required this.errors,
    required this.options,
    required this.source,
  });

  String generate() {
    final grammar = peg_parser.parse(source);
    final libraryGenerator = LibraryGenerator(
      errors: errors,
      grammar: grammar,
      options: options,
    );

    errors.addAll(grammar.errors);
    if (errors.isNotEmpty) {
      return '';
    }

    return libraryGenerator.generate();
  }
}

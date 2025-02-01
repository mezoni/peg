import 'parser_generator_options.dart';
import 'src/grammar/grammar.dart';
import 'src/grammar_generators/library_generator.dart';

export 'parser_generator_options.dart';

class ParserGenerator {
  final String classname;

  final List<String> errors;

  final Grammar grammar;

  final ParserGeneratorOptions options;

  ParserGenerator({
    required this.options,
    required this.classname,
    required this.errors,
    required this.grammar,
  });

  String generate() {
    final rules = grammar.rules;
    final libraryGenerator = LibraryGenerator(
      options: options,
      classname: classname,
      errors: errors,
      globals: grammar.globals,
      members: grammar.members,
      rules: rules,
    );

    errors.addAll(grammar.errors);
    if (errors.isNotEmpty) {
      return '';
    }

    return libraryGenerator.generate();
  }
}

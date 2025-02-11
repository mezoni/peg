import 'grammar/grammar.dart';
import 'grammar/production_rule.dart';
import 'grammar_analyzers/grammar_initializer0.dart';
import 'grammar_analyzers/grammar_initializer1.dart';
import 'grammar_generators/library_generator.dart';
import 'parser_generator_diagnostics.dart';
import 'parser_generator_options.dart';
import 'peg_parser/peg_parser.dart' as peg_parser;

export 'parser_generator_options.dart';

class ParserGenerator {
  final ParserGeneratorDiagnostics diagnostics = ParserGeneratorDiagnostics();

  final ParserGeneratorOptions options;

  final String source;

  ParserGenerator({
    required this.options,
    required this.source,
  });

  String generate() {
    final grammar = peg_parser.parse(source);
    final libraryGenerator = LibraryGenerator(
      diagnostics: diagnostics,
      grammar: grammar,
      options: options,
    );

    _initializeGrammar(grammar);
    if (diagnostics.hasErrors) {
      return '';
    }

    var result = '';
    result = libraryGenerator.generate();
    if (diagnostics.hasErrors) {
      return '';
    }

    return result;
  }

  void _initializeGrammar(Grammar grammar) {
    final ruleSet = <ProductionRule>{};
    final rules = grammar.rules;
    for (var rule in rules) {
      final name = rule.name;
      if (!ruleSet.add(rule)) {
        final error = diagnostics.error('Duplicate production rule name');
        error.description('Name', name);
        return;
      }

      rule.resultType = rule.resultType.trim();
    }

    if (rules.isEmpty) {
      diagnostics.error('No rule definitions found');
      return;
    }

    final grammarInitializer0 = GrammarInitializer0(
      grammar: grammar,
      diagnostics: diagnostics,
    );
    grammarInitializer0.initialize();
    if (diagnostics.hasErrors) {
      return;
    }

    final grammarInitializer1 = GrammarInitializer1(
      grammar: grammar,
      diagnostics: diagnostics,
    );
    grammarInitializer1.initialize();

    if (diagnostics.hasErrors) {
      return;
    }
  }
}

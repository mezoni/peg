import '../expression_analyzers/expression_initializer1.dart';
import '../grammar/grammar.dart';
import '../parser_generator_diagnostics.dart';

class GrammarInitializer1 {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  GrammarInitializer1({
    required this.diagnostics,
    required this.grammar,
  });

  void initialize() {
    final expressionInitializer1 = ExpressionInitializer1(
      diagnostics: diagnostics,
      grammar: grammar,
    );
    expressionInitializer1.initialize();
  }
}

import '../expression_analyzers/expression_initializer1.dart';
import '../grammar/grammar.dart';

class GrammarInitializer1 {
  void initialize(Grammar grammar) {
    if (grammar.errors.isNotEmpty) {
      return;
    }

    final expressionInitializer1 = ExpressionInitializer1();
    expressionInitializer1.initialize(grammar);
  }
}

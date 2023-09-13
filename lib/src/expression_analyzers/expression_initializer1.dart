import '../grammar/grammar.dart';
import 'expression_result_type_resolver.dart';

class ExpressionInitializer1 {
  void initialize(Grammar grammar) {
    final rules = grammar.rules;
    //final optionalExpressionResolver = OptionalExpressionResolver();
    //optionalExpressionResolver.resolve(rules);
    //final expressionStartCharactersResolver = ExpressionStartCharactersResolver();
    //expressionStartCharactersResolver.resolve(rules);
    // final expressionSuccessfulnessResolver = ExpressionSuccessfulnessResolver();
    //expressionSuccessfulnessResolver.resolve(grammar);
    final expressionResultTypeResolver = ExpressionResultTypeResolver();
    expressionResultTypeResolver.resolve(rules);
    //final expressionResultUsageResolver = ExpressionResultUsageResolver();
    //expressionResultUsageResolver.resolve(rules);
    //final expressionErrorResolver = ExpressionErrorResolver();
    //expressionErrorResolver.resolve(rules);
  }
}

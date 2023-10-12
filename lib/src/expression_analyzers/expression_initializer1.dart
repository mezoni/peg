import '../grammar/grammar.dart';
import 'optional_expressions_resolver.dart';
import 'result_type_resolver.dart';
import 'starting_characters_resolver.dart';
import 'starting_expressions_resolver.dart';

class ExpressionInitializer1 {
  void initialize(Grammar grammar) {
    final rules = grammar.rules;
    final optionalExpressionsResolver = OptionalExpressionsResolver();
    optionalExpressionsResolver.resolve(rules);
    final startingExpressionsResolver = StartingExpressionsResolver();
    startingExpressionsResolver.resolve(rules);
    final startingCharactersResolver = StartingCharactersResolver();
    startingCharactersResolver.resolve(rules);
    // final expressionSuccessfulnessResolver = ExpressionSuccessfulnessResolver();
    //expressionSuccessfulnessResolver.resolve(grammar);
    final resultTypeResolver = ResultTypesResolver();
    resultTypeResolver.resolve(rules);
    //final expressionResultUsageResolver = ExpressionResultUsageResolver();
    //expressionResultUsageResolver.resolve(rules);
    //final expressionErrorResolver = ExpressionErrorResolver();
    //expressionErrorResolver.resolve(rules);
  }
}

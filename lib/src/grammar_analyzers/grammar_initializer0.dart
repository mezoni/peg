import '../expression_analyzers/expression_initializer0.dart';
import '../grammar/grammar.dart';
import 'invocations_resolver.dart';
import 'starting_rule_resolver.dart';

class GrammarInitializer0 {
  void initialize(Grammar grammar) {
    if (grammar.errors.isNotEmpty) {
      return;
    }

    final expressionInitializer0 = ExpressionInitializer0();
    expressionInitializer0.initialize(grammar);
    if (expressionInitializer0.errors.isNotEmpty) {
      grammar.errors.addAll(expressionInitializer0.errors);
      return;
    }

    final invocationsResolver = InvocationsResolver();
    invocationsResolver.resolve(grammar);
    final startingRulesFinder = StartingRuleResolver();
    final startingRules = startingRulesFinder.find(grammar);
    if (startingRules.isEmpty) {
      final start = grammar.rules.first;
      grammar.start = start;
    } else if (startingRules.length > 1) {
      final names = startingRules.map((e) => e.name);
      grammar.errors.add('Found several starting rules: ${names.join(', ')}');
    } else {
      grammar.start = startingRules.first;
    }
  }
}

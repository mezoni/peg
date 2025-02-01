import '../grammar/grammar.dart';
import '../grammar/production_rule.dart';

class StartingRuleResolver {
  List<ProductionRule> find(Grammar grammar) {
    final result = <ProductionRule>[];
    final rules = grammar.rules;
    for (final rule in rules) {
      if (rule.directCallers.isEmpty) {
        result.add(rule);
      }
    }

    return result;
  }
}

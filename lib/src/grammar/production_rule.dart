import '../expressions/expression.dart';

class ProductionRule {
  final Expression expression;

  String? expected;

  final String name;

  String getResultType() {
    if (resultType.isEmpty) {
      return 'Object';
    } else {
      return resultType;
    }
  }

  String resultType;

  final Set<ProductionRule> allCallees = {};

  final Set<NonterminalExpression> allCallers = {};

  final Set<ProductionRule> directCallees = {};

  final Set<NonterminalExpression> directCallers = {};

  ProductionRule({
    this.expected,
    required this.expression,
    required this.name,
    String? resultType,
  }) : resultType = resultType ?? '';

  @override
  String toString() {
    return '$name = $expression';
  }
}

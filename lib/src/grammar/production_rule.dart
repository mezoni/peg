import '../expressions/expression.dart';

export '../expressions/expression.dart';

class ProductionRule {
  final Expression expression;

  String? expected;

  final String name;

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

  String getResultType() {
    if (resultType.isEmpty) {
      return 'void';
    } else {
      return resultType.trim();
    }
  }

  String getReturnType() {
    final type = getResultType();
    return '($type,)?';
  }

  @override
  String toString() {
    return '$name = $expression';
  }
}

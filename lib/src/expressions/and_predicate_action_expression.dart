import 'expression.dart';

class AndPredicateActionExpression extends Expression {
  final String action;

  AndPredicateActionExpression({
    required this.action,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicateAction(this);
  }

  @override
  String toString() {
    return '&{$action}';
  }
}

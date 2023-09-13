import 'expression.dart';

class AndPredicateExpression extends SingleExpression {
  AndPredicateExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicate(this);
  }

  @override
  String toString() {
    return '&$expression';
  }
}

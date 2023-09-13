import 'expression.dart';

class NotPredicateExpression extends SingleExpression {
  NotPredicateExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitNotPredicate(this);
  }

  @override
  String toString() {
    return '!$expression';
  }
}

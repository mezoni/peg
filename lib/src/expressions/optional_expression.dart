import 'expression.dart';

class OptionalExpression extends SingleExpression {
  OptionalExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOptional(this);
  }

  @override
  String toString() {
    return '$expression?';
  }
}

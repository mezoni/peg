import 'expression.dart';

class BufferExpression extends SingleExpression {
  BufferExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitBuffer(this);
  }

  @override
  String toString() {
    return '@buffer($expression)';
  }
}

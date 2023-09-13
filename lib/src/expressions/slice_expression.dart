import 'expression.dart';

class SliceExpression extends SingleExpression {
  SliceExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSlice(this);
  }

  @override
  String toString() {
    return '\$$expression';
  }
}

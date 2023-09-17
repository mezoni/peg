import 'expression.dart';

class VerifyExpression extends SingleExpression {
  String handler;

  VerifyExpression({
    required super.expression,
    required this.handler,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitVerify(this);
  }

  @override
  String toString() {
    return '@verify$expression)';
  }
}

import 'expression.dart';

class CutExpression extends Expression {
  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCut(this);
  }

  @override
  String toString() {
    return '↑';
  }
}

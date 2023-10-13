import 'expression.dart';

class EofExpression extends Expression {
  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitEof(this);
  }

  @override
  String toString() {
    return '@eof()';
  }
}

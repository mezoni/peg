import 'expression.dart';

class AnyCharacterExpression extends Expression {
  AnyCharacterExpression();

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  String toString() {
    return '.';
  }
}

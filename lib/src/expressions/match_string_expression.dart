import 'expression.dart';

class MatchStringExpression extends Expression {
  final String string;

  MatchStringExpression({
    required this.string,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMatchString(this);
  }

  @override
  String toString() {
    return '@matchString()';
  }
}

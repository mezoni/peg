import 'expression.dart';

class MatchStringExpression extends Expression {
  final String value;

  MatchStringExpression({
    required this.value,
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

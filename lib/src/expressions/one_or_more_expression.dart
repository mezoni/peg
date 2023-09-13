import 'expression.dart';

class OneOrMoreExpression extends SingleExpression {
  OneOrMoreExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOneOrMore(this);
  }

  @override
  String toString() {
    return '$expression+';
  }
}

import '../visitors/visitors.dart';
import 'expression.dart';

class ZeroOrMoreExpression extends SingleExpression {
  ZeroOrMoreExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitZeroOrMore(this);
  }

  @override
  String toString() {
    return '$expression*';
  }
}

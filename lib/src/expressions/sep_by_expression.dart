import '../visitors/visitors.dart';
import 'expression.dart';

class SepByExpression extends MultipleExpression {
  final Expression expression;

  final Expression separator;

  SepByExpression({
    required this.expression,
    required this.separator,
  }) : super(expressions: [expression, separator]);

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSepBy(this);
  }

  @override
  String toString() {
    return '@sepBy($expression, $separator)';
  }
}

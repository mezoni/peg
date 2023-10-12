import '../visitors/visitors.dart';
import 'expression.dart';

class SepBy1Expression extends MultipleExpression {
  final Expression expression;

  final Expression separator;

  SepBy1Expression({
    required this.expression,
    required this.separator,
  }) : super(expressions: [expression, separator]);

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSepBy1(this);
  }

  @override
  String toString() {
    return '@sepBy1($expression, $separator)';
  }
}

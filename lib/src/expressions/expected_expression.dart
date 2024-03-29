import '../helper.dart' as helper;
import 'expression.dart';

class ExpectedExpression extends SingleExpression {
  String tag;

  ExpectedExpression({
    required super.expression,
    required this.tag,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitExpected(this);
  }

  @override
  String toString() {
    final escapedTag = helper.escapeString(tag);
    return '@expected($escapedTag, $expression)';
  }
}

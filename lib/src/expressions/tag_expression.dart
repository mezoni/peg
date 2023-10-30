import '../helper.dart' as helper;
import 'expression.dart';

class TagExpression extends SingleExpression {
  String tag;

  TagExpression({
    required super.expression,
    required this.tag,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitTag(this);
  }

  @override
  String toString() {
    final escapedTag = helper.escapeString(tag);
    return '@tag($escapedTag, $expression)';
  }
}

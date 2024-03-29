import '../helper.dart' as helper;
import 'expression.dart';

class VerifyExpression extends SingleExpression {
  String message;

  String predicate;

  VerifyExpression({
    required super.expression,
    required this.message,
    required this.predicate,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitVerify(this);
  }

  @override
  String toString() {
    final escapedMessage = helper.escapeString(message);
    return '@verify($escapedMessage, $expression)';
  }
}

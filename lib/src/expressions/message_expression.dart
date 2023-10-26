import '../helper.dart' as helper;
import 'expression.dart';

class MessageExpression extends SingleExpression {
  final String message;

  MessageExpression({
    required super.expression,
    required this.message,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMessage(this);
  }

  @override
  String toString() {
    final escapedMessage = helper.escapeString(message);
    return '@message($escapedMessage, $expression)';
  }
}

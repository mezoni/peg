import '../helper.dart' as helper;
import 'expression.dart';

class IndicateExpression extends SingleExpression {
  final String message;

  IndicateExpression({
    required super.expression,
    required this.message,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitIndicate(this);
  }

  @override
  String toString() {
    final escapedMessage = helper.escapeString(message);
    return '@indicate($escapedMessage, $expression)';
  }
}

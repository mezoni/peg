import 'expression.dart';

class ErrorHandlerExpression extends SingleExpression {
  String handler;

  ErrorHandlerExpression({
    required super.expression,
    required this.handler,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitErrorHandler(this);
  }

  @override
  String toString() {
    return '@errorHandler($expression)';
  }
}

import '../helper.dart' as helper;
import 'expression.dart';

class LiteralExpression extends Expression {
  final bool caseSensitive;

  final String string;

  LiteralExpression({
    this.caseSensitive = true,
    required this.string,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitLiteral(this);
  }

  @override
  String toString() {
    return helper.escapeString(string);
  }
}

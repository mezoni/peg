import '../visitors/visitors.dart';
import 'expression.dart';

class ListExpression extends MultipleExpression {
  final Expression first;

  final Expression next;

  ListExpression({
    required this.first,
    required this.next,
  }) : super(expressions: [first, next]);

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitList(this);
  }

  @override
  String toString() {
    return '@list($first, $next)';
  }
}

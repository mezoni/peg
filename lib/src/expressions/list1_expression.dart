import '../visitors/visitors.dart';
import 'expression.dart';

class List1Expression extends MultipleExpression {
  final Expression first;

  final Expression next;

  List1Expression({
    required this.first,
    required this.next,
  }) : super(expressions: [first, next]);

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitList1(this);
  }

  @override
  String toString() {
    return '@list1($first, $next)';
  }
}

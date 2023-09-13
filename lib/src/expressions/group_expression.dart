import 'expression.dart';

class GroupExpression extends SingleExpression {
  GroupExpression({
    required super.expression,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitGroup(this);
  }

  @override
  String toString() {
    return '($expression)';
  }
}

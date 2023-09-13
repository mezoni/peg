import 'expression.dart';

class OrderedChoiceExpression extends MultipleExpression {
  OrderedChoiceExpression({
    required super.expressions,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOrderedChoice(this);
  }

  @override
  String toString() {
    return expressions.join(' / ');
  }

  @override
  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(visitor);
    }
  }
}

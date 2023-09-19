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
}

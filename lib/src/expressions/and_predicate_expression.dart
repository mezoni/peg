import 'expression.dart';
import 'expressions.dart';

class AndPredicateExpression extends SingleExpression {
  AndPredicateExpression({required super.expression});

  @override
  String generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final values = {
      'p': expression.generate(context),
    };
    const template = '''
{{p}}
state.position = {{$pos}};''';
    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicate(this);
  }
}

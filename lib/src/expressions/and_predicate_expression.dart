import 'expression.dart';
import 'expressions.dart';

class AndPredicateExpression extends SingleExpression {
  AndPredicateExpression({required super.expression});

  @override
  String generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    context.setExpressionResultUsage(expression, false);
    final r = context.allocateExpressionVariable(expression);
    final assignment =
        assignResult(context, '$r != null ? const (null,) : null');
    final values = {
      'p': expression.generate(context),
    };
    final template = '''
{{p}}
state.position = {{$pos}};
$assignment''';
    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicate(this);
  }
}

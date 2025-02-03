import 'expression.dart';
import 'expressions.dart';

class NotPredicateExpression extends SingleExpression {
  NotPredicateExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitNotPredicate(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    context.setExpressionResultUsage(expression, false);
    final r = context.allocateExpressionVariable(expression);
    final assignment =
        assignResult(context, '$r == null ? const (null,) : null');
    final values = {
      'notPredicate': context.allocate(),
      'p': expression.generate(context),
      'r': r,
    };
    final template = '''
final {{notPredicate}} = state.notPredicate;
state.notPredicate = true;
{{p}}
state.notPredicate = {{notPredicate}};
if ({{r}} != null) {
  state.fail(state.position - {{$pos}});
  state.position = {{$pos}};
}
$assignment''';
    return render(context, this, template, values);
  }
}

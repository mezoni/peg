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
    final values = {
      'notPredicate': context.allocate(),
      'p': expression.generate(context),
    };
    const template = '''
final {{notPredicate}} = state.notPredicate;
state.notPredicate = true;
{{p}}
state.notPredicate = {{notPredicate}};
if (!(state.isSuccess = !state.isSuccess)) {
  state.fail(state.position - {{$pos}});
  state.position = {{$pos}};
}''';
    return render(context, this, template, values);
  }
}

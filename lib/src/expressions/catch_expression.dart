import 'expression.dart';

class CatchExpression extends SingleExpression {
  final String catchBlock;

  CatchExpression({
    required super.expression,
    required this.catchBlock,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCatch(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    if (variable != null) {
      context.setExpressionVariable(expression, variable);
    }

    final p = expression.generate(context);
    final values = {
      'failure': context.allocate('failure'),
      'catchBlock': catchBlock,
      'p': p,
    };
    const template = '''
final {{failure}} = state.enter();
{{p}}
if (!state.isSuccess) {
  {{catchBlock}}
}
state.leave({{failure}});''';
    return render(context, this, template, values);
  }
}

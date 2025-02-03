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
    context.setExpressionVariable(expression, variable);
    context.copyExpressionResultUsage(this, expression);
    final values = {
      'failure': context.allocate('failure'),
      'catchBlock': catchBlock,
      'p': expression.generate(context),
      'r': variable,
    };
    const template = '''
final {{failure}} = state.enter();
{{p}}
if ({{variable}} == null) {
  {{catchBlock}}
}
state.leave({{failure}});''';
    return render(context, this, template, values);
  }
}

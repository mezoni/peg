import 'expression.dart';

class OptionalExpression extends SingleExpression {
  OptionalExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOptional(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    context.setExpressionVariable(expression, variable);
    context.copyExpressionResultUsage(this, expression);
    final values = {
      'p': expression.generate(context),
      'variable': variable,
    };
    const template = '''
{{p}}
{{variable}} ??= state.opt((null,));''';
    return render(context, this, template, values);
  }
}

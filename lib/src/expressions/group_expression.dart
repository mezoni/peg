import 'expression.dart';

class GroupExpression extends SingleExpression {
  GroupExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitGroup(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    context.setExpressionVariable(expression, variable);
    context.copyExpressionResultUsage(this, expression);
    final p = expression.generate(context);
    final values = {
      'p': p,
    };
    const template = '''
{{p}}''';
    return render(context, this, template, values);
  }
}

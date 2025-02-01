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
    if (variable != null) {
      context.setExpressionVariable(expression, variable);
    }

    final values = {
      'p': expression.generate(context),
    };
    const template = '''
{{p}}
state.isSuccess = true;''';
    return render(context, this, template, values);
  }
}

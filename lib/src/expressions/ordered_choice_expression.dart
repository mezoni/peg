import 'expression.dart';

class OrderedChoiceExpression extends MultiExpression {
  OrderedChoiceExpression({required super.expressions});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOrderedChoice(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = <String, String>{};
    if (expressions.length == 1) {
      final expression = expressions[0];
      context.setExpressionVariable(expression, variable);
      context.copyExpressionResultUsage(this, expression);
      context.changeExpressionVariableDeclarator(variable, this, expression);
      values['p0'] = expression.generate(context);
    } else {
      for (var i = 0; i < expressions.length; i++) {
        final expression = expressions[i];
        context.setExpressionVariable(expression, variable);
        context.copyExpressionResultUsage(this, expression);
        values['p$i'] = expression.generate(context);
      }
    }

    var code = '';
    for (var i = expressions.length - 1; i >= 0; i--) {
      final expression = expressions[i];
      final r = context.getExpressionVariable(expression);
      final p = '{{p$i}}';
      if (i == 0) {
        code = '$p\n$code';
      } else if (i < expressions.length - 1) {
        code = '\nif ($r == null) { $p\n $code }';
      } else {
        code = '\nif ($r == null) { $p\n }';
      }
    }

    final template = code;
    return render(context, this, template, values);
  }
}

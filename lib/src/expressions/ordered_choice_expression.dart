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
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      if (variable != null) {
        context.setExpressionVariable(expression, variable);
      }

      values['p$i'] = expression.generate(context);
    }

    var code = '';
    for (var i = expressions.length - 1; i >= 0; i--) {
      final p = '{{p$i}}';
      if (i == 0) {
        code = '$p\n$code';
      } else if (i < expressions.length - 1) {
        code = '\nif (!state.isSuccess) { $p\n $code }';
      } else {
        code = '\nif (!state.isSuccess) { $p\n }';
      }
    }

    final template = code;
    return render(context, this, template, values);
  }
}

import 'expression.dart';
import 'expressions.dart';

class MatchExpression extends SingleExpression {
  MatchExpression({required super.expression});

  @override
  String generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final values = {
      'p': expression.generate(context),
    };
    var template = '';
    if (variable != null) {
      values.addAll({
        'variable': variable,
      });

      template = '''
{{p}}
{{variable}} = state.isSuccess ? state.input.substring({{$pos}}, state.position) : null;''';
    } else {
      template = '''
{{p}}''';
    }

    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMatch(this);
  }
}

import 'expression.dart';
import 'expressions.dart';

class MatchExpression extends SingleExpression {
  MatchExpression({required super.expression});

  @override
  String generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final isResultUsed = context.getExpressionResultUsage(this);
    context.setExpressionResultUsage(expression, false);
    final r = context.allocateExpressionVariable(expression);
    final values = {
      'p': expression.generate(context),
      'r': r,
    };
    final assignment = !isResultUsed
        ? ''
        : assignResult(context,
            '$r != null ? (state.input.substring({{$pos}}, state.position),) : null');
    final template = '''
{{p}}
$assignment''';
    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMatch(this);
  }
}

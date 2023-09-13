import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OrderedChoiceGenerator
    extends ExpressionGenerator<OrderedChoiceExpression> {
  static const _templateNext = '''
{{p}}
if (!state.ok) {
  {{next}}
}''';

  OrderedChoiceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final expressions = expression.expressions;
    if (expressions.isEmpty) {
      throw StateError(
          'Sequence expression must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      for (final child in expressions) {
        ruleGenerator.setExpressionVariable(child, variable);
      }
    }

    String plunge(int i) {
      final values = <String, String>{};
      final child = expressions[i];
      if (i < expressions.length - 1) {
        values['next'] = plunge(i + 1);
        values['p'] = generateExpression(child, false);
        return render(_templateNext, values);
      }

      return generateExpression(child, false);
    }

    return plunge(0);
  }
}

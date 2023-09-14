import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OptionalGenerator extends ExpressionGenerator<OptionalExpression> {
  static const _template = '''
{{p}}
state.ok = true;''';

  OptionalGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

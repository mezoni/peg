import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OptionalGenerator extends ExpressionGenerator<OptionalExpression> {
  OptionalGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateExpression(child, false);
    const template = '''
{{p}}
if (!state.ok) {
  state.setOk(true);
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateAsyncExpression(child, false);
    const template = '''
{{p}}
if (!state.ok) {
  state.setOk(true);
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }
}

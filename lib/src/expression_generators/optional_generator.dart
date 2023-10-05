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
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateExpression(child, false);
    const template = '''
{{p}}
state.ok = true;''';
    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, false);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    {
      final values = <String, String>{};
      const template = '''
 if (!state.ok) {
  state.ok = true;
}''';
      asyncGenerator.render(template, values);
    }
  }
}

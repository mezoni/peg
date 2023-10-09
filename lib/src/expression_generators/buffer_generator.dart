import '../expressions/expressions.dart';
import 'expression_generator.dart';

class BufferGenerator extends ExpressionGenerator<BufferExpression> {
  BufferGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    return generateExpression(child, false);
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

    asyncGenerator.buffering++;
    values['p'] = generateAsyncExpression(child, false);
    asyncGenerator.buffering--;
    const template = '''
{{p}}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
    );
  }
}

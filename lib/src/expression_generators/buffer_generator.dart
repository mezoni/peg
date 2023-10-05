import '../expressions/expressions.dart';
import 'expression_generator.dart';

class BufferGenerator extends ExpressionGenerator<BufferExpression> {
  BufferGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    return generateExpression(child, false);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, false);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');
  }
}

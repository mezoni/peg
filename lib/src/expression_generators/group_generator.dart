import '../expressions/expressions.dart';
import 'expression_generator.dart';

class GroupGenerator extends ExpressionGenerator<GroupExpression> {
  GroupGenerator({
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
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    return generateAsyncExpression(child, false);
  }
}

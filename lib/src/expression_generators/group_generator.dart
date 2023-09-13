import '../expressions/expressions.dart';
import 'expression_generator.dart';

class GroupGenerator extends ExpressionGenerator<GroupExpression> {
  GroupGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    return generateExpression(child, false);
  }
}

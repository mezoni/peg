import '../async_generators/action_node.dart';
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

    values['is_optional'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{is_optional}} = state.isOptional;
state.isOptional = true;
{{p}}
state.isOptional = {{is_optional}};
if (!state.ok) {
  state.setOk(true);
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final isOptional = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    block << '$isOptional = state.isOptional;';
    block << 'state.isOptional = true;';
    generateAsyncExpression(block, child, false);
    block << 'state.isOptional = $isOptional;';
    block.if_('!state.ok', (block) {
      block << 'state.setOk(true);';
    });
  }
}

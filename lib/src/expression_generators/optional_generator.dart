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

    values['ignore_errors'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
{{p}}
state.ignoreErrors = {{ignore_errors}};
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

    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    block << '$ignoreErrors = state.ignoreErrors;';
    block << 'state.ignoreErrors = true;';
    generateAsyncExpression(block, child, false);
    block << 'state.ignoreErrors = $ignoreErrors;';
    block.if_('!state.ok', (block) {
      block << 'state.setOk(true);';
    });
  }
}

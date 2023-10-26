import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AndPredicateGenerator
    extends ExpressionGenerator<AndPredicateExpression> {
  AndPredicateGenerator({
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

    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  state.backtrack({{pos}});
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    block << '$pos = state.pos;';
    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, false);
    asyncGenerator.endBuffering(block);
    block.if_('state.ok', (block) {
      block << 'state.backtrack($pos);';
    });
  }
}

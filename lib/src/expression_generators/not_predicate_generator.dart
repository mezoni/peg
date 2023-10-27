import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class NotPredicateGenerator
    extends ExpressionGenerator<NotPredicateExpression> {
  NotPredicateGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  final length = {{pos}} - state.pos;
  state.fail(switch (length) {
    0 => const ErrorUnexpectedInput(0),
    -1 => const ErrorUnexpectedInput(-1),
    -2 => const ErrorUnexpectedInput(-2),
    _ => ErrorUnexpectedInput(length)
  });
  state.backtrack({{pos}});
} else {
  state.setOk(true);
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    block << '$pos = state.pos;';
    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, false);
    asyncGenerator.endBuffering(block);
    block.if_('state.ok', (block) {
      block << 'final length = $pos - state.pos;';
      block << 'state.fail(switch (length) {';
      block << '0 => const ErrorUnexpectedInput(0),';
      block << '-1 => const ErrorUnexpectedInput(-1),';
      block << '-2 => const ErrorUnexpectedInput(-2),';
      block << '_ => ErrorUnexpectedInput(length)';
      block << '});';
      block << 'state.backtrack($pos);';
    }).else_((block) {
      block << 'state.setOk(true);';
    });
  }
}

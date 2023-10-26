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
state.mute++;
{{p}}
state.mute--;
if (state.ok) {
  final length = state.pos - {{pos}};
  state.failAt({{pos}}, switch (length) {
    0 => const ErrorUnexpectedInput(0),
    1 => const ErrorUnexpectedInput(1),
    2 => const ErrorUnexpectedInput(2),
    _ => ErrorUnexpectedInput(length)
  });
  state.backtrack({{pos}});
} else {
  state.advance(0);
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
    block << 'state.mute++;';
    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, false);
    asyncGenerator.endBuffering(block);
    block << 'state.mute--;';
    block.if_('state.ok', (block) {
      block << 'final length = state.pos - $pos;';
      block << 'state.failAt($pos, switch (length) {';
      block << '0 => const ErrorUnexpectedInput(0),';
      block << '1 => const ErrorUnexpectedInput(1),';
      block << '2 => const ErrorUnexpectedInput(2),';
      block << '_ => ErrorUnexpectedInput(length)';
      block << '});';
      block << 'state.backtrack($pos);';
    }).else_((block) {
      block << 'state.advance(0);';
      block << 'state.setOk(true);';
    });
  }
}

import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class EofGenerator extends ExpressionGenerator<EofExpression> {
  EofGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    const template = '''
if (state.pos >= state.input.length) {
  state.setOk(true);
} else {
  state.fail(const ErrorExpectedEndOfInput());
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final handle = asyncGenerator.functionName;
    final input = allocateName();
    final label = allocateName();
    block.label(label);
    block << 'final $input = state.input;';
    block.if_('state.pos >= $input.end && !$input.isClosed', (block) {
      block << '$input.sleep = true;';
      block << '$input.handle = $handle;';
      block.return_(label);
    });
    block.if_('state.pos >= $input.end', (block) {
      block << 'state.setOk(true);';
    }).else_((block) {
      block << 'state.fail(const ErrorExpectedEndOfInput());';
    });
  }
}

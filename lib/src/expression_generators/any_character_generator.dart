import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class AnyCharacterGenerator
    extends ExpressionGenerator<AnyCharacterExpression> {
  AnyCharacterGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['input'] = allocateName();
    values['adjust_state_pos'] =
        helper.adjustStatePos('c', [(0, 0x10ffff)], false);
    if (variable != null) {
      values['assign_result'] = '$variable = c;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
if (state.pos < state.input.length) {
  final c = state.input.runeAt(state.pos);
  {{adjust_state_pos}};
  state.setOk(true);
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final handle = asyncGenerator.functionName;
    final input = allocateName();
    final adjustStatePos = helper.adjustStatePos('c', [(0, 0x10ffff)], false);
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = c;';
    }

    final label = allocateName();
    block.label(label);
    block << 'final $input = state.input;';
    block.if_('state.pos >= $input.end && !$input.isClosed', (block) {
      block << '$input.sleep = true;';
      block << '$input.handle = $handle;';
      block.return_(label);
    });
    block.if_('state.pos < $input.end', (block) {
      block << 'final c = $input.data.runeAt(state.pos - $input.start);';
      block << '$adjustStatePos;';
      block << 'state.setOk(true);';
      block << assignResult;
    }).else_((block) {
      block << 'state.fail(const ErrorUnexpectedEndOfInput());';
    });
  }
}

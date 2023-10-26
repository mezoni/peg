import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class MatchStringGenerator extends ExpressionGenerator<MatchStringExpression> {
  MatchStringGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final string = allocateName();
    values['string'] = string;
    values['value'] = expression.value;
    if (variable != null) {
      values['assign_result'] = '$variable = $string;';
      values['assign_empty_result'] = '$variable = \'\';';
    } else {
      values['assign_result'] = '';
      values['assign_empty_result'] = '';
    }

    const template = '''
final {{string}} = {{value}};
if ({{string}}.isEmpty) {
  state.setOk(true);
  {{assign_empty_result}}
} else {
  final ok = state.pos < state.input.length &&
      state.input.codeUnitAt(state.pos) == {{string}}.codeUnitAt(0) &&
      state.input.startsWith({{string}}, state.pos);
  if (ok) {
    state.pos += {{string}}.length;
    state.setOk(true);
    {{assign_result}}
  } else {
    state.fail(ErrorExpectedTags([{{string}}]));
  }
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final value = expression.value;
    final data = allocateName();
    final input = allocateName();
    final ok = allocateName();
    final pos = allocateName();
    final string = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'String'))
        .name;
    final handle = asyncGenerator.functionName;
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = $string;';
    }

    block << '$string = $value;';
    block.if_('$string.isEmpty', (block) {
      block << 'state.setOk(true);';
      block << assignResult;
    }).else_((block) {
      final label = allocateName();
      block.label(label);
      block << 'final $input = state.input;';
      block.if_(
          'state.pos + $string.length - 1 >= $input.end && !$input.isClosed',
          (block) {
        block << '$input.sleep = true;';
        block << '$input.handle = $handle;';
        block.return_(label);
      });
      block << 'final $data = $input.data;';
      block << 'final $pos = state.pos - $input.start;';
      block <<
          'final $ok = $data.codeUnitAt($pos) == $string.codeUnitAt(0) && $data.startsWith($string, $pos);';
      block.if_(ok, (block) {
        block << 'state.pos += $string.length;';
        block << 'state.setOk(true);';
        block << assignResult;
      }).else_((block) {
        block << 'state.fail(ErrorExpectedTags([$string]));';
      });
    });
  }
}

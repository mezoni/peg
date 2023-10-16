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
    final c = allocateName();
    values['c'] = c;
    values['input'] = allocateName();
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos < {{input}}.length) {
  final {{c}} = {{input}}.runeAt(state.pos);
  state.pos += {{c}} > 0xffff ? 2 : 1;
  state.ok = true;
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    const ranges = [(0, 0x10ffff)];
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final c = allocateName();
    values['c'] = c;
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    values['read_char_async'] = helper.readCharAsync(ranges, false);
    values['assign_state_pos'] = helper.assignStatePos(c, ranges, false);
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
      values['clear_result'] = '$variable = null;';
    } else {
      values['assign_result'] = '';
      values['clear_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
final {{c}} = {{read_char_async}}(state);
state.ok = {{c}} >= 0;
if (state.ok) {
  {{assign_state_pos}};
  {{assign_result}}
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }
}

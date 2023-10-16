import '../expressions/expressions.dart';
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
state.ok = state.pos < state.input.length;
if (state.ok) {
  final {{c}} = state.input.runeAt(state.pos);
  state.pos += {{c}} > 0xffff ? 2 : 1;
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedCharacter());
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    if (variable != null) {
      values['assign_result'] = '$variable = c;';
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
state.ok = state.pos < {{input}}.end;
if (state.ok) {
  final c = {{input}}.data.runeAt(state.pos - {{input}}.start);
  state.pos += c > 0xffff ? 2 : 1;
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedCharacter());
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }
}

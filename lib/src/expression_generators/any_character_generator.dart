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
if (state.pos < {{input}}.end || {{input}}.isClosed) {
  {{clear_result}}
  if (state.pos >= {{input}}.start) {
    state.ok = state.pos < {{input}}.end;
    if (state.ok) {
      final c = {{input}}.data.runeAt(state.pos - {{input}}.start);
      state.pos += c > 0xffff ? 2 : 1;
      {{assign_result}}
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  } else {
    state.fail(ErrorBacktracking(state.pos));
  }
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
    );
  }
}

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
  void generateAsync() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;

    {
      asyncGenerator.writeln('state.input.beginBuffering();');
      asyncGenerator.moveToNewState();
    }

    {
      final values = <String, String>{};
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
if (state.pos + 1 >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
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
{{input}}.endBuffering(state.pos);''';
      asyncGenerator.render(template, values);
    }
  }
}

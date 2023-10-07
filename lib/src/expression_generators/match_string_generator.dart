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
  state.ok = true;
  {{assign_empty_result}}
} else {
  state.ok = state.pos < state.input.length &&
      state.input.codeUnitAt(state.pos) == {{string}}.codeUnitAt(0) &&
      state.input.startsWith({{string}}, state.pos);
  if (state.ok) {
    state.pos += {{string}}.length;
    {{assign_result}}
  } else {
    state.fail(ErrorExpectedTags([{{string}}]));
  }
}''';
    return render(template, values);
  }

  @override
  void generateAsync() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final value = expression.value;
    final input = allocateName();
    final string = allocateName();

    asyncGenerator.writeln('state.input.beginBuffering();');
    asyncGenerator.moveToNewState();

    {
      final values = <String, String>{};
      values['handle'] = asyncGenerator.functionName;
      values['input'] = input;
      values['string'] = string;
      values['value'] = value;
      if (variable != null) {
        values['assign_result'] = '$variable = ';
      } else {
        values['assign_result'] = '';
      }

      const template = '''
final {{input}} = state.input;
final {{string}} = {{value}};
if (state.pos + {{string}}.length - 1 < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchLiteralAsync(state, {{string}}, ErrorExpectedTags([{{string}}]));
  {{input}}.endBuffering(state.pos);
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
      asyncGenerator.render(template, values);
    }
  }
}

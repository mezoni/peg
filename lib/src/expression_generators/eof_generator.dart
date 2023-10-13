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
state.ok = state.pos >= state.input.length;
if (!state.ok) {
  state.fail(const ErrorExpectedEndOfInput());
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    const template = '''
final {{input}} = state.input;
if (state.pos >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
state.ok = state.pos >= {{input}}.end;
if (!state.ok) {
  state.fail(const ErrorExpectedEndOfInput());
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }
}

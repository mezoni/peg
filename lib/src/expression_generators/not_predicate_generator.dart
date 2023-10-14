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
{{p}}
state.setOk(!state.ok);
if (!state.ok) {
  final length = {{pos}} - state.pos;
  state.fail(switch (length) {
    0 => const ErrorUnexpectedInput(0),
    1 => const ErrorUnexpectedInput(-1),
    2 => const ErrorUnexpectedInput(-2),
    _ => ErrorUnexpectedInput(length)
  });
  state.backtrack({{pos}});
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    final key = (name: pos, value: 'state.pos');
    values['pos'] = pos;
    asyncGenerator.buffering++;
    values['p'] = generateAsyncExpression(child, false);
    asyncGenerator.buffering--;
    const template = '''
{{p}}
state.setOk(!state.ok);
if (!state.ok) {
  final length = {{pos}}! - state.pos;
  state.fail(switch (length) {
    0 => const ErrorUnexpectedInput(0),
    1 => const ErrorUnexpectedInput(-1),
    2 => const ErrorUnexpectedInput(-2),
    _ => ErrorUnexpectedInput(length)
  });
  state.backtrack({{pos}}!);
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
      key: key,
    );
  }
}

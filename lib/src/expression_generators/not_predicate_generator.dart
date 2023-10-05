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
    values['length'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
{{p}}
state.ok = !state.ok;
if (!state.ok) {
  final length = {{pos}} - state.pos;
  state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(1),
        2 => const ErrorUnexpectedInput(2),
        _ => ErrorUnexpectedInput(length)
      });
}
state.pos = {{pos}};''';
    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final pos = allocateName();
    asyncGenerator.addVariable(pos, GenericType(name: 'int'));

    asyncGenerator.writeln('$pos = state.pos;');
    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, false);
    asyncGenerator.writeln('state.input.endBuffering($pos!);');

    {
      final values = <String, String>{};
      values['pos'] = pos;
      const template = '''
state.ok = !state.ok;
if (!state.ok) {
  final length = {{pos}}! - state.pos;
  state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(1),
        2 => const ErrorUnexpectedInput(2),
        _ => ErrorUnexpectedInput(length)
      });
}
state.pos = {{pos}}!;''';
      asyncGenerator.render(template, values);
    }
  }
}

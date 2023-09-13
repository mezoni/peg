import '../expressions/expressions.dart';
import 'expression_generator.dart';

class NotPredicateGenerator
    extends ExpressionGenerator<NotPredicateExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
state.ok = !state.ok;
if (!state.ok) {
  state.pos = {{pos}};
}''';

  static const _templateEof = '''
state.ok = state.pos >= state.input.length;
if (!state.ok) {
  state.fail(const ErrorExpectedEndOfInput());
}''';

  NotPredicateGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final child = expression.expression;
    if (child is AnyCharacterExpression) {
      return _generateEof();
    }

    return _generate();
  }

  String _generate() {
    final values = <String, String>{};
    final child = expression.expression;
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }

  String _generateEof() {
    return render(_templateEof, {});
  }
}

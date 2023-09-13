import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AnyCharacterGenerator
    extends ExpressionGenerator<AnyCharacterExpression> {
  static const _template = '''
if (state.pos < state.input.length) {
  {{r}} = state.input.readChar(state.pos);
  state.pos += state.input.count;
  state.ok = true;
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';

  static const _templateNoResult = '''
if (state.pos < state.input.length) {
  state.input.readChar(state.pos);
  state.pos += state.input.count;
  state.ok = true;
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';

  AnyCharacterGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = _templateNoResult;
    }

    return render(template, values);
  }
}

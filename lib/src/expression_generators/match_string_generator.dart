import '../expressions/expressions.dart';
import 'expression_generator.dart';

class MatchStringGenerator extends ExpressionGenerator<MatchStringExpression> {
  static const _template = '''
final {{literal}} = {{string}};
if ({{literal}}.isEmpty) {
  state.ok = true;
  {{r}} = '';
} else {
  state.ok = state.input.startsWith({{literal}}, state.pos);
  if (state.ok) {
    state.pos += state.input.count;
    {{r}} = {{literal}};
  } else {
    state.fail(ErrorExpectedTags([{{literal}}]));
  }
}''';

  static const _templateNoResult = '''
final {{literal}} = {{string}};
if ({{literal}}.isEmpty) {
  state.ok = true;
} else {
  state.ok = state.input.startsWith({{literal}}, state.pos);
  if (state.ok) {
    state.pos += state.input.count;
  } else {
    state.fail(ErrorExpectedTags([{{literal}}]));
  }
}''';

  MatchStringGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['literal'] = allocateName();
    values['string'] = expression.string;
    values['r'] = variable ?? '';
    final template = variable != null ? _template : _templateNoResult;
    return render(template, values);
  }
}

import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SliceGenerator extends ExpressionGenerator<SliceExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  {{r}} = state.input.substring({{pos}}, state.pos);
}''';

  SliceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }
}

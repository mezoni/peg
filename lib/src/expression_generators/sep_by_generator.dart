import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SepByGenerator extends ExpressionGenerator<SepByExpression> {
  static const _template = '''
{{p1}}
if (!state.ok) {
  state.ok = true;
  {{r}} = const [];
  } else {
  final {{list}} = [{{rv}}];
  while (true) {
    final {{pos}} = state.pos;
    {{p2}}
    if (!state.ok) {
      state.ok = true;
      {{r}} = {{list}};
      break;
    }
    {{p3}}
    if (!state.ok) {
      state.pos = {{pos}};
      break;
    }
    {{list}}.add({{rv}});
  }
}''';

  static const _templateNoResult = '''
{{p1}}
if (!state.ok) {
  state.ok = true;
  } else {
  while (true) {
    final {{pos}} = state.pos;
    {{p2}}
    if (!state.ok) {
      state.ok = true;
      break;
    }
    {{p3}}
    if (!state.ok) {
      state.pos = {{pos}};
      break;
    }
  }
}''';

  SepByGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final element = expression.expression;
    final separator = expression.separator;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    var template = '';
    if (variable != null) {
      values['O'] = element.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(element);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(element);
      template = _template;
    } else {
      template = _templateNoResult;
    }

    values['p1'] = generateExpression(element, true);
    values['p2'] = generateExpression(separator, false);
    values['p3'] = generateExpression(element, false);
    return render(template, values);
  }
}

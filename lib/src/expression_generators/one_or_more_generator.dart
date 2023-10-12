import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OneOrMoreGenerator extends ExpressionGenerator<OneOrMoreExpression> {
  OneOrMoreGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.setOk({{list}}.isNotEmpty);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      values['ok'] = allocateName();
      template = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.setOk({{ok}});''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    ({String name, String value})? key;
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(expression.resultType!);
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
      values['rv'] = getExpressionVariableWithNullCheck(child);
      key = (name: values['list']!, value: '[]');
    } else {
      values['ok'] = asyncGenerator.allocateVariable(GenericType(name: 'bool'));
      key = (name: values['ok']!, value: 'false');
    }

    values['p'] = generateAsyncExpression(child, true);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    {{r1}} = null;
    break;
  }
  {{list}}!.add({{rv}});
  {{r1}} = null;
}
state.setOk({{list}}!.isNotEmpty);
if (state.ok) {
  {{r}} = {{list}};
}
{{list}} = null;''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.setOk({{ok}}!);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
  }
}

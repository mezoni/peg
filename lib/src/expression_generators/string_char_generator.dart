import '../expressions/expressions.dart';
import 'expression_generator.dart';

class StringCharsGenerator extends ExpressionGenerator<StringCharsExpression> {
  static const _template = '''
final {{input}} = state.input;
List<String>? {{list}};
String? {{str}};
while (state.pos < {{input}}.length) {
  {{p1}}
  if (state.ok) {
    final v = {{rv1}};
    if ({{str}} == null) {
      {{str}} = v;
    } else if ({{list}} == null) {
      {{list}} = [{{str}}, v];
    } else {
      {{list}}.add(v);
    }
  }
  final pos = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
  {{p3}}
  if (!state.ok) {
    state.pos = pos;
    break;
  }
  if ({{str}} == null) {
    {{str}} = {{rv3}};
  } else {
    if ({{list}} == null) {
      {{list}} = [{{str}}, {{rv3}}];
    } else {
      {{list}}.add({{rv3}});
    }
  }
}
state.ok = true;
if ({{str}} == null) {
  {{r}} = '';
} else if ({{list}} == null) {
  {{r}} = {{str}};
} else {
  {{r}} = {{list}}.join();
}''';

  static const _templateNoResult = '''
final {{input}} = state.input;
while (state.pos < {{input}}.length) {
  {{p1}}
  final pos = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
  {{p3}}
  if (!state.ok) {
    state.pos = pos;
    break;
  }
}
state.ok = true;''';

  StringCharsGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final normalCharacters = expression.normalCharacters;
    final escapeCharacter = expression.escapeCharacter;
    final escape = expression.escape;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(normalCharacters);
      ruleGenerator.allocateExpressionVariable(escape);
    }

    final declareVariable = variable != null;
    values['p1'] = generateExpression(normalCharacters, declareVariable);
    values['p2'] = generateExpression(escapeCharacter, false);
    values['p3'] = generateExpression(escape, declareVariable);
    var template = '';
    values['input'] = allocateName();
    if (variable != null) {
      values['list'] = allocateName();
      values['str'] = allocateName();
      values['r'] = variable;
      values['rv1'] = getExpressionVariableWithNullCheck(normalCharacters);
      values['rv3'] = getExpressionVariableWithNullCheck(escape);
      template = _template;
    } else {
      template = _templateNoResult;
    }

    return render(template, values);
  }
}

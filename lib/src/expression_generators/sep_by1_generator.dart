import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SepBy1Generator extends ExpressionGenerator<SepBy1Expression> {
  SepBy1Generator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final element = expression.expression;
    final separator = expression.separator;
    if (variable != null) {
      values['O'] = element.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(element);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(element);
    } else {
      values['ok'] = allocateName();
    }

    values['pos'] = allocateName();
    values['p1'] = generateExpression(element, true);
    values['p2'] = generateExpression(separator, false);
    var template = '';
    if (variable != null) {
      template = '''
final {{list}} = <{{O}}>[];
var {{pos}} = state.pos;
while (true) {
  {{p1}}
  if (!state.ok) {
    state.backtrack({{pos}});
    break;
  }
  {{list}}.add({{rv}});
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.setOk({{list}}.isNotEmpty);
if (state.ok) {
  {{r}} = {{list}};
} else {

}''';
    } else {
      template = '''
var {{ok}} = false;
var {{pos}} = state.pos;
while (true) {
  {{p1}}
  if (!state.ok) {
    state.backtrack({{pos}});
    break;
  }
  {{ok}} = true;
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.setOk({{ok}});''';
    }

    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final element = expression.expression;
    final elementType = element.resultType!;
    final separator = expression.separator;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['state'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(
          GenericType(name: 'List', arguments: [elementType]));
      values['r1'] = ruleGenerator.allocateExpressionVariable(element);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(element);
    } else {
      values['ok'] = asyncGenerator.allocateVariable(GenericType(name: 'bool'));
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['p1'] = generateExpression(element, true);
    values['p2'] = generateExpression(separator, false);
    var initTemplate = '';
    if (variable != null) {
      initTemplate = '''
{{list}} = [];
{{pos}} = state.pos;
{{state}} = 0;''';
    } else {
      initTemplate = '''
{{ok}} = false;
{{pos}} = state.pos;
{{state}} = 0;''';
    }

    final init = render(initTemplate, values);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      state.backtrack({{pos}}!);
      {{r1}} = null;
      break;
    }
    {{list}}!.add({{rv}});
    {{r1}} = null;
    {{pos}} = state.pos;
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{state}} = 0;
  }
}
state.setOk({{list}}!.isNotEmpty);
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
}''';
    } else {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      state.backtrack({{pos}}!);
      break;
    }
    {{ok}} = true;
    {{pos}} = state.pos;
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{state}} = 0;
  }
}
state.setOk({{ok}}!);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      init: init,
    );
  }
}

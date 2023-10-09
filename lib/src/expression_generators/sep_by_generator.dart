import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SepByGenerator extends ExpressionGenerator<SepByExpression> {
  SepByGenerator({
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
    state.pos = {{pos}};
    break;
  }
  {{list}}.add({{rv}});
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = true;
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
var {{pos}} = state.pos;
while (true) {
  {{p1}}
  if (!state.ok) {
    state.pos = {{pos}};
    break;
  }
  {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
}
state.ok = true;''';
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
    values['key1'] = asyncGenerator
        .allocateVariable(GenericType(name: 'Object').getNullableType());
    values['key2'] = asyncGenerator
        .allocateVariable(GenericType(name: 'Object').getNullableType());
    values['state'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(
          GenericType(name: 'List', arguments: [elementType]));
      values['r1'] = ruleGenerator.allocateExpressionVariable(element);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(element);
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['p1'] = generateExpression(element, true);
    values['p2'] = generateExpression(separator, false);
    var template = '';
    if (variable != null) {
      template = '''
if ({{key1}} == null) {
  {{key1}} = true;
  state.input.beginBuffering();
  {{list}} = [];
  {{pos}} = state.pos;
  {{state}} = 0;
}
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      state.pos = {{pos}}!;
      state.input.endBuffering(state.pos);
      {{r1}} = null;
      break;
    }
    {{list}}!.add({{rv}});
    {{r1}} = null;
    state.input.endBuffering(state.pos);
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    if ({{key2}} == null) {
      {{key2}} = true;
      state.input.beginBuffering();
      {{pos}} = state.pos;
    }
    {{p2}}
    {{key2}} = null;
    if (!state.ok) {
      state.input.endBuffering(state.pos);
      break;
    }
    {{state}} = 0;
  }
}
state.ok = true;
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
}
{{key2}} = null;''';
    } else {
      template = '''
if ({{key1}} == null) {
  {{key1}} = true;
  state.input.beginBuffering();
  {{pos}} = state.pos;
  {{state}} = 0;
}
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      state.pos = {{pos}}!;
      state.input.endBuffering(state.pos);
      break;
    }
    state.input.endBuffering(state.pos);
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    if ({{key2}} == null) {
      {{key2}} = true;
      state.input.beginBuffering();
      {{pos}} = state.pos;
    }
    {{p2}}
    {{key2}} = null;
    if (!state.ok) {
      state.input.endBuffering(state.pos);
      break;
    }
    {{state}} = 0;
  }
}
state.ok = true;
{{key2}} = null;''';
    }

    return render(template, values);
  }
}

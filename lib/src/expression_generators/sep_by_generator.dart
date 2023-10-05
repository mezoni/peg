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
      template = '''
final {{list}} = <{{O}}>[];
{{p1}}
if (state.ok) {
  {{list}}.add({{rv}});
  while (true) {
    final {{pos}} = state.pos;
    {{p2}}
    if (!state.ok) {
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
}
state.ok = true;
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
{{p1}}
if (state.ok) {
  while (true) {
    final {{pos}} = state.pos;
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{p3}}
    if (!state.ok) {
      state.pos = {{pos}};
      break;
    }
  }
}
state.ok = true;''';
    }

    values['p1'] = generateExpression(element, true);
    values['p2'] = generateExpression(separator, false);
    values['p3'] = generateExpression(element, false);
    return render(template, values);
  }

  @override
  void generateAsync() {
    final element = expression.expression;
    final separator = expression.separator;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final endState = asyncGenerator.allocateState();
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(element);
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(element, true);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    {
      final values = <String, String>{};
      values['end'] = endState;
      values['state'] = stateVariable;
      var template = '';
      if (variable != null) {
        values['r'] = variable;
        values['rv'] = getExpressionVariableWithNullCheck(element);
        template = '''
{{r}} = [];
if (!state.ok) {
  {{state}} = {{end}};
  break;
}
{{r}}!.add({{rv}});''';
      } else {
        template = '''
if (!state.ok) {
  {{state}} = {{end}};
  break;
}''';
      }

      asyncGenerator.render(template, values);
    }

    final state0 = asyncGenerator.moveToNewState();
    final pos = allocateName();
    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = state.pos;');

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(separator, false);

    {
      final values = <String, String>{};
      values['end'] = endState;
      values['state'] = stateVariable;
      const template = '''
if (!state.ok) {
  state.input.endBuffering(state.pos);
  {{state}} = {{end}};
  break;
}''';
      asyncGenerator.render(template, values);
    }

    generateAsyncExpression(element, false);

    {
      final values = <String, String>{};
      values['end'] = endState;
      values['pos'] = pos;
      values['state'] = stateVariable;
      values['state0'] = state0;
      var template = '';
      if (variable != null) {
        values['r'] = variable;
        values['rv'] = getExpressionVariableWithNullCheck(element);
        template = '''
if (!state.ok) {
  state.pos = {{pos}}!;
  state.input.endBuffering(state.pos);
  {{state}} = {{end}};
  break;
}
state.input.endBuffering(state.pos);
{{r}}!.add({{rv}});
{{state}} = {{state0}};
break;''';
      } else {
        template = '''
if (!state.ok) {
  state.pos = {{pos}}!;
  state.input.endBuffering(state.pos);
  {{state}} = {{end}};
  break;
}
state.input.endBuffering(state.pos);
{{state}} = {{state0}};
break;''';
      }
      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(endState);
    asyncGenerator.writeln('state.ok = true;');
  }
}

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
state.ok = {{list}}.isNotEmpty;
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
state.ok = {{ok}};''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final list = variable == null ? '' : allocateName();
    final ok = variable != null ? '' : allocateName();
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    } else {
      asyncGenerator.addVariable(ok, GenericType(name: 'bool'));
      asyncGenerator.writeln('$ok = false;');
    }

    var state0 = asyncGenerator.currentState;
    if (!asyncGenerator.isEmptyState) {
      state0 = asyncGenerator.moveToNewState();
    }

    asyncGenerator.loopLevel++;

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, true);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    asyncGenerator.loopLevel--;
    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['rv'] = getExpressionVariableWithNullCheck(child);
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
{{list}}!.add({{rv}});
{{state}} = {{state0}};
break;''';
      } else {
        values['ok'] = ok;
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
{{ok}} = true;
{{state}} = {{state0}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);

    {
      final values = <String, String>{};
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['r'] = variable;
        template = '''
state.ok = {{list}}!.isNotEmpty;
if (state.ok) {
  {{r}} = {{list}};
}
{{list}} = null;''';
      } else {
        values['ok'] = ok;
        template = '''
state.ok = {{ok}}!;''';
      }

      asyncGenerator.render(template, values);
    }
  }
}

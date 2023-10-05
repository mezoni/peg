import '../expressions/expressions.dart';
import 'expression_generator.dart';

class StringCharsGenerator extends ExpressionGenerator<StringCharsExpression> {
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
      template = '''
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
    } else {
      template = '''
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
    }

    return render(template, values);
  }

  @override
  void generateAsync() {
    final normalCharacters = expression.normalCharacters;
    final escapeCharacter = expression.escapeCharacter;
    final escape = expression.escape;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final list = variable == null ? '' : allocateName();
    final ok = allocateName();
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(normalCharacters);
      ruleGenerator.allocateExpressionVariable(escape);
      asyncGenerator.addVariable(list,
          GenericType(name: 'List', arguments: [GenericType(name: 'String')]));
      asyncGenerator.writeln('$list = [];');
    }

    asyncGenerator.addVariable(ok, GenericType(name: 'bool'));
    final state0 = asyncGenerator.moveToNewState();

    //asyncGenerator.loopLevel++;

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(normalCharacters, true);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    //asyncGenerator.loopLevel--;

    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['ok'] = ok;
      values['state'] = stateVariable;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['rv'] = getExpressionVariableWithNullCheck(normalCharacters);
        template = '''
{{ok}} = state.ok;
if (state.ok) {
  {{list}}!.add({{rv}});
}
{{state}} = {{state1}};
break;''';
      } else {
        template = '''
{{ok}} = state.ok;
{{state}} = {{state1}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);
    final state2 = asyncGenerator.allocateState();
    final pos = allocateName();
    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = state.pos;');
    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(escapeCharacter, false);

    {
      final values = <String, String>{};
      values['ok'] = ok;
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state2'] = state2;
      const template = '''
if (!state.ok) {
  state.input.endBuffering(state.pos);
  {{state}} = {{ok}} == true ? {{state0}} : {{state2}};
  break;
}''';

      asyncGenerator.render(template, values);
    }

    generateAsyncExpression(escape, true);

    {
      final values = <String, String>{};
      values['pos'] = pos;
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state1'] = state1;
      values['state2'] = state2;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['rv'] = getExpressionVariableWithNullCheck(escape);
        template = '''
if (!state.ok) {
  state.pos = {{pos}}!;
  state.input.endBuffering(state.pos);
  {{state}} = {{state2}};
  break;
}
state.input.endBuffering(state.pos);
{{list}}!.add({{rv}});
{{state}} = {{state0}};
break;''';
      } else {
        template = '''
if (!state.ok) {
  state.pos = {{pos}}!;
  state.input.endBuffering(state.pos);
  {{state}} = {{state2}};
  break;
}
state.input.endBuffering(state.pos);
{{state}} = {{state0}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state2);

    if (variable != null) {
      asyncGenerator.writeln('$variable = ($list)!.join();');
      asyncGenerator.writeln('$list = null;');
    }

    asyncGenerator.writeln('state.ok = true;');
  }
}

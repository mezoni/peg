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
    state.backtrack(pos);
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
    state.backtrack(pos);
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
    final normalCharacters = expression.normalCharacters;
    final escapeCharacter = expression.escapeCharacter;
    final escape = expression.escape;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['state'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(normalCharacters);
      ruleGenerator.allocateExpressionVariable(escape);
      values['list'] = asyncGenerator.allocateVariable(
          GenericType(name: 'List', arguments: [GenericType(name: 'String')]));
      values['str'] =
          asyncGenerator.allocateVariable(GenericType(name: 'String'));
      values['r'] = variable;
      values['rv1'] = getExpressionVariableWithNullCheck(normalCharacters);
      values['rv3'] = getExpressionVariableWithNullCheck(escape);
    }

    values['p1'] = generateAsyncExpression(normalCharacters, true);
    values['p2'] = generateAsyncExpression(escapeCharacter, false);
    values['p3'] = generateAsyncExpression(escape, true);
    var initTemplate = '';
    if (variable != null) {
      initTemplate = '''
{{list}} = null;
{{str}} = null;
{{state}} = 0;''';
    } else {
      initTemplate = '''
{{state}} = 0;''';
    }

    final init = render(initTemplate, values);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (state.ok) {
      final v = {{rv1}};
      if ({{str}} == null) {
        {{str}} = v;
      } else if ({{list}} == null) {
        {{list}} = [{{str}}!, v];
      } else {
        {{list}}!.add(v);
      }
    }
    {{pos}} = state.pos;
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{state}} = 2;
  }
  if ({{state}} == 2) {
    {{p3}}
    if (!state.ok) {
      state.backtrack({{pos}}!);
      break;
    }
    if ({{str}} == null) {
      {{str}} = {{rv3}};
    } else {
      if ({{list}} == null) {
        {{list}} = [{{str}}!, {{rv3}}];
      } else {
        {{list}}!.add({{rv3}});
      }
    }
    {{state}} = 0;
  }
}
state.ok = true;
if ({{str}} == null) {
  {{r}} = '';
} else if ({{list}} == null) {
  {{r}} = {{str}}!;
} else {
  {{r}} = {{list}}!.join();
}''';
    } else {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    {{pos}} = state.pos;
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{state}} = 2;
  }
  if ({{state}} == 2) {
    {{p3}}
    if (!state.ok) {
      state.backtrack({{pos}}!);
      break;
    }
    {{state}} = 0;
  }
}
state.ok = true;''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      init: init,
    );
  }
}

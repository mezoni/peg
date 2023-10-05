import '../expressions/expressions.dart';
import 'expression_generators.dart';

class RepetitionGenerator extends ExpressionGenerator<RepetitionExpression> {
  RepetitionGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final min = expression.min;
    final max = expression.max;
    if (min != null && max != null) {
      if (min != max) {
        return _generateMinNax(min, max);
      } else {
        return _generateN(min);
      }
    } else if (min != null) {
      if (min == 0) {
        return _generateMin0();
      } else {
        return _generateMin(min);
      }
    } else {
      return _generateMax(max!);
    }
  }

  @override
  void generateAsync() {
    final max = expression.max;
    final min = expression.min;
    if (min != null && max != null) {
      if (min != max) {
        _generateAsyncMinMax(min, max);
      } else {
        _generateAsyncN(min);
      }
    } else if (min != null) {
      if (min == 0) {
        _generateAsyncMin0();
      } else {
        _generateAsyncMin(min);
      }
    } else {
      _generateAsyncMax(max!);
    }
  }

  void _generateAsyncMax(int n) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final list = variable == null ? '' : allocateName();
    final list2 = variable == null ? '' : allocateName();
    final count = variable != null ? '' : allocateName();
    final count2 = variable != null ? '' : allocateName();

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    } else {
      asyncGenerator.addVariable(count, GenericType(name: 'int'));
      asyncGenerator.writeln('$count = 0;');
    }

    final state0 = asyncGenerator.moveToNewState();
    asyncGenerator.loopLevel++;

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, true);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    asyncGenerator.loopLevel--;
    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['n'] = '$n';
      values['list2'] = list2;
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
final {{list2}} = {{list}}!;
{{list2}}.add({{rv}});
{{state}} = {{list2}}.length < {{n}} ? {{state0}} : {{state1}};
break;''';
      } else {
        values['count'] = count;
        values['count2'] = count2;
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
var {{count2}} = {{count}}!;
{{count2}}++;
{{count}} = {{count2}};
{{state}} = {{count2}} < {{n}} ? {{state0}} : {{state1}};
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
state.ok = true;
{{r}} = {{list}};
{{list}} = null;''';
      } else {
        values['count'] = count;
        template = '''
state.ok = true;''';
      }

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncMin(int m) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final pos = allocateName();
    final list = variable == null ? '' : allocateName();
    final list2 = variable == null ? '' : allocateName();
    final count = variable != null ? '' : allocateName();
    final count2 = variable != null ? '' : allocateName();

    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = 0;');

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    } else {
      asyncGenerator.addVariable(count, GenericType(name: 'int'));
      asyncGenerator.writeln('$count = 0;');
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    final state0 = asyncGenerator.moveToNewState();

    asyncGenerator.loopLevel++;

    {
      final values = <String, String>{};
      values['m'] = '$m';
      var template = '';
      if (variable != null) {
        values['list'] = list;
        template = '''
if ({{list}}!.length >= {{m}}) {
  state.input.beginBuffering();
}''';
      } else {
        values['count'] = count;
        template = '''
if ({{count}}! >= {{m}}) {
  state.input.beginBuffering();
}''';
      }

      asyncGenerator.render(template, values);
    }

    generateAsyncExpression(child, true);

    asyncGenerator.loopLevel--;
    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['m'] = '$m';
      values['pos'] = pos;
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['list2'] = list2;
        values['rv'] = getExpressionVariableWithNullCheck(child);
        template = '''
if (!state.ok) {
  state.input.endBuffering({{pos}}!);
  {{state}} = {{state1}};
  break;
}
final {{list2}} = {{list}}!;
{{list2}}.add({{rv}});
if ({{list2}}.length >= {{m}}) {
  state.input.endBuffering(state.pos);
}
{{state}} = {{state0}};
break;''';
      } else {
        values['count'] = count;
        values['count2'] = count2;
        template = '''
if (!state.ok) {
  state.input.endBuffering({{pos}}!);
  {{state}} = {{state1}};
  break;
}
var {{count2}} = {{count}}!;
{{count2}}++;
{{count}} = {{count2}};
if ({{count2}} >= {{m}}) {
  state.input.endBuffering(state.pos);
}
{{state}} = {{state0}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);

    {
      final values = <String, String>{};
      values['m'] = '$m';
      values['pos'] = pos;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['r'] = variable;
        template = '''
state.ok = {{list}}!.length >= {{m}};
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.pos = {{pos}}!;
}''';
      } else {
        values['count'] = count;
        template = '''
state.ok = {{count}}! >= {{m}};
if (!state.ok) {
  state.pos = {{pos}}!;
}''';
      }

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncMin0() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final list = variable == null ? '' : allocateName();

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    }

    final state0 = asyncGenerator.moveToNewState();
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
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
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
state.ok = true;
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
}''';
      } else {
        template = '''
state.ok = true;''';
      }

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncMinMax(int m, int n) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final pos = allocateName();
    final list = variable == null ? '' : allocateName();
    final list2 = variable == null ? '' : allocateName();
    final count = variable != null ? '' : allocateName();
    final count2 = variable != null ? '' : allocateName();

    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = 0;');

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    } else {
      asyncGenerator.addVariable(count, GenericType(name: 'int'));
      asyncGenerator.writeln('$count = 0;');
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    final state0 = asyncGenerator.moveToNewState();
    asyncGenerator.loopLevel++;

    {
      final values = <String, String>{};
      values['m'] = '$m';
      var template = '';
      if (variable != null) {
        values['list'] = list;
        template = '''
if ({{list}}!.length >= {{m}}) {
  state.input.beginBuffering();
}''';
      } else {
        values['count'] = count;
        template = '''
if ({{count}}! >= {{m}}) {
  state.input.beginBuffering();
}''';
      }

      asyncGenerator.render(template, values);
    }

    generateAsyncExpression(child, true);

    asyncGenerator.loopLevel--;

    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['m'] = '$m';
      values['n'] = '$n';
      values['pos'] = pos;
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['list2'] = list2;
        values['rv'] = getExpressionVariableWithNullCheck(child);
        template = '''
if (!state.ok) {
  state.input.endBuffering({{pos}}!);
  {{state}} = {{state1}};
  break;
}
final {{list2}} = {{list}}!;
{{list2}}.add({{rv}});
if ({{list2}}.length >= {{m}}) {
  state.input.endBuffering(state.pos);
}
{{state}} = {{list2}}.length < {{n}} ? {{state0}} : {{state1}};
break;''';
      } else {
        values['count'] = count;
        values['count2'] = count2;
        template = '''
if (!state.ok) {
  state.input.endBuffering({{pos}}!);
  {{state}} = {{state1}};
  break;
}
var {{count2}} = {{count}}!;
{{count2}}++;
{{count}} = {{count2}};
if ({{count2}} >= {{m}}) {
  state.input.endBuffering(state.pos);
}
{{state}} = {{count2}} < {{n}} ? {{state0}} : {{state1}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);

    {
      final values = <String, String>{};
      values['m'] = '$m';
      values['pos'] = pos;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['r'] = variable;
        template = '''
state.ok = {{list}}!.length >= {{m}};
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.pos = {{pos}}!;
}''';
      } else {
        values['count'] = count;
        template = '''
state.ok = {{count}}! >= {{m}};
if (!state.ok) {
  state.pos = {{pos}}!;
}''';
      }

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncN(int n) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final pos = allocateName();
    final list = variable == null ? '' : allocateName();
    final list2 = variable == null ? '' : allocateName();
    final count = variable != null ? '' : allocateName();
    final count2 = variable != null ? '' : allocateName();

    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = 0;');

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    } else {
      asyncGenerator.addVariable(count, GenericType(name: 'int'));
      asyncGenerator.writeln('$count = 0;');
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    final state0 = asyncGenerator.moveToNewState();
    asyncGenerator.loopLevel++;

    generateAsyncExpression(child, true);

    asyncGenerator.loopLevel--;
    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['n'] = '$n';
      values['list2'] = list2;
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
final {{list2}} = {{list}}!;
{{list2}}.add({{rv}});
{{state}} = {{list2}}.length < {{n}} ? {{state0}} : {{state1}};
break;''';
      } else {
        values['count'] = count;
        values['count2'] = count2;
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
var {{count2}} = {{count}}!;
{{count2}}++;
{{count}} = {{count2}};
{{state}} = {{count2}} < {{n}} ? {{state0}} : {{state1}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);

    {
      final values = <String, String>{};
      values['n'] = '$n';
      values['pos'] = pos;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['r'] = variable;
        template = '''
state.ok = {{list}}!.length == {{n}};
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.pos = {{pos}}!;
}
state.input.endBuffering(state.pos);''';
      } else {
        values['count'] = count;
        template = '''
state.ok = {{count}}! == {{n}};
if (!state.ok) {
  state.pos = {{pos}}!;
}
state.input.endBuffering(state.pos);''';
      }

      asyncGenerator.render(template, values);
    }
  }

  String _generateMax(int n) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['n'] = '$n';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
while ({{list}}.length < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ok = true;
if (state.ok) {
 {{r}} = {{list}};
}''';
    } else {
      values['count'] = allocateName();
      template = '''
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = true;''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMin(int m) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    values['m'] = '$m';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ok = {{list}}.length >= {{m}};
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.pos = {{pos}};
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (!state.ok) {
  state.pos = {{pos}};
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMin0() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ok = true;
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.pos = {{pos}};
}''';
    } else {
      template = '''
final {{pos}} = state.pos;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = true;
if (!state.ok) {
  state.pos = {{pos}};
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMinNax(int m, int n) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    values['m'] = '$m';
    values['n'] = '$n';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while ({{list}}.length < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ok = {{list}}.length >= {{m}};
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.pos = {{pos}};
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} >= {{m}};
if (!state.ok) {
  state.pos = {{pos}};
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateN(int n) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    values['n'] = '$n';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while ({{list}}.length < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ok = {{list}}.length == {{n}};
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.pos = {{pos}};
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} == {{n}};
if (!state.ok) {
  state.pos = {{pos}};
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }
}

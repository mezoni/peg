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
  String generateAsync() {
    final max = expression.max;
    final min = expression.min;
    if (min != null && max != null) {
      if (min != max) {
        return _generateAsyncMinMax(min, max);
      } else {
        return _generateAsyncN(min);
      }
    } else if (min != null) {
      if (min == 0) {
        return _generateAsyncMin0();
      } else {
        return _generateAsyncMin(min);
      }
    } else {
      return _generateAsyncMax(max!);
    }
  }

  String _generateAsyncMax(int n) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    ({String name, String value})? key;
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(expression.resultType!);
      values['list_'] = allocateName();
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
      values['rv'] = getExpressionVariableWithNullCheck(child);
      key = (name: values['list']!, value: '[]');
    } else {
      values['count'] =
          asyncGenerator.allocateVariable(GenericType(name: 'int'));
      values['count_'] = allocateName();
      key = (name: values['count']!, value: '0');
    }

    values['n'] = '$n';
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
  final {{list_}} = {{list}}!;
  {{list_}}.add({{rv}});
  {{r1}} = null;
  if ({{list_}}.length == {{n}}) {
    break;
  }
}
state.setOk(true);
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
  final {{count_}} = {{count}}! + 1;
  {{count}} = {{count_}};
  if ({{count_}} == {{n}}) {
    break;
  }
}
state.setOk(true);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
  }

  String _generateAsyncMin(int m) {
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
      values['count'] =
          asyncGenerator.allocateVariable(GenericType(name: 'int'));
      key = (name: values['count']!, value: '0');
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    const initTemplate = '''
{{pos}} = state.pos;''';
    final init = render(initTemplate, values);
    values['m'] = '$m';
    values['p'] = generateAsyncExpression(child, true);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}!.add({{rv}});
  {{r1}} = null;
}
state.setOk({{list}}!.length >= {{m}});
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.backtrack({{pos}}!);
}''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}} = {{count}}! + 1;
}
state.setOk({{count}}! >= {{m}});
if (!state.ok) {
  state.backtrack({{pos}}!);
}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
      init: init,
    );
  }

  String _generateAsyncMin0() {
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
state.setOk(true);
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
}
state.setOk(true);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
  }

  String _generateAsyncMinMax(int m, int n) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    ({String name, String value})? key;
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(expression.resultType!);
      values['list_'] = allocateName();
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
      values['rv'] = getExpressionVariableWithNullCheck(child);
      key = (name: values['list']!, value: '[]');
    } else {
      values['count'] =
          asyncGenerator.allocateVariable(GenericType(name: 'int'));
      values['count_'] = allocateName();
      key = (name: values['count']!, value: '0');
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    const initTemplate = '''
{{pos}} = state.pos;''';
    final init = render(initTemplate, values);
    values['m'] = '$m';
    values['n'] = '$n';
    values['p'] = generateAsyncExpression(child, true);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  final {{list_}} = {{list}}!;
  {{list_}}.add({{rv}});
  {{r1}} = null;
  if ({{list_}}.length == {{n}}) {
    break;
  }
}
state.setOk({{list}}!.length >= {{m}});
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.backtrack({{pos}}!);
}''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  var {{count_}} = {{count}}!;
  {{count_}}++;
  {{count}} = {{count_}};
  if ({{count_}} == {{n}}) {
    break;
  }
}
state.setOk({{count}}! >= {{m}});
if (!state.ok) {
  state.backtrack({{pos}}!);
}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
      init: init,
    );
  }

  String _generateAsyncN(int n) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    ({String name, String value})? key;
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(expression.resultType!);
      values['list_'] = allocateName();
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
      values['rv'] = getExpressionVariableWithNullCheck(child);
      key = (name: values['list']!, value: '[]');
    } else {
      values['count'] =
          asyncGenerator.allocateVariable(GenericType(name: 'int'));
      values['count_'] = allocateName();
      key = (name: values['count']!, value: '0');
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    const initTemplate = '''
{{pos}} = state.pos;''';
    final init = render(initTemplate, values);
    values['n'] = '$n';
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
  final {{list_}} = {{list}}!;
  {{list_}}.add({{rv}});
  {{r1}} = null;
  if ({{list_}}.length == {{n}}) {
    break;
  }
}
state.setOk({{list}}!.length == {{n}});
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
} else {
  state.backtrack({{pos}}!);
}''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  final {{count_}} = {{count}}! + 1;
  {{count}} = {{count_}};
  if ({{count_}} == {{n}}) {
    break;
  }
}
state.setOk({{count}}!  == {{n}});
if (!state.ok) {
  state.backtrack({{pos}}!);
}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
      init: init,
    );
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
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
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
state.setOk(true);
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
state.setOk(true);''';
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
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
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
state.setOk({{list}}.length >= {{m}});
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
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
state.setOk({{count}} >= {{m}});
if (!state.ok) {
  state.backtrack({{pos}});
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
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
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
state.setOk(true);
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
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
state.setOk(true);
if (!state.ok) {
  state.backtrack({{pos}});
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
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
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
state.setOk({{list}}.length >= {{m}});
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
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
state.setOk({{count}} >= {{m}});
if (!state.ok) {
  state.backtrack({{pos}});
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
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
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
state.setOk({{list}}.length == {{n}});
if (state.ok) {
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
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
state.setOk({{count}} == {{n}});
if (!state.ok) {
  state.backtrack({{pos}});
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }
}

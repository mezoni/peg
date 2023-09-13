import '../expressions/expressions.dart';
import 'expression_generators.dart';

class RepetitionGenerator extends ExpressionGenerator<RepetitionExpression> {
  static const _templateOneOrMore = '''
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

  static const _templateOneOrMoreNoResult = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.ok = {{ok}};''';

  static const _templateRepetition = '''
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

  static const _templateRepetitionNoResult = '''
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

  static const _templateRepetitionRange = '''
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

  static const _templateRepetitionRangeNoResult = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ok = {{count}} >= {{n}};
if (!state.ok) {
  state.pos = {{pos}};
}''';

  static const _templateZeroOrMore = '''
final {{list}} = <{{O}}>[];
while (true) {
  {{p}}
  if (!state.ok) {
    state.ok = true;
    {{r}} = {{list}};
    break;
  }
  {{list}}.add({{rv}});
}''';

  static const _templateZeroOrMoreNoResult = '''
while (true) {
  {{p}}
  if (!state.ok) {
    state.ok = true;
    break;
  }
}''';

  RepetitionGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final min = expression.min;
    final max = expression.max;
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      if (min == 0 && max == null) {
        template = _templateZeroOrMore;
      } else if (min == 1 && max == null) {
        template = _templateOneOrMore;
      } else if (min != null && min == max) {
        values['pos'] = allocateName();
        values['n'] = '$min';
        template = _templateRepetition;
      } else {
        values['pos'] = allocateName();
        values['m'] = '$min';
        values['n'] = '$max';
        template = _templateRepetitionRange;
      }
    } else {
      values['count'] = allocateName();
      if (min == 0 && max == null) {
        template = _templateZeroOrMoreNoResult;
      } else if (min == 1 && max == null) {
        values['ok'] = allocateName();
        template = _templateOneOrMoreNoResult;
      } else if (min != null && min == max) {
        values['pos'] = allocateName();
        values['count'] = allocateName();
        template = _templateRepetitionNoResult;
        values['n'] = '$min';
      } else {
        values['pos'] = allocateName();
        values['count'] = allocateName();
        values['m'] = '$min';
        values['n'] = '$max';
        template = _templateRepetitionRangeNoResult;
      }
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }
}

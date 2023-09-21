import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OneOrMoreGenerator extends ExpressionGenerator<OneOrMoreExpression> {
  static const _template = '''
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

  static const _templateNoResult = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.ok = {{ok}};''';

  // ignore: unused_field
  static const _templateAsync = '''
final result = AsyncResult<List<{{O}}>>();
final input = state.input;
final list = <{{O}}>[];
late AsyncResult<{{O}}> r;
var s = 0;
void parse() {
  while (true) {
    switch (s) {
      case 0:
        s = 1;
        r = {{p}}(state);
        if (r.hasValue) {
          break;
        }
        r.handle = parse;
        break;
      case 1:
        if (!state.ok) {
          s = -1;
          if (list.isNotEmpty) {
            state.ok = true;
            result.value = list;
          }
          return;
        }
        final value = result.{{value}};
        list.add(value);
        s = 0;
        break;
      default:
        throw StateError('Invalid state: \$s');
    }
  }
}

parse();
return result;''';

// ignore: unused_field
  static const _templateAsyncNoResult = '''
final result = AsyncResult<void>();
final input = state.input;
final ok = false;
late AsyncResult<void> r;
var s = 0;
void parse() {
  while (true) {
    switch (s) {
      case 0:
        s = 1;
        r = {{p}}(state);
        if (r.isComplete) {
          break;
        }
        r.handle = parse;
        break;
      case 1:
        if (!state.ok) {
          s = -1;
          result.isComplete = true;
          state.ok = ok;
          return;
        }
        ok = true;
        s = 0;
        break;
      default:
        throw StateError('Invalid state: \$s');
    }
  }
}

parse();
return result;''';

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
      template = _template;
    } else {
      values['ok'] = allocateName();
      template = _templateNoResult;
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }
}

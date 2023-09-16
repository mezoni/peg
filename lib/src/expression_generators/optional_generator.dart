import '../expressions/expressions.dart';
import 'expression_generator.dart';

class OptionalGenerator extends ExpressionGenerator<OptionalExpression> {
  static const _template = '''
{{p}}
state.ok = true;''';

  // ignore: unused_field
  static const _templateAsync = '''
final result = AsyncResult<{{O}}?>();
final input = state.input;
final r = {{p}}(state);
void parse() {
  if (state.ok) {
    result.value = r.value;
  } else {
    state.ok = true;
    result.value = const Result(null);
  }
}

if (r.result != null) {
  parse();
} else {
  r.handle = parse;
}
return result;''';

  OptionalGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

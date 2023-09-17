import '../expressions/expression.dart';
import 'expression_generator.dart';

class VerifyGenerator extends ExpressionGenerator<VerifyExpression> {
  static const _template =
      r'''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  // ignore: unused_local_variable
  final pos = {{pos}};
  // ignore: unused_local_variable
  final $$ = {{r}};
  {{handler}}
}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  VerifyGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    } else {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['pos'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, variable == null);
    if (variable != null) {
      values['r'] = variable;
    } else {
      values['r'] = ruleGenerator.getExpressionVariable(child)!;
    }

    return render(_template, values);
  }
}

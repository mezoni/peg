import '../expressions/expression.dart';
import 'expression_generator.dart';

class VerifyGenerator extends ExpressionGenerator<VerifyExpression> {
  static const _template = r'''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (state.ok) {
  final pos = {{pos}};
  // ignore: unused_local_variable
  final $$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    if ({{failPos}} <= pos) {
      state.failPos = {{failPos}};
      state.errorCount = {{errorCount}};
    }
    state.failAt(pos, error);
  }
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

    values['errorCount'] = allocateName();
    values['failPos'] = allocateName();
    values['pos'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, variable == null);
    if (variable != null) {
      values['rv'] = getExpressionVariableWithNullCheck(expression);
    } else {
      values['rv'] = getExpressionVariableWithNullCheck(child);
    }

    return render(_template, values);
  }
}

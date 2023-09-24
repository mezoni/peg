import '../expressions/error_handler_expression.dart';
import 'expression_generator.dart';

class ErrorHandlerGenerator
    extends ExpressionGenerator<ErrorHandlerExpression> {
  static const _template = '''
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (!state.ok && state._canHandleError({{failPos}}, {{errorCount}})) {
  ParseError? error;
  // ignore: prefer_final_locals
  var rollbackErrors = false;
  {{handler}}
  if (rollbackErrors == true) {
    state._rollbackErrors({{failPos}}, {{errorCount}});
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (error == null) {
      error = const ErrorUnknownError();
    }
  }
  // ignore: unnecessary_null_comparison
  if (error != null) {
    state.failAt(state.failPos, error);
  }
}''';

  ErrorHandlerGenerator({
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

    values['failPos'] = allocateName();
    values['errorCount'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

import '../expressions/expressions.dart';
import 'expression_generator.dart';

class ErrorHandlerGenerator
    extends ExpressionGenerator<ErrorHandlerExpression> {
  ErrorHandlerGenerator({
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
    }

    values['failPos'] = allocateName();
    values['errorCount'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, false);
    const template = '''
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
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['handler'] = expression.handler.trim();
    values['errorCount'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['failPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    const initTemplate = '''
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;''';
    final init = render(initTemplate, values);
    values['p'] = generateAsyncExpression(child, false);
    const template = '''
{{p}}
if (!state.ok && state._canHandleError({{failPos}}!, {{errorCount}}!)) {
  ParseError? error;
  // ignore: prefer_final_locals
  var rollbackErrors = false;
  {{handler}}
  if (rollbackErrors == true) {
    state._rollbackErrors({{failPos}}!, {{errorCount}}!);
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
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      init: init,
    );
  }
}

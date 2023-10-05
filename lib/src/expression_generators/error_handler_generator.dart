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
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final handler = expression.handler.trim();
    final failPos = allocateName();
    final errorCount = allocateName();
    asyncGenerator.addVariable(failPos, GenericType(name: 'int'));
    asyncGenerator.addVariable(errorCount, GenericType(name: 'int'));

    {
      final values = <String, String>{};
      values['errorCount'] = errorCount;
      values['failPos'] = failPos;
      const template = '''
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;''';
      asyncGenerator.render(template, values);
    }

    generateAsyncExpression(child, false);

    {
      final values = <String, String>{};
      values['errorCount'] = errorCount;
      values['failPos'] = failPos;
      values['handler'] = handler;
      const template = '''
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

      asyncGenerator.render(template, values);
    }
  }
}

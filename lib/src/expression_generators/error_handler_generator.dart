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

    values['pos'] = allocateName();
    values['failPos'] = allocateName();
    values['errorCount'] = allocateName();
    values['lastFailPos'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
final {{lastFailPos}} = state.lastFailPos;
state.lastFailPos = -1;
{{p}}
if (!state.ok && state.lastFailPos >= state.failPos) {
  // ignore: unused_local_variable
  final start = {{pos}};
  ParseError? error;
  // ignore: prefer_final_locals
  var rollbackErrors = false;
  {{handler}}
  if (rollbackErrors == true) {
    state.errorCount = state.lastFailPos > {{failPos}} ? 0 : {{errorCount}};
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (error == null) {
      error = const ErrorUnknownError();
    }
  }
  // ignore: unnecessary_null_comparison
  if (error != null) {
    state.failAt(state.failPos, error);
  }
}
if (state.lastFailPos < {{lastFailPos}}) {
  state.lastFailPos = {{lastFailPos}};
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

    final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['handler'] = expression.handler.trim();
    values['pos'] = pos;
    values['failPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['errorCount'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['lastFailPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    final key = (name: pos, value: 'state.pos');
    const initTemplate = '''
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;
{{lastFailPos}} = state.lastFailPos;
state.lastFailPos = -1;''';
    final init = render(initTemplate, values);
    values['p'] = generateAsyncExpression(child, false);
    const template = '''
{{p}}
if (!state.ok && state.lastFailPos >= state.failPos) {
  // ignore: unused_local_variable
  final start = {{pos}}!;
  ParseError? error;
  // ignore: prefer_final_locals
  var rollbackErrors = false;
  {{handler}}
  if (rollbackErrors == true) {
    state.errorCount = state.lastFailPos > {{failPos}}! ? 0 : {{errorCount}}!;
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (error == null) {
      error = const ErrorUnknownError();
    }
  }
  // ignore: unnecessary_null_comparison
  if (error != null) {
    state.failAt(state.failPos, error);
  }
}
if (state.lastFailPos < {{lastFailPos}}!) {
  state.lastFailPos = {{lastFailPos}}!;
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
      init: init,
    );
  }
}

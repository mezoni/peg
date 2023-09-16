import '../expressions/error_handler_expression.dart';
import 'expression_generator.dart';

class ErrorHandlerGenerator
    extends ExpressionGenerator<ErrorHandlerExpression> {
  static const _template = '''
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (!state.ok && state._canHandleError({{failPos}}, {{errorCount}})) {
  void replaceLastErrors(List<ParseError> errors) {
    state._replaceLastErrors({{failPos}}, {{errorCount}}, errors);
  }
  {{handler}}
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
    values['handler'] = expression.handler;
    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

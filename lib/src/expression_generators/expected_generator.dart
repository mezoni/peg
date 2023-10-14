import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class ExpectedGenerator extends ExpressionGenerator<ExpectedExpression> {
  ExpectedGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final tag = expression.tag;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['pos'] = allocateName();
    values['failPos'] = allocateName();
    values['errorCount'] = allocateName();
    values['tag'] = helper.escapeString(tag);
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (!state.ok && state.canHandleError({{failPos}}, {{errorCount}})) {
  if (state.failPos == {{pos}}) {
    state.rollbackErrors({{failPos}}, {{errorCount}});
    state.fail(const ErrorExpectedTags([{{tag}}]));
  }
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final tag = expression.tag;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['failPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['errorCount'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['tag'] = helper.escapeString(tag);
    const initTemplate = '''
{{pos}} = state.pos;
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;''';
    final init = render(initTemplate, values);
    values['p'] = generateAsyncExpression(child, false);
    const template = '''
{{p}}
if (!state.ok && state.canHandleError({{failPos}}!, {{errorCount}}!)) {
  if (state.failPos == {{pos}}!) {
    state.rollbackErrors({{failPos}}!, {{errorCount}}!);
    state.fail(const ErrorExpectedTags([{{tag}}]));
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

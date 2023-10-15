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
    values['lastFailPos'] = allocateName();
    values['errorCount'] = allocateName();
    values['tag'] = helper.escapeString(tag);
    values['p'] = generateExpression(child, false);
    values['lastFailPos'] = allocateName();
    const template = '''
final {{pos}} = state.pos;
final {{lastFailPos}} = state.lastFailPos;
final {{errorCount}} = state.errorCount;
state.lastFailPos = -1;
{{p}}
if (!state.ok && state.lastFailPos >= state.failPos &&
  state.lastFailPos == {{pos}}) {
  state.errorCount = {{errorCount}};
  state.fail(const ErrorExpectedTags([{{tag}}]));
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
    final tag = expression.tag;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['pos'] = pos;
    values['lastFailPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['errorCount'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['tag'] = helper.escapeString(tag);
    final key = (name: pos, value: 'state.pos');
    const initTemplate = '''
{{lastFailPos}} = state.lastFailPos;
{{errorCount}} = state.errorCount;
state.lastFailPos = -1;''';
    final init = render(initTemplate, values);
    values['p'] = generateAsyncExpression(child, false);
    const template = '''
{{p}}
if (!state.ok && state.lastFailPos >= state.failPos &&
  state.lastFailPos == {{pos}}!) {
  state.errorCount = {{errorCount}}!;
  state.fail(const ErrorExpectedTags([{{tag}}]));
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

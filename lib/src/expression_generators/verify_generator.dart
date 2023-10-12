import '../expressions/expressions.dart';
import 'expression_generator.dart';

class VerifyGenerator extends ExpressionGenerator<VerifyExpression> {
  VerifyGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
      values['clear_result'] = '';
    } else {
      ruleGenerator.allocateExpressionVariable(child);
      values['clear_result'] = '';
    }

    values['errorCount'] = allocateName();
    values['failPos'] = allocateName();
    values['pos'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, variable == null);
    values['rv'] = getExpressionVariableWithNullCheck(child);
    const template = '''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (state.ok) {
  final pos = {{pos}};
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
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
  {{clear_result}}
  state.backtrack({{pos}});
}''';

    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
      values['clear_result'] = '$variable = null;';
    } else {
      ruleGenerator.allocateExpressionVariable(child);
      values['clear_result'] = '';
    }

    values['handler'] = expression.handler.trim();
    values['pos'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['failPos'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['errorCount'] =
        asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['rv'] = getExpressionVariableWithNullCheck(child);
    const initTemplate = '''
{{pos}} = state.pos;
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;''';
    final init = render(initTemplate, values);
    asyncGenerator.buffering++;
    values['p'] = generateAsyncExpression(child, variable == null);
    asyncGenerator.buffering--;
    const template = '''
{{p}}
if (state.ok) {
  final pos = {{pos}}!;
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    if ({{failPos}}! <= pos) {
      state.failPos = {{failPos}}!;
      state.errorCount = {{errorCount}}!;
    }
    state.failAt(pos, error);
  }
}
if (!state.ok) {
  {{clear_result}}
  state.backtrack({{pos}}!);
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
      init: init,
    );
  }
}

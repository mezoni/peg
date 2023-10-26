import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
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
      values['clear_result'] = '$variable = null;';
    } else {
      ruleGenerator.allocateExpressionVariable(child);
      values['clear_result'] = '';
    }

    values['ok'] = allocateName();
    values['pos'] = allocateName();
    values['message'] = helper.escapeString(expression.message);
    values['predicate'] = expression.predicate.trim();
    values['p'] = generateExpression(child, variable == null);
    values['rv'] = getExpressionVariableWithNullCheck(child);
    const template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  final {{ok}} = (() => {{predicate}})();
  if (!{{ok}}) {
    state.fail(ErrorMessage({{pos}} - state.pos, {{message}}));
    {{clear_result}}
    state.backtrack({{pos}});
  }
}''';

    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    var clearResult = '';
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
      clearResult = '$variable = null;';
    } else {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final ok = allocateName();
    final message = helper.escapeString(expression.message);
    final predicate = expression.predicate.trim();
    final rv = getExpressionVariableWithNullCheck(child);
    block << '$pos = state.pos;';
    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, variable == null);
    asyncGenerator.endBuffering(block);
    block.if_('state.ok', (block) {
      block << ' // ignore: unused_local_variable';
      block << 'final \$\$ = $rv;';
      block << 'final $ok = (() => $predicate)();';
      block.if_('!$ok', (block) {
        block << 'state.fail(ErrorMessage($pos - state.pos, $message));';
        block << clearResult;
        block << 'state.backtrack($pos);';
      });
    });
  }
}

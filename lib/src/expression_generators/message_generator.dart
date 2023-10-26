import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class MessageGenerator extends ExpressionGenerator<MessageExpression> {
  MessageGenerator({
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

    values['errorCount'] = allocateName();
    values['failPos'] = allocateName();
    values['lastFailPos'] = allocateName();
    values['message'] = helper.escapeString(expression.message);
    values['p'] = generateExpression(child, false);
    const template = '''
final {{errorCount}} = state.errorCount;
final {{failPos}} = state.failPos;
final {{lastFailPos}} = state.lastFailPos;
state.lastFailPos = -1;
{{p}}
if (!state.ok) {
  if (state.lastFailPos == {{failPos}}) {
    state.errorCount = {{errorCount}};
  } else if (state.lastFailPos > {{failPos}}) {
    state.errorCount = 0;
  }
  state.failAt(state.lastFailPos, ErrorMessage(0, {{message}}));
}
if (state.lastFailPos < {{lastFailPos}}) {
  state.lastFailPos = {{lastFailPos}};
}''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final errorCount = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final failPos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final lastFailPos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final message = helper.escapeString(expression.message);
    block << '$errorCount = state.errorCount;';
    block << '$failPos = state.failPos;';
    block << '$lastFailPos = state.lastFailPos;';
    block << 'state.lastFailPos = -1;';
    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, false);
    asyncGenerator.endBuffering(block);
    block.if_('!state.ok', (block) {
      block.if_('state.lastFailPos == $failPos', (block) {
        block << 'state.errorCount = $errorCount;';
      }).else_((block) {
        block.if_('state.lastFailPos > $failPos', (block) {
          block << 'state.errorCount = 0;';
        });
      });
      block << 'state.failAt(state.lastFailPos, ErrorMessage(0, $message));';
    });
    block.if_('state.lastFailPos < $lastFailPos', (block) {
      block << 'state.lastFailPos = $lastFailPos;';
    });
  }
}

import '../async_generators/action_node.dart';
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
    values['errorCount'] = allocateName();
    values['failPos'] = allocateName();
    values['lastFailPos'] = allocateName();
    values['tag'] = helper.escapeString(tag);
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
final {{errorCount}} = state.errorCount;
final {{failPos}} = state.failPos;
final {{lastFailPos}} = state.lastFailPos;
state.lastFailPos = -1;
{{p}}
if (!state.ok && state.lastFailPos == {{pos}}) {
  if (state.lastFailPos == {{failPos}}) {
    state.errorCount = {{errorCount}};
  } else if (state.lastFailPos > {{failPos}}) {
    state.errorCount = 0;
  }
  state.fail(const ErrorExpectedTags([{{tag}}]));
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
    final tag = expression.tag;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final errorCount = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final failPos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final lastFailPos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    final escapedTag = helper.escapeString(tag);
    block << '$pos = state.pos;';
    block << '$errorCount = state.errorCount;';
    block << '$failPos = state.failPos;';
    block << '$lastFailPos = state.lastFailPos;';
    block << 'state.lastFailPos = -1;';
    generateAsyncExpression(block, child, false);
    block.if_('!state.ok && state.lastFailPos == $pos', (block) {
      block.if_('state.lastFailPos == $failPos', (block) {
        block << 'state.errorCount = $errorCount;';
      }).else_((block) {
        block.if_('state.lastFailPos > $failPos', (block) {
          block << 'state.errorCount = 0;';
        });
      });
      block << 'state.fail(const ErrorExpectedTags([$escapedTag]));';
    });
    block.if_('state.lastFailPos < $lastFailPos', (block) {
      block << 'state.lastFailPos = $lastFailPos;';
    });
  }
}

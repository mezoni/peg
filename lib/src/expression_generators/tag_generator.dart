import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class TagGenerator extends ExpressionGenerator<TagExpression> {
  TagGenerator({
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
    values['ignore_errors'] = allocateName();
    values['tag'] = helper.escapeString(tag);
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
{{p}}
state.ignoreErrors = {{ignore_errors}};
if (!state.ok) {
  state.failAt({{pos}}, const ErrorExpectedTags([{{tag}}]));
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
    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    final escapedTag = helper.escapeString(tag);
    block << '$pos = state.pos;';
    block << '$ignoreErrors = state.ignoreErrors;';
    block << 'state.ignoreErrors = true;';
    generateAsyncExpression(block, child, false);
    block << 'state.ignoreErrors = $ignoreErrors;';
    block.if_('!state.ok', (block) {
      block << 'state.failAt($pos, const ErrorExpectedTags([$escapedTag]));';
    });
  }
}

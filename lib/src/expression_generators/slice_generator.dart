import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SliceGenerator extends ExpressionGenerator<SliceExpression> {
  SliceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  {{r}} = state.input.substring({{pos}}, state.pos);
}''';
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    var pos = '';
    if (variable != null) {
      pos = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block << '$pos = state.pos;';
    }

    asyncGenerator.beginBuffering(block);
    generateAsyncExpression(block, child, false);
    asyncGenerator.endBuffering(block);
    if (variable != null) {
      block.if_('state.ok', (block) {
        block << 'final input = state.input;';
        block << 'final start = input.start;';
        block <<
            '$variable = input.data.substring($pos - start, state.pos - start);';
      });
    }
  }
}

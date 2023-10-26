import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class CutGenerator extends ExpressionGenerator<CutExpression> {
  CutGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    const template = '''
 state.setOk(true);''';
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    block << 'state.setOk(true);';
    block << 'state.input.cut(state.pos);';
  }
}

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
 state.cut(state.pos);''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};

    final asyncGenerator = ruleGenerator.asyncGenerator;
    const template = '''
 state.cut(state.pos);
 state.input.cut(state.pos);''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }
}

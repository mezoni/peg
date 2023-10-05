import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SliceGenerator extends ExpressionGenerator<SliceExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  {{r}} = state.input.substring({{pos}}, state.pos);
}''';

  SliceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final pos = variable == null ? '' : allocateName();
    if (variable != null) {
      asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    }

    if (variable != null) {
      asyncGenerator.writeln('$pos = state.pos;');
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, false);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    if (variable != null) {
      final values = <String, String>{};
      values['pos'] = pos;
      values['r'] = variable;
      const template = '''
 if (state.ok) {
  final input = state.input;
  final start = input.start;
  {{r}} = input.data.substring({{pos}}! - start, state.pos - start);
}''';
      asyncGenerator.render(template, values);
    }
  }
}

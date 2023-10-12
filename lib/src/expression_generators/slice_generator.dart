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
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
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
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    var pos = '';

    if (variable != null) {
      pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
      values['r'] = variable;
      values['pos'] = pos;
    }

    String? init;
    if (variable != null) {
      init = '$pos = state.pos;';
    }

    asyncGenerator.buffering++;
    values['p'] = generateAsyncExpression(child, false);
    asyncGenerator.buffering--;
    var template = '';
    if (variable != null) {
      template = '''
{{p}}
if (state.ok) {
  final input = state.input;
  final start = input.start;
  final pos = {{pos}}!;
  {{r}} = input.data.substring(pos - start, state.pos - start);
}''';
    } else {
      template = '''
{{p}}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
      init: init,
    );
  }
}

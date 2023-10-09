import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AndPredicateGenerator
    extends ExpressionGenerator<AndPredicateExpression> {
  AndPredicateGenerator({
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
    }

    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  state.pos = {{pos}};
}''';
    return render(template, values);
  }

  @override
  String generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final values = <String, String>{};
    final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    final init = '$pos = state.pos;';
    values['pos'] = pos;
    asyncGenerator.buffering++;
    values['p'] = generateAsyncExpression(child, false);
    asyncGenerator.buffering--;
    const template = '''
{{p}}
if (state.ok) {
  state.pos = {{pos}}!;
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
      init: init,
    );
  }
}

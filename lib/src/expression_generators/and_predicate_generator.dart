import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AndPredicateGenerator
    extends ExpressionGenerator<AndPredicateExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  state.pos = {{pos}};
}''';

  AndPredicateGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

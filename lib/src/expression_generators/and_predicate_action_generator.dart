import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AndPredicateActionGenerator
    extends ExpressionGenerator<AndPredicateActionExpression> {
  static const _template = '''
final {{pos}} = state.pos;
state.ok = true;
if (state.ok) {
  state.ok = {{action}};
  state.pos = {{pos}};
}''';

  AndPredicateActionGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final action = expression.action;
    values['pos'] = allocateName();
    values['action'] = action;
    return render(_template, values);
  }
}

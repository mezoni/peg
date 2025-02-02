import '../grammar/production_rule.dart';
import 'expression.dart';

class NonterminalExpression extends Expression {
  final String name;

  ProductionRule? reference;

  NonterminalExpression({
    required this.name,
    this.reference,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitNonterminal(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = {
      'name': 'parse$name',
    };

    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      template = '''
{{declare}}{{variable}} = {{name}}(state);''';
    } else {
      template = '''
{{name}}(state);''';
    }

    return render(context, this, template, values);
  }
}

import 'expression.dart';

class AnyCharacterExpression extends Expression {
  AnyCharacterExpression();

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = <String, String>{};
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
{{declare}}{{variable}} = state.matchAny();''';
    } else {
      template = '''
state.matchAny();''';
    }
    return render(context, this, template, values);
  }
}

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
      values['variable'] = variable;
      template = '''
if (state.isSuccess = state.position < state.input.length) {
  {{variable}} = state.input.readChar(state.position);
  state.position += {{variable}} > 0xffff ? 2 : 1;
} else {
  state.fail();
}''';
    } else {
      template = '''
if (state.isSuccess = state.position < state.input.length) {
  final c = state.input.readChar(state.position);
  state.position += c > 0xffff ? 2 : 1;
} else {
  state.fail();
}''';
    }
    return render(context, this, template, values);
  }
}

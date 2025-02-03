import 'expression.dart';

class AnyCharacterExpression extends Expression {
  AnyCharacterExpression();

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final template = assignResult(context, 'state.matchAny()');
    return render(context, this, template, const {});
  }
}

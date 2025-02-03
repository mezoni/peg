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
    final template = assignResult(context, 'parse$name(state)');
    return render(context, this, template, const {});
  }
}

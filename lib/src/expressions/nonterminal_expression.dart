import '../grammar/production_rule.dart';
import '../helper.dart';
import 'build_context.dart';

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
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final value = 'parse$name(state)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }
}

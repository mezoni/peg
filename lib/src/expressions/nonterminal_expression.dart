import '../grammar/production_rule.dart';
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
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final invocation = 'parse$name(state)';
    final code = result.code;
    if (result.isUsed) {
      final variable = context.allocate();
      code.assign(variable, invocation, 'final');
      code.branch('$variable != null', '$variable == null');
      result.value = Value('$variable.\$1', boxed: variable);
    } else {
      final expression = reference!.expression;
      if (!expression.isAlwaysSuccessful) {
        final variable = context.allocate();
        code.assign(variable, invocation, 'final');
        code.branch('$variable != null', '$variable == null');
      } else {
        code.statement(invocation);
        code.branch('true', 'false');
      }
    }

    result.postprocess(this);
  }
}

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
      if (!isAlwaysSuccessful) {
        code.assign(variable, invocation, 'final');
        code.branch('$variable != null');
        result.value = Value('$variable.\$1', wrapped: variable);
      } else {
        code.assign(variable, invocation, 'final');
        code.branch('true');
        result.value = Value(variable);
      }
    } else {
      final expression = reference!.expression;
      if (!expression.isAlwaysSuccessful) {
        final variable = context.allocate();
        code.assign(variable, invocation, 'final');
        code.branch('$variable != null');
        result.allocated = variable;
      } else {
        code.statement(invocation);
        code.branch('true');
      }
    }

    result.postprocess(this);
  }
}

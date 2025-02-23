import 'build_context.dart';

class PredicateExpression extends Expression {
  final String code;

  final bool negate;

  PredicateExpression({
    required this.code,
    required this.negate,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitPredicate(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final code = result.code;
    if (!negate) {
      code.branch(this.code, '!($this.code)');
    } else {
      final variable = context.allocate();
      code.assign(variable, this.code, 'final');
      code.branch('!$variable', variable);
    }

    if (result.isUsed) {
      result.value = Value('null', isConst: true);
    }

    result.postprocess(this);
  }
}

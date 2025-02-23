import 'build_context.dart';

class MatchExpression extends SingleExpression {
  MatchExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMatch(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final position = context.getSharedValue(this, Expression.position);
    context.shareValues(this, expression, [Expression.position]);
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: false,
    );

    expression.generate(context, childResult);

    final code = result.code;
    if (result.isUsed) {
      final branch = childResult.branch();
      branch.truth.block((b) {
        final variable = context.allocate();
        final value = 'state.substring($position, state.position)';
        b.assign(variable, value, 'final');
        result.value = Value(variable);
      });
    }

    code.add(childResult.code);
    result.postprocess(this);
  }
}

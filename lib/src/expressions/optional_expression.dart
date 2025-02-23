import 'build_context.dart';

class OptionalExpression extends SingleExpression {
  OptionalExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOptional(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    context.shareValues(this, expression, [Expression.position]);
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: result.isUsed,
    );

    expression.generate(context, childResult);

    final code = result.code;
    if (result.isUsed) {
      final variable = context.allocate();
      final type = result.getIntermediateType();
      code.statement('$type $variable');
      final branch = childResult.branch();
      branch.truth.block((b) {
        final value = childResult.value;
        b.assign(variable, value.code);
      });

      result.value = Value(variable);
    }

    code.add(childResult.code);
    if (!result.isUsed) {
      if (childResult.allocated != null) {
        code.assign('state.unused', childResult.allocated!);
      }
    }

    code.branch('true');
    result.postprocess(this);
  }
}

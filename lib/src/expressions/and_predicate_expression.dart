import 'build_context.dart';

class AndPredicateExpression extends SingleExpression {
  AndPredicateExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicate(this);
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

    final branch = childResult.branch();
    branch.truth.block((b) {
      b.assign('state.position', position.name);
    });

    final code = result.code;
    code.add(childResult.code);
    if (result.isUsed) {
      result.value = Value('null', isConst: true);
    }

    result.postprocess(this);
  }
}

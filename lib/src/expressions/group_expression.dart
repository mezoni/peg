import 'build_context.dart';

class GroupExpression extends SingleExpression {
  GroupExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitGroup(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    context.shareValues(this, expression, [Expression.position]);
    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    final code = result.code;
    code.add(childResult.code);
    childResult.copyValueTo(result);
    result.postprocess(this);
  }
}

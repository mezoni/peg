import 'build_context.dart';

class TypingExpression extends SingleExpression {
  final String type;

  TypingExpression({
    required super.expression,
    required this.type,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitTyping(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    context.shareValues(this, expression, [Expression.position]);
    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    childResult.copyValueTo(result);
    result.code.add(childResult.code);
    result.postprocess(this);
  }
}

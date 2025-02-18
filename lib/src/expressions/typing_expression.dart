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
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    context.shareValues(this, expression, [Expression.position]);
    sink.writeln(expression.generate(context, variable, isFast));
    return postprocess(context, sink);
  }
}

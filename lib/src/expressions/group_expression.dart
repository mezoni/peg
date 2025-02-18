import 'build_context.dart';

class GroupExpression extends SingleExpression {
  GroupExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitGroup(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    context.shareValues(this, expression, [Expression.position]);
    sink.writeln(expression.generate(context, variable, isFast));
    return postprocess(context, sink);
  }
}

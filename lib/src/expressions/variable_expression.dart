import 'build_context.dart';

class VariableExpression extends SingleExpression {
  final String name;

  VariableExpression({
    required super.expression,
    required this.name,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitVariable(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    sink.writeln(expression.generate(context, variable, isFast));
    return postprocess(context, sink);
  }
}

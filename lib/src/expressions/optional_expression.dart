import '../helper.dart';
import 'build_context.dart';

class OptionalExpression extends SingleExpression {
  OptionalExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOptional(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    if (variable != null) {
      if (variable.type.isEmpty) {
        variable.type = getReturnType();
      }
    }

    context.shareValues(this, expression, [Expression.position]);
    sink.writeln(expression.generate(context, variable, isFast));
    if (variable != null) {
      sink.statement('$variable ??= (null,)');
    }

    return postprocess(context, sink);
  }
}

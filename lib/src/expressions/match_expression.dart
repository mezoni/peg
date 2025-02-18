import '../helper.dart';
import 'build_context.dart';

class MatchExpression extends SingleExpression {
  MatchExpression({required super.expression});

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final childVariable = expression.isVariableNeedForTestState()
        ? context.allocateVariable()
        : null;
    final position = context.getSharedValue(this, Expression.position);
    context.shareValues(this, expression, [Expression.position]);
    sink.writeln(expression.generate(context, childVariable, true));
    if (variable != null) {
      final isSuccess = expression.getStateTest(childVariable, true);
      final value = conditional(
          isSuccess, '(state.substring($position, state.position),)', 'null');
      variable.assign(sink, value);
    }

    return postprocess(context, sink);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitMatch(this);
  }
}

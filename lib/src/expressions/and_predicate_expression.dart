import '../helper.dart';
import 'build_context.dart';

class AndPredicateExpression extends SingleExpression {
  AndPredicateExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAndPredicate(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final childVariable = expression.isVariableNeedForTestState()
        ? context.allocateVariable()
        : null;
    final isSuccess = expression.getStateTest(childVariable, true);
    sink.write(expression.generate(context, childVariable, true));
    final position = getSharedValue(context, 'state.position');
    sink.statement(conditional(isSuccess, 'null', 'state.fail<void>()'));
    sink.statement('state.position = $position');
    final value = conditional(isSuccess, '(null,)', 'null');
    if (variable != null) {
      variable.assign(sink, value);
    }

    return postprocess(context, sink);
  }
}

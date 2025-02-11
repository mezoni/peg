import '../helper.dart';
import 'build_context.dart';

class NotPredicateExpression extends SingleExpression {
  NotPredicateExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitNotPredicate(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final optimized = _optimize(context, variable, isFast);
    if (optimized != null) {
      return optimized;
    }

    final sink = preprocess(context);
    final position = getSharedValue(context, 'state.position');
    final predicate = context.allocate('predicate');
    final childVariable = expression.isVariableNeedForTestState()
        ? context.allocateVariable()
        : null;
    final isFailure = expression.getStateTest(childVariable, false);
    sink.statement('final $predicate = state.predicate');
    sink.statement('state.predicate = true');
    sink.writeln(expression.generate(context, childVariable, true));
    sink.statement('state.predicate = $predicate');
    final value = conditional(
        isFailure, '(null,)', 'state.failAndBacktrack<void>($position)');
    if (variable != null) {
      variable.assign(sink, value);
    }

    return postprocess(context, sink);
  }

  String? _optimize(BuildContext context, Variable? variable, bool isFast) {
    if (isFastOrVoid(isFast)) {
      if (expression is AnyCharacterExpression) {
        final sink = preprocess(context);
        const value = 'state.matchEof()';
        if (variable != null) {
          variable.assign(sink, value);
        } else {
          sink.statement(value);
        }

        return postprocess(context, sink);
      }
    }

    return null;
  }
}

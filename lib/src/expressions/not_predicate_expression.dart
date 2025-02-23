import 'build_context.dart';

class NotPredicateExpression extends SingleExpression {
  NotPredicateExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitNotPredicate(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    if (_optimize(context, result)) {
      return;
    }

    final position = context.getSharedValue(this, Expression.position);
    context.shareValues(this, expression, [Expression.position]);
    final predicate = context.allocate();
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: false,
    );

    expression.generate(context, childResult);

    final ok = context.allocate();
    final branch = childResult.branch();
    branch.truth.block((b) {
      b.statement('state.failAndBacktrack($position)');
      b.assign(ok, 'false');
    });

    final code = result.code;
    code.assign(predicate, 'state.predicate', 'final');
    code.assign('state.predicate', 'true');
    code.assign(ok, 'true', 'var');
    code.add(childResult.code);
    code.assign('state.predicate', predicate);
    code.branch(ok, '!$ok');
    if (result.isUsed) {
      result.value = Value('null', isConst: true);
    }

    result.postprocess(this);
  }

  bool _optimize(BuildContext context, BuildResult result) {
    if (expression is AnyCharacterExpression) {
      final code = result.code;
      final branch = code.branch('state.peek() == 0', 'state.peek() != 0');
      branch.falsity.block((b) {
        b.statement('state.fail()');
      });

      if (result.isUsed) {
        result.value = Value('null', isConst: true);
      }

      result.postprocess(this);
      return true;
    }

    return false;
  }
}

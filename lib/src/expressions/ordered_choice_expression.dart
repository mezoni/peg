import 'build_context.dart';

class OrderedChoiceExpression extends MultiExpression {
  OrderedChoiceExpression({required super.expressions});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOrderedChoice(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    if (expressions.length == 1) {
      return _generate1(context, result);
    }

    return _generate(context, result);
  }

  void _generate(BuildContext context, BuildResult result) {
    final variable = context.allocate();
    final results = <BuildResult>[];
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      context.shareValues(this, expression, [Expression.position]);
      final childResult = result.copy(expression);

      expression.generate(context, childResult);

      results.add(childResult);
      final branch = childResult.branch();
      branch.truth.block((b) {
        if (result.isUsed) {
          final value = childResult.value;
          b.assign(variable, value.code);
        }
      });
    }

    BuildResult? previous;
    for (var i = 0; i < results.length; i++) {
      final current = results[i];
      if (previous != null) {
        final branch = previous.branch();
        branch.falsity.block((b) {
          b.add(current.code);
        });
      }

      previous = current;
    }

    final code = result.code;
    if (result.isUsed) {
      final type = result.getIntermediateType();
      code.statement('$type $variable');
    } else {
      code.assign(variable, 'true', 'var');
    }

    final first = results.first;
    code.add(first.code);
    if (result.isUsed) {
      code.branch('$variable != null', '$variable == null');
    } else {
      code.branch(variable, '!$variable');
    }

    if (!result.isUsed) {
      final last = results.last;
      final branch = last.branch();
      branch.falsity.block((b) {
        b.assign(variable, 'false');
      });
    }

    if (result.isUsed) {
      result.value = Value(variable);
    }

    result.postprocess(this);
  }

  void _generate1(BuildContext context, BuildResult result) {
    final expression = expressions.first;
    context.shareValues(this, expression, [Expression.position]);
    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    childResult.copyValueTo(result);
    result.code.add(childResult.code);
    result.postprocess(this);
  }
}

import 'build_context.dart';

class SequenceExpression extends MultiExpression {
  SequenceExpression({
    required super.expressions,
  }) {
    if (expressions.isEmpty) {
      throw ArgumentError('Must not be empty', 'expressions');
    }
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSequence(this);
  }

  int findResultIndex() {
    if (expressions.length == 1) {
      return 0;
    }

    for (var i = expressions.length - 1; i >= 0; i--) {
      final expression = expressions[i];
      if (expression case final VariableExpression expression) {
        if (expression.name == '\$') {
          return i;
        }
      }
    }

    return -1;
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
    SharedValue? position;
    String? variable;
    if (!isAlwaysSuccessful) {
      variable = context.allocate();
    }

    if (expressions.skip(1).any((e) => !e.isAlwaysSuccessful)) {
      position = context.getSharedValue(this, Expression.position);
    }

    final results = <BuildResult>[];
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final childResult = BuildResult(
        context: context,
        expression: expression,
        isUsed: expression is VariableExpression,
      );

      if (i == 0) {
        context.shareValues(this, expression, [Expression.position]);
      }

      expression.generate(context, childResult);

      results.add(childResult);
    }

    BuildResult? previous;
    for (var i = 0; i < results.length; i++) {
      final current = results[i];
      if (previous != null) {
        final branch = previous.branch();
        branch.truth.block((b) {
          b.add(current.code);
        });
      }

      previous = current;
    }

    final last = results.last;
    final lastBranch = last.branch();
    lastBranch.truth.block((b) {
      if (variable != null) {
        if (result.isUsed) {
          b.assign(variable, r'$');
        } else {
          b.assign(variable, 'true');
        }
      }
    });

    final code = result.code;
    if (variable != null) {
      if (result.isUsed) {
        final type = result.getIntermediateType();
        code.statement('$type $variable');
      } else {
        code.assign(variable, 'false', 'var');
      }
    }

    final first = results.first;
    code.add(first.code);
    if (variable != null) {
      if (result.isUsed) {
        code.branch('$variable != null', '$variable == null');
      } else {
        code.branch(variable, '!$variable');
      }
    } else {
      code.branch('true', 'false');
    }

    if (position != null) {
      final branch = result.branch();
      branch.falsity.block((b) {
        b.assign('state.position', position!.name);
      });
    }

    if (result.isUsed) {
      if (variable != null) {
        result.value = Value(variable);
      } else {
        result.value = Value(r'$');
      }
    }

    result.postprocess(this);
  }

  void _generate1(BuildContext context, BuildResult result) {
    final expression = expressions.first;
    context.shareValues(this, expression, [Expression.position]);
    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    final code = result.code;
    code.add(childResult.code);
    childResult.copyValueTo(result);
    result.postprocess(this);
  }
}

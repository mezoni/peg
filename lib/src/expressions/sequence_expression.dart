import '../helper.dart';
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
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final expressions = List.of(this.expressions);
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      if (expression is TypingExpression) {
        expressions[i] = expression.expression;
      }
    }

    final sink = preprocess(context);
    if (expressions.length > 1) {
      if (variable != null) {
        if (variable.needDeclare) {
          if (variable.type.isEmpty) {
            variable.type = getReturnType();
          }

          variable.assign(sink, '');
        }
      }
    } else {
      if (variable != null) {
        final expression = expressions[0];
        if (expression is VariableExpression) {
          if (variable.needDeclare) {
            if (variable.type.isEmpty) {
              variable.type = getReturnType();
            }

            variable.assign(sink, '');
          }
        }
      }
    }

    final variables = <Variable?>[];
    if (expressions.length == 1) {
      final expression = expressions[0];
      if (expression is VariableExpression) {
        variables.add(context.allocateVariable());
      } else {
        variables.add(variable);
      }
    } else {
      for (var i = 0; i < expressions.length; i++) {
        final expression = expressions[i];
        Variable? childVariable;
        if (expression is VariableExpression) {
          childVariable = context.allocateVariable();
        }

        if (childVariable == null && expression.isVariableNeedForTestState()) {
          childVariable = context.allocateVariable();
        }

        variables.add(childVariable);
      }
    }

    var numberOfBlocks = expressions.length;
    if ((expressions.length > 1 && variable != null) ||
        expressions.last is VariableExpression) {
      numberOfBlocks++;
    }

    final blocks = List.generate(numberOfBlocks, (i) => StringBuffer());
    for (var i = 1; i < blocks.length; i++) {
      final block = blocks[i];
      final expression = expressions[i - 1];
      if (expression is VariableExpression) {
        final name = expression.name;
        final type = expression.getResultType();
        final variable = variables[i - 1];
        block.statement('$type $name = $variable.\$1');
      }
    }

    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final variable = variables[i];
      final block = blocks[i];
      if (i == 0) {
        context.shareValues(this, expression, [Expression.position]);
      }

      block.writeln(
          expression.generate(context, variable, isFast || variable == null));
    }

    final resultIndex = findResultIndex();
    if (variable != null) {
      final block = blocks.last;
      String? value;
      if (resultIndex != -1) {
        final variable = variables[resultIndex];
        final expression = expressions[resultIndex];
        if (expression is VariableExpression) {
          final name = expression.name;
          value = '($name,)';
        } else {
          value = '$variable';
        }
      } else {
        value = '(null,)';
      }

      if (value != variable.name) {
        variable.assign(block, value);
      }
    }

    String getStateTestAtIndex(int index) {
      if (index < 0) {
        return 'true';
      }

      final expression = expressions[index];
      final variable = variables[index];
      return expression.getStateTest(variable, true);
    }

    var buffer = StringBuffer();
    for (var i = blocks.length - 1; i >= 0; i--) {
      final block = blocks[i];
      if (i == 0) {
        final inner = '$buffer';
        buffer = StringBuffer();
        buffer.writeln(block);
        buffer.writeln(inner);
      } else if (i < blocks.length - 1) {
        final isSuccess = getStateTestAtIndex(i - 1);
        final inner = '$buffer';
        buffer = StringBuffer();
        buffer.ifStatement(isSuccess, (b) {
          b.writeln(block);
          b.writeln(inner);
        });
      } else {
        final isSuccess = getStateTestAtIndex(i - 1);
        buffer.ifStatement(isSuccess, (b) {
          b.writeln(block);
        });
      }

      if (i == 1) {
        if (_isPositionRequired()) {
          final isFailure = getStateTest(variable, false);
          buffer.ifStatement(isFailure, (b) {
            final position = context.getSharedValue(this, Expression.position);
            b.statement('state.position = $position');
          });
        }
      }
    }

    sink.writeln(buffer);
    return postprocess(context, sink);
  }

  bool _isPositionRequired() {
    if (expressions.length == 1) {
      return false;
    }

    if (isAlwaysSuccessful) {
      return false;
    }

    if (expressions.length == 2) {
      final last = expressions.last;
      return !last.isAlwaysSuccessful;
    }

    return true;
  }
}

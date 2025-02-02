import 'expression.dart';

class SequenceExpression extends MultiExpression {
  final String? errorHandler;

  SequenceExpression({
    required super.expressions,
    this.errorHandler,
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

    var resultIndex = -1;
    var count = 0;
    for (var i = expressions.length - 1; i >= 0; i--) {
      final expression = expressions[i];
      final semanticVariable = expression.semanticVariable;
      if (semanticVariable == '\$') {
        return i;
      }

      if (semanticVariable != null) {
        resultIndex = i;
        count++;
      }
    }

    return count == 1 ? resultIndex : -1;
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = <String, String>{};
    final resultIndex = findResultIndex();
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final childVariable = expression.semanticVariable;
      if (childVariable != null) {
        context.allocateExpressionVariable(expression);
      } else {
        if (i == resultIndex && variable != null) {
          context.setExpressionVariable(expression, variable);
        }
      }

      values['p$i'] = expression.generate(context);
    }

    final template = _generateTemplate(context);
    return render(context, this, template, values);
  }

  String _generateTemplate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final blocks = <StringBuffer>[];
    final semanticVariables = <int>[];
    final resultIndex = findResultIndex();
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final block = StringBuffer();
      final childVariable = context.getExpressionVariable(expression);
      var actionAssignsValue = false;
      if (expression is ActionExpression) {
        actionAssignsValue =
            expression.semanticVariable != null || expressions.length == 1;
        if (actionAssignsValue) {
          final resultType = expression.getResultType();
          block.writeln('late $resultType \$\$;');
        }
      }

      block.writeln('{{p$i}}');
      if (actionAssignsValue) {
        block.writeln('$childVariable = \$\$;');
      }

      blocks.add(block);
      final semanticVariable = expression.semanticVariable;
      if (semanticVariable != null) {
        semanticVariables.add(i);
      }
    }

    if (expressions.last.semanticVariable != null) {
      final last = StringBuffer();
      blocks.add(last);
    }

    if (variable != null) {
      final last = blocks.last;
      String? resultVariable;
      if (resultIndex != -1) {
        final resultExpression = expressions[resultIndex];
        final semanticVariable = resultExpression.semanticVariable;
        if (semanticVariable != null) {
          resultVariable = semanticVariable;
        } else {
          resultVariable = context.getExpressionVariable(resultExpression);
        }
      }

      if (resultVariable == null) {
        resultVariable = context.allocate();
        last.writeln(' // Fictive result of expression: $this');
        last.writeln('void $resultVariable;');
      }

      if (variable != resultVariable) {
        last.writeln('$variable = $resultVariable;');
      }
    }

    for (var i = 0; i < semanticVariables.length; i++) {
      final index = semanticVariables[i];
      final expression = expressions[index];
      final childVariable = context.getExpressionVariable(expression)!;
      final childResultValue = expression.getResultValue(childVariable);
      final semanticVariable = expression.semanticVariable!;
      var block = blocks[index + 1];
      final code = '$block';
      final childType = expression.getResultType();
      block = StringBuffer();
      var value = childResultValue;
      if (expression is ActionExpression) {
        value = childVariable;
      }

      block.writeln('$childType $semanticVariable = $value;');
      block.writeln(code);
      blocks[index + 1] = block;
    }

    var template = StringBuffer();
    for (var i = blocks.length - 1; i >= 0; i--) {
      final block = blocks[i];
      if (i == 0) {
        final inner = '$template';
        template = StringBuffer();
        template.writeln(block);
        template.writeln(inner);
      } else if (i < blocks.length - 1) {
        final inner = '$template';
        template = StringBuffer();
        template.writeln('if (state.isSuccess) {');
        template.writeln(block);
        template.writeln(inner);
        template.writeln('}');
      } else {
        template.writeln('if (state.isSuccess) {');
        template.writeln(block);
        template.writeln('}');
      }

      if (i == 1) {
        template.writeln('if (!state.isSuccess) {');
        template.writeln('state.position = {{$pos}};');
        template.writeln('}');
      }
    }

    return '$template';
  }
}

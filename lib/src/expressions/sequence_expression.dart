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

    for (var i = expressions.length - 1; i >= 0; i--) {
      final expression = expressions[i];
      final semanticVariable = expression.semanticVariable;
      if (semanticVariable == '\$') {
        return i;
      }
    }

    return -1;
  }

  @override
  String generate(ProductionRuleContext context) {
    final values = <String, String>{};
    if (expressions.length == 1) {
      final variable = context.getExpressionVariable(this);
      final expression = expressions[0];
      context.setExpressionVariable(expression, variable);
      context.copyExpressionResultUsage(this, expression);
      if (expression.semanticVariable == null) {
        context.changeExpressionVariableDeclarator(variable, this, expression);
      }

      values['p0'] = expression.generate(context);
    } else {
      for (var i = 0; i < expressions.length; i++) {
        final expression = expressions[i];
        final semanticVariable = expression.semanticVariable;
        context.allocateExpressionVariable(expression);
        context.setExpressionResultUsage(expression, semanticVariable != null);
        values['p$i'] = expression.generate(context);
      }
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
    context.getExpressionResultUsage(this);
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final block = StringBuffer();
      block.writeln('{{p$i}}');
      blocks.add(block);
      final semanticVariable = expression.semanticVariable;
      if (semanticVariable != null) {
        semanticVariables.add(i);
      }
    }

    /*
    if (expressions.length > 1) {
      final last = StringBuffer();
      blocks.add(last);
    }
    */

    if (expressions.length > 1 || expressions.last.semanticVariable != null) {
      final last = StringBuffer();
      blocks.add(last);
    }

    if (true) {
      final last = blocks.last;
      String? resultValue;
      if (resultIndex != -1) {
        final resultExpression = expressions[resultIndex];
        final semanticVariable = resultExpression.semanticVariable;
        if (semanticVariable != null) {
          resultValue = '($semanticVariable,)';
        } else {
          resultValue = context.getExpressionVariable(resultExpression);
        }
      } else {
        resultValue = 'const (null,)';
      }

      if (variable != resultValue) {
        last.writeln('$variable = $resultValue;');
      }
    }

    for (var i = 0; i < semanticVariables.length; i++) {
      final index = semanticVariables[i];
      final expression = expressions[index];
      final childVariable = context.getExpressionVariable(expression);
      final childResultValue = expression.getResultValue(childVariable);
      final semanticVariable = expression.semanticVariable!;
      var block = blocks[index + 1];
      final code = '$block';
      final childType = expression.getResultType();
      block = StringBuffer();
      block.writeln('$childType $semanticVariable = $childResultValue;');
      block.writeln(code);
      blocks[index + 1] = block;
    }

    var template = StringBuffer();
    for (var i = blocks.length - 1; i >= 0; i--) {
      var r = '';
      if (i > 0) {
        final expression = expressions[i - 1];
        r = context.getExpressionVariable(expression);
      }

      final block = blocks[i];
      if (i == 0) {
        final inner = '$template';
        template = StringBuffer();
        template.writeln(block);
        template.writeln(inner);
      } else if (i < blocks.length - 1) {
        final inner = '$template';
        template = StringBuffer();
        template.writeln('if ($r != null) {');
        template.writeln(block);
        template.writeln(inner);
        template.writeln('}');
      } else {
        template.writeln('if ($r != null) {');
        template.writeln(block);
        template.writeln('}');
      }

      if (i == 1) {
        template.writeln('if ($variable == null) {');
        template.writeln('state.position = {{$pos}};');
        template.writeln('}');
      }
    }

    return '$template';
  }
}

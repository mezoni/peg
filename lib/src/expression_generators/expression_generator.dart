import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../grammar_generators/production_rule_generator.dart';
import '../helper.dart' as helper;

abstract class ExpressionGenerator<T extends Expression> {
  final T expression;

  final ProductionRuleGenerator ruleGenerator;

  ExpressionGenerator({
    required this.expression,
    required this.ruleGenerator,
  });

  ProductionRule get rule => ruleGenerator.rule;

  String allocateName() {
    return ruleGenerator.allocator.allocate();
  }

  String generate();

  String generateAsync() {
    throw UnimplementedError('generateAsync()');
  }

  String generateAsyncExpression(Expression expression, bool declareVariable) {
    final buffer = StringBuffer();
    final asyncGenerator = ruleGenerator.asyncGenerator;
    buffer.writeln(' // $expression');
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      if (declareVariable) {
        asyncGenerator.addVariable(variable, expression.resultType!);
      }
    }

    final forceBuffering =
        asyncGenerator.buffering == 0 && _needForceBuffering(expression);
    if (forceBuffering) {
      asyncGenerator.buffering++;
    }

    final source = expression.accept(ruleGenerator);
    if (forceBuffering) {
      asyncGenerator.buffering--;
    }

    buffer.writeln(source);
    return buffer.toString();
  }

  String generateExpression(Expression expression, bool declareVariable) {
    final values = <String, String>{};
    final buffer = StringBuffer();
    if (expression is SequenceExpression) {
      buffer.writeln(' // $expression');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      if (declareVariable) {
        values['type'] =
            getExpressionResultType(expression).getNullableType().toString();
        values['variable'] = variable;
        buffer.writeln('{{type}} {{variable}};');
      }
    }

    buffer.write('{{p}}');
    values['p'] = expression.accept(ruleGenerator);
    return render(buffer.toString(), values);
  }

  ResultType getExpressionResultType(Expression expression) {
    if (expression.resultType case final resultType?) {
      return resultType;
    }

    return GenericType(name: 'Object', isNullableType: true);
  }

  String getExpressionVariableWithNullCheck(Expression expression) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable == null) {
      return '__undefined__';
    }

    final type = getExpressionResultType(expression);
    if (type.isNullableType) {
      return variable;
    }

    return '$variable!';
  }

  String render(String template, Map<String, String> values,
      {bool removeEmptyLines = true}) {
    return helper.render(template, values);
  }

  bool _needForceBuffering(Expression expression) {
    if (!expression.hasCutExpressions) {
      return false;
    }

    final parent = expression.parent;
    if (parent is! OrderedChoiceExpression) {
      return false;
    }

    final children = parent.expressions;
    final last = children.last;
    if (expression == last) {
      return false;
    }

    final indexOfExpression = children.indexOf(expression);
    final alternatives = <Expression>[];
    final current = expression.startingCharacters;
    outer:
    for (var i = indexOfExpression + 1; i < children.length; i++) {
      final child = children[i];
      final next = child.startingCharacters;
      for (var j = 0; j < current.length; j++) {
        final range = current[j];
        final start = range.$1;
        final end = range.$2;
        for (var k = 0; k < next.length; k++) {
          final range2 = next[k];
          final start2 = range2.$1;
          final end2 = range2.$2;
          if (start >= start2 && start <= end2) {
            alternatives.add(child);
            break outer;
          }

          if (end >= start2 && end <= end2) {
            alternatives.add(child);
            break outer;
          }

          if (start > end2) {
            break;
          }
        }
      }
    }

    if (alternatives.isEmpty) {
      return false;
    }

    final rule = expression.rule!.name;
    final text = <String>[];
    text.add('Force buffering of alternative from ordered choice.');
    text.add('Production rule: $rule');
    text.add('Ordered choice: $parent');
    text.add('Buffered alternative: $expression');
    text.add('Overlapping alternative(s):');
    text.add(alternatives.join('\n'));
    print(text.join('\n'));
    return true;
  }
}

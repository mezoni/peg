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

    final source = expression.accept(ruleGenerator);
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
}

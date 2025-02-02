import '../allocator.dart';
import '../expressions/expression.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import '../parser_generator.dart';

class ProductionRuleGenerator {
  final List<String> errors;

  final ParserGeneratorOptions options;

  final ProductionRule rule;

  ProductionRuleGenerator({
    required this.errors,
    required this.options,
    required this.rule,
  });

  String generate() {
    final expression = rule.expression;
    final name = 'parse${rule.name}';
    final returnType = rule.resultType;
    final resultType = expression.resultType;
    if (resultType.isEmpty) {
      errors.add('''
Unresolved result type for expression
Expression: $expression''');
    }
    if (returnType.isEmpty) {
      errors.add('''
Unresolved return type for production rule
Production rule: $name''');
    }

    if (errors.isNotEmpty) {
      return '';
    }

    final context = ProductionRuleContext(
      allocator: Allocator(),
      options: options,
    );
    if (returnType != 'void') {
      final variable = context.allocateExpressionVariable(expression);
      context.setExpressionVariableDeclared(variable);
    }

    final code = expression.generate(context);
    final expected = rule.expected;
    var prologue = '';
    var epilogue = '';
    final inputVariable = context.inputVariable;
    if (inputVariable != null) {
      prologue = '''
$prologue
final $inputVariable = state.input;''';
    }

    if (expected != null) {
      var pos = context.positionVariables[expression];
      if (pos == null) {
        pos = context.allocate('pos');
        prologue = '''
$prologue
final $pos = state.position;''';
      }

      final escaped = helper.escapeString(expected, "'");
      final failure = context.allocate();
      prologue = '''
$prologue
final $failure = state.enter();''';
      epilogue = '''
state.expected($escaped, $pos, false);
state.leave($failure);
$epilogue''';
    }

    final values = {
      'code': code,
      'epilogue': epilogue,
      'name': name,
      'prologue': prologue,
      'return_type': helper.getNullableType(returnType),
      'result_type': helper.getNullableType(resultType),
    };
    var template = '';
    if (returnType != 'void') {
      final variable = context.getExpressionVariable(expression)!;
      values['variable'] = variable;
      template = '''
{{return_type}} {{name}}(State state) {
  {{prologue}}
  {{result_type}} {{variable}};
  {{code}}
  {{epilogue}}
  return {{variable}};
}''';
    } else {
      template = '''
void {{name}}(State state) {
  {{prologue}}
  {{code}}
  {{epilogue}}
}''';
    }

    errors.addAll(context.errors.map((e) {
      final expression = e.$1;
      final message = e.$2;
      final rule = expression.rule!;
      final name = rule.name;
      return '''
$message
Expression: $expression
Production rule: $name''';
    }));

    final rendered = helper.render(template, values);
    final comments = _generateComments(expression);
    template = '''
$comments
$rendered''';
    return template;
  }

  String _generateComments(Expression expression) {
    final declaration = StringBuffer();
    declaration.write(' /// **${rule.name}**');
    final expected = rule.expected;
    if (expected != null) {
      final escaped = helper.escapeString(expected, "'");
      declaration.write(' ($escaped)');
    }

    declaration.writeln();
    declaration.writeln(' ///');
    declaration.writeln(' ///```code');
    if (rule.resultType.isNotEmpty) {
      declaration.writeln(' /// `${rule.resultType}`');
    }

    declaration.writeln(' /// ${rule.name} =');
    if (expression is OrderedChoiceExpression) {
      final expressions = expression.expressions;
      if (expressions.length == 1) {
        declaration.writeln(' ///    $expression');
      } else {
        for (var i = 0; i < expressions.length; i++) {
          final expression = expressions[i];
          final prefix = i == 0 ? '    ' : '  / ';
          declaration.writeln(' /// $prefix$expression');
        }
      }
    } else {
      declaration.writeln(' /// $expression');
    }

    declaration.writeln(' ///```');
    return '$declaration'.trim();
  }
}

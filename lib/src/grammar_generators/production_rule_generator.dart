import '../allocator.dart';
import '../expressions/build_context.dart';
import '../grammar/production_rule.dart';
import '../helper.dart';
import '../parser_generator.dart';
import '../parser_generator_diagnostics.dart';

class ProductionRuleGenerator {
  final ParserGeneratorDiagnostics diagnostics;

  final ParserGeneratorOptions options;

  final ProductionRule rule;

  ProductionRuleGenerator({
    required this.diagnostics,
    required this.options,
    required this.rule,
  });

  String generate() {
    final expression = rule.expression;
    final name = 'parse${rule.name}';
    final resultType = rule.getResultType();
    final context = BuildContext(
      allocator: Allocator(),
      diagnostics: diagnostics,
      options: options,
    );

    final isFast = resultType == 'void' ? true : false;
    final variable = context.allocateVariable();
    final expected = rule.expected;
    if (expected != null) {
      expression.getSharedValue(context, 'state.position');
    }

    final code = expression.generate(context, variable, isFast);
    if (diagnostics.hasErrors) {
      return '';
    }

    var prologue = '';
    var epilogue = '';
    if (expected != null) {
      final position = expression.getSharedValue(context, 'state.position');
      final escaped = escapeString(expected, "'");
      final failure = context.allocate();
      prologue = '''
$prologue
final $failure = state.enter();''';
      epilogue = '''
state.expected($variable, $escaped, $position, false);
state.leave($failure);
$epilogue''';
    }

    final values = {
      'code': code,
      'epilogue': epilogue,
      'name': name,
      'prologue': prologue,
      'return_type': rule.getReturnType(),
      'variable': variable.name,
    };
    var template = '';
    template = '''
{{return_type}} {{name}}(State state) {
  {{prologue}}
  {{code}}
  {{epilogue}}
  return {{variable}};
}''';

    final rendered = render(template, values);
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
      final escaped = escapeString(expected, "'");
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

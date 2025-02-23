import 'dart:convert';

import '../allocator.dart';
import '../expressions/build_context.dart';
import '../expressions/code_gen.dart';
import '../expressions/expression_printer2.dart';
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
    final name = 'parse${rule.name}';
    final resultType = rule.getResultType();
    final context = BuildContext(
      allocator: Allocator(),
      diagnostics: diagnostics,
      options: options,
    );

    final isUsed = resultType != 'void';
    final expected = rule.expected;
    var expression = rule.expression;
    if (expected != null) {
      expression = ExpectedExpression(expression: expression, name: expected);
    }

    context.addSharedValues(expression, [Expression.position]);
    final result = BuildResult(
      context: context,
      expression: expression,
      isUsed: isUsed,
    );

    expression.generate(context, result);
    if (diagnostics.hasErrors) {
      return '';
    }

    final code = CodeGen();
    code.add(result.code);
    final branch = result.branch();
    branch.truth.block((b) {
      if (result.isUsed) {
        final value = result.value;
        final boxed = value.boxed ?? '($value,)';
        if (value.isConst) {
          b.statement('return const $boxed');
        } else {
          b.statement('return $boxed');
        }
      } else {
        b.statement('return const (null,)');
      }
    });

    if (branch.ok.trim() != 'true') {
      branch.falsity.block((b) {
        b.statement('return null');
      });
    }

    final sink = StringBuffer();
    code.generate(sink);
    final values = {
      'code': '$sink',
      'name': name,
      'return_type': rule.getReturnType(),
    };
    var template = '';
    template = '''
{{return_type}} {{name}}(State state) {
  {{code}}
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
    final escapedExpected =
        expected == null ? null : escapeString(expected, "'");
    if (escapedExpected != null) {
      declaration.write(' ($escapedExpected)');
    }

    declaration.writeln();
    declaration.writeln(' ///');
    declaration.writeln(' ///```text');
    if (rule.resultType.isNotEmpty) {
      declaration.writeln(' /// `${rule.resultType}`');
    }

    declaration.write(' /// ${rule.name}');
    if (escapedExpected != null) {
      declaration.write('($escapedExpected)');
    }

    declaration.writeln(' =>');
    final code = const LineSplitter()
        .convert(ExpressionPrinter2().print(expression))
        .map((e) => ' ///   $e')
        .join('\n');
    declaration.writeln(code);
    declaration.writeln(' ///```');
    return '$declaration'.trim();
  }
}

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
    final resultType = rule.getResultType().trim();
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
    _generateReturn(result);
    final sink = StringBuffer();
    code.generate(sink);
    final values = {
      'code': '$sink',
      'name': name,
      'return_type': expression.isAlwaysSuccessful
          ? expression.getResultType()
          : rule.getReturnType(),
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

  void _generateReturn(BuildResult result) {
    void addReturns(String success, String failure, String value) {
      final branch = result.branch();
      final truthHasCode = branch.truth.hasCode;
      final falsityHasCode = branch.falsity.hasCode;
      final test = branch.test;
      if (!truthHasCode && !falsityHasCode) {
        if (test == '$value != null') {
          result.code.statement('return $value');
          return;
        }
      }

      if (!falsityHasCode) {
        if (test == 'true') {
          result.code.statement('return $value');
          return;
        }
      }

      branch.truth.block((b) {
        b.statement('return $success');
      });

      branch.falsity.block((b) {
        b.statement('return $failure');
      });
    }

    final resultType = rule.getResultType();
    final expression = rule.expression;
    if (expression.isAlwaysSuccessful) {
      if (resultType == 'void') {
        return;
      }

      if (!result.isUsed) {
        addReturns('null', 'null', '');
        return;
      }

      final code = result.value.code;
      addReturns(code, 'null', code);
      return;
    }

    if (resultType == 'void') {
      addReturns('const (null,)', 'null', '');
      return;
    }

    if (result.isUsed) {
      final value = result.value;
      final wrapped = value.wrapped ?? '($value,)';
      if (value.isConst) {
        addReturns('const $wrapped', 'null', wrapped);
      } else {
        addReturns(wrapped, 'null', wrapped);
      }
    } else {
      addReturns('const (null,)', 'null', '');
    }
  }
}

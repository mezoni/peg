import 'package:strings/strings.dart';

import '../grammar/grammar.dart';
import '../helper.dart';
import '../parser_generator.dart';
import '../parser_generator_diagnostics.dart';

class ParseFunctionGenerator {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  final ParserGeneratorOptions options;

  ParseFunctionGenerator({
    required this.diagnostics,
    required this.grammar,
    required this.options,
  });

  String generate() {
    final parse = options.parseFunction;
    if (parse == null) {
      return '';
    }

    final start = grammar.start;
    if (start == null) {
      return '';
    }

    final ruleName = start.name.toUpperCase().toCamelCase();
    final expression = start.expression;
    final resultType = expression.getResultType();
    if (expression.isAlwaysSuccessful) {
      if (resultType == 'void') {
        final values = {
          'parse': 'parse',
          'parser_name': options.name,
          'parse_start': 'parse$ruleName',
        };
        const template = r'''
void {{parse}}(String source) {
  final state = State(source);
  final parser = {{parser_name}}();
  parser.{{parse_start}}(state);
  return;
}
''';
        return render(template, values);
      } else {
        final values = {
          'parse': 'parse',
          'parser_name': options.name,
          'parse_start': 'parse$ruleName',
          'type': resultType,
        };

        const template = r'''
{{type}} {{parse}}(String source) {
  final state = State(source);
  final parser = {{parser_name}}();
  return parser.{{parse_start}}(state);
}
''';
        return render(template, values);
      }
    } else {
      final values = {
        'return': resultType == 'void' ? 'return' : r'return result.$1',
        'parse': 'parse',
        'parser_name': options.name,
        'parse_start': 'parse$ruleName',
        'type': resultType,
      };

      const template = r'''
{{type}} {{parse}}(String source) {
  final state = State(source);
  final parser = {{parser_name}}();
  final result = parser.{{parse_start}}(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }
  {{return}};
}
''';

      return render(template, values);
    }
  }
}

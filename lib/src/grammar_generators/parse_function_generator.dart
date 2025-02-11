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
    if (resultType.isEmpty) {
      return '';
    }

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
  final result = parser.{{parse_start}}(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }
  return result.$1;
}
''';

    return render(template, values);
  }
}

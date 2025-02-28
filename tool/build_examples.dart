import 'dart:io';

import 'package:peg/src/parser_generator.dart';

void main(List<String> args) {
  final parsers = [
    (
      'example/calc.peg',
      'example/example.dart',
      ParserGeneratorOptions(
        name: 'CalcParser',
      ),
    ),
    (
      'example/json.peg',
      'example/json_example.dart',
      ParserGeneratorOptions(
        name: 'JsonParser',
        parseFunction: 'parse',
      ),
    ),
    (
      'example/math.peg',
      'example/math_parser.dart',
      ParserGeneratorOptions(
        name: 'MathParser',
      ),
    ),
    (
      'example/number.peg',
      'example/number.dart',
      ParserGeneratorOptions(
        name: 'NumberParser',
        parseFunction: 'parse',
      ),
    ),
    (
      'example/realtime_calc.peg',
      'example/realtime_calc.dart',
      ParserGeneratorOptions(
        name: 'CalcParser',
      ),
    ),
  ];
  final outputFiles = <String>[];
  for (final parser in parsers) {
    final inputFile = parser.$1;
    final outputFile = parser.$2;
    final options = parser.$3;
    final source = File(inputFile).readAsStringSync();
    final generator = ParserGenerator(
      options: options,
      source: source,
    );
    final result = generator.generate();
    final diagnostics = generator.diagnostics;
    for (final error in diagnostics.errors) {
      print('$error\n');
    }

    for (final warning in diagnostics.warnings) {
      print('$warning\n');
    }

    if (diagnostics.hasErrors) {
      exit(-1);
    }

    outputFiles.add(outputFile);
    File(outputFile).writeAsStringSync(result);
  }

  Process.runSync(Platform.executable, ['format', ...outputFiles]);
}

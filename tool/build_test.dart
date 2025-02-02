import 'dart:io';

import 'package:peg/src/parser_generator.dart';

void main(List<String> args) {
  const inputFile = 'test/test.peg';
  const outputFile = 'test/test_parser.dart';
  final source = File(inputFile).readAsStringSync();
  final options = ParserGeneratorOptions(
    addComments: true,
    name: 'TestParser',
    parseFunction: 'parse',
  );
  final errors = <String>[];
  final generator = ParserGenerator(
    errors: errors,
    options: options,
    source: source,
  );
  final result = generator.generate();
  if (errors.isNotEmpty) {
    print(errors.join('\n\n'));
    exit(-1);
  }

  File(outputFile).writeAsStringSync(result);
  Process.runSync(Platform.executable, ['format', outputFile]);
}

import 'dart:io';

import 'package:peg/src/parser_generator.dart';

void main(List<String> args) {
  final files = [
    ('tool/test.peg', 'tool/test_parser.dart', 'TestParser'),
  ];
  final outputFiles = <String>[];
  for (final element in files) {
    final inputFile = element.$1;
    final outputFile = element.$2;
    final name = element.$3;
    final source = File(inputFile).readAsStringSync();
    final options = ParserGeneratorOptions(
      addComments: false,
      name: name,
    );
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

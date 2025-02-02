import 'dart:io';

import 'package:peg/src/parser_generator.dart';

void main(List<String> args) {
  final files = [
    ('example/calc.peg', 'example/example.dart'),
    ('example/realtime_calc.peg', 'example/realtime_calc.dart'),
  ];
  final outputFiles = <String>[];
  for (final element in files) {
    final inputFile = element.$1;
    final outputFile = element.$2;
    final source = File(inputFile).readAsStringSync();
    final options = ParserGeneratorOptions(
      addComments: false,
      name: 'CalcParser',
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

    outputFiles.add(outputFile);
    File(outputFile).writeAsStringSync(result);
  }

  Process.runSync(Platform.executable, ['format', ...outputFiles]);
}

import 'dart:io';

import 'package:peg/parser_generator.dart';
import 'package:source_span/source_span.dart';

import '../bin/peg_parser.dart';

void main(List<String> args) {
  final source = File('example/calc.peg').readAsStringSync();
  final parser = PegParser();
  final state = State(source);
  final result = parser.parseStart(state);
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  final grammar = result!;
  final errors = <String>[];
  final options = ParserGeneratorOptions(
    addComments: false,
  );
  final generator = ParserGenerator(
      classname: 'CalcParser',
      errors: errors,
      grammar: grammar,
      options: options);
  final code = generator.generate();
  if (errors.isNotEmpty) {
    print(errors.join('\n\n'));
    exit(-1);
  }

  const outputFile = 'example/example.dart';
  File(outputFile).writeAsStringSync(code);
  Process.runSync(Platform.executable, ['format', outputFile]);
}

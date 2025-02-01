import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:peg/parser_generator.dart';
import 'package:peg/src/grammar/grammar.dart';
import 'package:source_span/source_span.dart';
import 'package:strings/strings.dart';

import 'peg_parser.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser();
  argParser.addFlag(
    'comment',
    help: '''
Specifies that detailed comments should be generated for each expression.''',
    defaultsTo: false,
  );

  final argResults = argParser.parse(args);
  final rest = argResults.rest;
  if (rest.length != 1) {
    print('Usage: peg [options] input_file');
    print(argParser.usage);
    exit(-1);
  }

  final comment = argResults['comment'] as bool;

  final inputFilename = rest[0];
  final basename = path.basenameWithoutExtension(inputFilename);
  final outputDir = path.dirname(inputFilename);
  final parserFilename = '${basename}_parser.dart';
  final parserFilePath = path.join(outputDir, parserFilename);
  final converterFilename = '${basename}_converter.dart';
  path.join(outputDir, converterFilename);

  var name = basename.toLowerCase();
  name = name.toCamelCase();
  final parserName = '${name}Parser';
  final file = File(inputFilename);
  if (!file.existsSync()) {
    print('File not found: $inputFilename');
    exit(-1);
  }

  final input = file.readAsStringSync();
  final grammar = _parse(input);
  if (grammar == null) {
    exit(-1);
  }

  final errors = grammar.errors;
  if (errors.isNotEmpty) {
    print('Errors were found while analyzing the grammar:');
    print(errors.join('\n'));
    exit(-1);
  }

  final options = ParserGeneratorOptions(
    addComments: comment,
  );
  final parserGenerator = ParserGenerator(
    options: options,
    classname: parserName,
    errors: errors,
    grammar: grammar,
  );

  final parserSource = parserGenerator.generate();
  File(parserFilePath).writeAsStringSync(parserSource);
  final files = [parserFilePath];
  files.sort();
  await _format(files);
}

Future<void> _format(List<String> filenames) async {
  final process2 =
      await Process.start(Platform.executable, ['format', ...filenames]);
  unawaited(process2.stdout.transform(utf8.decoder).forEach(print));
  unawaited(process2.stderr.transform(utf8.decoder).forEach(print));
}

Grammar? _parse(String source) {
  final state = State(source);
  final parser = PegParser();
  final result = parser.parseStart(state);
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result as Grammar;
}

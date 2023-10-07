import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:peg/src/converter_generator.dart';
import 'package:peg/src/grammar_generators/library_generator.dart';
import 'package:strings/strings.dart';

import 'peg_parser.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser();
  argParser.addFlag(
    'async',
    help: 'Indicates that asynchronous parsing methods should be generated.',
    defaultsTo: false,
  );

  final argResults = argParser.parse(args);
  final rest = argResults.rest;
  if (rest.length != 1) {
    print('Usage: peg [options] input_file');
    print(argParser.usage);
    exit(-1);
  }

  final inputFilename = rest[0];
  final basename = path.basenameWithoutExtension(inputFilename);
  final outputDir = path.dirname(inputFilename);
  final parserFilename = '${basename}_parser.dart';
  final parserFilePath = path.join(outputDir, parserFilename);
  final converterFilename = '${basename}_converter.dart';
  final converterFilePath = path.join(outputDir, converterFilename);

  final isAsync = argResults['async'] as bool;
  var name = basename.toLowerCase();
  name = name.toCamelCase();
  final parserName = '${name}Parser';
  final converterName = '${name}Converter';

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

  final libraryGenerator = LibraryGenerator(
    filename: inputFilename,
    grammar: grammar,
    isAsync: isAsync,
    parserName: parserName,
  );
  final parserSource = libraryGenerator.generate();
  File(parserFilePath).writeAsStringSync(parserSource);

  final converterGenerator = ConverterGenerator(
      converterName: converterName,
      grammar: grammar,
      isAsync: isAsync,
      parserFilename: parserFilename,
      parserName: parserName);
  final converterSource = converterGenerator.generate();
  File(converterFilePath).writeAsStringSync(converterSource);
  final files = [parserFilePath, converterFilePath];
  files.sort();
  await _format(files);
}

Future<void> _format(List<String> filenames) async {
  final process2 =
      await Process.start(Platform.executable, ['format', ...filenames]);
  unawaited(process2.stdout.transform(utf8.decoder).forEach(print));
  unawaited(process2.stderr.transform(utf8.decoder).forEach(print));
}

Grammar? _parse(String input) {
  final parser = PegParser();
  final result = tryParse(parser.parseStart, input);
  if (!result.ok) {
    final message = result.errorMessage;
    print('Errors were found while parsing the grammar:');
    print(message);
    return null;
  }

  return result.result;
}

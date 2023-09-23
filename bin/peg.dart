import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:peg/src/grammar/grammar.dart';
import 'package:peg/src/grammar_generators/library_generator.dart';
import 'package:strings/strings.dart';

import 'peg_parser.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser();
  argParser.addOption(
    'class',
    help: 'Specifies the name of the generated parser class',
  );

  final argResults = argParser.parse(args);
  final rest = argResults.rest;
  if (rest.isEmpty || rest.length > 2) {
    print('Usage: peg [options] input_file output_file');
    print(argParser.usage);
    exit(-1);
  }

  final inputFilename = rest[0];
  var outputFilename = '';
  if (rest.length == 2) {
    outputFilename = rest[1];
  } else {
    outputFilename = path.basenameWithoutExtension(inputFilename);
    outputFilename = '$outputFilename.dart';
    outputFilename = path.join(path.dirname(inputFilename), outputFilename);
  }

  var parserName = argResults['class'] as String?;
  if (parserName == null) {
    parserName = path.basenameWithoutExtension(inputFilename);
    parserName = parserName.toLowerCase();
    parserName = parserName.toCamelCase();
  }

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
    parserName: parserName,
  );
  final source = libraryGenerator.generate();
  File(outputFilename).writeAsStringSync(source);
  final process =
      await Process.start(Platform.executable, ['format', outputFilename]);
  unawaited(process.stdout.transform(utf8.decoder).forEach(print));
  unawaited(process.stderr.transform(utf8.decoder).forEach(print));
}

Grammar? _parse(String input) {
  final parser = PegParser();
  final result = tryParse(parser.parseStart, StringReader(input));
  if (!result.ok) {
    final message = result.errorMessage;
    print('Errors were found while parsing the grammar:');
    print(message);
    return null;
  }

  return result.result;
}

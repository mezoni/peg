import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:peg/src/parser_generator.dart';
import 'package:strings/strings.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser();
  argParser.addFlag(
    'comment',
    help: '''
Specifies that detailed comments should be generated for each expression.''',
    defaultsTo: false,
  );

  argParser.addOption(
    'name',
    help: '''
Specifies the class name of the generated  parser.''',
  );

  argParser.addOption(
    'parse',
    help: '''
Specifies the name of the top-level function that will be generated for parsing.
This function will include code that performs the following operations:
- Create the parser
- Call starting production rule
- Return the parsing result or throw an 'FormatException' exception
This function requires importing the `source_span` package.''',
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

  var name = argResults.option('name');
  if (name == null) {
    name = basename.toLowerCase();
    name = name.toCamelCase();
    name = '${name}Parser';
  }

  final parse = argResults.option('parse');

  final file = File(inputFilename);
  if (!file.existsSync()) {
    print('File not found: $inputFilename');
    exit(-1);
  }

  final source = file.readAsStringSync();
  final errors = <String>[];
  final options = ParserGeneratorOptions(
    addComments: comment,
    name: name,
    parseFunction: parse,
  );
  final parserGenerator = ParserGenerator(
    errors: errors,
    options: options,
    source: source,
  );
  final parserSource = parserGenerator.generate();
  if (errors.isNotEmpty) {
    print('Errors were found while analyzing the grammar:');
    print(errors.join('\n\n'));
    exit(-1);
  }

  File(parserFilePath).writeAsStringSync(parserSource);
  final files = [parserFilePath];
  files.sort();
  await _format(files);
}

Future<void> _format(List<String> filenames) async {
  final process =
      await Process.start(Platform.executable, ['format', ...filenames]);
  unawaited(process.stdout.transform(utf8.decoder).forEach(print));
  unawaited(process.stderr.transform(utf8.decoder).forEach(print));
}

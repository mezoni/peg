import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final exitCodes = <Future<int>>[];
  const files = [
    'example/calc_parser.peg',
    'example/csv_parser.peg',
    'example/json_parser.peg',
  ];
  for (final file in files) {
    final process = await Process.start(Platform.executable, [
      'bin/peg.dart',
      '--async',
      file,
    ]);
    unawaited(process.stdout.transform(utf8.decoder).forEach(print));
    unawaited(process.stderr.transform(utf8.decoder).forEach(print));
    exitCodes.add(process.exitCode);
  }

  final results = await Future.wait(exitCodes);
  final failed = results.where((e) => e != 0);
  if (failed.isNotEmpty) {
    exit(failed.first);
  }
}

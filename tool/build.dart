import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final exitCodes = <Future<int>>[];
  const files = <String, List<String>>{
    'example/calc.peg': [],
    'example/csv.peg': ['--async'],
    'example/json.peg': ['--async'],
  };
  for (final file in files.entries) {
    final process = await Process.start(Platform.executable, [
      'bin/peg.dart',
      ...file.value,
      file.key,
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final exitCodes = <int>[];
  const files = <String, List<String>>{
    'example/calc.peg': ['--no-runtime'],
    'example/csv.peg': ['--async'],
    'example/json.peg': ['--async'],
  };
  for (final file in files.entries) {
    final process = await Process.start(Platform.executable, [
      'bin/peg.dart',
      ...file.value,
      file.key,
    ]);
    unawaited(process.stdout.transform(utf8.decoder).forEach(stdout.write));
    unawaited(process.stderr.transform(utf8.decoder).forEach(stderr.write));
    exitCodes.add(await process.exitCode);
  }

  final failed = exitCodes.where((e) => e != 0);
  if (failed.isNotEmpty) {
    exit(failed.first);
  }
}

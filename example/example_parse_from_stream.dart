import 'dart:async';

import 'csv_parser.dart';

Future<void> main() async {
  await _parse();
}

const _data = '''
John,Doe,120 jefferson st.,Riverside, NJ, 08075
Jack,McGinnis,220 hobo Av.,Phila, PA,09119
"John ""Da Man""",Repici,120 Jefferson St.,Riverside, NJ,08075
Stephen,Tyler,"7452 Terrace ""At the Plaza"" road",SomeTown,SD, 91234
,Blankman,,SomeTown, SD, 00298
"Joan ""the bone"", Anne",Jet,"9th, at Terrace plc",Desert City,CO,00123''';

Future<void> _parse() {
  final completer = Completer<void>();
  // The chunk size is 16 code units but can be anything from 1 code unit
  final stream = Stream.fromIterable(_toChunks(_data, 16));
  final parser = _MyCsvParser();
  final input = parseAsync(parser.parseStart$Async, (result) {
    try {
      result.getResult();
      completer.complete();
    } catch (e, s) {
      completer.completeError(e, s);
    }
  });
  stream.listen(input.add, onDone: input.close);
  return completer.future;
}

Iterable<String> _toChunks(String string, int size) sync* {
  final count = string.length ~/ size;
  final rest = string.length % size;
  for (var i = 0; i < count; i++) {
    final start = i * size;
    final value = string.substring(start, start + size);
    yield value;
  }

  if (rest != 0) {
    final start = count * size;
    final value = string.substring(start, start + rest);
    yield value;
  }
}

class _MyCsvParser extends CsvParser {
  @override
  void beginEvent(CsvParserEvent event) {
    //
  }

  @override
  R? endEvent<R>(CsvParserEvent event, R? result, bool ok) {
    if (ok && event == CsvParserEvent.rowEvent) {
      // Save one record to the database and free the memory from that record.
      print('Saving to database: $result');
      return const <String>[] as R;
    }

    return result;
  }
}

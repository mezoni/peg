import 'dart:async';

import 'json_parser.dart';

Future<void> main(List<String> args) async {
  await _exampleParseStreamWithEvents();
}

Stream<String> _createStream() {
  // Create the stream with 1000000 objects
  const count = 1000 * 1000;
  final controller = StreamController<String>();
  final sink = controller.sink;
  const object = '{ "firstName" : "John", "lastName" : "Doe", "age" : 41 }';
  const rowsInChunk = count ~/ 100;
  final chunk = List.generate(rowsInChunk, (i) => object).join(',');
  print('Total data amount ${object.length * count} code units.');
  print('The data will arrive in ${chunk.length} code unit chunks.');
  var i = 0;
  sink.add('[');
  Timer.periodic(Duration.zero, (timer) {
    sink.add(chunk);
    i += rowsInChunk;
    if (i < count) {
      sink.add(',');
    }

    if (i >= count) {
      sink.add(']');
      controller.close();
      timer.cancel();
    }
  });

  return controller.stream;
}

Future<void> _exampleParseStreamWithEvents() async {
  print('=========================');
  print('Start event-based streaming parsing JSON data');
  // Get external data
  final stream = _createStream();
  final parser = _MyParser();
  final completer = Completer<void>();
  final sw = Stopwatch();
  sw.start();
  final input = parseAsync(parser.parseStart$Async, (result) {
    sw.stop();
    print('Data processing complete in ${sw.elapsed}');
    try {
      final input = result.input;
      print('Max parsing buffer load: ${input.bufferLoad} code units');
      result.getResult();
      completer.complete();
    } catch (e, s) {
      completer.completeError(e, s);
    }
  });
  stream.listen(input.add, onDone: input.close);
  return completer.future;
}

class _MyParser extends JsonParser {
  int _count = 0;

  int _totalCount = 0;

  int _transactionCount = 0;

  final List<Map<String, Object?>> _object = [];

  @override
  void beginEvent(JsonParserEvent event) {
    if (event == JsonParserEvent.startEvent) {
      _count = 0;
      _totalCount = 0;
      _transactionCount = 0;
      _object.clear();
    }
  }

  @override
  R? endEvent<R>(JsonParserEvent event, R? result, bool ok) {
    if (ok) {
      switch (event) {
        case JsonParserEvent.objectEvent:
          final object = result as Map<String, Object?>;
          _object.add(object);
          if (_object.length > 10000) {
            _saveObjects(false);
          }

          // Free memory
          result = const <String, Object?>{} as R;
          break;
        case JsonParserEvent.startEvent:
          _saveObjects(true);
        default:
      }
    }

    return result;
  }

  void _saveObjects(bool isLast) {
    final rows = _object.toList();
    _object.clear();
    Timer.run(() async {
      await _saveToDatabase(rows, isLast);
    });
  }

  Future<void> _saveToDatabase(
      List<Map<String, Object?>> rows, bool isLast) async {
    _transactionCount++;
    _count += rows.length;
    _totalCount += rows.length;
    if (_count > 100000 || isLast) {
      print(
          'Saved to virtual database $_totalCount row(s) in $_transactionCount transaction(s)');
      _count = 0;
    }

    if (isLast) {
      print(
          'Totally saved to virtual database $_totalCount row(s) in $_transactionCount transaction(s)');
    }
  }
}

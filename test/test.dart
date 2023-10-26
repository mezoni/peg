import 'dart:async';

import 'package:test/test.dart';

import 'test_parser.dart';

void main() {
  _testOrderedChoiceWithLiterals();
  _testZeroOrMore();
}

final _parser = TestParser();

Future<void> __testFailure({
  required Set<ErrorMessage> errors,
  required int failPos,
  required void Function(State<String>) fastParse,
  required AsyncResult<Object?> Function(State<ChunkedParsingSink>)
      fastParseAsync,
  required Object? Function(State<String>) parse,
  required AsyncResult<Object?> Function(State<ChunkedParsingSink>) parseAsync,
  required int pos,
  required String source,
}) async {
  final input = source;
  final r1 = tryParse(fastParse, input);
  final r2 = tryParse(parse, input);
  final runes = source.runes.toList();
  final chunks = List.generate(
      source.runes.toList().length, (i) => String.fromCharCode(runes[i]));
  final stream1 = Stream.fromIterable(chunks);
  final stream2 = Stream.fromIterable(chunks);
  final r3 = await _parseChunkedData(fastParseAsync, stream1);
  final r4 = await _parseChunkedData(parseAsync, stream2);

  String errorToString(ParseError error) {
    return '$error.${error.length}';
  }

  final errors2 = errors.map(errorToString).toSet();
  expect(r1.errors.map(errorToString).toSet(), errors2,
      reason: 'fastParse, errors != $errors, source: "$source", $fastParse');
  expect(r2.errors.map(errorToString).toSet(), errors2,
      reason: 'parse, errors != $errors, source: "$source", $parse');
  expect(r3.errors.map(errorToString).toSet(), errors2,
      reason:
          'fastParseAsync, errors != $errors, source: "$source", $fastParseAsync');
  expect(r4.errors.map(errorToString).toSet(), errors2,
      reason: 'parseAsync, errors != $errors, source: "$source", $parseAsync');
  expect(r1.ok, false,
      reason: 'fastParse, ok != false, source: "$source", $fastParse');
  expect(r2.ok, false, reason: 'parse, ok != false, source: "$source", $parse');
  expect(r3.ok, false,
      reason:
          'fastParseAsync, ok != false, source: "$source", $fastParseAsync');
  expect(r4.ok, false,
      reason: 'parseAsync, ok != false, source: "$source", $parseAsync');
  expect(r1.pos, pos,
      reason: 'fastParse, pos != $pos, source: "$source", $fastParse');
  expect(r2.pos, pos, reason: 'parse, pos != $pos, source: "$source", $parse');
  expect(r3.pos, pos,
      reason:
          'fastParseAsync, pos != $pos, source: "$source", $fastParseAsync');
  expect(r4.pos, pos,
      reason: 'parseAsync, pos != $pos, source: "$source", $parseAsync');
  expect(r1.failPos, failPos,
      reason: 'fastParse, failPos != $failPos, source: "$source", $fastParse');
  expect(r2.failPos, failPos,
      reason: 'parse, failPos != $failPos, source: "$source", $parse');
  expect(r3.failPos, failPos,
      reason:
          'fastParseAsync, failPos != $failPos, source: "$source", $fastParseAsync');
  expect(r4.failPos, failPos,
      reason:
          'parseAsync, failPos != $failPos, source: "$source", $parseAsync');
}

Future<void> __testSuccess({
  required void Function(State<String>) fastParse,
  required Object? Function(State<String>) parse,
  required int pos,
  required Object? result,
  required String source,
}) async {
  final input = source;
  final r1 = tryParse(fastParse, input);
  final r2 = tryParse(parse, input);
  expect(r1.ok, true, reason: 'fastParse, ok != true, source: "$source"');
  expect(r2.ok, true, reason: 'parse, ok != true, source: "$source"');
  expect(r1.pos, pos, reason: 'fastParse, pos != $pos, source: "$source"');
  expect(r2.pos, pos, reason: 'parse, pos != $pos, source: "$source"');
  expect(r2.result, result,
      reason: 'parse, result != $result, source: "$source"');
}

Future<ParseResult<ChunkedParsingSink, R>> _parseChunkedData<R>(
  AsyncResult<R> Function(State<ChunkedParsingSink>) parse,
  Stream<String> stream,
) {
  final completer = Completer<ParseResult<ChunkedParsingSink, R>>();
  final input = parseAsync(parse, completer.complete);
  stream.listen(input.add, onDone: input.close);
  return completer.future;
}

void _testOrderedChoiceWithLiterals() {
  test('OrderedChoiceWithLiterals', () async {
    {
      // Optimized version
      const source = 'abc';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 3,
        result: 'abc',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'ab';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 2,
        result: 'ab',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'a';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 1,
        result: 'a',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'def';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 3,
        result: 'def',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'de';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 2,
        result: 'de',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'd';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 1,
        result: 'd',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'gh';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoiceWithLiterals,
        parse: _parser.parseOrderedChoiceWithLiterals,
        pos: 2,
        result: 'gh',
        source: source,
      );
    }
  });
}

void _testZeroOrMore() {
  test('ZeroOrMore', () async {
    {
      // Optimized version
      const source = 'abcEND';
      await __testSuccess(
        fastParse: _parser.fastParseSkipUntil,
        parse: _parser.parseSkipUntil,
        pos: 3,
        result: 'abc'.codeUnits,
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'abcE';
      await __testSuccess(
        fastParse: _parser.fastParseSkipTil,
        parse: _parser.parseSkipTil,
        pos: 3,
        result: 'abc'.codeUnits,
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'abcEND';
      await __testSuccess(
        fastParse: _parser.fastParseTakeUntil,
        parse: _parser.parseTakeUntil,
        pos: 3,
        result: 'abc',
        source: source,
      );
    }

    {
      // Optimized version
      const source = 'abcE';
      await __testSuccess(
        fastParse: _parser.fastParseTakeTil,
        parse: _parser.parseTakeTil,
        pos: 3,
        result: 'abc',
        source: source,
      );
    }
  });
}

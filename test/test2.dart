import 'dart:async';

import 'package:test/test.dart';

import 'test2_parser.dart';

void main() {
  _testAndPredicate();
  _testAnyCharacter();
  _testCharacterClass();
  _testCut();
  _testEof();
  _testErrorHandler();
  _testExpected();
  _testList();
  _testList1();
  _testLiteral();
  _testMatchString();
  _testNotPredicate();
  _testOneOrMore();
  _testOptional();
  _testOrderedChoice();
  _testRepetition();
  _testSequence();
  _testSlice();
  _testStringChars();
  _testVerify();
  _testZeroOrMore();
}

final _parser = Test2Parser();

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

  // TODO:
  final errors2 = errors.map((e) => '$e').toSet();
  expect(r1.errors.map((e) => '$e').toSet(), errors2,
      reason: 'fastParse, errors != $errors, source: "$source", $fastParse');
  expect(r2.errors.map((e) => '$e').toSet(), errors2,
      reason: 'parse, errors != $errors, source: "$source", $parse');
  expect(r3.errors.map((e) => '$e').toSet(), errors2,
      reason:
          'fastParseAsync, errors != $errors, source: "$source", $fastParseAsync');
  expect(r4.errors.map((e) => '$e').toSet(), errors2,
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
  required AsyncResult<Object?> Function(State<ChunkedParsingSink>)
      fastParseAsync,
  required Object? Function(State<String>) parse,
  required AsyncResult<Object?> Function(State<ChunkedParsingSink>) parseAsync,
  required int pos,
  required Object? result,
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
  expect(r1.ok, true,
      reason: 'fastParse, ok != true, source: "$source", $fastParse');
  expect(r2.ok, true, reason: 'parse, ok != true, source: "$source", $parse');
  expect(r3.ok, true,
      reason: 'fastParseAsync, ok != true, source: "$source", $fastParseAsync');
  expect(r4.ok, true,
      reason: 'parseAsync, ok != true, source: "$source", $parseAsync ');
  expect(r1.pos, pos,
      reason: 'fastParse, pos != $pos, source: "$source", $fastParse');
  expect(r2.pos, pos, reason: 'parse, pos != $pos, source: "$source", $parse');
  expect(r3.pos, pos,
      reason:
          'fastParseAsync, pos != $pos, source: "$source", $fastParseAsync');
  expect(r4.pos, pos,
      reason: 'parseAsync, pos != $pos, source: "$source", $parseAsync');
  expect(r2.result, result,
      reason: 'parse, result != $result, source: "$source", $parse');
  expect(r4.result, result,
      reason: 'parseAsync, result != $result, source: "$source", $parseAsync');
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

void _testAndPredicate() {
  test('AndPredicate', () async {
    {
      const source = '012';
      await __testSuccess(
        fastParse: _parser.fastParseAndPredicate,
        fastParseAsync: _parser.fastParseAndPredicate$Async,
        parse: _parser.parseAndPredicate,
        parseAsync: _parser.parseAndPredicate$Async,
        pos: 3,
        result: [
          [0x30, 0x31, 0x32],
          0x30,
          0x31,
          0x32
        ],
        source: source,
      );
    }

    {
      const source = '013';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 2),
        },
        failPos: 2,
        fastParse: _parser.fastParseAndPredicate,
        fastParseAsync: _parser.fastParseAndPredicate$Async,
        parse: _parser.parseAndPredicate,
        parseAsync: _parser.parseAndPredicate$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testAnyCharacter() {
  test('AnyCharacter', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseAnyCharacter,
        fastParseAsync: _parser.fastParseAnyCharacter$Async,
        parse: _parser.parseAnyCharacter,
        parseAsync: _parser.parseAnyCharacter$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseAnyCharacter,
        fastParseAsync: _parser.fastParseAnyCharacter$Async,
        parse: _parser.parseAnyCharacter,
        parseAsync: _parser.parseAnyCharacter$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseAnyCharacter,
        fastParseAsync: _parser.fastParseAnyCharacter$Async,
        parse: _parser.parseAnyCharacter,
        parseAsync: _parser.parseAnyCharacter$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testCharacterClass() {
  test('CharacterClass', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClass,
        fastParseAsync: _parser.fastParseCharacterClass$Async,
        parse: _parser.parseCharacterClass,
        parseAsync: _parser.parseCharacterClass$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClass,
        fastParseAsync: _parser.fastParseCharacterClass$Async,
        parse: _parser.parseCharacterClass,
        parseAsync: _parser.parseCharacterClass$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClass,
        fastParseAsync: _parser.fastParseCharacterClass$Async,
        parse: _parser.parseCharacterClass,
        parseAsync: _parser.parseCharacterClass$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClass,
        fastParseAsync: _parser.fastParseCharacterClass$Async,
        parse: _parser.parseCharacterClass,
        parseAsync: _parser.parseCharacterClass$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassChar32,
        fastParseAsync: _parser.fastParseCharacterClassChar32$Async,
        parse: _parser.parseCharacterClassChar32,
        parseAsync: _parser.parseCharacterClassChar32$Async,
        pos: 2,
        result: 0x1f680,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassChar32,
        fastParseAsync: _parser.fastParseCharacterClassChar32$Async,
        parse: _parser.parseCharacterClassChar32,
        parseAsync: _parser.parseCharacterClassChar32$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassChar32,
        fastParseAsync: _parser.fastParseCharacterClassChar32$Async,
        parse: _parser.parseCharacterClassChar32,
        parseAsync: _parser.parseCharacterClassChar32$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassCharNegate,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate$Async,
        parse: _parser.parseCharacterClassCharNegate,
        parseAsync: _parser.parseCharacterClassCharNegate$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassCharNegate,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate$Async,
        parse: _parser.parseCharacterClassCharNegate,
        parseAsync: _parser.parseCharacterClassCharNegate$Async,
        pos: 2,
        result: 0x1f680,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassCharNegate,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate$Async,
        parse: _parser.parseCharacterClassCharNegate,
        parseAsync: _parser.parseCharacterClassCharNegate$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassCharNegate32,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate32$Async,
        parse: _parser.parseCharacterClassCharNegate32,
        parseAsync: _parser.parseCharacterClassCharNegate32$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '🚁';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassCharNegate32,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate32$Async,
        parse: _parser.parseCharacterClassCharNegate32,
        parseAsync: _parser.parseCharacterClassCharNegate32$Async,
        pos: 2,
        result: 0x1f681,
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassCharNegate32,
        fastParseAsync: _parser.fastParseCharacterClassCharNegate32$Async,
        parse: _parser.parseCharacterClassCharNegate32,
        parseAsync: _parser.parseCharacterClassCharNegate32$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassRange32,
        fastParseAsync: _parser.fastParseCharacterClassRange32$Async,
        parse: _parser.parseCharacterClassRange32,
        parseAsync: _parser.parseCharacterClassRange32$Async,
        pos: 2,
        result: 0x1f680,
        source: source,
      );
    }

    {
      const source = ' ';
      await __testSuccess(
        fastParse: _parser.fastParseCharacterClassRange32,
        fastParseAsync: _parser.fastParseCharacterClassRange32$Async,
        parse: _parser.parseCharacterClassRange32,
        parseAsync: _parser.parseCharacterClassRange32$Async,
        pos: 1,
        result: ' '.runeAt(0),
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassRange32,
        fastParseAsync: _parser.fastParseCharacterClassRange32$Async,
        parse: _parser.parseCharacterClassRange32,
        parseAsync: _parser.parseCharacterClassRange32$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '\n';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCharacterClassRange32,
        fastParseAsync: _parser.fastParseCharacterClassRange32$Async,
        parse: _parser.parseCharacterClassRange32,
        parseAsync: _parser.parseCharacterClassRange32$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testCut() {
  test('Cut', () async {
    {
      const source = '0+1';
      await __testSuccess(
        fastParse: _parser.fastParseCut,
        fastParseAsync: _parser.fastParseCut$Async,
        parse: _parser.parseCut,
        parseAsync: _parser.parseCut$Async,
        pos: 3,
        result: [0x30, 0x2b, null, 0x31],
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseCut,
        fastParseAsync: _parser.fastParseCut$Async,
        parse: _parser.parseCut,
        parseAsync: _parser.parseCut$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '0+';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 2),
        },
        failPos: 2,
        fastParse: _parser.fastParseCut,
        fastParseAsync: _parser.fastParseCut$Async,
        parse: _parser.parseCut,
        parseAsync: _parser.parseCut$Async,
        pos: 2,
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseCut1,
        fastParseAsync: _parser.fastParseCut1$Async,
        parse: _parser.parseCut1,
        parseAsync: _parser.parseCut1$Async,
        pos: 1,
        result: [0x30, null],
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseCut1,
        fastParseAsync: _parser.fastParseCut1$Async,
        parse: _parser.parseCut1,
        parseAsync: _parser.parseCut1$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseCut1,
        fastParseAsync: _parser.fastParseCut1$Async,
        parse: _parser.parseCut1,
        parseAsync: _parser.parseCut1$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a1';
      await __testSuccess(
        fastParse: _parser.fastParseCutWithInner,
        fastParseAsync: _parser.fastParseCutWithInner$Async,
        parse: _parser.parseCutWithInner,
        parseAsync: _parser.parseCutWithInner$Async,
        pos: 3,
        result: [0x30, null, 0x61, 0x31],
        source: source,
      );
    }

    {
      const source = '0b1';
      await __testSuccess(
        fastParse: _parser.fastParseCutWithInner,
        fastParseAsync: _parser.fastParseCutWithInner$Async,
        parse: _parser.parseCutWithInner,
        parseAsync: _parser.parseCutWithInner$Async,
        pos: 3,
        result: [0x30, null, 0x62, 0x31],
        source: source,
      );
    }
  });
}

void _testEof() {
  test('Eof', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseEof,
        fastParseAsync: _parser.fastParseEof$Async,
        parse: _parser.parseEof,
        parseAsync: _parser.parseEof$Async,
        pos: 1,
        result: [0x30, null],
        source: source,
      );
    }

    {
      const source = '01';
      await __testFailure(
        errors: {
          ErrorExpectedEndOfInput().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseEof,
        fastParseAsync: _parser.fastParseEof$Async,
        parse: _parser.parseEof,
        parseAsync: _parser.parseEof$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testErrorHandler() {
  test('ErrorHandler', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseErrorHandler,
        fastParseAsync: _parser.fastParseErrorHandler$Async,
        parse: _parser.parseErrorHandler,
        parseAsync: _parser.parseErrorHandler$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testFailure(
        errors: {
          ErrorMessage(0, 'error'),
        },
        failPos: 0,
        fastParse: _parser.fastParseErrorHandler,
        fastParseAsync: _parser.fastParseErrorHandler$Async,
        parse: _parser.parseErrorHandler,
        parseAsync: _parser.parseErrorHandler$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testExpected() {
  test('Expected', () async {
    {
      const source = '012';
      await __testSuccess(
        fastParse: _parser.fastParseExpected,
        fastParseAsync: _parser.fastParseExpected$Async,
        parse: _parser.parseExpected,
        parseAsync: _parser.parseExpected$Async,
        pos: 3,
        result: [0x30, 0x31, 0x32],
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorExpectedTags(['digits']).getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseExpected,
        fastParseAsync: _parser.fastParseExpected$Async,
        parse: _parser.parseExpected,
        parseAsync: _parser.parseExpected$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseExpected,
        fastParseAsync: _parser.fastParseExpected$Async,
        parse: _parser.parseExpected,
        parseAsync: _parser.parseExpected$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testList() {
  test('List', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseList,
        fastParseAsync: _parser.fastParseList$Async,
        parse: _parser.parseList,
        parseAsync: _parser.parseList$Async,
        pos: 0,
        result: [],
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseList,
        fastParseAsync: _parser.fastParseList$Async,
        parse: _parser.parseList,
        parseAsync: _parser.parseList$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }

    {
      const source = '0,0';
      await __testSuccess(
        fastParse: _parser.fastParseList,
        fastParseAsync: _parser.fastParseList$Async,
        parse: _parser.parseList,
        parseAsync: _parser.parseList$Async,
        pos: 3,
        result: [0x30, 0x30],
        source: source,
      );
    }

    {
      const source = '0,';
      await __testSuccess(
        fastParse: _parser.fastParseList,
        fastParseAsync: _parser.fastParseList$Async,
        parse: _parser.parseList,
        parseAsync: _parser.parseList$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }
  });
}

void _testList1() {
  test('List1', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseList1,
        fastParseAsync: _parser.fastParseList1$Async,
        parse: _parser.parseList1,
        parseAsync: _parser.parseList1$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }

    {
      const source = '0,0';
      await __testSuccess(
        fastParse: _parser.fastParseList1,
        fastParseAsync: _parser.fastParseList1$Async,
        parse: _parser.parseList1,
        parseAsync: _parser.parseList1$Async,
        pos: 3,
        result: [0x30, 0x30],
        source: source,
      );
    }

    {
      const source = '0,';
      await __testSuccess(
        fastParse: _parser.fastParseList1,
        fastParseAsync: _parser.fastParseList1$Async,
        parse: _parser.parseList1,
        parseAsync: _parser.parseList1$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseList1,
        fastParseAsync: _parser.fastParseList1$Async,
        parse: _parser.parseList1,
        parseAsync: _parser.parseList1$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testLiteral() {
  test('Literal', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseLiteral0,
        fastParseAsync: _parser.fastParseLiteral0$Async,
        parse: _parser.parseLiteral0,
        parseAsync: _parser.parseLiteral0$Async,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseLiteral1,
        fastParseAsync: _parser.fastParseLiteral1$Async,
        parse: _parser.parseLiteral1,
        parseAsync: _parser.parseLiteral1$Async,
        pos: 1,
        result: '0',
        source: source,
      );
    }

    {
      const source = '1';
      await __testFailure(
        errors: {
          ErrorExpectedTags(['0']).getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseLiteral1,
        fastParseAsync: _parser.fastParseLiteral1$Async,
        parse: _parser.parseLiteral1,
        parseAsync: _parser.parseLiteral1$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseLiteral2,
        fastParseAsync: _parser.fastParseLiteral2$Async,
        parse: _parser.parseLiteral2,
        parseAsync: _parser.parseLiteral2$Async,
        pos: 2,
        result: '01',
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorExpectedTags(['01']).getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseLiteral2,
        fastParseAsync: _parser.fastParseLiteral2$Async,
        parse: _parser.parseLiteral2,
        parseAsync: _parser.parseLiteral2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '012';
      await __testSuccess(
        fastParse: _parser.fastParseLiterals,
        fastParseAsync: _parser.fastParseLiterals$Async,
        parse: _parser.parseLiterals,
        parseAsync: _parser.parseLiterals$Async,
        pos: 3,
        result: '012',
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseLiterals,
        fastParseAsync: _parser.fastParseLiterals$Async,
        parse: _parser.parseLiterals,
        parseAsync: _parser.parseLiterals$Async,
        pos: 2,
        result: '01',
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorExpectedTags(['01', '012']).getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseLiterals,
        fastParseAsync: _parser.fastParseLiterals$Async,
        parse: _parser.parseLiterals,
        parseAsync: _parser.parseLiterals$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testMatchString() {
  test('MatchString', () async {
    {
      const source = '';
      _parser.text = '';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        fastParseAsync: _parser.fastParseMatchString$Async,
        parse: _parser.parseMatchString,
        parseAsync: _parser.parseMatchString$Async,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = '0';
      _parser.text = '0';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        fastParseAsync: _parser.fastParseMatchString$Async,
        parse: _parser.parseMatchString,
        parseAsync: _parser.parseMatchString$Async,
        pos: 1,
        result: '0',
        source: source,
      );
    }

    {
      const source = '01';
      _parser.text = '01';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        fastParseAsync: _parser.fastParseMatchString$Async,
        parse: _parser.parseMatchString,
        parseAsync: _parser.parseMatchString$Async,
        pos: 2,
        result: '01',
        source: source,
      );
    }

    {
      const source = '0';
      _parser.text = '1';
      await __testFailure(
        errors: {
          ErrorExpectedTags(['1']).getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseMatchString,
        fastParseAsync: _parser.fastParseMatchString$Async,
        parse: _parser.parseMatchString,
        parseAsync: _parser.parseMatchString$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testNotPredicate() {
  test('NotPredicate', () async {
    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseNotPredicate,
        fastParseAsync: _parser.fastParseNotPredicate$Async,
        parse: _parser.parseNotPredicate,
        parseAsync: _parser.parseNotPredicate$Async,
        pos: 2,
        result: [null, 0x30, 0x31],
        source: source,
      );
    }

    {
      const source = '012';
      await __testFailure(
        errors: {ErrorUnexpectedInput(3).getErrorMessage(source, 0)},
        failPos: 3,
        fastParse: _parser.fastParseNotPredicate,
        fastParseAsync: _parser.fastParseNotPredicate$Async,
        parse: _parser.parseNotPredicate,
        parseAsync: _parser.parseNotPredicate$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testOneOrMore() {
  test('OneOrMore', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseOneOrMore,
        fastParseAsync: _parser.fastParseOneOrMore$Async,
        parse: _parser.parseOneOrMore,
        parseAsync: _parser.parseOneOrMore$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }

    {
      const source = '00';
      await __testSuccess(
        fastParse: _parser.fastParseOneOrMore,
        fastParseAsync: _parser.fastParseOneOrMore$Async,
        parse: _parser.parseOneOrMore,
        parseAsync: _parser.parseOneOrMore$Async,
        pos: 2,
        result: [0x30, 0x30],
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseOneOrMore,
        fastParseAsync: _parser.fastParseOneOrMore$Async,
        parse: _parser.parseOneOrMore,
        parseAsync: _parser.parseOneOrMore$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testOptional() {
  test('Optional', () async {
    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseOptional,
        fastParseAsync: _parser.fastParseOptional$Async,
        parse: _parser.parseOptional,
        parseAsync: _parser.parseOptional$Async,
        pos: 2,
        result: [0x30, 0x31],
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseOptional,
        fastParseAsync: _parser.fastParseOptional$Async,
        parse: _parser.parseOptional,
        parseAsync: _parser.parseOptional$Async,
        pos: 1,
        result: [null, 0x31],
        source: source,
      );
    }
  });
}

void _testOrderedChoice() {
  test('OrderedChoice', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoice2,
        fastParseAsync: _parser.fastParseOrderedChoice2$Async,
        parse: _parser.parseOrderedChoice2,
        parseAsync: _parser.parseOrderedChoice2$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoice2,
        fastParseAsync: _parser.fastParseOrderedChoice2$Async,
        parse: _parser.parseOrderedChoice2,
        parseAsync: _parser.parseOrderedChoice2$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseOrderedChoice2,
        fastParseAsync: _parser.fastParseOrderedChoice2$Async,
        parse: _parser.parseOrderedChoice2,
        parseAsync: _parser.parseOrderedChoice2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseOrderedChoice2,
        fastParseAsync: _parser.fastParseOrderedChoice2$Async,
        parse: _parser.parseOrderedChoice2,
        parseAsync: _parser.parseOrderedChoice2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoice3,
        fastParseAsync: _parser.fastParseOrderedChoice3$Async,
        parse: _parser.parseOrderedChoice3,
        parseAsync: _parser.parseOrderedChoice3$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoice3,
        fastParseAsync: _parser.fastParseOrderedChoice3$Async,
        parse: _parser.parseOrderedChoice3,
        parseAsync: _parser.parseOrderedChoice3$Async,
        pos: 1,
        result: 0x31,
        source: source,
      );
    }

    {
      const source = '2';
      await __testSuccess(
        fastParse: _parser.fastParseOrderedChoice3,
        fastParseAsync: _parser.fastParseOrderedChoice3$Async,
        parse: _parser.parseOrderedChoice3,
        parseAsync: _parser.parseOrderedChoice3$Async,
        pos: 1,
        result: 0x32,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseOrderedChoice3,
        fastParseAsync: _parser.fastParseOrderedChoice3$Async,
        parse: _parser.parseOrderedChoice3,
        parseAsync: _parser.parseOrderedChoice3$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseOrderedChoice3,
        fastParseAsync: _parser.fastParseOrderedChoice3$Async,
        parse: _parser.parseOrderedChoice3,
        parseAsync: _parser.parseOrderedChoice3$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testRepetition() {
  test('Repetition', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMax,
        fastParseAsync: _parser.fastParseRepetitionMax$Async,
        parse: _parser.parseRepetitionMax,
        parseAsync: _parser.parseRepetitionMax$Async,
        pos: 0,
        result: [],
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMax,
        fastParseAsync: _parser.fastParseRepetitionMax$Async,
        parse: _parser.parseRepetitionMax,
        parseAsync: _parser.parseRepetitionMax$Async,
        pos: 2,
        result: [0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMax,
        fastParseAsync: _parser.fastParseRepetitionMax$Async,
        parse: _parser.parseRepetitionMax,
        parseAsync: _parser.parseRepetitionMax$Async,
        pos: 4,
        result: [0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMax,
        fastParseAsync: _parser.fastParseRepetitionMax$Async,
        parse: _parser.parseRepetitionMax,
        parseAsync: _parser.parseRepetitionMax$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMax,
        fastParseAsync: _parser.fastParseRepetitionMax$Async,
        parse: _parser.parseRepetitionMax,
        parseAsync: _parser.parseRepetitionMax$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMin,
        fastParseAsync: _parser.fastParseRepetitionMin$Async,
        parse: _parser.parseRepetitionMin,
        parseAsync: _parser.parseRepetitionMin$Async,
        pos: 8,
        result: [0x1f680, 0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMin,
        fastParseAsync: _parser.fastParseRepetitionMin$Async,
        parse: _parser.parseRepetitionMin,
        parseAsync: _parser.parseRepetitionMin$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 4),
        },
        failPos: 4,
        fastParse: _parser.fastParseRepetitionMin,
        fastParseAsync: _parser.fastParseRepetitionMin$Async,
        parse: _parser.parseRepetitionMin,
        parseAsync: _parser.parseRepetitionMin$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseRepetitionMin,
        fastParseAsync: _parser.fastParseRepetitionMin$Async,
        parse: _parser.parseRepetitionMin,
        parseAsync: _parser.parseRepetitionMin$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMinMax,
        fastParseAsync: _parser.fastParseRepetitionMinMax$Async,
        parse: _parser.parseRepetitionMinMax,
        parseAsync: _parser.parseRepetitionMinMax$Async,
        pos: 4,
        result: [0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMinMax,
        fastParseAsync: _parser.fastParseRepetitionMinMax$Async,
        parse: _parser.parseRepetitionMinMax,
        parseAsync: _parser.parseRepetitionMinMax$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionMinMax,
        fastParseAsync: _parser.fastParseRepetitionMinMax$Async,
        parse: _parser.parseRepetitionMinMax,
        parseAsync: _parser.parseRepetitionMinMax$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 2,
        fastParse: _parser.fastParseRepetitionMinMax,
        fastParseAsync: _parser.fastParseRepetitionMinMax$Async,
        parse: _parser.parseRepetitionMinMax,
        parseAsync: _parser.parseRepetitionMinMax$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseRepetitionMinMax,
        fastParseAsync: _parser.fastParseRepetitionMinMax$Async,
        parse: _parser.parseRepetitionMinMax,
        parseAsync: _parser.parseRepetitionMinMax$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionN,
        fastParseAsync: _parser.fastParseRepetitionN$Async,
        parse: _parser.parseRepetitionN,
        parseAsync: _parser.parseRepetitionN$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀🚀';
      await __testSuccess(
        fastParse: _parser.fastParseRepetitionN,
        fastParseAsync: _parser.fastParseRepetitionN$Async,
        parse: _parser.parseRepetitionN,
        parseAsync: _parser.parseRepetitionN$Async,
        pos: 6,
        result: [0x1f680, 0x1f680, 0x1f680],
        source: source,
      );
    }

    {
      const source = '🚀🚀';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 4,
        fastParse: _parser.fastParseRepetitionN,
        fastParseAsync: _parser.fastParseRepetitionN$Async,
        parse: _parser.parseRepetitionN,
        parseAsync: _parser.parseRepetitionN$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseRepetitionN,
        fastParseAsync: _parser.fastParseRepetitionN$Async,
        parse: _parser.parseRepetitionN,
        parseAsync: _parser.parseRepetitionN$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testSequence() {
  test('Sequence', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseSequence1,
        fastParseAsync: _parser.fastParseSequence1$Async,
        parse: _parser.parseSequence1,
        parseAsync: _parser.parseSequence1$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1,
        fastParseAsync: _parser.fastParseSequence1$Async,
        parse: _parser.parseSequence1,
        parseAsync: _parser.parseSequence1$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1,
        fastParseAsync: _parser.fastParseSequence1$Async,
        parse: _parser.parseSequence1,
        parseAsync: _parser.parseSequence1$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseSequence1WithAction,
        fastParseAsync: _parser.fastParseSequence1WithAction$Async,
        parse: _parser.parseSequence1WithAction,
        parseAsync: _parser.parseSequence1WithAction$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithAction,
        fastParseAsync: _parser.fastParseSequence1WithAction$Async,
        parse: _parser.parseSequence1WithAction,
        parseAsync: _parser.parseSequence1WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithAction,
        fastParseAsync: _parser.fastParseSequence1WithAction$Async,
        parse: _parser.parseSequence1WithAction,
        parseAsync: _parser.parseSequence1WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseSequence1WithVariable,
        fastParseAsync: _parser.fastParseSequence1WithVariable$Async,
        parse: _parser.parseSequence1WithVariable,
        parseAsync: _parser.parseSequence1WithVariable$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithVariable,
        fastParseAsync: _parser.fastParseSequence1WithVariable$Async,
        parse: _parser.parseSequence1WithVariable,
        parseAsync: _parser.parseSequence1WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithVariable,
        fastParseAsync: _parser.fastParseSequence1WithVariable$Async,
        parse: _parser.parseSequence1WithVariable,
        parseAsync: _parser.parseSequence1WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseSequence1WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence1WithVariableWithAction$Async,
        parse: _parser.parseSequence1WithVariableWithAction,
        parseAsync: _parser.parseSequence1WithVariableWithAction$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence1WithVariableWithAction$Async,
        parse: _parser.parseSequence1WithVariableWithAction,
        parseAsync: _parser.parseSequence1WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence1WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence1WithVariableWithAction$Async,
        parse: _parser.parseSequence1WithVariableWithAction,
        parseAsync: _parser.parseSequence1WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2,
        fastParseAsync: _parser.fastParseSequence2$Async,
        parse: _parser.parseSequence2,
        parseAsync: _parser.parseSequence2$Async,
        pos: 2,
        result: [0x30, 0x31],
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2,
        fastParseAsync: _parser.fastParseSequence2$Async,
        parse: _parser.parseSequence2,
        parseAsync: _parser.parseSequence2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2,
        fastParseAsync: _parser.fastParseSequence2$Async,
        parse: _parser.parseSequence2,
        parseAsync: _parser.parseSequence2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2,
        fastParseAsync: _parser.fastParseSequence2$Async,
        parse: _parser.parseSequence2,
        parseAsync: _parser.parseSequence2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2,
        fastParseAsync: _parser.fastParseSequence2$Async,
        parse: _parser.parseSequence2,
        parseAsync: _parser.parseSequence2$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2WithAction,
        fastParseAsync: _parser.fastParseSequence2WithAction$Async,
        parse: _parser.parseSequence2WithAction,
        parseAsync: _parser.parseSequence2WithAction$Async,
        pos: 2,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithAction,
        fastParseAsync: _parser.fastParseSequence2WithAction$Async,
        parse: _parser.parseSequence2WithAction,
        parseAsync: _parser.parseSequence2WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithAction,
        fastParseAsync: _parser.fastParseSequence2WithAction$Async,
        parse: _parser.parseSequence2WithAction,
        parseAsync: _parser.parseSequence2WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithAction,
        fastParseAsync: _parser.fastParseSequence2WithAction$Async,
        parse: _parser.parseSequence2WithAction,
        parseAsync: _parser.parseSequence2WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithAction,
        fastParseAsync: _parser.fastParseSequence2WithAction$Async,
        parse: _parser.parseSequence2WithAction,
        parseAsync: _parser.parseSequence2WithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2WithVariable,
        fastParseAsync: _parser.fastParseSequence2WithVariable$Async,
        parse: _parser.parseSequence2WithVariable,
        parseAsync: _parser.parseSequence2WithVariable$Async,
        pos: 2,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariable,
        fastParseAsync: _parser.fastParseSequence2WithVariable$Async,
        parse: _parser.parseSequence2WithVariable,
        parseAsync: _parser.parseSequence2WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariable,
        fastParseAsync: _parser.fastParseSequence2WithVariable$Async,
        parse: _parser.parseSequence2WithVariable,
        parseAsync: _parser.parseSequence2WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariable,
        fastParseAsync: _parser.fastParseSequence2WithVariable$Async,
        parse: _parser.parseSequence2WithVariable,
        parseAsync: _parser.parseSequence2WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariable,
        fastParseAsync: _parser.fastParseSequence2WithVariable$Async,
        parse: _parser.parseSequence2WithVariable,
        parseAsync: _parser.parseSequence2WithVariable$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariableWithAction$Async,
        parse: _parser.parseSequence2WithVariableWithAction,
        parseAsync: _parser.parseSequence2WithVariableWithAction$Async,
        pos: 2,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariableWithAction$Async,
        parse: _parser.parseSequence2WithVariableWithAction,
        parseAsync: _parser.parseSequence2WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariableWithAction$Async,
        parse: _parser.parseSequence2WithVariableWithAction,
        parseAsync: _parser.parseSequence2WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariableWithAction$Async,
        parse: _parser.parseSequence2WithVariableWithAction,
        parseAsync: _parser.parseSequence2WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariableWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariableWithAction$Async,
        parse: _parser.parseSequence2WithVariableWithAction,
        parseAsync: _parser.parseSequence2WithVariableWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2WithVariables,
        fastParseAsync: _parser.fastParseSequence2WithVariables$Async,
        parse: _parser.parseSequence2WithVariables,
        parseAsync: _parser.parseSequence2WithVariables$Async,
        pos: 2,
        result: (v1: 0x30, v2: 0x31),
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariables,
        fastParseAsync: _parser.fastParseSequence2WithVariables$Async,
        parse: _parser.parseSequence2WithVariables,
        parseAsync: _parser.parseSequence2WithVariables$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariables,
        fastParseAsync: _parser.fastParseSequence2WithVariables$Async,
        parse: _parser.parseSequence2WithVariables,
        parseAsync: _parser.parseSequence2WithVariables$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariables,
        fastParseAsync: _parser.fastParseSequence2WithVariables$Async,
        parse: _parser.parseSequence2WithVariables,
        parseAsync: _parser.parseSequence2WithVariables$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariables,
        fastParseAsync: _parser.fastParseSequence2WithVariables$Async,
        parse: _parser.parseSequence2WithVariables,
        parseAsync: _parser.parseSequence2WithVariables$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSequence2WithVariablesWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariablesWithAction$Async,
        parse: _parser.parseSequence2WithVariablesWithAction,
        parseAsync: _parser.parseSequence2WithVariablesWithAction$Async,
        pos: 2,
        result: 0x30 + 0x31,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariablesWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariablesWithAction$Async,
        parse: _parser.parseSequence2WithVariablesWithAction,
        parseAsync: _parser.parseSequence2WithVariablesWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSequence2WithVariablesWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariablesWithAction$Async,
        parse: _parser.parseSequence2WithVariablesWithAction,
        parseAsync: _parser.parseSequence2WithVariablesWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariablesWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariablesWithAction$Async,
        parse: _parser.parseSequence2WithVariablesWithAction,
        parseAsync: _parser.parseSequence2WithVariablesWithAction$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 1),
        },
        failPos: 1,
        fastParse: _parser.fastParseSequence2WithVariablesWithAction,
        fastParseAsync: _parser.fastParseSequence2WithVariablesWithAction$Async,
        parse: _parser.parseSequence2WithVariablesWithAction,
        parseAsync: _parser.parseSequence2WithVariablesWithAction$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testSlice() {
  test('Slice', () async {
    {
      const source = '012';
      await __testSuccess(
        fastParse: _parser.fastParseSlice,
        fastParseAsync: _parser.fastParseSlice$Async,
        parse: _parser.parseSlice,
        parseAsync: _parser.parseSlice$Async,
        pos: 3,
        result: '012',
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseSlice,
        fastParseAsync: _parser.fastParseSlice$Async,
        parse: _parser.parseSlice,
        parseAsync: _parser.parseSlice$Async,
        pos: 2,
        result: '01',
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSlice,
        fastParseAsync: _parser.fastParseSlice$Async,
        parse: _parser.parseSlice,
        parseAsync: _parser.parseSlice$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'a';
      await __testFailure(
        errors: {
          ErrorUnexpectedCharacter().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseSlice,
        fastParseAsync: _parser.fastParseSlice$Async,
        parse: _parser.parseSlice,
        parseAsync: _parser.parseSlice$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '0';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 1,
        fastParse: _parser.fastParseSlice,
        fastParseAsync: _parser.fastParseSlice$Async,
        parse: _parser.parseSlice,
        parseAsync: _parser.parseSlice$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testStringChars() {
  test('StringChars', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 1,
        result: '0',
        source: source,
      );
    }

    {
      const source = '01';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 2,
        result: '01',
        source: source,
      );
    }

    {
      const source = r'\t';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 2,
        result: '\t',
        source: source,
      );
    }

    {
      const source = r'\t\t';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 4,
        result: '\t\t',
        source: source,
      );
    }

    {
      const source = r'0\t';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 3,
        result: '0\t',
        source: source,
      );
    }

    {
      const source = r'01\t';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 4,
        result: '01\t',
        source: source,
      );
    }

    {
      const source = r'0\t1';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 4,
        result: '0\t1',
        source: source,
      );
    }

    {
      const source = r'0\t10';
      await __testSuccess(
        fastParse: _parser.fastParseStringChars,
        fastParseAsync: _parser.fastParseStringChars$Async,
        parse: _parser.parseStringChars,
        parseAsync: _parser.parseStringChars$Async,
        pos: 5,
        result: '0\t10',
        source: source,
      );
    }
  });
}

void _testVerify() {
  test('Verify', () async {
    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseVerify,
        fastParseAsync: _parser.fastParseVerify$Async,
        parse: _parser.parseVerify,
        parseAsync: _parser.parseVerify$Async,
        pos: 1,
        result: 0x30,
        source: source,
      );
    }

    {
      const source = '1';
      await __testFailure(
        errors: {
          ErrorMessage(0, 'error'),
        },
        failPos: 0,
        fastParse: _parser.fastParseVerify,
        fastParseAsync: _parser.fastParseVerify$Async,
        parse: _parser.parseVerify,
        parseAsync: _parser.parseVerify$Async,
        pos: 0,
        source: source,
      );
    }

    {
      const source = '';
      await __testFailure(
        errors: {
          ErrorUnexpectedEndOfInput().getErrorMessage(source, 0),
        },
        failPos: 0,
        fastParse: _parser.fastParseVerify,
        fastParseAsync: _parser.fastParseVerify$Async,
        parse: _parser.parseVerify,
        parseAsync: _parser.parseVerify$Async,
        pos: 0,
        source: source,
      );
    }
  });
}

void _testZeroOrMore() {
  test('ZeroOrMore', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseZeroOrMore,
        fastParseAsync: _parser.fastParseZeroOrMore$Async,
        parse: _parser.parseZeroOrMore,
        parseAsync: _parser.parseZeroOrMore$Async,
        pos: 0,
        result: [],
        source: source,
      );
    }

    {
      const source = '0';
      await __testSuccess(
        fastParse: _parser.fastParseZeroOrMore,
        fastParseAsync: _parser.fastParseZeroOrMore$Async,
        parse: _parser.parseZeroOrMore,
        parseAsync: _parser.parseZeroOrMore$Async,
        pos: 1,
        result: [0x30],
        source: source,
      );
    }

    {
      const source = '00';
      await __testSuccess(
        fastParse: _parser.fastParseZeroOrMore,
        fastParseAsync: _parser.fastParseZeroOrMore$Async,
        parse: _parser.parseZeroOrMore,
        parseAsync: _parser.parseZeroOrMore$Async,
        pos: 2,
        result: [0x30, 0x30],
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseZeroOrMore,
        fastParseAsync: _parser.fastParseZeroOrMore$Async,
        parse: _parser.parseZeroOrMore,
        parseAsync: _parser.parseZeroOrMore$Async,
        pos: 0,
        result: [],
        source: source,
      );
    }
  });
}

import 'package:test/test.dart';

import 'test_parser.dart';

void main() {
  _testMatchString();
  _testOrderedChoiceWithLiterals();
  _testSepBy();
  _testVerify();
  _testZeroOrMore();
}

final _parser = TestParser();

Future<void> __testFailure({
  required Set<ErrorMessage> errors,
  required int failPos,
  required void Function(State<String>) fastParse,
  required Object? Function(State<String>) parse,
  required int pos,
  required String source,
}) async {
  final input = source;
  final r1 = tryParse(fastParse, input);
  final r2 = tryParse(parse, input);
  expect(r1.ok, false, reason: 'fastParse, ok != false, source: "$source"');
  expect(r2.ok, false, reason: 'parse, ok != false, source: "$source"');
  expect(r1.pos, pos, reason: 'fastParse, pos != $pos, source: "$source"');
  expect(r2.pos, pos, reason: 'parse, pos != $pos, source: "$source"');
  expect(r1.failPos, failPos,
      reason: 'fastParse, failPos != $failPos, source: "$source"');
  expect(r2.failPos, failPos,
      reason: 'parse, failPos != $failPos, source: "$source"');
  // TODO:
  final errors2 = errors.map((e) => '$e').toSet();
  expect(r1.errors.map((e) => '$e').toSet(), errors2,
      reason: 'fastParse, errors != $errors, source: "$source"');
  expect(errors.map((e) => '$e').toSet(), errors2,
      reason: 'parse, errors != $errors, source: "$source"');
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

void _testMatchString() {
  test('MatchString', () async {
    {
      const source = 'abc123';
      _parser.text = 'abc';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        parse: _parser.parseMatchString,
        pos: 3,
        result: 'abc',
        source: source,
      );
    }

    {
      const source = 'abc123';
      _parser.text = '';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        parse: _parser.parseMatchString,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = '';
      _parser.text = '';
      await __testSuccess(
        fastParse: _parser.fastParseMatchString,
        parse: _parser.parseMatchString,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = 'abc';
      _parser.text = '123';
      await __testFailure(
        errors: {
          const ErrorMessage(0, "Expected: '123'"),
        },
        failPos: 0,
        fastParse: _parser.fastParseMatchString,
        parse: _parser.parseMatchString,
        pos: 0,
        source: source,
      );
    }
  });
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

void _testSepBy() {
  test('SepBy', () async {
    {
      const source = '';
      await __testSuccess(
        fastParse: _parser.fastParseSepBy,
        parse: _parser.parseSepBy,
        pos: 0,
        result: <int>[],
        source: source,
      );
    }

    {
      const source = '1';
      await __testSuccess(
        fastParse: _parser.fastParseSepBy,
        parse: _parser.parseSepBy,
        pos: 1,
        result: [1],
        source: source,
      );
    }

    {
      const source = '1,2';
      await __testSuccess(
        fastParse: _parser.fastParseSepBy,
        parse: _parser.parseSepBy,
        pos: 3,
        result: [1, 2],
        source: source,
      );
    }

    {
      const source = '1,';
      await __testSuccess(
        fastParse: _parser.fastParseSepBy,
        parse: _parser.parseSepBy,
        pos: 1,
        result: [1],
        source: source,
      );
    }
  });
}

void _testVerify() {
  test('Verify', () async {
    {
      const source = '41abc';
      await __testSuccess(
        fastParse: _parser.fastParseVerify41,
        parse: _parser.parseVerify41,
        pos: 2,
        result: 41,
        source: source,
      );
    }

    {
      const source = '40abc';
      await __testFailure(
        errors: {
          const ErrorMessage(2, 'error'),
        },
        failPos: 0,
        fastParse: _parser.fastParseVerify41,
        parse: _parser.parseVerify41,
        pos: 0,
        source: source,
      );
    }

    {
      const source = 'abc';
      _parser.flag = true;
      await __testSuccess(
        fastParse: _parser.fastParseVerifyFlag,
        parse: _parser.parseVerifyFlag,
        pos: 0,
        result: '',
        source: source,
      );
    }

    {
      const source = 'abc';
      _parser.flag = false;
      await __testFailure(
        errors: {
          const ErrorMessage(0, 'error'),
        },
        failPos: 0,
        fastParse: _parser.fastParseVerifyFlag,
        parse: _parser.parseVerifyFlag,
        pos: 0,
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

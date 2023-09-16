import 'package:test/test.dart';

import 'test_parser.dart';

void main() {
  _testAndPredicateAction();
  _testOneOrMore();
  _testZeroOrMore();
}

final _parser = TestParser();

void _testAndPredicateAction() {
  test('AndPredicateAction', () async {
    {
      const source = '41';
      _parser.flag = true;
      await _testSuccess(
        fastParse: _parser.fastParseAndPredicateAction,
        parse: _parser.parseAndPredicateAction,
        pos: 2,
        result: 41,
        source: source,
      );
    }

    {
      const source = '41';
      _parser.flag = false;
      await _testFailure(
        errors: {ErrorMessage(0, 'error')},
        failPos: 0,
        fastParse: _parser.fastParseAndPredicateAction,
        parse: _parser.parseAndPredicateAction,
        pos: 0,
        source: source,
      );
    }
  });
}

Future<void> _testFailure({
  required Set<ErrorMessage> errors,
  required int failPos,
  required void Function(State<StringReader>) fastParse,
  required Object? Function(State<StringReader>) parse,
  required int pos,
  required String source,
}) async {
  final input = StringReader(source);
  final r1 = tryFastParse(fastParse, input);
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

Future<void> _testSuccess({
  required void Function(State<StringReader>) fastParse,
  required Object? Function(State<StringReader>) parse,
  required int pos,
  required Object? result,
  required String source,
}) async {
  final input = StringReader(source);
  final r1 = tryFastParse(fastParse, input);
  final r2 = tryParse(parse, input);
  expect(r1.ok, true, reason: 'fastParse, ok != true, source: "$source"');
  expect(r2.ok, true, reason: 'parse, ok != true, source: "$source"');
  expect(r1.pos, pos, reason: 'fastParse, pos != $pos, source: "$source"');
  expect(r2.pos, pos, reason: 'parse, pos != $pos, source: "$source"');
  expect(r2.result, result,
      reason: 'parse, result != $result, source: "$source"');
}

void _testZeroOrMore() {
  test('ZeroOrMore', () async {
    {
      // Optimized version
      const source = 'abcEND';
      await _testSuccess(
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
      await _testSuccess(
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
      await _testSuccess(
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
      await _testSuccess(
        fastParse: _parser.fastParseTakeTil,
        parse: _parser.parseTakeTil,
        pos: 3,
        result: 'abc',
        source: source,
      );
    }
  });
}

void _testOneOrMore() {
  test('OneOrMore', () async {
    {
      // Optimized version
      const source = '123abc';
      await _testSuccess(
        fastParse: _parser.fastParseOneOrMoreCharacters,
        parse: _parser.parseOneOrMoreCharacters,
        pos: 3,
        result: '123'.codeUnits,
        source: source,
      );
    }
  });
}

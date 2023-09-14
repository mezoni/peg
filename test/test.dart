import 'package:test/test.dart';

import 'test_parser.dart';

void main() {
  _testZeroOrMore();
}

final _parser = TestParser();

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
  });
}

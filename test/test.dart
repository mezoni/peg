import 'package:test/test.dart' hide fail;

import 'test_parser.dart';

void main() {
  _testAnd();
  _testAnyChar();
  _testCharacterClass();
  _testLiteral();
  _testNot();
  _testOneOrMore();
  _testOptional();
  _testOrderChoice();
  _testRanges();
  //_testSequence();
  _testZeroOrMore();
}

final _p = TestParser();

void _testAnd() {
  group('And', () {
    test('& (void)', () {
      final parse = _p.parseAndAbc;
      {
        const input = 'abc';
        _testSuccess(parse, input, null, 0);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testAnyChar() {
  group('AnyChar', () {
    test('16-bit', () {
      final parse = _p.parseAnyChar;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
    });

    test('16-bit (void)', () {
      final parse = _p.parseAnyCharVoid;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
    });

    test('32-bit', () {
      final parse = _p.parseAnyChar;
      {
        const input = '🠀';
        _testSuccess(parse, input, 129024, 2);
      }
    });

    test('32-bit (void)', () {
      final parse = _p.parseAnyCharVoid;
      {
        const input = '🠀';
        _testSuccess(parse, input, 129024, 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('Empty input', () {
      final parse = _p.parseAnyChar;
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });
  });

  test('Empty input (void)', () {
    final parse = _p.parseAnyCharVoid;
    {
      const input = '';
      final state = State(input);
      final r = parse(state);
      expect(r, isNull, reason: 'Input $input');
      expect(state.position, 0, reason: 'Input $input');
      expect(state.getErrors(),
          [(start: 0, end: 0, message: 'Unexpected input data')],
          reason: 'Input $input');
    }
  });
}

void _testCharacterClass() {
  group('Character class', () {
    test('16-bit', () {
      final parse = _p.parseChar16;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('16-bit (void)', () {
      final parse = _p.parseChar16Void;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('32-bit', () {
      final parse = _p.parseChar32;
      {
        const input = '🠀';
        _testSuccess(parse, input, 129024, 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('32-bit (void)', () {
      final parse = _p.parseChar32Void;
      {
        const input = '🠀';
        _testSuccess(parse, input, 129024, 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('Negate', () {
      final parse = _p.parseNotDigits;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '3';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('Negate (void)', () {
      final parse = _p.parseNotDigitsVoid;
      {
        const input = 'a';
        _testSuccess(parse, input, 97, 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '3';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });
  });
}

void _testLiteral() {
  group('Literal', () {
    test('Empty', () {
      final parse = _p.parseLiteral0;
      {
        const input = '';
        _testSuccess(parse, input, '', 0);
      }
      {
        const input = 'a';
        _testSuccess(parse, input, '', 0);
      }
    });

    test('Empty (void)', () {
      final parse = _p.parseLiteral0Void;
      {
        const input = '';
        _testSuccess(parse, input, '', 0);
      }
      {
        const input = 'a';
        _testSuccess(parse, input, '', 0);
      }
    });

    test('l char', () {
      final parse = _p.parseLiteral1;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });

    test('l char', () {
      final parse = _p.parseLiteral1Void;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });

    test('2 chars', () {
      final parse = _p.parseLiteral2;
      {
        const input = 'ab';
        _testSuccess(parse, input, 'ab', 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
    });

    test('2 chars (void)', () {
      final parse = _p.parseLiteral2Void;
      {
        const input = 'ab';
        _testSuccess(parse, input, 'ab', 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testNot() {
  group('Not', () {
    test('! (void)', () {
      final parse = _p.parseNotAbc;
      {
        const input = 'abd';
        _testSuccess(parse, input, null, 0);
      }
      {
        const input = 'abc';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 3, message: "Unexpected: 'abc'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testOneOrMore() {
  group('OneOrMore', () {
    test('+', () {
      final parse = _p.parseOneOrMore;
      {
        const input = 'abc';
        _testSuccess(parse, input, ['abc'], 3);
      }
      {
        const input = 'abcabc';
        _testSuccess(parse, input, ['abc', 'abc'], 6);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
    });

    test('+ (void)', () {
      final parse = _p.parseOneOrMoreVoid;
      {
        const input = 'abc';
        _testSuccess(parse, input, ['abc'], 3);
      }
      {
        const input = 'abcabc';
        _testSuccess(parse, input, ['abc', 'abc'], 6);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
    });

    test('<[]+>', () {
      final parse = _p.parseTakeWhile1;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'aa';
        _testSuccess(parse, input, 'aa', 2);
      }
      {
        const input = 'aaa';
        _testSuccess(parse, input, 'aaa', 3);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Unexpected input data")],
            reason: 'Input $input');
      }
    });

    test('<[]+> (void)', () {
      final parse = _p.parseTakeWhile1Void;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'aa';
        _testSuccess(parse, input, 'aa', 2);
      }
      {
        const input = 'aaa';
        _testSuccess(parse, input, 'aaa', 3);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });
  });
}

void _testOptional() {
  group('Optional', () {
    test('?', () {
      final parse = _p.parseOptional;
      {
        const input = 'abc';
        _testSuccess(parse, input, 'abc', 3);
      }
      {
        const input = '';
        _testSuccess(parse, input, null, 0);
      }
      {
        const input = 'ab';
        _testSuccess(parse, input, null, 0);
      }
    });

    test('? (void)', () {
      final parse = _p.parseOptionalVoid;
      {
        const input = 'abc';
        _testSuccess(parse, input, 'abc', 3);
      }
      {
        const input = '';
        _testSuccess(parse, input, null, 0);
      }
      {
        const input = 'ab';
        _testSuccess(parse, input, null, 0);
      }
    });
  });
}

void _testOrderChoice() {
  group('OrderChoice', () {
    test('/', () {
      final parse = _p.parseOrderedChoice;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'b';
        _testSuccess(parse, input, 'b', 1);
      }
      {
        const input = 'c';
        _testSuccess(parse, input, 'c', 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
    });

    test('/ (void)', () {
      final parse = _p.parseOrderedChoiceVoid;
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'b';
        _testSuccess(parse, input, 'b', 1);
      }
      {
        const input = 'c';
        _testSuccess(parse, input, 'c', 1);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testRanges() {
  group('Ranges', () {
    test('[]', () {
      final parse = _p.parseRanges;
      {
        const input = '0';
        _testSuccess(parse, input, '0', 1);
      }
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'A';
        _testSuccess(parse, input, 'A', 1);
      }
      {
        const input = '!';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Unexpected input data")],
            reason: 'Input $input');
      }
    });
  });
}

/*
void _testSequence() {
  group('Sequence', () {
    test('2 expressions', () {
      final parse = _p.parseSeq2;
      {
        const input = 'ab';
        _testSuccess(parse, input, 'ab', 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });

    test('2 expressions (void)', () {
      final parse = _p.parseSeq2Void;
      {
        const input = 'ab';
        _testSuccess(parse, input, null, 2);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });

    test('3 expressions, no vars, no action', () {
      final parse = _p.parseSeq3;
      {
        const input = 'abc';
        _testSuccess(parse, input, 'abc', 3);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });

    test('3 expressions (void)', () {
      final parse = _p.parseSeq3Void;
      {
        const input = 'abc';
        _testSuccess(parse, input, null, 3);
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(r, isNull, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });
  });
}
*/

void _testSuccess<T>(
    (T,)? Function(State state) parse, String input, T expected, int position) {
  final state = State(input);
  final result = parse(state);
  expect(result, isNotNull, reason: 'Input $input');
  expect(state.position, position, reason: 'Input $input');
  expect(result!.$1, expected, reason: 'Input $input');
}

void _testZeroOrMore() {
  group('ZeroOrMore', () {
    test('*', () {
      final parse = _p.parseZeroOrMore;
      {
        const input = '';
        _testSuccess(parse, input, <String>[], 0);
      }
      {
        const input = 'abc';
        _testSuccess(parse, input, ['abc'], 3);
      }
      {
        const input = 'abcabc';
        _testSuccess(parse, input, ['abc', 'abc'], 6);
      }
    });

    test('* (void)', () {
      final parse = _p.parseZeroOrMoreVoid;
      {
        const input = '';
        _testSuccess(parse, input, <String>[], 0);
      }
      {
        const input = 'abc';
        _testSuccess(parse, input, ['abc'], 3);
      }
      {
        const input = 'abcabc';
        _testSuccess(parse, input, ['abc', 'abc'], 6);
      }
    });

    test('<[]*>', () {
      final parse = _p.parseTakeWhile;
      {
        const input = '';
        _testSuccess(parse, input, '', 0);
      }
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'aa';
        _testSuccess(parse, input, 'aa', 2);
      }
      {
        const input = 'aaa';
        _testSuccess(parse, input, 'aaa', 3);
      }
    });

    test('<[]*>', () {
      final parse = _p.parseTakeWhileVoid;
      {
        const input = '';
        _testSuccess(parse, input, '', 0);
      }
      {
        const input = 'a';
        _testSuccess(parse, input, 'a', 1);
      }
      {
        const input = 'aa';
        _testSuccess(parse, input, 'aa', 2);
      }
      {
        const input = 'aaa';
        _testSuccess(parse, input, 'aaa', 3);
      }
    });
  });
}

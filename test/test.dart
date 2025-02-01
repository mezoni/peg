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
  _testSequence();
  _testZeroOrMore();
}

final _p = TestParser();

void _testAnd() {
  group('And', () {
    test('& (void)', () {
      final parse = _p.parseAndAbc;
      {
        const input = 'abc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 97, reason: 'Input $input');
      }
    });

    test('16-bit (void)', () {
      final parse = _p.parseAnyCharVoid;
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
    });

    test('32-bit', () {
      final parse = _p.parseAnyChar;
      {
        const input = '🠀';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 129024, reason: 'Input $input');
      }
    });

    test('32-bit (void)', () {
      final parse = _p.parseAnyCharVoid;
      {
        const input = '🠀';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
      parse(state);
      expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 97, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 129024, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.position, 1, reason: 'Input $input');
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(r, 97, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '3';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.position, 1, reason: 'Input $input');
        expect(state.isSuccess, isTrue, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
      {
        const input = '3';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, '', reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, '', reason: 'Input $input');
      }
    });

    test('Empty (void)', () {
      final parse = _p.parseLiteral0Void;
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
    });

    test('l char', () {
      final parse = _p.parseLiteral1;
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'a', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 'ab', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'ab'")],
            reason: 'Input $input');
      }
      {
        const input = '1';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = 'abc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 3, message: "Unexpected 'abc'")],
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, ['abc'], reason: 'Input $input');
      }
      {
        const input = 'abcabc';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 6, reason: 'Input $input');
        expect(r, ['abc', 'abc'], reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
      {
        const input = 'abcabc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 6, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'abc'")],
            reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'a', reason: 'Input $input');
      }
      {
        const input = 'aa';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 'aa', reason: 'Input $input');
      }
      {
        const input = 'aaa';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, 'aaa', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: 'Unexpected input data')],
            reason: 'Input $input');
      }
    });

    test('<[]+> (void)', () {
      final parse = _p.parseTakeWhile1Void;
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = 'aa';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = 'aaa';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, 'abc', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, null, reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, null, reason: 'Input $input');
      }
    });

    test('? (void)', () {
      final parse = _p.parseOptionalVoid;
      {
        const input = 'abc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = 'ab';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, '0', reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'a', reason: 'Input $input');
      }
      {
        const input = 'A';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'A', reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'a', reason: 'Input $input');
      }
      {
        const input = 'b';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'b', reason: 'Input $input');
      }
      {
        const input = 'c';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'c', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = 'b';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = 'c';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(state.getErrors(),
            [(start: 0, end: 0, message: "Expected: 'a', 'b', 'c'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testSequence() {
  group('Sequence', () {
    test('2 expressions', () {
      final parse = _p.parseSeq2;
      {
        const input = 'ab';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 'ab', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, 'abc', reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
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
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isFalse, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(
            state.getErrors(), [(start: 0, end: 0, message: "Expected: 'a'")],
            reason: 'Input $input');
      }
    });
  });
}

void _testZeroOrMore() {
  group('ZeroOrMore', () {
    test('*', () {
      final parse = _p.parseZeroOrMore;
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, <String>[], reason: 'Input $input');
      }
      {
        const input = 'abc';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, ['abc'], reason: 'Input $input');
      }
      {
        const input = 'abcabc';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 6, reason: 'Input $input');
        expect(r, ['abc', 'abc'], reason: 'Input $input');
      }
    });

    test('* (void)', () {
      final parse = _p.parseZeroOrMoreVoid;
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = 'abc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
      {
        const input = 'abcabc';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 6, reason: 'Input $input');
      }
    });

    test('<[]*>', () {
      final parse = _p.parseTakeWhile;
      {
        const input = '';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
        expect(r, '', reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
        expect(r, 'a', reason: 'Input $input');
      }
      {
        const input = 'aa';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
        expect(r, 'aa', reason: 'Input $input');
      }
      {
        const input = 'aaa';
        final state = State(input);
        final r = parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
        expect(r, 'aaa', reason: 'Input $input');
      }
    });

    test('<[]*>', () {
      final parse = _p.parseTakeWhileVoid;
      {
        const input = '';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 0, reason: 'Input $input');
      }
      {
        const input = 'a';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 1, reason: 'Input $input');
      }
      {
        const input = 'aa';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 2, reason: 'Input $input');
      }
      {
        const input = 'aaa';
        final state = State(input);
        parse(state);
        expect(state.isSuccess, isTrue, reason: 'Input $input');
        expect(state.position, 3, reason: 'Input $input');
      }
    });
  });
}

String _unexpectedChar(String s) {
  final ch = s.runes.first;
  final str = ch < 32 ? '' : ': \'${String.fromCharCode(ch)}\'';
  var size = 6;
  if (ch <= 0xff) {
    size = 2;
  } else if (ch <= 0xffff) {
    size = 4;
  }

  final hex = ch.toRadixString(16).padLeft(size, '0').toUpperCase();
  return 'Unexpected character (0x$hex)$str';
}

//ignore_for_file: prefer_conditional_assignment, prefer_final_locals

import 'dart:math' as math;

import 'package:source_span/source_span.dart';

void main() {
  _testErrors();
  print(parse('0'));
  print(parse('-0'));
  print(parse('1'));
  print(parse('-1'));
  print(parse('123.456'));
  print(parse('-123.456'));
}

void _testErrors() {
  const patterns = ['1.', '`'];
  for (final pattern in patterns) {
    try {
      parse(pattern);
    } catch (e) {
      print(pattern);
      print(e);
    }
  }
}

num parse(String source) {
  final state = State(source);
  final parser = NumberParser();
  final result = parser.parseNumber(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }
  return result.$1;
}

class NumberParser {
  /// **Number** ('number')
  ///
  ///```text
  /// `num`
  /// Number('number') =>
  ///   negative = [\-]?
  ///   integer = <[0-9]+>
  ///   `num` result = { $$ = num.parse(integer); }
  ///   { var ok = true; }
  ///   (
  ///     [.]
  ///     { ok = false; }
  ///     (
  ///       decimal = <[0-9]+>
  ///       { ok = true; }
  ///       { result += int.parse(decimal) / math.pow(10, decimal.length); }
  ///        ~ { message = 'Expected decimal digit' }
  ///     )
  ///   )?
  ///   &{ ok }
  ///   $ = { $$ = negative == null ? result  : -result; }
  ///```
  (num,)? parseNumber(State state) {
    final $15 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $16 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (num,)? $0;
    (int?,)? $2 = state.peek() == 45 ? (state.advance(),) : state.fail<int>();
    $2 ??= (null,);
    int? negative = $2.$1;
    final $8 = state.position;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.advance();
      c = state.peek();
    }
    final $7 = state.position != $8 ? (null,) : state.fail<List<int>>();
    final $3 = $7 != null ? (state.substring($8, state.position),) : null;
    if ($3 != null) {
      String integer = $3.$1;
      final num $$;
      $$ = num.parse(integer);
      final $4 = ($$,);
      num result = $4.$1;
      var ok = true;
      final $9 = state.peek() == 46 ? (state.advance(),) : state.fail<int>();
      if ($9 != null) {
        ok = false;
        final $14 = state.position;
        final $11 = state.failure;
        state.failure = state.position;
        (void,)? $10;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        final $13 = state.position != $14 ? (null,) : state.fail<List<int>>();
        final $12 =
            $13 != null ? (state.substring($14, state.position),) : null;
        if ($12 != null) {
          String decimal = $12.$1;
          ok = true;
          result += int.parse(decimal) / math.pow(10, decimal.length);
          $10 = (null,);
        }
        if ($10 == null) {
          state.position = $14;
        }
        if ($10 == null) {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
        }
        state.failure = state.failure < $11 ? $11 : state.failure;
      }
      final $5 = ok ? (null,) : state.fail<void>();
      if ($5 != null) {
        final num $$;
        $$ = negative == null ? result : -result;
        final $6 = ($$,);
        num $ = $6.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    if (state.failure == $1 && $15 < state.nesting) {
      state.expected($0, 'number', $1, state.position);
    }
    state.nesting = $15;
    state.failure = state.failure < $16 ? $16 : state.failure;
    return $0;
  }
}

class State {
  static const flagUseStart = 1;

  static const flagUseEnd = 2;

  static const flagExpected = 4;

  static const flagUnexpected = 8;

  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// This field is for internal use only.
  int nesting = -1;

  /// This field is for internal use only.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  int _ch = 0;

  int _errorIndex = 0;

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  final List<int?> _flags = List.filled(128, null);

  final String _input;

  final List<String?> _messages = List.filled(128, null);

  int _peekPosition = -1;

  final List<int?> _starts = List.filled(128, null);

  State(String input)
      : _input = input,
        length = input.length {
    peek();
  }

  /// Advances the current [position] to the next character position and
  /// returns the character from the current position.
  ///
  /// A call to this method must be preceded by a call to the [peek] method,
  /// otherwise the behavior of this method is undefined.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int advance() {
    position += _ch > 0xffff ? 2 : 1;
    return _ch;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void error(String message, int start, int end, int flag) {
    if (_farthestError > end) {
      return;
    }

    if (_farthestError < end) {
      _farthestError = end;
      _errorIndex = 0;
    }

    if (_errorIndex < _messages.length) {
      _flags[_errorIndex] = flag;
      _messages[_errorIndex] = message;
      _starts[_errorIndex] = start;
      _errorIndex++;
    }
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(Object? result, String string, int start, int end) {
    if (result != null) {
      predicate ? error(string, start, end, flagUnexpected) : null;
    } else {
      predicate ? null : error(string, start, end, flagExpected);
    }
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (T,)? fail<T>([int length = 0]) {
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return null;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    if (length != 0) {
      _farthestFailureLength =
          _farthestFailureLength < length ? length : _farthestFailureLength;
    }

    return null;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (T,)? failAndBacktrack<T>(int position) {
    fail<void>(this.position - position);
    this.position = position;
    return null;
  }

  /// Converts error messages to errors and returns them as an error list.
  List<({int end, String message, int start})> getErrors() {
    final errors = <({int end, String message, int start})>[];
    final expected = <String>{};
    final unexpected = <(int, int), Set<String>>{};
    for (var i = 0; i < _errorIndex; i++) {
      final message = _messages[i];
      if (message == null) {
        continue;
      }

      final flag = _flags[i]!;
      final startPosition = _starts[i]!;
      if (flag & (flagExpected | flagUnexpected) == 0) {
        var start = flag & flagUseStart == 0 ? startPosition : _farthestError;
        var end = flag & flagUseEnd == 0 ? _farthestError : startPosition;
        if (start > end) {
          start = startPosition;
          end = _farthestError;
        }

        errors.add((message: message, start: start, end: end));
      } else if (flag & flagExpected != 0) {
        expected.add(message);
      } else if (flag & flagUnexpected != 0) {
        (unexpected[(startPosition, _farthestError)] ??= {}).add(message);
      }
    }

    if (expected.isNotEmpty) {
      final list = expected.toList();
      list.sort();
      final message = 'Expected: ${list.map((e) => '\'$e\'').join(', ')}';
      errors
          .add((message: message, start: _farthestError, end: _farthestError));
    }

    if (unexpected.isNotEmpty) {
      for (final entry in unexpected.entries) {
        final key = entry.key;
        final value = entry.value;
        final list = value.toList();
        list.sort();
        final message = 'Unexpected: ${list.map((e) => '\'$e\'').join(', ')}';
        errors.add((message: message, start: key.$1, end: key.$2));
      }
    }

    if (errors.isEmpty) {
      errors.add((
        message: 'Unexpected input data',
        start: _farthestFailure - _farthestFailureLength,
        end: _farthestFailure
      ));
    }

    return errors.toSet().toList();
  }

  /// Matches the input data at the current [position] with the string [string].
  ///
  /// If successful, advances the [position] by the length of the [string] (in
  /// input data units) and returns the specified [string], otherwise calls the
  /// [fails] method and returns `null`.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match(String string) {
    if (startsWith(string, position)) {
      position += string.length;
      return (string,);
    }

    fail<void>();
    return null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? matchLiteral(String string) {
    final start = position;
    final result = match(string);
    if (nesting < position) {
      expected(result, string, start, position);
    }

    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? matchLiteral1(String string, int char) {
    final start = position;
    final result = peek() == char ? (string,) : null;
    result != null ? advance() : fail<void>();
    if (nesting < position) {
      expected(result, string, start, position);
    }

    return result;
  }

  /// Reads and returns the character at the current [position].
  ///
  /// If the end of the input data is reached, the return value is `0`.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int peek() {
    if (_peekPosition == position) {
      return _ch;
    }

    _peekPosition = position;
    if (position < length) {
      if ((_ch = _input.codeUnitAt(position)) < 0xd800) {
        return _ch;
      }

      if (_ch < 0xe000) {
        final c = _input.codeUnitAt(position + 1);
        if ((c & 0xfc00) == 0xdc00) {
          return _ch = 0x10000 + ((_ch & 0x3ff) << 10) + (c & 0x3ff);
        }

        throw FormatException('Invalid UTF-16 character', this, position);
      }

      return _ch;
    } else {
      return _ch = 0;
    }
  }

  bool startsWith(String string, int position) =>
      _input.startsWith(string, position);

  /// Returns a substring of the input data, starting at position [start] and
  /// ending at position [end].
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String substring(int start, int end) => _input.substring(start, end);

  @override
  String toString() {
    if (position >= length) {
      return '';
    }

    var rest = length - position;
    if (rest > 80) {
      rest = 80;
    }

    // Need to create the equivalent of 'substring'
    var line = substring(position, position + rest);
    line = line.replaceAll('\n', '\n');
    return '|$position|$line';
  }
}

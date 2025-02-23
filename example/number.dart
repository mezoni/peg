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
  ///   @expected('number') { negative = [\-]?
  ///   integer = <[0-9]+>
  ///   `num` result = { num.parse(integer) }
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
  ///   $ = { negative == null ? result : -result } }
  ///```
  (num,)? parseNumber(State state) {
    final $0 = state.position;
    const $11 = 'number';
    final $12 = state.failure;
    final $13 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (num,)? $1;
    int? $2;
    if (state.peek() == 45) {
      state.position += state.charSize(45);
      $2 = 45;
    } else {
      state.fail();
    }
    int? negative = $2;
    final $3 = state.position;
    String? $4;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($3 != state.position) {
      $4 = state.substring($3, state.position);
      String integer = $4;
      num result = num.parse(integer);
      var ok = true;
      final $6 = state.position;
      var $5 = false;
      if (state.peek() == 46) {
        state.position += state.charSize(46);
        ok = false;
        final $10 = state.failure;
        state.failure = state.position;
        var $7 = false;
        final $8 = state.position;
        String? $9;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        if ($8 != state.position) {
          $9 = state.substring($8, state.position);
          String decimal = $9;
          ok = true;
          result += int.parse(decimal) / math.pow(10, decimal.length);
          $7 = true;
        } else {
          state.fail();
        }
        if ($7) {
          state.failure < $10 ? state.failure = $10 : null;
          $5 = true;
        } else {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
          state.failure < $10 ? state.failure = $10 : null;
        }
      } else {
        state.fail();
      }
      if (!$5) {
        state.position = $6;
      }
      if (ok) {
        num $ = negative == null ? result : -result;
        $1 = ($,);
      }
    } else {
      state.fail();
    }
    if ($1 != null) {
      state.onSuccess($11, $0, $13);
      return $1;
    } else {
      state.position = $0;
      state.onFailure($11, $0, $13, $12);
      return null;
    }
  }
}

class State {
  /// Intended for internal use only.
  static const flagUseStart = 1;

  /// Intended for internal use only.
  static const flagUseEnd = 2;

  /// Intended for internal use only.
  static const flagExpected = 4;

  /// Intended for internal use only.
  static const flagUnexpected = 8;

  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// Intended for internal use only.
  int nesting = -1;

  /// Intended for internal use only.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  /// Current parsing position.
  Object? unused;

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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int charSize(int char) => char > 0xffff ? 2 : 1;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void consume(String literal, int start) {
    position += strlen(literal);
    if (predicate && nesting < position) {
      error(literal, start, position, flagUnexpected);
    }
  }

  /// Intended for internal use only.
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
  void expected(String literal) {
    if (nesting < position && !predicate) {
      error(literal, position, position, flagExpected);
    }

    fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void fail([String? name]) {
    failure < position ? failure = position : null;
    if (_farthestFailure < position) {
      _farthestFailure = position;
      _farthestFailureLength = 0;
    }

    if (name != null && nesting < position) {
      error(name, position, position, flagExpected);
    }
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void failAndBacktrack(int position) {
    fail();
    final length = this.position - position;
    _farthestFailureLength < length ? _farthestFailureLength = length : null;
    this.position = position;
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void onFailure(String name, int start, int nesting, int failure) {
    if (failure == position && nesting < position && !predicate) {
      error(name, position, position, flagExpected);
    }

    this.nesting = nesting;
    this.failure < failure ? this.failure = failure : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void onSuccess(String name, int start, int nesting) {
    if (predicate && nesting < start) {
      error(name, start, position, flagUnexpected);
    }

    this.nesting = nesting;
  }

  /// Intended for internal use only.
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool startsWith(String string, int position) =>
      _input.startsWith(string, position);

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int strlen(String string) => string.length;

  /// Intended for internal use only.
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

    var line = substring(position, position + rest);
    line = line.replaceAll('\n', r'\n');
    return '|$position|$line';
  }
}

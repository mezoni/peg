//ignore_for_file: curly_braces_in_flow_control_structures, empty_statements, prefer_conditional_assignment, prefer_final_locals

import 'package:source_span/source_span.dart';

void main() {
  const source = ' 1 + 2 * 3 + x ';
  final result = calc(source, {'x': 5});
  print(result);
}

int calc(String source, Map<String, int> vars) {
  final parser = CalcParser(vars);
  final state = State(source);
  final result = parser.parseStart(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result.$1;
}

class CalcParser {
  Map<String, int> vars = {};

  CalcParser(this.vars);

  /// **EOF** ('end of file')
  ///
  ///```text
  /// `void`
  /// EOF('end of file') =>
  ///   !.
  ///```
  (void,)? parseEOF(State state) {
    final $2 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $3 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    final $0 = state.peek() == 0 ? (null,) : null;
    if (state.failure == $1 && $2 < state.nesting) {
      state.expected($0, 'end of file', $1, state.position);
    }
    state.nesting == $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
  }

  /// **Expr** ('expression')
  ///
  ///```text
  /// `int`
  /// Expr('expression') =>
  ///   Sum
  ///```
  (int,)? parseExpr(State state) {
    final $2 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $3 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    final $0 = parseSum(state);
    if (state.failure == $1 && $2 < state.nesting) {
      state.expected($0, 'expression', $1, state.position);
    }
    state.nesting == $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
  }

  /// **ID**
  ///
  ///```text
  /// `String`
  /// ID =>
  ///   $ = <[a-zA-Z]>
  ///   S
  ///```
  (String,)? parseID(State state) {
    final $3 = state.position;
    (String,)? $0;
    final $4 = state.peek();
    final $2 = ($4 >= 97 ? $4 <= 122 : $4 >= 65 && $4 <= 90)
        ? (state.advance(),)
        : state.fail<int>();
    final $1 = $2 != null ? (state.substring($3, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      parseS(state);
      $0 = ($,);
    }
    return $0;
  }

  /// **NUMBER**
  ///
  ///```text
  /// `int`
  /// NUMBER =>
  ///   n = <[0-9]+>
  ///   S
  ///   $ = { $$ = int.parse(n); }
  ///```
  (int,)? parseNUMBER(State state) {
    final $4 = state.position;
    (int,)? $0;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.advance();
      c = state.peek();
    }
    final $3 = state.position != $4 ? (null,) : state.fail<List<int>>();
    final $1 = $3 != null ? (state.substring($4, state.position),) : null;
    if ($1 != null) {
      String n = $1.$1;
      parseS(state);
      final int $$;
      $$ = int.parse(n);
      final $2 = ($$,);
      int $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $4;
    }
    return $0;
  }

  /// **Product**
  ///
  ///```text
  /// `int`
  /// Product =>
  ///   $ = Value
  ///   @while (*) (
  ///     n = [*/]
  ///     S
  ///     r = Product
  ///     { $ = switch(n) {
  ///         42 => $ * r,
  ///         47 => $ ~/ r,
  ///         _ => $,
  ///       };
  ///     }
  ///   )
  ///```
  (int,)? parseProduct(State state) {
    (int,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        final $5 = state.peek();
        final $3 =
            $5 == 42 || $5 == 47 ? (state.advance(),) : state.fail<int>();
        if ($3 != null) {
          int n = $3.$1;
          parseS(state);
          final $4 = parseProduct(state);
          if ($4 != null) {
            int r = $4.$1;
            $ = switch (n) {
              42 => $ * r,
              47 => $ ~/ r,
              _ => $,
            };
            $2 = (null,);
          }
        }
        if ($2 == null) {
          state.position = $6;
        }
        if ($2 == null) {
          break;
        }
      }
      $0 = ($,);
    }
    return $0;
  }

  /// **S**
  ///
  ///```text
  /// `void `
  /// S =>
  ///   `void ` [ {9}{d}{a}]*
  ///```
  (void,)? parseS(State state) {
    final $list = <int>[];
    while (true) {
      final $2 = state.peek();
      final $1 = ($2 >= 13 ? $2 <= 13 || $2 == 32 : $2 >= 9 && $2 <= 10)
          ? (state.advance(),)
          : state.fail<int>();
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = ($list,);
    return $0;
  }

  /// **Start**
  ///
  ///```text
  /// `int`
  /// Start =>
  ///   S
  ///   $ = Expr
  ///   EOF
  ///```
  (int,)? parseStart(State state) {
    final $3 = state.position;
    (int,)? $0;
    parseS(state);
    final $1 = parseExpr(state);
    if ($1 != null) {
      int $ = $1.$1;
      final $2 = parseEOF(state);
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    return $0;
  }

  /// **Sum**
  ///
  ///```text
  /// `int`
  /// Sum =>
  ///   $ = Product
  ///   @while (*) (
  ///     n = [\-+]
  ///     S
  ///     r = Product
  ///     { $ = switch(n) {
  ///         43 => $ + r,
  ///         45 => $ - r,
  ///         _ => $,
  ///       };
  ///     }
  ///   )
  ///```
  (int,)? parseSum(State state) {
    (int,)? $0;
    final $1 = parseProduct(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        final $5 = state.peek();
        final $3 =
            $5 == 43 || $5 == 45 ? (state.advance(),) : state.fail<int>();
        if ($3 != null) {
          int n = $3.$1;
          parseS(state);
          final $4 = parseProduct(state);
          if ($4 != null) {
            int r = $4.$1;
            $ = switch (n) {
              43 => $ + r,
              45 => $ - r,
              _ => $,
            };
            $2 = (null,);
          }
        }
        if ($2 == null) {
          state.position = $6;
        }
        if ($2 == null) {
          break;
        }
      }
      $0 = ($,);
    }
    return $0;
  }

  /// **Value** ('expression')
  ///
  ///```text
  /// `int`
  /// Value('expression') =>
  ///   (
  ///     NUMBER
  ///     ----
  ///     i = ID
  ///     $ = { $$ = vars[i]!; }
  ///     ----
  ///     '('
  ///     S
  ///     $ = Expr
  ///     ')'
  ///     S
  ///   )
  ///```
  (int,)? parseValue(State state) {
    final $7 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $8 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (int,)? $0;
    $0 = parseNUMBER(state);
    if ($0 == null) {
      final $2 = parseID(state);
      if ($2 != null) {
        String i = $2.$1;
        final int $$;
        $$ = vars[i]!;
        final $3 = ($$,);
        int $ = $3.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        final $4 = state.matchLiteral1('(', 40);
        if ($4 != null) {
          parseS(state);
          final $5 = parseExpr(state);
          if ($5 != null) {
            int $ = $5.$1;
            final $6 = state.matchLiteral1(')', 41);
            if ($6 != null) {
              parseS(state);
              $0 = ($,);
            }
          }
        }
        if ($0 == null) {
          state.position = $1;
        }
      }
    }
    if (state.failure == $1 && $7 < state.nesting) {
      state.expected($0, 'expression', $1, state.position);
    }
    state.nesting == $7;
    state.failure = state.failure < $8 ? $8 : state.failure;
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
    if (_input.startsWith(string, position)) {
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

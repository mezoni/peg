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
  ///   @expected('end of file') { !. }
  ///```
  (void,)? parseEOF(State state) {
    final $0 = state.position;
    const $1 = 'end of file';
    final $2 = state.failure;
    final $3 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    if (state.peek() == 0) {
      state.onSuccess($1, $0, $3);
      return const (null,);
    } else {
      state.fail();
      state.onFailure($1, $0, $3, $2);
      return null;
    }
  }

  /// **Expr** ('expression')
  ///
  ///```text
  /// `int`
  /// Expr('expression') =>
  ///   @expected('expression') { Sum }
  ///```
  (int,)? parseExpr(State state) {
    final $0 = state.position;
    const $2 = 'expression';
    final $3 = state.failure;
    final $4 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    final $1 = parseSum(state);
    if ($1 != null) {
      state.onSuccess($2, $0, $4);
      return $1;
    } else {
      state.onFailure($2, $0, $4, $3);
      return null;
    }
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
    final $1 = state.position;
    (String,)? $0;
    String? $3;
    final $2 = state.peek();
    if ($2 >= 97 ? $2 <= 122 : $2 >= 65 && $2 <= 90) {
      state.position += state.charSize($2);
      $3 = state.substring($1, state.position);
      String $ = $3;
      parseS(state);
      $0 = ($,);
    } else {
      state.fail();
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
    final $1 = state.position;
    (int,)? $0;
    String? $2;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($1 != state.position) {
      $2 = state.substring($1, state.position);
      String n = $2;
      parseS(state);
      final int $$;
      $$ = int.parse(n);
      int $ = $$;
      $0 = ($,);
    } else {
      state.fail();
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
        final $3 = state.position;
        var $2 = false;
        final $4 = state.peek();
        if ($4 == 42 || $4 == 47) {
          state.position += state.charSize($4);
          int n = $4;
          parseS(state);
          final $5 = parseProduct(state);
          if ($5 != null) {
            int r = $5.$1;
            $ = switch (n) {
              42 => $ * r,
              47 => $ ~/ r,
              _ => $,
            };
            $2 = true;
          }
        } else {
          state.fail();
        }
        if (!$2) {
          state.position = $3;
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
  void parseS(State state) {
    for (var c = state.peek();
        c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
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
    final $1 = state.position;
    (int,)? $0;
    parseS(state);
    final $2 = parseExpr(state);
    if ($2 != null) {
      int $ = $2.$1;
      final $3 = parseEOF(state);
      if ($3 != null) {
        $0 = ($,);
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
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
        final $3 = state.position;
        var $2 = false;
        final $4 = state.peek();
        if ($4 == 43 || $4 == 45) {
          state.position += state.charSize($4);
          int n = $4;
          parseS(state);
          final $5 = parseProduct(state);
          if ($5 != null) {
            int r = $5.$1;
            $ = switch (n) {
              43 => $ + r,
              45 => $ - r,
              _ => $,
            };
            $2 = true;
          }
        } else {
          state.fail();
        }
        if (!$2) {
          state.position = $3;
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
  ///   @expected('expression') { (
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
  ///   ) }
  ///```
  (int,)? parseValue(State state) {
    final $0 = state.position;
    const $8 = 'expression';
    final $9 = state.failure;
    final $10 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (int,)? $1;
    final $2 = parseNUMBER(state);
    if ($2 != null) {
      $1 = $2;
    } else {
      (int,)? $3;
      final $4 = parseID(state);
      if ($4 != null) {
        String i = $4.$1;
        final int $$;
        $$ = vars[i]!;
        int $ = $$;
        $3 = ($,);
      }
      if ($3 != null) {
        $1 = $3;
      } else {
        (int,)? $5;
        if (state.peek() == 40) {
          state.consume('(', $0);
          parseS(state);
          final $6 = parseExpr(state);
          if ($6 != null) {
            int $ = $6.$1;
            final $7 = state.position;
            if (state.peek() == 41) {
              state.consume(')', $7);
              parseS(state);
              $5 = ($,);
            } else {
              state.expected(')');
            }
          }
        } else {
          state.expected('(');
        }
        if ($5 != null) {
          $1 = $5;
        } else {
          state.position = $0;
        }
      }
    }
    if ($1 != null) {
      state.onSuccess($8, $0, $10);
      return $1;
    } else {
      state.onFailure($8, $0, $10, $9);
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

// ignore_for_file: prefer_final_locals

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
  ///```code
  /// `void`
  /// EOF =
  ///    !.
  ///```
  (void,)? parseEOF(State state) {
    final $3 = state.enter();
    final $pos = state.position;
    final $2 = state.notPredicate;
    state.notPredicate = true;
    final $1 = state.matchAny();
    state.notPredicate = $2;
    if ($1 != null) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    final $0 = $1 == null ? const (null,) : null;
    state.expected($0, 'end of file', $pos, false);
    state.leave($3);
    return $0;
  }

  /// **Expr** ('expression')
  ///
  ///```code
  /// `int`
  /// Expr =
  ///    Sum
  ///```
  (int,)? parseExpr(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    final $0 = parseSum(state);
    state.expected($0, 'expression', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **ID**
  ///
  ///```code
  /// `String`
  /// ID =
  ///    $ = <[a-zA-Z]> S
  ///```
  (String,)? parseID(State state) {
    final $pos = state.position;
    (String,)? $0;
    final $2 = state
        .matchChars16((int c) => c >= 65 && c <= 90 || c >= 97 && c <= 122);
    final $1 =
        $2 != null ? (state.input.substring($pos, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      final $3 = parseS(state);
      if ($3 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **NUMBER**
  ///
  ///```code
  /// `int`
  /// NUMBER =
  ///    n = <[0-9]+> S $ = { }
  ///```
  (int,)? parseNUMBER(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $2 = state.skip16While1((int c) => c >= 48 && c <= 57);
    final $1 =
        $2 != null ? (state.input.substring($pos, state.position),) : null;
    if ($1 != null) {
      String n = $1.$1;
      final $3 = parseS(state);
      if ($3 != null) {
        late int $$;
        $$ = int.parse(n);
        final $4 = state.opt(($$,));
        if ($4 != null) {
          int $ = $4.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Product**
  ///
  ///```code
  /// `int`
  /// Product =
  ///    $ = Value (n = [*/] S r = Product { })*
  ///```
  (int,)? parseProduct(State state) {
    final $pos1 = state.position;
    (int,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $pos = state.position;
        (void,)? $3;
        final $4 = state.matchChars16((int c) => c == 42 || c == 47);
        if ($4 != null) {
          int n = $4.$1;
          final $5 = parseS(state);
          if ($5 != null) {
            final $6 = parseProduct(state);
            if ($6 != null) {
              int r = $6.$1;
              $ = switch (n) {
                42 => $ * r,
                47 => $ ~/ r,
                _ => $,
              };
              final $7 = state.opt((null,));
              if ($7 != null) {
                $3 = const (null,);
              }
            }
          }
        }
        if ($3 == null) {
          state.position = $pos;
        }
        if ($3 == null) {
          break;
        }
      }
      final $2 = state.opt((const <void>[],));
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **S**
  ///
  ///```code
  /// `void `
  /// S =
  ///    [ \t\r\n]*
  ///```
  (void,)? parseS(State state) {
    final $list = <int>[];
    while (true) {
      final $1 = state.matchChars16(
          (int c) => c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = state.opt(($list,));
    return $0;
  }

  /// **Start**
  ///
  ///```code
  /// `int`
  /// Start =
  ///    S $ = Expr EOF
  ///```
  (int,)? parseStart(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $1 = parseS(state);
    if ($1 != null) {
      final $2 = parseExpr(state);
      if ($2 != null) {
        int $ = $2.$1;
        final $3 = parseEOF(state);
        if ($3 != null) {
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Sum**
  ///
  ///```code
  /// `int`
  /// Sum =
  ///    $ = Product (n = [\-+] S r = Product { })*
  ///```
  (int,)? parseSum(State state) {
    final $pos1 = state.position;
    (int,)? $0;
    final $1 = parseProduct(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $pos = state.position;
        (void,)? $3;
        final $4 = state.matchChars16((int c) => c == 43 || c == 45);
        if ($4 != null) {
          int n = $4.$1;
          final $5 = parseS(state);
          if ($5 != null) {
            final $6 = parseProduct(state);
            if ($6 != null) {
              int r = $6.$1;
              $ = switch (n) {
                43 => $ + r,
                45 => $ - r,
                _ => $,
              };
              final $7 = state.opt((null,));
              if ($7 != null) {
                $3 = const (null,);
              }
            }
          }
        }
        if ($3 == null) {
          state.position = $pos;
        }
        if ($3 == null) {
          break;
        }
      }
      final $2 = state.opt((const <void>[],));
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Value** ('expression')
  ///
  ///```code
  /// `int`
  /// Value =
  ///    (NUMBER / i = ID $ = { } / '(' S $ = Expr ')' S)
  ///```
  (int,)? parseValue(State state) {
    final $8 = state.enter();
    final $pos = state.position;
    (int,)? $0;
    $0 = parseNUMBER(state);
    if ($0 == null) {
      final $1 = parseID(state);
      if ($1 != null) {
        String i = $1.$1;
        late int $$;
        $$ = vars[i]!;
        final $2 = state.opt(($$,));
        if ($2 != null) {
          int $ = $2.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
      if ($0 == null) {
        final $3 = state.match1('(', 40);
        if ($3 != null) {
          final $4 = parseS(state);
          if ($4 != null) {
            final $5 = parseExpr(state);
            if ($5 != null) {
              int $ = $5.$1;
              final $6 = state.match1(')', 41);
              if ($6 != null) {
                final $7 = parseS(state);
                if ($7 != null) {
                  $0 = ($,);
                }
              }
            }
          }
        }
        if ($0 == null) {
          state.position = $pos;
        }
      }
    }
    state.expected($0, 'expression', $pos, false);
    state.leave($8);
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// Input data for parsing.
  String input;

  /// Indicates that parsing occurs within a `not' predicate`.
  ///
  /// When parsed within the `not predicate`, all `expected` errors are
  /// converted to `unexpected` errors.
  bool notPredicate = false;

  /// Current parsing position.
  int position = 0;

  int _errorIndex = 0;

  int _expectedIndex = 0;

  final List<String?> _expected = List.filled(128, null);

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  int _farthestUnexpected = 0;

  final List<bool?> _locations = List.filled(128, null);

  final List<String?> _messages = List.filled(128, null);

  final List<int?> _positions = List.filled(128, null);

  int _unexpectedIndex = 0;

  final List<String?> _unexpectedElements = List.filled(128, null);

  final List<int?> _unexpectedPositions = List.filled(128, null);

  State(this.input);

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int enter() {
    final failure = this.failure;
    this.failure = position;
    return failure;
  }

  /// Registers an error at the [failure] position.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void error(String message, {bool? location}) {
    if (_farthestError > failure) {
      return;
    }

    if (_farthestError < failure) {
      _farthestError = failure;
      _errorIndex = 0;
      _expectedIndex = 0;
    }

    if (_errorIndex < _messages.length) {
      _locations[_errorIndex] = location;
      _messages[_errorIndex] = message;
      _positions[_errorIndex] = position;
      _errorIndex++;
    }
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(Object? result, String element, int start,
      [bool nested = true]) {
    if (_farthestError > position) {
      return;
    }

    if (result != null) {
      if (!notPredicate || _farthestUnexpected > position) {
        return;
      }

      if (_farthestUnexpected < position) {
        _farthestUnexpected = position;
        _unexpectedIndex = 0;
      }

      if (_unexpectedIndex < _unexpectedElements.length) {
        _unexpectedElements[_unexpectedIndex] = element;
        _unexpectedPositions[_unexpectedIndex] = start;
        _unexpectedIndex++;
      }
    } else {
      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (!nested) {
        _expectedIndex = 0;
      }

      if (_expectedIndex < _expected.length) {
        _expected[_expectedIndex++] = element;
      }
    }
  }

  /// Causes a parsing failure and updates the [failure] and [_farthestFailure]
  /// positions.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void fail([int length = 0]) {
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    _farthestFailureLength =
        _farthestFailureLength < length ? length : _farthestFailureLength;
  }

  /// Converts error messages to errors and returns them as an error list.
  List<({int end, String message, int start})> getErrors() {
    final errors = <({int end, String message, int start})>[];
    for (var i = 0; i < _errorIndex; i++) {
      final message = _messages[i];
      if (message == null) {
        continue;
      }

      var start = _positions[i]!;
      var end = _farthestError;
      final location = _locations[i];
      switch (location) {
        case true:
          start = end;
          break;
        case false:
          end = start;
          break;
        default:
      }

      errors.add((message: message, start: start, end: end));
    }

    if (_expectedIndex > 0) {
      final names = <String>[];
      for (var i = 0; i < _expectedIndex; i++) {
        final name = _expected[i]!;
        names.add(name);
      }

      names.sort();
      final message =
          'Expected: ${names.toSet().map((e) => '\'$e\'').join(', ')}';
      errors
          .add((message: message, start: _farthestError, end: _farthestError));
    }

    if (_farthestUnexpected >= _farthestError) {
      if (_unexpectedIndex > 0) {
        for (var i = 0; i < _unexpectedIndex; i++) {
          final element = _unexpectedElements[i]!;
          final position = _unexpectedPositions[i]!;
          final message = "Unexpected '$element'";
          errors.add(
              (message: message, start: position, end: _farthestUnexpected));
        }
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

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void leave(int failure) {
    if (this.failure < failure) {
      this.failure = failure;
    }
  }

  /// Registers an error if the [failure] position is further than starting
  /// [position], otherwise the error will be ignored.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void malformed(String message, {bool? location}) =>
      failure != position ? error(message, location: location) : null;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match(String string, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position < input.length &&
        input.codeUnitAt(position) == string.codeUnitAt(0)) {
      if (input.startsWith(string, position)) {
        position += string.length;
        result = (string,);
      }
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match1(String string, int char, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position < input.length && input.codeUnitAt(position) == char) {
      position++;
      result = (string,);
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match2(String string, int char, int char2, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position + 1 < input.length &&
        input.codeUnitAt(position) == char &&
        input.codeUnitAt(position + 1) == char2) {
      position += 2;
      result = (string,);
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchAny() {
    int? c;
    if (position < input.length) {
      c = input.readChar(position);
    }

    c != null ? position += c > 0xffff ? 2 : 1 : fail();
    return c != null ? (c,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChar16(int char) {
    final ok = position < input.length && input.codeUnitAt(position) == char;
    ok ? position++ : fail();
    return ok ? (char,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChar32(int char) {
    final ok = position + 1 < input.length && input.readChar(position) == char;
    ok ? position += 2 : fail();
    return ok ? (char,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChars16(bool Function(int c) f) {
    (int,)? result;
    if (position < input.length) {
      final c = input.codeUnitAt(position);
      result = f(c) ? (c,) : null;
    }

    result != null ? position++ : fail();
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChars32(bool Function(int c) f) {
    (int,)? result;
    var c = 0;
    if (position < input.length) {
      c = input.readChar(position);
      result = f(c) ? (c,) : null;
    }

    result != null ? position += c > 0xffff ? 2 : 1 : fail();
    return result;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  T? opt<T>(T value) => value;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip16While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!f(c)) {
        break;
      }

      position++;
    }

    return (const [],);
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip16While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!f(c)) {
        break;
      }

      position++;
    }

    final ok = start != position;
    ok ? null : fail();
    return ok ? (const [],) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip32While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.readChar(position);
      if (!f(c)) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    return (const [],);
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip32While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.readChar(position);
      if (!f(c)) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    final ok = start != position;
    ok ? null : fail();
    return ok ? (const [],) : null;
  }

  @override
  String toString() {
    var rest = input.length - position;
    if (rest > 80) {
      rest = 80;
    }

    var line = input.substring(position, position + rest);
    line = line.replaceAll('\n', '\n');
    return '($position)$line';
  }
}

extension on String {
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  int readChar(int index) {
    final b1 = codeUnitAt(index++);
    if (b1 > 0xd7ff && b1 < 0xe000) {
      if (index < length) {
        final b2 = codeUnitAt(index);
        if ((b2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((b1 & 0x3ff) << 10) + (b2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return b1;
  }
}

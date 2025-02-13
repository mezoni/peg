// ignore_for_file: prefer_conditional_assignment, prefer_final_locals

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
    final $2 = state.enter();
    final $1 = state.position;
    final $0 = state.matchEof();
    state.expected($0, 'end of file', $1, false);
    state.leave($2);
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
    final $2 = state.enter();
    final $1 = state.position;
    final $0 = parseSum(state);
    state.expected($0, 'expression', $1, false);
    state.leave($2);
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
    final $4 = state.position;
    (String,)? $0;
    (int,)? $3;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 97 ? c <= 122 : c >= 65 && c <= 90;
      $3 = ok ? (c,) : null;
      $3 ?? (state.position = $4);
    }
    final $2 = $3 ?? state.fail<int>();
    (String,)? $1 = $2 != null ? (state.substring($4, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      parseS(state);
      $0 = ($,);
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
    final $4 = state.position;
    (int,)? $0;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c >= 48 && c <= 57;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    final $3 =
        state.position != $4 ? const (<int>[],) : state.fail<List<int>>();
    (String,)? $1 = $3 != null ? (state.substring($4, state.position),) : null;
    if ($1 != null) {
      String n = $1.$1;
      parseS(state);
      late int $$;
      $$ = int.parse(n);
      (int,)? $2 = ($$,);
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
  ///```code
  /// `int`
  /// Product =
  ///    $ = Value n = [*/] S r = Product { }*
  ///```
  (int,)? parseProduct(State state) {
    (int,)? $0;
    (int,)? $1 = parseValue(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        (int,)? $5;
        if (state.position < state.length) {
          final c = state.nextChar16();
          final ok = c == 42 || c == 47;
          $5 = ok ? (c,) : null;
          $5 ?? (state.position = $6);
        }
        (int,)? $3 = $5 ?? state.fail<int>();
        if ($3 != null) {
          int n = $3.$1;
          parseS(state);
          (int,)? $4 = parseProduct(state);
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
  ///```code
  /// `void `
  /// S =
  ///    `void ` [ {9}{d}{a}]*
  ///```
  (void,)? parseS(State state) {
    final $list = <int>[];
    while (true) {
      final $3 = state.position;
      (int,)? $2;
      if (state.position < state.length) {
        final c = state.nextChar16();
        final ok = c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10;
        $2 = ok ? (c,) : null;
        $2 ?? (state.position = $3);
      }
      final $1 = $2 ?? state.fail<int>();
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
  ///```code
  /// `int`
  /// Start =
  ///    S $ = Expr EOF
  ///```
  (int,)? parseStart(State state) {
    final $3 = state.position;
    (int,)? $0;
    parseS(state);
    (int,)? $1 = parseExpr(state);
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
  ///```code
  /// `int`
  /// Sum =
  ///    $ = Product n = [\-+] S r = Product { }*
  ///```
  (int,)? parseSum(State state) {
    (int,)? $0;
    (int,)? $1 = parseProduct(state);
    if ($1 != null) {
      int $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        (int,)? $5;
        if (state.position < state.length) {
          final c = state.nextChar16();
          final ok = c == 43 || c == 45;
          $5 = ok ? (c,) : null;
          $5 ?? (state.position = $6);
        }
        (int,)? $3 = $5 ?? state.fail<int>();
        if ($3 != null) {
          int n = $3.$1;
          parseS(state);
          (int,)? $4 = parseProduct(state);
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
  ///```code
  /// `int`
  /// Value =
  ///    (NUMBER / i = ID $ = { } / '(' S $ = Expr ')' S)
  ///```
  (int,)? parseValue(State state) {
    final $7 = state.enter();
    final $1 = state.position;
    (int,)? $0;
    $0 = parseNUMBER(state);
    if ($0 == null) {
      (String,)? $2 = parseID(state);
      if ($2 != null) {
        String i = $2.$1;
        late int $$;
        $$ = vars[i]!;
        (int,)? $3 = ($$,);
        int $ = $3.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        final $4 = state.matchLiteral1(('(',), '(', 40);
        if ($4 != null) {
          parseS(state);
          (int,)? $5 = parseExpr(state);
          if ($5 != null) {
            int $ = $5.$1;
            final $6 = state.matchLiteral1((')',), ')', 41);
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
    state.expected($0, 'expression', $1, false);
    state.leave($7);
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// Indicates that parsing occurs within a `not' predicate`.
  ///
  /// When parsed within the `not predicate`, all `expected` errors are
  /// converted to `unexpected` errors.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  int _errorIndex = 0;

  int _expectedIndex = 0;

  final List<String?> _expected = List.filled(128, null);

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  int _farthestUnexpected = 0;

  final String _input;

  final List<bool?> _locations = List.filled(128, null);

  final List<String?> _messages = List.filled(128, null);

  final List<int?> _positions = List.filled(128, null);

  int _unexpectedIndex = 0;

  final List<String?> _unexpectedElements = List.filled(128, null);

  final List<int?> _unexpectedPositions = List.filled(128, null);

  State(String input)
      : _input = input,
        length = input.length;

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
      [bool literal = true]) {
    if (_farthestError > position) {
      return;
    }

    if (result != null) {
      if (!predicate || _farthestUnexpected > position) {
        return;
      }

      if (_farthestUnexpected < position) {
        _farthestUnexpected = position;
        _unexpectedIndex = 0;
      }

      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (_unexpectedIndex < _unexpectedElements.length) {
        _unexpectedElements[_unexpectedIndex] = element;
        _unexpectedPositions[_unexpectedIndex] = start;
        _unexpectedIndex++;
      }
    } else {
      if (!literal && failure != position) {
        return;
      }

      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (!literal) {
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
  (T,)? fail<T>([int length = 0]) {
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return null;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    _farthestFailureLength =
        _farthestFailureLength < length ? length : _farthestFailureLength;
    return null;
  }

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
  (R,)? match<R>((R,) result, String string) {
    final start = position;
    if (position + string.length <= length) {
      for (var i = 0; i < string.length; i++) {
        if (string.codeUnitAt(i) != nextChar16()) {
          position = start;
          return fail();
        }
      }
    }

    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match1<R>((R,) result, int c) {
    final start = position;
    if (position < length && c == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match2<R>((R,) result, int c1, int c2) {
    final start = position;
    if (position + 1 < length && c1 == nextChar16() && c2 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match3<R>((R,) result, int c1, int c2, int c3) {
    final start = position;
    if (position + 2 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match4<R>((R,) result, int c1, int c2, int c3, int c4) {
    final start = position;
    if (position + 3 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16() &&
        c4 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match5<R>((R,) result, int c1, int c2, int c3, int c4, int c5) {
    final start = position;
    if (position + 4 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16() &&
        c4 == nextChar16() &&
        c5 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchAny() {
    if (position < length) {
      return (nextChar32(),);
    }

    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (void,)? matchEof() {
    return position >= length ? (null,) : fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral<R>((R,) result, String literal) {
    final start = position;
    final actual = match(result, literal);
    expected(actual, literal, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral1<R>((R,) result, String string, int c) {
    final start = position;
    final actual = match1(result, c);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral2<R>((R,) result, String string, int c1, int c2) {
    final start = position;
    final actual = match2(result, c1, c2);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral3<R>((R,) result, String string, int c1, int c2, int c3) {
    final start = position;
    final actual = match3(result, c1, c2, c3);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral4<R>(
      (R,) result, String string, int c1, int c2, int c3, int c4) {
    final start = position;
    final actual = match4(result, c1, c2, c3, c4);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral5<R>(
      (R,) result, String string, int c1, int c2, int c3, int c4, int c5) {
    final start = position;
    final actual = match5(result, c1, c2, c3, c4, c5);
    expected(actual, string, start, true);
    return actual;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int nextChar16() => _input.codeUnitAt(position++);

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int nextChar32() {
    final c = _input.readChar(position);
    position += c > 0xffff ? 2 : 1;
    return c;
  }

  /// This method is for internal use only.
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

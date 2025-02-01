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
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result as int;
}

class CalcParser {
  CalcParser(this.vars);

  Map<String, int> vars = {};

  /// **EOF** ('end of file')
  ///
  ///```code
  /// `void`
  /// EOF =
  ///    !.
  ///```
  void parseEOF(State state) {
    final $1 = state.enter();
    // >> !.
    final $pos = state.position;
    final $0 = state.notPredicate;
    state.notPredicate = true;
    // >> .
    if (state.isSuccess = state.position < state.input.length) {
      final c = state.input.readChar(state.position);
      state.position += c > 0xffff ? 2 : 1;
    } else {
      state.fail();
    }
    // << .
    state.notPredicate = $0;
    if (!(state.isSuccess = !state.isSuccess)) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    // << !.
    state.expected('end of file', $pos, false);
    state.leave($1);
  }

  /// **Expr** ('expression')
  ///
  ///```code
  /// `int`
  /// Expr =
  ///    Sum
  ///```
  int? parseExpr(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    int? $0;
    // >> Sum
    $0 = parseSum(state);
    // << Sum
    state.expected('expression', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **ID**
  ///
  ///```code
  /// `String`
  /// ID =
  ///    n = <[a-zA-Z]> S $ = { }
  ///```
  String? parseID(State state) {
    String? $0;
    // >> n = <[a-zA-Z]> S $ = { }
    final $pos = state.position;
    // >> n = <[a-zA-Z]>
    String? $1;
    // >> [a-zA-Z]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c >= 65 && c <= 90 || c >= 97 && c <= 122;
      if (state.isSuccess) {
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [a-zA-Z]
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << n = <[a-zA-Z]>
    if (state.isSuccess) {
      String n = $1!;
      // >> S
      parseS(state);
      // << S
      if (state.isSuccess) {
        late String $$;
        // >> $ = { }
        String? $2;
        state.isSuccess = true;
        $$ = n;
        // << $ = { }
        $2 = $$;
        if (state.isSuccess) {
          String $ = $2;
          $0 = $;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << n = <[a-zA-Z]> S $ = { }
    return $0;
  }

  /// **NUMBER**
  ///
  ///```code
  /// `int`
  /// NUMBER =
  ///    n = <[0-9]+> S $ = { }
  ///```
  int? parseNUMBER(State state) {
    int? $0;
    // >> n = <[0-9]+> S $ = { }
    final $pos = state.position;
    // >> n = <[0-9]+>
    String? $1;
    // >> [0-9]+
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c >= 48 && c <= 57;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    if (!(state.isSuccess = $pos != state.position)) {
      state.fail();
    }
    // << [0-9]+
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << n = <[0-9]+>
    if (state.isSuccess) {
      String n = $1!;
      // >> S
      parseS(state);
      // << S
      if (state.isSuccess) {
        late int $$;
        // >> $ = { }
        int? $2;
        state.isSuccess = true;
        $$ = int.parse(n);
        // << $ = { }
        $2 = $$;
        if (state.isSuccess) {
          int $ = $2;
          $0 = $;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << n = <[0-9]+> S $ = { }
    return $0;
  }

  /// **Product**
  ///
  ///```code
  /// `int`
  /// Product =
  ///    l = Value [*] S r = Value { } / [/] S r = Value { }*
  ///```
  int? parseProduct(State state) {
    final $input = state.input;
    int? $0;
    // >> l = Value [*] S r = Value { } / [/] S r = Value { }*
    final $pos1 = state.position;
    // >> l = Value
    final $1 = parseValue(state);
    // << l = Value
    if (state.isSuccess) {
      int l = $1!;
      // >> [*] S r = Value { } / [/] S r = Value { }*
      while (true) {
        // >> [*] S r = Value { } / [/] S r = Value { }
        final $pos = state.position;
        // >> [*] S r = Value { }
        // >> [*]
        // *
        state.isSuccess = state.position < $input.length &&
            $input.codeUnitAt(state.position) == 42;
        state.isSuccess ? state.position++ : state.fail();
        // << [*]
        if (state.isSuccess) {
          // >> S
          parseS(state);
          // << S
          if (state.isSuccess) {
            // >> r = Value
            final $2 = parseValue(state);
            // << r = Value
            if (state.isSuccess) {
              int r = $2!;
              // >> { }
              state.isSuccess = true;
              l *= r;
              // << { }
            }
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << [*] S r = Value { }
        if (!state.isSuccess) {
          // >> [/] S r = Value { }
          // >> [/]
          // /
          state.isSuccess = state.position < $input.length &&
              $input.codeUnitAt(state.position) == 47;
          state.isSuccess ? state.position++ : state.fail();
          // << [/]
          if (state.isSuccess) {
            // >> S
            parseS(state);
            // << S
            if (state.isSuccess) {
              // >> r = Value
              final $3 = parseValue(state);
              // << r = Value
              if (state.isSuccess) {
                int r = $3!;
                // >> { }
                state.isSuccess = true;
                l ~/= r;
                // << { }
              }
            }
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
          // << [/] S r = Value { }
        }
        // << [*] S r = Value { } / [/] S r = Value { }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      // << [*] S r = Value { } / [/] S r = Value { }*
      $0 = l;
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    // << l = Value [*] S r = Value { } / [/] S r = Value { }*
    return $0;
  }

  /// **S**
  ///
  ///```code
  /// `void`
  /// S =
  ///    [ \t\r\n]*
  ///```
  void parseS(State state) {
    // >> [ \t\r\n]*
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    state.isSuccess = true;
    // << [ \t\r\n]*
  }

  /// **Start**
  ///
  ///```code
  /// `int`
  /// Start =
  ///    S e = Expr EOF
  ///```
  int? parseStart(State state) {
    int? $0;
    // >> S e = Expr EOF
    final $pos = state.position;
    // >> S
    parseS(state);
    // << S
    if (state.isSuccess) {
      // >> e = Expr
      final $1 = parseExpr(state);
      // << e = Expr
      if (state.isSuccess) {
        int e = $1!;
        // >> EOF
        parseEOF(state);
        // << EOF
        $0 = e;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << S e = Expr EOF
    return $0;
  }

  /// **Sum**
  ///
  ///```code
  /// `int`
  /// Sum =
  ///    l = Product [+] S r = Product { } / [\-] S r = Product { }*
  ///```
  int? parseSum(State state) {
    final $input = state.input;
    int? $0;
    // >> l = Product [+] S r = Product { } / [\-] S r = Product { }*
    final $pos1 = state.position;
    // >> l = Product
    final $1 = parseProduct(state);
    // << l = Product
    if (state.isSuccess) {
      int l = $1!;
      // >> [+] S r = Product { } / [\-] S r = Product { }*
      while (true) {
        // >> [+] S r = Product { } / [\-] S r = Product { }
        final $pos = state.position;
        // >> [+] S r = Product { }
        // >> [+]
        // +
        state.isSuccess = state.position < $input.length &&
            $input.codeUnitAt(state.position) == 43;
        state.isSuccess ? state.position++ : state.fail();
        // << [+]
        if (state.isSuccess) {
          // >> S
          parseS(state);
          // << S
          if (state.isSuccess) {
            // >> r = Product
            final $2 = parseProduct(state);
            // << r = Product
            if (state.isSuccess) {
              int r = $2!;
              // >> { }
              state.isSuccess = true;
              l += r;
              // << { }
            }
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << [+] S r = Product { }
        if (!state.isSuccess) {
          // >> [\-] S r = Product { }
          // >> [\-]
          // -
          state.isSuccess = state.position < $input.length &&
              $input.codeUnitAt(state.position) == 45;
          state.isSuccess ? state.position++ : state.fail();
          // << [\-]
          if (state.isSuccess) {
            // >> S
            parseS(state);
            // << S
            if (state.isSuccess) {
              // >> r = Product
              final $3 = parseProduct(state);
              // << r = Product
              if (state.isSuccess) {
                int r = $3!;
                // >> { }
                state.isSuccess = true;
                l -= r;
                // << { }
              }
            }
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
          // << [\-] S r = Product { }
        }
        // << [+] S r = Product { } / [\-] S r = Product { }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      // << [+] S r = Product { } / [\-] S r = Product { }*
      $0 = l;
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    // << l = Product [+] S r = Product { } / [\-] S r = Product { }*
    return $0;
  }

  /// **Value** ('expression')
  ///
  ///```code
  /// `int`
  /// Value =
  ///    (NUMBER / i = ID $ = { } / '(' S i = Expr ')' S)
  ///```
  int? parseValue(State state) {
    final $input = state.input;
    final $4 = state.enter();
    int? $0;
    // >> (NUMBER / i = ID $ = { } / '(' S i = Expr ')' S)
    final $pos = state.position;
    // >> NUMBER
    $0 = parseNUMBER(state);
    // << NUMBER
    if (!state.isSuccess) {
      // >> i = ID $ = { }
      // >> i = ID
      final $1 = parseID(state);
      // << i = ID
      if (state.isSuccess) {
        String i = $1!;
        late int $$;
        // >> $ = { }
        int? $2;
        state.isSuccess = true;
        $$ = vars[i]!;
        // << $ = { }
        $2 = $$;
        if (state.isSuccess) {
          int $ = $2;
          $0 = $;
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      // << i = ID $ = { }
      if (!state.isSuccess) {
        // >> '(' S i = Expr ')' S
        // >> '('
        const $literal = '(';
        state.isSuccess = $pos < $input.length && $input.codeUnitAt($pos) == 40;
        state.isSuccess ? state.position++ : state.fail();
        state.expected($literal, $pos);
        // << '('
        if (state.isSuccess) {
          // >> S
          parseS(state);
          // << S
          if (state.isSuccess) {
            // >> i = Expr
            final $3 = parseExpr(state);
            // << i = Expr
            if (state.isSuccess) {
              int i = $3!;
              // >> ')'
              final $pos1 = state.position;
              const $literal1 = ')';
              state.isSuccess =
                  $pos1 < $input.length && $input.codeUnitAt($pos1) == 41;
              state.isSuccess ? state.position++ : state.fail();
              state.expected($literal1, $pos1);
              // << ')'
              if (state.isSuccess) {
                // >> S
                parseS(state);
                // << S
                $0 = i;
              }
            }
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << '(' S i = Expr ')' S
      }
    }
    // << (NUMBER / i = ID $ = { } / '(' S i = Expr ')' S)
    state.expected('expression', $pos, false);
    state.leave($4);
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// Input data for parsing.
  String input;

  /// Indicator of the success of the parsing.
  bool isSuccess = false;

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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(String element, int start, [bool nested = true]) {
    if (_farthestError > position) {
      return;
    }

    if (isSuccess) {
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
    isSuccess = false;
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

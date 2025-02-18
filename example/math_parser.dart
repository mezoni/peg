//ignore_for_file: prefer_conditional_assignment, prefer_final_locals

import 'dart:math' as math;

import 'package:source_span/source_span.dart';

void main() {
  final data = <(String, Map<String, num>, Map<String, Function>)>[
    ('1 + -10.25e2', {}, {}),
    ('1 + a * 3', {'a': 2}, {}),
    ('sin(x)', {'x': 1}, {}),
    ('2^2^x', {'x': 2}, {}),
    ('sum(a, b)', {'a': 1, 'b': 2}, {'sum': (num x, num y) => x + y}),
    ('x * pi', {'x': 2}, {}),
  ];
  for (var i = 0; i < data.length; i++) {
    final element = data[i];
    final expression = element.$1;
    final variables = element.$2;
    final functions = element.$3;
    final result = eval(
      expression,
      functions: functions,
      variables: variables,
    );
    print('*' * 40);
    print(expression);
    if (variables.isNotEmpty) {
      print(variables.entries.map((e) => '${e.key}: ${e.value}').join(', '));
    }

    if (functions.isNotEmpty) {
      print(functions.keys.join(', '));
    }

    print(result);
  }
}

num eval(
  String source, {
  Map<String, Function> functions = const {},
  Map<String, num> variables = const {},
}) {
  final parser = MathParser(functions: functions, variables: variables);
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

class MathParser {
  Map<String, Function> functions = {
    'acos': math.acos,
    'asin': math.asin,
    'atan': math.atan,
    'atan2': math.atan2,
    'exp': math.exp,
    'cos': math.cos,
    'log': math.log,
    'max': math.max,
    'min': math.min,
    'pow': math.pow,
    'sin': math.sin,
    'sqrt': math.sqrt,
    'tan': math.tan,
  };

  Map<String, num> variables = {
    'e': math.e,
    'ln10': math.ln10,
    'ln2': math.ln2,
    'log10e': math.log10e,
    'pi': math.pi,
    'sqrt1_2': math.sqrt1_2,
    'sqrt2': math.sqrt2,
  };

  MathParser({
    Map<String, Function> functions = const {},
    Map<String, num> variables = const {},
  }) {
    this.functions.addAll(functions);
    this.variables.addAll(variables);
  }

  /// **Arguments**
  ///
  ///```text
  /// `List<num>`
  /// Arguments =>
  ///   e = Expression
  ///   $ = { final l = [e]; $$ = l; }
  ///   @while (*) (
  ///     ','
  ///     S
  ///     e = Expression
  ///     { l.add(e); }
  ///   )
  ///```
  (List<num>,)? parseArguments(State state) {
    final $7 = state.position;
    (List<num>,)? $0;
    final $1 = parseExpression(state);
    if ($1 != null) {
      num e = $1.$1;
      final List<num> $$;
      final l = [e];
      $$ = l;
      final $2 = ($$,);
      List<num> $ = $2.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $3;
        final $4 = state.matchLiteral1(',', 44);
        if ($4 != null) {
          parseS(state);
          final $5 = parseExpression(state);
          if ($5 != null) {
            num e = $5.$1;
            l.add(e);
            $3 = (null,);
          }
        }
        if ($3 == null) {
          state.position = $6;
        }
        if ($3 == null) {
          break;
        }
      }
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
  }

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
    state.nesting = $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
  }

  /// **Expression** ('expression')
  ///
  ///```text
  /// `num`
  /// Expression('expression') =>
  ///   Sum
  ///```
  (num,)? parseExpression(State state) {
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
    state.nesting = $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
  }

  /// **Function**
  ///
  ///```text
  /// `num`
  /// Function =>
  ///   i = Identifier
  ///   '('
  ///   S
  ///   a = Arguments?
  ///   ')'
  ///   S
  ///   $ = {
  ///     final f = functions[i];
  ///     if (f == null) {
  ///       throw StateError('Function not found: $i');
  ///     }
  ///     $$ = Function.apply(f, a ?? []) as num;
  ///   }
  ///```
  (num,)? parseFunction(State state) {
    final $6 = state.position;
    (num,)? $0;
    final $1 = parseIdentifier(state);
    if ($1 != null) {
      String i = $1.$1;
      final $2 = state.matchLiteral1('(', 40);
      if ($2 != null) {
        parseS(state);
        (List<num>?,)? $3 = parseArguments(state);
        $3 ??= (null,);
        List<num>? a = $3.$1;
        final $4 = state.matchLiteral1(')', 41);
        if ($4 != null) {
          parseS(state);
          final num $$;
          final f = functions[i];
          if (f == null) {
            throw StateError('Function not found: $i');
          }
          $$ = Function.apply(f, a ?? []) as num;
          final $5 = ($$,);
          num $ = $5.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $6;
    }
    return $0;
  }

  /// **Identifier**
  ///
  ///```text
  /// `String`
  /// Identifier =>
  ///   $ = <[a-zA-Z]+>
  ///   S
  ///```
  (String,)? parseIdentifier(State state) {
    final $3 = state.position;
    (String,)? $0;
    for (var c = state.peek(); c >= 97 ? c <= 122 : c >= 65 && c <= 90;) {
      state.advance();
      c = state.peek();
    }
    final $2 = state.position != $3 ? (null,) : state.fail<List<int>>();
    final $1 = $2 != null ? (state.substring($3, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      parseS(state);
      $0 = ($,);
    }
    return $0;
  }

  /// **Number** ('number')
  ///
  ///```text
  /// `num`
  /// Number('number') =>
  ///   { var ok = true; }
  ///   n = <
  ///     [\-]?
  ///     <[0-9]+>
  ///     (
  ///       [.]
  ///       { ok = false; }
  ///       (
  ///         <[0-9]+>
  ///         { ok = true; }
  ///          ~ { message = 'Expected decimal digit' }
  ///       )
  ///     )?
  ///     (
  ///       [eE]
  ///       { ok = false; }
  ///       (
  ///         [\-+]?
  ///         <[0-9]+>
  ///         { ok = true; }
  ///          ~ { message = 'Expected decimal digit' }
  ///       )
  ///     )?
  ///   >
  ///   &{ ok }
  ///   S
  ///   $ = { $$ = num.parse(n); }
  ///```
  (num,)? parseNumber(State state) {
    final $25 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $26 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (num,)? $0;
    var ok = true;
    final $6 = state.position;
    (void,)? $5;
    state.peek() == 45 ? (state.advance(),) : state.fail<int>();
    final $9 = state.position;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.advance();
      c = state.peek();
    }
    final $8 = state.position != $9 ? (null,) : state.fail<List<int>>();
    final $7 = $8 != null ? (state.substring($9, state.position),) : null;
    if ($7 != null) {
      final $10 = state.peek() == 46 ? (state.advance(),) : state.fail<int>();
      if ($10 != null) {
        ok = false;
        final $15 = state.position;
        final $12 = state.failure;
        state.failure = state.position;
        (void,)? $11;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        final $14 = state.position != $15 ? (null,) : state.fail<List<int>>();
        final $13 =
            $14 != null ? (state.substring($15, state.position),) : null;
        if ($13 != null) {
          ok = true;
          $11 = (null,);
        }
        if ($11 == null) {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
        }
        state.failure = state.failure < $12 ? $12 : state.failure;
      }
      final $18 = state.peek();
      final $16 =
          $18 == 69 || $18 == 101 ? (state.advance(),) : state.fail<int>();
      if ($16 != null) {
        ok = false;
        final $24 = state.position;
        final $19 = state.failure;
        state.failure = state.position;
        (void,)? $17;
        final $21 = state.peek();
        $21 == 43 || $21 == 45 ? (state.advance(),) : state.fail<int>();
        final $23 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        final $22 = state.position != $23 ? (null,) : state.fail<List<int>>();
        final $20 =
            $22 != null ? (state.substring($23, state.position),) : null;
        if ($20 != null) {
          ok = true;
          $17 = (null,);
        }
        if ($17 == null) {
          state.position = $24;
        }
        if ($17 == null) {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
        }
        state.failure = state.failure < $19 ? $19 : state.failure;
      }
      $5 = (null,);
    }
    if ($5 == null) {
      state.position = $6;
    }
    final $2 = $5 != null ? (state.substring($6, state.position),) : null;
    if ($2 != null) {
      String n = $2.$1;
      final $3 = ok ? (null,) : state.fail<void>();
      if ($3 != null) {
        parseS(state);
        final num $$;
        $$ = num.parse(n);
        final $4 = ($$,);
        num $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    if (state.failure == $1 && $25 < state.nesting) {
      state.expected($0, 'number', $1, state.position);
    }
    state.nesting = $25;
    state.failure = state.failure < $26 ? $26 : state.failure;
    return $0;
  }

  /// **Pow**
  ///
  ///```text
  /// `num`
  /// Pow =>
  ///   $ = Value
  ///   @while (*) (
  ///     [\^]
  ///     S
  ///     r = Value
  ///     { $ = math.pow($, r); }
  ///   )
  ///```
  (num,)? parsePow(State state) {
    (num,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $5 = state.position;
        (void,)? $2;
        final $3 = state.peek() == 94 ? (state.advance(),) : state.fail<int>();
        if ($3 != null) {
          parseS(state);
          final $4 = parseValue(state);
          if ($4 != null) {
            num r = $4.$1;
            $ = math.pow($, r);
            $2 = (null,);
          }
        }
        if ($2 == null) {
          state.position = $5;
        }
        if ($2 == null) {
          break;
        }
      }
      $0 = ($,);
    }
    return $0;
  }

  /// **Product**
  ///
  ///```text
  /// `num`
  /// Product =>
  ///   $ = Unary
  ///   @while (*) (
  ///     [*]
  ///     S
  ///     r = Unary
  ///     { $ *= r; }
  ///     ----
  ///     [/]
  ///     S
  ///     r = Unary
  ///     { $ ~/= r; }
  ///   )
  ///```
  (num,)? parseProduct(State state) {
    (num,)? $0;
    final $1 = parseUnary(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $5 = state.position;
        (void,)? $2;
        final $3 = state.peek() == 42 ? (state.advance(),) : state.fail<int>();
        if ($3 != null) {
          parseS(state);
          final $4 = parseUnary(state);
          if ($4 != null) {
            num r = $4.$1;
            $ *= r;
            $2 = (null,);
          }
        }
        if ($2 == null) {
          state.position = $5;
        }
        if ($2 == null) {
          final $6 =
              state.peek() == 47 ? (state.advance(),) : state.fail<int>();
          if ($6 != null) {
            parseS(state);
            final $7 = parseUnary(state);
            if ($7 != null) {
              num r = $7.$1;
              $ ~/= r;
              $2 = (null,);
            }
          }
          if ($2 == null) {
            state.position = $5;
          }
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
  /// `void`
  /// S =>
  ///   [ {9}{d}{a}]*
  ///```
  (void,)? parseS(State state) {
    for (var c = state.peek();
        c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10;) {
      state.advance();
      c = state.peek();
    }
    const $0 = (null,);
    return $0;
  }

  /// **Start**
  ///
  ///```text
  /// `num`
  /// Start =>
  ///   S
  ///   $ = Expression
  ///   EOF
  ///```
  (num,)? parseStart(State state) {
    final $3 = state.position;
    (num,)? $0;
    parseS(state);
    final $1 = parseExpression(state);
    if ($1 != null) {
      num $ = $1.$1;
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
  /// `num`
  /// Sum =>
  ///   $ = Product
  ///   @while (*) (
  ///     [+]
  ///     S
  ///     r = Product
  ///     { $ += r; }
  ///     ----
  ///     [\-]
  ///     S
  ///     r = Product
  ///     { $ -= r; }
  ///   )
  ///```
  (num,)? parseSum(State state) {
    (num,)? $0;
    final $1 = parseProduct(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $5 = state.position;
        (void,)? $2;
        final $3 = state.peek() == 43 ? (state.advance(),) : state.fail<int>();
        if ($3 != null) {
          parseS(state);
          final $4 = parseProduct(state);
          if ($4 != null) {
            num r = $4.$1;
            $ += r;
            $2 = (null,);
          }
        }
        if ($2 == null) {
          state.position = $5;
        }
        if ($2 == null) {
          final $6 =
              state.peek() == 45 ? (state.advance(),) : state.fail<int>();
          if ($6 != null) {
            parseS(state);
            final $7 = parseProduct(state);
            if ($7 != null) {
              num r = $7.$1;
              $ -= r;
              $2 = (null,);
            }
          }
          if ($2 == null) {
            state.position = $5;
          }
        }
        if ($2 == null) {
          break;
        }
      }
      $0 = ($,);
    }
    return $0;
  }

  /// **Unary**
  ///
  ///```text
  /// `num`
  /// Unary =>
  ///   n = [\-]?
  ///   e = Pow
  ///   $ = { $$ = n == null ? e : -e; }
  ///```
  (num,)? parseUnary(State state) {
    final $4 = state.position;
    (num,)? $0;
    (int?,)? $1 = state.peek() == 45 ? (state.advance(),) : state.fail<int>();
    $1 ??= (null,);
    int? n = $1.$1;
    final $2 = parsePow(state);
    if ($2 != null) {
      num e = $2.$1;
      final num $$;
      $$ = n == null ? e : -e;
      final $3 = ($$,);
      num $ = $3.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $4;
    }
    return $0;
  }

  /// **Value** ('expression')
  ///
  ///```text
  /// `num`
  /// Value('expression') =>
  ///   (
  ///     Function
  ///     ----
  ///     Number
  ///     ----
  ///     i = Identifier
  ///     $ = {
  ///       final v = variables[i];
  ///       if (v == null) {
  ///         throw StateError('Variable not found: $i');
  ///       }
  ///       $$ = v;
  ///     }
  ///     ----
  ///     '('
  ///     S
  ///     $ = Expression
  ///     ')'
  ///     S
  ///   )
  ///```
  (num,)? parseValue(State state) {
    final $7 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $8 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (num,)? $0;
    $0 = parseFunction(state);
    if ($0 == null) {
      $0 = parseNumber(state);
      if ($0 == null) {
        final $2 = parseIdentifier(state);
        if ($2 != null) {
          String i = $2.$1;
          final num $$;
          final v = variables[i];
          if (v == null) {
            throw StateError('Variable not found: $i');
          }
          $$ = v;
          final $3 = ($$,);
          num $ = $3.$1;
          $0 = ($,);
        }
        if ($0 == null) {
          final $4 = state.matchLiteral1('(', 40);
          if ($4 != null) {
            parseS(state);
            final $5 = parseExpression(state);
            if ($5 != null) {
              num $ = $5.$1;
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
    }
    if (state.failure == $1 && $7 < state.nesting) {
      state.expected($0, 'expression', $1, state.position);
    }
    state.nesting = $7;
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

// ignore_for_file: prefer_conditional_assignment, prefer_final_locals

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
  /// Arguments =
  ///    e = Expression $ = { } (',' S e = Expression { })*
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
        final $4 = state.matchLiteral1((',',), ',', 44);
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
  /// EOF =
  ///    !.
  ///```
  (void,)? parseEOF(State state) {
    final $2 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    final $0 = state.matchEof();
    state.expected($0, 'end of file', $1, false);
    state.failure = state.failure < $2 ? $2 : state.failure;
    return $0;
  }

  /// **Expression** ('expression')
  ///
  ///```text
  /// `num`
  /// Expression =
  ///    Sum
  ///```
  (num,)? parseExpression(State state) {
    final $2 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    final $0 = parseSum(state);
    state.expected($0, 'expression', $1, false);
    state.failure = state.failure < $2 ? $2 : state.failure;
    return $0;
  }

  /// **Function**
  ///
  ///```text
  /// `num`
  /// Function =
  ///    i = Identifier '(' S a = Arguments? ')' S $ = { }
  ///```
  (num,)? parseFunction(State state) {
    final $6 = state.position;
    (num,)? $0;
    final $1 = parseIdentifier(state);
    if ($1 != null) {
      String i = $1.$1;
      final $2 = state.matchLiteral1(('(',), '(', 40);
      if ($2 != null) {
        parseS(state);
        (List<num>?,)? $3 = parseArguments(state);
        $3 ??= (null,);
        List<num>? a = $3.$1;
        final $4 = state.matchLiteral1((')',), ')', 41);
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
  /// Identifier =
  ///    $ = <[a-zA-Z]+> S
  ///```
  (String,)? parseIdentifier(State state) {
    final $3 = state.position;
    (String,)? $0;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c >= 97 ? c <= 122 : c >= 65 && c <= 90;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    final $2 =
        state.position != $3 ? const (<int>[],) : state.fail<List<int>>();
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
  /// Number =
  ///    { } n = <[\-]? <[0-9]+> ([.] { } (<[0-9]+> { } ~ { message = 'Expected decimal digit' }))? ([eE] { } ([\-+]? <[0-9]+> { } ~ { message = 'Expected decimal digit' }))?> &{ } S $ = { }
  ///```
  (num,)? parseNumber(State state) {
    final $32 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (num,)? $0;
    var ok = true;
    final $31 = state.position;
    final $8 = state.position;
    (void,)? $5;
    (int,)? $7;
    if (state.position < state.length) {
      final c = state.nextChar16();
      $7 = c == 45 ? (45,) : null;
      $7 ?? (state.position = $8);
    }
    $7 ?? state.fail<int>();
    final $11 = state.position;
    final $10 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c >= 48 && c <= 57;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    final $9 =
        state.position != $10 ? const (<int>[],) : state.fail<List<int>>();
    final $6 = $9 != null ? (state.substring($11, state.position),) : null;
    if ($6 != null) {
      final $15 = state.position;
      (int,)? $14;
      if (state.position < state.length) {
        final c = state.nextChar16();
        $14 = c == 46 ? (46,) : null;
        $14 ?? (state.position = $15);
      }
      final $12 = $14 ?? state.fail<int>();
      if ($12 != null) {
        ok = false;
        final $19 = state.position;
        final $16 = state.failure;
        state.failure = state.position;
        (void,)? $13;
        while (state.position < state.length) {
          final position = state.position;
          final c = state.nextChar16();
          final ok = c >= 48 && c <= 57;
          if (!ok) {
            state.position = position;
            break;
          }
        }
        final $18 =
            state.position != $19 ? const (<int>[],) : state.fail<List<int>>();
        final $17 =
            $18 != null ? (state.substring($19, state.position),) : null;
        if ($17 != null) {
          ok = true;
          $13 = (null,);
        }
        if ($13 == null) {
          state.error('Expected decimal digit');
        }
        state.failure = state.failure < $16 ? $16 : state.failure;
        if ($13 != null) {}
      }
      final $23 = state.position;
      (int,)? $22;
      if (state.position < state.length) {
        final c = state.nextChar16();
        final ok = c == 69 || c == 101;
        $22 = ok ? (c,) : null;
        $22 ?? (state.position = $23);
      }
      final $20 = $22 ?? state.fail<int>();
      if ($20 != null) {
        ok = false;
        final $27 = state.position;
        final $24 = state.failure;
        state.failure = state.position;
        (void,)? $21;
        (int,)? $26;
        if (state.position < state.length) {
          final c = state.nextChar16();
          final ok = c == 43 || c == 45;
          $26 = ok ? (c,) : null;
          $26 ?? (state.position = $27);
        }
        $26 ?? state.fail<int>();
        final $30 = state.position;
        final $29 = state.position;
        while (state.position < state.length) {
          final position = state.position;
          final c = state.nextChar16();
          final ok = c >= 48 && c <= 57;
          if (!ok) {
            state.position = position;
            break;
          }
        }
        final $28 =
            state.position != $29 ? const (<int>[],) : state.fail<List<int>>();
        final $25 =
            $28 != null ? (state.substring($30, state.position),) : null;
        if ($25 != null) {
          ok = true;
          $21 = (null,);
        }
        if ($21 == null) {
          state.position = $27;
        }
        if ($21 == null) {
          state.error('Expected decimal digit');
        }
        state.failure = state.failure < $24 ? $24 : state.failure;
        if ($21 != null) {}
      }
      $5 = (null,);
    }
    if ($5 == null) {
      state.position = $8;
    }
    final $2 = $5 != null ? (state.substring($31, state.position),) : null;
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
    state.expected($0, 'number', $1, false);
    state.failure = state.failure < $32 ? $32 : state.failure;
    return $0;
  }

  /// **Pow**
  ///
  ///```text
  /// `num`
  /// Pow =
  ///    $ = Value ([^] S r = Value { })*
  ///```
  (num,)? parsePow(State state) {
    (num,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        (int,)? $5;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $5 = c == 94 ? (94,) : null;
          $5 ?? (state.position = $6);
        }
        final $3 = $5 ?? state.fail<int>();
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

  /// **Product**
  ///
  ///```text
  /// `num`
  /// Product =
  ///    $ = Unary ([*] S r = Unary { } / [/] S r = Unary { })*
  ///```
  (num,)? parseProduct(State state) {
    (num,)? $0;
    final $1 = parseUnary(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        (int,)? $5;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $5 = c == 42 ? (42,) : null;
          $5 ?? (state.position = $6);
        }
        final $3 = $5 ?? state.fail<int>();
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
          state.position = $6;
        }
        if ($2 == null) {
          (int,)? $9;
          if (state.position < state.length) {
            final c = state.nextChar16();
            $9 = c == 47 ? (47,) : null;
            $9 ?? (state.position = $6);
          }
          final $7 = $9 ?? state.fail<int>();
          if ($7 != null) {
            parseS(state);
            final $8 = parseUnary(state);
            if ($8 != null) {
              num r = $8.$1;
              $ ~/= r;
              $2 = (null,);
            }
          }
          if ($2 == null) {
            state.position = $6;
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
  /// S =
  ///    [ {9}{d}{a}]*
  ///```
  (void,)? parseS(State state) {
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c >= 13 ? c <= 13 || c == 32 : c >= 9 && c <= 10;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    const $0 = (<int>[],);
    return $0;
  }

  /// **Start**
  ///
  ///```text
  /// `num`
  /// Start =
  ///    S $ = Expression EOF
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
  /// Sum =
  ///    $ = Product ([+] S r = Product { } / [\-] S r = Product { })*
  ///```
  (num,)? parseSum(State state) {
    (num,)? $0;
    final $1 = parseProduct(state);
    if ($1 != null) {
      num $ = $1.$1;
      while (true) {
        final $6 = state.position;
        (void,)? $2;
        (int,)? $5;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $5 = c == 43 ? (43,) : null;
          $5 ?? (state.position = $6);
        }
        final $3 = $5 ?? state.fail<int>();
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
          state.position = $6;
        }
        if ($2 == null) {
          (int,)? $9;
          if (state.position < state.length) {
            final c = state.nextChar16();
            $9 = c == 45 ? (45,) : null;
            $9 ?? (state.position = $6);
          }
          final $7 = $9 ?? state.fail<int>();
          if ($7 != null) {
            parseS(state);
            final $8 = parseProduct(state);
            if ($8 != null) {
              num r = $8.$1;
              $ -= r;
              $2 = (null,);
            }
          }
          if ($2 == null) {
            state.position = $6;
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
  /// Unary =
  ///    n = [\-]? e = Pow $ = { }
  ///```
  (num,)? parseUnary(State state) {
    final $5 = state.position;
    (num,)? $0;
    (int,)? $4;
    if (state.position < state.length) {
      final c = state.nextChar16();
      $4 = c == 45 ? (45,) : null;
      $4 ?? (state.position = $5);
    }
    (int?,)? $1 = $4 ?? state.fail<int>();
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
      state.position = $5;
    }
    return $0;
  }

  /// **Value** ('expression')
  ///
  ///```text
  /// `num`
  /// Value =
  ///    (Function / Number / i = Identifier $ = { } / '(' S $ = Expression ')' S)
  ///```
  (num,)? parseValue(State state) {
    final $7 = state.failure;
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
          final $4 = state.matchLiteral1(('(',), '(', 40);
          if ($4 != null) {
            parseS(state);
            final $5 = parseExpression(state);
            if ($5 != null) {
              num $ = $5.$1;
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
    }
    state.expected($0, 'expression', $1, false);
    state.failure = state.failure < $7 ? $7 : state.failure;
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

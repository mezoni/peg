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
    (List<num>,)? $0;
    final $1 = parseExpression(state);
    if ($1 != null) {
      num e = $1.$1;
      final List<num> $$;
      final l = [e];
      $$ = l;
      List<num> $ = $$;
      while (true) {
        final $3 = state.position;
        var $2 = false;
        if (state.peek() == 44) {
          state.consume(',', $3);
          parseS(state);
          final $4 = parseExpression(state);
          if ($4 != null) {
            num e = $4.$1;
            l.add(e);
            $2 = true;
          }
        } else {
          state.expected(',');
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

  /// **Expression** ('expression')
  ///
  ///```text
  /// `num`
  /// Expression('expression') =>
  ///   @expected('expression') { Sum }
  ///```
  (num,)? parseExpression(State state) {
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
    final $1 = state.position;
    (num,)? $0;
    final $2 = parseIdentifier(state);
    if ($2 != null) {
      String i = $2.$1;
      final $3 = state.position;
      if (state.peek() == 40) {
        state.consume('(', $3);
        parseS(state);
        List<num>? $5;
        final $4 = parseArguments(state);
        if ($4 != null) {
          $5 = $4.$1;
        }
        List<num>? a = $5;
        final $6 = state.position;
        if (state.peek() == 41) {
          state.consume(')', $6);
          parseS(state);
          final num $$;
          final f = functions[i];
          if (f == null) {
            throw StateError('Function not found: $i');
          }
          $$ = Function.apply(f, a ?? []) as num;
          num $ = $$;
          $0 = ($,);
        } else {
          state.expected(')');
        }
      } else {
        state.expected('(');
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
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
    final $1 = state.position;
    (String,)? $0;
    for (var c = state.peek(); c >= 97 ? c <= 122 : c >= 65 && c <= 90;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($1 != state.position) {
      final $2 = state.substring($1, state.position);
      String $ = $2;
      parseS(state);
      $0 = ($,);
    } else {
      state.fail();
    }
    return $0;
  }

  /// **Number** ('number')
  ///
  ///```text
  /// `num`
  /// Number('number') =>
  ///   @expected('number') { { var ok = true; }
  ///   n = <
  ///     [0-9]+
  ///     (
  ///       [.]
  ///       { ok = false; }
  ///       (
  ///         [0-9]+
  ///         { ok = true; }
  ///          ~ { message = 'Expected decimal digit' }
  ///       )
  ///     )?
  ///     (
  ///       [eE]
  ///       { ok = false; }
  ///       (
  ///         [\-+]?
  ///         [0-9]+
  ///         { ok = true; }
  ///          ~ { message = 'Expected decimal digit' }
  ///       )
  ///     )?
  ///   >
  ///   &{ ok }
  ///   S
  ///   $ = { num.parse(n) } }
  ///```
  (num,)? parseNumber(State state) {
    final $0 = state.position;
    const $18 = 'number';
    final $19 = state.failure;
    final $20 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (num,)? $1;
    var ok = true;
    final $2 = state.position;
    var $3 = false;
    for (var c = state.peek(); c >= 48 && c <= 57;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($2 != state.position) {
      final $5 = state.position;
      var $4 = false;
      if (state.peek() == 46) {
        state.position += state.charSize(46);
        ok = false;
        final $8 = state.failure;
        state.failure = state.position;
        var $6 = false;
        final $7 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        if ($7 != state.position) {
          ok = true;
          $6 = true;
        } else {
          state.fail();
        }
        if ($6) {
          state.failure < $8 ? state.failure = $8 : null;
          $4 = true;
        } else {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
          state.failure < $8 ? state.failure = $8 : null;
        }
      } else {
        state.fail();
      }
      if (!$4) {
        state.position = $5;
      }
      final $10 = state.position;
      var $9 = false;
      final $11 = state.peek();
      if ($11 == 69 || $11 == 101) {
        state.position += state.charSize($11);
        ok = false;
        final $16 = state.failure;
        state.failure = state.position;
        final $13 = state.position;
        var $12 = false;
        final $14 = state.peek();
        if ($14 == 43 || $14 == 45) {
          state.position += state.charSize($14);
        } else {
          state.fail();
        }
        final $15 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        if ($15 != state.position) {
          ok = true;
          $12 = true;
        } else {
          state.fail();
        }
        if ($12) {
          state.failure < $16 ? state.failure = $16 : null;
          $9 = true;
        } else {
          state.position = $13;
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
          state.failure < $16 ? state.failure = $16 : null;
        }
      } else {
        state.fail();
      }
      if (!$9) {
        state.position = $10;
      }
      $3 = true;
    } else {
      state.fail();
    }
    if ($3) {
      final $17 = state.substring($2, state.position);
      String n = $17;
      if (ok) {
        parseS(state);
        num $ = num.parse(n);
        $1 = ($,);
      }
    }
    if ($1 != null) {
      state.onSuccess($18, $0, $20);
      return $1;
    } else {
      state.position = $0;
      state.onFailure($18, $0, $20, $19);
      return null;
    }
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
        final $3 = state.position;
        var $2 = false;
        if (state.peek() == 94) {
          state.position += state.charSize(94);
          parseS(state);
          final $4 = parseValue(state);
          if ($4 != null) {
            num r = $4.$1;
            $ = math.pow($, r);
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
        var $2 = true;
        final $4 = state.position;
        var $3 = false;
        if (state.peek() == 42) {
          state.position += state.charSize(42);
          parseS(state);
          final $5 = parseUnary(state);
          if ($5 != null) {
            num r = $5.$1;
            $ *= r;
            $3 = true;
          }
        } else {
          state.fail();
        }
        if (!$3) {
          state.position = $4;
          final $7 = state.position;
          var $6 = false;
          if (state.peek() == 47) {
            state.position += state.charSize(47);
            parseS(state);
            final $8 = parseUnary(state);
            if ($8 != null) {
              num r = $8.$1;
              $ ~/= r;
              $6 = true;
            }
          } else {
            state.fail();
          }
          if (!$6) {
            state.position = $7;
            $2 = false;
          }
        }
        if (!$2) {
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
  /// `num`
  /// Start =>
  ///   S
  ///   $ = Expression
  ///   EOF
  ///```
  (num,)? parseStart(State state) {
    final $1 = state.position;
    (num,)? $0;
    parseS(state);
    final $2 = parseExpression(state);
    if ($2 != null) {
      num $ = $2.$1;
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
        var $2 = true;
        final $4 = state.position;
        var $3 = false;
        if (state.peek() == 43) {
          state.position += state.charSize(43);
          parseS(state);
          final $5 = parseProduct(state);
          if ($5 != null) {
            num r = $5.$1;
            $ += r;
            $3 = true;
          }
        } else {
          state.fail();
        }
        if (!$3) {
          state.position = $4;
          final $7 = state.position;
          var $6 = false;
          if (state.peek() == 45) {
            state.position += state.charSize(45);
            parseS(state);
            final $8 = parseProduct(state);
            if ($8 != null) {
              num r = $8.$1;
              $ -= r;
              $6 = true;
            }
          } else {
            state.fail();
          }
          if (!$6) {
            state.position = $7;
            $2 = false;
          }
        }
        if (!$2) {
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
  ///   $ = { n == null ? e : -e }
  ///```
  (num,)? parseUnary(State state) {
    final $1 = state.position;
    (num,)? $0;
    int? $2;
    if (state.peek() == 45) {
      state.position += state.charSize(45);
      $2 = 45;
    } else {
      state.fail();
    }
    int? n = $2;
    final $3 = parsePow(state);
    if ($3 != null) {
      num e = $3.$1;
      num $ = n == null ? e : -e;
      $0 = ($,);
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Value** ('expression')
  ///
  ///```text
  /// `num`
  /// Value('expression') =>
  ///   @expected('expression') { (
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
  ///   ) }
  ///```
  (num,)? parseValue(State state) {
    final $0 = state.position;
    const $9 = 'expression';
    final $10 = state.failure;
    final $11 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (num,)? $1;
    final $2 = parseFunction(state);
    if ($2 != null) {
      $1 = $2;
    } else {
      final $3 = parseNumber(state);
      if ($3 != null) {
        $1 = $3;
      } else {
        (num,)? $4;
        final $5 = parseIdentifier(state);
        if ($5 != null) {
          String i = $5.$1;
          final num $$;
          final v = variables[i];
          if (v == null) {
            throw StateError('Variable not found: $i');
          }
          $$ = v;
          num $ = $$;
          $4 = ($,);
        }
        if ($4 != null) {
          $1 = $4;
        } else {
          (num,)? $6;
          if (state.peek() == 40) {
            state.consume('(', $0);
            parseS(state);
            final $7 = parseExpression(state);
            if ($7 != null) {
              num $ = $7.$1;
              final $8 = state.position;
              if (state.peek() == 41) {
                state.consume(')', $8);
                parseS(state);
                $6 = ($,);
              } else {
                state.expected(')');
              }
            }
          } else {
            state.expected('(');
          }
          if ($6 != null) {
            $1 = $6;
          } else {
            state.position = $0;
          }
        }
      }
    }
    if ($1 != null) {
      state.onSuccess($9, $0, $11);
      return $1;
    } else {
      state.onFailure($9, $0, $11, $10);
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

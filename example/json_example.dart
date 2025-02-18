//ignore_for_file: prefer_conditional_assignment, prefer_final_locals

import 'package:source_span/source_span.dart';

void main(List<String> args) {
  const source = '{"rocket": "🚀 flies to the stars"}';
  final result = parse(source);
  print(result);
}

Object? parse(String source) {
  final state = State(source);
  final parser = JsonParser();
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

class JsonParser {
  /// **Array**
  ///
  ///```text
  /// `List<Object?>`
  /// Array =>
  ///   '['
  ///   S
  ///   n = Values?
  ///   ']'
  ///   S
  ///   $ = { $$ = n ?? const []; }
  ///```
  (List<Object?>,)? parseArray(State state) {
    final $5 = state.position;
    (List<Object?>,)? $0;
    final $1 = state.matchLiteral1('[', 91);
    if ($1 != null) {
      parseS(state);
      (List<Object?>?,)? $2 = parseValues(state);
      $2 ??= (null,);
      List<Object?>? n = $2.$1;
      final $3 = state.matchLiteral1(']', 93);
      if ($3 != null) {
        parseS(state);
        final List<Object?> $$;
        $$ = n ?? const [];
        final $4 = ($$,);
        List<Object?> $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $5;
    }
    return $0;
  }

  /// **Boolean** ('boolean')
  ///
  ///```text
  /// `bool`
  /// Boolean('boolean') =>
  ///   'false'
  ///   S
  ///   $ = { $$ = false; }
  ///   ----
  ///   'true'
  ///   S
  ///   $ = { $$ = true; }
  ///```
  (bool,)? parseBoolean(State state) {
    final $6 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $7 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (bool,)? $0;
    final $2 = state.matchLiteral('false');
    if ($2 != null) {
      parseS(state);
      final bool $$;
      $$ = false;
      final $3 = ($$,);
      bool $ = $3.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $1;
    }
    if ($0 == null) {
      final $4 = state.matchLiteral('true');
      if ($4 != null) {
        parseS(state);
        final bool $$;
        $$ = true;
        final $5 = ($$,);
        bool $ = $5.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        state.position = $1;
      }
    }
    if (state.failure == $1 && $6 < state.nesting) {
      state.expected($0, 'boolean', $1, state.position);
    }
    state.nesting = $6;
    state.failure = state.failure < $7 ? $7 : state.failure;
    return $0;
  }

  /// **Chars**
  ///
  ///```text
  /// `String`
  /// Chars =>
  ///   n = @while (+) (
  ///     Unescaped
  ///     ----
  ///     [\\]
  ///     $ = Escaped
  ///   )
  ///   $ = { $$ = n.join(); }
  ///```
  (String,)? parseChars(State state) {
    (String,)? $0;
    final $list = <String>[];
    while (true) {
      final $6 = state.position;
      (String,)? $3;
      $3 = parseUnescaped(state);
      if ($3 == null) {
        final $4 = state.peek() == 92 ? (state.advance(),) : state.fail<int>();
        if ($4 != null) {
          final $5 = parseEscaped(state);
          if ($5 != null) {
            String $ = $5.$1;
            $3 = ($,);
          }
        }
        if ($3 == null) {
          state.position = $6;
        }
      }
      if ($3 == null) {
        break;
      }
      $list.add($3.$1);
    }
    final $1 = $list.isNotEmpty ? ($list,) : state.fail<List<String>>();
    if ($1 != null) {
      List<String> n = $1.$1;
      final String $$;
      $$ = n.join();
      final $2 = ($$,);
      String $ = $2.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Eof** ('end of file')
  ///
  ///```text
  /// `void`
  /// Eof('end of file') =>
  ///   !.
  ///```
  (void,)? parseEof(State state) {
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

  /// **Escaped** ('Malformed escape sequence')
  ///
  ///```text
  /// `String`
  /// Escaped('Malformed escape sequence') =>
  ///   [u]
  ///   $ = Hex
  ///   ----
  ///   c = ["/\\bfnrt]
  ///   $ = { $$ = switch(c) {
  ///         0x22 => '"',
  ///         0x5C => '\\',
  ///         0x2F => '/',
  ///         0x62 => '\b',
  ///         0x66 => '\f',
  ///         0x6E => '\n',
  ///         0x72 => '\r',
  ///         0x74 => '\t',
  ///         _ => String.fromCharCode(c),
  ///     };
  ///   }
  ///```
  (String,)? parseEscaped(State state) {
    final $7 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $8 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    final $2 = state.peek() == 117 ? (state.advance(),) : state.fail<int>();
    if ($2 != null) {
      final $3 = parseHex(state);
      if ($3 != null) {
        String $ = $3.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    if ($0 == null) {
      final $6 = state.peek();
      final $4 = ($6 >= 98
              ? $6 <= 98 || $6 >= 110
                  ? $6 <= 110 || $6 == 114 || $6 == 116
                  : $6 == 102
              : $6 >= 47
                  ? $6 <= 47 || $6 == 92
                  : $6 == 34)
          ? (state.advance(),)
          : state.fail<int>();
      if ($4 != null) {
        int c = $4.$1;
        final String $$;
        $$ = switch (c) {
          0x22 => '"',
          0x5C => '\\',
          0x2F => '/',
          0x62 => '\b',
          0x66 => '\f',
          0x6E => '\n',
          0x72 => '\r',
          0x74 => '\t',
          _ => String.fromCharCode(c),
        };
        final $5 = ($$,);
        String $ = $5.$1;
        $0 = ($,);
      }
    }
    if (state.failure == $1 && $7 < state.nesting) {
      state.expected($0, 'Malformed escape sequence', $1, state.position);
    }
    state.nesting = $7;
    state.failure = state.failure < $8 ? $8 : state.failure;
    return $0;
  }

  /// **Hex** ('4 hex digits')
  ///
  ///```text
  /// `String`
  /// Hex('4 hex digits') =>
  ///   { var n = 0; }
  ///   s = <
  ///     @while (*) (
  ///       [a-fA-F0-9]
  ///       &{ ++n < 4 }
  ///     )
  ///   >
  ///   &{ n == 4 }
  ///   $ = { $$ = String.fromCharCode(int.parse(s, radix: 16)); }
  ///```
  (String,)? parseHex(State state) {
    final $11 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $12 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    var n = 0;
    final $5 = state.position;
    while (true) {
      final $10 = state.position;
      (void,)? $6;
      final $9 = state.peek();
      final $7 =
          ($9 >= 65 ? $9 <= 70 || $9 >= 97 && $9 <= 102 : $9 >= 48 && $9 <= 57)
              ? (state.advance(),)
              : state.fail<int>();
      if ($7 != null) {
        final $8 = ++n < 4 ? (null,) : state.fail<void>();
        if ($8 != null) {
          $6 = (null,);
        }
      }
      if ($6 == null) {
        state.position = $10;
      }
      if ($6 == null) {
        break;
      }
    }
    final $2 = (state.substring($5, state.position),);
    String s = $2.$1;
    final $3 = n == 4 ? (null,) : state.fail<void>();
    if ($3 != null) {
      final String $$;
      $$ = String.fromCharCode(int.parse(s, radix: 16));
      final $4 = ($$,);
      String $ = $4.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $1;
    }
    if (state.failure == $1 && $11 < state.nesting) {
      state.expected($0, '4 hex digits', $1, state.position);
    }
    state.nesting = $11;
    state.failure = state.failure < $12 ? $12 : state.failure;
    return $0;
  }

  /// **Member**
  ///
  ///```text
  /// `MapEntry<String, Object?>`
  /// Member =>
  ///   k = String
  ///   ':'
  ///   S
  ///   v = Value
  ///   $ = { $$ = MapEntry(k, v); }
  ///```
  (MapEntry<String, Object?>,)? parseMember(State state) {
    final $5 = state.position;
    (MapEntry<String, Object?>,)? $0;
    final $1 = parseString(state);
    if ($1 != null) {
      String k = $1.$1;
      final $2 = state.matchLiteral1(':', 58);
      if ($2 != null) {
        parseS(state);
        final $3 = parseValue(state);
        if ($3 != null) {
          Object? v = $3.$1;
          final MapEntry<String, Object?> $$;
          $$ = MapEntry(k, v);
          final $4 = ($$,);
          MapEntry<String, Object?> $ = $4.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $5;
    }
    return $0;
  }

  /// **Members**
  ///
  ///```text
  /// `List<MapEntry<String, Object?>>`
  /// Members =>
  ///   m = Member
  ///   { final l = [m]; }
  ///   @while (*) (
  ///     ','
  ///     S
  ///     m = Member
  ///     { l.add(m); }
  ///   )
  ///   $ = { $$ = l; }
  ///```
  (List<MapEntry<String, Object?>>,)? parseMembers(State state) {
    final $7 = state.position;
    (List<MapEntry<String, Object?>>,)? $0;
    final $1 = parseMember(state);
    if ($1 != null) {
      MapEntry<String, Object?> m = $1.$1;
      final l = [m];
      while (true) {
        final $6 = state.position;
        (void,)? $3;
        final $4 = state.matchLiteral1(',', 44);
        if ($4 != null) {
          parseS(state);
          final $5 = parseMember(state);
          if ($5 != null) {
            MapEntry<String, Object?> m = $5.$1;
            l.add(m);
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
      final List<MapEntry<String, Object?>> $$;
      $$ = l;
      final $2 = ($$,);
      List<MapEntry<String, Object?>> $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
  }

  /// **Null**
  ///
  ///```text
  /// `Object?`
  /// Null =>
  ///   'null'
  ///   S
  ///   $ = { $$ = null; }
  ///```
  (Object?,)? parseNull(State state) {
    final $3 = state.position;
    (Object?,)? $0;
    final $1 = state.matchLiteral('null');
    if ($1 != null) {
      parseS(state);
      final Object? $$;
      $$ = null;
      final $2 = ($$,);
      Object? $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $3;
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
  ///     (
  ///       [0]
  ///       ----
  ///       [1-9]
  ///       [0-9]*
  ///     )
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
  ///   $ = { $$ = num.parse(n); }
  ///```
  (num,)? parseNumber(State state) {
    final $23 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $24 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (num,)? $0;
    var ok = true;
    final $6 = state.position;
    (void,)? $5;
    state.peek() == 45 ? (state.advance(),) : state.fail<int>();
    (void,)? $7;
    $7 = state.peek() == 48 ? (state.advance(),) : state.fail<int>();
    if ($7 == null) {
      final $9 = state.peek();
      final $8 = $9 >= 49 && $9 <= 57 ? (state.advance(),) : state.fail<int>();
      if ($8 != null) {
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        $7 = (null,);
      }
    }
    if ($7 != null) {
      final $10 = state.peek() == 46 ? (state.advance(),) : state.fail<int>();
      if ($10 != null) {
        ok = false;
        final $14 = state.position;
        final $12 = state.failure;
        state.failure = state.position;
        (void,)? $11;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        final $13 = state.position != $14 ? (null,) : state.fail<void>();
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
      final $17 = state.peek();
      final $15 =
          $17 == 69 || $17 == 101 ? (state.advance(),) : state.fail<int>();
      if ($15 != null) {
        ok = false;
        final $22 = state.position;
        final $18 = state.failure;
        state.failure = state.position;
        (void,)? $16;
        final $20 = state.peek();
        $20 == 43 || $20 == 45 ? (state.advance(),) : state.fail<int>();
        final $21 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.advance();
          c = state.peek();
        }
        final $19 = state.position != $21 ? (null,) : state.fail<void>();
        if ($19 != null) {
          ok = true;
          $16 = (null,);
        }
        if ($16 == null) {
          state.position = $22;
        }
        if ($16 == null) {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
        }
        state.failure = state.failure < $18 ? $18 : state.failure;
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
    if (state.failure == $1 && $23 < state.nesting) {
      state.expected($0, 'number', $1, state.position);
    }
    state.nesting = $23;
    state.failure = state.failure < $24 ? $24 : state.failure;
    return $0;
  }

  /// **Object**
  ///
  ///```text
  /// `Map<String, Object?>`
  /// Object =>
  ///   '{'
  ///   S
  ///   m = Members?
  ///   '}'
  ///   S
  ///   $ = { $$ = Map.fromEntries(m ?? const []); }
  ///```
  (Map<String, Object?>,)? parseObject(State state) {
    final $5 = state.position;
    (Map<String, Object?>,)? $0;
    final $1 = state.matchLiteral1('{', 123);
    if ($1 != null) {
      parseS(state);
      (List<MapEntry<String, Object?>>?,)? $2 = parseMembers(state);
      $2 ??= (null,);
      List<MapEntry<String, Object?>>? m = $2.$1;
      final $3 = state.matchLiteral1('}', 125);
      if ($3 != null) {
        parseS(state);
        final Map<String, Object?> $$;
        $$ = Map.fromEntries(m ?? const []);
        final $4 = ($$,);
        Map<String, Object?> $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $5;
    }
    return $0;
  }

  /// **S**
  ///
  ///```text
  /// `void`
  /// S =>
  ///   [ {a}{d}{9}]*
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
  /// `Object?`
  /// Start =>
  ///   S
  ///   $ = Value
  ///   Eof
  ///```
  (Object?,)? parseStart(State state) {
    final $3 = state.position;
    (Object?,)? $0;
    parseS(state);
    final $1 = parseValue(state);
    if ($1 != null) {
      Object? $ = $1.$1;
      final $2 = parseEof(state);
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    return $0;
  }

  /// **String**
  ///
  ///```text
  /// `String`
  /// String =>
  ///   '"'
  ///   c = Chars?
  ///   '"'
  ///   S
  ///   $ = { $$ = c ?? ''; }
  ///```
  (String,)? parseString(State state) {
    final $5 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1('"', 34);
    if ($1 != null) {
      (String?,)? $2 = parseChars(state);
      $2 ??= (null,);
      String? c = $2.$1;
      final $3 = state.matchLiteral1('"', 34);
      if ($3 != null) {
        parseS(state);
        final String $$;
        $$ = c ?? '';
        final $4 = ($$,);
        String $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $5;
    }
    return $0;
  }

  /// **Unescaped**
  ///
  ///```text
  /// `String`
  /// Unescaped =>
  ///   <[^{0-1f}"\\]+>
  ///```
  (String,)? parseUnescaped(State state) {
    final $2 = state.position;
    for (var c = state.peek();
        !(c >= 34 ? c <= 34 || c == 92 : c >= 0 && c <= 31);) {
      state.advance();
      c = state.peek();
    }
    final $1 = state.position != $2 ? (null,) : state.fail<List<int>>();
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
    return $0;
  }

  /// **Value**
  ///
  ///```text
  /// `Object?`
  /// Value =>
  ///   String
  ///   ----
  ///   Array
  ///   ----
  ///   Number
  ///   ----
  ///   Boolean
  ///   ----
  ///   Null
  ///   ----
  ///   Object
  ///```
  (Object?,)? parseValue(State state) {
    (Object?,)? $0;
    $0 = parseString(state);
    if ($0 == null) {
      $0 = parseArray(state);
      if ($0 == null) {
        $0 = parseNumber(state);
        if ($0 == null) {
          $0 = parseBoolean(state);
          if ($0 == null) {
            $0 = parseNull(state);
            $0 ??= parseObject(state);
          }
        }
      }
    }
    return $0;
  }

  /// **Values**
  ///
  ///```text
  /// `List<Object?>`
  /// Values =>
  ///   v = Value
  ///   { final l = [v]; }
  ///   @while (*) (
  ///     ','
  ///     S
  ///     v = Value
  ///     { l.add(v); }
  ///   )
  ///   $ = { $$ = l; }
  ///```
  (List<Object?>,)? parseValues(State state) {
    final $7 = state.position;
    (List<Object?>,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      Object? v = $1.$1;
      final l = [v];
      while (true) {
        final $6 = state.position;
        (void,)? $3;
        final $4 = state.matchLiteral1(',', 44);
        if ($4 != null) {
          parseS(state);
          final $5 = parseValue(state);
          if ($5 != null) {
            Object? v = $5.$1;
            l.add(v);
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
      final List<Object?> $$;
      $$ = l;
      final $2 = ($$,);
      List<Object?> $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $7;
    }
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

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
  ///   $ = { n ?? const [] }
  ///```
  (List<Object?>,)? parseArray(State state) {
    final $1 = state.position;
    (List<Object?>,)? $0;
    if (state.peek() == 91) {
      state.consume('[', $1);
      parseS(state);
      List<Object?>? $3;
      final $2 = parseValues(state);
      if ($2 != null) {
        $3 = $2.$1;
      }
      List<Object?>? n = $3;
      final $4 = state.position;
      if (state.peek() == 93) {
        state.consume(']', $4);
        parseS(state);
        List<Object?> $ = n ?? const [];
        $0 = ($,);
      } else {
        state.expected(']');
      }
    } else {
      state.expected('[');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
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
  ///   $ = { n.join() }
  ///```
  (String,)? parseChars(State state) {
    (String,)? $0;
    final $6 = <String>[];
    while (true) {
      (String,)? $1;
      final $2 = parseUnescaped(state);
      if ($2 != null) {
        $1 = $2;
      } else {
        final $4 = state.position;
        (String,)? $3;
        if (state.peek() == 92) {
          state.position += state.charSize(92);
          final $5 = parseEscaped(state);
          if ($5 != null) {
            String $ = $5.$1;
            $3 = ($,);
          }
        } else {
          state.fail();
        }
        if ($3 != null) {
          $1 = $3;
        } else {
          state.position = $4;
        }
      }
      if ($1 != null) {
        $6.add($1.$1);
      } else {
        break;
      }
    }
    if ($6.isNotEmpty) {
      List<String> n = $6;
      String $ = n.join();
      $0 = ($,);
    }
    return $0;
  }

  /// **Eof** ('end of file')
  ///
  ///```text
  /// `void`
  /// Eof('end of file') =>
  ///   @expected('end of file') { !. }
  ///```
  (void,)? parseEof(State state) {
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

  /// **Escaped** ('Malformed escape sequence')
  ///
  ///```text
  /// `String`
  /// Escaped('Malformed escape sequence') =>
  ///   @expected('Malformed escape sequence') { [u]
  ///   $ = Hex
  ///   ----
  ///   c = ["/\\bfnrt]
  ///   $ = { switch(c) {
  ///         0x22 => '"',
  ///         0x5C => '\\',
  ///         0x2F => '/',
  ///         0x62 => '\b',
  ///         0x66 => '\f',
  ///         0x6E => '\n',
  ///         0x72 => '\r',
  ///         0x74 => '\t',
  ///         _ => String.fromCharCode(c),
  ///     }
  ///   } }
  ///```
  (String,)? parseEscaped(State state) {
    final $0 = state.position;
    const $6 = 'Malformed escape sequence';
    final $7 = state.failure;
    final $8 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    (String,)? $2;
    if (state.peek() == 117) {
      state.position += state.charSize(117);
      final $3 = parseHex(state);
      if ($3 != null) {
        String $ = $3.$1;
        $2 = ($,);
      }
    } else {
      state.fail();
    }
    if ($2 != null) {
      $1 = $2;
    } else {
      state.position = $0;
      (String,)? $4;
      final $5 = state.peek();
      if ($5 >= 98
          ? $5 <= 98 || $5 >= 110
              ? $5 <= 110 || $5 == 114 || $5 == 116
              : $5 == 102
          : $5 >= 47
              ? $5 <= 47 || $5 == 92
              : $5 == 34) {
        state.position += state.charSize($5);
        int c = $5;
        String $ = switch (c) {
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
        $4 = ($,);
      } else {
        state.fail();
      }
      if ($4 != null) {
        $1 = $4;
      }
    }
    if ($1 != null) {
      state.onSuccess($6, $0, $8);
      return $1;
    } else {
      state.onFailure($6, $0, $8, $7);
      return null;
    }
  }

  /// **Hex** ('4 hex digits')
  ///
  ///```text
  /// `String`
  /// Hex('4 hex digits') =>
  ///   @expected('4 hex digits') { { var n = 0; }
  ///   s = <
  ///     @while (*) (
  ///       [a-fA-F0-9]
  ///       &{ ++n < 4 }
  ///     )
  ///   >
  ///   &{ n == 4 }
  ///   $ = { String.fromCharCode(int.parse(s, radix: 16)) } }
  ///```
  (String,)? parseHex(State state) {
    final $0 = state.position;
    const $7 = '4 hex digits';
    final $8 = state.failure;
    final $9 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    var n = 0;
    final $2 = state.position;
    String? $6;
    while (true) {
      final $4 = state.position;
      var $3 = false;
      final $5 = state.peek();
      if ($5 >= 65 ? $5 <= 70 || $5 >= 97 && $5 <= 102 : $5 >= 48 && $5 <= 57) {
        state.position += state.charSize($5);
        if (++n < 4) {
          $3 = true;
        }
      } else {
        state.fail();
      }
      if (!$3) {
        state.position = $4;
        break;
      }
    }
    $6 = state.substring($2, state.position);
    String s = $6;
    if (n == 4) {
      String $ = String.fromCharCode(int.parse(s, radix: 16));
      $1 = ($,);
    }
    if ($1 != null) {
      state.onSuccess($7, $0, $9);
      return $1;
    } else {
      state.position = $0;
      state.onFailure($7, $0, $9, $8);
      return null;
    }
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
  ///   $ = { MapEntry(k, v) }
  ///```
  (MapEntry<String, Object?>,)? parseMember(State state) {
    final $1 = state.position;
    (MapEntry<String, Object?>,)? $0;
    final $2 = parseString(state);
    if ($2 != null) {
      String k = $2.$1;
      final $3 = state.position;
      if (state.peek() == 58) {
        state.consume(':', $3);
        parseS(state);
        final $4 = parseValue(state);
        if ($4 != null) {
          Object? v = $4.$1;
          MapEntry<String, Object?> $ = MapEntry(k, v);
          $0 = ($,);
        }
      } else {
        state.expected(':');
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
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
  ///   $ = { l }
  ///```
  (List<MapEntry<String, Object?>>,)? parseMembers(State state) {
    (List<MapEntry<String, Object?>>,)? $0;
    final $1 = parseMember(state);
    if ($1 != null) {
      MapEntry<String, Object?> m = $1.$1;
      final l = [m];
      while (true) {
        final $3 = state.position;
        var $2 = false;
        if (state.peek() == 44) {
          state.consume(',', $3);
          parseS(state);
          final $4 = parseMember(state);
          if ($4 != null) {
            MapEntry<String, Object?> m = $4.$1;
            l.add(m);
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
      List<MapEntry<String, Object?>> $ = l;
      $0 = ($,);
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
  ///   $ = { num.parse(n) } }
  ///```
  (num,)? parseNumber(State state) {
    final $0 = state.position;
    const $21 = 'number';
    final $22 = state.failure;
    final $23 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (num,)? $1;
    var ok = true;
    final $2 = state.position;
    String? $20;
    var $3 = false;
    if (state.peek() == 45) {
      state.position += state.charSize(45);
    } else {
      state.fail();
    }
    var $4 = true;
    if (state.peek() == 48) {
      state.position += state.charSize(48);
    } else {
      state.fail();
      var $5 = false;
      final $6 = state.peek();
      if ($6 >= 49 && $6 <= 57) {
        state.position += state.charSize($6);
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        $5 = true;
      } else {
        state.fail();
      }
      if (!$5) {
        $4 = false;
      }
    }
    if ($4) {
      final $8 = state.position;
      var $7 = false;
      if (state.peek() == 46) {
        state.position += state.charSize(46);
        ok = false;
        final $11 = state.failure;
        state.failure = state.position;
        var $9 = false;
        final $10 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        if ($10 != state.position) {
          ok = true;
          $9 = true;
        } else {
          state.fail();
        }
        if ($9) {
          state.failure < $11 ? state.failure = $11 : null;
          $7 = true;
        } else {
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
          state.failure < $11 ? state.failure = $11 : null;
        }
      } else {
        state.fail();
      }
      if (!$7) {
        state.position = $8;
      }
      final $13 = state.position;
      var $12 = false;
      final $14 = state.peek();
      if ($14 == 69 || $14 == 101) {
        state.position += state.charSize($14);
        ok = false;
        final $19 = state.failure;
        state.failure = state.position;
        final $16 = state.position;
        var $15 = false;
        final $17 = state.peek();
        if ($17 == 43 || $17 == 45) {
          state.position += state.charSize($17);
        } else {
          state.fail();
        }
        final $18 = state.position;
        for (var c = state.peek(); c >= 48 && c <= 57;) {
          state.position += state.charSize(c);
          c = state.peek();
        }
        if ($18 != state.position) {
          ok = true;
          $15 = true;
        } else {
          state.fail();
        }
        if ($15) {
          state.failure < $19 ? state.failure = $19 : null;
          $12 = true;
        } else {
          state.position = $16;
          state.error(
              'Expected decimal digit', state.position, state.failure, 3);
          state.failure < $19 ? state.failure = $19 : null;
        }
      } else {
        state.fail();
      }
      if (!$12) {
        state.position = $13;
      }
      $3 = true;
    }
    if ($3) {
      $20 = state.substring($2, state.position);
      String n = $20;
      if (ok) {
        parseS(state);
        num $ = num.parse(n);
        $1 = ($,);
      }
    } else {
      state.position = $2;
    }
    if ($1 != null) {
      state.onSuccess($21, $0, $23);
      return $1;
    } else {
      state.position = $0;
      state.onFailure($21, $0, $23, $22);
      return null;
    }
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
  ///   $ = { Map.fromEntries(m ?? const []) }
  ///```
  (Map<String, Object?>,)? parseObject(State state) {
    final $1 = state.position;
    (Map<String, Object?>,)? $0;
    if (state.peek() == 123) {
      state.consume('{', $1);
      parseS(state);
      List<MapEntry<String, Object?>>? $3;
      final $2 = parseMembers(state);
      if ($2 != null) {
        $3 = $2.$1;
      }
      List<MapEntry<String, Object?>>? m = $3;
      final $4 = state.position;
      if (state.peek() == 125) {
        state.consume('}', $4);
        parseS(state);
        Map<String, Object?> $ = Map.fromEntries(m ?? const []);
        $0 = ($,);
      } else {
        state.expected('}');
      }
    } else {
      state.expected('{');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **S**
  ///
  ///```text
  /// `void`
  /// S =>
  ///   [ {a}{d}{9}]*
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
  /// `Object?`
  /// Start =>
  ///   S
  ///   $ = Value
  ///   Eof
  ///```
  (Object?,)? parseStart(State state) {
    final $1 = state.position;
    (Object?,)? $0;
    parseS(state);
    final $2 = parseValue(state);
    if ($2 != null) {
      Object? $ = $2.$1;
      final $3 = parseEof(state);
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

  /// **String**
  ///
  ///```text
  /// `String`
  /// String =>
  ///   '"'
  ///   c = Chars?
  ///   '"'
  ///   S
  ///   $ = { c ?? '' }
  ///```
  (String,)? parseString(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 34) {
      state.consume('"', $1);
      String? $3;
      final $2 = parseChars(state);
      if ($2 != null) {
        $3 = $2.$1;
      }
      String? c = $3;
      final $4 = state.position;
      if (state.peek() == 34) {
        state.consume('"', $4);
        parseS(state);
        String $ = c ?? '';
        $0 = ($,);
      } else {
        state.expected('"');
      }
    } else {
      state.expected('"');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Unescaped**
  ///
  ///```text
  /// `String`
  /// Unescaped =>
  ///   <[^{0-1f}"\\]+>
  ///```
  (String,)? parseUnescaped(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek();
        !(c >= 34 ? c <= 34 || c == 92 : c >= 0 && c <= 31);) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      $1 = state.substring($0, state.position);
      return ($1,);
    } else {
      state.fail();
      return null;
    }
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
  ///   'true'
  ///   S
  ///   $ = { true }
  ///   ----
  ///   'false'
  ///   S
  ///   $ = { false }
  ///   ----
  ///   'null'
  ///   S
  ///   $ = { null }
  ///   ----
  ///   Object
  ///```
  (Object?,)? parseValue(State state) {
    final $5 = state.position;
    (Object?,)? $0;
    final $1 = parseString(state);
    if ($1 != null) {
      $0 = $1;
    } else {
      final $2 = parseArray(state);
      if ($2 != null) {
        $0 = $2;
      } else {
        final $3 = parseNumber(state);
        if ($3 != null) {
          $0 = $3;
        } else {
          (Object?,)? $4;
          if (state.peek() == 116 && state.startsWith('true', state.position)) {
            state.consume('true', $5);
            parseS(state);
            Object? $ = true;
            $4 = ($,);
          } else {
            state.expected('true');
          }
          if ($4 != null) {
            $0 = $4;
          } else {
            (Object?,)? $6;
            if (state.peek() == 102 &&
                state.startsWith('false', state.position)) {
              state.consume('false', $5);
              parseS(state);
              Object? $ = false;
              $6 = ($,);
            } else {
              state.expected('false');
            }
            if ($6 != null) {
              $0 = $6;
            } else {
              (Object?,)? $7;
              if (state.peek() == 110 &&
                  state.startsWith('null', state.position)) {
                state.consume('null', $5);
                parseS(state);
                Object? $;
                $7 = ($,);
              } else {
                state.expected('null');
              }
              if ($7 != null) {
                $0 = $7;
              } else {
                final $8 = parseObject(state);
                if ($8 != null) {
                  $0 = $8;
                }
              }
            }
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
  ///   $ = { l }
  ///```
  (List<Object?>,)? parseValues(State state) {
    (List<Object?>,)? $0;
    final $1 = parseValue(state);
    if ($1 != null) {
      Object? v = $1.$1;
      final l = [v];
      while (true) {
        final $3 = state.position;
        var $2 = false;
        if (state.peek() == 44) {
          state.consume(',', $3);
          parseS(state);
          final $4 = parseValue(state);
          if ($4 != null) {
            Object? v = $4.$1;
            l.add(v);
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
      List<Object?> $ = l;
      $0 = ($,);
    }
    return $0;
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

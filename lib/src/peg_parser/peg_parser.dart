//ignore_for_file: prefer_conditional_assignment, prefer_final_locals

import 'package:source_span/source_span.dart';

import '../grammar/grammar.dart';
import '../grammar/production_rule.dart';

Grammar parse(String source) {
  final state = State(source);
  final parser = PegParser();
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

class PegParser {
  /// **Action**
  ///
  ///```text
  /// `Expression`
  /// Action =>
  ///   b = Block
  ///   $ = { $$ = ActionExpression(code: b); }
  ///```
  (Expression,)? parseAction(State state) {
    (Expression,)? $0;
    final $1 = parseBlock(state);
    if ($1 != null) {
      String b = $1.$1;
      final Expression $$;
      $$ = ActionExpression(code: b);
      Expression $ = $$;
      $0 = ($,);
    }
    return $0;
  }

  /// **AnyCharacter**
  ///
  ///```text
  /// `Expression`
  /// AnyCharacter =>
  ///   '.'
  ///   S
  ///   $ = { $$ = AnyCharacterExpression(); }
  ///```
  (Expression,)? parseAnyCharacter(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    if (state.peek() == 46) {
      state.consume('.', $1);
      parseS(state);
      final Expression $$;
      $$ = AnyCharacterExpression();
      Expression $ = $$;
      $0 = ($,);
    } else {
      state.expected('.');
    }
    return $0;
  }

  /// **Assignment**
  ///
  ///```text
  /// `Expression`
  /// Assignment =>
  ///   v = (
  ///     Identifier
  ///     ----
  ///     $ = '\$'
  ///     S
  ///   )
  ///   o = ('=' / ':')
  ///   S
  ///   e = Prefix
  ///   $ = { $$ = VariableExpression(expression: e, name: v, operator: o); }
  ///   ----
  ///   Prefix
  ///```
  (Expression,)? parseAssignment(State state) {
    final $2 = state.position;
    (Expression,)? $0;
    (Expression,)? $1;
    (String,)? $3;
    final $4 = parseIdentifier(state);
    if ($4 != null) {
      $3 = $4;
    } else {
      (String,)? $5;
      if (state.peek() == 36) {
        state.consume('\$', $2);
        String $ = '\$';
        parseS(state);
        $5 = ($,);
      } else {
        state.expected('\$');
      }
      if ($5 != null) {
        $3 = $5;
      }
    }
    if ($3 != null) {
      String v = $3.$1;
      (String,)? $6;
      final $7 = state.position;
      if (state.peek() == 61) {
        state.consume('=', $7);
        $6 = ('=',);
      } else {
        state.expected('=');
        final $8 = state.position;
        if (state.peek() == 58) {
          state.consume(':', $8);
          $6 = (':',);
        } else {
          state.expected(':');
        }
      }
      if ($6 != null) {
        String o = $6.$1;
        parseS(state);
        final $9 = parsePrefix(state);
        if ($9 != null) {
          Expression e = $9.$1;
          final Expression $$;
          $$ = VariableExpression(expression: e, name: v, operator: o);
          Expression $ = $$;
          $1 = ($,);
        }
      }
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      final $10 = parsePrefix(state);
      if ($10 != null) {
        $0 = $10;
      }
    }
    return $0;
  }

  /// **Block**
  ///
  ///```text
  /// `String`
  /// Block =>
  ///   '{'
  ///   $ = <BlockBody*>
  ///   '}'
  ///   S
  ///```
  (String,)? parseBlock(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 123) {
      state.consume('{', $1);
      final $2 = state.position;
      while (true) {
        final $3 = parseBlockBody(state);
        if ($3 == null) {
          break;
        }
      }
      final $4 = state.substring($2, state.position);
      String $ = $4;
      final $5 = state.position;
      if (state.peek() == 125) {
        state.consume('}', $5);
        parseS(state);
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

  /// **BlockBody**
  ///
  ///```text
  /// `void`
  /// BlockBody =>
  ///   "{"
  ///   BlockBody*
  ///   '}'
  ///   ----
  ///   !"}"
  ///   .
  ///```
  (void,)? parseBlockBody(State state) {
    final $2 = state.position;
    var $0 = true;
    var $1 = false;
    if (state.peek() == 123) {
      state.position += state.charSize(123);
      while (true) {
        final $3 = parseBlockBody(state);
        if ($3 == null) {
          break;
        }
      }
      final $4 = state.position;
      if (state.peek() == 125) {
        state.consume('}', $4);
        $1 = true;
      } else {
        state.expected('}');
      }
    } else {
      state.fail();
    }
    if (!$1) {
      state.position = $2;
      var $5 = false;
      final $6 = state.predicate;
      state.predicate = true;
      var $7 = true;
      if (state.peek() == 125) {
        state.position += state.charSize(125);
        state.failAndBacktrack($2);
        $7 = false;
      } else {
        state.fail();
      }
      state.predicate = $6;
      if ($7) {
        final $8 = state.peek();
        if ($8 != 0) {
          state.position += state.charSize($8);
          $5 = true;
        } else {
          state.fail();
        }
      }
      if (!$5) {
        state.position = $2;
        $0 = false;
      }
    }
    if ($0) {
      return const (null,);
    } else {
      return null;
    }
  }

  /// **CharacterClass**
  ///
  ///```text
  /// `Expression`
  /// CharacterClass =>
  ///   { var negate = false; }
  ///   (
  ///     '[^'
  ///     { negate = true; }
  ///     ----
  ///     '['
  ///   )
  ///   r = @while (+) (
  ///     !']'
  ///     $ = Range
  ///   )
  ///   ']'
  ///   S
  ///   $ = { $$ = CharacterClassExpression(ranges: r, negate: negate); }
  ///```
  (Expression,)? parseCharacterClass(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    var negate = false;
    var $2 = true;
    var $3 = false;
    final $4 = state.position;
    if (state.peek() == 91 && state.startsWith('[^', state.position)) {
      state.consume('[^', $4);
      negate = true;
      $3 = true;
    } else {
      state.expected('[^');
    }
    if (!$3) {
      final $5 = state.position;
      if (state.peek() == 91) {
        state.consume('[', $5);
      } else {
        state.expected('[');
        $2 = false;
      }
    }
    if ($2) {
      final $11 = <(int, int)>[];
      while (true) {
        final $7 = state.position;
        ((int, int),)? $6;
        final $8 = state.predicate;
        state.predicate = true;
        var $9 = true;
        if (state.peek() == 93) {
          state.consume(']', $7);
          state.failAndBacktrack($7);
          $9 = false;
        } else {
          state.expected(']');
        }
        state.predicate = $8;
        if ($9) {
          final $10 = parseRange(state);
          if ($10 != null) {
            (int, int) $ = $10.$1;
            $6 = ($,);
          }
        }
        if ($6 != null) {
          $11.add($6.$1);
        } else {
          state.position = $7;
          break;
        }
      }
      if ($11.isNotEmpty) {
        List<(int, int)> r = $11;
        final $12 = state.position;
        if (state.peek() == 93) {
          state.consume(']', $12);
          parseS(state);
          final Expression $$;
          $$ = CharacterClassExpression(ranges: r, negate: negate);
          Expression $ = $$;
          $0 = ($,);
        } else {
          state.expected(']');
        }
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Comment**
  ///
  ///```text
  /// `void`
  /// Comment =>
  ///   "#"
  ///   @while (*) (
  ///     !EndOfLine
  ///     .
  ///   )
  ///   EndOfLine?
  ///```
  (void,)? parseComment(State state) {
    var $0 = false;
    if (state.peek() == 35) {
      state.position += state.charSize(35);
      while (true) {
        final $2 = state.position;
        var $1 = false;
        final $3 = state.predicate;
        state.predicate = true;
        var $5 = true;
        final $4 = parseEndOfLine(state);
        if ($4 != null) {
          state.failAndBacktrack($2);
          $5 = false;
        }
        state.predicate = $3;
        if ($5) {
          final $6 = state.peek();
          if ($6 != 0) {
            state.position += state.charSize($6);
            $1 = true;
          } else {
            state.fail();
          }
        }
        if (!$1) {
          state.position = $2;
          break;
        }
      }
      final $7 = parseEndOfLine(state);
      state.unused = $7;
      $0 = true;
    } else {
      state.fail();
    }
    if ($0) {
      return const (null,);
    } else {
      return null;
    }
  }

  /// **DQChar**
  ///
  ///```text
  /// `int`
  /// DQChar =>
  ///   !"\\"
  ///   $ = [ -!#-\[{5d-10ffff}]
  ///   ----
  ///   "\\"
  ///   $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseDQChar(State state) {
    final $2 = state.position;
    (int,)? $0;
    (int,)? $1;
    final $3 = state.predicate;
    state.predicate = true;
    var $4 = true;
    if (state.peek() == 92) {
      state.position += state.charSize(92);
      state.failAndBacktrack($2);
      $4 = false;
    } else {
      state.fail();
    }
    state.predicate = $3;
    if ($4) {
      final $5 = state.peek();
      if ($5 >= 35
          ? $5 <= 91 || $5 >= 93 && $5 <= 1114111
          : $5 >= 32 && $5 <= 33) {
        state.position += state.charSize($5);
        int $ = $5;
        $1 = ($,);
      } else {
        state.fail();
      }
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      (int,)? $6;
      if (state.peek() == 92) {
        state.position += state.charSize(92);
        (int,)? $7;
        final $8 = parseEscapedValue(state);
        if ($8 != null) {
          $7 = $8;
        } else {
          final $9 = parseEscapedHexValue(state);
          if ($9 != null) {
            $7 = $9;
          }
        }
        if ($7 != null) {
          int $ = $7.$1;
          $6 = ($,);
        }
      } else {
        state.fail();
      }
      if ($6 != null) {
        $0 = $6;
      } else {
        state.position = $2;
      }
    }
    return $0;
  }

  /// **DQString**
  ///
  ///```text
  /// `String`
  /// DQString =>
  ///   '"'
  ///   n = @while (*) (
  ///     !["]
  ///     $ = DQChar
  ///   )
  ///   '"'
  ///   S
  ///   $ = { $$ = String.fromCharCodes(n); }
  ///```
  (String,)? parseDQString(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 34) {
      state.consume('"', $1);
      final $7 = <int>[];
      while (true) {
        final $3 = state.position;
        (int,)? $2;
        final $4 = state.predicate;
        state.predicate = true;
        var $5 = true;
        if (state.peek() == 34) {
          state.position += state.charSize(34);
          state.failAndBacktrack($3);
          $5 = false;
        } else {
          state.fail();
        }
        state.predicate = $4;
        if ($5) {
          final $6 = parseDQChar(state);
          if ($6 != null) {
            int $ = $6.$1;
            $2 = ($,);
          }
        }
        if ($2 != null) {
          $7.add($2.$1);
        } else {
          state.position = $3;
          break;
        }
      }
      List<int> n = $7;
      final $8 = state.position;
      if (state.peek() == 34) {
        state.consume('"', $8);
        parseS(state);
        final String $$;
        $$ = String.fromCharCodes(n);
        String $ = $$;
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

  /// **EndOfLine**
  ///
  ///```text
  /// `void`
  /// EndOfLine =>
  ///   "\r\n" / [{a}{d}]
  ///```
  (void,)? parseEndOfLine(State state) {
    var $0 = true;
    if (state.peek() == 13 && state.startsWith('\r\n', state.position)) {
      state.position += state.strlen('\r\n');
    } else {
      state.fail();
      final $1 = state.peek();
      if ($1 == 10 || $1 == 13) {
        state.position += state.charSize($1);
      } else {
        state.fail();
        $0 = false;
      }
    }
    if ($0) {
      return const (null,);
    } else {
      return null;
    }
  }

  /// **ErrorParameters**
  ///
  ///```text
  /// `List<(String, String)>`
  /// ErrorParameters =>
  ///   $ = @while (+) (
  ///     k = 'message'
  ///     S
  ///     '='
  ///     S
  ///     v = String
  ///     S
  ///     $ = { $$ = (k, v); }
  ///     ----
  ///     k = ('start' / 'end')
  ///     S
  ///     '='
  ///     S
  ///     v = ('start' / 'end')
  ///     S
  ///     $ = { $$ = (k, v); }
  ///     ----
  ///     k = 'origin'
  ///     S
  ///     `String` v = (
  ///       n = ('==' / '!=')
  ///       S
  ///       s = 'start'
  ///       S
  ///       $ = { $$ = '$n $s'; }
  ///     )
  ///     $ = { $$ = (k, v); }
  ///   )
  ///```
  (List<(String, String)>,)? parseErrorParameters(State state) {
    final $18 = <(String, String)>[];
    while (true) {
      ((String, String),)? $0;
      final $2 = state.position;
      ((String, String),)? $1;
      if (state.peek() == 109 && state.startsWith('message', state.position)) {
        state.consume('message', $2);
        String k = 'message';
        parseS(state);
        final $3 = state.position;
        if (state.peek() == 61) {
          state.consume('=', $3);
          parseS(state);
          final $4 = parseString(state);
          if ($4 != null) {
            String v = $4.$1;
            parseS(state);
            final (String, String) $$;
            $$ = (k, v);
            (String, String) $ = $$;
            $1 = ($,);
          }
        } else {
          state.expected('=');
        }
      } else {
        state.expected('message');
      }
      if ($1 != null) {
        $0 = $1;
      } else {
        state.position = $2;
        final $6 = state.position;
        ((String, String),)? $5;
        (String,)? $7;
        if (state.peek() == 115 && state.startsWith('start', state.position)) {
          state.consume('start', $6);
          $7 = ('start',);
        } else {
          state.expected('start');
          if (state.peek() == 101 && state.startsWith('end', state.position)) {
            state.consume('end', $6);
            $7 = ('end',);
          } else {
            state.expected('end');
          }
        }
        if ($7 != null) {
          String k = $7.$1;
          parseS(state);
          final $8 = state.position;
          if (state.peek() == 61) {
            state.consume('=', $8);
            parseS(state);
            (String,)? $9;
            final $10 = state.position;
            if (state.peek() == 115 &&
                state.startsWith('start', state.position)) {
              state.consume('start', $10);
              $9 = ('start',);
            } else {
              state.expected('start');
              final $11 = state.position;
              if (state.peek() == 101 &&
                  state.startsWith('end', state.position)) {
                state.consume('end', $11);
                $9 = ('end',);
              } else {
                state.expected('end');
              }
            }
            if ($9 != null) {
              String v = $9.$1;
              parseS(state);
              final (String, String) $$;
              $$ = (k, v);
              (String, String) $ = $$;
              $5 = ($,);
            }
          } else {
            state.expected('=');
          }
        }
        if ($5 != null) {
          $0 = $5;
        } else {
          state.position = $6;
          final $13 = state.position;
          ((String, String),)? $12;
          if (state.peek() == 111 &&
              state.startsWith('origin', state.position)) {
            state.consume('origin', $13);
            String k = 'origin';
            parseS(state);
            final $15 = state.position;
            (String,)? $14;
            (String,)? $16;
            if (state.peek() == 61 && state.startsWith('==', state.position)) {
              state.consume('==', $15);
              $16 = ('==',);
            } else {
              state.expected('==');
              if (state.peek() == 33 &&
                  state.startsWith('!=', state.position)) {
                state.consume('!=', $15);
                $16 = ('!=',);
              } else {
                state.expected('!=');
              }
            }
            if ($16 != null) {
              String n = $16.$1;
              parseS(state);
              final $17 = state.position;
              if (state.peek() == 115 &&
                  state.startsWith('start', state.position)) {
                state.consume('start', $17);
                String s = 'start';
                parseS(state);
                final String $$;
                $$ = '$n $s';
                String $ = $$;
                $14 = ($,);
              } else {
                state.expected('start');
              }
            }
            if ($14 != null) {
              String v = $14.$1;
              final (String, String) $$;
              $$ = (k, v);
              (String, String) $ = $$;
              $12 = ($,);
            } else {
              state.position = $15;
            }
          } else {
            state.expected('origin');
          }
          if ($12 != null) {
            $0 = $12;
          } else {
            state.position = $13;
          }
        }
      }
      if ($0 != null) {
        $18.add($0.$1);
      } else {
        break;
      }
    }
    if ($18.isNotEmpty) {
      List<(String, String)> $ = $18;
      return ($,);
    } else {
      return null;
    }
  }

  /// **EscapedHexValue**
  ///
  ///```text
  /// `int`
  /// EscapedHexValue =>
  ///   "u"
  ///   '{'
  ///   $ = HexValue
  ///   '}'
  ///    ~ { message = 'Malformed escape sequence' origin != start }
  ///```
  (int,)? parseEscapedHexValue(State state) {
    final $1 = state.position;
    final $5 = state.failure;
    state.failure = state.position;
    (int,)? $0;
    if (state.peek() == 117) {
      state.position += state.charSize(117);
      final $2 = state.position;
      if (state.peek() == 123) {
        state.consume('{', $2);
        final $3 = parseHexValue(state);
        if ($3 != null) {
          int $ = $3.$1;
          final $4 = state.position;
          if (state.peek() == 125) {
            state.consume('}', $4);
            $0 = ($,);
          } else {
            state.expected('}');
          }
        }
      } else {
        state.expected('{');
      }
    } else {
      state.fail();
    }
    if ($0 != null) {
      state.failure < $5 ? state.failure = $5 : null;
      return $0;
    } else {
      state.position = $1;
      if (state.failure != state.position) {
        state.error(
            'Malformed escape sequence', state.position, state.failure, 3);
      }
      state.failure < $5 ? state.failure = $5 : null;
      return null;
    }
  }

  /// **EscapedValue**
  ///
  ///```text
  /// `int`
  /// EscapedValue =>
  ///   $ = [abefnrtv'"\\]
  ///   {
  ///     $ = switch ($) {
  ///       97 => 0x07,  // a
  ///       98 => 0x08,  // b
  ///       101 => 0x1B, // e
  ///       102 => 0x0C, // f
  ///       110 => 0x0A, // n
  ///       114 => 0x0D, // r
  ///       116 => 0x09, // t
  ///       118 => 0x0B, // v
  ///       _ => $,
  ///     };
  ///   }
  ///    ~ { message = 'Unexpected escape character' }
  ///```
  (int,)? parseEscapedValue(State state) {
    final $2 = state.failure;
    state.failure = state.position;
    (int,)? $0;
    final $1 = state.peek();
    if ($1 >= 101
        ? $1 <= 102 || $1 >= 114
            ? $1 <= 114 || $1 == 116 || $1 == 118
            : $1 == 110
        : $1 >= 39
            ? $1 <= 39 || $1 == 92 || $1 >= 97 && $1 <= 98
            : $1 == 34) {
      state.position += state.charSize($1);
      int $ = $1;
      $ = switch ($) {
        97 => 0x07, // a
        98 => 0x08, // b
        101 => 0x1B, // e
        102 => 0x0C, // f
        110 => 0x0A, // n
        114 => 0x0D, // r
        116 => 0x09, // t
        118 => 0x0B, // v
        _ => $,
      };
      $0 = ($,);
    } else {
      state.fail();
    }
    if ($0 != null) {
      state.failure < $2 ? state.failure = $2 : null;
      return $0;
    } else {
      state.error(
          'Unexpected escape character', state.position, state.failure, 3);
      state.failure < $2 ? state.failure = $2 : null;
      return null;
    }
  }

  /// **Expression** ('expression')
  ///
  ///```text
  /// `Expression`
  /// Expression('expression') =>
  ///   @expected('expression') { OrderedChoice }
  ///```
  (Expression,)? parseExpression(State state) {
    final $0 = state.position;
    const $2 = 'expression';
    final $3 = state.failure;
    final $4 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    final $1 = parseOrderedChoice(state);
    if ($1 != null) {
      state.onSuccess($2, $0, $4);
      return $1;
    } else {
      state.onFailure($2, $0, $4, $3);
      return null;
    }
  }

  /// **Globals**
  ///
  ///```text
  /// `String`
  /// Globals =>
  ///   '%{'
  ///   $ = <
  ///     @while (*) (
  ///       !"}%"
  ///       .
  ///     )
  ///   >
  ///   '}%'
  ///   S
  ///```
  (String,)? parseGlobals(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 37 && state.startsWith('%{', state.position)) {
      state.consume('%{', $1);
      final $2 = state.position;
      while (true) {
        final $4 = state.position;
        var $3 = false;
        final $5 = state.predicate;
        state.predicate = true;
        var $6 = true;
        if (state.peek() == 125 && state.startsWith('}%', state.position)) {
          state.position += state.strlen('}%');
          state.failAndBacktrack($4);
          $6 = false;
        } else {
          state.fail();
        }
        state.predicate = $5;
        if ($6) {
          final $7 = state.peek();
          if ($7 != 0) {
            state.position += state.charSize($7);
            $3 = true;
          } else {
            state.fail();
          }
        }
        if (!$3) {
          state.position = $4;
          break;
        }
      }
      final $8 = state.substring($2, state.position);
      String $ = $8;
      final $9 = state.position;
      if (state.peek() == 125 && state.startsWith('}%', state.position)) {
        state.consume('}%', $9);
        parseS(state);
        $0 = ($,);
      } else {
        state.expected('}%');
      }
    } else {
      state.expected('%{');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Group**
  ///
  ///```text
  /// `Expression`
  /// Group =>
  ///   '('
  ///   S
  ///   $ = Expression
  ///   ')'
  ///   S
  ///   { $ = GroupExpression(expression: $); }
  ///```
  (Expression,)? parseGroup(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    if (state.peek() == 40) {
      state.consume('(', $1);
      parseS(state);
      final $2 = parseExpression(state);
      if ($2 != null) {
        Expression $ = $2.$1;
        final $3 = state.position;
        if (state.peek() == 41) {
          state.consume(')', $3);
          parseS(state);
          $ = GroupExpression(expression: $);
          $0 = ($,);
        } else {
          state.expected(')');
        }
      }
    } else {
      state.expected('(');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **HexValue** ('hex number')
  ///
  ///```text
  /// `int`
  /// HexValue('hex number') =>
  ///   @expected('hex number') { n = <[a-fA-F0-9]+>
  ///   $ = { $$ = int.parse(n, radix: 16); } }
  ///```
  (int,)? parseHexValue(State state) {
    final $0 = state.position;
    const $3 = 'hex number';
    final $4 = state.failure;
    final $5 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (int,)? $1;
    for (var c = state.peek();
        c >= 65 ? c <= 70 || c >= 97 && c <= 102 : c >= 48 && c <= 57;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      final $2 = state.substring($0, state.position);
      String n = $2;
      final int $$;
      $$ = int.parse(n, radix: 16);
      int $ = $$;
      $1 = ($,);
    } else {
      state.fail();
    }
    if ($1 != null) {
      state.onSuccess($3, $0, $5);
      return $1;
    } else {
      state.onFailure($3, $0, $5, $4);
      return null;
    }
  }

  /// **Identifier** ('identifier')
  ///
  ///```text
  /// `String`
  /// Identifier('identifier') =>
  ///   @expected('identifier') { $ = <
  ///     [a-zA-Z]
  ///     [a-zA-Z0-9_]*
  ///   >
  ///   S }
  ///```
  (String,)? parseIdentifier(State state) {
    final $0 = state.position;
    const $5 = 'identifier';
    final $6 = state.failure;
    final $7 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    var $2 = false;
    final $3 = state.peek();
    if ($3 >= 97 ? $3 <= 122 : $3 >= 65 && $3 <= 90) {
      state.position += state.charSize($3);
      for (var c = state.peek();
          c >= 65
              ? c <= 90 || c == 95 || c >= 97 && c <= 122
              : c >= 48 && c <= 57;) {
        state.position += state.charSize(c);
        c = state.peek();
      }
      $2 = true;
    } else {
      state.fail();
    }
    if ($2) {
      final $4 = state.substring($0, state.position);
      String $ = $4;
      parseS(state);
      $1 = ($,);
    }
    if ($1 != null) {
      state.onSuccess($5, $0, $7);
      return $1;
    } else {
      state.onFailure($5, $0, $7, $6);
      return null;
    }
  }

  /// **Literal**
  ///
  ///```text
  /// `Expression`
  /// Literal =>
  ///   s = SQString
  ///   $ = { $$ = LiteralExpression(literal: s); }
  ///   ----
  ///   s = DQString
  ///   $ = { $$ = LiteralExpression(literal: s, silent: true); }
  ///```
  (Expression,)? parseLiteral(State state) {
    (Expression,)? $0;
    (Expression,)? $1;
    final $2 = parseSQString(state);
    if ($2 != null) {
      String s = $2.$1;
      final Expression $$;
      $$ = LiteralExpression(literal: s);
      Expression $ = $$;
      $1 = ($,);
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      (Expression,)? $3;
      final $4 = parseDQString(state);
      if ($4 != null) {
        String s = $4.$1;
        final Expression $$;
        $$ = LiteralExpression(literal: s, silent: true);
        Expression $ = $$;
        $3 = ($,);
      }
      if ($3 != null) {
        $0 = $3;
      }
    }
    return $0;
  }

  /// **Match**
  ///
  ///```text
  /// `Expression`
  /// Match =>
  ///   '<'
  ///   S
  ///   e = Expression
  ///   '>'
  ///   S
  ///   $ = { $$ = MatchExpression(expression: e); }
  ///```
  (Expression,)? parseMatch(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    if (state.peek() == 60) {
      state.consume('<', $1);
      parseS(state);
      final $2 = parseExpression(state);
      if ($2 != null) {
        Expression e = $2.$1;
        final $3 = state.position;
        if (state.peek() == 62) {
          state.consume('>', $3);
          parseS(state);
          final Expression $$;
          $$ = MatchExpression(expression: e);
          Expression $ = $$;
          $0 = ($,);
        } else {
          state.expected('>');
        }
      }
    } else {
      state.expected('<');
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
  /// `String`
  /// Members =>
  ///   '%%'
  ///   $ = <
  ///     @while (*) (
  ///       !"%%"
  ///       .
  ///     )
  ///   >
  ///   '%%'
  ///   S
  ///```
  (String,)? parseMembers(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 37 && state.startsWith('%%', state.position)) {
      state.consume('%%', $1);
      final $2 = state.position;
      while (true) {
        final $4 = state.position;
        var $3 = false;
        final $5 = state.predicate;
        state.predicate = true;
        var $6 = true;
        if (state.peek() == 37 && state.startsWith('%%', state.position)) {
          state.position += state.strlen('%%');
          state.failAndBacktrack($4);
          $6 = false;
        } else {
          state.fail();
        }
        state.predicate = $5;
        if ($6) {
          final $7 = state.peek();
          if ($7 != 0) {
            state.position += state.charSize($7);
            $3 = true;
          } else {
            state.fail();
          }
        }
        if (!$3) {
          state.position = $4;
          break;
        }
      }
      final $8 = state.substring($2, state.position);
      String $ = $8;
      final $9 = state.position;
      if (state.peek() == 37 && state.startsWith('%%', state.position)) {
        state.consume('%%', $9);
        parseS(state);
        $0 = ($,);
      } else {
        state.expected('%%');
      }
    } else {
      state.expected('%%');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Nonterminal**
  ///
  ///```text
  /// `Expression`
  /// Nonterminal =>
  ///   i = RuleName
  ///   !(
  ///     ProductionRuleArguments?
  ///     '=>'
  ///     S
  ///   )
  ///   $ = { $$ = NonterminalExpression(name: i); }
  ///```
  (Expression,)? parseNonterminal(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    final $2 = parseRuleName(state);
    if ($2 != null) {
      String i = $2.$1;
      final $3 = state.position;
      final $4 = state.predicate;
      state.predicate = true;
      var $8 = true;
      var $5 = false;
      final $6 = parseProductionRuleArguments(state);
      state.unused = $6;
      final $7 = state.position;
      if (state.peek() == 61 && state.startsWith('=>', state.position)) {
        state.consume('=>', $7);
        parseS(state);
        $5 = true;
      } else {
        state.expected('=>');
      }
      if ($5) {
        state.failAndBacktrack($3);
        $8 = false;
      } else {
        state.position = $3;
      }
      state.predicate = $4;
      if ($8) {
        final Expression $$;
        $$ = NonterminalExpression(name: i);
        Expression $ = $$;
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

  /// **OrderedChoice**
  ///
  ///```text
  /// `Expression`
  /// OrderedChoice =>
  ///   n = Sequence
  ///   { final l = [n]; }
  ///   @while (*) (
  ///     ('/' / '-'+)
  ///     S
  ///     n = Sequence
  ///     { l.add(n); }
  ///   )
  ///   $ = { $$ = OrderedChoiceExpression(expressions: l); }
  ///```
  (Expression,)? parseOrderedChoice(State state) {
    (Expression,)? $0;
    final $1 = parseSequence(state);
    if ($1 != null) {
      Expression n = $1.$1;
      final l = [n];
      while (true) {
        final $3 = state.position;
        var $2 = false;
        var $4 = true;
        if (state.peek() == 47) {
          state.consume('/', $3);
        } else {
          state.expected('/');
          while (true) {
            final $5 = state.position;
            if (state.peek() == 45) {
              state.consume('-', $5);
            } else {
              state.expected('-');
              break;
            }
          }
          if ($3 == state.position) {
            $4 = false;
          }
        }
        if ($4) {
          parseS(state);
          final $6 = parseSequence(state);
          if ($6 != null) {
            Expression n = $6.$1;
            l.add(n);
            $2 = true;
          }
        }
        if (!$2) {
          state.position = $3;
          break;
        }
      }
      final Expression $$;
      $$ = OrderedChoiceExpression(expressions: l);
      Expression $ = $$;
      $0 = ($,);
    }
    return $0;
  }

  /// **Prefix**
  ///
  ///```text
  /// `Expression`
  /// Prefix =>
  ///   p = (
  ///     $ = '!'
  ///     S
  ///     ----
  ///     $ = '&'
  ///     S
  ///   )?
  ///   $ = Suffix
  ///   { switch(p) {
  ///       case '!':
  ///         if ($ is ActionExpression) {
  ///           $ = PredicateExpression(code: $.code, negate: true);
  ///         } else {
  ///           $ = NotPredicateExpression(expression: $);
  ///         }
  ///         break;
  ///       case '&':
  ///       if ($ is ActionExpression) {
  ///           $ = PredicateExpression(code: $.code, negate: false);
  ///         } else {
  ///           $ = AndPredicateExpression(expression: $);
  ///         }
  ///         break;
  ///     }
  ///   }
  ///```
  (Expression,)? parsePrefix(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    String? $5;
    (String,)? $2;
    (String,)? $3;
    if (state.peek() == 33) {
      state.consume('!', $1);
      String $ = '!';
      parseS(state);
      $3 = ($,);
    } else {
      state.expected('!');
    }
    if ($3 != null) {
      $2 = $3;
    } else {
      (String,)? $4;
      if (state.peek() == 38) {
        state.consume('&', $1);
        String $ = '&';
        parseS(state);
        $4 = ($,);
      } else {
        state.expected('&');
      }
      if ($4 != null) {
        $2 = $4;
      }
    }
    if ($2 != null) {
      $5 = $2.$1;
    }
    String? p = $5;
    final $6 = parseSuffix(state);
    if ($6 != null) {
      Expression $ = $6.$1;
      switch (p) {
        case '!':
          if ($ is ActionExpression) {
            $ = PredicateExpression(code: $.code, negate: true);
          } else {
            $ = NotPredicateExpression(expression: $);
          }
          break;
        case '&':
          if ($ is ActionExpression) {
            $ = PredicateExpression(code: $.code, negate: false);
          } else {
            $ = AndPredicateExpression(expression: $);
          }
          break;
      }
      $0 = ($,);
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Primary** ('expression')
  ///
  ///```text
  /// `Expression`
  /// Primary('expression') =>
  ///   @expected('expression') { CharacterClass
  ///   ----
  ///   Literal
  ///   ----
  ///   Group
  ///   ----
  ///   Repeater
  ///   ----
  ///   Nonterminal
  ///   ----
  ///   Action
  ///   ----
  ///   AnyCharacter
  ///   ----
  ///   Match }
  ///```
  (Expression,)? parsePrimary(State state) {
    final $0 = state.position;
    const $10 = 'expression';
    final $11 = state.failure;
    final $12 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (Expression,)? $1;
    final $2 = parseCharacterClass(state);
    if ($2 != null) {
      $1 = $2;
    } else {
      final $3 = parseLiteral(state);
      if ($3 != null) {
        $1 = $3;
      } else {
        final $4 = parseGroup(state);
        if ($4 != null) {
          $1 = $4;
        } else {
          final $5 = parseRepeater(state);
          if ($5 != null) {
            $1 = $5;
          } else {
            final $6 = parseNonterminal(state);
            if ($6 != null) {
              $1 = $6;
            } else {
              final $7 = parseAction(state);
              if ($7 != null) {
                $1 = $7;
              } else {
                final $8 = parseAnyCharacter(state);
                if ($8 != null) {
                  $1 = $8;
                } else {
                  final $9 = parseMatch(state);
                  if ($9 != null) {
                    $1 = $9;
                  }
                }
              }
            }
          }
        }
      }
    }
    if ($1 != null) {
      state.onSuccess($10, $0, $12);
      return $1;
    } else {
      state.onFailure($10, $0, $12, $11);
      return null;
    }
  }

  /// **ProductionRule**
  ///
  ///```text
  /// `ProductionRule`
  /// ProductionRule =>
  ///   t = Type?
  ///   i = Identifier
  ///   a = ProductionRuleArguments?
  ///   '=>'
  ///   S
  ///   e = Expression
  ///   [;]?
  ///   S
  ///   $ = { $$ = ProductionRule(expression: e, expected: a, name: i, resultType: t ?? ''); }
  ///```
  (ProductionRule,)? parseProductionRule(State state) {
    final $1 = state.position;
    (ProductionRule,)? $0;
    String? $3;
    final $2 = parseType(state);
    if ($2 != null) {
      $3 = $2.$1;
    }
    String? t = $3;
    final $4 = parseIdentifier(state);
    if ($4 != null) {
      String i = $4.$1;
      String? $6;
      final $5 = parseProductionRuleArguments(state);
      if ($5 != null) {
        $6 = $5.$1;
      }
      String? a = $6;
      final $7 = state.position;
      if (state.peek() == 61 && state.startsWith('=>', state.position)) {
        state.consume('=>', $7);
        parseS(state);
        final $8 = parseExpression(state);
        if ($8 != null) {
          Expression e = $8.$1;
          if (state.peek() == 59) {
            state.position += state.charSize(59);
          } else {
            state.fail();
          }
          parseS(state);
          final ProductionRule $$;
          $$ = ProductionRule(
              expression: e, expected: a, name: i, resultType: t ?? '');
          ProductionRule $ = $$;
          $0 = ($,);
        }
      } else {
        state.expected('=>');
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **ProductionRuleArguments**
  ///
  ///```text
  /// `String`
  /// ProductionRuleArguments =>
  ///   '('
  ///   S
  ///   $ = String
  ///   ')'
  ///   S
  ///```
  (String,)? parseProductionRuleArguments(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 40) {
      state.consume('(', $1);
      parseS(state);
      final $2 = parseString(state);
      if ($2 != null) {
        String $ = $2.$1;
        final $3 = state.position;
        if (state.peek() == 41) {
          state.consume(')', $3);
          parseS(state);
          $0 = ($,);
        } else {
          state.expected(')');
        }
      }
    } else {
      state.expected('(');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Range** ('range')
  ///
  ///```text
  /// `(int, int)`
  /// Range('range') =>
  ///   @expected('range') { "{"
  ///   s = HexValue
  ///   "-"
  ///   e = HexValue
  ///   '}'
  ///   $ = { $$ = (s, e); }
  ///   ----
  ///   "{"
  ///   n = HexValue
  ///   '}'
  ///   $ = { $$ = (n, n); }
  ///   ----
  ///   s = RangeChar
  ///   "-"
  ///   e = RangeChar
  ///   $ = { $$ = (s, e); }
  ///   ----
  ///   n = RangeChar
  ///   $ = { $$ = (n, n); } }
  ///```
  ((int, int),)? parseRange(State state) {
    final $0 = state.position;
    const $14 = 'range';
    final $15 = state.failure;
    final $16 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    ((int, int),)? $1;
    ((int, int),)? $2;
    if (state.peek() == 123) {
      state.position += state.charSize(123);
      final $3 = parseHexValue(state);
      if ($3 != null) {
        int s = $3.$1;
        if (state.peek() == 45) {
          state.position += state.charSize(45);
          final $4 = parseHexValue(state);
          if ($4 != null) {
            int e = $4.$1;
            final $5 = state.position;
            if (state.peek() == 125) {
              state.consume('}', $5);
              final (int, int) $$;
              $$ = (s, e);
              (int, int) $ = $$;
              $2 = ($,);
            } else {
              state.expected('}');
            }
          }
        } else {
          state.fail();
        }
      }
    } else {
      state.fail();
    }
    if ($2 != null) {
      $1 = $2;
    } else {
      state.position = $0;
      ((int, int),)? $6;
      if (state.peek() == 123) {
        state.position += state.charSize(123);
        final $7 = parseHexValue(state);
        if ($7 != null) {
          int n = $7.$1;
          final $8 = state.position;
          if (state.peek() == 125) {
            state.consume('}', $8);
            final (int, int) $$;
            $$ = (n, n);
            (int, int) $ = $$;
            $6 = ($,);
          } else {
            state.expected('}');
          }
        }
      } else {
        state.fail();
      }
      if ($6 != null) {
        $1 = $6;
      } else {
        state.position = $0;
        ((int, int),)? $9;
        final $10 = parseRangeChar(state);
        if ($10 != null) {
          int s = $10.$1;
          if (state.peek() == 45) {
            state.position += state.charSize(45);
            final $11 = parseRangeChar(state);
            if ($11 != null) {
              int e = $11.$1;
              final (int, int) $$;
              $$ = (s, e);
              (int, int) $ = $$;
              $9 = ($,);
            }
          } else {
            state.fail();
          }
        }
        if ($9 != null) {
          $1 = $9;
        } else {
          state.position = $0;
          ((int, int),)? $12;
          final $13 = parseRangeChar(state);
          if ($13 != null) {
            int n = $13.$1;
            final (int, int) $$;
            $$ = (n, n);
            (int, int) $ = $$;
            $12 = ($,);
          }
          if ($12 != null) {
            $1 = $12;
          }
        }
      }
    }
    if ($1 != null) {
      state.onSuccess($14, $0, $16);
      return $1;
    } else {
      state.onFailure($14, $0, $16, $15);
      return null;
    }
  }

  /// **RangeChar**
  ///
  ///```text
  /// `int`
  /// RangeChar =>
  ///   !"\\"
  ///   $ = [^{0-1f}\{\}\[\]\\]
  ///   ----
  ///   "\\"
  ///   $ = (
  ///     "u"
  ///     '{'
  ///     $ = HexValue
  ///     '}'
  ///     ----
  ///     $ = [\-\^abefnrtv\{\}\[\]\\]
  ///     {
  ///       $ = switch ($) {
  ///         97 => 0x07,  // a
  ///         98 => 0x08,  // b
  ///         101 => 0x1B, // e
  ///         102 => 0x0C, // f
  ///         110 => 0x0A, // n
  ///         114 => 0x0D, // r
  ///         116 => 0x09, // t
  ///         118 => 0x0B, // v
  ///         _ => $,
  ///       };
  ///     }
  ///   )
  ///```
  (int,)? parseRangeChar(State state) {
    final $2 = state.position;
    (int,)? $0;
    (int,)? $1;
    final $3 = state.predicate;
    state.predicate = true;
    var $4 = true;
    if (state.peek() == 92) {
      state.position += state.charSize(92);
      state.failAndBacktrack($2);
      $4 = false;
    } else {
      state.fail();
    }
    state.predicate = $3;
    if ($4) {
      final $5 = state.peek();
      if (!($5 >= 91
          ? $5 <= 93 || $5 == 123 || $5 == 125
          : $5 >= 0 && $5 <= 31)) {
        state.position += state.charSize($5);
        int $ = $5;
        $1 = ($,);
      } else {
        state.fail();
      }
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      (int,)? $6;
      if (state.peek() == 92) {
        state.position += state.charSize(92);
        (int,)? $7;
        final $9 = state.position;
        (int,)? $8;
        if (state.peek() == 117) {
          state.position += state.charSize(117);
          final $10 = state.position;
          if (state.peek() == 123) {
            state.consume('{', $10);
            final $11 = parseHexValue(state);
            if ($11 != null) {
              int $ = $11.$1;
              final $12 = state.position;
              if (state.peek() == 125) {
                state.consume('}', $12);
                $8 = ($,);
              } else {
                state.expected('}');
              }
            }
          } else {
            state.expected('{');
          }
        } else {
          state.fail();
        }
        if ($8 != null) {
          $7 = $8;
        } else {
          state.position = $9;
          (int,)? $13;
          final $14 = state.peek();
          if ($14 >= 110
              ? $14 <= 110 || $14 >= 118
                  ? $14 <= 118 || $14 == 123 || $14 == 125
                  : $14 == 114 || $14 == 116
              : $14 >= 91
                  ? $14 <= 94 ||
                      ($14 >= 101 ? $14 <= 102 : $14 >= 97 && $14 <= 98)
                  : $14 == 45) {
            state.position += state.charSize($14);
            int $ = $14;
            $ = switch ($) {
              97 => 0x07, // a
              98 => 0x08, // b
              101 => 0x1B, // e
              102 => 0x0C, // f
              110 => 0x0A, // n
              114 => 0x0D, // r
              116 => 0x09, // t
              118 => 0x0B, // v
              _ => $,
            };
            $13 = ($,);
          } else {
            state.fail();
          }
          if ($13 != null) {
            $7 = $13;
          }
        }
        if ($7 != null) {
          int $ = $7.$1;
          $6 = ($,);
        }
      } else {
        state.fail();
      }
      if ($6 != null) {
        $0 = $6;
      } else {
        state.position = $2;
      }
    }
    return $0;
  }

  /// **Repeater**
  ///
  ///```text
  /// `Expression`
  /// Repeater =>
  ///   '@while'
  ///   S
  ///   '('
  ///   S
  ///   '*'
  ///   S
  ///   ')'
  ///   S
  ///   '{'
  ///   S
  ///   e = Expression
  ///   '}'
  ///   S
  ///   $ = { $$ = ZeroOrMoreExpression(expression: GroupExpression(expression: e)); }
  ///   ----
  ///   '@while'
  ///   S
  ///   '('
  ///   S
  ///   '+'
  ///   S
  ///   ')'
  ///   S
  ///   '{'
  ///   S
  ///   e = Expression
  ///   '}'
  ///   S
  ///   $ = { $$ = OneOrMoreExpression(expression: GroupExpression(expression: e)); }
  ///```
  (Expression,)? parseRepeater(State state) {
    final $2 = state.position;
    (Expression,)? $0;
    (Expression,)? $1;
    if (state.peek() == 64 && state.startsWith('@while', state.position)) {
      state.consume('@while', $2);
      parseS(state);
      final $3 = state.position;
      if (state.peek() == 40) {
        state.consume('(', $3);
        parseS(state);
        final $4 = state.position;
        if (state.peek() == 42) {
          state.consume('*', $4);
          parseS(state);
          final $5 = state.position;
          if (state.peek() == 41) {
            state.consume(')', $5);
            parseS(state);
            final $6 = state.position;
            if (state.peek() == 123) {
              state.consume('{', $6);
              parseS(state);
              final $7 = parseExpression(state);
              if ($7 != null) {
                Expression e = $7.$1;
                final $8 = state.position;
                if (state.peek() == 125) {
                  state.consume('}', $8);
                  parseS(state);
                  final Expression $$;
                  $$ = ZeroOrMoreExpression(
                      expression: GroupExpression(expression: e));
                  Expression $ = $$;
                  $1 = ($,);
                } else {
                  state.expected('}');
                }
              }
            } else {
              state.expected('{');
            }
          } else {
            state.expected(')');
          }
        } else {
          state.expected('*');
        }
      } else {
        state.expected('(');
      }
    } else {
      state.expected('@while');
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      (Expression,)? $9;
      if (state.peek() == 64 && state.startsWith('@while', state.position)) {
        state.consume('@while', $2);
        parseS(state);
        final $10 = state.position;
        if (state.peek() == 40) {
          state.consume('(', $10);
          parseS(state);
          final $11 = state.position;
          if (state.peek() == 43) {
            state.consume('+', $11);
            parseS(state);
            final $12 = state.position;
            if (state.peek() == 41) {
              state.consume(')', $12);
              parseS(state);
              final $13 = state.position;
              if (state.peek() == 123) {
                state.consume('{', $13);
                parseS(state);
                final $14 = parseExpression(state);
                if ($14 != null) {
                  Expression e = $14.$1;
                  final $15 = state.position;
                  if (state.peek() == 125) {
                    state.consume('}', $15);
                    parseS(state);
                    final Expression $$;
                    $$ = OneOrMoreExpression(
                        expression: GroupExpression(expression: e));
                    Expression $ = $$;
                    $9 = ($,);
                  } else {
                    state.expected('}');
                  }
                }
              } else {
                state.expected('{');
              }
            } else {
              state.expected(')');
            }
          } else {
            state.expected('+');
          }
        } else {
          state.expected('(');
        }
      } else {
        state.expected('@while');
      }
      if ($9 != null) {
        $0 = $9;
      } else {
        state.position = $2;
      }
    }
    return $0;
  }

  /// **RuleName** ('production rule name')
  ///
  ///```text
  /// `String`
  /// RuleName('production rule name') =>
  ///   @expected('production rule name') { $ = <
  ///     [A-Z]
  ///     [a-zA-Z0-9_]*
  ///   >
  ///   S }
  ///```
  (String,)? parseRuleName(State state) {
    final $0 = state.position;
    const $5 = 'production rule name';
    final $6 = state.failure;
    final $7 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    var $2 = false;
    final $3 = state.peek();
    if ($3 >= 65 && $3 <= 90) {
      state.position += state.charSize($3);
      for (var c = state.peek();
          c >= 65
              ? c <= 90 || c == 95 || c >= 97 && c <= 122
              : c >= 48 && c <= 57;) {
        state.position += state.charSize(c);
        c = state.peek();
      }
      $2 = true;
    } else {
      state.fail();
    }
    if ($2) {
      final $4 = state.substring($0, state.position);
      String $ = $4;
      parseS(state);
      $1 = ($,);
    }
    if ($1 != null) {
      state.onSuccess($5, $0, $7);
      return $1;
    } else {
      state.onFailure($5, $0, $7, $6);
      return null;
    }
  }

  /// **S**
  ///
  ///```text
  /// `void`
  /// S =>
  ///   @while (*) (Space / Comment)
  ///```
  void parseS(State state) {
    while (true) {
      var $0 = true;
      final $1 = parseSpace(state);
      if ($1 == null) {
        final $2 = parseComment(state);
        if ($2 == null) {
          $0 = false;
        }
      }
      if (!$0) {
        break;
      }
    }
  }

  /// **SQChar**
  ///
  ///```text
  /// `int`
  /// SQChar =>
  ///   !"\\"
  ///   $ = [ -&(-\[{5d-10ffff}]
  ///   ----
  ///   "\\"
  ///   $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseSQChar(State state) {
    final $2 = state.position;
    (int,)? $0;
    (int,)? $1;
    final $3 = state.predicate;
    state.predicate = true;
    var $4 = true;
    if (state.peek() == 92) {
      state.position += state.charSize(92);
      state.failAndBacktrack($2);
      $4 = false;
    } else {
      state.fail();
    }
    state.predicate = $3;
    if ($4) {
      final $5 = state.peek();
      if ($5 >= 40
          ? $5 <= 91 || $5 >= 93 && $5 <= 1114111
          : $5 >= 32 && $5 <= 38) {
        state.position += state.charSize($5);
        int $ = $5;
        $1 = ($,);
      } else {
        state.fail();
      }
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      (int,)? $6;
      if (state.peek() == 92) {
        state.position += state.charSize(92);
        (int,)? $7;
        final $8 = parseEscapedValue(state);
        if ($8 != null) {
          $7 = $8;
        } else {
          final $9 = parseEscapedHexValue(state);
          if ($9 != null) {
            $7 = $9;
          }
        }
        if ($7 != null) {
          int $ = $7.$1;
          $6 = ($,);
        }
      } else {
        state.fail();
      }
      if ($6 != null) {
        $0 = $6;
      } else {
        state.position = $2;
      }
    }
    return $0;
  }

  /// **SQString**
  ///
  ///```text
  /// `String`
  /// SQString =>
  ///   '\''
  ///   n = @while (*) (
  ///     ![']
  ///     $ = SQChar
  ///   )
  ///   '\''
  ///   S
  ///   $ = { $$ = String.fromCharCodes(n); }
  ///```
  (String,)? parseSQString(State state) {
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 39) {
      state.consume('\'', $1);
      final $7 = <int>[];
      while (true) {
        final $3 = state.position;
        (int,)? $2;
        final $4 = state.predicate;
        state.predicate = true;
        var $5 = true;
        if (state.peek() == 39) {
          state.position += state.charSize(39);
          state.failAndBacktrack($3);
          $5 = false;
        } else {
          state.fail();
        }
        state.predicate = $4;
        if ($5) {
          final $6 = parseSQChar(state);
          if ($6 != null) {
            int $ = $6.$1;
            $2 = ($,);
          }
        }
        if ($2 != null) {
          $7.add($2.$1);
        } else {
          state.position = $3;
          break;
        }
      }
      List<int> n = $7;
      final $8 = state.position;
      if (state.peek() == 39) {
        state.consume('\'', $8);
        parseS(state);
        final String $$;
        $$ = String.fromCharCodes(n);
        String $ = $$;
        $0 = ($,);
      } else {
        state.expected('\'');
      }
    } else {
      state.expected('\'');
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **Sequence**
  ///
  ///```text
  /// `Expression`
  /// Sequence =>
  ///   n = Typing+
  ///   p = (
  ///     '~'
  ///     S
  ///     '{'
  ///     S
  ///     $ = ErrorParameters
  ///     '}'
  ///     S
  ///   )?
  ///   $ = {
  ///     final e = SequenceExpression(expressions: n);
  ///     $$ = p == null ? e : CatchExpression(expression: e, parameters: p);
  ///   }
  ///```
  (Expression,)? parseSequence(State state) {
    (Expression,)? $0;
    final $2 = <Expression>[];
    while (true) {
      final $1 = parseTyping(state);
      if ($1 != null) {
        $2.add($1.$1);
      } else {
        break;
      }
    }
    if ($2.isNotEmpty) {
      List<Expression> n = $2;
      List<(String, String)>? $8;
      final $4 = state.position;
      (List<(String, String)>,)? $3;
      if (state.peek() == 126) {
        state.consume('~', $4);
        parseS(state);
        final $5 = state.position;
        if (state.peek() == 123) {
          state.consume('{', $5);
          parseS(state);
          final $6 = parseErrorParameters(state);
          if ($6 != null) {
            List<(String, String)> $ = $6.$1;
            final $7 = state.position;
            if (state.peek() == 125) {
              state.consume('}', $7);
              parseS(state);
              $3 = ($,);
            } else {
              state.expected('}');
            }
          }
        } else {
          state.expected('{');
        }
      } else {
        state.expected('~');
      }
      if ($3 != null) {
        $8 = $3.$1;
      } else {
        state.position = $4;
      }
      List<(String, String)>? p = $8;
      final Expression $$;
      final e = SequenceExpression(expressions: n);
      $$ = p == null ? e : CatchExpression(expression: e, parameters: p);
      Expression $ = $$;
      $0 = ($,);
    }
    return $0;
  }

  /// **Space**
  ///
  ///```text
  /// `void`
  /// Space =>
  ///   [ {9}] / EndOfLine
  ///```
  (void,)? parseSpace(State state) {
    var $0 = true;
    final $1 = state.peek();
    if ($1 == 9 || $1 == 32) {
      state.position += state.charSize($1);
    } else {
      state.fail();
      final $2 = parseEndOfLine(state);
      if ($2 == null) {
        $0 = false;
      }
    }
    if ($0) {
      return const (null,);
    } else {
      return null;
    }
  }

  /// **Start**
  ///
  ///```text
  /// `Grammar`
  /// Start =>
  ///   S
  ///   g = Globals?
  ///   m = Members?
  ///   r = ProductionRule+
  ///   !.
  ///   $ = { $$ = Grammar(globals: g, members: m, rules: r); }
  ///```
  (Grammar,)? parseStart(State state) {
    final $1 = state.position;
    (Grammar,)? $0;
    parseS(state);
    String? $3;
    final $2 = parseGlobals(state);
    if ($2 != null) {
      $3 = $2.$1;
    }
    String? g = $3;
    String? $5;
    final $4 = parseMembers(state);
    if ($4 != null) {
      $5 = $4.$1;
    }
    String? m = $5;
    final $7 = <ProductionRule>[];
    while (true) {
      final $6 = parseProductionRule(state);
      if ($6 != null) {
        $7.add($6.$1);
      } else {
        break;
      }
    }
    if ($7.isNotEmpty) {
      List<ProductionRule> r = $7;
      if (state.peek() == 0) {
        final Grammar $$;
        $$ = Grammar(globals: g, members: m, rules: r);
        Grammar $ = $$;
        $0 = ($,);
      } else {
        state.fail();
      }
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
      return null;
    }
  }

  /// **String** ('string')
  ///
  ///```text
  /// `String`
  /// String('string') =>
  ///   @expected('string') { DQString / SQString }
  ///```
  (String,)? parseString(State state) {
    final $0 = state.position;
    const $4 = 'string';
    final $5 = state.failure;
    final $6 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    final $2 = parseDQString(state);
    if ($2 != null) {
      $1 = $2;
    } else {
      final $3 = parseSQString(state);
      if ($3 != null) {
        $1 = $3;
      }
    }
    if ($1 != null) {
      state.onSuccess($4, $0, $6);
      return $1;
    } else {
      state.onFailure($4, $0, $6, $5);
      return null;
    }
  }

  /// **Suffix**
  ///
  ///```text
  /// `Expression`
  /// Suffix =>
  ///   $ = Primary
  ///   (
  ///     '*'
  ///     S
  ///     { $ = ZeroOrMoreExpression(expression: $); }
  ///     ----
  ///     '+'
  ///     S
  ///     { $ = OneOrMoreExpression(expression: $); }
  ///     ----
  ///     '?'
  ///     S
  ///     { $ = OptionalExpression(expression: $); }
  ///   )?
  ///```
  (Expression,)? parseSuffix(State state) {
    (Expression,)? $0;
    final $1 = parsePrimary(state);
    if ($1 != null) {
      Expression $ = $1.$1;
      var $2 = true;
      var $3 = false;
      final $4 = state.position;
      if (state.peek() == 42) {
        state.consume('*', $4);
        parseS(state);
        $ = ZeroOrMoreExpression(expression: $);
        $3 = true;
      } else {
        state.expected('*');
      }
      if (!$3) {
        var $5 = false;
        final $6 = state.position;
        if (state.peek() == 43) {
          state.consume('+', $6);
          parseS(state);
          $ = OneOrMoreExpression(expression: $);
          $5 = true;
        } else {
          state.expected('+');
        }
        if (!$5) {
          var $7 = false;
          final $8 = state.position;
          if (state.peek() == 63) {
            state.consume('?', $8);
            parseS(state);
            $ = OptionalExpression(expression: $);
            $7 = true;
          } else {
            state.expected('?');
          }
          if (!$7) {
            $2 = false;
          }
        }
      }
      state.unused = $2;
      $0 = ($,);
    }
    return $0;
  }

  /// **Type** ('type')
  ///
  ///```text
  /// `String`
  /// Type('type') =>
  ///   @expected('type') { '`'
  ///   $ = <
  ///     @while (*) (
  ///       ![`]
  ///       [a-zA-Z0-9_$<(\{,:\})>? ]
  ///     )
  ///   >
  ///   '`'
  ///   S }
  ///```
  (String,)? parseType(State state) {
    final $0 = state.position;
    const $10 = 'type';
    final $11 = state.failure;
    final $12 = state.nesting;
    state.failure = $0;
    state.nesting = $0;
    (String,)? $1;
    if (state.peek() == 96) {
      state.consume('`', $0);
      final $2 = state.position;
      while (true) {
        final $4 = state.position;
        var $3 = false;
        final $5 = state.predicate;
        state.predicate = true;
        var $6 = true;
        if (state.peek() == 96) {
          state.position += state.charSize(96);
          state.failAndBacktrack($4);
          $6 = false;
        } else {
          state.fail();
        }
        state.predicate = $5;
        if ($6) {
          final $7 = state.peek();
          if ($7 >= 60
              ? $7 <= 60 || $7 >= 95
                  ? $7 <= 95 || ($7 >= 125 ? $7 <= 125 : $7 >= 97 && $7 <= 123)
                  : $7 >= 65
                      ? $7 <= 90
                      : $7 >= 62 && $7 <= 63
              : $7 >= 40
                  ? $7 <= 41 || $7 == 44 || $7 >= 48 && $7 <= 58
                  : $7 == 32 || $7 == 36) {
            state.position += state.charSize($7);
            $3 = true;
          } else {
            state.fail();
          }
        }
        if (!$3) {
          state.position = $4;
          break;
        }
      }
      final $8 = state.substring($2, state.position);
      String $ = $8;
      final $9 = state.position;
      if (state.peek() == 96) {
        state.consume('`', $9);
        parseS(state);
        $1 = ($,);
      } else {
        state.expected('`');
      }
    } else {
      state.expected('`');
    }
    if ($1 != null) {
      state.onSuccess($10, $0, $12);
      return $1;
    } else {
      state.position = $0;
      state.onFailure($10, $0, $12, $11);
      return null;
    }
  }

  /// **Typing**
  ///
  ///```text
  /// `Expression`
  /// Typing =>
  ///   t = Type?
  ///   e = Assignment
  ///   $ = { $$ = t == null ? e : TypingExpression(expression: e, type: t); }
  ///```
  (Expression,)? parseTyping(State state) {
    final $1 = state.position;
    (Expression,)? $0;
    String? $3;
    final $2 = parseType(state);
    if ($2 != null) {
      $3 = $2.$1;
    }
    String? t = $3;
    final $4 = parseAssignment(state);
    if ($4 != null) {
      Expression e = $4.$1;
      final Expression $$;
      $$ = t == null ? e : TypingExpression(expression: e, type: t);
      Expression $ = $$;
      $0 = ($,);
    }
    if ($0 != null) {
      return $0;
    } else {
      state.position = $1;
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

//ignore_for_file: curly_braces_in_flow_control_structures, empty_statements, prefer_conditional_assignment, prefer_final_locals

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
      final $2 = ($$,);
      Expression $ = $2.$1;
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
    final $3 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1('.', 46);
    if ($1 != null) {
      parseS(state);
      final Expression $$;
      $$ = AnyCharacterExpression();
      final $2 = ($$,);
      Expression $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $3;
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
  ///   (
  ///     '='
  ///     S
  ///     ----
  ///     ':'
  ///     S
  ///   )
  ///   e = Prefix
  ///   $ = { $$ = VariableExpression(expression: e, name: v); }
  ///   ----
  ///   Prefix
  ///```
  (Expression,)? parseAssignment(State state) {
    final $8 = state.position;
    (Expression,)? $0;
    (String,)? $1;
    $1 = parseIdentifier(state);
    if ($1 == null) {
      final $5 = state.matchLiteral1('\$', 36);
      if ($5 != null) {
        String $ = $5.$1;
        parseS(state);
        $1 = ($,);
      }
    }
    if ($1 != null) {
      String v = $1.$1;
      (void,)? $2;
      final $6 = state.matchLiteral1('=', 61);
      if ($6 != null) {
        parseS(state);
        $2 = (null,);
      }
      if ($2 == null) {
        final $7 = state.matchLiteral1(':', 58);
        if ($7 != null) {
          parseS(state);
          $2 = (null,);
        }
      }
      if ($2 != null) {
        final $3 = parsePrefix(state);
        if ($3 != null) {
          Expression e = $3.$1;
          final Expression $$;
          $$ = VariableExpression(expression: e, name: v);
          final $4 = ($$,);
          Expression $ = $4.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $8;
    }
    $0 ??= parsePrefix(state);
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
    final $6 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1('{', 123);
    if ($1 != null) {
      final $4 = state.position;
      while (true) {
        final $5 = parseBlockBody(state);
        if ($5 == null) {
          break;
        }
      }
      final $2 = (state.substring($4, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral1('}', 125);
      if ($3 != null) {
        parseS(state);
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $6;
    }
    return $0;
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
    final $4 = state.position;
    (void,)? $0;
    final $1 = state.match('{');
    if ($1 != null) {
      while (true) {
        final $3 = parseBlockBody(state);
        if ($3 == null) {
          break;
        }
      }
      final $2 = state.matchLiteral1('}', 125);
      if ($2 != null) {
        $0 = (null,);
      }
    }
    if ($0 == null) {
      state.position = $4;
    }
    if ($0 == null) {
      final $predicate = state.predicate;
      state.predicate = true;
      final $7 = state.match('}');
      state.predicate = $predicate;
      final $5 = $7 == null ? (null,) : state.failAndBacktrack<void>($4);
      if ($5 != null) {
        final $6 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
        if ($6 != null) {
          $0 = (null,);
        }
      }
      if ($0 == null) {
        state.position = $4;
      }
    }
    return $0;
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
    final $11 = state.position;
    (Expression,)? $0;
    var negate = false;
    (void,)? $1;
    final $5 = state.matchLiteral('[^');
    if ($5 != null) {
      negate = true;
      $1 = (null,);
    }
    $1 ??= state.matchLiteral1('[', 91);
    if ($1 != null) {
      final $list = <(int, int)>[];
      while (true) {
        final $9 = state.position;
        ((int, int),)? $6;
        final $predicate = state.predicate;
        state.predicate = true;
        final $10 = state.matchLiteral1(']', 93);
        state.predicate = $predicate;
        final $7 = $10 == null ? (null,) : state.failAndBacktrack<void>($9);
        if ($7 != null) {
          final $8 = parseRange(state);
          if ($8 != null) {
            (int, int) $ = $8.$1;
            $6 = ($,);
          }
        }
        if ($6 == null) {
          state.position = $9;
        }
        if ($6 == null) {
          break;
        }
        $list.add($6.$1);
      }
      final $2 = $list.isNotEmpty ? ($list,) : state.fail<List<(int, int)>>();
      if ($2 != null) {
        List<(int, int)> r = $2.$1;
        final $3 = state.matchLiteral1(']', 93);
        if ($3 != null) {
          parseS(state);
          final Expression $$;
          $$ = CharacterClassExpression(ranges: r, negate: negate);
          final $4 = ($$,);
          Expression $ = $4.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $11;
    }
    return $0;
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
    final $7 = state.position;
    (void,)? $0;
    final $1 = state.match('#');
    if ($1 != null) {
      while (true) {
        final $5 = state.position;
        (void,)? $2;
        final $predicate = state.predicate;
        state.predicate = true;
        final $6 = parseEndOfLine(state);
        state.predicate = $predicate;
        final $3 = $6 == null ? (null,) : state.failAndBacktrack<void>($5);
        if ($3 != null) {
          final $4 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
          if ($4 != null) {
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
      parseEndOfLine(state);
      $0 = (null,);
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
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
  ///   $ = (EscapedValue
  ///   ----
  ///   EscapedHexValue)
  ///```
  (int,)? parseDQChar(State state) {
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match('\\');
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $5 = state.peek();
      final $2 = ($5 >= 35
              ? $5 <= 91 || $5 >= 93 && $5 <= 1114111
              : $5 >= 32 && $5 <= 33)
          ? (state.advance(),)
          : state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $6 = state.match('\\');
      if ($6 != null) {
        (int,)? $7;
        $7 = parseEscapedValue(state);
        $7 ??= parseEscapedHexValue(state);
        if ($7 != null) {
          int $ = $7.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $3;
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
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1('"', 34);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $8 = state.position;
        (int,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        final $9 = state.peek() == 34 ? (state.advance(),) : state.fail<int>();
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          final $7 = parseDQChar(state);
          if ($7 != null) {
            int $ = $7.$1;
            $5 = ($,);
          }
        }
        if ($5 == null) {
          state.position = $8;
        }
        if ($5 == null) {
          break;
        }
        $list.add($5.$1);
      }
      final $2 = ($list,);
      List<int> n = $2.$1;
      final $3 = state.matchLiteral1('"', 34);
      if ($3 != null) {
        parseS(state);
        final String $$;
        $$ = String.fromCharCodes(n);
        final $4 = ($$,);
        String $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $10;
    }
    return $0;
  }

  /// **EndOfLine**
  ///
  ///```text
  /// `void`
  /// EndOfLine =>
  ///   "\r\n"
  ///   ----
  ///   [{a}{d}]
  ///```
  (void,)? parseEndOfLine(State state) {
    (void,)? $0;
    $0 = state.match('\r\n');
    if ($0 == null) {
      final $1 = state.peek();
      $0 = $1 == 10 || $1 == 13 ? (state.advance(),) : state.fail<int>();
    }
    return $0;
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
  ///     k = ('start'
  ///   ----
  ///   'end')
  ///     S
  ///     '='
  ///     S
  ///     v = ('start'
  ///   ----
  ///   'end')
  ///     S
  ///     $ = { $$ = (k, v); }
  ///     ----
  ///     k = 'origin'
  ///     S
  ///     `String` v = (
  ///       n = ('=='
  ///   ----
  ///   '!=')
  ///       S
  ///       s = 'start'
  ///       S
  ///       $ = { $$ = '$n $s'; }
  ///     )
  ///     $ = { $$ = (k, v); }
  ///   )
  ///```
  (List<(String, String)>,)? parseErrorParameters(State state) {
    (List<(String, String)>,)? $0;
    final $list = <(String, String)>[];
    while (true) {
      final $7 = state.position;
      ((String, String),)? $2;
      final $3 = state.matchLiteral('message');
      if ($3 != null) {
        String k = $3.$1;
        parseS(state);
        final $4 = state.matchLiteral1('=', 61);
        if ($4 != null) {
          parseS(state);
          final $5 = parseString(state);
          if ($5 != null) {
            String v = $5.$1;
            parseS(state);
            final (String, String) $$;
            $$ = (k, v);
            final $6 = ($$,);
            (String, String) $ = $6.$1;
            $2 = ($,);
          }
        }
      }
      if ($2 == null) {
        state.position = $7;
      }
      if ($2 == null) {
        (String,)? $8;
        $8 = state.matchLiteral('start');
        $8 ??= state.matchLiteral('end');
        if ($8 != null) {
          String k = $8.$1;
          parseS(state);
          final $9 = state.matchLiteral1('=', 61);
          if ($9 != null) {
            parseS(state);
            (String,)? $10;
            $10 = state.matchLiteral('start');
            $10 ??= state.matchLiteral('end');
            if ($10 != null) {
              String v = $10.$1;
              parseS(state);
              final (String, String) $$;
              $$ = (k, v);
              final $11 = ($$,);
              (String, String) $ = $11.$1;
              $2 = ($,);
            }
          }
        }
        if ($2 == null) {
          state.position = $7;
        }
        if ($2 == null) {
          final $12 = state.matchLiteral('origin');
          if ($12 != null) {
            String k = $12.$1;
            parseS(state);
            final $18 = state.position;
            (String,)? $13;
            (String,)? $15;
            $15 = state.matchLiteral('==');
            $15 ??= state.matchLiteral('!=');
            if ($15 != null) {
              String n = $15.$1;
              parseS(state);
              final $16 = state.matchLiteral('start');
              if ($16 != null) {
                String s = $16.$1;
                parseS(state);
                final String $$;
                $$ = '$n $s';
                final $17 = ($$,);
                String $ = $17.$1;
                $13 = ($,);
              }
            }
            if ($13 == null) {
              state.position = $18;
            }
            if ($13 != null) {
              String v = $13.$1;
              final (String, String) $$;
              $$ = (k, v);
              final $14 = ($$,);
              (String, String) $ = $14.$1;
              $2 = ($,);
            }
          }
          if ($2 == null) {
            state.position = $7;
          }
        }
      }
      if ($2 == null) {
        break;
      }
      $list.add($2.$1);
    }
    final $1 =
        $list.isNotEmpty ? ($list,) : state.fail<List<(String, String)>>();
    if ($1 != null) {
      List<(String, String)> $ = $1.$1;
      $0 = ($,);
    }
    return $0;
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
    final $6 = state.position;
    final $1 = state.failure;
    state.failure = state.position;
    (int,)? $0;
    final $2 = state.match('u');
    if ($2 != null) {
      final $3 = state.matchLiteral1('{', 123);
      if ($3 != null) {
        final $4 = parseHexValue(state);
        if ($4 != null) {
          int $ = $4.$1;
          final $5 = state.matchLiteral1('}', 125);
          if ($5 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $6;
    }
    if ($0 == null) {
      if (state.failure != state.position) {
        state.error(
            'Malformed escape sequence', state.position, state.failure, 3);
      }
    }
    state.failure = state.failure < $1 ? $1 : state.failure;
    return $0;
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
    final $1 = state.failure;
    state.failure = state.position;
    (int,)? $0;
    final $3 = state.peek();
    final $2 = ($3 >= 101
            ? $3 <= 102 || $3 >= 114
                ? $3 <= 114 || $3 == 116 || $3 == 118
                : $3 == 110
            : $3 >= 39
                ? $3 <= 39 || $3 == 92 || $3 >= 97 && $3 <= 98
                : $3 == 34)
        ? (state.advance(),)
        : state.fail<int>();
    if ($2 != null) {
      int $ = $2.$1;
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
    }
    if ($0 == null) {
      state.error(
          'Unexpected escape character', state.position, state.failure, 3);
    }
    state.failure = state.failure < $1 ? $1 : state.failure;
    return $0;
  }

  /// **Expression** ('expression')
  ///
  ///```text
  /// `Expression`
  /// Expression('expression') =>
  ///   OrderedChoice
  ///```
  (Expression,)? parseExpression(State state) {
    final $2 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $3 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    final $0 = parseOrderedChoice(state);
    if (state.failure == $1 && $2 < state.nesting) {
      state.expected($0, 'expression', $1, state.position);
    }
    state.nesting == $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
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
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral('%{');
    if ($1 != null) {
      final $4 = state.position;
      while (true) {
        final $8 = state.position;
        (void,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        final $9 = state.match('}%');
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          final $7 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
          if ($7 != null) {
            $5 = (null,);
          }
        }
        if ($5 == null) {
          state.position = $8;
        }
        if ($5 == null) {
          break;
        }
      }
      final $2 = (state.substring($4, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral('}%');
      if ($3 != null) {
        parseS(state);
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $10;
    }
    return $0;
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
    final $4 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1('(', 40);
    if ($1 != null) {
      parseS(state);
      final $2 = parseExpression(state);
      if ($2 != null) {
        Expression $ = $2.$1;
        final $3 = state.matchLiteral1(')', 41);
        if ($3 != null) {
          parseS(state);
          $ = GroupExpression(expression: $);
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $4;
    }
    return $0;
  }

  /// **HexValue** ('hex number')
  ///
  ///```text
  /// `int`
  /// HexValue('hex number') =>
  ///   n = <[a-fA-F0-9]+>
  ///   $ = { $$ = int.parse(n, radix: 16); }
  ///```
  (int,)? parseHexValue(State state) {
    final $5 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $6 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (int,)? $0;
    for (var c = state.peek();
        c >= 65 ? c <= 70 || c >= 97 && c <= 102 : c >= 48 && c <= 57;) {
      state.advance();
      c = state.peek();
    }
    final $4 = state.position != $1 ? (null,) : state.fail<List<int>>();
    final $2 = $4 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String n = $2.$1;
      final int $$;
      $$ = int.parse(n, radix: 16);
      final $3 = ($$,);
      int $ = $3.$1;
      $0 = ($,);
    }
    if (state.failure == $1 && $5 < state.nesting) {
      state.expected($0, 'hex number', $1, state.position);
    }
    state.nesting == $5;
    state.failure = state.failure < $6 ? $6 : state.failure;
    return $0;
  }

  /// **Identifier** ('identifier')
  ///
  ///```text
  /// `String`
  /// Identifier('identifier') =>
  ///   $ = <
  ///     [a-zA-Z]
  ///     [a-zA-Z0-9_]*
  ///   >
  ///   S
  ///```
  (String,)? parseIdentifier(State state) {
    final $6 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $7 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    (void,)? $3;
    final $5 = state.peek();
    final $4 = ($5 >= 97 ? $5 <= 122 : $5 >= 65 && $5 <= 90)
        ? (state.advance(),)
        : state.fail<int>();
    if ($4 != null) {
      for (var c = state.peek();
          c >= 65
              ? c <= 90 || c == 95 || c >= 97 && c <= 122
              : c >= 48 && c <= 57;) {
        state.advance();
        c = state.peek();
      }
      $3 = (null,);
    }
    final $2 = $3 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String $ = $2.$1;
      parseS(state);
      $0 = ($,);
    }
    if (state.failure == $1 && $6 < state.nesting) {
      state.expected($0, 'identifier', $1, state.position);
    }
    state.nesting == $6;
    state.failure = state.failure < $7 ? $7 : state.failure;
    return $0;
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
    final $1 = parseSQString(state);
    if ($1 != null) {
      String s = $1.$1;
      final Expression $$;
      $$ = LiteralExpression(literal: s);
      final $2 = ($$,);
      Expression $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      final $3 = parseDQString(state);
      if ($3 != null) {
        String s = $3.$1;
        final Expression $$;
        $$ = LiteralExpression(literal: s, silent: true);
        final $4 = ($$,);
        Expression $ = $4.$1;
        $0 = ($,);
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
    final $5 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1('<', 60);
    if ($1 != null) {
      parseS(state);
      final $2 = parseExpression(state);
      if ($2 != null) {
        Expression e = $2.$1;
        final $3 = state.matchLiteral1('>', 62);
        if ($3 != null) {
          parseS(state);
          final Expression $$;
          $$ = MatchExpression(expression: e);
          final $4 = ($$,);
          Expression $ = $4.$1;
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
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral('%%');
    if ($1 != null) {
      final $4 = state.position;
      while (true) {
        final $8 = state.position;
        (void,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        final $9 = state.match('%%');
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          final $7 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
          if ($7 != null) {
            $5 = (null,);
          }
        }
        if ($5 == null) {
          state.position = $8;
        }
        if ($5 == null) {
          break;
        }
      }
      final $2 = (state.substring($4, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral('%%');
      if ($3 != null) {
        parseS(state);
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $10;
    }
    return $0;
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
    final $7 = state.position;
    (Expression,)? $0;
    final $1 = parseRuleName(state);
    if ($1 != null) {
      String i = $1.$1;
      final $4 = state.position;
      final $predicate = state.predicate;
      state.predicate = true;
      (void,)? $5;
      parseProductionRuleArguments(state);
      final $6 = state.matchLiteral('=>');
      if ($6 != null) {
        parseS(state);
        $5 = (null,);
      }
      if ($5 == null) {
        state.position = $4;
      }
      state.predicate = $predicate;
      final $2 = $5 == null ? (null,) : state.failAndBacktrack<void>($4);
      if ($2 != null) {
        final Expression $$;
        $$ = NonterminalExpression(name: i);
        final $3 = ($$,);
        Expression $ = $3.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
  }

  /// **OrderedChoice**
  ///
  ///```text
  /// `Expression`
  /// OrderedChoice =>
  ///   n = Sequence
  ///   { final l = [n]; }
  ///   @while (*) (
  ///     ('/'
  ///   ----
  ///   '-'+)
  ///     S
  ///     n = Sequence
  ///     { l.add(n); }
  ///   )
  ///   $ = { $$ = OrderedChoiceExpression(expressions: l); }
  ///```
  (Expression,)? parseOrderedChoice(State state) {
    final $8 = state.position;
    (Expression,)? $0;
    final $1 = parseSequence(state);
    if ($1 != null) {
      Expression n = $1.$1;
      final l = [n];
      while (true) {
        final $7 = state.position;
        (void,)? $3;
        (void,)? $4;
        $4 = state.matchLiteral1('/', 47);
        if ($4 == null) {
          while (true) {
            final $6 = state.matchLiteral1('-', 45);
            if ($6 == null) {
              break;
            }
          }
          $4 = state.position != $7 ? (null,) : state.fail();
        }
        if ($4 != null) {
          parseS(state);
          final $5 = parseSequence(state);
          if ($5 != null) {
            Expression n = $5.$1;
            l.add(n);
            $3 = (null,);
          }
        }
        if ($3 == null) {
          state.position = $7;
        }
        if ($3 == null) {
          break;
        }
      }
      final Expression $$;
      $$ = OrderedChoiceExpression(expressions: l);
      final $2 = ($$,);
      Expression $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $8;
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
    final $5 = state.position;
    (Expression,)? $0;
    (String?,)? $1;
    final $3 = state.matchLiteral1('!', 33);
    if ($3 != null) {
      String $ = $3.$1;
      parseS(state);
      $1 = ($,);
    }
    if ($1 == null) {
      final $4 = state.matchLiteral1('&', 38);
      if ($4 != null) {
        String $ = $4.$1;
        parseS(state);
        $1 = ($,);
      }
    }
    $1 ??= (null,);
    String? p = $1.$1;
    final $2 = parseSuffix(state);
    if ($2 != null) {
      Expression $ = $2.$1;
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
    if ($0 == null) {
      state.position = $5;
    }
    return $0;
  }

  /// **Primary** ('expression')
  ///
  ///```text
  /// `Expression`
  /// Primary('expression') =>
  ///   CharacterClass
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
  ///   Match
  ///```
  (Expression,)? parsePrimary(State state) {
    final $2 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $3 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (Expression,)? $0;
    $0 = parseCharacterClass(state);
    if ($0 == null) {
      $0 = parseLiteral(state);
      if ($0 == null) {
        $0 = parseGroup(state);
        if ($0 == null) {
          $0 = parseRepeater(state);
          if ($0 == null) {
            $0 = parseNonterminal(state);
            if ($0 == null) {
              $0 = parseAction(state);
              if ($0 == null) {
                $0 = parseAnyCharacter(state);
                $0 ??= parseMatch(state);
              }
            }
          }
        }
      }
    }
    if (state.failure == $1 && $2 < state.nesting) {
      state.expected($0, 'expression', $1, state.position);
    }
    state.nesting == $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
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
    final $7 = state.position;
    (ProductionRule,)? $0;
    (String?,)? $1 = parseType(state);
    $1 ??= (null,);
    String? t = $1.$1;
    final $2 = parseIdentifier(state);
    if ($2 != null) {
      String i = $2.$1;
      (String?,)? $3 = parseProductionRuleArguments(state);
      $3 ??= (null,);
      String? a = $3.$1;
      final $4 = state.matchLiteral('=>');
      if ($4 != null) {
        parseS(state);
        final $5 = parseExpression(state);
        if ($5 != null) {
          Expression e = $5.$1;
          state.peek() == 59 ? (state.advance(),) : state.fail<int>();
          parseS(state);
          final ProductionRule $$;
          $$ = ProductionRule(
              expression: e, expected: a, name: i, resultType: t ?? '');
          final $6 = ($$,);
          ProductionRule $ = $6.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
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
    final $4 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1('(', 40);
    if ($1 != null) {
      parseS(state);
      final $2 = parseString(state);
      if ($2 != null) {
        String $ = $2.$1;
        final $3 = state.matchLiteral1(')', 41);
        if ($3 != null) {
          parseS(state);
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $4;
    }
    return $0;
  }

  /// **Range** ('range')
  ///
  ///```text
  /// `(int, int)`
  /// Range('range') =>
  ///   "{"
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
  ///   $ = { $$ = (n, n); }
  ///```
  ((int, int),)? parseRange(State state) {
    final $18 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $19 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    ((int, int),)? $0;
    final $2 = state.match('{');
    if ($2 != null) {
      final $3 = parseHexValue(state);
      if ($3 != null) {
        int s = $3.$1;
        final $4 = state.match('-');
        if ($4 != null) {
          final $5 = parseHexValue(state);
          if ($5 != null) {
            int e = $5.$1;
            final $6 = state.matchLiteral1('}', 125);
            if ($6 != null) {
              final (int, int) $$;
              $$ = (s, e);
              final $7 = ($$,);
              (int, int) $ = $7.$1;
              $0 = ($,);
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    if ($0 == null) {
      final $8 = state.match('{');
      if ($8 != null) {
        final $9 = parseHexValue(state);
        if ($9 != null) {
          int n = $9.$1;
          final $10 = state.matchLiteral1('}', 125);
          if ($10 != null) {
            final (int, int) $$;
            $$ = (n, n);
            final $11 = ($$,);
            (int, int) $ = $11.$1;
            $0 = ($,);
          }
        }
      }
      if ($0 == null) {
        state.position = $1;
      }
      if ($0 == null) {
        final $12 = parseRangeChar(state);
        if ($12 != null) {
          int s = $12.$1;
          final $13 = state.match('-');
          if ($13 != null) {
            final $14 = parseRangeChar(state);
            if ($14 != null) {
              int e = $14.$1;
              final (int, int) $$;
              $$ = (s, e);
              final $15 = ($$,);
              (int, int) $ = $15.$1;
              $0 = ($,);
            }
          }
        }
        if ($0 == null) {
          state.position = $1;
        }
        if ($0 == null) {
          final $16 = parseRangeChar(state);
          if ($16 != null) {
            int n = $16.$1;
            final (int, int) $$;
            $$ = (n, n);
            final $17 = ($$,);
            (int, int) $ = $17.$1;
            $0 = ($,);
          }
        }
      }
    }
    if (state.failure == $1 && $18 < state.nesting) {
      state.expected($0, 'range', $1, state.position);
    }
    state.nesting == $18;
    state.failure = state.failure < $19 ? $19 : state.failure;
    return $0;
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
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match('\\');
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $5 = state.peek();
      final $2 = (!($5 >= 91
              ? $5 <= 93 || $5 == 123 || $5 == 125
              : $5 >= 0 && $5 <= 31))
          ? (state.advance(),)
          : state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $6 = state.match('\\');
      if ($6 != null) {
        final $12 = state.position;
        (int,)? $7;
        final $8 = state.match('u');
        if ($8 != null) {
          final $9 = state.matchLiteral1('{', 123);
          if ($9 != null) {
            final $10 = parseHexValue(state);
            if ($10 != null) {
              int $ = $10.$1;
              final $11 = state.matchLiteral1('}', 125);
              if ($11 != null) {
                $7 = ($,);
              }
            }
          }
        }
        if ($7 == null) {
          state.position = $12;
        }
        if ($7 == null) {
          final $14 = state.peek();
          final $13 = ($14 >= 110
                  ? $14 <= 110 || $14 >= 118
                      ? $14 <= 118 || $14 == 123 || $14 == 125
                      : $14 == 114 || $14 == 116
                  : $14 >= 91
                      ? $14 <= 94 ||
                          ($14 >= 101 ? $14 <= 102 : $14 >= 97 && $14 <= 98)
                      : $14 == 45)
              ? (state.advance(),)
              : state.fail<int>();
          if ($13 != null) {
            int $ = $13.$1;
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
            $7 = ($,);
          }
        }
        if ($7 != null) {
          int $ = $7.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $3;
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
    final $9 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral('@while');
    if ($1 != null) {
      parseS(state);
      final $2 = state.matchLiteral1('(', 40);
      if ($2 != null) {
        parseS(state);
        final $3 = state.matchLiteral1('*', 42);
        if ($3 != null) {
          parseS(state);
          final $4 = state.matchLiteral1(')', 41);
          if ($4 != null) {
            parseS(state);
            final $5 = state.matchLiteral1('{', 123);
            if ($5 != null) {
              parseS(state);
              final $6 = parseExpression(state);
              if ($6 != null) {
                Expression e = $6.$1;
                final $7 = state.matchLiteral1('}', 125);
                if ($7 != null) {
                  parseS(state);
                  final Expression $$;
                  $$ = ZeroOrMoreExpression(
                      expression: GroupExpression(expression: e));
                  final $8 = ($$,);
                  Expression $ = $8.$1;
                  $0 = ($,);
                }
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $9;
    }
    if ($0 == null) {
      final $10 = state.matchLiteral('@while');
      if ($10 != null) {
        parseS(state);
        final $11 = state.matchLiteral1('(', 40);
        if ($11 != null) {
          parseS(state);
          final $12 = state.matchLiteral1('+', 43);
          if ($12 != null) {
            parseS(state);
            final $13 = state.matchLiteral1(')', 41);
            if ($13 != null) {
              parseS(state);
              final $14 = state.matchLiteral1('{', 123);
              if ($14 != null) {
                parseS(state);
                final $15 = parseExpression(state);
                if ($15 != null) {
                  Expression e = $15.$1;
                  final $16 = state.matchLiteral1('}', 125);
                  if ($16 != null) {
                    parseS(state);
                    final Expression $$;
                    $$ = OneOrMoreExpression(
                        expression: GroupExpression(expression: e));
                    final $17 = ($$,);
                    Expression $ = $17.$1;
                    $0 = ($,);
                  }
                }
              }
            }
          }
        }
      }
      if ($0 == null) {
        state.position = $9;
      }
    }
    return $0;
  }

  /// **RuleName** ('production rule name')
  ///
  ///```text
  /// `String`
  /// RuleName('production rule name') =>
  ///   $ = <
  ///     [A-Z]
  ///     [a-zA-Z0-9_]*
  ///   >
  ///   S
  ///```
  (String,)? parseRuleName(State state) {
    final $6 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $7 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    (void,)? $3;
    final $5 = state.peek();
    final $4 = $5 >= 65 && $5 <= 90 ? (state.advance(),) : state.fail<int>();
    if ($4 != null) {
      for (var c = state.peek();
          c >= 65
              ? c <= 90 || c == 95 || c >= 97 && c <= 122
              : c >= 48 && c <= 57;) {
        state.advance();
        c = state.peek();
      }
      $3 = (null,);
    }
    final $2 = $3 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String $ = $2.$1;
      parseS(state);
      $0 = ($,);
    }
    if (state.failure == $1 && $6 < state.nesting) {
      state.expected($0, 'production rule name', $1, state.position);
    }
    state.nesting == $6;
    state.failure = state.failure < $7 ? $7 : state.failure;
    return $0;
  }

  /// **S**
  ///
  ///```text
  /// `List<void>`
  /// S =>
  ///   @while (*) (Space
  ///   ----
  ///   Comment)
  ///```
  (List<void>,)? parseS(State state) {
    final $list = <void>[];
    while (true) {
      (void,)? $1;
      $1 = parseSpace(state);
      $1 ??= parseComment(state);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = ($list,);
    return $0;
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
  ///   $ = (EscapedValue
  ///   ----
  ///   EscapedHexValue)
  ///```
  (int,)? parseSQChar(State state) {
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match('\\');
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $5 = state.peek();
      final $2 = ($5 >= 40
              ? $5 <= 91 || $5 >= 93 && $5 <= 1114111
              : $5 >= 32 && $5 <= 38)
          ? (state.advance(),)
          : state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $6 = state.match('\\');
      if ($6 != null) {
        (int,)? $7;
        $7 = parseEscapedValue(state);
        $7 ??= parseEscapedHexValue(state);
        if ($7 != null) {
          int $ = $7.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $3;
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
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1('\'', 39);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $8 = state.position;
        (int,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        final $9 = state.peek() == 39 ? (state.advance(),) : state.fail<int>();
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          final $7 = parseSQChar(state);
          if ($7 != null) {
            int $ = $7.$1;
            $5 = ($,);
          }
        }
        if ($5 == null) {
          state.position = $8;
        }
        if ($5 == null) {
          break;
        }
        $list.add($5.$1);
      }
      final $2 = ($list,);
      List<int> n = $2.$1;
      final $3 = state.matchLiteral1('\'', 39);
      if ($3 != null) {
        parseS(state);
        final String $$;
        $$ = String.fromCharCodes(n);
        final $4 = ($$,);
        String $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $10;
    }
    return $0;
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
    final $10 = state.position;
    (Expression,)? $0;
    final $list = <Expression>[];
    while (true) {
      final $4 = parseTyping(state);
      if ($4 == null) {
        break;
      }
      $list.add($4.$1);
    }
    final $1 = $list.isNotEmpty ? ($list,) : state.fail<List<Expression>>();
    if ($1 != null) {
      List<Expression> n = $1.$1;
      final $9 = state.position;
      (List<(String, String)>?,)? $2;
      final $5 = state.matchLiteral1('~', 126);
      if ($5 != null) {
        parseS(state);
        final $6 = state.matchLiteral1('{', 123);
        if ($6 != null) {
          parseS(state);
          final $7 = parseErrorParameters(state);
          if ($7 != null) {
            List<(String, String)> $ = $7.$1;
            final $8 = state.matchLiteral1('}', 125);
            if ($8 != null) {
              parseS(state);
              $2 = ($,);
            }
          }
        }
      }
      if ($2 == null) {
        state.position = $9;
      }
      $2 ??= (null,);
      List<(String, String)>? p = $2.$1;
      final Expression $$;
      final e = SequenceExpression(expressions: n);
      $$ = p == null ? e : CatchExpression(expression: e, parameters: p);
      final $3 = ($$,);
      Expression $ = $3.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $10;
    }
    return $0;
  }

  /// **Space**
  ///
  ///```text
  /// `void`
  /// Space =>
  ///   [ {9}]
  ///   ----
  ///   EndOfLine
  ///```
  (void,)? parseSpace(State state) {
    (void,)? $0;
    final $1 = state.peek();
    $0 = $1 == 9 || $1 == 32 ? (state.advance(),) : state.fail<int>();
    $0 ??= parseEndOfLine(state);
    return $0;
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
    final $7 = state.position;
    (Grammar,)? $0;
    parseS(state);
    (String?,)? $1 = parseGlobals(state);
    $1 ??= (null,);
    String? g = $1.$1;
    (String?,)? $2 = parseMembers(state);
    $2 ??= (null,);
    String? m = $2.$1;
    final $list = <ProductionRule>[];
    while (true) {
      final $6 = parseProductionRule(state);
      if ($6 == null) {
        break;
      }
      $list.add($6.$1);
    }
    final $3 = $list.isNotEmpty ? ($list,) : state.fail<List<ProductionRule>>();
    if ($3 != null) {
      List<ProductionRule> r = $3.$1;
      final $4 = state.peek() == 0 ? (null,) : null;
      if ($4 != null) {
        final Grammar $$;
        $$ = Grammar(globals: g, members: m, rules: r);
        final $5 = ($$,);
        Grammar $ = $5.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $7;
    }
    return $0;
  }

  /// **String** ('string')
  ///
  ///```text
  /// `String`
  /// String('string') =>
  ///   DQString
  ///   ----
  ///   SQString
  ///```
  (String,)? parseString(State state) {
    final $2 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $3 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    $0 = parseDQString(state);
    $0 ??= parseSQString(state);
    if (state.failure == $1 && $2 < state.nesting) {
      state.expected($0, 'string', $1, state.position);
    }
    state.nesting == $2;
    state.failure = state.failure < $3 ? $3 : state.failure;
    return $0;
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
      final $4 = state.position;
      (void,)? $2;
      final $3 = state.matchLiteral1('*', 42);
      if ($3 != null) {
        parseS(state);
        $ = ZeroOrMoreExpression(expression: $);
        $2 = (null,);
      }
      if ($2 == null) {
        state.position = $4;
      }
      if ($2 == null) {
        final $5 = state.matchLiteral1('+', 43);
        if ($5 != null) {
          parseS(state);
          $ = OneOrMoreExpression(expression: $);
          $2 = (null,);
        }
        if ($2 == null) {
          state.position = $4;
        }
        if ($2 == null) {
          final $6 = state.matchLiteral1('?', 63);
          if ($6 != null) {
            parseS(state);
            $ = OptionalExpression(expression: $);
            $2 = (null,);
          }
          if ($2 == null) {
            state.position = $4;
          }
        }
      }
      $0 = ($,);
    }
    return $0;
  }

  /// **Type** ('type')
  ///
  ///```text
  /// `String`
  /// Type('type') =>
  ///   '`'
  ///   $ = <
  ///     @while (*) (
  ///       ![`]
  ///       [a-zA-Z0-9_$<(\{,:\})>? ]
  ///     )
  ///   >
  ///   '`'
  ///   S
  ///```
  (String,)? parseType(State state) {
    final $12 = state.nesting;
    state.nesting =
        state.nesting < state.position ? state.position : state.nesting;
    final $13 = state.failure;
    state.failure = state.position;
    final $1 = state.position;
    (String,)? $0;
    final $2 = state.matchLiteral1('`', 96);
    if ($2 != null) {
      final $5 = state.position;
      while (true) {
        final $9 = state.position;
        (void,)? $6;
        final $predicate = state.predicate;
        state.predicate = true;
        final $10 = state.peek() == 96 ? (state.advance(),) : state.fail<int>();
        state.predicate = $predicate;
        final $7 = $10 == null ? (null,) : state.failAndBacktrack<void>($9);
        if ($7 != null) {
          final $11 = state.peek();
          final $8 = ($11 >= 60
                  ? $11 <= 60 || $11 >= 95
                      ? $11 <= 95 ||
                          ($11 >= 125 ? $11 <= 125 : $11 >= 97 && $11 <= 123)
                      : $11 >= 65
                          ? $11 <= 90
                          : $11 >= 62 && $11 <= 63
                  : $11 >= 40
                      ? $11 <= 41 || $11 == 44 || $11 >= 48 && $11 <= 58
                      : $11 == 32 || $11 == 36)
              ? (state.advance(),)
              : state.fail<int>();
          if ($8 != null) {
            $6 = (null,);
          }
        }
        if ($6 == null) {
          state.position = $9;
        }
        if ($6 == null) {
          break;
        }
      }
      final $3 = (state.substring($5, state.position),);
      String $ = $3.$1;
      final $4 = state.matchLiteral1('`', 96);
      if ($4 != null) {
        parseS(state);
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    if (state.failure == $1 && $12 < state.nesting) {
      state.expected($0, 'type', $1, state.position);
    }
    state.nesting == $12;
    state.failure = state.failure < $13 ? $13 : state.failure;
    return $0;
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
    final $4 = state.position;
    (Expression,)? $0;
    (String?,)? $1 = parseType(state);
    $1 ??= (null,);
    String? t = $1.$1;
    final $2 = parseAssignment(state);
    if ($2 != null) {
      Expression e = $2.$1;
      final Expression $$;
      $$ = t == null ? e : TypingExpression(expression: e, type: t);
      final $3 = ($$,);
      Expression $ = $3.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $4;
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
    if (_input.startsWith(string, position)) {
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

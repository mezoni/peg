// ignore_for_file: prefer_final_locals

import 'package:source_span/source_span.dart';

import '../expressions/expressions.dart';
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
  ///```code
  /// `Expression`
  /// Action =
  ///    b = Block $ = { }
  ///```
  (Expression,)? parseAction(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = parseBlock(state);
    if ($1 != null) {
      String b = $1.$1;
      late Expression $$;
      $$ = ActionExpression(code: b);
      final $2 = state.opt(($$,));
      if ($2 != null) {
        Expression $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **AnyCharacter**
  ///
  ///```code
  /// `Expression`
  /// AnyCharacter =
  ///    '.' S $ = { }
  ///```
  (Expression,)? parseAnyCharacter(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = state.match1('.', 46);
    if ($1 != null) {
      final $2 = parseS(state);
      if ($2 != null) {
        late Expression $$;
        $$ = AnyCharacterExpression();
        final $3 = state.opt(($$,));
        if ($3 != null) {
          Expression $ = $3.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Assignment**
  ///
  ///```code
  /// `Expression`
  /// Assignment =
  ///     v = (Identifier / $ = '\$' S) ('=' S / ':' S) t = Type? e = Prefix $ = { }
  ///   / t = Type? e = Prefix $ = { }
  ///```
  (Expression,)? parseAssignment(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    (String,)? $1;
    $1 = parseIdentifier(state);
    if ($1 == null) {
      final $2 = state.match1('\$', 36);
      if ($2 != null) {
        String $ = $2.$1;
        final $3 = parseS(state);
        if ($3 != null) {
          $1 = ($,);
        }
      }
      if ($1 == null) {
        state.position = $pos;
      }
    }
    if ($1 != null) {
      String v = $1.$1;
      (void,)? $4;
      final $pos1 = state.position;
      final $5 = state.match1('=', 61);
      if ($5 != null) {
        final $6 = parseS(state);
        if ($6 != null) {
          $4 = const (null,);
        }
      }
      if ($4 == null) {
        state.position = $pos1;
      }
      if ($4 == null) {
        final $pos2 = state.position;
        final $7 = state.match1(':', 58);
        if ($7 != null) {
          final $8 = parseS(state);
          if ($8 != null) {
            $4 = const (null,);
          }
        }
        if ($4 == null) {
          state.position = $pos2;
        }
      }
      if ($4 != null) {
        (String?,)? $9;
        $9 = parseType(state);
        $9 ??= state.opt((null,));
        if ($9 != null) {
          String? t = $9.$1;
          final $10 = parsePrefix(state);
          if ($10 != null) {
            Expression e = $10.$1;
            late Expression $$;
            $$ = e
              ..semanticVariable = v
              ..resultType = t ?? '';
            final $11 = state.opt(($$,));
            if ($11 != null) {
              Expression $ = $11.$1;
              $0 = ($,);
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      (String?,)? $12;
      $12 = parseType(state);
      $12 ??= state.opt((null,));
      if ($12 != null) {
        String? t = $12.$1;
        final $13 = parsePrefix(state);
        if ($13 != null) {
          Expression e = $13.$1;
          late Expression $$;
          $$ = e..resultType = t ?? '';
          final $14 = state.opt(($$,));
          if ($14 != null) {
            Expression $ = $14.$1;
            $0 = ($,);
          }
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **Block**
  ///
  ///```code
  /// `String`
  /// Block =
  ///    '{' $ = <BlockBody*> '}' S
  ///```
  (String,)? parseBlock(State state) {
    final $pos1 = state.position;
    (String,)? $0;
    final $1 = state.match1('{', 123);
    if ($1 != null) {
      final $pos = state.position;
      while (true) {
        final $4 = parseBlockBody(state);
        if ($4 == null) {
          break;
        }
      }
      final $3 = state.opt((const <void>[],));
      final $2 =
          $3 != null ? (state.input.substring($pos, state.position),) : null;
      if ($2 != null) {
        String $ = $2.$1;
        final $5 = state.match1('}', 125);
        if ($5 != null) {
          final $6 = parseS(state);
          if ($6 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **BlockBody**
  ///
  ///```code
  /// `void`
  /// BlockBody =
  ///     "{" BlockBody* '}'
  ///   / !"}" .
  ///```
  (void,)? parseBlockBody(State state) {
    final $pos = state.position;
    (void,)? $0;
    final $1 = state.match1('{', 123, true);
    if ($1 != null) {
      while (true) {
        final $3 = parseBlockBody(state);
        if ($3 == null) {
          break;
        }
      }
      final $2 = state.opt((const <void>[],));
      if ($2 != null) {
        final $4 = state.match1('}', 125);
        if ($4 != null) {
          $0 = const (null,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $7 = state.notPredicate;
      state.notPredicate = true;
      final $6 = state.match1('}', 125, true);
      state.notPredicate = $7;
      if ($6 != null) {
        state.fail(state.position - $pos);
        state.position = $pos;
      }
      final $5 = $6 == null ? const (null,) : null;
      if ($5 != null) {
        final $8 = state.matchAny();
        if ($8 != null) {
          $0 = const (null,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **CharacterClass**
  ///
  ///```code
  /// `Expression`
  /// CharacterClass =
  ///    { } ('[^' { } / '[') r = !"]" $ = Range+ ']' S $ = { }
  ///```
  (Expression,)? parseCharacterClass(State state) {
    final $pos2 = state.position;
    (Expression,)? $0;
    var negate = false;
    final $1 = state.opt((null,));
    if ($1 != null) {
      (void,)? $2;
      final $pos = state.position;
      final $3 = state.match2('[^', 91, 94);
      if ($3 != null) {
        negate = true;
        final $4 = state.opt((null,));
        if ($4 != null) {
          $2 = const (null,);
        }
      }
      if ($2 == null) {
        state.position = $pos;
      }
      if ($2 == null) {
        $2 = state.match1('[', 91);
      }
      if ($2 != null) {
        final $list = <(int, int)>[];
        while (true) {
          final $pos1 = state.position;
          ((int, int),)? $6;
          final $9 = state.notPredicate;
          state.notPredicate = true;
          final $8 = state.match1(']', 93, true);
          state.notPredicate = $9;
          if ($8 != null) {
            state.fail(state.position - $pos1);
            state.position = $pos1;
          }
          final $7 = $8 == null ? const (null,) : null;
          if ($7 != null) {
            final $10 = parseRange(state);
            if ($10 != null) {
              (int, int) $ = $10.$1;
              $6 = ($,);
            }
          }
          if ($6 == null) {
            state.position = $pos1;
          }
          if ($6 == null) {
            break;
          }
          $list.add($6.$1);
        }
        final $5 = $list.isNotEmpty ? ($list,) : null;
        if ($5 != null) {
          List<(int, int)> r = $5.$1;
          final $11 = state.match1(']', 93);
          if ($11 != null) {
            final $12 = parseS(state);
            if ($12 != null) {
              late Expression $$;
              $$ = CharacterClassExpression(ranges: r, negate: negate);
              final $13 = state.opt(($$,));
              if ($13 != null) {
                Expression $ = $13.$1;
                $0 = ($,);
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos2;
    }
    return $0;
  }

  /// **Comment**
  ///
  ///```code
  /// `void`
  /// Comment =
  ///    "#" !EndOfLine .* EndOfLine?
  ///```
  (void,)? parseComment(State state) {
    final $pos1 = state.position;
    (void,)? $0;
    final $1 = state.match1('#', 35, true);
    if ($1 != null) {
      while (true) {
        final $pos = state.position;
        (void,)? $3;
        final $6 = state.notPredicate;
        state.notPredicate = true;
        final $5 = parseEndOfLine(state);
        state.notPredicate = $6;
        if ($5 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $4 = $5 == null ? const (null,) : null;
        if ($4 != null) {
          final $7 = state.matchAny();
          if ($7 != null) {
            $3 = const (null,);
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
        (void,)? $8;
        $8 = parseEndOfLine(state);
        $8 ??= state.opt((null,));
        if ($8 != null) {
          $0 = const (null,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **DQChar**
  ///
  ///```code
  /// `int`
  /// DQChar =
  ///     !"\\" $ = [ -!#-\[{5d-10ffff}]
  ///   / "\\" $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseDQChar(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $3 = state.notPredicate;
    state.notPredicate = true;
    final $2 = state.match1('\\', 92, true);
    state.notPredicate = $3;
    if ($2 != null) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    final $1 = $2 == null ? const (null,) : null;
    if ($1 != null) {
      final $4 = state.matchChars32((int c) =>
          c >= 35 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 33);
      if ($4 != null) {
        int $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $5 = state.match1('\\', 92, true);
      if ($5 != null) {
        (int,)? $6;
        $6 = parseEscapedValue(state);
        if ($6 == null) {
          $6 = parseEscapedHexValue(state);
        }
        if ($6 != null) {
          int $ = $6.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **DQString**
  ///
  ///```code
  /// `String`
  /// DQString =
  ///    '"' n = !["] $ = DQChar* '"' S $ = { }
  ///```
  (String,)? parseDQString(State state) {
    final $pos1 = state.position;
    (String,)? $0;
    final $1 = state.match1('"', 34);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $pos = state.position;
        (int,)? $3;
        final $6 = state.notPredicate;
        state.notPredicate = true;
        final $5 = state.matchChar16(34);
        state.notPredicate = $6;
        if ($5 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $4 = $5 == null ? const (null,) : null;
        if ($4 != null) {
          final $7 = parseDQChar(state);
          if ($7 != null) {
            int $ = $7.$1;
            $3 = ($,);
          }
        }
        if ($3 == null) {
          state.position = $pos;
        }
        if ($3 == null) {
          break;
        }
        $list.add($3.$1);
      }
      final $2 = state.opt(($list,));
      if ($2 != null) {
        List<int> n = $2.$1;
        final $8 = state.match1('"', 34);
        if ($8 != null) {
          final $9 = parseS(state);
          if ($9 != null) {
            late String $$;
            $$ = String.fromCharCodes(n);
            final $10 = state.opt(($$,));
            if ($10 != null) {
              String $ = $10.$1;
              $0 = ($,);
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **EndOfLine**
  ///
  ///```code
  /// `void`
  /// EndOfLine =
  ///     "\r\n"
  ///   / [\n\r]
  ///```
  (void,)? parseEndOfLine(State state) {
    (void,)? $0;
    $0 = state.match2('\r\n', 13, 10, true);
    if ($0 == null) {
      $0 = state.matchChars16((int c) => c == 10 || c == 13);
    }
    return $0;
  }

  /// **EscapedHexValue**
  ///
  ///```code
  /// `int`
  /// EscapedHexValue =
  ///    "u" '{' $ = HexValue '}' ~ { }
  ///```
  (int,)? parseEscapedHexValue(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $failure = state.enter();
    final $1 = state.match1('u', 117, true);
    if ($1 != null) {
      final $2 = state.match1('{', 123);
      if ($2 != null) {
        final $3 = parseHexValue(state);
        if ($3 != null) {
          int $ = $3.$1;
          final $4 = state.match1('}', 125);
          if ($4 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      state.malformed('Malformed escape sequence');
    }
    state.leave($failure);
    return $0;
  }

  /// **EscapedValue**
  ///
  ///```code
  /// `int`
  /// EscapedValue =
  ///    $ = [abefnrtv'"\\] { } ~ { }
  ///```
  (int,)? parseEscapedValue(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $failure = state.enter();
    final $1 = state.matchChars16((int c) => c >= 101
        ? c <= 102 || c >= 114
            ? c <= 114 || c == 116 || c == 118
            : c == 110
        : c >= 39
            ? c <= 39 || c == 92 || c >= 97 && c <= 98
            : c == 34);
    if ($1 != null) {
      int $ = $1.$1;
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
      final $2 = state.opt((null,));
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      state.error('Unexpected escape character');
    }
    state.leave($failure);
    return $0;
  }

  /// **Expression** ('expression')
  ///
  ///```code
  /// `Expression`
  /// Expression =
  ///    OrderedChoice
  ///```
  (Expression,)? parseExpression(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    final $0 = parseOrderedChoice(state);
    state.expected($0, 'expression', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **Globals**
  ///
  ///```code
  /// `String`
  /// Globals =
  ///    '%{' $ = <!"}%" .*> '}%' S
  ///```
  (String,)? parseGlobals(State state) {
    final $pos2 = state.position;
    (String,)? $0;
    final $1 = state.match2('%{', 37, 123);
    if ($1 != null) {
      final $pos1 = state.position;
      while (true) {
        final $pos = state.position;
        (void,)? $4;
        final $7 = state.notPredicate;
        state.notPredicate = true;
        final $6 = state.match2('}%', 125, 37, true);
        state.notPredicate = $7;
        if ($6 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $5 = $6 == null ? const (null,) : null;
        if ($5 != null) {
          final $8 = state.matchAny();
          if ($8 != null) {
            $4 = const (null,);
          }
        }
        if ($4 == null) {
          state.position = $pos;
        }
        if ($4 == null) {
          break;
        }
      }
      final $3 = state.opt((const <void>[],));
      final $2 =
          $3 != null ? (state.input.substring($pos1, state.position),) : null;
      if ($2 != null) {
        String $ = $2.$1;
        final $9 = state.match2('}%', 125, 37);
        if ($9 != null) {
          final $10 = parseS(state);
          if ($10 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos2;
    }
    return $0;
  }

  /// **Group**
  ///
  ///```code
  /// `Expression`
  /// Group =
  ///    '(' S $ = Expression ')' S { }
  ///```
  (Expression,)? parseGroup(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = state.match1('(', 40);
    if ($1 != null) {
      final $2 = parseS(state);
      if ($2 != null) {
        final $3 = parseExpression(state);
        if ($3 != null) {
          Expression $ = $3.$1;
          final $4 = state.match1(')', 41);
          if ($4 != null) {
            final $5 = parseS(state);
            if ($5 != null) {
              $.isGrouped = true;
              final $6 = state.opt((null,));
              if ($6 != null) {
                $0 = ($,);
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **HexValue** ('hex number')
  ///
  ///```code
  /// `int`
  /// HexValue =
  ///    n = <[a-fA-F0-9]+> $ = { }
  ///```
  (int,)? parseHexValue(State state) {
    final $4 = state.enter();
    final $pos = state.position;
    (int,)? $0;
    final $2 = state.skip16While1((int c) =>
        c >= 65 ? c <= 70 || c >= 97 && c <= 102 : c >= 48 && c <= 57);
    final $1 =
        $2 != null ? (state.input.substring($pos, state.position),) : null;
    if ($1 != null) {
      String n = $1.$1;
      late int $$;
      $$ = int.parse(n, radix: 16);
      final $3 = state.opt(($$,));
      if ($3 != null) {
        int $ = $3.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    state.expected($0, 'hex number', $pos, false);
    state.leave($4);
    return $0;
  }

  /// **Identifier** ('identifier')
  ///
  ///```code
  /// `String`
  /// Identifier =
  ///    $ = <[a-zA-Z] [a-zA-Z0-9_]*> S
  ///```
  (String,)? parseIdentifier(State state) {
    final $6 = state.enter();
    final $pos = state.position;
    (String,)? $0;
    (void,)? $2;
    final $3 = state
        .matchChars16((int c) => c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if ($3 != null) {
      final $4 = state.skip16While((int c) => c >= 65
          ? c <= 90 || c == 95 || c >= 97 && c <= 122
          : c >= 48 && c <= 57);
      if ($4 != null) {
        $2 = const (null,);
      }
    }
    if ($2 == null) {
      state.position = $pos;
    }
    final $1 =
        $2 != null ? (state.input.substring($pos, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      final $5 = parseS(state);
      if ($5 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    state.expected($0, 'identifier', $pos, false);
    state.leave($6);
    return $0;
  }

  /// **Literal**
  ///
  ///```code
  /// `Expression`
  /// Literal =
  ///     s = SQString $ = { }
  ///   / s = DQString $ = { }
  ///```
  (Expression,)? parseLiteral(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = parseSQString(state);
    if ($1 != null) {
      String s = $1.$1;
      late Expression $$;
      $$ = LiteralExpression(literal: s);
      final $2 = state.opt(($$,));
      if ($2 != null) {
        Expression $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $3 = parseDQString(state);
      if ($3 != null) {
        String s = $3.$1;
        late Expression $$;
        $$ = LiteralExpression(literal: s, silent: true);
        final $4 = state.opt(($$,));
        if ($4 != null) {
          Expression $ = $4.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **Match**
  ///
  ///```code
  /// `Expression`
  /// Match =
  ///    '<' S e = Expression '>' S $ = { }
  ///```
  (Expression,)? parseMatch(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = state.match1('<', 60);
    if ($1 != null) {
      final $2 = parseS(state);
      if ($2 != null) {
        final $3 = parseExpression(state);
        if ($3 != null) {
          Expression e = $3.$1;
          final $4 = state.match1('>', 62);
          if ($4 != null) {
            final $5 = parseS(state);
            if ($5 != null) {
              late Expression $$;
              $$ = MatchExpression(expression: e);
              final $6 = state.opt(($$,));
              if ($6 != null) {
                Expression $ = $6.$1;
                $0 = ($,);
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Members**
  ///
  ///```code
  /// `String`
  /// Members =
  ///    '%%' $ = <!"%%" .*> '%%' S
  ///```
  (String,)? parseMembers(State state) {
    final $pos2 = state.position;
    (String,)? $0;
    final $1 = state.match2('%%', 37, 37);
    if ($1 != null) {
      final $pos1 = state.position;
      while (true) {
        final $pos = state.position;
        (void,)? $4;
        final $7 = state.notPredicate;
        state.notPredicate = true;
        final $6 = state.match2('%%', 37, 37, true);
        state.notPredicate = $7;
        if ($6 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $5 = $6 == null ? const (null,) : null;
        if ($5 != null) {
          final $8 = state.matchAny();
          if ($8 != null) {
            $4 = const (null,);
          }
        }
        if ($4 == null) {
          state.position = $pos;
        }
        if ($4 == null) {
          break;
        }
      }
      final $3 = state.opt((const <void>[],));
      final $2 =
          $3 != null ? (state.input.substring($pos1, state.position),) : null;
      if ($2 != null) {
        String $ = $2.$1;
        final $9 = state.match2('%%', 37, 37);
        if ($9 != null) {
          final $10 = parseS(state);
          if ($10 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos2;
    }
    return $0;
  }

  /// **Nonterminal**
  ///
  ///```code
  /// `Expression`
  /// Nonterminal =
  ///    i = RuleName !(ProductionRuleArguments? '=>' S) $ = { }
  ///```
  (Expression,)? parseNonterminal(State state) {
    final $pos2 = state.position;
    (Expression,)? $0;
    final $1 = parseRuleName(state);
    if ($1 != null) {
      String i = $1.$1;
      final $pos1 = state.position;
      final $4 = state.notPredicate;
      state.notPredicate = true;
      final $pos = state.position;
      (void,)? $3;
      (String?,)? $5;
      $5 = parseProductionRuleArguments(state);
      $5 ??= state.opt((null,));
      if ($5 != null) {
        final $6 = state.match2('=>', 61, 62);
        if ($6 != null) {
          final $7 = parseS(state);
          if ($7 != null) {
            $3 = const (null,);
          }
        }
      }
      if ($3 == null) {
        state.position = $pos;
      }
      state.notPredicate = $4;
      if ($3 != null) {
        state.fail(state.position - $pos1);
        state.position = $pos1;
      }
      final $2 = $3 == null ? const (null,) : null;
      if ($2 != null) {
        late Expression $$;
        $$ = NonterminalExpression(name: i);
        final $8 = state.opt(($$,));
        if ($8 != null) {
          Expression $ = $8.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos2;
    }
    return $0;
  }

  /// **OrderedChoice**
  ///
  ///```code
  /// `Expression`
  /// OrderedChoice =
  ///    n = Sequence { } ('/' / '-'*) S n = Sequence { }* $ = { }
  ///```
  (Expression,)? parseOrderedChoice(State state) {
    final $pos1 = state.position;
    (Expression,)? $0;
    final $1 = parseSequence(state);
    if ($1 != null) {
      Expression n = $1.$1;
      final l = [n];
      final $2 = state.opt((null,));
      if ($2 != null) {
        while (true) {
          final $pos = state.position;
          (void,)? $4;
          (void,)? $5;
          $5 = state.match1('/', 47);
          if ($5 == null) {
            while (true) {
              final $6 = state.match1('-', 45);
              if ($6 == null) {
                break;
              }
            }
            $5 = state.opt((const <String>[],));
          }
          if ($5 != null) {
            final $7 = parseS(state);
            if ($7 != null) {
              final $8 = parseSequence(state);
              if ($8 != null) {
                Expression n = $8.$1;
                l.add(n);
                final $9 = state.opt((null,));
                if ($9 != null) {
                  $4 = const (null,);
                }
              }
            }
          }
          if ($4 == null) {
            state.position = $pos;
          }
          if ($4 == null) {
            break;
          }
        }
        final $3 = state.opt((const <void>[],));
        if ($3 != null) {
          late Expression $$;
          $$ = OrderedChoiceExpression(expressions: l);
          final $10 = state.opt(($$,));
          if ($10 != null) {
            Expression $ = $10.$1;
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Prefix**
  ///
  ///```code
  /// `Expression`
  /// Prefix =
  ///    p = ($ = '!' S / $ = '&' S)? $ = Suffix { }
  ///```
  (Expression,)? parsePrefix(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    (String?,)? $1;
    final $2 = state.match1('!', 33);
    if ($2 != null) {
      String $ = $2.$1;
      final $3 = parseS(state);
      if ($3 != null) {
        $1 = ($,);
      }
    }
    if ($1 == null) {
      state.position = $pos;
    }
    if ($1 == null) {
      final $4 = state.match1('&', 38);
      if ($4 != null) {
        String $ = $4.$1;
        final $5 = parseS(state);
        if ($5 != null) {
          $1 = ($,);
        }
      }
      if ($1 == null) {
        state.position = $pos;
      }
    }
    $1 ??= state.opt((null,));
    if ($1 != null) {
      String? p = $1.$1;
      final $6 = parseSuffix(state);
      if ($6 != null) {
        Expression $ = $6.$1;
        switch (p) {
          case '!':
            $ = NotPredicateExpression(expression: $);
            break;
          case '&':
            $ = AndPredicateExpression(expression: $);
            break;
        }
        final $7 = state.opt((null,));
        if ($7 != null) {
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Primary** ('expression')
  ///
  ///```code
  /// `Expression`
  /// Primary =
  ///     CharacterClass
  ///   / Literal
  ///   / Group
  ///   / Repeater
  ///   / Nonterminal
  ///   / Action
  ///   / AnyCharacter
  ///   / Match
  ///```
  (Expression,)? parsePrimary(State state) {
    final $pos = state.position;
    final $1 = state.enter();
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
                if ($0 == null) {
                  $0 = parseMatch(state);
                }
              }
            }
          }
        }
      }
    }
    state.expected($0, 'expression', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **ProductionRule**
  ///
  ///```code
  /// `ProductionRule`
  /// ProductionRule =
  ///    t = Type? i = Identifier a = ProductionRuleArguments? '=>' S e = Expression [;]? S $ = { }
  ///```
  (ProductionRule,)? parseProductionRule(State state) {
    final $pos = state.position;
    (ProductionRule,)? $0;
    (String?,)? $1;
    $1 = parseType(state);
    $1 ??= state.opt((null,));
    if ($1 != null) {
      String? t = $1.$1;
      final $2 = parseIdentifier(state);
      if ($2 != null) {
        String i = $2.$1;
        (String?,)? $3;
        $3 = parseProductionRuleArguments(state);
        $3 ??= state.opt((null,));
        if ($3 != null) {
          String? a = $3.$1;
          final $4 = state.match2('=>', 61, 62);
          if ($4 != null) {
            final $5 = parseS(state);
            if ($5 != null) {
              final $6 = parseExpression(state);
              if ($6 != null) {
                Expression e = $6.$1;
                (int?,)? $7;
                $7 = state.matchChar16(59);
                $7 ??= state.opt((null,));
                if ($7 != null) {
                  final $8 = parseS(state);
                  if ($8 != null) {
                    late ProductionRule $$;
                    $$ = ProductionRule(
                        expression: e,
                        expected: a,
                        name: i,
                        resultType: t ?? '');
                    final $9 = state.opt(($$,));
                    if ($9 != null) {
                      ProductionRule $ = $9.$1;
                      $0 = ($,);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **ProductionRuleArguments**
  ///
  ///```code
  /// `String`
  /// ProductionRuleArguments =
  ///    '(' S $ = String ')' S
  ///```
  (String,)? parseProductionRuleArguments(State state) {
    final $pos = state.position;
    (String,)? $0;
    final $1 = state.match1('(', 40);
    if ($1 != null) {
      final $2 = parseS(state);
      if ($2 != null) {
        final $3 = parseString(state);
        if ($3 != null) {
          String $ = $3.$1;
          final $4 = state.match1(')', 41);
          if ($4 != null) {
            final $5 = parseS(state);
            if ($5 != null) {
              $0 = ($,);
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Range** ('range')
  ///
  ///```code
  /// `(int, int)`
  /// Range =
  ///     "{" s = HexValue "-" e = HexValue '}' $ = { }
  ///   / "{" n = HexValue '}' $ = { }
  ///   / s = RangeChar "-" e = RangeChar $ = { }
  ///   / n = RangeChar $ = { }
  ///```
  ((int, int),)? parseRange(State state) {
    final $17 = state.enter();
    final $pos = state.position;
    ((int, int),)? $0;
    final $1 = state.match1('{', 123, true);
    if ($1 != null) {
      final $2 = parseHexValue(state);
      if ($2 != null) {
        int s = $2.$1;
        final $3 = state.match1('-', 45, true);
        if ($3 != null) {
          final $4 = parseHexValue(state);
          if ($4 != null) {
            int e = $4.$1;
            final $5 = state.match1('}', 125);
            if ($5 != null) {
              late (int, int) $$;
              $$ = (s, e);
              final $6 = state.opt(($$,));
              if ($6 != null) {
                (int, int) $ = $6.$1;
                $0 = ($,);
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $7 = state.match1('{', 123, true);
      if ($7 != null) {
        final $8 = parseHexValue(state);
        if ($8 != null) {
          int n = $8.$1;
          final $9 = state.match1('}', 125);
          if ($9 != null) {
            late (int, int) $$;
            $$ = (n, n);
            final $10 = state.opt(($$,));
            if ($10 != null) {
              (int, int) $ = $10.$1;
              $0 = ($,);
            }
          }
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
      if ($0 == null) {
        final $11 = parseRangeChar(state);
        if ($11 != null) {
          int s = $11.$1;
          final $12 = state.match1('-', 45, true);
          if ($12 != null) {
            final $13 = parseRangeChar(state);
            if ($13 != null) {
              int e = $13.$1;
              late (int, int) $$;
              $$ = (s, e);
              final $14 = state.opt(($$,));
              if ($14 != null) {
                (int, int) $ = $14.$1;
                $0 = ($,);
              }
            }
          }
        }
        if ($0 == null) {
          state.position = $pos;
        }
        if ($0 == null) {
          final $15 = parseRangeChar(state);
          if ($15 != null) {
            int n = $15.$1;
            late (int, int) $$;
            $$ = (n, n);
            final $16 = state.opt(($$,));
            if ($16 != null) {
              (int, int) $ = $16.$1;
              $0 = ($,);
            }
          }
          if ($0 == null) {
            state.position = $pos;
          }
        }
      }
    }
    state.expected($0, 'range', $pos, false);
    state.leave($17);
    return $0;
  }

  /// **RangeChar**
  ///
  ///```code
  /// `int`
  /// RangeChar =
  ///     !"\\" $ = [ -Z{5e-10ffff}]
  ///   / "\\" $ = ("u" '{' $ = HexValue '}' / $ = [\-abefnrtv\{\}\[\]\\] { })
  ///```
  (int,)? parseRangeChar(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $3 = state.notPredicate;
    state.notPredicate = true;
    final $2 = state.match1('\\', 92, true);
    state.notPredicate = $3;
    if ($2 != null) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    final $1 = $2 == null ? const (null,) : null;
    if ($1 != null) {
      final $4 = state.matchChars32(
          (int c) => c >= 32 && c <= 90 || c >= 94 && c <= 1114111);
      if ($4 != null) {
        int $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $5 = state.match1('\\', 92, true);
      if ($5 != null) {
        (int,)? $6;
        final $pos1 = state.position;
        final $7 = state.match1('u', 117, true);
        if ($7 != null) {
          final $8 = state.match1('{', 123);
          if ($8 != null) {
            final $9 = parseHexValue(state);
            if ($9 != null) {
              int $ = $9.$1;
              final $10 = state.match1('}', 125);
              if ($10 != null) {
                $6 = ($,);
              }
            }
          }
        }
        if ($6 == null) {
          state.position = $pos1;
        }
        if ($6 == null) {
          final $pos2 = state.position;
          final $11 = state.matchChars16((int c) => c >= 110
              ? c <= 110 || c >= 118
                  ? c <= 118 || c == 123 || c == 125
                  : c == 114 || c == 116
              : c >= 91
                  ? c <= 93 || c >= 97 && c <= 98 || c >= 101 && c <= 102
                  : c == 45);
          if ($11 != null) {
            int $ = $11.$1;
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
            final $12 = state.opt((null,));
            if ($12 != null) {
              $6 = ($,);
            }
          }
          if ($6 == null) {
            state.position = $pos2;
          }
        }
        if ($6 != null) {
          int $ = $6.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **Repeater**
  ///
  ///```code
  /// `Expression`
  /// Repeater =
  ///     '@while' S '(' S '*' S ')' S '{' S e = Expression '}' S $ = { }
  ///   / '@while' S '(' S '+' S ')' S '{' S e = Expression '}' S $ = { }
  ///```
  (Expression,)? parseRepeater(State state) {
    final $pos = state.position;
    (Expression,)? $0;
    final $1 = state.match('@while');
    if ($1 != null) {
      final $2 = parseS(state);
      if ($2 != null) {
        final $3 = state.match1('(', 40);
        if ($3 != null) {
          final $4 = parseS(state);
          if ($4 != null) {
            final $5 = state.match1('*', 42);
            if ($5 != null) {
              final $6 = parseS(state);
              if ($6 != null) {
                final $7 = state.match1(')', 41);
                if ($7 != null) {
                  final $8 = parseS(state);
                  if ($8 != null) {
                    final $9 = state.match1('{', 123);
                    if ($9 != null) {
                      final $10 = parseS(state);
                      if ($10 != null) {
                        final $11 = parseExpression(state);
                        if ($11 != null) {
                          Expression e = $11.$1;
                          final $12 = state.match1('}', 125);
                          if ($12 != null) {
                            final $13 = parseS(state);
                            if ($13 != null) {
                              late Expression $$;
                              $$ = ZeroOrMoreExpression(
                                  expression: e..isGrouped = true);
                              final $14 = state.opt(($$,));
                              if ($14 != null) {
                                Expression $ = $14.$1;
                                $0 = ($,);
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $15 = state.match('@while');
      if ($15 != null) {
        final $16 = parseS(state);
        if ($16 != null) {
          final $17 = state.match1('(', 40);
          if ($17 != null) {
            final $18 = parseS(state);
            if ($18 != null) {
              final $19 = state.match1('+', 43);
              if ($19 != null) {
                final $20 = parseS(state);
                if ($20 != null) {
                  final $21 = state.match1(')', 41);
                  if ($21 != null) {
                    final $22 = parseS(state);
                    if ($22 != null) {
                      final $23 = state.match1('{', 123);
                      if ($23 != null) {
                        final $24 = parseS(state);
                        if ($24 != null) {
                          final $25 = parseExpression(state);
                          if ($25 != null) {
                            Expression e = $25.$1;
                            final $26 = state.match1('}', 125);
                            if ($26 != null) {
                              final $27 = parseS(state);
                              if ($27 != null) {
                                late Expression $$;
                                $$ = OneOrMoreExpression(
                                    expression: e..isGrouped = true);
                                final $28 = state.opt(($$,));
                                if ($28 != null) {
                                  Expression $ = $28.$1;
                                  $0 = ($,);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **RuleName** ('production rule name')
  ///
  ///```code
  /// `String`
  /// RuleName =
  ///    $ = <[A-Z] [a-zA-Z0-9_]*> S
  ///```
  (String,)? parseRuleName(State state) {
    final $6 = state.enter();
    final $pos = state.position;
    (String,)? $0;
    (void,)? $2;
    final $3 = state.matchChars16((int c) => c >= 65 && c <= 90);
    if ($3 != null) {
      final $4 = state.skip16While((int c) => c >= 65
          ? c <= 90 || c == 95 || c >= 97 && c <= 122
          : c >= 48 && c <= 57);
      if ($4 != null) {
        $2 = const (null,);
      }
    }
    if ($2 == null) {
      state.position = $pos;
    }
    final $1 =
        $2 != null ? (state.input.substring($pos, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      final $5 = parseS(state);
      if ($5 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    state.expected($0, 'production rule name', $pos, false);
    state.leave($6);
    return $0;
  }

  /// **S**
  ///
  ///```code
  /// `List<void>`
  /// S =
  ///    Space / Comment*
  ///```
  (List<void>,)? parseS(State state) {
    final $list = <void>[];
    while (true) {
      (void,)? $1;
      $1 = parseSpace(state);
      if ($1 == null) {
        $1 = parseComment(state);
      }
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = state.opt(($list,));
    return $0;
  }

  /// **SQChar**
  ///
  ///```code
  /// `int`
  /// SQChar =
  ///     !"\\" $ = [ -&(-\[{5d-10ffff}]
  ///   / "\\" $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseSQChar(State state) {
    final $pos = state.position;
    (int,)? $0;
    final $3 = state.notPredicate;
    state.notPredicate = true;
    final $2 = state.match1('\\', 92, true);
    state.notPredicate = $3;
    if ($2 != null) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    final $1 = $2 == null ? const (null,) : null;
    if ($1 != null) {
      final $4 = state.matchChars32((int c) =>
          c >= 40 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 38);
      if ($4 != null) {
        int $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    if ($0 == null) {
      final $5 = state.match1('\\', 92, true);
      if ($5 != null) {
        (int,)? $6;
        $6 = parseEscapedValue(state);
        if ($6 == null) {
          $6 = parseEscapedHexValue(state);
        }
        if ($6 != null) {
          int $ = $6.$1;
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
    }
    return $0;
  }

  /// **SQString**
  ///
  ///```code
  /// `String`
  /// SQString =
  ///    '\'' n = !['] $ = SQChar* '\'' S $ = { }
  ///```
  (String,)? parseSQString(State state) {
    final $pos1 = state.position;
    (String,)? $0;
    final $1 = state.match1('\'', 39);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $pos = state.position;
        (int,)? $3;
        final $6 = state.notPredicate;
        state.notPredicate = true;
        final $5 = state.matchChar16(39);
        state.notPredicate = $6;
        if ($5 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $4 = $5 == null ? const (null,) : null;
        if ($4 != null) {
          final $7 = parseSQChar(state);
          if ($7 != null) {
            int $ = $7.$1;
            $3 = ($,);
          }
        }
        if ($3 == null) {
          state.position = $pos;
        }
        if ($3 == null) {
          break;
        }
        $list.add($3.$1);
      }
      final $2 = state.opt(($list,));
      if ($2 != null) {
        List<int> n = $2.$1;
        final $8 = state.match1('\'', 39);
        if ($8 != null) {
          final $9 = parseS(state);
          if ($9 != null) {
            late String $$;
            $$ = String.fromCharCodes(n);
            final $10 = state.opt(($$,));
            if ($10 != null) {
              String $ = $10.$1;
              $0 = ($,);
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Sequence**
  ///
  ///```code
  /// `Expression`
  /// Sequence =
  ///    n = Assignment+ b = ('~' S $ = Block)? $ = { }
  ///```
  (Expression,)? parseSequence(State state) {
    final $pos1 = state.position;
    (Expression,)? $0;
    final $list = <Expression>[];
    while (true) {
      final $2 = parseAssignment(state);
      if ($2 == null) {
        break;
      }
      $list.add($2.$1);
    }
    final $1 = $list.isNotEmpty ? ($list,) : null;
    if ($1 != null) {
      List<Expression> n = $1.$1;
      (String?,)? $3;
      final $pos = state.position;
      final $4 = state.match1('~', 126);
      if ($4 != null) {
        final $5 = parseS(state);
        if ($5 != null) {
          final $6 = parseBlock(state);
          if ($6 != null) {
            String $ = $6.$1;
            $3 = ($,);
          }
        }
      }
      if ($3 == null) {
        state.position = $pos;
      }
      $3 ??= state.opt((null,));
      if ($3 != null) {
        String? b = $3.$1;
        late Expression $$;
        final e = SequenceExpression(expressions: n);
        $$ = b == null ? e : CatchExpression(expression: e, catchBlock: b);
        final $7 = state.opt(($$,));
        if ($7 != null) {
          Expression $ = $7.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Space**
  ///
  ///```code
  /// `void`
  /// Space =
  ///     [ \t]
  ///   / EndOfLine
  ///```
  (void,)? parseSpace(State state) {
    (void,)? $0;
    $0 = state.matchChars16((int c) => c == 9 || c == 32);
    if ($0 == null) {
      $0 = parseEndOfLine(state);
    }
    return $0;
  }

  /// **Start**
  ///
  ///```code
  /// `Grammar`
  /// Start =
  ///    S g = Globals? m = Members? r = ProductionRule+ !. $ = { }
  ///```
  (Grammar,)? parseStart(State state) {
    final $pos1 = state.position;
    (Grammar,)? $0;
    final $1 = parseS(state);
    if ($1 != null) {
      (String?,)? $2;
      $2 = parseGlobals(state);
      $2 ??= state.opt((null,));
      if ($2 != null) {
        String? g = $2.$1;
        (String?,)? $3;
        $3 = parseMembers(state);
        $3 ??= state.opt((null,));
        if ($3 != null) {
          String? m = $3.$1;
          final $list = <ProductionRule>[];
          while (true) {
            final $5 = parseProductionRule(state);
            if ($5 == null) {
              break;
            }
            $list.add($5.$1);
          }
          final $4 = $list.isNotEmpty ? ($list,) : null;
          if ($4 != null) {
            List<ProductionRule> r = $4.$1;
            final $pos = state.position;
            final $8 = state.notPredicate;
            state.notPredicate = true;
            final $7 = state.matchAny();
            state.notPredicate = $8;
            if ($7 != null) {
              state.fail(state.position - $pos);
              state.position = $pos;
            }
            final $6 = $7 == null ? const (null,) : null;
            if ($6 != null) {
              late Grammar $$;
              $$ = Grammar(globals: g, members: m, rules: r);
              final $9 = state.opt(($$,));
              if ($9 != null) {
                Grammar $ = $9.$1;
                $0 = ($,);
              }
            }
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **String** ('string')
  ///
  ///```code
  /// `String`
  /// String =
  ///     DQString
  ///   / SQString
  ///```
  (String,)? parseString(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    (String,)? $0;
    $0 = parseDQString(state);
    if ($0 == null) {
      $0 = parseSQString(state);
    }
    state.expected($0, 'string', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **Suffix**
  ///
  ///```code
  /// `Expression`
  /// Suffix =
  ///    $ = Primary ('*' S { } / '+' S { } / '?' S { })?
  ///```
  (Expression,)? parseSuffix(State state) {
    final $pos1 = state.position;
    (Expression,)? $0;
    final $1 = parsePrimary(state);
    if ($1 != null) {
      Expression $ = $1.$1;
      (void,)? $2;
      final $pos = state.position;
      final $3 = state.match1('*', 42);
      if ($3 != null) {
        final $4 = parseS(state);
        if ($4 != null) {
          $ = ZeroOrMoreExpression(expression: $);
          final $5 = state.opt((null,));
          if ($5 != null) {
            $2 = const (null,);
          }
        }
      }
      if ($2 == null) {
        state.position = $pos;
      }
      if ($2 == null) {
        final $6 = state.match1('+', 43);
        if ($6 != null) {
          final $7 = parseS(state);
          if ($7 != null) {
            $ = OneOrMoreExpression(expression: $);
            final $8 = state.opt((null,));
            if ($8 != null) {
              $2 = const (null,);
            }
          }
        }
        if ($2 == null) {
          state.position = $pos;
        }
        if ($2 == null) {
          final $9 = state.match1('?', 63);
          if ($9 != null) {
            final $10 = parseS(state);
            if ($10 != null) {
              $ = OptionalExpression(expression: $);
              final $11 = state.opt((null,));
              if ($11 != null) {
                $2 = const (null,);
              }
            }
          }
          if ($2 == null) {
            state.position = $pos;
          }
        }
      }
      $2 ??= state.opt((null,));
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Type** ('type')
  ///
  ///```code
  /// `String`
  /// Type =
  ///    '`' $ = <![`] [a-zA-Z0-9_$<(\{,:\})>? ]*> '`' S
  ///```
  (String,)? parseType(State state) {
    final $11 = state.enter();
    final $pos2 = state.position;
    (String,)? $0;
    final $1 = state.match1('`', 96);
    if ($1 != null) {
      final $pos1 = state.position;
      while (true) {
        final $pos = state.position;
        (void,)? $4;
        final $7 = state.notPredicate;
        state.notPredicate = true;
        final $6 = state.matchChar16(96);
        state.notPredicate = $7;
        if ($6 != null) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        final $5 = $6 == null ? const (null,) : null;
        if ($5 != null) {
          final $8 = state.matchChars16((int c) => c >= 60
              ? c <= 60 || c >= 95
                  ? c <= 95 || c >= 97 && c <= 123 || c == 125
                  : c >= 62 && c <= 63 || c >= 65 && c <= 90
              : c >= 40
                  ? c <= 41 || c == 44 || c >= 48 && c <= 58
                  : c == 32 || c == 36);
          if ($8 != null) {
            $4 = const (null,);
          }
        }
        if ($4 == null) {
          state.position = $pos;
        }
        if ($4 == null) {
          break;
        }
      }
      final $3 = state.opt((const <void>[],));
      final $2 =
          $3 != null ? (state.input.substring($pos1, state.position),) : null;
      if ($2 != null) {
        String $ = $2.$1;
        final $9 = state.match1('`', 96);
        if ($9 != null) {
          final $10 = parseS(state);
          if ($10 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $pos2;
    }
    state.expected($0, 'type', $pos2, false);
    state.leave($11);
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

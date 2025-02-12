// ignore_for_file: prefer_final_locals

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
  ///```code
  /// `Expression`
  /// Action =
  ///    b = Block $ = { }
  ///```
  (Expression,)? parseAction(State state) {
    (Expression,)? $0;
    (String,)? $1 = parseBlock(state);
    if ($1 != null) {
      String b = $1.$1;
      late Expression $$;
      $$ = ActionExpression(code: b);
      (Expression,)? $2 = ($$,);
      Expression $ = $2.$1;
      $0 = ($,);
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
    final $3 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1(('.',), '.', 46);
    if ($1 != null) {
      parseS(state);
      late Expression $$;
      $$ = AnyCharacterExpression();
      (Expression,)? $2 = ($$,);
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
  ///```code
  /// `Expression`
  /// Assignment =
  ///     v = (Identifier / $ = '\$' S) ('=' S / ':' S) e = Prefix $ = { }
  ///   / Prefix
  ///```
  (Expression,)? parseAssignment(State state) {
    final $8 = state.position;
    (Expression,)? $0;
    (String,)? $1;
    $1 = parseIdentifier(state);
    if ($1 == null) {
      (String,)? $5 = state.matchLiteral1(('\$',), '\$', 36);
      if ($5 != null) {
        String $ = $5.$1;
        parseS(state);
        $1 = ($,);
      }
    }
    if ($1 != null) {
      String v = $1.$1;
      (void,)? $2;
      final $6 = state.matchLiteral1(('=',), '=', 61);
      if ($6 != null) {
        parseS(state);
        $2 = (null,);
      }
      if ($2 == null) {
        final $7 = state.matchLiteral1((':',), ':', 58);
        if ($7 != null) {
          parseS(state);
          $2 = (null,);
        }
      }
      if ($2 != null) {
        (Expression,)? $3 = parsePrefix(state);
        if ($3 != null) {
          Expression e = $3.$1;
          late Expression $$;
          $$ = VariableExpression(expression: e, name: v);
          (Expression,)? $4 = ($$,);
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
  ///```code
  /// `String`
  /// Block =
  ///    '{' $ = <BlockBody*> '}' S
  ///```
  (String,)? parseBlock(State state) {
    final $6 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1(('{',), '{', 123);
    if ($1 != null) {
      final $5 = state.position;
      while (true) {
        final $4 = parseBlockBody(state);
        if ($4 == null) {
          break;
        }
      }
      (String,)? $2 = (state.substring($5, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral1(('}',), '}', 125);
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
  ///```code
  /// `void`
  /// BlockBody =
  ///     "{" BlockBody* '}'
  ///   / !"}" .
  ///```
  (void,)? parseBlockBody(State state) {
    final $4 = state.position;
    (void,)? $0;
    final $1 = state.match1(('{',), 123);
    if ($1 != null) {
      while (true) {
        final $3 = parseBlockBody(state);
        if ($3 == null) {
          break;
        }
      }
      final $2 = state.matchLiteral1(('}',), '}', 125);
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
      final $7 = state.match1(('}',), 125);
      state.predicate = $predicate;
      final $5 = $7 == null ? (null,) : state.failAndBacktrack<void>($4);
      if ($5 != null) {
        final $6 = state.matchAny();
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
  ///```code
  /// `Expression`
  /// CharacterClass =
  ///    { } ('[^' { } / '[') r = !']' $ = Range+ ']' S $ = { }
  ///```
  (Expression,)? parseCharacterClass(State state) {
    final $11 = state.position;
    (Expression,)? $0;
    var negate = false;
    (void,)? $1;
    final $5 = state.matchLiteral2(('[^',), '[^', 91, 94);
    if ($5 != null) {
      negate = true;
      $1 = (null,);
    }
    $1 ??= state.matchLiteral1(('[',), '[', 91);
    if ($1 != null) {
      final $list = <(int, int)>[];
      while (true) {
        final $9 = state.position;
        ((int, int),)? $6;
        final $predicate = state.predicate;
        state.predicate = true;
        final $10 = state.matchLiteral1((']',), ']', 93);
        state.predicate = $predicate;
        final $7 = $10 == null ? (null,) : state.failAndBacktrack<void>($9);
        if ($7 != null) {
          ((int, int),)? $8 = parseRange(state);
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
      (List<(int, int)>,)? $2 = $list.isNotEmpty ? ($list,) : null;
      if ($2 != null) {
        List<(int, int)> r = $2.$1;
        final $3 = state.matchLiteral1((']',), ']', 93);
        if ($3 != null) {
          parseS(state);
          late Expression $$;
          $$ = CharacterClassExpression(ranges: r, negate: negate);
          (Expression,)? $4 = ($$,);
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
  ///```code
  /// `void`
  /// Comment =
  ///    "#" !EndOfLine .* EndOfLine?
  ///```
  (void,)? parseComment(State state) {
    final $7 = state.position;
    (void,)? $0;
    final $1 = state.match1(('#',), 35);
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
          final $4 = state.matchAny();
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
  ///```code
  /// `int`
  /// DQChar =
  ///     !"\\" $ = [ -!#-\[{5d-10ffff}]
  ///   / "\\" $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseDQChar(State state) {
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match1(('\\',), 92);
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $6 = state.position;
      (int,)? $5;
      if (state.position < state.length) {
        final c = state.nextChar32();
        final ok =
            c >= 35 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 33;
        $5 = ok ? (c,) : null;
        $5 ?? (state.position = $6);
      }
      (int,)? $2 = $5 ?? state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $7 = state.match1(('\\',), 92);
      if ($7 != null) {
        (int,)? $8;
        $8 = parseEscapedValue(state);
        $8 ??= parseEscapedHexValue(state);
        if ($8 != null) {
          int $ = $8.$1;
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
  ///```code
  /// `String`
  /// DQString =
  ///    '"' n = !["] $ = DQChar* '"' S $ = { }
  ///```
  (String,)? parseDQString(State state) {
    final $11 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1(('"',), '"', 34);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $8 = state.position;
        (int,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        (int,)? $10;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $10 = c == 34 ? (c,) : null;
          $10 ?? (state.position = $8);
        }
        final $9 = $10 ?? state.fail<int>();
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          (int,)? $7 = parseDQChar(state);
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
      (List<int>,)? $2 = ($list,);
      List<int> n = $2.$1;
      final $3 = state.matchLiteral1(('"',), '"', 34);
      if ($3 != null) {
        parseS(state);
        late String $$;
        $$ = String.fromCharCodes(n);
        (String,)? $4 = ($$,);
        String $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $11;
    }
    return $0;
  }

  /// **EndOfLine**
  ///
  ///```code
  /// `void`
  /// EndOfLine =
  ///     "\r\n"
  ///   / [{a}{d}]
  ///```
  (void,)? parseEndOfLine(State state) {
    final $2 = state.position;
    (void,)? $0;
    $0 = state.match2(('\r\n',), 13, 10);
    if ($0 == null) {
      (int,)? $1;
      if (state.position < state.length) {
        final c = state.nextChar16();
        final ok = c == 10 || c == 13;
        $1 = ok ? (c,) : null;
        $1 ?? (state.position = $2);
      }
      $0 = $1 ?? state.fail<int>();
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
    final $5 = state.position;
    final $failure = state.enter();
    (int,)? $0;
    final $1 = state.match1(('u',), 117);
    if ($1 != null) {
      final $2 = state.matchLiteral1(('{',), '{', 123);
      if ($2 != null) {
        (int,)? $3 = parseHexValue(state);
        if ($3 != null) {
          int $ = $3.$1;
          final $4 = state.matchLiteral1(('}',), '}', 125);
          if ($4 != null) {
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
      state.position = $5;
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
    final $3 = state.position;
    final $failure = state.enter();
    (int,)? $0;
    (int,)? $2;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 101
          ? c <= 102 || c >= 114
              ? c <= 114 || c == 116 || c == 118
              : c == 110
          : c >= 39
              ? c <= 39 || c == 92 || c >= 97 && c <= 98
              : c == 34;
      $2 = ok ? (c,) : null;
      $2 ?? (state.position = $3);
    }
    (int,)? $1 = $2 ?? state.fail<int>();
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
      $0 = ($,);
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
    final $2 = state.enter();
    final $1 = state.position;
    final $0 = parseOrderedChoice(state);
    state.expected($0, 'expression', $1, false);
    state.leave($2);
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
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral2(('%{',), '%{', 37, 123);
    if ($1 != null) {
      final $9 = state.position;
      while (true) {
        final $7 = state.position;
        (void,)? $4;
        final $predicate = state.predicate;
        state.predicate = true;
        final $8 = state.match2(('}%',), 125, 37);
        state.predicate = $predicate;
        final $5 = $8 == null ? (null,) : state.failAndBacktrack<void>($7);
        if ($5 != null) {
          final $6 = state.matchAny();
          if ($6 != null) {
            $4 = (null,);
          }
        }
        if ($4 == null) {
          state.position = $7;
        }
        if ($4 == null) {
          break;
        }
      }
      (String,)? $2 = (state.substring($9, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral2(('}%',), '}%', 125, 37);
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
  ///```code
  /// `Expression`
  /// Group =
  ///    '(' S $ = Expression ')' S { }
  ///```
  (Expression,)? parseGroup(State state) {
    final $4 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1(('(',), '(', 40);
    if ($1 != null) {
      parseS(state);
      (Expression,)? $2 = parseExpression(state);
      if ($2 != null) {
        Expression $ = $2.$1;
        final $3 = state.matchLiteral1((')',), ')', 41);
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
  ///```code
  /// `int`
  /// HexValue =
  ///    n = <[a-fA-F0-9]+> $ = { }
  ///```
  (int,)? parseHexValue(State state) {
    final $5 = state.enter();
    final $1 = state.position;
    (int,)? $0;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c >= 65 ? c <= 70 || c >= 97 && c <= 102 : c >= 48 && c <= 57;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    state.fail<List<void>>();
    final $4 = state.position != $1 ? const (<int>[],) : null;
    (String,)? $2 = $4 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String n = $2.$1;
      late int $$;
      $$ = int.parse(n, radix: 16);
      (int,)? $3 = ($$,);
      int $ = $3.$1;
      $0 = ($,);
    }
    state.expected($0, 'hex number', $1, false);
    state.leave($5);
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
    final $1 = state.position;
    (String,)? $0;
    (void,)? $3;
    (int,)? $5;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 97 ? c <= 122 : c >= 65 && c <= 90;
      $5 = ok ? (c,) : null;
      $5 ?? (state.position = $1);
    }
    final $4 = $5 ?? state.fail<int>();
    if ($4 != null) {
      while (state.position < state.length) {
        final position = state.position;
        final c = state.nextChar16();
        final ok = c >= 65
            ? c <= 90 || c == 95 || c >= 97 && c <= 122
            : c >= 48 && c <= 57;
        if (!ok) {
          state.position = position;
          break;
        }
      }
      $3 = (null,);
    }
    (String,)? $2 = $3 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String $ = $2.$1;
      parseS(state);
      $0 = ($,);
    }
    state.expected($0, 'identifier', $1, false);
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
    (Expression,)? $0;
    (String,)? $1 = parseSQString(state);
    if ($1 != null) {
      String s = $1.$1;
      late Expression $$;
      $$ = LiteralExpression(literal: s);
      (Expression,)? $2 = ($$,);
      Expression $ = $2.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      (String,)? $3 = parseDQString(state);
      if ($3 != null) {
        String s = $3.$1;
        late Expression $$;
        $$ = LiteralExpression(literal: s, silent: true);
        (Expression,)? $4 = ($$,);
        Expression $ = $4.$1;
        $0 = ($,);
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
    final $5 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral1(('<',), '<', 60);
    if ($1 != null) {
      parseS(state);
      (Expression,)? $2 = parseExpression(state);
      if ($2 != null) {
        Expression e = $2.$1;
        final $3 = state.matchLiteral1(('>',), '>', 62);
        if ($3 != null) {
          parseS(state);
          late Expression $$;
          $$ = MatchExpression(expression: e);
          (Expression,)? $4 = ($$,);
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
  ///```code
  /// `String`
  /// Members =
  ///    '%%' $ = <!"%%" .*> '%%' S
  ///```
  (String,)? parseMembers(State state) {
    final $10 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral2(('%%',), '%%', 37, 37);
    if ($1 != null) {
      final $9 = state.position;
      while (true) {
        final $7 = state.position;
        (void,)? $4;
        final $predicate = state.predicate;
        state.predicate = true;
        final $8 = state.match2(('%%',), 37, 37);
        state.predicate = $predicate;
        final $5 = $8 == null ? (null,) : state.failAndBacktrack<void>($7);
        if ($5 != null) {
          final $6 = state.matchAny();
          if ($6 != null) {
            $4 = (null,);
          }
        }
        if ($4 == null) {
          state.position = $7;
        }
        if ($4 == null) {
          break;
        }
      }
      (String,)? $2 = (state.substring($9, state.position),);
      String $ = $2.$1;
      final $3 = state.matchLiteral2(('%%',), '%%', 37, 37);
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
  ///```code
  /// `Expression`
  /// Nonterminal =
  ///    i = RuleName !(ProductionRuleArguments? '=>' S) $ = { }
  ///```
  (Expression,)? parseNonterminal(State state) {
    final $8 = state.position;
    (Expression,)? $0;
    (String,)? $1 = parseRuleName(state);
    if ($1 != null) {
      String i = $1.$1;
      final $4 = state.position;
      final $predicate = state.predicate;
      state.predicate = true;
      final $7 = state.position;
      (void,)? $5;
      parseProductionRuleArguments(state);
      final $6 = state.matchLiteral2(('=>',), '=>', 61, 62);
      if ($6 != null) {
        parseS(state);
        $5 = (null,);
      }
      if ($5 == null) {
        state.position = $7;
      }
      state.predicate = $predicate;
      final $2 = $5 == null ? (null,) : state.failAndBacktrack<void>($4);
      if ($2 != null) {
        late Expression $$;
        $$ = NonterminalExpression(name: i);
        (Expression,)? $3 = ($$,);
        Expression $ = $3.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $8;
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
    final $8 = state.position;
    (Expression,)? $0;
    (Expression,)? $1 = parseSequence(state);
    if ($1 != null) {
      Expression n = $1.$1;
      final l = [n];
      while (true) {
        final $7 = state.position;
        (void,)? $3;
        (void,)? $5;
        $5 = state.matchLiteral1(('/',), '/', 47);
        if ($5 == null) {
          while (true) {
            final $6 = state.matchLiteral1(('-',), '-', 45);
            if ($6 == null) {
              break;
            }
          }
          $5 = const ([],);
        }
        parseS(state);
        (Expression,)? $4 = parseSequence(state);
        if ($4 != null) {
          Expression n = $4.$1;
          l.add(n);
          $3 = (null,);
        }
        if ($3 == null) {
          state.position = $7;
        }
        if ($3 == null) {
          break;
        }
      }
      late Expression $$;
      $$ = OrderedChoiceExpression(expressions: l);
      (Expression,)? $2 = ($$,);
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
  ///```code
  /// `Expression`
  /// Prefix =
  ///    p = ($ = '!' S / $ = '&' S)? $ = Suffix { }
  ///```
  (Expression,)? parsePrefix(State state) {
    final $5 = state.position;
    (Expression,)? $0;
    (String?,)? $1;
    (String,)? $3 = state.matchLiteral1(('!',), '!', 33);
    if ($3 != null) {
      String $ = $3.$1;
      parseS(state);
      $1 = ($,);
    }
    if ($1 == null) {
      (String,)? $4 = state.matchLiteral1(('&',), '&', 38);
      if ($4 != null) {
        String $ = $4.$1;
        parseS(state);
        $1 = ($,);
      }
    }
    $1 ??= (null,);
    String? p = $1.$1;
    (Expression,)? $2 = parseSuffix(state);
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
    final $2 = state.enter();
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
    state.expected($0, 'expression', $1, false);
    state.leave($2);
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
    final $9 = state.position;
    (ProductionRule,)? $0;
    (String?,)? $1 = parseType(state);
    $1 ??= (null,);
    String? t = $1.$1;
    (String,)? $2 = parseIdentifier(state);
    if ($2 != null) {
      String i = $2.$1;
      (String?,)? $3 = parseProductionRuleArguments(state);
      $3 ??= (null,);
      String? a = $3.$1;
      final $4 = state.matchLiteral2(('=>',), '=>', 61, 62);
      if ($4 != null) {
        parseS(state);
        (Expression,)? $5 = parseExpression(state);
        if ($5 != null) {
          Expression e = $5.$1;
          final $8 = state.position;
          (int,)? $7;
          if (state.position < state.length) {
            final c = state.nextChar16();
            $7 = c == 59 ? (c,) : null;
            $7 ?? (state.position = $8);
          }
          $7 ?? state.fail<int>();
          parseS(state);
          late ProductionRule $$;
          $$ = ProductionRule(
              expression: e, expected: a, name: i, resultType: t ?? '');
          (ProductionRule,)? $6 = ($$,);
          ProductionRule $ = $6.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
      state.position = $9;
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
    final $4 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1(('(',), '(', 40);
    if ($1 != null) {
      parseS(state);
      (String,)? $2 = parseString(state);
      if ($2 != null) {
        String $ = $2.$1;
        final $3 = state.matchLiteral1((')',), ')', 41);
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
  ///```code
  /// `(int, int)`
  /// Range =
  ///     "{" s = HexValue "-" e = HexValue '}' $ = { }
  ///   / "{" n = HexValue '}' $ = { }
  ///   / s = RangeChar "-" e = RangeChar $ = { }
  ///   / n = RangeChar $ = { }
  ///```
  ((int, int),)? parseRange(State state) {
    final $18 = state.enter();
    final $1 = state.position;
    ((int, int),)? $0;
    final $2 = state.match1(('{',), 123);
    if ($2 != null) {
      (int,)? $3 = parseHexValue(state);
      if ($3 != null) {
        int s = $3.$1;
        final $4 = state.match1(('-',), 45);
        if ($4 != null) {
          (int,)? $5 = parseHexValue(state);
          if ($5 != null) {
            int e = $5.$1;
            final $6 = state.matchLiteral1(('}',), '}', 125);
            if ($6 != null) {
              late (int, int) $$;
              $$ = (s, e);
              ((int, int),)? $7 = ($$,);
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
      final $8 = state.match1(('{',), 123);
      if ($8 != null) {
        (int,)? $9 = parseHexValue(state);
        if ($9 != null) {
          int n = $9.$1;
          final $10 = state.matchLiteral1(('}',), '}', 125);
          if ($10 != null) {
            late (int, int) $$;
            $$ = (n, n);
            ((int, int),)? $11 = ($$,);
            (int, int) $ = $11.$1;
            $0 = ($,);
          }
        }
      }
      if ($0 == null) {
        state.position = $1;
      }
      if ($0 == null) {
        (int,)? $12 = parseRangeChar(state);
        if ($12 != null) {
          int s = $12.$1;
          final $13 = state.match1(('-',), 45);
          if ($13 != null) {
            (int,)? $14 = parseRangeChar(state);
            if ($14 != null) {
              int e = $14.$1;
              late (int, int) $$;
              $$ = (s, e);
              ((int, int),)? $15 = ($$,);
              (int, int) $ = $15.$1;
              $0 = ($,);
            }
          }
        }
        if ($0 == null) {
          state.position = $1;
        }
        if ($0 == null) {
          (int,)? $16 = parseRangeChar(state);
          if ($16 != null) {
            int n = $16.$1;
            late (int, int) $$;
            $$ = (n, n);
            ((int, int),)? $17 = ($$,);
            (int, int) $ = $17.$1;
            $0 = ($,);
          }
        }
      }
    }
    state.expected($0, 'range', $1, false);
    state.leave($18);
    return $0;
  }

  /// **RangeChar**
  ///
  ///```code
  /// `int`
  /// RangeChar =
  ///     !"\\" $ = [{0-1f}\{\}\[\]\\]
  ///   / "\\" $ = ("u" '{' $ = HexValue '}' / $ = [\-abefnrtv\{\}\[\]\\] { })
  ///```
  (int,)? parseRangeChar(State state) {
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match1(('\\',), 92);
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $6 = state.position;
      (int,)? $5;
      if (state.position < state.length) {
        final c = state.nextChar16();
        final ok =
            !(c >= 91 ? c <= 93 || c == 123 || c == 125 : c >= 0 && c <= 31);
        $5 = ok ? (c,) : null;
        $5 ?? (state.position = $6);
      }
      (int,)? $2 = $5 ?? state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $7 = state.match1(('\\',), 92);
      if ($7 != null) {
        final $13 = state.position;
        (int,)? $8;
        final $9 = state.match1(('u',), 117);
        if ($9 != null) {
          final $10 = state.matchLiteral1(('{',), '{', 123);
          if ($10 != null) {
            (int,)? $11 = parseHexValue(state);
            if ($11 != null) {
              int $ = $11.$1;
              final $12 = state.matchLiteral1(('}',), '}', 125);
              if ($12 != null) {
                $8 = ($,);
              }
            }
          }
        }
        if ($8 == null) {
          state.position = $13;
        }
        if ($8 == null) {
          (int,)? $15;
          if (state.position < state.length) {
            final c = state.nextChar16();
            final ok = c >= 110
                ? c <= 110 || c >= 118
                    ? c <= 118 || c == 123 || c == 125
                    : c == 114 || c == 116
                : c >= 91
                    ? c <= 93 || (c >= 101 ? c <= 102 : c >= 97 && c <= 98)
                    : c == 45;
            $15 = ok ? (c,) : null;
            $15 ?? (state.position = $13);
          }
          (int,)? $14 = $15 ?? state.fail<int>();
          if ($14 != null) {
            int $ = $14.$1;
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
            $8 = ($,);
          }
        }
        if ($8 != null) {
          int $ = $8.$1;
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
  ///```code
  /// `Expression`
  /// Repeater =
  ///     '@while' S '(' S '*' S ')' S '{' S e = Expression '}' S $ = { }
  ///   / '@while' S '(' S '+' S ')' S '{' S e = Expression '}' S $ = { }
  ///```
  (Expression,)? parseRepeater(State state) {
    final $9 = state.position;
    (Expression,)? $0;
    final $1 = state.matchLiteral(('@while',), '@while');
    if ($1 != null) {
      parseS(state);
      final $2 = state.matchLiteral1(('(',), '(', 40);
      if ($2 != null) {
        parseS(state);
        final $3 = state.matchLiteral1(('*',), '*', 42);
        if ($3 != null) {
          parseS(state);
          final $4 = state.matchLiteral1((')',), ')', 41);
          if ($4 != null) {
            parseS(state);
            final $5 = state.matchLiteral1(('{',), '{', 123);
            if ($5 != null) {
              parseS(state);
              (Expression,)? $6 = parseExpression(state);
              if ($6 != null) {
                Expression e = $6.$1;
                final $7 = state.matchLiteral1(('}',), '}', 125);
                if ($7 != null) {
                  parseS(state);
                  late Expression $$;
                  $$ = ZeroOrMoreExpression(expression: e);
                  (Expression,)? $8 = ($$,);
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
      final $10 = state.matchLiteral(('@while',), '@while');
      if ($10 != null) {
        parseS(state);
        final $11 = state.matchLiteral1(('(',), '(', 40);
        if ($11 != null) {
          parseS(state);
          final $12 = state.matchLiteral1(('+',), '+', 43);
          if ($12 != null) {
            parseS(state);
            final $13 = state.matchLiteral1((')',), ')', 41);
            if ($13 != null) {
              parseS(state);
              final $14 = state.matchLiteral1(('{',), '{', 123);
              if ($14 != null) {
                parseS(state);
                (Expression,)? $15 = parseExpression(state);
                if ($15 != null) {
                  Expression e = $15.$1;
                  final $16 = state.matchLiteral1(('}',), '}', 125);
                  if ($16 != null) {
                    parseS(state);
                    late Expression $$;
                    $$ = OneOrMoreExpression(expression: e);
                    (Expression,)? $17 = ($$,);
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
  ///```code
  /// `String`
  /// RuleName =
  ///    $ = <[A-Z] [a-zA-Z0-9_]*> S
  ///```
  (String,)? parseRuleName(State state) {
    final $6 = state.enter();
    final $1 = state.position;
    (String,)? $0;
    (void,)? $3;
    (int,)? $5;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 65 && c <= 90;
      $5 = ok ? (c,) : null;
      $5 ?? (state.position = $1);
    }
    final $4 = $5 ?? state.fail<int>();
    if ($4 != null) {
      while (state.position < state.length) {
        final position = state.position;
        final c = state.nextChar16();
        final ok = c >= 65
            ? c <= 90 || c == 95 || c >= 97 && c <= 122
            : c >= 48 && c <= 57;
        if (!ok) {
          state.position = position;
          break;
        }
      }
      $3 = (null,);
    }
    (String,)? $2 = $3 != null ? (state.substring($1, state.position),) : null;
    if ($2 != null) {
      String $ = $2.$1;
      parseS(state);
      $0 = ($,);
    }
    state.expected($0, 'production rule name', $1, false);
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
  ///```code
  /// `int`
  /// SQChar =
  ///     !"\\" $ = [ -&(-\[{5d-10ffff}]
  ///   / "\\" $ = (EscapedValue / EscapedHexValue)
  ///```
  (int,)? parseSQChar(State state) {
    final $3 = state.position;
    (int,)? $0;
    final $predicate = state.predicate;
    state.predicate = true;
    final $4 = state.match1(('\\',), 92);
    state.predicate = $predicate;
    final $1 = $4 == null ? (null,) : state.failAndBacktrack<void>($3);
    if ($1 != null) {
      final $6 = state.position;
      (int,)? $5;
      if (state.position < state.length) {
        final c = state.nextChar32();
        final ok =
            c >= 40 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 38;
        $5 = ok ? (c,) : null;
        $5 ?? (state.position = $6);
      }
      (int,)? $2 = $5 ?? state.fail<int>();
      if ($2 != null) {
        int $ = $2.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      final $7 = state.match1(('\\',), 92);
      if ($7 != null) {
        (int,)? $8;
        $8 = parseEscapedValue(state);
        $8 ??= parseEscapedHexValue(state);
        if ($8 != null) {
          int $ = $8.$1;
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
  ///```code
  /// `String`
  /// SQString =
  ///    '\'' n = !['] $ = SQChar* '\'' S $ = { }
  ///```
  (String,)? parseSQString(State state) {
    final $11 = state.position;
    (String,)? $0;
    final $1 = state.matchLiteral1(('\'',), '\'', 39);
    if ($1 != null) {
      final $list = <int>[];
      while (true) {
        final $8 = state.position;
        (int,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        (int,)? $10;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $10 = c == 39 ? (c,) : null;
          $10 ?? (state.position = $8);
        }
        final $9 = $10 ?? state.fail<int>();
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          (int,)? $7 = parseSQChar(state);
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
      (List<int>,)? $2 = ($list,);
      List<int> n = $2.$1;
      final $3 = state.matchLiteral1(('\'',), '\'', 39);
      if ($3 != null) {
        parseS(state);
        late String $$;
        $$ = String.fromCharCodes(n);
        (String,)? $4 = ($$,);
        String $ = $4.$1;
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $11;
    }
    return $0;
  }

  /// **Sequence**
  ///
  ///```code
  /// `Expression`
  /// Sequence =
  ///    n = Typing+ b = ('~' S $ = Block)? $ = { }
  ///```
  (Expression,)? parseSequence(State state) {
    final $8 = state.position;
    (Expression,)? $0;
    final $list = <Expression>[];
    while (true) {
      final $4 = parseTyping(state);
      if ($4 == null) {
        break;
      }
      $list.add($4.$1);
    }
    (List<Expression>,)? $1 = $list.isNotEmpty ? ($list,) : null;
    if ($1 != null) {
      List<Expression> n = $1.$1;
      final $7 = state.position;
      (String?,)? $2;
      final $5 = state.matchLiteral1(('~',), '~', 126);
      if ($5 != null) {
        parseS(state);
        (String,)? $6 = parseBlock(state);
        if ($6 != null) {
          String $ = $6.$1;
          $2 = ($,);
        }
      }
      if ($2 == null) {
        state.position = $7;
      }
      $2 ??= (null,);
      String? b = $2.$1;
      late Expression $$;
      final e = SequenceExpression(expressions: n);
      $$ = b == null ? e : CatchExpression(expression: e, catchBlock: b);
      (Expression,)? $3 = ($$,);
      Expression $ = $3.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $8;
    }
    return $0;
  }

  /// **Space**
  ///
  ///```code
  /// `void`
  /// Space =
  ///     [ {9}]
  ///   / EndOfLine
  ///```
  (void,)? parseSpace(State state) {
    final $2 = state.position;
    (void,)? $0;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c == 9 || c == 32;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    $0 = $1 ?? state.fail<int>();
    $0 ??= parseEndOfLine(state);
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
    (List<ProductionRule>,)? $3 = $list.isNotEmpty ? ($list,) : null;
    if ($3 != null) {
      List<ProductionRule> r = $3.$1;
      final $4 = state.matchEof();
      if ($4 != null) {
        late Grammar $$;
        $$ = Grammar(globals: g, members: m, rules: r);
        (Grammar,)? $5 = ($$,);
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
  ///```code
  /// `String`
  /// String =
  ///     DQString
  ///   / SQString
  ///```
  (String,)? parseString(State state) {
    final $2 = state.enter();
    final $1 = state.position;
    (String,)? $0;
    $0 = parseDQString(state);
    $0 ??= parseSQString(state);
    state.expected($0, 'string', $1, false);
    state.leave($2);
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
    (Expression,)? $0;
    (Expression,)? $1 = parsePrimary(state);
    if ($1 != null) {
      Expression $ = $1.$1;
      final $4 = state.position;
      (void,)? $2;
      final $3 = state.matchLiteral1(('*',), '*', 42);
      if ($3 != null) {
        parseS(state);
        $ = ZeroOrMoreExpression(expression: $);
        $2 = (null,);
      }
      if ($2 == null) {
        state.position = $4;
      }
      if ($2 == null) {
        final $5 = state.matchLiteral1(('+',), '+', 43);
        if ($5 != null) {
          parseS(state);
          $ = OneOrMoreExpression(expression: $);
          $2 = (null,);
        }
        if ($2 == null) {
          state.position = $4;
        }
        if ($2 == null) {
          final $6 = state.matchLiteral1(('?',), '?', 63);
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
  ///```code
  /// `String`
  /// Type =
  ///    '`' $ = <![`] [a-zA-Z0-9_$<(\{,:\})>? ]*> '`' S
  ///```
  (String,)? parseType(State state) {
    final $14 = state.enter();
    final $1 = state.position;
    (String,)? $0;
    final $2 = state.matchLiteral1(('`',), '`', 96);
    if ($2 != null) {
      final $13 = state.position;
      while (true) {
        final $8 = state.position;
        (void,)? $5;
        final $predicate = state.predicate;
        state.predicate = true;
        (int,)? $10;
        if (state.position < state.length) {
          final c = state.nextChar16();
          $10 = c == 96 ? (c,) : null;
          $10 ?? (state.position = $8);
        }
        final $9 = $10 ?? state.fail<int>();
        state.predicate = $predicate;
        final $6 = $9 == null ? (null,) : state.failAndBacktrack<void>($8);
        if ($6 != null) {
          final $12 = state.position;
          (int,)? $11;
          if (state.position < state.length) {
            final c = state.nextChar16();
            final ok = c >= 60
                ? c <= 60 || c >= 95
                    ? c <= 95 || (c >= 125 ? c <= 125 : c >= 97 && c <= 123)
                    : c >= 65
                        ? c <= 90
                        : c >= 62 && c <= 63
                : c >= 40
                    ? c <= 41 || c == 44 || c >= 48 && c <= 58
                    : c == 32 || c == 36;
            $11 = ok ? (c,) : null;
            $11 ?? (state.position = $12);
          }
          final $7 = $11 ?? state.fail<int>();
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
      (String,)? $3 = (state.substring($13, state.position),);
      String $ = $3.$1;
      final $4 = state.matchLiteral1(('`',), '`', 96);
      if ($4 != null) {
        parseS(state);
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $1;
    }
    state.expected($0, 'type', $1, false);
    state.leave($14);
    return $0;
  }

  /// **Typing**
  ///
  ///```code
  /// `Expression`
  /// Typing =
  ///    t = Type? e = Assignment $ = { }
  ///```
  (Expression,)? parseTyping(State state) {
    final $4 = state.position;
    (Expression,)? $0;
    (String?,)? $1 = parseType(state);
    $1 ??= (null,);
    String? t = $1.$1;
    (Expression,)? $2 = parseAssignment(state);
    if ($2 != null) {
      Expression e = $2.$1;
      late Expression $$;
      $$ = t == null ? e : TypingExpression(expression: e, type: t);
      (Expression,)? $3 = ($$,);
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

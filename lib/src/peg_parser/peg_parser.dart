// ignore_for_file: prefer_final_locals

import 'package:source_span/source_span.dart';

import '../expressions/expressions.dart';
import '../grammar/grammar.dart';
import '../grammar/production_rule.dart';

Grammar parse(String source) {
  final state = State(source);
  final parser = PegParser();
  final result = parser.parseStart(state);
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }
  return result as Grammar;
}

class PegParser {
  /// **Action**
  ///
  ///```code
  /// `Expression`
  /// Action =
  ///    b = Block $ = { }
  ///```
  Expression? parseAction(State state) {
    Expression? $0;
    final $pos = state.position;
    final $1 = parseBlock(state);
    if (state.isSuccess) {
      String b = $1!;
      late Expression $$;
      Expression? $2;
      state.isSuccess = true;
      $$ = ActionExpression(code: b);
      $2 = $$;
      if (state.isSuccess) {
        Expression $ = $2;
        $0 = $;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    return $0;
  }

  /// **AnyCharacter**
  ///
  ///```code
  /// `Expression`
  /// AnyCharacter =
  ///    '.' S n = { }
  ///```
  Expression? parseAnyCharacter(State state) {
    Expression? $0;
    final $pos = state.position;
    state.match1('.', 46);
    if (state.isSuccess) {
      parseS(state);
      if (state.isSuccess) {
        late Expression $$;
        Expression? $1;
        state.isSuccess = true;
        $$ = AnyCharacterExpression();
        $1 = $$;
        if (state.isSuccess) {
          Expression n = $1;
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Assignment**
  ///
  ///```code
  /// `Expression`
  /// Assignment =
  ///     i = (Identifier / n = '\$' S) ('=' S / ':' S) e = Prefix $ = { }
  ///   / Prefix
  ///```
  Expression? parseAssignment(State state) {
    Expression? $0;
    final $pos = state.position;
    String? $1;
    $1 = parseIdentifier(state);
    if (!state.isSuccess) {
      final $2 = state.match1('\$', 36);
      if (state.isSuccess) {
        String n = $2!;
        parseS(state);
        $1 = n;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
    }
    if (state.isSuccess) {
      String i = $1!;
      final $pos1 = state.position;
      state.match1('=', 61);
      if (state.isSuccess) {
        parseS(state);
      }
      if (!state.isSuccess) {
        state.position = $pos1;
      }
      if (!state.isSuccess) {
        final $pos2 = state.position;
        state.match1(':', 58);
        if (state.isSuccess) {
          parseS(state);
        }
        if (!state.isSuccess) {
          state.position = $pos2;
        }
      }
      if (state.isSuccess) {
        final $3 = parsePrefix(state);
        if (state.isSuccess) {
          Expression e = $3!;
          late Expression $$;
          Expression? $4;
          state.isSuccess = true;
          $$ = e..semanticVariable = i;
          $4 = $$;
          if (state.isSuccess) {
            Expression $ = $4;
            $0 = $;
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      $0 = parsePrefix(state);
    }
    return $0;
  }

  /// **Block**
  ///
  ///```code
  /// `String`
  /// Block =
  ///    '{' n = <BlockBody*> '}' S
  ///```
  String? parseBlock(State state) {
    String? $0;
    final $pos1 = state.position;
    state.match1('{', 123);
    if (state.isSuccess) {
      final $pos = state.position;
      String? $1;
      while (true) {
        parseBlockBody(state);
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
      if (state.isSuccess) {
        String n = $1!;
        state.match1('}', 125);
        if (state.isSuccess) {
          parseS(state);
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
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
  void parseBlockBody(State state) {
    final $pos = state.position;
    state.match1('{', 123, true);
    if (state.isSuccess) {
      while (true) {
        parseBlockBody(state);
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      if (state.isSuccess) {
        state.match1('}', 125);
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      final $0 = state.notPredicate;
      state.notPredicate = true;
      state.match1('}', 125, true);
      state.notPredicate = $0;
      if (!(state.isSuccess = !state.isSuccess)) {
        state.fail(state.position - $pos);
        state.position = $pos;
      }
      if (state.isSuccess) {
        state.matchAny();
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
    }
  }

  /// **CharacterClass**
  ///
  ///```code
  /// `Expression`
  /// CharacterClass =
  ///    { } ('[^' { } / '[') r = !"]" n = Range+ ']' S $ = { }
  ///```
  Expression? parseCharacterClass(State state) {
    Expression? $0;
    final $pos2 = state.position;
    state.isSuccess = true;
    var negate = false;
    if (state.isSuccess) {
      final $pos = state.position;
      state.match2('[^', 91, 94);
      if (state.isSuccess) {
        state.isSuccess = true;
        negate = true;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      if (!state.isSuccess) {
        state.match1('[', 91);
      }
      if (state.isSuccess) {
        List<(int, int)>? $1;
        final $list = <(int, int)>[];
        while (true) {
          final $pos1 = state.position;
          (int, int)? $2;
          final $3 = state.notPredicate;
          state.notPredicate = true;
          state.match1(']', 93, true);
          state.notPredicate = $3;
          if (!(state.isSuccess = !state.isSuccess)) {
            state.fail(state.position - $pos1);
            state.position = $pos1;
          }
          if (state.isSuccess) {
            final $4 = parseRange(state);
            if (state.isSuccess) {
              (int, int) n = $4!;
              $2 = n;
            }
          }
          if (!state.isSuccess) {
            state.position = $pos1;
          }
          if (!state.isSuccess) {
            break;
          }
          $list.add($2!);
        }
        if (state.isSuccess = $list.isNotEmpty) {
          $1 = $list;
        }
        if (state.isSuccess) {
          List<(int, int)> r = $1!;
          state.match1(']', 93);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              late Expression $$;
              Expression? $5;
              state.isSuccess = true;
              $$ = CharacterClassExpression(ranges: r, negate: negate);
              $5 = $$;
              if (state.isSuccess) {
                Expression $ = $5;
                $0 = $;
              }
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
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
  void parseComment(State state) {
    final $pos1 = state.position;
    state.match1('#', 35, true);
    if (state.isSuccess) {
      while (true) {
        final $pos = state.position;
        final $0 = state.notPredicate;
        state.notPredicate = true;
        parseEndOfLine(state);
        state.notPredicate = $0;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          state.matchAny();
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      if (state.isSuccess) {
        parseEndOfLine(state);
        state.isSuccess = true;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
  }

  /// **DQChar**
  ///
  ///```code
  /// `int`
  /// DQChar =
  ///     !"\\" n = [ -!#-\[{5d-10ffff}]
  ///   / "\\" n = (EscapedValue / EscapedHexValue)
  ///```
  int? parseDQChar(State state) {
    int? $0;
    final $pos = state.position;
    final $1 = state.notPredicate;
    state.notPredicate = true;
    state.match1('\\', 92, true);
    state.notPredicate = $1;
    if (!(state.isSuccess = !state.isSuccess)) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    if (state.isSuccess) {
      final $2 = state.matchChars32((int c) =>
          c >= 35 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 33);
      if (state.isSuccess) {
        int n = $2!;
        $0 = n;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      state.match1('\\', 92, true);
      if (state.isSuccess) {
        int? $3;
        $3 = parseEscapedValue(state);
        if (!state.isSuccess) {
          $3 = parseEscapedHexValue(state);
        }
        if (state.isSuccess) {
          int n = $3!;
          $0 = n;
        }
      }
      if (!state.isSuccess) {
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
  ///    '"' n = !["] n = DQChar* '"' S $ = { }
  ///```
  String? parseDQString(State state) {
    String? $0;
    final $pos1 = state.position;
    state.match1('"', 34);
    if (state.isSuccess) {
      List<int>? $1;
      final $list = <int>[];
      while (true) {
        final $pos = state.position;
        int? $2;
        final $3 = state.notPredicate;
        state.notPredicate = true;
        // '"'
        state.matchChar16(34);
        state.notPredicate = $3;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          final $4 = parseDQChar(state);
          if (state.isSuccess) {
            int n = $4!;
            $2 = n;
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
        $list.add($2!);
      }
      $1 = (state.isSuccess = true) ? $list : null;
      if (state.isSuccess) {
        List<int> n = $1!;
        state.match1('"', 34);
        if (state.isSuccess) {
          parseS(state);
          if (state.isSuccess) {
            late String $$;
            String? $5;
            state.isSuccess = true;
            $$ = String.fromCharCodes(n);
            $5 = $$;
            if (state.isSuccess) {
              String $ = $5;
              $0 = $;
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
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
  void parseEndOfLine(State state) {
    state.match2('\r\n', 13, 10, true);
    if (!state.isSuccess) {
      state.matchChars16((int c) => c == 10 || c == 13);
    }
  }

  /// **EscapedHexValue**
  ///
  ///```code
  /// `int`
  /// EscapedHexValue =
  ///    "u" '{' n = HexValue '}' ~ { }
  ///```
  int? parseEscapedHexValue(State state) {
    int? $0;
    final $pos = state.position;
    final $failure = state.enter();
    state.match1('u', 117, true);
    if (state.isSuccess) {
      state.match1('{', 123);
      if (state.isSuccess) {
        final $1 = parseHexValue(state);
        if (state.isSuccess) {
          int n = $1!;
          state.match1('}', 125);
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
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
  ///    n = [abefnrtv'"\\] { } ~ { }
  ///```
  int? parseEscapedValue(State state) {
    int? $0;
    final $pos = state.position;
    final $failure = state.enter();
    final $1 = state.matchChars16((int c) => c >= 101
        ? c <= 102 || c >= 114
            ? c <= 114 || c == 116 || c == 118
            : c == 110
        : c >= 39
            ? c <= 39 || c == 92 || c >= 97 && c <= 98
            : c == 34);
    if (state.isSuccess) {
      int n = $1!;
      state.isSuccess = true;
      n = switch (n) {
        97 => 0x07, // a
        98 => 0x08, // b
        101 => 0x1B, // e
        102 => 0x0C, // f
        110 => 0x0A, // n
        114 => 0x0D, // r
        116 => 0x09, // t
        118 => 0x0B, // v
        _ => n,
      };
      $0 = n;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
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
  Expression? parseExpression(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    Expression? $0;
    $0 = parseOrderedChoice(state);
    state.expected('expression', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **Globals**
  ///
  ///```code
  /// `String`
  /// Globals =
  ///    '%{' n = <!"}%" .*> '}%' S
  ///```
  String? parseGlobals(State state) {
    String? $0;
    final $pos2 = state.position;
    state.match2('%{', 37, 123);
    if (state.isSuccess) {
      final $pos1 = state.position;
      String? $1;
      while (true) {
        final $pos = state.position;
        final $2 = state.notPredicate;
        state.notPredicate = true;
        state.match2('}%', 125, 37, true);
        state.notPredicate = $2;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          state.matchAny();
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      $1 =
          state.isSuccess ? state.input.substring($pos1, state.position) : null;
      if (state.isSuccess) {
        String n = $1!;
        state.match2('}%', 125, 37);
        if (state.isSuccess) {
          parseS(state);
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos2;
    }
    return $0;
  }

  /// **Group**
  ///
  ///```code
  /// `Expression`
  /// Group =
  ///    '(' S n = Expression ')' S { }
  ///```
  Expression? parseGroup(State state) {
    Expression? $0;
    final $pos = state.position;
    state.match1('(', 40);
    if (state.isSuccess) {
      parseS(state);
      if (state.isSuccess) {
        final $1 = parseExpression(state);
        if (state.isSuccess) {
          Expression n = $1!;
          state.match1(')', 41);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              state.isSuccess = true;
              n.isGrouped = true;
              $0 = n;
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
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
  int? parseHexValue(State state) {
    final $3 = state.enter();
    int? $0;
    final $pos = state.position;
    String? $1;
    state.skip16While1((int c) =>
        c >= 65 ? c <= 70 || c >= 97 && c <= 102 : c >= 48 && c <= 57);
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String n = $1!;
      late int $$;
      int? $2;
      state.isSuccess = true;
      $$ = int.parse(n, radix: 16);
      $2 = $$;
      if (state.isSuccess) {
        int $ = $2;
        $0 = $;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    state.expected('hex number', $pos, false);
    state.leave($3);
    return $0;
  }

  /// **Identifier** ('identifier')
  ///
  ///```code
  /// `String`
  /// Identifier =
  ///    n = <[a-zA-Z] [a-zA-Z0-9_]*> S
  ///```
  String? parseIdentifier(State state) {
    final $2 = state.enter();
    String? $0;
    final $pos = state.position;
    String? $1;
    state.matchChars16((int c) => c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if (state.isSuccess) {
      state.skip16While((int c) => c >= 65
          ? c <= 90 || c == 95 || c >= 97 && c <= 122
          : c >= 48 && c <= 57);
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String n = $1!;
      parseS(state);
      $0 = n;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    state.expected('identifier', $pos, false);
    state.leave($2);
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
  Expression? parseLiteral(State state) {
    Expression? $0;
    final $pos = state.position;
    final $1 = parseSQString(state);
    if (state.isSuccess) {
      String s = $1!;
      late Expression $$;
      Expression? $2;
      state.isSuccess = true;
      $$ = LiteralExpression(literal: s);
      $2 = $$;
      if (state.isSuccess) {
        Expression $ = $2;
        $0 = $;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      final $3 = parseDQString(state);
      if (state.isSuccess) {
        String s = $3!;
        late Expression $$;
        Expression? $4;
        state.isSuccess = true;
        $$ = LiteralExpression(literal: s, silent: true);
        $4 = $$;
        if (state.isSuccess) {
          Expression $ = $4;
          $0 = $;
        }
      }
      if (!state.isSuccess) {
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
  Expression? parseMatch(State state) {
    Expression? $0;
    final $pos = state.position;
    state.match1('<', 60);
    if (state.isSuccess) {
      parseS(state);
      if (state.isSuccess) {
        final $1 = parseExpression(state);
        if (state.isSuccess) {
          Expression e = $1!;
          state.match1('>', 62);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              late Expression $$;
              Expression? $2;
              state.isSuccess = true;
              $$ = MatchExpression(expression: e);
              $2 = $$;
              if (state.isSuccess) {
                Expression $ = $2;
                $0 = $;
              }
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    return $0;
  }

  /// **Members**
  ///
  ///```code
  /// `String`
  /// Members =
  ///    '%%' n = <!"%%" .*> '%%' S
  ///```
  String? parseMembers(State state) {
    String? $0;
    final $pos2 = state.position;
    state.match2('%%', 37, 37);
    if (state.isSuccess) {
      final $pos1 = state.position;
      String? $1;
      while (true) {
        final $pos = state.position;
        final $2 = state.notPredicate;
        state.notPredicate = true;
        state.match2('%%', 37, 37, true);
        state.notPredicate = $2;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          state.matchAny();
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      $1 =
          state.isSuccess ? state.input.substring($pos1, state.position) : null;
      if (state.isSuccess) {
        String n = $1!;
        state.match2('%%', 37, 37);
        if (state.isSuccess) {
          parseS(state);
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
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
  Expression? parseNonterminal(State state) {
    Expression? $0;
    final $pos2 = state.position;
    final $1 = parseRuleName(state);
    if (state.isSuccess) {
      String i = $1!;
      final $pos1 = state.position;
      final $2 = state.notPredicate;
      state.notPredicate = true;
      final $pos = state.position;
      parseProductionRuleArguments(state);
      state.isSuccess = true;
      if (state.isSuccess) {
        state.match2('=>', 61, 62);
        if (state.isSuccess) {
          parseS(state);
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      state.notPredicate = $2;
      if (!(state.isSuccess = !state.isSuccess)) {
        state.fail(state.position - $pos1);
        state.position = $pos1;
      }
      if (state.isSuccess) {
        late Expression $$;
        Expression? $3;
        state.isSuccess = true;
        $$ = NonterminalExpression(name: i);
        $3 = $$;
        if (state.isSuccess) {
          Expression $ = $3;
          $0 = $;
        }
      }
    }
    if (!state.isSuccess) {
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
  Expression? parseOrderedChoice(State state) {
    Expression? $0;
    final $pos1 = state.position;
    final $1 = parseSequence(state);
    if (state.isSuccess) {
      Expression n = $1!;
      state.isSuccess = true;
      final l = [n];
      if (state.isSuccess) {
        while (true) {
          final $pos = state.position;
          state.match1('/', 47);
          if (!state.isSuccess) {
            while (true) {
              state.match1('-', 45);
              if (!state.isSuccess) {
                break;
              }
            }
            state.isSuccess = true;
          }
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              final $2 = parseSequence(state);
              if (state.isSuccess) {
                Expression n = $2!;
                state.isSuccess = true;
                l.add(n);
              }
            }
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
          if (!state.isSuccess) {
            break;
          }
        }
        state.isSuccess = true;
        if (state.isSuccess) {
          late Expression $$;
          Expression? $3;
          state.isSuccess = true;
          $$ = OrderedChoiceExpression(expressions: l);
          $3 = $$;
          if (state.isSuccess) {
            Expression $ = $3;
            $0 = $;
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Prefix**
  ///
  ///```code
  /// `Expression`
  /// Prefix =
  ///    p = (n = '!' S / n = '&' S)? $ = Suffix { }
  ///```
  Expression? parsePrefix(State state) {
    Expression? $0;
    final $pos = state.position;
    String? $1;
    final $2 = state.match1('!', 33);
    if (state.isSuccess) {
      String n = $2!;
      parseS(state);
      $1 = n;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      final $3 = state.match1('&', 38);
      if (state.isSuccess) {
        String n = $3!;
        parseS(state);
        $1 = n;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
    }
    state.isSuccess = true;
    if (state.isSuccess) {
      String? p = $1;
      final $4 = parseSuffix(state);
      if (state.isSuccess) {
        Expression $ = $4!;
        state.isSuccess = true;
        switch (p) {
          case '!':
            $ = NotPredicateExpression(expression: $);
            break;
          case '&':
            $ = AndPredicateExpression(expression: $);
            break;
        }
        $0 = $;
      }
    }
    if (!state.isSuccess) {
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
  Expression? parsePrimary(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    Expression? $0;
    $0 = parseCharacterClass(state);
    if (!state.isSuccess) {
      $0 = parseLiteral(state);
      if (!state.isSuccess) {
        $0 = parseGroup(state);
        if (!state.isSuccess) {
          $0 = parseRepeater(state);
          if (!state.isSuccess) {
            $0 = parseNonterminal(state);
            if (!state.isSuccess) {
              $0 = parseAction(state);
              if (!state.isSuccess) {
                $0 = parseAnyCharacter(state);
                if (!state.isSuccess) {
                  $0 = parseMatch(state);
                }
              }
            }
          }
        }
      }
    }
    state.expected('expression', $pos, false);
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
  ProductionRule? parseProductionRule(State state) {
    ProductionRule? $0;
    final $pos = state.position;
    String? $1;
    $1 = parseType(state);
    state.isSuccess = true;
    if (state.isSuccess) {
      String? t = $1;
      final $2 = parseIdentifier(state);
      if (state.isSuccess) {
        String i = $2!;
        String? $3;
        $3 = parseProductionRuleArguments(state);
        state.isSuccess = true;
        if (state.isSuccess) {
          String? a = $3;
          state.match2('=>', 61, 62);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              final $4 = parseExpression(state);
              if (state.isSuccess) {
                Expression e = $4!;
                // ';'
                state.matchChar16(59);
                state.isSuccess = true;
                if (state.isSuccess) {
                  parseS(state);
                  if (state.isSuccess) {
                    late ProductionRule $$;
                    ProductionRule? $5;
                    state.isSuccess = true;
                    $$ = ProductionRule(
                        expression: e,
                        expected: a,
                        name: i,
                        resultType: t ?? '');
                    $5 = $$;
                    if (state.isSuccess) {
                      ProductionRule $ = $5;
                      $0 = $;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    return $0;
  }

  /// **ProductionRuleArguments**
  ///
  ///```code
  /// `String`
  /// ProductionRuleArguments =
  ///    '(' S n = String ')' S
  ///```
  String? parseProductionRuleArguments(State state) {
    String? $0;
    final $pos = state.position;
    state.match1('(', 40);
    if (state.isSuccess) {
      parseS(state);
      if (state.isSuccess) {
        final $1 = parseString(state);
        if (state.isSuccess) {
          String n = $1!;
          state.match1(')', 41);
          if (state.isSuccess) {
            parseS(state);
            $0 = n;
          }
        }
      }
    }
    if (!state.isSuccess) {
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
  (int, int)? parseRange(State state) {
    final $11 = state.enter();
    (int, int)? $0;
    final $pos = state.position;
    state.match1('{', 123, true);
    if (state.isSuccess) {
      final $1 = parseHexValue(state);
      if (state.isSuccess) {
        int s = $1!;
        state.match1('-', 45, true);
        if (state.isSuccess) {
          final $2 = parseHexValue(state);
          if (state.isSuccess) {
            int e = $2!;
            state.match1('}', 125);
            if (state.isSuccess) {
              late (int, int) $$;
              (int, int)? $3;
              state.isSuccess = true;
              $$ = (s, e);
              $3 = $$;
              if (state.isSuccess) {
                (int, int) $ = $3;
                $0 = $;
              }
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      state.match1('{', 123, true);
      if (state.isSuccess) {
        final $4 = parseHexValue(state);
        if (state.isSuccess) {
          int n = $4!;
          state.match1('}', 125);
          if (state.isSuccess) {
            late (int, int) $$;
            (int, int)? $5;
            state.isSuccess = true;
            $$ = (n, n);
            $5 = $$;
            if (state.isSuccess) {
              (int, int) $ = $5;
              $0 = $;
            }
          }
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      if (!state.isSuccess) {
        final $6 = parseRangeChar(state);
        if (state.isSuccess) {
          int s = $6!;
          state.match1('-', 45, true);
          if (state.isSuccess) {
            final $7 = parseRangeChar(state);
            if (state.isSuccess) {
              int e = $7!;
              late (int, int) $$;
              (int, int)? $8;
              state.isSuccess = true;
              $$ = (s, e);
              $8 = $$;
              if (state.isSuccess) {
                (int, int) $ = $8;
                $0 = $;
              }
            }
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          final $9 = parseRangeChar(state);
          if (state.isSuccess) {
            int n = $9!;
            late (int, int) $$;
            (int, int)? $10;
            state.isSuccess = true;
            $$ = (n, n);
            $10 = $$;
            if (state.isSuccess) {
              (int, int) $ = $10;
              $0 = $;
            }
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
        }
      }
    }
    state.expected('range', $pos, false);
    state.leave($11);
    return $0;
  }

  /// **RangeChar**
  ///
  ///```code
  /// `int`
  /// RangeChar =
  ///     !"\\" n = [ -Z{5e-10ffff}]
  ///   / "\\" n = ("u" '{' n = HexValue '}' / n = [\-abefnrtv\[\]\\] { })
  ///```
  int? parseRangeChar(State state) {
    int? $0;
    final $pos = state.position;
    final $1 = state.notPredicate;
    state.notPredicate = true;
    state.match1('\\', 92, true);
    state.notPredicate = $1;
    if (!(state.isSuccess = !state.isSuccess)) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    if (state.isSuccess) {
      final $2 = state.matchChars32(
          (int c) => c >= 32 && c <= 90 || c >= 94 && c <= 1114111);
      if (state.isSuccess) {
        int n = $2!;
        $0 = n;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      state.match1('\\', 92, true);
      if (state.isSuccess) {
        int? $3;
        final $pos1 = state.position;
        state.match1('u', 117, true);
        if (state.isSuccess) {
          state.match1('{', 123);
          if (state.isSuccess) {
            final $4 = parseHexValue(state);
            if (state.isSuccess) {
              int n = $4!;
              state.match1('}', 125);
              $3 = n;
            }
          }
        }
        if (!state.isSuccess) {
          state.position = $pos1;
        }
        if (!state.isSuccess) {
          final $pos2 = state.position;
          final $5 = state.matchChars16((int c) => c >= 101
              ? c <= 102 || c >= 114
                  ? c <= 114 || c == 116 || c == 118
                  : c == 110
              : c >= 91
                  ? c <= 93 || c >= 97 && c <= 98
                  : c == 45);
          if (state.isSuccess) {
            int n = $5!;
            state.isSuccess = true;
            n = switch (n) {
              97 => 0x07, // a
              98 => 0x08, // b
              101 => 0x1B, // e
              102 => 0x0C, // f
              110 => 0x0A, // n
              114 => 0x0D, // r
              116 => 0x09, // t
              118 => 0x0B, // v
              _ => n,
            };
            $3 = n;
          }
          if (!state.isSuccess) {
            state.position = $pos2;
          }
        }
        if (state.isSuccess) {
          int n = $3!;
          $0 = n;
        }
      }
      if (!state.isSuccess) {
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
  Expression? parseRepeater(State state) {
    Expression? $0;
    final $pos = state.position;
    state.match('@while');
    if (state.isSuccess) {
      parseS(state);
      if (state.isSuccess) {
        state.match1('(', 40);
        if (state.isSuccess) {
          parseS(state);
          if (state.isSuccess) {
            state.match1('*', 42);
            if (state.isSuccess) {
              parseS(state);
              if (state.isSuccess) {
                state.match1(')', 41);
                if (state.isSuccess) {
                  parseS(state);
                  if (state.isSuccess) {
                    state.match1('{', 123);
                    if (state.isSuccess) {
                      parseS(state);
                      if (state.isSuccess) {
                        final $1 = parseExpression(state);
                        if (state.isSuccess) {
                          Expression e = $1!;
                          state.match1('}', 125);
                          if (state.isSuccess) {
                            parseS(state);
                            if (state.isSuccess) {
                              late Expression $$;
                              Expression? $2;
                              state.isSuccess = true;
                              $$ = ZeroOrMoreExpression(expression: e);
                              $2 = $$;
                              if (state.isSuccess) {
                                Expression $ = $2;
                                $0 = $;
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
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      state.match('@while');
      if (state.isSuccess) {
        parseS(state);
        if (state.isSuccess) {
          state.match1('(', 40);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              state.match1('+', 43);
              if (state.isSuccess) {
                parseS(state);
                if (state.isSuccess) {
                  state.match1(')', 41);
                  if (state.isSuccess) {
                    parseS(state);
                    if (state.isSuccess) {
                      state.match1('{', 123);
                      if (state.isSuccess) {
                        parseS(state);
                        if (state.isSuccess) {
                          final $3 = parseExpression(state);
                          if (state.isSuccess) {
                            Expression e = $3!;
                            state.match1('}', 125);
                            if (state.isSuccess) {
                              parseS(state);
                              if (state.isSuccess) {
                                late Expression $$;
                                Expression? $4;
                                state.isSuccess = true;
                                $$ = OneOrMoreExpression(expression: e);
                                $4 = $$;
                                if (state.isSuccess) {
                                  Expression $ = $4;
                                  $0 = $;
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
      if (!state.isSuccess) {
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
  ///    n = <[A-Z] [a-zA-Z0-9_]*> S
  ///```
  String? parseRuleName(State state) {
    final $2 = state.enter();
    String? $0;
    final $pos = state.position;
    String? $1;
    state.matchChars16((int c) => c >= 65 && c <= 90);
    if (state.isSuccess) {
      state.skip16While((int c) => c >= 65
          ? c <= 90 || c == 95 || c >= 97 && c <= 122
          : c >= 48 && c <= 57);
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String n = $1!;
      parseS(state);
      $0 = n;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    state.expected('production rule name', $pos, false);
    state.leave($2);
    return $0;
  }

  /// **S**
  ///
  ///```code
  /// `List<void>`
  /// S =
  ///    Space / Comment*
  ///```
  List<void>? parseS(State state) {
    List<void>? $0;
    final $list = <void>[];
    while (true) {
      void $1;
      $1 = parseSpace(state);
      if (!state.isSuccess) {
        $1 = parseComment(state);
      }
      if (!state.isSuccess) {
        break;
      }
      $list.add($1);
    }
    $0 = (state.isSuccess = true) ? $list : null;
    return $0;
  }

  /// **SQChar**
  ///
  ///```code
  /// `int`
  /// SQChar =
  ///     !"\\" n = [ -&(-\[{5d-10ffff}]
  ///   / "\\" n = (EscapedValue / EscapedHexValue)
  ///```
  int? parseSQChar(State state) {
    int? $0;
    final $pos = state.position;
    final $1 = state.notPredicate;
    state.notPredicate = true;
    state.match1('\\', 92, true);
    state.notPredicate = $1;
    if (!(state.isSuccess = !state.isSuccess)) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    if (state.isSuccess) {
      final $2 = state.matchChars32((int c) =>
          c >= 40 ? c <= 91 || c >= 93 && c <= 1114111 : c >= 32 && c <= 38);
      if (state.isSuccess) {
        int n = $2!;
        $0 = n;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    if (!state.isSuccess) {
      state.match1('\\', 92, true);
      if (state.isSuccess) {
        int? $3;
        $3 = parseEscapedValue(state);
        if (!state.isSuccess) {
          $3 = parseEscapedHexValue(state);
        }
        if (state.isSuccess) {
          int n = $3!;
          $0 = n;
        }
      }
      if (!state.isSuccess) {
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
  ///    '\'' n = !['] n = SQChar* '\'' S $ = { }
  ///```
  String? parseSQString(State state) {
    String? $0;
    final $pos1 = state.position;
    state.match1('\'', 39);
    if (state.isSuccess) {
      List<int>? $1;
      final $list = <int>[];
      while (true) {
        final $pos = state.position;
        int? $2;
        final $3 = state.notPredicate;
        state.notPredicate = true;
        // '''
        state.matchChar16(39);
        state.notPredicate = $3;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          final $4 = parseSQChar(state);
          if (state.isSuccess) {
            int n = $4!;
            $2 = n;
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
        $list.add($2!);
      }
      $1 = (state.isSuccess = true) ? $list : null;
      if (state.isSuccess) {
        List<int> n = $1!;
        state.match1('\'', 39);
        if (state.isSuccess) {
          parseS(state);
          if (state.isSuccess) {
            late String $$;
            String? $5;
            state.isSuccess = true;
            $$ = String.fromCharCodes(n);
            $5 = $$;
            if (state.isSuccess) {
              String $ = $5;
              $0 = $;
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Sequence**
  ///
  ///```code
  /// `Expression`
  /// Sequence =
  ///    n = TypeConversion+ b = ('~' S b = Block)? $ = { }
  ///```
  Expression? parseSequence(State state) {
    Expression? $0;
    final $pos1 = state.position;
    List<Expression>? $1;
    final $list = <Expression>[];
    while (true) {
      final $2 = parseTypeConversion(state);
      if (!state.isSuccess) {
        break;
      }
      $list.add($2!);
    }
    if (state.isSuccess = $list.isNotEmpty) {
      $1 = $list;
    }
    if (state.isSuccess) {
      List<Expression> n = $1!;
      String? $3;
      final $pos = state.position;
      state.match1('~', 126);
      if (state.isSuccess) {
        parseS(state);
        if (state.isSuccess) {
          final $4 = parseBlock(state);
          if (state.isSuccess) {
            String b = $4!;
            $3 = b;
          }
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      state.isSuccess = true;
      if (state.isSuccess) {
        String? b = $3;
        late Expression $$;
        Expression? $5;
        state.isSuccess = true;
        final e = SequenceExpression(expressions: n);
        $$ = b == null ? e : CatchExpression(expression: e, catchBlock: b);
        $5 = $$;
        if (state.isSuccess) {
          Expression $ = $5;
          $0 = $;
        }
      }
    }
    if (!state.isSuccess) {
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
  void parseSpace(State state) {
    state.matchChars16((int c) => c == 9 || c == 32);
    if (!state.isSuccess) {
      parseEndOfLine(state);
    }
  }

  /// **Start**
  ///
  ///```code
  /// `Grammar`
  /// Start =
  ///    S g = Globals? m = Members? r = ProductionRule+ !. $ = { }
  ///```
  Grammar? parseStart(State state) {
    Grammar? $0;
    final $pos1 = state.position;
    parseS(state);
    if (state.isSuccess) {
      String? $1;
      $1 = parseGlobals(state);
      state.isSuccess = true;
      if (state.isSuccess) {
        String? g = $1;
        String? $2;
        $2 = parseMembers(state);
        state.isSuccess = true;
        if (state.isSuccess) {
          String? m = $2;
          List<ProductionRule>? $3;
          final $list = <ProductionRule>[];
          while (true) {
            final $4 = parseProductionRule(state);
            if (!state.isSuccess) {
              break;
            }
            $list.add($4!);
          }
          if (state.isSuccess = $list.isNotEmpty) {
            $3 = $list;
          }
          if (state.isSuccess) {
            List<ProductionRule> r = $3!;
            final $pos = state.position;
            final $5 = state.notPredicate;
            state.notPredicate = true;
            state.matchAny();
            state.notPredicate = $5;
            if (!(state.isSuccess = !state.isSuccess)) {
              state.fail(state.position - $pos);
              state.position = $pos;
            }
            if (state.isSuccess) {
              late Grammar $$;
              Grammar? $6;
              state.isSuccess = true;
              $$ = Grammar(globals: g, members: m, rules: r);
              $6 = $$;
              if (state.isSuccess) {
                Grammar $ = $6;
                $0 = $;
              }
            }
          }
        }
      }
    }
    if (!state.isSuccess) {
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
  String? parseString(State state) {
    final $pos = state.position;
    final $1 = state.enter();
    String? $0;
    $0 = parseDQString(state);
    if (!state.isSuccess) {
      $0 = parseSQString(state);
    }
    state.expected('string', $pos, false);
    state.leave($1);
    return $0;
  }

  /// **Suffix**
  ///
  ///```code
  /// `Expression`
  /// Suffix =
  ///    n = Primary ('*' S { } / '+' S { } / '?' S { })?
  ///```
  Expression? parseSuffix(State state) {
    Expression? $0;
    final $pos1 = state.position;
    final $1 = parsePrimary(state);
    if (state.isSuccess) {
      Expression n = $1!;
      final $pos = state.position;
      state.match1('*', 42);
      if (state.isSuccess) {
        parseS(state);
        if (state.isSuccess) {
          state.isSuccess = true;
          n = ZeroOrMoreExpression(expression: n);
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      if (!state.isSuccess) {
        state.match1('+', 43);
        if (state.isSuccess) {
          parseS(state);
          if (state.isSuccess) {
            state.isSuccess = true;
            n = OneOrMoreExpression(expression: n);
          }
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          state.match1('?', 63);
          if (state.isSuccess) {
            parseS(state);
            if (state.isSuccess) {
              state.isSuccess = true;
              n = OptionalExpression(expression: n);
            }
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
        }
      }
      state.isSuccess = true;
      $0 = n;
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    return $0;
  }

  /// **Type** ('type')
  ///
  ///```code
  /// `String`
  /// Type =
  ///    '`' n = <![`] [a-zA-Z0-9_$<(\{,:\})>? ]*> '`' S
  ///```
  String? parseType(State state) {
    final $3 = state.enter();
    String? $0;
    final $pos2 = state.position;
    state.match1('`', 96);
    if (state.isSuccess) {
      final $pos1 = state.position;
      String? $1;
      while (true) {
        final $pos = state.position;
        final $2 = state.notPredicate;
        state.notPredicate = true;
        // '`'
        state.matchChar16(96);
        state.notPredicate = $2;
        if (!(state.isSuccess = !state.isSuccess)) {
          state.fail(state.position - $pos);
          state.position = $pos;
        }
        if (state.isSuccess) {
          state.matchChars16((int c) => c >= 60
              ? c <= 60 || c >= 95
                  ? c <= 95 || c >= 97 && c <= 123 || c == 125
                  : c >= 62 && c <= 63 || c >= 65 && c <= 90
              : c >= 40
                  ? c <= 41 || c == 44 || c >= 48 && c <= 58
                  : c == 32 || c == 36);
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        if (!state.isSuccess) {
          break;
        }
      }
      state.isSuccess = true;
      $1 =
          state.isSuccess ? state.input.substring($pos1, state.position) : null;
      if (state.isSuccess) {
        String n = $1!;
        state.match1('`', 96);
        if (state.isSuccess) {
          parseS(state);
          $0 = n;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos2;
    }
    state.expected('type', $pos2, false);
    state.leave($3);
    return $0;
  }

  /// **TypeConversion**
  ///
  ///```code
  /// `Expression`
  /// TypeConversion =
  ///    $ = Assignment t = ('as' S n = Type)? { }
  ///```
  Expression? parseTypeConversion(State state) {
    Expression? $0;
    final $pos1 = state.position;
    final $1 = parseAssignment(state);
    if (state.isSuccess) {
      Expression $ = $1!;
      String? $2;
      final $pos = state.position;
      state.match2('as', 97, 115);
      if (state.isSuccess) {
        parseS(state);
        if (state.isSuccess) {
          final $3 = parseType(state);
          if (state.isSuccess) {
            String n = $3!;
            $2 = n;
          }
        }
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      state.isSuccess = true;
      if (state.isSuccess) {
        String? t = $2;
        state.isSuccess = true;
        $.resultType = t ?? '';
        $0 = $;
      }
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match(String string, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess = position < input.length &&
        input.codeUnitAt(position) == string.codeUnitAt(0)) {
      if (isSuccess = input.startsWith(string, position)) {
        position += string.length;
        result = string;
      }
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match1(String string, int char, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess =
        position < input.length && input.codeUnitAt(position) == char) {
      position++;
      result = string;
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match2(String string, int char, int char2, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess = position + 1 < input.length &&
        input.codeUnitAt(position) == char &&
        input.codeUnitAt(position + 1) == char2) {
      position += 2;
      result = string;
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchAny() {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.readChar(position);
    }

    isSuccess ? position += c > 0xffff ? 2 : 1 : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16(int char) {
    isSuccess = position < input.length && input.codeUnitAt(position) == char;
    isSuccess ? position++ : fail();
    return isSuccess ? char : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar32(int char) {
    isSuccess = position + 1 < input.length && input.readChar(position) == char;
    isSuccess ? position += 2 : fail();
    return isSuccess ? char : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChars16(bool Function(int c) f) {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.codeUnitAt(position);
      isSuccess = f(c);
    }
    isSuccess ? position++ : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChars32(bool Function(int c) f) {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.readChar(position);
      isSuccess = f(c);
    }
    isSuccess ? position += c > 0xffff ? 2 : 1 : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip16While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position++;
    }

    isSuccess = true;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip16While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position++;
    }

    (isSuccess = start != position) ? null : fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip32While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.readChar(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    isSuccess = true;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip32While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.readChar(position);
      if (!(isSuccess = f(c))) {
        break;
      }
      position += c > 0xffff ? 2 : 1;
    }

    (isSuccess = start != position) ? null : fail();
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

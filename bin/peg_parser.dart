import 'package:peg/src/expressions/expressions.dart';
import 'package:peg/src/grammar/grammar.dart';

export 'package:peg/src/grammar/grammar.dart';

class PegParser {
  Expression _buildPrefix(String? prefix, Expression expression) {
    if (prefix == null) {
      return expression;
    }

    switch (prefix) {
      case '&':
        return AndPredicateExpression(expression: expression);
      case '!':
        return NotPredicateExpression(expression: expression);
      case '\$':
        return SliceExpression(expression: expression);
      default:
        throw StateError('Unknown prefix: $prefix');
    }
  }

  Expression _buildSuffix(Object? suffix, Expression expression) {
    if (suffix == null) {
      return expression;
    }

    if (suffix is (int?, int?)) {
      return RepetitionExpression(
          expression: expression, min: suffix.$1, max: suffix.$2);
    }

    switch (suffix) {
      case '+':
        return OneOrMoreExpression(expression: expression);
      case '?':
        return OptionalExpression(expression: expression);
      case '*':
        return ZeroOrMoreExpression(expression: expression);
      default:
        throw StateError('Unknown suffix: $suffix');
    }
  }

  int _escape(int charCode) {
    switch (charCode) {
      case 0x6e:
        return 0xa;
      case 0x72:
        return 0xd;
      case 0x74:
        return 0x9;
      case 0x22:
        return 0x22;
      case 0x27:
        return 0x27;
      case 0x5c:
        return 0x5c;
      case 0x5d:
        return 0x5d;
      case 0x5e:
        return 0x5e;
      default:
        return charCode;
    }
  }

  /// Apostrophe =
  ///   v:'\'' Spaces
  ///   ;
  void fastParseApostrophe(State<String> state) {
    // v:'\'' Spaces
    final $0 = state.pos;
    const $1 = '\'';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 39;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// BlockBody =
  ///     '{' v:BlockBody* '}'
  ///   / !'}' .
  ///   ;
  void fastParseBlockBody(State<String> state) {
    // '{' v:BlockBody* '}'
    final $0 = state.pos;
    const $1 = '{';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 123;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      final $3 = state.isOptional;
      state.isOptional = true;
      while (true) {
        // BlockBody
        fastParseBlockBody(state);
        if (!state.ok) {
          break;
        }
      }
      state.isOptional = $3;
      state.setOk(true);
      if (state.ok) {
        const $4 = '}';
        final $5 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 125;
        if ($5) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$4]));
        }
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
    if (!state.ok && state.isRecoverable) {
      // !'}' .
      final $6 = state.pos;
      final $7 = state.pos;
      const $8 = '}';
      final $9 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 125;
      if ($9) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$8]));
      }
      if (state.ok) {
        final length = $7 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          -1 => const ErrorUnexpectedInput(-1),
          -2 => const ErrorUnexpectedInput(-2),
          _ => ErrorUnexpectedInput(length)
        });
        state.backtrack($7);
      } else {
        state.setOk(true);
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.pos += c > 0xffff ? 2 : 1;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
    }
  }

  /// Colon =
  ///   v:':' Spaces
  ///   ;
  void fastParseColon(State<String> state) {
    // v:':' Spaces
    final $0 = state.pos;
    const $1 = ':';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 58;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Comma =
  ///   v:',' Spaces
  ///   ;
  void fastParseComma(State<String> state) {
    // v:',' Spaces
    final $0 = state.pos;
    const $1 = ',';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 44;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Comment =
  ///   '#' (![\n\r] .)*
  ///   ;
  void fastParseComment(State<String> state) {
    // '#' (![\n\r] .)*
    final $0 = state.pos;
    const $1 = '#';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 35;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      final $3 = state.isOptional;
      state.isOptional = true;
      while (true) {
        // ![\n\r] .
        final $4 = state.pos;
        final $5 = state.pos;
        if (state.pos < state.input.length) {
          final $6 = state.input.codeUnitAt(state.pos);
          final $7 = $6 == 10 || $6 == 13;
          if ($7) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          final length = $5 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            -1 => const ErrorUnexpectedInput(-1),
            -2 => const ErrorUnexpectedInput(-2),
            _ => ErrorUnexpectedInput(length)
          });
          state.backtrack($5);
        } else {
          state.setOk(true);
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final c = state.input.runeAt(state.pos);
            state.pos += c > 0xffff ? 2 : 1;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
        if (!state.ok) {
          state.backtrack($4);
        }
        if (!state.ok) {
          break;
        }
      }
      state.isOptional = $3;
      state.setOk(true);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// CommercialAt =
  ///   v:'@' Spaces
  ///   ;
  void fastParseCommercialAt(State<String> state) {
    // v:'@' Spaces
    final $0 = state.pos;
    const $1 = '@';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// EqualsSign =
  ///   v:'=' Spaces
  ///   ;
  void fastParseEqualsSign(State<String> state) {
    // v:'=' Spaces
    final $0 = state.pos;
    const $1 = '=';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 61;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// FullStop =
  ///   v:'.' Spaces
  ///   ;
  void fastParseFullStop(State<String> state) {
    // v:'.' Spaces
    final $0 = state.pos;
    const $1 = '.';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 46;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// GreaterThanSign =
  ///   v:'>' Spaces
  ///   ;
  void fastParseGreaterThanSign(State<String> state) {
    // v:'>' Spaces
    final $0 = state.pos;
    const $1 = '>';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 62;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// LeftCurlyBracket =
  ///   v:'{' Spaces
  ///   ;
  void fastParseLeftCurlyBracket(State<String> state) {
    // v:'{' Spaces
    final $0 = state.pos;
    const $1 = '{';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 123;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// LeftParenthesis =
  ///   v:'(' Spaces
  ///   ;
  void fastParseLeftParenthesis(State<String> state) {
    // v:'(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 40;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// LessThanSign =
  ///   v:'<' Spaces
  ///   ;
  void fastParseLessThanSign(State<String> state) {
    // v:'<' Spaces
    final $0 = state.pos;
    const $1 = '<';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 60;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// ReservedMetaName =
  ///   $('@' ('eof' / 'expected' / 'indicate' / 'list1' / 'list' / 'matchString' / 'message' / 'stringChars' / 'verify')) ![a-zA-Z_0-9]+
  ///   ;
  void fastParseReservedMetaName(State<String> state) {
    // $('@' ('eof' / 'expected' / 'indicate' / 'list1' / 'list' / 'matchString' / 'message' / 'stringChars' / 'verify')) ![a-zA-Z_0-9]+
    final $0 = state.pos;
    // '@' ('eof' / 'expected' / 'indicate' / 'list1' / 'list' / 'matchString' / 'message' / 'stringChars' / 'verify')
    final $2 = state.pos;
    const $3 = '@';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      final $6 = state.pos;
      var $5 = 0;
      if (state.pos < state.input.length) {
        final input = state.input;
        final c = input.codeUnitAt(state.pos);
        // ignore: unused_local_variable
        final pos2 = state.pos + 1;
        switch (c) {
          case 101:
            final ok = pos2 + 1 < input.length &&
                input.codeUnitAt(pos2) == 111 &&
                input.codeUnitAt(pos2 + 1) == 102;
            if (ok) {
              $5 = 3;
            } else {
              const $8 = 'expected';
              final ok = input.startsWith($8, state.pos);
              if (ok) {
                $5 = 8;
              }
            }
            break;
          case 105:
            const $9 = 'indicate';
            final ok = input.startsWith($9, state.pos);
            if (ok) {
              $5 = 8;
            }
            break;
          case 108:
            const $10 = 'list1';
            final ok = input.startsWith($10, state.pos);
            if (ok) {
              $5 = 5;
            } else {
              final ok = pos2 + 2 < input.length &&
                  input.codeUnitAt(pos2) == 105 &&
                  input.codeUnitAt(pos2 + 1) == 115 &&
                  input.codeUnitAt(pos2 + 2) == 116;
              if (ok) {
                $5 = 4;
              }
            }
            break;
          case 109:
            const $12 = 'matchString';
            final ok = input.startsWith($12, state.pos);
            if (ok) {
              $5 = 11;
            } else {
              const $13 = 'message';
              final ok = input.startsWith($13, state.pos);
              if (ok) {
                $5 = 7;
              }
            }
            break;
          case 115:
            const $14 = 'stringChars';
            final ok = input.startsWith($14, state.pos);
            if (ok) {
              $5 = 11;
            }
            break;
          case 118:
            const $15 = 'verify';
            final ok = input.startsWith($15, state.pos);
            if (ok) {
              $5 = 6;
            }
            break;
        }
      }
      if ($5 > 0) {
        state.pos += $5;
        state.setOk(true);
      } else {
        state.pos = $6;
        state.fail(const ErrorExpectedTags([
          'eof',
          'expected',
          'indicate',
          'list1',
          'list',
          'matchString',
          'message',
          'stringChars',
          'verify'
        ]));
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (state.ok) {
      final $16 = state.pos;
      var $17 = false;
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c < 65
                  ? c >= 48 && c <= 57
                  : c <= 90 || c == 95 || c >= 97 && c <= 122);
          state.pos++,
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          $17 = true);
      if ($17) {
        state.setOk($17);
      } else {
        state.pos < state.input.length
            ? state.fail(const ErrorUnexpectedCharacter())
            : state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        final length = $16 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          -1 => const ErrorUnexpectedInput(-1),
          -2 => const ErrorUnexpectedInput(-2),
          _ => ErrorUnexpectedInput(length)
        });
        state.backtrack($16);
      } else {
        state.setOk(true);
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// RightCurlyBracket =
  ///   v:'}' Spaces
  ///   ;
  void fastParseRightCurlyBracket(State<String> state) {
    // v:'}' Spaces
    final $0 = state.pos;
    const $1 = '}';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 125;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// RightParenthesis =
  ///   v:')' Spaces
  ///   ;
  void fastParseRightParenthesis(State<String> state) {
    // v:')' Spaces
    final $0 = state.pos;
    const $1 = ')';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 41;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// RightSquareBracket =
  ///   v:']' Spaces
  ///   ;
  void fastParseRightSquareBracket(State<String> state) {
    // v:']' Spaces
    final $0 = state.pos;
    const $1 = ']';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 93;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Semicolon =
  ///   v:';' Spaces
  ///   ;
  void fastParseSemicolon(State<String> state) {
    // v:';' Spaces
    final $0 = state.pos;
    const $1 = ';';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 59;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Solidus =
  ///   v:'/' Spaces
  ///   ;
  void fastParseSolidus(State<String> state) {
    // v:'/' Spaces
    final $0 = state.pos;
    const $1 = '/';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 47;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Spaces =
  ///   (WhiteSpace / Comment)*
  ///   ;
  void fastParseSpaces(State<String> state) {
    // (WhiteSpace / Comment)*
    final $1 = state.isOptional;
    state.isOptional = true;
    while (true) {
      // WhiteSpace
      // WhiteSpace
      fastParseWhiteSpace(state);
      if (!state.ok && state.isRecoverable) {
        // Comment
        // Comment
        fastParseComment(state);
      }
      if (!state.ok) {
        break;
      }
    }
    state.isOptional = $1;
    state.setOk(true);
  }

  /// UpwardsArrow =
  ///   v:'↑' Spaces
  ///   ;
  void fastParseUpwardsArrow(State<String> state) {
    // v:'↑' Spaces
    final $0 = state.pos;
    const $1 = '↑';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 8593;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// WhiteSpace =
  ///   [ \n\r\t]
  ///   ;
  void fastParseWhiteSpace(State<String> state) {
    // [ \n\r\t]
    if (state.pos < state.input.length) {
      final $1 = state.input.codeUnitAt(state.pos);
      final $2 = $1 < 13 ? $1 >= 9 && $1 <= 10 : $1 <= 13 || $1 == 32;
      if ($2) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// SemanticAction
  /// Action =
  ///   t:(LessThanSign v:Type GreaterThanSign)? b:Block {}
  ///   ;
  SemanticAction? parseAction(State<String> state) {
    SemanticAction? $0;
    // t:(LessThanSign v:Type GreaterThanSign)? b:Block {}
    final $3 = state.pos;
    ResultType? $1;
    final $4 = state.isOptional;
    state.isOptional = true;
    // LessThanSign v:Type GreaterThanSign
    final $6 = state.pos;
    // LessThanSign
    fastParseLessThanSign(state);
    if (state.ok) {
      ResultType? $5;
      // Type
      $5 = parseType(state);
      if (state.ok) {
        // GreaterThanSign
        fastParseGreaterThanSign(state);
        if (state.ok) {
          $1 = $5;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($6);
    }
    state.isOptional = $4;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      String? $2;
      // Block
      $2 = parseBlock(state);
      if (state.ok) {
        SemanticAction? $$;
        final t = $1;
        final b = $2!;
        $$ = SemanticAction(source: b, resultType: t);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Ampersand =
  ///   v:'&' Spaces
  ///   ;
  String? parseAmpersand(State<String> state) {
    String? $0;
    // v:'&' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '&';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 38;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// AnyCharacter =
  ///   FullStop {}
  ///   ;
  Expression? parseAnyCharacter(State<String> state) {
    Expression? $0;
    // FullStop {}
    // FullStop
    fastParseFullStop(state);
    if (state.ok) {
      Expression? $$;
      $$ = AnyCharacterExpression();
      $0 = $$;
    }
    return $0;
  }

  /// Asterisk =
  ///   v:'*' Spaces
  ///   ;
  String? parseAsterisk(State<String> state) {
    String? $0;
    // v:'*' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '*';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 42;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Block =
  ///   '{' v:$BlockBody* RightCurlyBracket
  ///   ;
  String? parseBlock(State<String> state) {
    String? $0;
    // '{' v:$BlockBody* RightCurlyBracket
    final $2 = state.pos;
    const $3 = '{';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 123;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      String? $1;
      final $5 = state.pos;
      final $6 = state.isOptional;
      state.isOptional = true;
      while (true) {
        // BlockBody
        fastParseBlockBody(state);
        if (!state.ok) {
          break;
        }
      }
      state.isOptional = $6;
      state.setOk(true);
      if (state.ok) {
        $1 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        // RightCurlyBracket
        fastParseRightCurlyBracket(state);
        if (state.ok) {
          $0 = $1;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// CharacterClass =
  ///     '[^' r:(!']' v:Range)+ RightSquareBracket {}
  ///   / '[' r:(!']' v:Range)+ RightSquareBracket {}
  ///   ;
  Expression? parseCharacterClass(State<String> state) {
    Expression? $0;
    // '[^' r:(!']' v:Range)+ RightSquareBracket {}
    final $2 = state.pos;
    const $3 = '[^';
    final $4 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 91 &&
        state.input.codeUnitAt(state.pos + 1) == 94;
    if ($4) {
      state.pos += 2;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      List<(int, int)>? $1;
      final $6 = <(int, int)>[];
      final $5 = state.isOptional;
      while (true) {
        state.isOptional = $6.isNotEmpty;
        (int, int)? $7;
        // !']' v:Range
        final $9 = state.pos;
        final $10 = state.pos;
        const $11 = ']';
        final $12 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 93;
        if ($12) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$11]));
        }
        if (state.ok) {
          final length = $10 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            -1 => const ErrorUnexpectedInput(-1),
            -2 => const ErrorUnexpectedInput(-2),
            _ => ErrorUnexpectedInput(length)
          });
          state.backtrack($10);
        } else {
          state.setOk(true);
        }
        if (state.ok) {
          (int, int)? $8;
          // Range
          $8 = parseRange(state);
          if (state.ok) {
            $7 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $6.add($7!);
      }
      state.isOptional = $5;
      if ($6.isNotEmpty) {
        state.setOk(true);
        $1 = $6;
      }
      if (state.ok) {
        // RightSquareBracket
        fastParseRightSquareBracket(state);
        if (state.ok) {
          Expression? $$;
          final r = $1!;
          $$ = CharacterClassExpression(ranges: r, negate: true);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (!state.ok && state.isRecoverable) {
      // '[' r:(!']' v:Range)+ RightSquareBracket {}
      final $14 = state.pos;
      const $15 = '[';
      final $16 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 91;
      if ($16) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$15]));
      }
      if (state.ok) {
        List<(int, int)>? $13;
        final $18 = <(int, int)>[];
        final $17 = state.isOptional;
        while (true) {
          state.isOptional = $18.isNotEmpty;
          (int, int)? $19;
          // !']' v:Range
          final $21 = state.pos;
          final $22 = state.pos;
          const $23 = ']';
          final $24 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 93;
          if ($24) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$23]));
          }
          if (state.ok) {
            final length = $22 - state.pos;
            state.fail(switch (length) {
              0 => const ErrorUnexpectedInput(0),
              -1 => const ErrorUnexpectedInput(-1),
              -2 => const ErrorUnexpectedInput(-2),
              _ => ErrorUnexpectedInput(length)
            });
            state.backtrack($22);
          } else {
            state.setOk(true);
          }
          if (state.ok) {
            (int, int)? $20;
            // Range
            $20 = parseRange(state);
            if (state.ok) {
              $19 = $20;
            }
          }
          if (!state.ok) {
            state.backtrack($21);
          }
          if (!state.ok) {
            break;
          }
          $18.add($19!);
        }
        state.isOptional = $17;
        if ($18.isNotEmpty) {
          state.setOk(true);
          $13 = $18;
        }
        if (state.ok) {
          // RightSquareBracket
          fastParseRightSquareBracket(state);
          if (state.ok) {
            Expression? $$;
            final r = $13!;
            $$ = CharacterClassExpression(ranges: r);
            $0 = $$;
          }
        }
      }
      if (!state.ok) {
        state.backtrack($14);
      }
    }
    return $0;
  }

  /// Expression
  /// Cut =
  ///   UpwardsArrow {}
  ///   ;
  Expression? parseCut(State<String> state) {
    Expression? $0;
    // UpwardsArrow {}
    // UpwardsArrow
    fastParseUpwardsArrow(state);
    if (state.ok) {
      Expression? $$;
      $$ = CutExpression();
      $0 = $$;
    }
    return $0;
  }

  /// ProductionRule
  /// Definition =
  ///     m:Metadata? t:Type? i:Identifier EqualsSign e:Expression Semicolon {}
  ///   / m:Metadata? i:Identifier EqualsSign e:Expression Semicolon {}
  ///   ;
  ProductionRule? parseDefinition(State<String> state) {
    ProductionRule? $0;
    // m:Metadata? t:Type? i:Identifier EqualsSign e:Expression Semicolon {}
    final $5 = state.pos;
    List<({String name, List<Object?> arguments})>? $1;
    final $6 = state.isOptional;
    state.isOptional = true;
    // Metadata
    $1 = parseMetadata(state);
    state.isOptional = $6;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      ResultType? $2;
      final $7 = state.isOptional;
      state.isOptional = true;
      // Type
      $2 = parseType(state);
      state.isOptional = $7;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        String? $3;
        // Identifier
        $3 = parseIdentifier(state);
        if (state.ok) {
          // EqualsSign
          fastParseEqualsSign(state);
          if (state.ok) {
            Expression? $4;
            // Expression
            $4 = parseExpression(state);
            if (state.ok) {
              // Semicolon
              fastParseSemicolon(state);
              if (state.ok) {
                ProductionRule? $$;
                final m = $1;
                final t = $2;
                final i = $3!;
                final e = $4!;
                $$ = ProductionRule(
                    name: i,
                    expression: e as OrderedChoiceExpression,
                    resultType: t,
                    metadata: m);
                $0 = $$;
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    if (!state.ok && state.isRecoverable) {
      // m:Metadata? i:Identifier EqualsSign e:Expression Semicolon {}
      final $11 = state.pos;
      List<({String name, List<Object?> arguments})>? $8;
      final $12 = state.isOptional;
      state.isOptional = true;
      // Metadata
      $8 = parseMetadata(state);
      state.isOptional = $12;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        String? $9;
        // Identifier
        $9 = parseIdentifier(state);
        if (state.ok) {
          // EqualsSign
          fastParseEqualsSign(state);
          if (state.ok) {
            Expression? $10;
            // Expression
            $10 = parseExpression(state);
            if (state.ok) {
              // Semicolon
              fastParseSemicolon(state);
              if (state.ok) {
                ProductionRule? $$;
                final m = $8;
                final i = $9!;
                final e = $10!;
                $$ = ProductionRule(
                    name: i,
                    expression: e as OrderedChoiceExpression,
                    metadata: m);
                $0 = $$;
              }
            }
          }
        }
      }
      if (!state.ok) {
        state.backtrack($11);
      }
    }
    return $0;
  }

  /// DollarSign =
  ///   v:'\$' Spaces
  ///   ;
  String? parseDollarSign(State<String> state) {
    String? $0;
    // v:'\$' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '\$';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 36;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Eof =
  ///   '@eof' Spaces LeftParenthesis RightParenthesis Spaces {}
  ///   ;
  Expression? parseEof(State<String> state) {
    Expression? $0;
    // '@eof' Spaces LeftParenthesis RightParenthesis Spaces {}
    final $1 = state.pos;
    const $2 = '@eof';
    final $3 = state.pos + 3 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.codeUnitAt(state.pos + 1) == 101 &&
        state.input.codeUnitAt(state.pos + 2) == 111 &&
        state.input.codeUnitAt(state.pos + 3) == 102;
    if ($3) {
      state.pos += 4;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$2]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          // RightParenthesis
          fastParseRightParenthesis(state);
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
            if (state.ok) {
              Expression? $$;
              $$ = EofExpression();
              $0 = $$;
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// ExclamationMark =
  ///   v:'!' Spaces
  ///   ;
  String? parseExclamationMark(State<String> state) {
    String? $0;
    // v:'!' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '!';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 33;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Expected =
  ///   '@expected' Spaces LeftParenthesis t:String Comma e:Expression RightParenthesis {}
  ///   ;
  Expression? parseExpected(State<String> state) {
    Expression? $0;
    // '@expected' Spaces LeftParenthesis t:String Comma e:Expression RightParenthesis {}
    final $3 = state.pos;
    const $4 = '@expected';
    final $5 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.startsWith($4, state.pos);
    if ($5) {
      state.pos += 9;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          String? $1;
          // String
          $1 = parseString(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // RightParenthesis
                fastParseRightParenthesis(state);
                if (state.ok) {
                  Expression? $$;
                  final t = $1!;
                  final e = $2!;
                  $$ = ExpectedExpression(expression: e, tag: t);
                  $0 = $$;
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression =
  ///   OrderedChoice
  ///   ;
  Expression? parseExpression(State<String> state) {
    Expression? $0;
    // OrderedChoice
    // OrderedChoice
    $0 = parseOrderedChoice(state);
    return $0;
  }

  /// ResultType
  /// GenericType =
  ///     i:NativeIdentifier LessThanSign p:TypeArguments GreaterThanSign {}
  ///   / i:NativeIdentifier {}
  ///   ;
  ResultType? parseGenericType(State<String> state) {
    ResultType? $0;
    // i:NativeIdentifier LessThanSign p:TypeArguments GreaterThanSign {}
    final $3 = state.pos;
    String? $1;
    // NativeIdentifier
    $1 = parseNativeIdentifier(state);
    if (state.ok) {
      // LessThanSign
      fastParseLessThanSign(state);
      if (state.ok) {
        List<ResultType>? $2;
        // TypeArguments
        $2 = parseTypeArguments(state);
        if (state.ok) {
          // GreaterThanSign
          fastParseGreaterThanSign(state);
          if (state.ok) {
            ResultType? $$;
            final i = $1!;
            final p = $2!;
            $$ = GenericType(name: i, arguments: p);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // i:NativeIdentifier {}
      String? $4;
      // NativeIdentifier
      $4 = parseNativeIdentifier(state);
      if (state.ok) {
        ResultType? $$;
        final i = $4!;
        $$ = GenericType(name: i);
        $0 = $$;
      }
    }
    return $0;
  }

  /// Globals =
  ///   '%{' v:$(!'}%' v:.)* '}%' Spaces
  ///   ;
  String? parseGlobals(State<String> state) {
    String? $0;
    // '%{' v:$(!'}%' v:.)* '}%' Spaces
    final $2 = state.pos;
    const $3 = '%{';
    final $4 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 37 &&
        state.input.codeUnitAt(state.pos + 1) == 123;
    if ($4) {
      state.pos += 2;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      String? $1;
      final $5 = state.pos;
      const $8 = '}%';
      final $6 = state.input.indexOf($8, state.pos);
      final $7 = $6 != -1;
      if ($7) {
        state.pos = $6;
        state.setOk(true);
      } else {
        state.failAt(state.input.length, const ErrorExpectedTags([$8]));
      }
      if (state.ok) {
        $1 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        const $9 = '}%';
        final $10 = state.pos + 1 < state.input.length &&
            state.input.codeUnitAt(state.pos) == 125 &&
            state.input.codeUnitAt(state.pos + 1) == 37;
        if ($10) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$9]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            $0 = $1;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Group =
  ///   LeftParenthesis e:Expression RightParenthesis {}
  ///   ;
  Expression? parseGroup(State<String> state) {
    Expression? $0;
    // LeftParenthesis e:Expression RightParenthesis {}
    final $2 = state.pos;
    // LeftParenthesis
    fastParseLeftParenthesis(state);
    if (state.ok) {
      Expression? $1;
      // Expression
      $1 = parseExpression(state);
      if (state.ok) {
        // RightParenthesis
        fastParseRightParenthesis(state);
        if (state.ok) {
          Expression? $$;
          final e = $1!;
          $$ = GroupExpression(expression: e);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// int
  /// HexChar =
  ///   'u{' v:$[a-zA-Z0-9]+ '}' <int>{}
  ///   ;
  int? parseHexChar(State<String> state) {
    int? $0;
    // 'u{' v:$[a-zA-Z0-9]+ '}' <int>{}
    final $2 = state.pos;
    const $3 = 'u{';
    final $4 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 117 &&
        state.input.codeUnitAt(state.pos + 1) == 123;
    if ($4) {
      state.pos += 2;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      String? $1;
      final $5 = state.pos;
      var $6 = false;
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c < 65 ? c >= 48 && c <= 57 : c <= 90 || c >= 97 && c <= 122);
          state.pos++,
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          $6 = true);
      if ($6) {
        state.setOk($6);
      } else {
        state.pos < state.input.length
            ? state.fail(const ErrorUnexpectedCharacter())
            : state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $1 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        const $7 = '}';
        final $8 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 125;
        if ($8) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$7]));
        }
        if (state.ok) {
          int? $$;
          final v = $1!;
          $$ = int.parse(v, radix: 16);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// String
  /// Identifier =
  ///   i:$([a-zA-Z] [a-zA-Z_0-9]*) Spaces
  ///   ;
  String? parseIdentifier(State<String> state) {
    String? $0;
    // i:$([a-zA-Z] [a-zA-Z_0-9]*) Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    // [a-zA-Z] [a-zA-Z_0-9]*
    final $4 = state.pos;
    if (state.pos < state.input.length) {
      final $5 = state.input.codeUnitAt(state.pos);
      final $6 = $5 <= 90 ? $5 >= 65 : $5 >= 97 && $5 <= 122;
      if ($6) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c < 65
                  ? c >= 48 && c <= 57
                  : c <= 90 || c == 95 || c >= 97 && c <= 122);
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          state.pos++);
      state.setOk(true);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $1 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Indicate =
  ///   '@indicate' Spaces LeftParenthesis s:String Comma e:Expression RightParenthesis {}
  ///   ;
  Expression? parseIndicate(State<String> state) {
    Expression? $0;
    // '@indicate' Spaces LeftParenthesis s:String Comma e:Expression RightParenthesis {}
    final $3 = state.pos;
    const $4 = '@indicate';
    final $5 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.startsWith($4, state.pos);
    if ($5) {
      state.pos += 9;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          String? $1;
          // String
          $1 = parseString(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // RightParenthesis
                fastParseRightParenthesis(state);
                if (state.ok) {
                  Expression? $$;
                  final s = $1!;
                  final e = $2!;
                  $$ = IndicateExpression(expression: e, message: s);
                  $0 = $$;
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// int
  /// Integer =
  ///   v:$[0-9]+ {}
  ///   ;
  int? parseInteger(State<String> state) {
    int? $0;
    // v:$[0-9]+ {}
    String? $1;
    final $3 = state.pos;
    var $4 = false;
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c >= 48 && c <= 57);
        state.pos++,
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        $4 = true);
    if ($4) {
      state.setOk($4);
    } else {
      state.pos < state.input.length
          ? state.fail(const ErrorUnexpectedCharacter())
          : state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $1 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $1!;
      $$ = int.parse(v);
      $0 = $$;
    }
    return $0;
  }

  /// Expression
  /// List =
  ///   '@list' Spaces LeftParenthesis h:Expression Comma t:Expression RightParenthesis {}
  ///   ;
  Expression? parseList(State<String> state) {
    Expression? $0;
    // '@list' Spaces LeftParenthesis h:Expression Comma t:Expression RightParenthesis {}
    final $3 = state.pos;
    const $4 = '@list';
    final $5 = state.pos + 4 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.codeUnitAt(state.pos + 1) == 108 &&
        state.input.codeUnitAt(state.pos + 2) == 105 &&
        state.input.codeUnitAt(state.pos + 3) == 115 &&
        state.input.codeUnitAt(state.pos + 4) == 116;
    if ($5) {
      state.pos += 5;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          Expression? $1;
          // Expression
          $1 = parseExpression(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // RightParenthesis
                fastParseRightParenthesis(state);
                if (state.ok) {
                  Expression? $$;
                  final h = $1!;
                  final t = $2!;
                  $$ = ListExpression(first: h, next: t);
                  $0 = $$;
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// List1 =
  ///   '@list1' Spaces LeftParenthesis h:Expression Comma t:Expression RightParenthesis {}
  ///   ;
  Expression? parseList1(State<String> state) {
    Expression? $0;
    // '@list1' Spaces LeftParenthesis h:Expression Comma t:Expression RightParenthesis {}
    final $3 = state.pos;
    const $4 = '@list1';
    final $5 = state.pos + 5 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.codeUnitAt(state.pos + 1) == 108 &&
        state.input.codeUnitAt(state.pos + 2) == 105 &&
        state.input.codeUnitAt(state.pos + 3) == 115 &&
        state.input.codeUnitAt(state.pos + 4) == 116 &&
        state.input.codeUnitAt(state.pos + 5) == 49;
    if ($5) {
      state.pos += 6;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          Expression? $1;
          // Expression
          $1 = parseExpression(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // RightParenthesis
                fastParseRightParenthesis(state);
                if (state.ok) {
                  Expression? $$;
                  final h = $1!;
                  final t = $2!;
                  $$ = List1Expression(first: h, next: t);
                  $0 = $$;
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// Literal =
  ///   s:String {}
  ///   ;
  Expression? parseLiteral(State<String> state) {
    Expression? $0;
    // s:String {}
    String? $1;
    // String
    $1 = parseString(state);
    if (state.ok) {
      Expression? $$;
      final s = $1!;
      $$ = LiteralExpression(string: s);
      $0 = $$;
    }
    return $0;
  }

  /// Expression
  /// MatchString =
  ///   '@matchString' Spaces LeftParenthesis b:Block RightParenthesis {}
  ///   ;
  Expression? parseMatchString(State<String> state) {
    Expression? $0;
    // '@matchString' Spaces LeftParenthesis b:Block RightParenthesis {}
    final $2 = state.pos;
    const $3 = '@matchString';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.startsWith($3, state.pos);
    if ($4) {
      state.pos += 12;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          String? $1;
          // Block
          $1 = parseBlock(state);
          if (state.ok) {
            // RightParenthesis
            fastParseRightParenthesis(state);
            if (state.ok) {
              Expression? $$;
              final b = $1!;
              $$ = MatchStringExpression(value: b);
              $0 = $$;
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Members =
  ///   '%%' v:$(!'%%' v:.)* '%%' Spaces
  ///   ;
  String? parseMembers(State<String> state) {
    String? $0;
    // '%%' v:$(!'%%' v:.)* '%%' Spaces
    final $2 = state.pos;
    const $3 = '%%';
    final $4 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 37 &&
        state.input.codeUnitAt(state.pos + 1) == 37;
    if ($4) {
      state.pos += 2;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      String? $1;
      final $5 = state.pos;
      const $8 = '%%';
      final $6 = state.input.indexOf($8, state.pos);
      final $7 = $6 != -1;
      if ($7) {
        state.pos = $6;
        state.setOk(true);
      } else {
        state.failAt(state.input.length, const ErrorExpectedTags([$8]));
      }
      if (state.ok) {
        $1 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        const $9 = '%%';
        final $10 = state.pos + 1 < state.input.length &&
            state.input.codeUnitAt(state.pos) == 37 &&
            state.input.codeUnitAt(state.pos + 1) == 37;
        if ($10) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$9]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            $0 = $1;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Message =
  ///   '@message' Spaces LeftParenthesis s:String Comma e:Expression RightParenthesis {}
  ///   ;
  Expression? parseMessage(State<String> state) {
    Expression? $0;
    // '@message' Spaces LeftParenthesis s:String Comma e:Expression RightParenthesis {}
    final $3 = state.pos;
    const $4 = '@message';
    final $5 = state.pos + 7 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.codeUnitAt(state.pos + 1) == 109 &&
        state.input.codeUnitAt(state.pos + 2) == 101 &&
        state.input.codeUnitAt(state.pos + 3) == 115 &&
        state.input.codeUnitAt(state.pos + 4) == 115 &&
        state.input.codeUnitAt(state.pos + 5) == 97 &&
        state.input.codeUnitAt(state.pos + 6) == 103 &&
        state.input.codeUnitAt(state.pos + 7) == 101;
    if ($5) {
      state.pos += 8;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          String? $1;
          // String
          $1 = parseString(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // RightParenthesis
                fastParseRightParenthesis(state);
                if (state.ok) {
                  Expression? $$;
                  final s = $1!;
                  final e = $2!;
                  $$ = MessageExpression(expression: e, message: s);
                  $0 = $$;
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// MetaExpression =
  ///   !ReservedMetaName @verify('Unknown meta expression', MetaName) {}
  ///   ;
  Expression? parseMetaExpression(State<String> state) {
    Expression? $0;
    // !ReservedMetaName @verify('Unknown meta expression', MetaName) {}
    final $1 = state.pos;
    final $2 = state.pos;
    // ReservedMetaName
    fastParseReservedMetaName(state);
    if (state.ok) {
      final length = $2 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        -1 => const ErrorUnexpectedInput(-1),
        -2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($2);
    } else {
      state.setOk(true);
    }
    if (state.ok) {
      final $5 = state.pos;
      String? $3;
      // MetaName
      // MetaName
      $3 = parseMetaName(state);
      if (state.ok) {
        // ignore: unused_local_variable
        final $$ = $3!;
        final $4 = (() => false)();
        if (!$4) {
          state.fail(ErrorMessage($5 - state.pos, 'Unknown meta expression'));
          state.backtrack($5);
        }
      }
      if (state.ok) {
        Expression? $$;
        $$ = null;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// String
  /// MetaName =
  ///   !ReservedMetaName v:$('@' [a-zA-Z] [a-zA-Z_0-9]*) Spaces
  ///   ;
  String? parseMetaName(State<String> state) {
    String? $0;
    // !ReservedMetaName v:$('@' [a-zA-Z] [a-zA-Z_0-9]*) Spaces
    final $2 = state.pos;
    final $3 = state.pos;
    // ReservedMetaName
    fastParseReservedMetaName(state);
    if (state.ok) {
      final length = $3 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        -1 => const ErrorUnexpectedInput(-1),
        -2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($3);
    } else {
      state.setOk(true);
    }
    if (state.ok) {
      String? $1;
      final $4 = state.pos;
      // '@' [a-zA-Z] [a-zA-Z_0-9]*
      final $5 = state.pos;
      const $6 = '@';
      final $7 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 64;
      if ($7) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$6]));
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final $8 = state.input.codeUnitAt(state.pos);
          final $9 = $8 <= 90 ? $8 >= 65 : $8 >= 97 && $8 <= 122;
          if ($9) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.codeUnitAt(state.pos)) == c &&
                  (c < 65
                      ? c >= 48 && c <= 57
                      : c <= 90 || c == 95 || c >= 97 && c <= 122);
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              state.pos++);
          state.setOk(true);
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
      if (state.ok) {
        $1 = state.input.substring($4, state.pos);
      }
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
        if (state.ok) {
          $0 = $1;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// List<({String name, List<Object?> arguments})>
  /// Metadata =
  ///   h:MetadataElement t:(Spaces v:MetadataElement)* {}
  ///   ;
  List<({String name, List<Object?> arguments})>? parseMetadata(
      State<String> state) {
    List<({String name, List<Object?> arguments})>? $0;
    // h:MetadataElement t:(Spaces v:MetadataElement)* {}
    final $3 = state.pos;
    ({String name, List<Object?> arguments})? $1;
    // MetadataElement
    $1 = parseMetadataElement(state);
    if (state.ok) {
      List<({String name, List<Object?> arguments})>? $2;
      final $5 = <({String name, List<Object?> arguments})>[];
      final $4 = state.isOptional;
      state.isOptional = true;
      while (true) {
        ({String name, List<Object?> arguments})? $6;
        // Spaces v:MetadataElement
        final $8 = state.pos;
        // Spaces
        fastParseSpaces(state);
        if (state.ok) {
          ({String name, List<Object?> arguments})? $7;
          // MetadataElement
          $7 = parseMetadataElement(state);
          if (state.ok) {
            $6 = $7;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $5.add($6!);
      }
      state.isOptional = $4;
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
      }
      if (state.ok) {
        List<({String name, List<Object?> arguments})>? $$;
        final h = $1!;
        final t = $2!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// MetadataArgument =
  ///   '\'' v:StringChar* Apostrophe {}
  ///   ;
  Object? parseMetadataArgument(State<String> state) {
    Object? $0;
    // '\'' v:StringChar* Apostrophe {}
    final $2 = state.pos;
    const $3 = '\'';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 39;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      List<int>? $1;
      final $6 = <int>[];
      final $5 = state.isOptional;
      state.isOptional = true;
      while (true) {
        int? $7;
        // StringChar
        $7 = parseStringChar(state);
        if (!state.ok) {
          break;
        }
        $6.add($7!);
      }
      state.isOptional = $5;
      state.setOk(true);
      if (state.ok) {
        $1 = $6;
      }
      if (state.ok) {
        // Apostrophe
        fastParseApostrophe(state);
        if (state.ok) {
          Object? $$;
          final v = $1!;
          $$ = String.fromCharCodes(v);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// List<Object?>
  /// MetadataArgumentList =
  ///   h:MetadataArgument t:(Comma v:MetadataArgument)* {}
  ///   ;
  List<Object?>? parseMetadataArgumentList(State<String> state) {
    List<Object?>? $0;
    // h:MetadataArgument t:(Comma v:MetadataArgument)* {}
    final $3 = state.pos;
    Object? $1;
    // MetadataArgument
    $1 = parseMetadataArgument(state);
    if (state.ok) {
      List<Object?>? $2;
      final $5 = <Object?>[];
      final $4 = state.isOptional;
      state.isOptional = true;
      while (true) {
        Object? $6;
        // Comma v:MetadataArgument
        final $8 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          Object? $7;
          // MetadataArgument
          $7 = parseMetadataArgument(state);
          if (state.ok) {
            $6 = $7;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $5.add($6);
      }
      state.isOptional = $4;
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
      }
      if (state.ok) {
        List<Object?>? $$;
        final h = $1;
        final t = $2!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// List<Object?>
  /// MetadataArguments =
  ///   LeftParenthesis v:MetadataArgumentList? RightParenthesis {}
  ///   ;
  List<Object?>? parseMetadataArguments(State<String> state) {
    List<Object?>? $0;
    // LeftParenthesis v:MetadataArgumentList? RightParenthesis {}
    final $2 = state.pos;
    // LeftParenthesis
    fastParseLeftParenthesis(state);
    if (state.ok) {
      List<Object?>? $1;
      final $3 = state.isOptional;
      state.isOptional = true;
      // MetadataArgumentList
      $1 = parseMetadataArgumentList(state);
      state.isOptional = $3;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        // RightParenthesis
        fastParseRightParenthesis(state);
        if (state.ok) {
          List<Object?>? $$;
          final v = $1;
          $$ = v ?? const [];
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// ({String name, List<Object?> arguments})
  /// MetadataElement =
  ///   CommercialAt i:Identifier a:MetadataArguments? {}
  ///   ;
  ({String name, List<Object?> arguments})? parseMetadataElement(
      State<String> state) {
    ({String name, List<Object?> arguments})? $0;
    // CommercialAt i:Identifier a:MetadataArguments? {}
    final $3 = state.pos;
    // CommercialAt
    fastParseCommercialAt(state);
    if (state.ok) {
      String? $1;
      // Identifier
      $1 = parseIdentifier(state);
      if (state.ok) {
        List<Object?>? $2;
        final $4 = state.isOptional;
        state.isOptional = true;
        // MetadataArguments
        $2 = parseMetadataArguments(state);
        state.isOptional = $4;
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          ({String name, List<Object?> arguments})? $$;
          final i = $1!;
          final a = $2;
          $$ = (name: '@$i', arguments: a ?? const []);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// (int?, int?)
  /// MinMax =
  ///     m:Integer Comma n:Integer {}
  ///   / Comma n:Integer {}
  ///   / m:Integer Comma {}
  ///   / n:Integer {}
  ///   ;
  (int?, int?)? parseMinMax(State<String> state) {
    (int?, int?)? $0;
    // m:Integer Comma n:Integer {}
    final $3 = state.pos;
    int? $1;
    // Integer
    $1 = parseInteger(state);
    if (state.ok) {
      // Comma
      fastParseComma(state);
      if (state.ok) {
        int? $2;
        // Integer
        $2 = parseInteger(state);
        if (state.ok) {
          (int?, int?)? $$;
          final m = $1!;
          final n = $2!;
          $$ = (m, n);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // Comma n:Integer {}
      final $5 = state.pos;
      // Comma
      fastParseComma(state);
      if (state.ok) {
        int? $4;
        // Integer
        $4 = parseInteger(state);
        if (state.ok) {
          (int?, int?)? $$;
          final n = $4!;
          $$ = (null, n);
          $0 = $$;
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
      if (!state.ok && state.isRecoverable) {
        // m:Integer Comma {}
        final $7 = state.pos;
        int? $6;
        // Integer
        $6 = parseInteger(state);
        if (state.ok) {
          // Comma
          fastParseComma(state);
          if (state.ok) {
            (int?, int?)? $$;
            final m = $6!;
            $$ = (m, null);
            $0 = $$;
          }
        }
        if (!state.ok) {
          state.backtrack($7);
        }
        if (!state.ok && state.isRecoverable) {
          // n:Integer {}
          int? $8;
          // Integer
          $8 = parseInteger(state);
          if (state.ok) {
            (int?, int?)? $$;
            final n = $8!;
            $$ = (n, n);
            $0 = $$;
          }
        }
      }
    }
    return $0;
  }

  /// ({ResultType type, String name})
  /// NamedField =
  ///   type:Type name:NativeIdentifier
  ///   ;
  ({ResultType type, String name})? parseNamedField(State<String> state) {
    ({ResultType type, String name})? $0;
    // type:Type name:NativeIdentifier
    final $3 = state.pos;
    ResultType? $1;
    // Type
    $1 = parseType(state);
    if (state.ok) {
      String? $2;
      // NativeIdentifier
      $2 = parseNativeIdentifier(state);
      if (state.ok) {
        $0 = (type: $1!, name: $2!);
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// List<({ResultType type, String name})>
  /// NamedFields =
  ///   LeftCurlyBracket h:NamedField t:(Comma v:NamedField)* RightCurlyBracket {}
  ///   ;
  List<({ResultType type, String name})>? parseNamedFields(
      State<String> state) {
    List<({ResultType type, String name})>? $0;
    // LeftCurlyBracket h:NamedField t:(Comma v:NamedField)* RightCurlyBracket {}
    final $3 = state.pos;
    // LeftCurlyBracket
    fastParseLeftCurlyBracket(state);
    if (state.ok) {
      ({ResultType type, String name})? $1;
      // NamedField
      $1 = parseNamedField(state);
      if (state.ok) {
        List<({ResultType type, String name})>? $2;
        final $5 = <({ResultType type, String name})>[];
        final $4 = state.isOptional;
        state.isOptional = true;
        while (true) {
          ({ResultType type, String name})? $6;
          // Comma v:NamedField
          final $8 = state.pos;
          // Comma
          fastParseComma(state);
          if (state.ok) {
            ({ResultType type, String name})? $7;
            // NamedField
            $7 = parseNamedField(state);
            if (state.ok) {
              $6 = $7;
            }
          }
          if (!state.ok) {
            state.backtrack($8);
          }
          if (!state.ok) {
            break;
          }
          $5.add($6!);
        }
        state.isOptional = $4;
        state.setOk(true);
        if (state.ok) {
          $2 = $5;
        }
        if (state.ok) {
          // RightCurlyBracket
          fastParseRightCurlyBracket(state);
          if (state.ok) {
            List<({ResultType type, String name})>? $$;
            final h = $1!;
            final t = $2!;
            $$ = [h, ...t];
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// String
  /// NativeIdentifier =
  ///   i:$([$a-zA-Z_] [$0-9a-zA-Z_]*) Spaces
  ///   ;
  String? parseNativeIdentifier(State<String> state) {
    String? $0;
    // i:$([$a-zA-Z_] [$0-9a-zA-Z_]*) Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    // [$a-zA-Z_] [$0-9a-zA-Z_]*
    final $4 = state.pos;
    if (state.pos < state.input.length) {
      final $5 = state.input.codeUnitAt(state.pos);
      final $6 =
          $5 < 65 ? $5 == 36 : $5 <= 90 || $5 == 95 || $5 >= 97 && $5 <= 122;
      if ($6) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c < 65
                  ? c == 36 || c >= 48 && c <= 57
                  : c <= 90 || c == 95 || c >= 97 && c <= 122);
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          state.pos++);
      state.setOk(true);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $1 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// OrderedChoice =
  ///   h:Sequence t:(Solidus v:Sequence)* {}
  ///   ;
  Expression? parseOrderedChoice(State<String> state) {
    Expression? $0;
    // h:Sequence t:(Solidus v:Sequence)* {}
    final $3 = state.pos;
    Expression? $1;
    // Sequence
    $1 = parseSequence(state);
    if (state.ok) {
      List<Expression>? $2;
      final $5 = <Expression>[];
      final $4 = state.isOptional;
      state.isOptional = true;
      while (true) {
        Expression? $6;
        // Solidus v:Sequence
        final $8 = state.pos;
        // Solidus
        fastParseSolidus(state);
        if (state.ok) {
          Expression? $7;
          // Sequence
          $7 = parseSequence(state);
          if (state.ok) {
            $6 = $7;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $5.add($6!);
      }
      state.isOptional = $4;
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
      }
      if (state.ok) {
        Expression? $$;
        final h = $1!;
        final t = $2!;
        $$ = OrderedChoiceExpression(expressions: [h, ...t]);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// PlusSign =
  ///   v:'+' Spaces
  ///   ;
  String? parsePlusSign(State<String> state) {
    String? $0;
    // v:'+' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '+';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 43;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// ({ResultType type, String? name})
  /// PositionalField =
  ///   type:Type name:NativeIdentifier?
  ///   ;
  ({ResultType type, String? name})? parsePositionalField(State<String> state) {
    ({ResultType type, String? name})? $0;
    // type:Type name:NativeIdentifier?
    final $3 = state.pos;
    ResultType? $1;
    // Type
    $1 = parseType(state);
    if (state.ok) {
      String? $2;
      final $4 = state.isOptional;
      state.isOptional = true;
      // NativeIdentifier
      $2 = parseNativeIdentifier(state);
      state.isOptional = $4;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        $0 = (type: $1!, name: $2);
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// List<({ResultType type, String? name})>
  /// PositionalFields =
  ///   h:PositionalField t:(Comma v:PositionalField)* {}
  ///   ;
  List<({ResultType type, String? name})>? parsePositionalFields(
      State<String> state) {
    List<({ResultType type, String? name})>? $0;
    // h:PositionalField t:(Comma v:PositionalField)* {}
    final $3 = state.pos;
    ({ResultType type, String? name})? $1;
    // PositionalField
    $1 = parsePositionalField(state);
    if (state.ok) {
      List<({ResultType type, String? name})>? $2;
      final $5 = <({ResultType type, String? name})>[];
      final $4 = state.isOptional;
      state.isOptional = true;
      while (true) {
        ({ResultType type, String? name})? $6;
        // Comma v:PositionalField
        final $8 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          ({ResultType type, String? name})? $7;
          // PositionalField
          $7 = parsePositionalField(state);
          if (state.ok) {
            $6 = $7;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $5.add($6!);
      }
      state.isOptional = $4;
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
      }
      if (state.ok) {
        List<({ResultType type, String? name})>? $$;
        final h = $1!;
        final t = $2!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// Prefix =
  ///   p:(DollarSign / Ampersand / ExclamationMark)? s:Suffix {}
  ///   ;
  Expression? parsePrefix(State<String> state) {
    Expression? $0;
    // p:(DollarSign / Ampersand / ExclamationMark)? s:Suffix {}
    final $3 = state.pos;
    String? $1;
    final $4 = state.isOptional;
    state.isOptional = true;
    // DollarSign
    // DollarSign
    $1 = parseDollarSign(state);
    if (!state.ok && state.isRecoverable) {
      // Ampersand
      // Ampersand
      $1 = parseAmpersand(state);
      if (!state.ok && state.isRecoverable) {
        // ExclamationMark
        // ExclamationMark
        $1 = parseExclamationMark(state);
      }
    }
    state.isOptional = $4;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      Expression? $2;
      // Suffix
      $2 = parseSuffix(state);
      if (state.ok) {
        Expression? $$;
        final p = $1;
        final s = $2!;
        $$ = _buildPrefix(p, s);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Primary =
  ///     Symbol
  ///   / CharacterClass
  ///   / Literal
  ///   / CharacterClass
  ///   / AnyCharacter
  ///   / Group
  ///   / MetaExpression
  ///   / Cut
  ///   / Eof
  ///   / Expected
  ///   / Indicate
  ///   / List
  ///   / List1
  ///   / MatchString
  ///   / Message
  ///   / StringChars
  ///   / Verify
  ///   ;
  Expression? parsePrimary(State<String> state) {
    Expression? $0;
    // Symbol
    // Symbol
    $0 = parseSymbol(state);
    if (!state.ok && state.isRecoverable) {
      // CharacterClass
      // CharacterClass
      $0 = parseCharacterClass(state);
      if (!state.ok && state.isRecoverable) {
        // Literal
        // Literal
        $0 = parseLiteral(state);
        if (!state.ok && state.isRecoverable) {
          // CharacterClass
          // CharacterClass
          $0 = parseCharacterClass(state);
          if (!state.ok && state.isRecoverable) {
            // AnyCharacter
            // AnyCharacter
            $0 = parseAnyCharacter(state);
            if (!state.ok && state.isRecoverable) {
              // Group
              // Group
              $0 = parseGroup(state);
              if (!state.ok && state.isRecoverable) {
                // MetaExpression
                // MetaExpression
                $0 = parseMetaExpression(state);
                if (!state.ok && state.isRecoverable) {
                  // Cut
                  // Cut
                  $0 = parseCut(state);
                  if (!state.ok && state.isRecoverable) {
                    // Eof
                    // Eof
                    $0 = parseEof(state);
                    if (!state.ok && state.isRecoverable) {
                      // Expected
                      // Expected
                      $0 = parseExpected(state);
                      if (!state.ok && state.isRecoverable) {
                        // Indicate
                        // Indicate
                        $0 = parseIndicate(state);
                        if (!state.ok && state.isRecoverable) {
                          // List
                          // List
                          $0 = parseList(state);
                          if (!state.ok && state.isRecoverable) {
                            // List1
                            // List1
                            $0 = parseList1(state);
                            if (!state.ok && state.isRecoverable) {
                              // MatchString
                              // MatchString
                              $0 = parseMatchString(state);
                              if (!state.ok && state.isRecoverable) {
                                // Message
                                // Message
                                $0 = parseMessage(state);
                                if (!state.ok && state.isRecoverable) {
                                  // StringChars
                                  // StringChars
                                  $0 = parseStringChars(state);
                                  if (!state.ok && state.isRecoverable) {
                                    // Verify
                                    // Verify
                                    $0 = parseVerify(state);
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
      }
    }
    return $0;
  }

  /// QuestionMark =
  ///   v:'?' Spaces
  ///   ;
  String? parseQuestionMark(State<String> state) {
    String? $0;
    // v:'?' Spaces
    final $2 = state.pos;
    String? $1;
    const $3 = '?';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 63;
    if ($4) {
      state.pos++;
      state.setOk(true);
      $1 = $3;
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// (int, int)
  /// Range =
  ///     s:RangeChar '-' e:RangeChar {}
  ///   / s:RangeChar {}
  ///   ;
  (int, int)? parseRange(State<String> state) {
    (int, int)? $0;
    // s:RangeChar '-' e:RangeChar {}
    final $3 = state.pos;
    int? $1;
    // RangeChar
    $1 = parseRangeChar(state);
    if (state.ok) {
      const $4 = '-';
      final $5 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 45;
      if ($5) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$4]));
      }
      if (state.ok) {
        int? $2;
        // RangeChar
        $2 = parseRangeChar(state);
        if (state.ok) {
          (int, int)? $$;
          final s = $1!;
          final e = $2!;
          $$ = (s, e);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // s:RangeChar {}
      int? $6;
      // RangeChar
      $6 = parseRangeChar(state);
      if (state.ok) {
        (int, int)? $$;
        final s = $6!;
        $$ = (s, s);
        $0 = $$;
      }
    }
    return $0;
  }

  /// int
  /// RangeChar =
  ///     '\\' v:(c:[-nrt\]\\^] <int>{} / HexChar)
  ///   / !'\\' c:.
  ///   ;
  int? parseRangeChar(State<String> state) {
    int? $0;
    // '\\' v:(c:[-nrt\]\\^] <int>{} / HexChar)
    final $2 = state.pos;
    const $3 = '\\';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 92;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      int? $1;
      // c:[-nrt\]\\^] <int>{}
      if (state.pos < state.input.length) {
        final $6 = state.input.codeUnitAt(state.pos);
        final $7 = $6 < 110
            ? $6 == 45 || $6 >= 92 && $6 <= 94
            : $6 <= 110 || $6 == 114 || $6 == 116;
        if ($7) {
          state.pos++;
          state.setOk(true);
          $1 = $6;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $$;
        final c = $1!;
        $$ = _escape(c);
        $1 = $$;
      }
      if (!state.ok && state.isRecoverable) {
        // HexChar
        // HexChar
        $1 = parseHexChar(state);
      }
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (!state.ok && state.isRecoverable) {
      // !'\\' c:.
      final $10 = state.pos;
      final $11 = state.pos;
      const $12 = '\\';
      final $13 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 92;
      if ($13) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$12]));
      }
      if (state.ok) {
        final length = $11 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          -1 => const ErrorUnexpectedInput(-1),
          -2 => const ErrorUnexpectedInput(-2),
          _ => ErrorUnexpectedInput(length)
        });
        state.backtrack($11);
      } else {
        state.setOk(true);
      }
      if (state.ok) {
        int? $9;
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.pos += c > 0xffff ? 2 : 1;
          state.setOk(true);
          $9 = c;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $0 = $9;
        }
      }
      if (!state.ok) {
        state.backtrack($10);
      }
    }
    return $0;
  }

  /// ResultType
  /// RecordType =
  ///   LeftParenthesis v:(n:NamedFields <RecordType>{} / p:PositionalFields Comma n:NamedFields <RecordType>{} / h:PositionalField Comma t:PositionalFields <RecordType>{} / t:PositionalField Comma <RecordType>{}) RightParenthesis
  ///   ;
  ResultType? parseRecordType(State<String> state) {
    ResultType? $0;
    // LeftParenthesis v:(n:NamedFields <RecordType>{} / p:PositionalFields Comma n:NamedFields <RecordType>{} / h:PositionalField Comma t:PositionalFields <RecordType>{} / t:PositionalField Comma <RecordType>{}) RightParenthesis
    final $2 = state.pos;
    // LeftParenthesis
    fastParseLeftParenthesis(state);
    if (state.ok) {
      RecordType? $1;
      // n:NamedFields <RecordType>{}
      List<({ResultType type, String name})>? $3;
      // NamedFields
      $3 = parseNamedFields(state);
      if (state.ok) {
        RecordType? $$;
        final n = $3!;
        $$ = RecordType(named: n);
        $1 = $$;
      }
      if (!state.ok && state.isRecoverable) {
        // p:PositionalFields Comma n:NamedFields <RecordType>{}
        final $7 = state.pos;
        List<({ResultType type, String? name})>? $5;
        // PositionalFields
        $5 = parsePositionalFields(state);
        if (state.ok) {
          // Comma
          fastParseComma(state);
          if (state.ok) {
            List<({ResultType type, String name})>? $6;
            // NamedFields
            $6 = parseNamedFields(state);
            if (state.ok) {
              RecordType? $$;
              final p = $5!;
              final n = $6!;
              $$ = RecordType(positional: p, named: n);
              $1 = $$;
            }
          }
        }
        if (!state.ok) {
          state.backtrack($7);
        }
        if (!state.ok && state.isRecoverable) {
          // h:PositionalField Comma t:PositionalFields <RecordType>{}
          final $10 = state.pos;
          ({ResultType type, String? name})? $8;
          // PositionalField
          $8 = parsePositionalField(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              List<({ResultType type, String? name})>? $9;
              // PositionalFields
              $9 = parsePositionalFields(state);
              if (state.ok) {
                RecordType? $$;
                final h = $8!;
                final t = $9!;
                $$ = RecordType(positional: [h, ...t]);
                $1 = $$;
              }
            }
          }
          if (!state.ok) {
            state.backtrack($10);
          }
          if (!state.ok && state.isRecoverable) {
            // t:PositionalField Comma <RecordType>{}
            final $12 = state.pos;
            ({ResultType type, String? name})? $11;
            // PositionalField
            $11 = parsePositionalField(state);
            if (state.ok) {
              // Comma
              fastParseComma(state);
              if (state.ok) {
                RecordType? $$;
                final t = $11!;
                $$ = RecordType(positional: [t]);
                $1 = $$;
              }
            }
            if (!state.ok) {
              state.backtrack($12);
            }
          }
        }
      }
      if (state.ok) {
        // RightParenthesis
        fastParseRightParenthesis(state);
        if (state.ok) {
          $0 = $1;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Expression
  /// Sequence =
  ///   e:SequenceElement+ a:Action? {}
  ///   ;
  Expression? parseSequence(State<String> state) {
    Expression? $0;
    // e:SequenceElement+ a:Action? {}
    final $3 = state.pos;
    List<Expression>? $1;
    final $5 = <Expression>[];
    final $4 = state.isOptional;
    while (true) {
      state.isOptional = $5.isNotEmpty;
      Expression? $6;
      // SequenceElement
      $6 = parseSequenceElement(state);
      if (!state.ok) {
        break;
      }
      $5.add($6!);
    }
    state.isOptional = $4;
    if ($5.isNotEmpty) {
      state.setOk(true);
      $1 = $5;
    }
    if (state.ok) {
      SemanticAction? $2;
      final $7 = state.isOptional;
      state.isOptional = true;
      // Action
      $2 = parseAction(state);
      state.isOptional = $7;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        Expression? $$;
        final e = $1!;
        final a = $2;
        $$ = SequenceExpression(expressions: e, action: a);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// SequenceElement =
  ///     i:Identifier Colon p:Prefix <Expression>{}
  ///   / Prefix
  ///   ;
  Expression? parseSequenceElement(State<String> state) {
    Expression? $0;
    // i:Identifier Colon p:Prefix <Expression>{}
    final $3 = state.pos;
    String? $1;
    // Identifier
    $1 = parseIdentifier(state);
    if (state.ok) {
      // Colon
      fastParseColon(state);
      if (state.ok) {
        Expression? $2;
        // Prefix
        $2 = parsePrefix(state);
        if (state.ok) {
          Expression? $$;
          final i = $1!;
          final p = $2!;
          $$ = p..semanticVariable = i;
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // Prefix
      // Prefix
      $0 = parsePrefix(state);
    }
    return $0;
  }

  /// Grammar
  /// Start =
  ///   Spaces g:Globals? m:Members? d:Definition* @eof() {}
  ///   ;
  Grammar? parseStart(State<String> state) {
    Grammar? $0;
    // Spaces g:Globals? m:Members? d:Definition* @eof() {}
    final $4 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      String? $1;
      final $5 = state.isOptional;
      state.isOptional = true;
      // Globals
      $1 = parseGlobals(state);
      state.isOptional = $5;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        String? $2;
        final $6 = state.isOptional;
        state.isOptional = true;
        // Members
        $2 = parseMembers(state);
        state.isOptional = $6;
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          List<ProductionRule>? $3;
          final $8 = <ProductionRule>[];
          final $7 = state.isOptional;
          state.isOptional = true;
          while (true) {
            ProductionRule? $9;
            // Definition
            $9 = parseDefinition(state);
            if (!state.ok) {
              break;
            }
            $8.add($9!);
          }
          state.isOptional = $7;
          state.setOk(true);
          if (state.ok) {
            $3 = $8;
          }
          if (state.ok) {
            if (state.pos >= state.input.length) {
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedEndOfInput());
            }
            if (state.ok) {
              Grammar? $$;
              final g = $1;
              final m = $2;
              final d = $3!;
              $$ = Grammar(rules: d, globals: g, members: m);
              $0 = $$;
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    return $0;
  }

  /// String
  /// String =
  ///   '\'' cs:(!'\'' c:StringChar)* '\'' Spaces {}
  ///   ;
  String? parseString(State<String> state) {
    String? $0;
    // '\'' cs:(!'\'' c:StringChar)* '\'' Spaces {}
    final $2 = state.pos;
    const $3 = '\'';
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 39;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
    if (state.ok) {
      List<int>? $1;
      final $6 = <int>[];
      final $5 = state.isOptional;
      state.isOptional = true;
      while (true) {
        int? $7;
        // !'\'' c:StringChar
        final $9 = state.pos;
        final $10 = state.pos;
        const $11 = '\'';
        final $12 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 39;
        if ($12) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$11]));
        }
        if (state.ok) {
          final length = $10 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            -1 => const ErrorUnexpectedInput(-1),
            -2 => const ErrorUnexpectedInput(-2),
            _ => ErrorUnexpectedInput(length)
          });
          state.backtrack($10);
        } else {
          state.setOk(true);
        }
        if (state.ok) {
          int? $8;
          // StringChar
          $8 = parseStringChar(state);
          if (state.ok) {
            $7 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $6.add($7!);
      }
      state.isOptional = $5;
      state.setOk(true);
      if (state.ok) {
        $1 = $6;
      }
      if (state.ok) {
        const $13 = '\'';
        final $14 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 39;
        if ($14) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$13]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            String? $$;
            final cs = $1!;
            $$ = String.fromCharCodes(cs);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// int
  /// StringChar =
  ///     [ -[\]-\u{10ffff}]
  ///   / '\\' v:(c:[rnt'"\\] <int>{} / HexChar)
  ///   ;
  int? parseStringChar(State<String> state) {
    int? $0;
    // [ -[\]-\u{10ffff}]
    if (state.pos < state.input.length) {
      final $2 = state.input.runeAt(state.pos);
      final $3 = $2 <= 91 ? $2 >= 32 : $2 >= 93 && $2 <= 1114111;
      if ($3) {
        state.pos += $2 > 0xffff ? 2 : 1;
        state.setOk(true);
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // '\\' v:(c:[rnt'"\\] <int>{} / HexChar)
      final $5 = state.pos;
      const $6 = '\\';
      final $7 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 92;
      if ($7) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$6]));
      }
      if (state.ok) {
        int? $4;
        // c:[rnt'"\\] <int>{}
        if (state.pos < state.input.length) {
          final $9 = state.input.codeUnitAt(state.pos);
          final $10 = $9 < 92
              ? $9 == 34 || $9 == 39
              : $9 <= 92 || ($9 < 114 ? $9 == 110 : $9 <= 114 || $9 == 116);
          if ($10) {
            state.pos++;
            state.setOk(true);
            $4 = $9;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $$;
          final c = $4!;
          $$ = _escape(c);
          $4 = $$;
        }
        if (!state.ok && state.isRecoverable) {
          // HexChar
          // HexChar
          $4 = parseHexChar(state);
        }
        if (state.ok) {
          $0 = $4;
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
    }
    return $0;
  }

  /// Expression
  /// StringChars =
  ///   '@stringChars' Spaces LeftParenthesis n:Expression Comma c:Expression Comma e:Expression RightParenthesis {}
  ///   ;
  Expression? parseStringChars(State<String> state) {
    Expression? $0;
    // '@stringChars' Spaces LeftParenthesis n:Expression Comma c:Expression Comma e:Expression RightParenthesis {}
    final $4 = state.pos;
    const $5 = '@stringChars';
    final $6 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.startsWith($5, state.pos);
    if ($6) {
      state.pos += 12;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          Expression? $1;
          // Expression
          $1 = parseExpression(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // Comma
                fastParseComma(state);
                if (state.ok) {
                  Expression? $3;
                  // Expression
                  $3 = parseExpression(state);
                  if (state.ok) {
                    // RightParenthesis
                    fastParseRightParenthesis(state);
                    if (state.ok) {
                      Expression? $$;
                      final n = $1!;
                      final c = $2!;
                      final e = $3!;
                      $$ = StringCharsExpression(
                          normalCharacters: n, escapeCharacter: c, escape: e);
                      $0 = $$;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    return $0;
  }

  /// Expression
  /// Suffix =
  ///   p:Primary s:(Asterisk / QuestionMark / PlusSign / LeftCurlyBracket v:MinMax RightCurlyBracket)? {}
  ///   ;
  Expression? parseSuffix(State<String> state) {
    Expression? $0;
    // p:Primary s:(Asterisk / QuestionMark / PlusSign / LeftCurlyBracket v:MinMax RightCurlyBracket)? {}
    final $3 = state.pos;
    Expression? $1;
    // Primary
    $1 = parsePrimary(state);
    if (state.ok) {
      Object? $2;
      final $4 = state.isOptional;
      state.isOptional = true;
      // Asterisk
      // Asterisk
      $2 = parseAsterisk(state);
      if (!state.ok && state.isRecoverable) {
        // QuestionMark
        // QuestionMark
        $2 = parseQuestionMark(state);
        if (!state.ok && state.isRecoverable) {
          // PlusSign
          // PlusSign
          $2 = parsePlusSign(state);
          if (!state.ok && state.isRecoverable) {
            // LeftCurlyBracket v:MinMax RightCurlyBracket
            final $9 = state.pos;
            // LeftCurlyBracket
            fastParseLeftCurlyBracket(state);
            if (state.ok) {
              (int?, int?)? $8;
              // MinMax
              $8 = parseMinMax(state);
              if (state.ok) {
                // RightCurlyBracket
                fastParseRightCurlyBracket(state);
                if (state.ok) {
                  $2 = $8;
                }
              }
            }
            if (!state.ok) {
              state.backtrack($9);
            }
          }
        }
      }
      state.isOptional = $4;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        Expression? $$;
        final p = $1!;
        final s = $2;
        $$ = _buildSuffix(s, p);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// Symbol =
  ///   i:Identifier {}
  ///   ;
  Expression? parseSymbol(State<String> state) {
    Expression? $0;
    // i:Identifier {}
    String? $1;
    // Identifier
    $1 = parseIdentifier(state);
    if (state.ok) {
      Expression? $$;
      final i = $1!;
      $$ = SymbolExpression(name: i);
      $0 = $$;
    }
    return $0;
  }

  /// ResultType
  /// Type =
  ///   t:(GenericType / RecordType) q:QuestionMark? {}
  ///   ;
  ResultType? parseType(State<String> state) {
    ResultType? $0;
    // t:(GenericType / RecordType) q:QuestionMark? {}
    final $3 = state.pos;
    ResultType? $1;
    // GenericType
    // GenericType
    $1 = parseGenericType(state);
    if (!state.ok && state.isRecoverable) {
      // RecordType
      // RecordType
      $1 = parseRecordType(state);
    }
    if (state.ok) {
      String? $2;
      final $6 = state.isOptional;
      state.isOptional = true;
      // QuestionMark
      $2 = parseQuestionMark(state);
      state.isOptional = $6;
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        ResultType? $$;
        final t = $1!;
        final q = $2;
        $$ = q == null ? t : t.getNullableType();
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// List<ResultType>
  /// TypeArguments =
  ///   h:Type t:(Comma v:Type)* {}
  ///   ;
  List<ResultType>? parseTypeArguments(State<String> state) {
    List<ResultType>? $0;
    // h:Type t:(Comma v:Type)* {}
    final $3 = state.pos;
    ResultType? $1;
    // Type
    $1 = parseType(state);
    if (state.ok) {
      List<ResultType>? $2;
      final $5 = <ResultType>[];
      final $4 = state.isOptional;
      state.isOptional = true;
      while (true) {
        ResultType? $6;
        // Comma v:Type
        final $8 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          ResultType? $7;
          // Type
          $7 = parseType(state);
          if (state.ok) {
            $6 = $7;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $5.add($6!);
      }
      state.isOptional = $4;
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
      }
      if (state.ok) {
        List<ResultType>? $$;
        final h = $1!;
        final t = $2!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Expression
  /// Verify =
  ///   '@verify' Spaces LeftParenthesis m:String Comma e:Expression Comma b:Block RightParenthesis {}
  ///   ;
  Expression? parseVerify(State<String> state) {
    Expression? $0;
    // '@verify' Spaces LeftParenthesis m:String Comma e:Expression Comma b:Block RightParenthesis {}
    final $4 = state.pos;
    const $5 = '@verify';
    final $6 = state.pos + 6 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 64 &&
        state.input.codeUnitAt(state.pos + 1) == 118 &&
        state.input.codeUnitAt(state.pos + 2) == 101 &&
        state.input.codeUnitAt(state.pos + 3) == 114 &&
        state.input.codeUnitAt(state.pos + 4) == 105 &&
        state.input.codeUnitAt(state.pos + 5) == 102 &&
        state.input.codeUnitAt(state.pos + 6) == 121;
    if ($6) {
      state.pos += 7;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        // LeftParenthesis
        fastParseLeftParenthesis(state);
        if (state.ok) {
          String? $1;
          // String
          $1 = parseString(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              Expression? $2;
              // Expression
              $2 = parseExpression(state);
              if (state.ok) {
                // Comma
                fastParseComma(state);
                if (state.ok) {
                  String? $3;
                  // Block
                  $3 = parseBlock(state);
                  if (state.ok) {
                    // RightParenthesis
                    fastParseRightParenthesis(state);
                    if (state.ok) {
                      Expression? $$;
                      final m = $1!;
                      final e = $2!;
                      final b = $3!;
                      $$ = VerifyExpression(
                          expression: e, message: m, predicate: b);
                      $0 = $$;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    return $0;
  }
}

void fastParseString(
    void Function(State<String> state) fastParse, String source) {
  final state = State(source);
  fastParse(state);
  if (state.ok) {
    return;
  }

  final parseResult = _createParseResult<String, Object?>(state, null);
  parseResult.getResult();
}

Sink<String> parseAsync<O>(
    AsyncResult<O> Function(State<ChunkedParsingSink> state) parse,
    void Function(ParseResult<ChunkedParsingSink, O> result) onComplete) {
  final input = ChunkedParsingSink();
  final state = State(input);
  final result = parse(state);
  void complete() {
    final parseResult =
        _createParseResult<ChunkedParsingSink, O>(state, result.value);
    onComplete(parseResult);
  }

  if (result.isComplete) {
    complete();
  } else {
    result.onComplete = complete;
  }

  return input;
}

O parseString<O>(O? Function(State<String> state) parse, String source) {
  final state = State(source);
  final result = parse(state);
  if (state.ok) {
    return result as O;
  }

  final parseResult = _createParseResult<String, O>(state, result);
  return parseResult.getResult();
}

ParseResult<I, O> tryParse<I, O>(O? Function(State<I> state) parse, I input) {
  final state = State(input);
  final result = parse(state);
  final parseResult = _createParseResult<I, O>(state, result);
  return parseResult;
}

ParseResult<I, O> _createParseResult<I, O>(State<I> state, O? result) {
  final input = state.input;
  if (state.ok) {
    return ParseResult(
      failPos: state.failPos,
      input: input,
      ok: true,
      pos: state.pos,
      result: result,
    );
  }

  final offset = state.failPos;
  final normalized = _normalize(input, offset, state.getErrors())
      .map((e) => e.getErrorMessage(input, offset))
      .toList();
  String? message;
  if (input is String) {
    message = _errorMessage(input, 0, offset, normalized);
  } else if (input is ChunkedParsingSink) {
    message = _errorMessage(input.data, input.start, offset, normalized);
  } else {
    message = normalized.join('\n');
  }

  return ParseResult(
    errors: normalized,
    failPos: state.failPos,
    input: input,
    errorMessage: message,
    ok: false,
    pos: state.pos,
    result: result,
  );
}

String _errorMessage(
    String source, int inputStart, int offset, List<ErrorMessage> errors) {
  final sb = StringBuffer();
  final errorInfoList = errors
      .map((e) => (length: e.length, message: e.toString()))
      .toSet()
      .toList();
  final offsets =
      errors.map((e) => e.length < 0 ? offset + e.length : offset).toSet();
  final offsetMap = <int, ({int line, int column})>{};
  if (inputStart == 0) {
    var line = 1;
    var lineStart = 0, next = 0, pos = 0;
    while (pos < source.length) {
      final found = offsets.any((e) => pos == e);
      if (found) {
        final column = pos - lineStart + 1;
        offsetMap[pos] = (line: line, column: column);
        offsets.remove(pos);
        if (offsets.isEmpty) {
          break;
        }
      }

      final c = source.codeUnitAt(pos++);
      if (c == 0xa || c == 0xd) {
        next = c == 0xa ? 0xd : 0xa;
        if (pos < source.length && source.codeUnitAt(pos) == next) {
          pos++;
        }

        line++;
        lineStart = pos;
      }
    }
  }

  for (var i = 0; i < errorInfoList.length; i++) {
    int max(int x, int y) => x > y ? x : y;
    int min(int x, int y) => x < y ? x : y;
    if (sb.isNotEmpty) {
      sb.writeln();
      sb.writeln();
    }

    final errorInfo = errorInfoList[i];
    final length = errorInfo.length;
    final message = errorInfo.message;
    final start = min(offset + length, offset);
    final end = max(offset + length, offset);
    final inputLen = source.length;
    final lineLimit = min(80, inputLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final extraLen = lineLimit - errorLen;
    final rightLen =
        min(inputStart + inputLen - end2, extraLen - (extraLen >> 1));
    final leftLen =
        min(start - inputStart, max(0, lineLimit - errorLen - rightLen));
    var index = start2 - 1 - inputStart;
    final list = <int>[];
    for (var i = 0; i < leftLen && index >= 0; i++) {
      var cc = source.codeUnitAt(index--);
      if ((cc & 0xFC00) == 0xDC00 && (index > 0)) {
        final pc = source.codeUnitAt(index);
        if ((pc & 0xFC00) == 0xD800) {
          cc = 0x10000 + ((pc & 0x3FF) << 10) + (cc & 0x3FF);
          index--;
        }
      }

      list.add(cc);
    }

    final left = String.fromCharCodes(list.reversed);
    final end3 = min(inputLen, start2 + (lineLimit - leftLen));
    final indicatorLen = max(1, errorLen);
    final right = source.substring(start - inputStart, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    final location = offsetMap[start];
    if (location != null) {
      final line = location.line;
      final column = location.column;
      sb.writeln('line $line, column $column (offset $start): $message');
    } else {
      sb.writeln('offset $start: $message');
    }

    sb.writeln(text);
    sb.write(' ' * leftLen + '^' * indicatorLen);
  }

  return sb.toString();
}

List<ParseError> _normalize<I>(I input, int offset, List<ParseError> errors) {
  final errorList = errors.toList();
  if (errorList.isEmpty) {
    errorList.add(const ErrorUnknownError());
  }

  final expectedTags = errorList.whereType<ErrorExpectedTags>().toList();
  if (expectedTags.isNotEmpty) {
    errorList.removeWhere((e) => e is ErrorExpectedTags);
    final tags = <String>{};
    for (final error in expectedTags) {
      tags.addAll(error.tags);
    }

    final tagList = tags.toList();
    tagList.sort();
    final error = ErrorExpectedTags(tagList);
    errorList.add(error);
  }

  final errorMap = <Object?, ParseError>{};
  for (final error in errorList) {
    Object key = error;
    if (error is ErrorUnexpectedInput) {
      key = (ErrorUnexpectedInput, error.length);
    } else if (error is ErrorUnknownError) {
      key = ErrorUnknownError;
    } else if (error is ErrorUnexpectedCharacter) {
      key = (ErrorUnexpectedCharacter, error.char);
    }

    errorMap[key] = error;
  }

  return errorMap.values.toList();
}

class AsyncResult<T> {
  bool isComplete = false;

  void Function()? onComplete;

  T? value;
}

class ChunkedParsingSink implements Sink<String> {
  int bufferLoad = 0;

  int _cuttingPosition = 0;

  String data = '';

  int end = 0;

  void Function()? handle;

  bool sleep = false;

  int start = 0;

  int _buffering = 0;

  bool _isClosed = false;

  bool get isClosed => _isClosed;

  @override
  void add(String data) {
    if (_isClosed) {
      throw StateError('Chunked data sink already closed');
    }

    this.data = this.data.isNotEmpty ? '${this.data}$data' : data;
    final length = this.data.length;
    end = start + length;
    if (bufferLoad < length) {
      bufferLoad = length;
    }

    sleep = false;
    while (!sleep) {
      final h = handle;
      handle = null;
      if (h == null) {
        break;
      }

      h();
    }

    if (_cuttingPosition > start) {
      this.data = _cuttingPosition != end
          ? this.data.substring(_cuttingPosition - start)
          : '';
      start = _cuttingPosition;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int beginBuffering() {
    return _buffering++;
  }

  @override
  void close() {
    if (_isClosed) {
      return;
    }

    _isClosed = true;
    sleep = false;
    while (!sleep) {
      final h = handle;
      handle = null;
      if (h == null) {
        break;
      }

      h();
    }

    if (_buffering != 0) {
      throw StateError('On closing, an incomplete buffering was detected');
    }

    if (data.isNotEmpty) {
      data = '';
    }
  }

  void cut(int position) {
    if (position < start || position > end) {
      throw RangeError.range(position, start, end, 'position');
    }

    if (_buffering == 0) {
      _cuttingPosition = position;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void endBuffering() {
    if (--_buffering < 0) {
      throw StateError('Inconsistent buffering completion detected.');
    }
  }
}

class ErrorExpectedEndOfInput extends ParseError {
  static const message = 'Expected an end of input';

  const ErrorExpectedEndOfInput();

  @override
  ErrorMessage getErrorMessage(Object? input, offset) {
    return const ErrorMessage(0, ErrorExpectedEndOfInput.message);
  }
}

class ErrorExpectedTags extends ParseError {
  static const message = 'Expected: {0}';

  final List<String> tags;

  const ErrorExpectedTags(this.tags);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    final list = tags.map(ParseError.escape).toList();
    list.sort();
    final argument = list.join(', ');
    return ErrorMessage(0, ErrorExpectedTags.message, [argument]);
  }
}

class ErrorMessage extends ParseError {
  final List<Object?> arguments;

  @override
  final int length;

  final String text;

  const ErrorMessage(this.length, this.text, [this.arguments = const []]);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return this;
  }

  @override
  String toString() {
    var result = text;
    for (var i = 0; i < arguments.length; i++) {
      final argument = arguments[i];
      result = result.replaceAll('{$i}', argument.toString());
    }

    return result;
  }
}

class ErrorUnexpectedCharacter extends ParseError {
  static const message = 'Unexpected character {0}';

  final int? char;

  const ErrorUnexpectedCharacter([this.char]);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    var argument = '<?>';
    var char = this.char;
    if (offset != null && offset >= 0) {
      if (input is String) {
        if (offset < input.length) {
          char = input.runeAt(offset);
        } else {
          argument = '<EOF>';
        }
      } else if (input is ChunkedParsingSink) {
        if (offset >= input.start && offset < input.end) {
          final index = offset - input.start;
          char = input.data.runeAt(index);
        } else if (input.isClosed && offset >= input.end) {
          argument = '<EOF>';
        }
      }
    }

    if (char != null) {
      final hexValue = char.toRadixString(16);
      final value = ParseError.escape(char);
      argument = '$value (0x$hexValue)';
    }

    return ErrorMessage(0, ErrorUnexpectedCharacter.message, [argument]);
  }
}

class ErrorUnexpectedEndOfInput extends ParseError {
  static const message = 'Unexpected end of input';

  const ErrorUnexpectedEndOfInput();

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return ErrorMessage(length, ErrorUnexpectedEndOfInput.message);
  }
}

class ErrorUnexpectedInput extends ParseError {
  static const message = 'Unexpected input data';

  @override
  final int length;

  const ErrorUnexpectedInput(this.length);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return ErrorMessage(length, ErrorUnexpectedInput.message);
  }
}

class ErrorUnknownError extends ParseError {
  static const message = 'Unknown error';

  const ErrorUnknownError();

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return const ErrorMessage(0, ErrorUnknownError.message);
  }
}

abstract class ParseError {
  const ParseError();

  int get length => 0;

  ErrorMessage getErrorMessage(Object? input, int? offset);

  @override
  String toString() {
    final message = getErrorMessage(null, null);
    return message.toString();
  }

  static String escape(Object? value, [bool quote = true]) {
    if (value is int) {
      if (value >= 0 && value <= 0xd7ff ||
          value >= 0xe000 && value <= 0x10ffff) {
        value = String.fromCharCode(value);
      } else {
        return value.toString();
      }
    } else if (value is! String) {
      return value.toString();
    }

    final map = {
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\r',
      '\t': '\\t',
      '\v': '\\v',
    };
    var result = value.toString();
    for (final key in map.keys) {
      result = result.replaceAll(key, map[key]!);
    }

    if (quote) {
      result = "'$result'";
    }

    return result;
  }
}

class ParseResult<I, O> {
  final String errorMessage;

  final List<ErrorMessage> errors;

  final int failPos;

  final I input;

  final bool ok;

  final int pos;

  final O? result;

  ParseResult({
    this.errorMessage = '',
    this.errors = const [],
    required this.failPos,
    required this.input,
    required this.ok,
    required this.pos,
    required this.result,
  });

  O getResult() {
    if (!ok) {
      throw FormatException(errorMessage);
    }

    return result as O;
  }
}

class State<T> {
  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool isOptional = false;

  bool isRecoverable = true;

  int lastFailPos = -1;

  bool ok = false;

  int pos = 0;

  final List<ParseError?> _errors = List.filled(256, null, growable: false);

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void advance(int offset) {
    pos += offset;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void backtrack(int pos) {
    if (isRecoverable) {
      this.pos = pos;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool fail(ParseError error) {
    return failAt(pos, error);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAll(List<ParseError> errors) {
    return failAllAt(pos, errors);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAllAt(int offset, List<ParseError> errors) {
    ok = false;
    if (!isOptional || !isRecoverable) {
      if (offset >= failPos) {
        if (failPos < offset) {
          failPos = offset;
          errorCount = 0;
        }

        for (var i = 0; i < errors.length; i++) {
          if (errorCount < errors.length) {
            _errors[errorCount++] = errors[i];
          }
        }

        if (lastFailPos < offset) {
          lastFailPos = offset;
        }
      }
    }

    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAt(int offset, ParseError error) {
    ok = false;
    if (!isOptional || !isRecoverable) {
      if (offset >= failPos) {
        if (failPos < offset) {
          failPos = offset;
          errorCount = 0;
        }

        if (errorCount < _errors.length) {
          _errors[errorCount++] = error;
        }
      }
    }

    if (lastFailPos < offset) {
      lastFailPos = offset;
    }

    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  List<ParseError> getErrors() {
    return List.generate(errorCount, (i) => _errors[i]!);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void setOk(bool ok) {
    this.ok = !ok ? false : isRecoverable;
  }

  @override
  String toString() {
    if (input case final String input) {
      if (pos >= input.length) {
        return '$ok $pos:';
      }

      var length = input.length - pos;
      length = length > 40 ? 40 : length;
      final string = input.substring(pos, pos + length);
      return '$ok $pos:$string';
    } else if (input case final ChunkedParsingSink input) {
      final source = input.data;
      final pos = this.pos - input.start;
      if (pos < 0 || pos >= source.length) {
        return '$ok $pos:';
      }

      var length = source.length - pos;
      length = length > 40 ? 40 : length;
      final string = source.substring(pos, pos + length);
      return '$ok $pos:$string';
    }

    return super.toString();
  }
}

extension ParseStringExt on String {
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  int runeAt(int index) {
    final w1 = codeUnitAt(index++);
    if (w1 > 0xd7ff && w1 < 0xe000) {
      if (index < length) {
        final w2 = codeUnitAt(index);
        if ((w2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((w1 & 0x3ff) << 10) + (w2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return w1;
  }
}

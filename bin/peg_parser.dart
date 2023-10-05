import 'package:peg/src/expressions/expressions.dart';
import 'package:peg/src/grammar/grammar.dart';

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

  /// AtSign =
  ///   v:'@' Spaces
  ///   ;
  void fastParseAtSign(State<StringReader> state) {
    // v:'@' Spaces
    final $0 = state.pos;
    const $1 = '@';
    matchLiteral1(state, 64, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// BlockBody =
  ///     '{' v:BlockBody* '}'
  ///   / !'}' .
  ///   ;
  void fastParseBlockBody(State<StringReader> state) {
    // '{' v:BlockBody* '}'
    final $0 = state.pos;
    const $1 = '{';
    matchLiteral1(state, 123, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      while (true) {
        // BlockBody
        fastParseBlockBody(state);
        if (!state.ok) {
          state.ok = true;
          break;
        }
      }
      if (state.ok) {
        const $2 = '}';
        matchLiteral1(state, 125, $2, const ErrorExpectedTags([$2]));
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
    if (!state.ok) {
      // !'}' .
      final $3 = state.pos;
      final $4 = state.pos;
      const $6 = '}';
      matchLiteral1(state, 125, $6, const ErrorExpectedTags([$6]));
      state.ok = !state.ok;
      if (!state.ok) {
        final length = $4 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          1 => const ErrorUnexpectedInput(1),
          2 => const ErrorUnexpectedInput(2),
          _ => ErrorUnexpectedInput(length)
        });
      }
      state.pos = $4;
      if (state.ok) {
        final $7 = state.input;
        if (state.pos < $7.length) {
          $7.readChar(state.pos);
          state.pos += $7.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
      if (!state.ok) {
        state.pos = $3;
      }
    }
  }

  /// CloseBrace =
  ///   v:'}' Spaces
  ///   ;
  void fastParseCloseBrace(State<StringReader> state) {
    // v:'}' Spaces
    final $0 = state.pos;
    const $1 = '}';
    matchLiteral1(state, 125, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// CloseBracket =
  ///   v:']' Spaces
  ///   ;
  void fastParseCloseBracket(State<StringReader> state) {
    // v:']' Spaces
    final $0 = state.pos;
    const $1 = ']';
    matchLiteral1(state, 93, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// CloseParenthesis =
  ///   v:')' Spaces
  ///   ;
  void fastParseCloseParenthesis(State<StringReader> state) {
    // v:')' Spaces
    final $0 = state.pos;
    const $1 = ')';
    matchLiteral1(state, 41, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Colon =
  ///   v:':' Spaces
  ///   ;
  void fastParseColon(State<StringReader> state) {
    // v:':' Spaces
    final $0 = state.pos;
    const $1 = ':';
    matchLiteral1(state, 58, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Comma =
  ///   v:',' Spaces
  ///   ;
  void fastParseComma(State<StringReader> state) {
    // v:',' Spaces
    final $0 = state.pos;
    const $1 = ',';
    matchLiteral1(state, 44, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Comment =
  ///   '#' (![\n\r] .)*
  ///   ;
  void fastParseComment(State<StringReader> state) {
    // '#' (![\n\r] .)*
    final $0 = state.pos;
    const $1 = '#';
    matchLiteral1(state, 35, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      while (true) {
        // ![\n\r] .
        final $2 = state.pos;
        final $3 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $5 = state.input.readChar(state.pos);
          state.ok = $5 == 10 || $5 == 13;
          if (state.ok) {
            state.pos += state.input.count;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $3 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $3;
        if (state.ok) {
          final $6 = state.input;
          if (state.pos < $6.length) {
            $6.readChar(state.pos);
            state.pos += $6.count;
            state.ok = true;
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
        if (!state.ok) {
          state.pos = $2;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Dot =
  ///   v:'.' Spaces
  ///   ;
  void fastParseDot(State<StringReader> state) {
    // v:'.' Spaces
    final $0 = state.pos;
    const $1 = '.';
    matchLiteral1(state, 46, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Equal =
  ///   v:'=' Spaces
  ///   ;
  void fastParseEqual(State<StringReader> state) {
    // v:'=' Spaces
    final $0 = state.pos;
    const $1 = '=';
    matchLiteral1(state, 61, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Greater =
  ///   v:'>' Spaces
  ///   ;
  void fastParseGreater(State<StringReader> state) {
    // v:'>' Spaces
    final $0 = state.pos;
    const $1 = '>';
    matchLiteral1(state, 62, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Less =
  ///   v:'<' Spaces
  ///   ;
  void fastParseLess(State<StringReader> state) {
    // v:'<' Spaces
    final $0 = state.pos;
    const $1 = '<';
    matchLiteral1(state, 60, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// OpenBrace =
  ///   v:'{' Spaces
  ///   ;
  void fastParseOpenBrace(State<StringReader> state) {
    // v:'{' Spaces
    final $0 = state.pos;
    const $1 = '{';
    matchLiteral1(state, 123, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// OpenParenthesis =
  ///   v:'(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<StringReader> state) {
    // v:'(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    matchLiteral1(state, 40, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Semicolon =
  ///   v:';' Spaces
  ///   ;
  void fastParseSemicolon(State<StringReader> state) {
    // v:';' Spaces
    final $0 = state.pos;
    const $1 = ';';
    matchLiteral1(state, 59, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// SingleQuote =
  ///   v:'\'' Spaces
  ///   ;
  void fastParseSingleQuote(State<StringReader> state) {
    // v:'\'' Spaces
    final $0 = state.pos;
    const $1 = '\'';
    matchLiteral1(state, 39, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Slash =
  ///   v:'/' Spaces
  ///   ;
  void fastParseSlash(State<StringReader> state) {
    // v:'/' Spaces
    final $0 = state.pos;
    const $1 = '/';
    matchLiteral1(state, 47, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Spaces =
  ///   (WhiteSpace / Comment)*
  ///   ;
  void fastParseSpaces(State<StringReader> state) {
    // (WhiteSpace / Comment)*
    while (true) {
      // WhiteSpace
      // WhiteSpace
      fastParseWhiteSpace(state);
      if (!state.ok) {
        // Comment
        // Comment
        fastParseComment(state);
      }
      if (!state.ok) {
        state.ok = true;
        break;
      }
    }
  }

  /// WhiteSpace =
  ///   [ \n\r\t]
  ///   ;
  void fastParseWhiteSpace(State<StringReader> state) {
    // [ \n\r\t]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
      if (state.ok) {
        state.pos += state.input.count;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// SemanticAction
  /// Action =
  ///   t:(Less v:Type Greater)? b:Block {}
  ///   ;
  SemanticAction? parseAction(State<StringReader> state) {
    SemanticAction? $0;
    // t:(Less v:Type Greater)? b:Block {}
    final $1 = state.pos;
    ResultType? $2;
    // Less v:Type Greater
    final $4 = state.pos;
    // Less
    fastParseLess(state);
    if (state.ok) {
      ResultType? $5;
      // Type
      $5 = parseType(state);
      if (state.ok) {
        // Greater
        fastParseGreater(state);
        if (state.ok) {
          $2 = $5;
        }
      }
    }
    if (!state.ok) {
      state.pos = $4;
    }
    state.ok = true;
    if (state.ok) {
      String? $3;
      // Block
      $3 = parseBlock(state);
      if (state.ok) {
        SemanticAction? $$;
        final t = $2;
        final b = $3!;
        $$ = SemanticAction(source: b, resultType: t);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Ampersand =
  ///   v:'&' Spaces
  ///   ;
  String? parseAmpersand(State<StringReader> state) {
    String? $0;
    // v:'&' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '&';
    $2 = matchLiteral1(state, 38, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// AnyCharacter =
  ///   Dot {}
  ///   ;
  Expression? parseAnyCharacter(State<StringReader> state) {
    Expression? $0;
    // Dot {}
    // Dot
    fastParseDot(state);
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
  String? parseAsterisk(State<StringReader> state) {
    String? $0;
    // v:'*' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '*';
    $2 = matchLiteral1(state, 42, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Block =
  ///   '{' v:$BlockBody* CloseBrace
  ///   ;
  String? parseBlock(State<StringReader> state) {
    String? $0;
    // '{' v:$BlockBody* CloseBrace
    final $1 = state.pos;
    const $3 = '{';
    matchLiteral1(state, 123, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      final $4 = state.pos;
      while (true) {
        // BlockBody
        fastParseBlockBody(state);
        if (!state.ok) {
          state.ok = true;
          break;
        }
      }
      if (state.ok) {
        $2 = state.input.substring($4, state.pos);
      }
      if (state.ok) {
        // CloseBrace
        fastParseCloseBrace(state);
        if (state.ok) {
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Buffer =
  ///   '@buffer' OpenParenthesis e:Expression CloseParenthesis {}
  ///   ;
  Expression? parseBuffer(State<StringReader> state) {
    Expression? $0;
    // '@buffer' OpenParenthesis e:Expression CloseParenthesis {}
    final $1 = state.pos;
    const $3 = '@buffer';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
      if (state.ok) {
        Expression? $2;
        // Expression
        $2 = parseExpression(state);
        if (state.ok) {
          // CloseParenthesis
          fastParseCloseParenthesis(state);
          if (state.ok) {
            Expression? $$;
            final e = $2!;
            $$ = BufferExpression(expression: e);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// CharacterClass =
  ///     '[^' r:(!']' v:Range)+ CloseBracket {}
  ///   / '[' r:(!']' v:Range)+ CloseBracket {}
  ///   ;
  Expression? parseCharacterClass(State<StringReader> state) {
    Expression? $0;
    // '[^' r:(!']' v:Range)+ CloseBracket {}
    final $1 = state.pos;
    const $3 = '[^';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      List<(int, int)>? $2;
      final $4 = <(int, int)>[];
      while (true) {
        (int, int)? $5;
        // !']' v:Range
        final $6 = state.pos;
        final $8 = state.pos;
        const $10 = ']';
        matchLiteral1(state, 93, $10, const ErrorExpectedTags([$10]));
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $8 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $8;
        if (state.ok) {
          (int, int)? $7;
          // Range
          $7 = parseRange(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.ok = $4.isNotEmpty;
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        // CloseBracket
        fastParseCloseBracket(state);
        if (state.ok) {
          Expression? $$;
          final r = $2!;
          $$ = CharacterClassExpression(ranges: r, negate: true);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // '[' r:(!']' v:Range)+ CloseBracket {}
      final $11 = state.pos;
      const $13 = '[';
      matchLiteral1(state, 91, $13, const ErrorExpectedTags([$13]));
      if (state.ok) {
        List<(int, int)>? $12;
        final $14 = <(int, int)>[];
        while (true) {
          (int, int)? $15;
          // !']' v:Range
          final $16 = state.pos;
          final $18 = state.pos;
          const $20 = ']';
          matchLiteral1(state, 93, $20, const ErrorExpectedTags([$20]));
          state.ok = !state.ok;
          if (!state.ok) {
            final length = $18 - state.pos;
            state.fail(switch (length) {
              0 => const ErrorUnexpectedInput(0),
              1 => const ErrorUnexpectedInput(1),
              2 => const ErrorUnexpectedInput(2),
              _ => ErrorUnexpectedInput(length)
            });
          }
          state.pos = $18;
          if (state.ok) {
            (int, int)? $17;
            // Range
            $17 = parseRange(state);
            if (state.ok) {
              $15 = $17;
            }
          }
          if (!state.ok) {
            state.pos = $16;
          }
          if (!state.ok) {
            break;
          }
          $14.add($15!);
        }
        state.ok = $14.isNotEmpty;
        if (state.ok) {
          $12 = $14;
        }
        if (state.ok) {
          // CloseBracket
          fastParseCloseBracket(state);
          if (state.ok) {
            Expression? $$;
            final r = $12!;
            $$ = CharacterClassExpression(ranges: r);
            $0 = $$;
          }
        }
      }
      if (!state.ok) {
        state.pos = $11;
      }
    }
    return $0;
  }

  /// ProductionRule
  /// Definition =
  ///     m:Metadata? t:Type? i:Identifier Equal e:Expression Semicolon {}
  ///   / m:Metadata? i:Identifier Equal e:Expression Semicolon {}
  ///   ;
  ProductionRule? parseDefinition(State<StringReader> state) {
    ProductionRule? $0;
    // m:Metadata? t:Type? i:Identifier Equal e:Expression Semicolon {}
    final $1 = state.pos;
    List<({String name, List<Object?> arguments})>? $2;
    // Metadata
    $2 = parseMetadata(state);
    state.ok = true;
    if (state.ok) {
      ResultType? $3;
      // Type
      $3 = parseType(state);
      state.ok = true;
      if (state.ok) {
        String? $4;
        // Identifier
        $4 = parseIdentifier(state);
        if (state.ok) {
          // Equal
          fastParseEqual(state);
          if (state.ok) {
            Expression? $5;
            // Expression
            $5 = parseExpression(state);
            if (state.ok) {
              // Semicolon
              fastParseSemicolon(state);
              if (state.ok) {
                ProductionRule? $$;
                final m = $2;
                final t = $3;
                final i = $4!;
                final e = $5!;
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
      state.pos = $1;
    }
    if (!state.ok) {
      // m:Metadata? i:Identifier Equal e:Expression Semicolon {}
      final $6 = state.pos;
      List<({String name, List<Object?> arguments})>? $7;
      // Metadata
      $7 = parseMetadata(state);
      state.ok = true;
      if (state.ok) {
        String? $8;
        // Identifier
        $8 = parseIdentifier(state);
        if (state.ok) {
          // Equal
          fastParseEqual(state);
          if (state.ok) {
            Expression? $9;
            // Expression
            $9 = parseExpression(state);
            if (state.ok) {
              // Semicolon
              fastParseSemicolon(state);
              if (state.ok) {
                ProductionRule? $$;
                final m = $7;
                final i = $8!;
                final e = $9!;
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
        state.pos = $6;
      }
    }
    return $0;
  }

  /// Dollar =
  ///   v:'\$' Spaces
  ///   ;
  String? parseDollar(State<StringReader> state) {
    String? $0;
    // v:'\$' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '\$';
    $2 = matchLiteral1(state, 36, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// ErrorHandler =
  ///   '@errorHandler' OpenParenthesis e:Expression Comma a:Block CloseParenthesis {}
  ///   ;
  Expression? parseErrorHandler(State<StringReader> state) {
    Expression? $0;
    // '@errorHandler' OpenParenthesis e:Expression Comma a:Block CloseParenthesis {}
    final $1 = state.pos;
    const $4 = '@errorHandler';
    matchLiteral(state, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
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
              // CloseParenthesis
              fastParseCloseParenthesis(state);
              if (state.ok) {
                Expression? $$;
                final e = $2!;
                final a = $3!;
                $$ = ErrorHandlerExpression(expression: e, handler: a);
                $0 = $$;
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Exclamation =
  ///   v:'!' Spaces
  ///   ;
  String? parseExclamation(State<StringReader> state) {
    String? $0;
    // v:'!' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '!';
    $2 = matchLiteral1(state, 33, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression =
  ///   OrderedChoice
  ///   ;
  Expression? parseExpression(State<StringReader> state) {
    Expression? $0;
    // OrderedChoice
    // OrderedChoice
    $0 = parseOrderedChoice(state);
    return $0;
  }

  /// ResultType
  /// GenericType =
  ///     i:NativeIdentifier Less p:TypeArguments Greater {}
  ///   / i:NativeIdentifier {}
  ///   ;
  ResultType? parseGenericType(State<StringReader> state) {
    ResultType? $0;
    // i:NativeIdentifier Less p:TypeArguments Greater {}
    final $1 = state.pos;
    String? $2;
    // NativeIdentifier
    $2 = parseNativeIdentifier(state);
    if (state.ok) {
      // Less
      fastParseLess(state);
      if (state.ok) {
        List<ResultType>? $3;
        // TypeArguments
        $3 = parseTypeArguments(state);
        if (state.ok) {
          // Greater
          fastParseGreater(state);
          if (state.ok) {
            ResultType? $$;
            final i = $2!;
            final p = $3!;
            $$ = GenericType(name: i, arguments: p);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // i:NativeIdentifier {}
      String? $5;
      // NativeIdentifier
      $5 = parseNativeIdentifier(state);
      if (state.ok) {
        ResultType? $$;
        final i = $5!;
        $$ = GenericType(name: i);
        $0 = $$;
      }
    }
    return $0;
  }

  /// Globals =
  ///   '%{' v:$(!'}%' v:.)* '}%' Spaces
  ///   ;
  String? parseGlobals(State<StringReader> state) {
    String? $0;
    // '%{' v:$(!'}%' v:.)* '}%' Spaces
    final $1 = state.pos;
    const $3 = '%{';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      final $4 = state.pos;
      const $6 = '}%';
      final $5 = state.input.indexOf($6, state.pos);
      state.ok = $5 != -1;
      if (state.ok) {
        state.pos = $5;
      } else {
        state.failAt(state.input.length, const ErrorExpectedTags([$6]));
      }
      if (state.ok) {
        $2 = state.input.substring($4, state.pos);
      }
      if (state.ok) {
        const $7 = '}%';
        matchLiteral(state, $7, const ErrorExpectedTags([$7]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            $0 = $2;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Group =
  ///   OpenParenthesis e:Expression CloseParenthesis {}
  ///   ;
  Expression? parseGroup(State<StringReader> state) {
    Expression? $0;
    // OpenParenthesis e:Expression CloseParenthesis {}
    final $1 = state.pos;
    // OpenParenthesis
    fastParseOpenParenthesis(state);
    if (state.ok) {
      Expression? $2;
      // Expression
      $2 = parseExpression(state);
      if (state.ok) {
        // CloseParenthesis
        fastParseCloseParenthesis(state);
        if (state.ok) {
          Expression? $$;
          final e = $2!;
          $$ = GroupExpression(expression: e);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// int
  /// HexChar =
  ///   'u{' v:$[a-zA-Z0-9]+ '}' <int>{}
  ///   ;
  int? parseHexChar(State<StringReader> state) {
    int? $0;
    // 'u{' v:$[a-zA-Z0-9]+ '}' <int>{}
    final $1 = state.pos;
    const $3 = 'u{';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      final $4 = state.pos;
      var $5 = false;
      while (true) {
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $6 = state.input.readChar(state.pos);
          state.ok = $6 <= 90
              ? $6 >= 48 && $6 <= 57 || $6 >= 65
              : $6 >= 97 && $6 <= 122;
          if (state.ok) {
            state.pos += state.input.count;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (!state.ok) {
          break;
        }
        $5 = true;
      }
      state.ok = $5;
      if (state.ok) {
        $2 = state.input.substring($4, state.pos);
      }
      if (state.ok) {
        const $7 = '}';
        matchLiteral1(state, 125, $7, const ErrorExpectedTags([$7]));
        if (state.ok) {
          int? $$;
          final v = $2!;
          $$ = int.parse(v, radix: 16);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// String
  /// Identifier =
  ///   i:$([a-zA-Z] [a-zA-Z_0-9]*) Spaces
  ///   ;
  String? parseIdentifier(State<StringReader> state) {
    String? $0;
    // i:$([a-zA-Z] [a-zA-Z_0-9]*) Spaces
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [a-zA-Z] [a-zA-Z_0-9]*
    final $4 = state.pos;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $5 = state.input.readChar(state.pos);
      state.ok = $5 >= 65 && $5 <= 90 || $5 >= 97 && $5 <= 122;
      if (state.ok) {
        state.pos += state.input.count;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      while (state.pos < state.input.length) {
        final $6 = state.input.readChar(state.pos);
        state.ok = $6 <= 90
            ? $6 >= 48 && $6 <= 57 || $6 >= 65
            : $6 == 95 || $6 >= 97 && $6 <= 122;
        if (!state.ok) {
          break;
        }
        state.pos += state.input.count;
      }
      state.fail(const ErrorUnexpectedCharacter());
      state.ok = true;
    }
    if (!state.ok) {
      state.pos = $4;
    }
    if (state.ok) {
      $2 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// int
  /// Integer =
  ///   v:$[0-9]+ {}
  ///   ;
  int? parseInteger(State<StringReader> state) {
    int? $0;
    // v:$[0-9]+ {}
    String? $2;
    final $3 = state.pos;
    var $4 = false;
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $5 = state.input.readChar(state.pos);
        state.ok = $5 >= 48 && $5 <= 57;
        if (state.ok) {
          state.pos += state.input.count;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $4 = true;
    }
    state.ok = $4;
    if (state.ok) {
      $2 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $2!;
      $$ = int.parse(v);
      $0 = $$;
    }
    return $0;
  }

  /// Expression
  /// Literal =
  ///   '\'' cs:(!'\'' c:StringChar)* '\'' Spaces {}
  ///   ;
  Expression? parseLiteral(State<StringReader> state) {
    Expression? $0;
    // '\'' cs:(!'\'' c:StringChar)* '\'' Spaces {}
    final $1 = state.pos;
    const $3 = '\'';
    matchLiteral1(state, 39, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      List<int>? $2;
      final $4 = <int>[];
      while (true) {
        int? $5;
        // !'\'' c:StringChar
        final $6 = state.pos;
        final $8 = state.pos;
        const $10 = '\'';
        matchLiteral1(state, 39, $10, const ErrorExpectedTags([$10]));
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $8 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $8;
        if (state.ok) {
          int? $7;
          // StringChar
          $7 = parseStringChar(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        const $11 = '\'';
        matchLiteral1(state, 39, $11, const ErrorExpectedTags([$11]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            Expression? $$;
            final cs = $2!;
            $$ = LiteralExpression(string: String.fromCharCodes(cs));
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// MatchString =
  ///   '@matchString' OpenParenthesis b:Block CloseParenthesis {}
  ///   ;
  Expression? parseMatchString(State<StringReader> state) {
    Expression? $0;
    // '@matchString' OpenParenthesis b:Block CloseParenthesis {}
    final $1 = state.pos;
    const $3 = '@matchString';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
      if (state.ok) {
        String? $2;
        // Block
        $2 = parseBlock(state);
        if (state.ok) {
          // CloseParenthesis
          fastParseCloseParenthesis(state);
          if (state.ok) {
            Expression? $$;
            final b = $2!;
            $$ = MatchStringExpression(value: b);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Members =
  ///   '%%' v:$(!'%%' v:.)* '%%' Spaces
  ///   ;
  String? parseMembers(State<StringReader> state) {
    String? $0;
    // '%%' v:$(!'%%' v:.)* '%%' Spaces
    final $1 = state.pos;
    const $3 = '%%';
    matchLiteral(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      final $4 = state.pos;
      const $6 = '%%';
      final $5 = state.input.indexOf($6, state.pos);
      state.ok = $5 != -1;
      if (state.ok) {
        state.pos = $5;
      } else {
        state.failAt(state.input.length, const ErrorExpectedTags([$6]));
      }
      if (state.ok) {
        $2 = state.input.substring($4, state.pos);
      }
      if (state.ok) {
        const $7 = '%%';
        matchLiteral(state, $7, const ErrorExpectedTags([$7]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
          if (state.ok) {
            $0 = $2;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<({String name, List<Object?> arguments})>
  /// Metadata =
  ///   h:MetadataElement t:(Spaces v:MetadataElement)* {}
  ///   ;
  List<({String name, List<Object?> arguments})>? parseMetadata(
      State<StringReader> state) {
    List<({String name, List<Object?> arguments})>? $0;
    // h:MetadataElement t:(Spaces v:MetadataElement)* {}
    final $1 = state.pos;
    ({String name, List<Object?> arguments})? $2;
    // MetadataElement
    $2 = parseMetadataElement(state);
    if (state.ok) {
      List<({String name, List<Object?> arguments})>? $3;
      final $4 = <({String name, List<Object?> arguments})>[];
      while (true) {
        ({String name, List<Object?> arguments})? $5;
        // Spaces v:MetadataElement
        final $6 = state.pos;
        // Spaces
        fastParseSpaces(state);
        if (state.ok) {
          ({String name, List<Object?> arguments})? $7;
          // MetadataElement
          $7 = parseMetadataElement(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        List<({String name, List<Object?> arguments})>? $$;
        final h = $2!;
        final t = $3!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// MetadataArgument =
  ///   '\'' v:StringChar* SingleQuote {}
  ///   ;
  Object? parseMetadataArgument(State<StringReader> state) {
    Object? $0;
    // '\'' v:StringChar* SingleQuote {}
    final $1 = state.pos;
    const $3 = '\'';
    matchLiteral1(state, 39, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      List<int>? $2;
      final $4 = <int>[];
      while (true) {
        int? $5;
        // StringChar
        $5 = parseStringChar(state);
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        // SingleQuote
        fastParseSingleQuote(state);
        if (state.ok) {
          Object? $$;
          final v = $2!;
          $$ = String.fromCharCodes(v);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<Object?>
  /// MetadataArgumentList =
  ///   h:MetadataArgument t:(Comma v:MetadataArgument)* {}
  ///   ;
  List<Object?>? parseMetadataArgumentList(State<StringReader> state) {
    List<Object?>? $0;
    // h:MetadataArgument t:(Comma v:MetadataArgument)* {}
    final $1 = state.pos;
    Object? $2;
    // MetadataArgument
    $2 = parseMetadataArgument(state);
    if (state.ok) {
      List<Object?>? $3;
      final $4 = <Object?>[];
      while (true) {
        Object? $5;
        // Comma v:MetadataArgument
        final $6 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          Object? $7;
          // MetadataArgument
          $7 = parseMetadataArgument(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        List<Object?>? $$;
        final h = $2;
        final t = $3!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<Object?>
  /// MetadataArguments =
  ///   OpenParenthesis v:MetadataArgumentList? CloseParenthesis {}
  ///   ;
  List<Object?>? parseMetadataArguments(State<StringReader> state) {
    List<Object?>? $0;
    // OpenParenthesis v:MetadataArgumentList? CloseParenthesis {}
    final $1 = state.pos;
    // OpenParenthesis
    fastParseOpenParenthesis(state);
    if (state.ok) {
      List<Object?>? $2;
      // MetadataArgumentList
      $2 = parseMetadataArgumentList(state);
      state.ok = true;
      if (state.ok) {
        // CloseParenthesis
        fastParseCloseParenthesis(state);
        if (state.ok) {
          List<Object?>? $$;
          final v = $2;
          $$ = v ?? const [];
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// ({String name, List<Object?> arguments})
  /// MetadataElement =
  ///   AtSign i:Identifier a:MetadataArguments? {}
  ///   ;
  ({String name, List<Object?> arguments})? parseMetadataElement(
      State<StringReader> state) {
    ({String name, List<Object?> arguments})? $0;
    // AtSign i:Identifier a:MetadataArguments? {}
    final $1 = state.pos;
    // AtSign
    fastParseAtSign(state);
    if (state.ok) {
      String? $2;
      // Identifier
      $2 = parseIdentifier(state);
      if (state.ok) {
        List<Object?>? $3;
        // MetadataArguments
        $3 = parseMetadataArguments(state);
        state.ok = true;
        if (state.ok) {
          ({String name, List<Object?> arguments})? $$;
          final i = $2!;
          final a = $3;
          $$ = (name: '@$i', arguments: a ?? const []);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
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
  (int?, int?)? parseMinMax(State<StringReader> state) {
    (int?, int?)? $0;
    // m:Integer Comma n:Integer {}
    final $1 = state.pos;
    int? $2;
    // Integer
    $2 = parseInteger(state);
    if (state.ok) {
      // Comma
      fastParseComma(state);
      if (state.ok) {
        int? $3;
        // Integer
        $3 = parseInteger(state);
        if (state.ok) {
          (int?, int?)? $$;
          final m = $2!;
          final n = $3!;
          $$ = (m, n);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // Comma n:Integer {}
      final $4 = state.pos;
      // Comma
      fastParseComma(state);
      if (state.ok) {
        int? $5;
        // Integer
        $5 = parseInteger(state);
        if (state.ok) {
          (int?, int?)? $$;
          final n = $5!;
          $$ = (null, n);
          $0 = $$;
        }
      }
      if (!state.ok) {
        state.pos = $4;
      }
      if (!state.ok) {
        // m:Integer Comma {}
        final $6 = state.pos;
        int? $7;
        // Integer
        $7 = parseInteger(state);
        if (state.ok) {
          // Comma
          fastParseComma(state);
          if (state.ok) {
            (int?, int?)? $$;
            final m = $7!;
            $$ = (m, null);
            $0 = $$;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          // n:Integer {}
          int? $9;
          // Integer
          $9 = parseInteger(state);
          if (state.ok) {
            (int?, int?)? $$;
            final n = $9!;
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
  ({ResultType type, String name})? parseNamedField(State<StringReader> state) {
    ({ResultType type, String name})? $0;
    // type:Type name:NativeIdentifier
    final $1 = state.pos;
    ResultType? $2;
    // Type
    $2 = parseType(state);
    if (state.ok) {
      String? $3;
      // NativeIdentifier
      $3 = parseNativeIdentifier(state);
      if (state.ok) {
        $0 = (type: $2!, name: $3!);
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<({ResultType type, String name})>
  /// NamedFields =
  ///   OpenBrace h:NamedField t:(Comma v:NamedField)* CloseBrace {}
  ///   ;
  List<({ResultType type, String name})>? parseNamedFields(
      State<StringReader> state) {
    List<({ResultType type, String name})>? $0;
    // OpenBrace h:NamedField t:(Comma v:NamedField)* CloseBrace {}
    final $1 = state.pos;
    // OpenBrace
    fastParseOpenBrace(state);
    if (state.ok) {
      ({ResultType type, String name})? $2;
      // NamedField
      $2 = parseNamedField(state);
      if (state.ok) {
        List<({ResultType type, String name})>? $3;
        final $4 = <({ResultType type, String name})>[];
        while (true) {
          ({ResultType type, String name})? $5;
          // Comma v:NamedField
          final $6 = state.pos;
          // Comma
          fastParseComma(state);
          if (state.ok) {
            ({ResultType type, String name})? $7;
            // NamedField
            $7 = parseNamedField(state);
            if (state.ok) {
              $5 = $7;
            }
          }
          if (!state.ok) {
            state.pos = $6;
          }
          if (!state.ok) {
            state.ok = true;
            break;
          }
          $4.add($5!);
        }
        if (state.ok) {
          $3 = $4;
        }
        if (state.ok) {
          // CloseBrace
          fastParseCloseBrace(state);
          if (state.ok) {
            List<({ResultType type, String name})>? $$;
            final h = $2!;
            final t = $3!;
            $$ = [h, ...t];
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// String
  /// NativeIdentifier =
  ///   i:$([$a-zA-Z_] [$0-9a-zA-Z_]*) Spaces
  ///   ;
  String? parseNativeIdentifier(State<StringReader> state) {
    String? $0;
    // i:$([$a-zA-Z_] [$0-9a-zA-Z_]*) Spaces
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [$a-zA-Z_] [$0-9a-zA-Z_]*
    final $4 = state.pos;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $5 = state.input.readChar(state.pos);
      state.ok =
          $5 <= 90 ? $5 == 36 || $5 >= 65 : $5 == 95 || $5 >= 97 && $5 <= 122;
      if (state.ok) {
        state.pos += state.input.count;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      while (state.pos < state.input.length) {
        final $6 = state.input.readChar(state.pos);
        state.ok = $6 <= 90
            ? $6 <= 57
                ? $6 == 36 || $6 >= 48
                : $6 >= 65
            : $6 == 95 || $6 >= 97 && $6 <= 122;
        if (!state.ok) {
          break;
        }
        state.pos += state.input.count;
      }
      state.fail(const ErrorUnexpectedCharacter());
      state.ok = true;
    }
    if (!state.ok) {
      state.pos = $4;
    }
    if (state.ok) {
      $2 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// OrderedChoice =
  ///   h:Sequence t:(Slash v:Sequence)* {}
  ///   ;
  Expression? parseOrderedChoice(State<StringReader> state) {
    Expression? $0;
    // h:Sequence t:(Slash v:Sequence)* {}
    final $1 = state.pos;
    Expression? $2;
    // Sequence
    $2 = parseSequence(state);
    if (state.ok) {
      List<Expression>? $3;
      final $4 = <Expression>[];
      while (true) {
        Expression? $5;
        // Slash v:Sequence
        final $6 = state.pos;
        // Slash
        fastParseSlash(state);
        if (state.ok) {
          Expression? $7;
          // Sequence
          $7 = parseSequence(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        Expression? $$;
        final h = $2!;
        final t = $3!;
        $$ = OrderedChoiceExpression(expressions: [h, ...t]);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Plus =
  ///   v:'+' Spaces
  ///   ;
  String? parsePlus(State<StringReader> state) {
    String? $0;
    // v:'+' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '+';
    $2 = matchLiteral1(state, 43, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// ({ResultType type, String? name})
  /// PositionalField =
  ///   type:Type name:NativeIdentifier?
  ///   ;
  ({ResultType type, String? name})? parsePositionalField(
      State<StringReader> state) {
    ({ResultType type, String? name})? $0;
    // type:Type name:NativeIdentifier?
    final $1 = state.pos;
    ResultType? $2;
    // Type
    $2 = parseType(state);
    if (state.ok) {
      String? $3;
      // NativeIdentifier
      $3 = parseNativeIdentifier(state);
      state.ok = true;
      if (state.ok) {
        $0 = (type: $2!, name: $3);
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<({ResultType type, String? name})>
  /// PositionalFields =
  ///   h:PositionalField t:(Comma v:PositionalField)* {}
  ///   ;
  List<({ResultType type, String? name})>? parsePositionalFields(
      State<StringReader> state) {
    List<({ResultType type, String? name})>? $0;
    // h:PositionalField t:(Comma v:PositionalField)* {}
    final $1 = state.pos;
    ({ResultType type, String? name})? $2;
    // PositionalField
    $2 = parsePositionalField(state);
    if (state.ok) {
      List<({ResultType type, String? name})>? $3;
      final $4 = <({ResultType type, String? name})>[];
      while (true) {
        ({ResultType type, String? name})? $5;
        // Comma v:PositionalField
        final $6 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          ({ResultType type, String? name})? $7;
          // PositionalField
          $7 = parsePositionalField(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        List<({ResultType type, String? name})>? $$;
        final h = $2!;
        final t = $3!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Prefix =
  ///   p:(Dollar / Ampersand / Exclamation)? s:Suffix {}
  ///   ;
  Expression? parsePrefix(State<StringReader> state) {
    Expression? $0;
    // p:(Dollar / Ampersand / Exclamation)? s:Suffix {}
    final $1 = state.pos;
    String? $2;
    // Dollar
    // Dollar
    $2 = parseDollar(state);
    if (!state.ok) {
      // Ampersand
      // Ampersand
      $2 = parseAmpersand(state);
      if (!state.ok) {
        // Exclamation
        // Exclamation
        $2 = parseExclamation(state);
      }
    }
    state.ok = true;
    if (state.ok) {
      Expression? $3;
      // Suffix
      $3 = parseSuffix(state);
      if (state.ok) {
        Expression? $$;
        final p = $2;
        final s = $3!;
        $$ = _buildPrefix(p, s);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
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
  ///   / Buffer
  ///   / ErrorHandler
  ///   / MatchString
  ///   / SepBy
  ///   / StringChars
  ///   / Verify
  ///   ;
  Expression? parsePrimary(State<StringReader> state) {
    Expression? $0;
    // Symbol
    // Symbol
    $0 = parseSymbol(state);
    if (!state.ok) {
      // CharacterClass
      // CharacterClass
      $0 = parseCharacterClass(state);
      if (!state.ok) {
        // Literal
        // Literal
        $0 = parseLiteral(state);
        if (!state.ok) {
          // CharacterClass
          // CharacterClass
          $0 = parseCharacterClass(state);
          if (!state.ok) {
            // AnyCharacter
            // AnyCharacter
            $0 = parseAnyCharacter(state);
            if (!state.ok) {
              // Group
              // Group
              $0 = parseGroup(state);
              if (!state.ok) {
                // Buffer
                // Buffer
                $0 = parseBuffer(state);
                if (!state.ok) {
                  // ErrorHandler
                  // ErrorHandler
                  $0 = parseErrorHandler(state);
                  if (!state.ok) {
                    // MatchString
                    // MatchString
                    $0 = parseMatchString(state);
                    if (!state.ok) {
                      // SepBy
                      // SepBy
                      $0 = parseSepBy(state);
                      if (!state.ok) {
                        // StringChars
                        // StringChars
                        $0 = parseStringChars(state);
                        if (!state.ok) {
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
    return $0;
  }

  /// Question =
  ///   v:'?' Spaces
  ///   ;
  String? parseQuestion(State<StringReader> state) {
    String? $0;
    // v:'?' Spaces
    final $1 = state.pos;
    String? $2;
    const $3 = '?';
    $2 = matchLiteral1(state, 63, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// (int, int)
  /// Range =
  ///     s:RangeChar '-' e:RangeChar {}
  ///   / s:RangeChar {}
  ///   ;
  (int, int)? parseRange(State<StringReader> state) {
    (int, int)? $0;
    // s:RangeChar '-' e:RangeChar {}
    final $1 = state.pos;
    int? $2;
    // RangeChar
    $2 = parseRangeChar(state);
    if (state.ok) {
      const $4 = '-';
      matchLiteral1(state, 45, $4, const ErrorExpectedTags([$4]));
      if (state.ok) {
        int? $3;
        // RangeChar
        $3 = parseRangeChar(state);
        if (state.ok) {
          (int, int)? $$;
          final s = $2!;
          final e = $3!;
          $$ = (s, e);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
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
  int? parseRangeChar(State<StringReader> state) {
    int? $0;
    // '\\' v:(c:[-nrt\]\\^] <int>{} / HexChar)
    final $1 = state.pos;
    const $3 = '\\';
    matchLiteral1(state, 92, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      int? $2;
      // c:[-nrt\]\\^] <int>{}
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $5 = state.input.readChar(state.pos);
        state.ok = $5 == 110 ||
            ($5 < 110
                ? $5 <= 94
                    ? $5 == 45 || $5 >= 92
                    : false
                : $5 == 114 || $5 == 116);
        if (state.ok) {
          state.pos += state.input.count;
          $2 = $5;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $$;
        final c = $2!;
        $$ = _escape(c);
        $2 = $$;
      }
      if (!state.ok) {
        // HexChar
        // HexChar
        $2 = parseHexChar(state);
      }
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // !'\\' c:.
      final $7 = state.pos;
      final $9 = state.pos;
      const $11 = '\\';
      matchLiteral1(state, 92, $11, const ErrorExpectedTags([$11]));
      state.ok = !state.ok;
      if (!state.ok) {
        final length = $9 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          1 => const ErrorUnexpectedInput(1),
          2 => const ErrorUnexpectedInput(2),
          _ => ErrorUnexpectedInput(length)
        });
      }
      state.pos = $9;
      if (state.ok) {
        int? $8;
        final $12 = state.input;
        if (state.pos < $12.length) {
          $8 = $12.readChar(state.pos);
          state.pos += $12.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $0 = $8;
        }
      }
      if (!state.ok) {
        state.pos = $7;
      }
    }
    return $0;
  }

  /// ResultType
  /// RecordType =
  ///   OpenParenthesis v:(n:NamedFields <RecordType>{} / p:PositionalFields Comma n:NamedFields <RecordType>{} / h:PositionalField Comma t:PositionalFields <RecordType>{} / t:PositionalField Comma <RecordType>{}) CloseParenthesis
  ///   ;
  ResultType? parseRecordType(State<StringReader> state) {
    ResultType? $0;
    // OpenParenthesis v:(n:NamedFields <RecordType>{} / p:PositionalFields Comma n:NamedFields <RecordType>{} / h:PositionalField Comma t:PositionalFields <RecordType>{} / t:PositionalField Comma <RecordType>{}) CloseParenthesis
    final $1 = state.pos;
    // OpenParenthesis
    fastParseOpenParenthesis(state);
    if (state.ok) {
      RecordType? $2;
      // n:NamedFields <RecordType>{}
      List<({ResultType type, String name})>? $4;
      // NamedFields
      $4 = parseNamedFields(state);
      if (state.ok) {
        RecordType? $$;
        final n = $4!;
        $$ = RecordType(named: n);
        $2 = $$;
      }
      if (!state.ok) {
        // p:PositionalFields Comma n:NamedFields <RecordType>{}
        final $5 = state.pos;
        List<({ResultType type, String? name})>? $6;
        // PositionalFields
        $6 = parsePositionalFields(state);
        if (state.ok) {
          // Comma
          fastParseComma(state);
          if (state.ok) {
            List<({ResultType type, String name})>? $7;
            // NamedFields
            $7 = parseNamedFields(state);
            if (state.ok) {
              RecordType? $$;
              final p = $6!;
              final n = $7!;
              $$ = RecordType(positional: p, named: n);
              $2 = $$;
            }
          }
        }
        if (!state.ok) {
          state.pos = $5;
        }
        if (!state.ok) {
          // h:PositionalField Comma t:PositionalFields <RecordType>{}
          final $8 = state.pos;
          ({ResultType type, String? name})? $9;
          // PositionalField
          $9 = parsePositionalField(state);
          if (state.ok) {
            // Comma
            fastParseComma(state);
            if (state.ok) {
              List<({ResultType type, String? name})>? $10;
              // PositionalFields
              $10 = parsePositionalFields(state);
              if (state.ok) {
                RecordType? $$;
                final h = $9!;
                final t = $10!;
                $$ = RecordType(positional: [h, ...t]);
                $2 = $$;
              }
            }
          }
          if (!state.ok) {
            state.pos = $8;
          }
          if (!state.ok) {
            // t:PositionalField Comma <RecordType>{}
            final $11 = state.pos;
            ({ResultType type, String? name})? $12;
            // PositionalField
            $12 = parsePositionalField(state);
            if (state.ok) {
              // Comma
              fastParseComma(state);
              if (state.ok) {
                RecordType? $$;
                final t = $12!;
                $$ = RecordType(positional: [t]);
                $2 = $$;
              }
            }
            if (!state.ok) {
              state.pos = $11;
            }
          }
        }
      }
      if (state.ok) {
        // CloseParenthesis
        fastParseCloseParenthesis(state);
        if (state.ok) {
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// SepBy =
  ///   '@sepBy' OpenParenthesis e:Expression Comma s:Expression CloseParenthesis {}
  ///   ;
  Expression? parseSepBy(State<StringReader> state) {
    Expression? $0;
    // '@sepBy' OpenParenthesis e:Expression Comma s:Expression CloseParenthesis {}
    final $1 = state.pos;
    const $4 = '@sepBy';
    matchLiteral(state, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
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
              // CloseParenthesis
              fastParseCloseParenthesis(state);
              if (state.ok) {
                Expression? $$;
                final e = $2!;
                final s = $3!;
                $$ = SepByExpression(expression: e, separator: s);
                $0 = $$;
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Sequence =
  ///   e:SequenceElement+ a:Action? {}
  ///   ;
  Expression? parseSequence(State<StringReader> state) {
    Expression? $0;
    // e:SequenceElement+ a:Action? {}
    final $1 = state.pos;
    List<Expression>? $2;
    final $4 = <Expression>[];
    while (true) {
      Expression? $5;
      // SequenceElement
      $5 = parseSequenceElement(state);
      if (!state.ok) {
        break;
      }
      $4.add($5!);
    }
    state.ok = $4.isNotEmpty;
    if (state.ok) {
      $2 = $4;
    }
    if (state.ok) {
      SemanticAction? $3;
      // Action
      $3 = parseAction(state);
      state.ok = true;
      if (state.ok) {
        Expression? $$;
        final e = $2!;
        final a = $3;
        $$ = SequenceExpression(expressions: e, action: a);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// SequenceElement =
  ///     i:Identifier Colon p:Prefix <Expression>{}
  ///   / Prefix
  ///   ;
  Expression? parseSequenceElement(State<StringReader> state) {
    Expression? $0;
    // i:Identifier Colon p:Prefix <Expression>{}
    final $1 = state.pos;
    String? $2;
    // Identifier
    $2 = parseIdentifier(state);
    if (state.ok) {
      // Colon
      fastParseColon(state);
      if (state.ok) {
        Expression? $3;
        // Prefix
        $3 = parsePrefix(state);
        if (state.ok) {
          Expression? $$;
          final i = $2!;
          final p = $3!;
          $$ = p..semanticVariable = i;
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // Prefix
      // Prefix
      $0 = parsePrefix(state);
    }
    return $0;
  }

  /// Grammar
  /// Start =
  ///   Spaces g:Globals? m:Members? d:Definition* !. {}
  ///   ;
  Grammar? parseStart(State<StringReader> state) {
    Grammar? $0;
    // Spaces g:Globals? m:Members? d:Definition* !. {}
    final $1 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      String? $2;
      // Globals
      $2 = parseGlobals(state);
      state.ok = true;
      if (state.ok) {
        String? $3;
        // Members
        $3 = parseMembers(state);
        state.ok = true;
        if (state.ok) {
          List<ProductionRule>? $4;
          final $5 = <ProductionRule>[];
          while (true) {
            ProductionRule? $6;
            // Definition
            $6 = parseDefinition(state);
            if (!state.ok) {
              state.ok = true;
              break;
            }
            $5.add($6!);
          }
          if (state.ok) {
            $4 = $5;
          }
          if (state.ok) {
            final $7 = state.pos;
            final $9 = state.input;
            if (state.pos < $9.length) {
              $9.readChar(state.pos);
              state.pos += $9.count;
              state.ok = true;
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $7 - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $7;
            if (state.ok) {
              Grammar? $$;
              final g = $2;
              final m = $3;
              final d = $4!;
              $$ = Grammar(rules: d, globals: g, members: m);
              $0 = $$;
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// int
  /// StringChar =
  ///     [ -[\]-\u{10ffff}]
  ///   / '\\' v:(c:[rnt'"\\] <int>{} / HexChar)
  ///   ;
  int? parseStringChar(State<StringReader> state) {
    int? $0;
    // [ -[\]-\u{10ffff}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.readChar(state.pos);
      state.ok = $2 >= 32 && $2 <= 91 || $2 >= 93 && $2 <= 1114111;
      if (state.ok) {
        state.pos += state.input.count;
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok) {
      // '\\' v:(c:[rnt'"\\] <int>{} / HexChar)
      final $3 = state.pos;
      const $5 = '\\';
      matchLiteral1(state, 92, $5, const ErrorExpectedTags([$5]));
      if (state.ok) {
        int? $4;
        // c:[rnt'"\\] <int>{}
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $7 = state.input.readChar(state.pos);
          state.ok = $7 == 92 ||
              ($7 < 92
                  ? $7 == 39 || $7 == 34
                  : $7 == 114 || ($7 < 114 ? $7 == 110 : $7 == 116));
          if (state.ok) {
            state.pos += state.input.count;
            $4 = $7;
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
        if (!state.ok) {
          // HexChar
          // HexChar
          $4 = parseHexChar(state);
        }
        if (state.ok) {
          $0 = $4;
        }
      }
      if (!state.ok) {
        state.pos = $3;
      }
    }
    return $0;
  }

  /// Expression
  /// StringChars =
  ///   '@stringChars' OpenParenthesis n:Expression Comma c:Expression Comma e:Expression CloseParenthesis {}
  ///   ;
  Expression? parseStringChars(State<StringReader> state) {
    Expression? $0;
    // '@stringChars' OpenParenthesis n:Expression Comma c:Expression Comma e:Expression CloseParenthesis {}
    final $1 = state.pos;
    const $5 = '@stringChars';
    matchLiteral(state, $5, const ErrorExpectedTags([$5]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
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
              // Comma
              fastParseComma(state);
              if (state.ok) {
                Expression? $4;
                // Expression
                $4 = parseExpression(state);
                if (state.ok) {
                  // CloseParenthesis
                  fastParseCloseParenthesis(state);
                  if (state.ok) {
                    Expression? $$;
                    final n = $2!;
                    final c = $3!;
                    final e = $4!;
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
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Suffix =
  ///   p:Primary s:(Asterisk / Question / Plus / OpenBrace v:MinMax CloseBrace)? {}
  ///   ;
  Expression? parseSuffix(State<StringReader> state) {
    Expression? $0;
    // p:Primary s:(Asterisk / Question / Plus / OpenBrace v:MinMax CloseBrace)? {}
    final $1 = state.pos;
    Expression? $2;
    // Primary
    $2 = parsePrimary(state);
    if (state.ok) {
      Object? $3;
      // Asterisk
      // Asterisk
      $3 = parseAsterisk(state);
      if (!state.ok) {
        // Question
        // Question
        $3 = parseQuestion(state);
        if (!state.ok) {
          // Plus
          // Plus
          $3 = parsePlus(state);
          if (!state.ok) {
            // OpenBrace v:MinMax CloseBrace
            final $7 = state.pos;
            // OpenBrace
            fastParseOpenBrace(state);
            if (state.ok) {
              (int?, int?)? $8;
              // MinMax
              $8 = parseMinMax(state);
              if (state.ok) {
                // CloseBrace
                fastParseCloseBrace(state);
                if (state.ok) {
                  $3 = $8;
                }
              }
            }
            if (!state.ok) {
              state.pos = $7;
            }
          }
        }
      }
      state.ok = true;
      if (state.ok) {
        Expression? $$;
        final p = $2!;
        final s = $3;
        $$ = _buildSuffix(s, p);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Symbol =
  ///   i:Identifier {}
  ///   ;
  Expression? parseSymbol(State<StringReader> state) {
    Expression? $0;
    // i:Identifier {}
    String? $2;
    // Identifier
    $2 = parseIdentifier(state);
    if (state.ok) {
      Expression? $$;
      final i = $2!;
      $$ = SymbolExpression(name: i);
      $0 = $$;
    }
    return $0;
  }

  /// ResultType
  /// Type =
  ///   t:(GenericType / RecordType) q:Question? {}
  ///   ;
  ResultType? parseType(State<StringReader> state) {
    ResultType? $0;
    // t:(GenericType / RecordType) q:Question? {}
    final $1 = state.pos;
    ResultType? $2;
    // GenericType
    // GenericType
    $2 = parseGenericType(state);
    if (!state.ok) {
      // RecordType
      // RecordType
      $2 = parseRecordType(state);
    }
    if (state.ok) {
      String? $3;
      // Question
      $3 = parseQuestion(state);
      state.ok = true;
      if (state.ok) {
        ResultType? $$;
        final t = $2!;
        final q = $3;
        $$ = q == null ? t : t.getNullableType();
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// List<ResultType>
  /// TypeArguments =
  ///   h:Type t:(Comma v:Type)* {}
  ///   ;
  List<ResultType>? parseTypeArguments(State<StringReader> state) {
    List<ResultType>? $0;
    // h:Type t:(Comma v:Type)* {}
    final $1 = state.pos;
    ResultType? $2;
    // Type
    $2 = parseType(state);
    if (state.ok) {
      List<ResultType>? $3;
      final $4 = <ResultType>[];
      while (true) {
        ResultType? $5;
        // Comma v:Type
        final $6 = state.pos;
        // Comma
        fastParseComma(state);
        if (state.ok) {
          ResultType? $7;
          // Type
          $7 = parseType(state);
          if (state.ok) {
            $5 = $7;
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        List<ResultType>? $$;
        final h = $2!;
        final t = $3!;
        $$ = [h, ...t];
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression
  /// Verify =
  ///   '@verify' OpenParenthesis e:Expression Comma a:Block CloseParenthesis {}
  ///   ;
  Expression? parseVerify(State<StringReader> state) {
    Expression? $0;
    // '@verify' OpenParenthesis e:Expression Comma a:Block CloseParenthesis {}
    final $1 = state.pos;
    const $4 = '@verify';
    matchLiteral(state, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      // OpenParenthesis
      fastParseOpenParenthesis(state);
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
              // CloseParenthesis
              fastParseCloseParenthesis(state);
              if (state.ok) {
                Expression? $$;
                final e = $2!;
                final a = $3!;
                $$ = VerifyExpression(expression: e, handler: a);
                $0 = $$;
              }
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar(State<StringReader> state, int char, ParseError error) {
    final input = state.input;
    state.ok = input.matchChar(char, state.pos);
    if (state.ok) {
      state.pos += input.count;
      return char;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchCharAsync(
      State<ChunkedParsingSink> state, int char, ParseError error) {
    final input = state.input;
    state.ok = state.pos < input.end;
    if (state.ok) {
      final c = input.data.runeAt(state.pos - input.start);
      state.ok = c == char;
      if (state.ok) {
        state.pos += c > 0xffff ? 2 : 1;
        return char;
      }
    }
    if (!state.ok) {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral(
      State<StringReader> state, String string, ParseError error) {
    final input = state.input;
    state.ok = input.startsWith(string, state.pos);
    if (state.ok) {
      state.pos += input.count;
      return string;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1(
      State<StringReader> state, int char, String string, ParseError error) {
    final input = state.input;
    state.ok = state.pos < input.length && input.readChar(state.pos) == char;
    if (state.ok) {
      state.pos += input.count;
      state.ok = true;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1Async(State<ChunkedParsingSink> state, int char,
      String string, ParseError error) {
    final input = state.input;
    state.ok = state.pos < input.end &&
        input.data.runeAt(state.pos - input.start) == char;
    if (state.ok) {
      state.pos += char > 0xffff ? 2 : 1;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteralAsync(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    state.ok = state.pos <= input.end &&
        input.data.startsWith(string, state.pos - input.start);
    if (state.ok) {
      state.pos += string.length;
      return string;
    }
    state.fail(error);
    return null;
  }
}

void fastParseString(
    void Function(State<StringReader> state) fastParse, String source) {
  final input = StringReader(source);
  final result = tryParse(fastParse, input);
  result.getResult();
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

O parseString<O>(O? Function(State<StringReader> state) parse, String source) {
  final input = StringReader(source);
  final result = tryParse(parse, input);
  return result.getResult();
}

ParseResult<I, O> tryParse<I, O>(O? Function(State<I> state) parse, I input) {
  final result = _parse<I, O>(parse, input);
  return result;
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
  if (input is StringReader) {
    if (input.hasSource) {
      final source2 = _StringWrapper(
        invalidChar: 32,
        leftPadding: 0,
        rightPadding: 0,
        source: input.source,
      );
      message = _errorMessage(source2, offset, normalized);
    } else {
      message = _errorMessageWithoutSource(input, offset, normalized);
    }
  } else if (input is ChunkedParsingSink) {
    final source2 = _StringWrapper(
      invalidChar: 32,
      leftPadding: input.start,
      rightPadding: 0,
      source: input.data,
    );
    message = _errorMessage(source2, offset, normalized);
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
    _StringWrapper source, int offset, List<ErrorMessage> errors) {
  final sb = StringBuffer();
  final errorInfoList = errors
      .map((e) => (length: e.length, message: e.toString()))
      .toSet()
      .toList();
  final hasFullSource = source.leftPadding == 0 && source.rightPadding == 0;
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
    var row = 1;
    var lineStart = 0, next = 0, pos = 0;
    if (hasFullSource) {
      while (pos < source.length) {
        final c = source.codeUnitAt(pos++);
        if (c == 0xa || c == 0xd) {
          next = c == 0xa ? 0xd : 0xa;
          if (pos < source.length && source.codeUnitAt(pos) == next) {
            pos++;
          }
          if (pos - 1 >= start) {
            break;
          }
          row++;
          lineStart = pos;
        }
      }
    }

    final inputLen = source.length;
    final lineLimit = min(80, inputLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final extraLen = lineLimit - errorLen;
    final rightLen = min(inputLen - end2, extraLen - (extraLen >> 1));
    final leftLen = min(start, max(0, lineLimit - errorLen - rightLen));
    var index = start2 - 1;
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

    final column = start - lineStart + 1;
    final left = String.fromCharCodes(list.reversed);
    final end3 = min(inputLen, start2 + (lineLimit - leftLen));
    final indicatorLen = max(1, errorLen);
    final right = source.substring(start2, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    if (hasFullSource) {
      sb.writeln('line $row, column $column: $message');
    } else {
      sb.writeln('offset $start: $message');
    }

    sb.writeln(text);
    sb.write(' ' * leftLen + '^' * indicatorLen);
  }

  return sb.toString();
}

String _errorMessageWithoutSource(
    StringReader input, int offset, List<ErrorMessage> errors) {
  final sb = StringBuffer();
  final errorInfoList = errors
      .map((e) => (length: e.length, message: e.toString()))
      .toSet()
      .toList();
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
    final inputLen = input.length;
    final lineLimit = min(80, inputLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final indicatorLen = max(1, errorLen);
    var text = input.substring(start, lineLimit);
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    sb.writeln('offset $offset: $message');
    sb.writeln(text);
    sb.write('^' * indicatorLen);
  }

  return sb.toString();
}

List<ParseError> _normalize<I>(I input, int offset, List<ParseError> errors) {
  final errorList = errors.toList();
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
    if (error is ErrorExpectedCharacter) {
      key = (ErrorExpectedCharacter, error.char);
    } else if (error is ErrorUnexpectedInput) {
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

ParseResult<I, O> _parse<I, O>(O? Function(State<I> input) parse, I input) {
  final state = State(input);
  final result = parse(state);
  return _createParseResult<I, O>(state, result);
}

class AsyncResult<T> {
  bool isComplete = false;

  void Function()? onComplete;

  T? value;
}

abstract interface class ByteReader {
  int get length;

  int readByte(int offset);
}

class ChunkedParsingSink implements Sink<String> {
  String data = '';

  int end = 0;

  void Function()? handle;

  bool sleep = false;

  int start = 0;

  int _buffering = 0;

  bool _isClosed = false;

  int _lastPosition = 0;

  bool get isClosed => _isClosed;

  @override
  void add(String data) {
    if (_isClosed) {
      throw StateError('Chunked data sink already closed');
    }

    if (_lastPosition > start) {
      if (_lastPosition == end) {
        this.data = '';
      } else {
        this.data = this.data.substring(_lastPosition - start);
      }

      start = _lastPosition;
    }

    if (this.data.isEmpty) {
      this.data = data;
    } else {
      this.data = '${this.data}$data';
    }

    end = start + this.data.length;
    sleep = false;
    while (!sleep) {
      final h = handle;
      handle = null;
      if (h == null) {
        break;
      }

      h();
    }

    if (_buffering == 0) {
      //
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void beginBuffering() {
    _buffering++;
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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void endBuffering(int position) {
    _buffering--;
    if (_buffering == 0) {
      if (_lastPosition < position) {
        _lastPosition = position;
      }
    } else if (_buffering < 0) {
      throw StateError('Inconsistent buffering completion detected.');
    }
  }
}

class ErrorExpectedCharacter extends ParseError {
  static const message = 'Expected a character {0}';

  final int char;

  const ErrorExpectedCharacter(this.char);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    final value = ParseError.escape(char);
    final hexValue = char.toRadixString(16);
    final argument = '$value (0x$hexValue)';
    return ErrorMessage(0, ErrorExpectedCharacter.message, [argument]);
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
    if (offset != null && offset > 0) {
      if (input is StringReader && input.hasSource) {
        if (offset < input.length) {
          char = input.readChar(offset);
        } else {
          argument = '<EOF>';
        }
      } else if (input is ChunkedParsingSink) {
        final data = input.data;
        final length = input.isClosed ? input.end : -1;
        if (length != -1) {
          if (offset < length) {
            final source = _StringWrapper(
              invalidChar: 32,
              leftPadding: input.start,
              rightPadding: 0,
              source: data,
            );
            if (source.hasCodeUnitAt(offset)) {
              char = source.runeAt(offset);
            }
          } else {
            argument = '<EOF>';
          }
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
  Object? context;

  final List<ParseError?> errors = List.filled(64, null, growable: false);

  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool ok = false;

  int pos = 0;

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool fail(ParseError error) {
    ok = false;
    if (pos >= failPos) {
      if (failPos < pos) {
        failPos = pos;
        errorCount = 0;
      }
      if (errorCount < errors.length) {
        errors[errorCount++] = error;
      }
    }
    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAll(List<ParseError> errors) {
    ok = false;
    if (pos >= failPos) {
      if (failPos < pos) {
        failPos = pos;
        errorCount = 0;
      }
      for (var i = 0; i < errors.length; i++) {
        if (errorCount < errors.length) {
          this.errors[errorCount++] = errors[i];
        }
      }
    }
    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAllAt(int offset, List<ParseError> errors) {
    ok = false;
    if (offset >= failPos) {
      if (failPos < offset) {
        failPos = offset;
        errorCount = 0;
      }
      for (var i = 0; i < errors.length; i++) {
        if (errorCount < errors.length) {
          this.errors[errorCount++] = errors[i];
        }
      }
    }
    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAt(int offset, ParseError error) {
    ok = false;
    if (offset >= failPos) {
      if (failPos < offset) {
        failPos = offset;
        errorCount = 0;
      }
      if (errorCount < errors.length) {
        errors[errorCount++] = error;
      }
    }
    return false;
  }

  List<ParseError> getErrors() {
    return List.generate(errorCount, (i) => errors[i]!);
  }

  @override
  String toString() {
    if (input case final StringReader input) {
      if (input.hasSource) {
        final source = input.source;
        if (pos >= source.length) {
          return '$pos:';
        }
        var length = source.length - pos;
        length = length > 40 ? 40 : length;
        final string = source.substring(pos, pos + length);
        return '$pos:$string';
      }
    } else if (input case final ChunkedParsingSink input) {
      final source = input.data;
      final pos = this.pos - input.start;
      if (pos < 0 || pos >= source.length) {
        return '$pos:';
      }
      var length = source.length - pos;
      length = length > 40 ? 40 : length;
      final string = source.substring(pos, pos + length);
      return '$pos:$string';
    }

    return super.toString();
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  bool _canHandleError(int failPos, int errorCount) {
    return failPos == this.failPos
        ? errorCount < this.errorCount
        : failPos < this.failPos;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  void _rollbackErrors(int failPos, int errorCount) {
    if (this.failPos == failPos) {
      this.errorCount = errorCount;
    } else if (this.failPos > failPos) {
      this.errorCount = 0;
    }
  }
}

abstract interface class StringReader {
  factory StringReader(String source) {
    return _StringReader(source);
  }

  int get count;

  bool get hasSource;

  int get length;

  String get source;

  int indexOf(String string, int start);

  bool matchChar(int char, int offset);

  int readChar(int offset);

  bool startsWith(String string, [int index = 0]);

  String substring(int start, [int? end]);
}

class _StringReader implements StringReader {
  @override
  final bool hasSource = true;

  @override
  final int length;

  @override
  int count = 0;

  @override
  final String source;

  _StringReader(this.source) : length = source.length;

  @override
  int indexOf(String string, int start) {
    return source.indexOf(string, start);
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool matchChar(int char, int offset) {
    if (offset < length) {
      final c = source.runeAt(offset);
      count = char > 0xffff ? 2 : 1;
      if (c == char) {
        return true;
      }
    }

    return false;
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar(int offset) {
    final result = source.runeAt(offset);
    count = result > 0xffff ? 2 : 1;
    return result;
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool startsWith(String string, [int index = 0]) {
    if (source.startsWith(string, index)) {
      count = string.length;
      return true;
    }

    return false;
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String substring(int start, [int? end]) {
    final result = source.substring(start, end);
    count = result.length;
    return result;
  }

  @override
  String toString() {
    return source;
  }
}

class _StringWrapper {
  final int invalidChar;

  final int leftPadding;

  final int length;

  final int rightPadding;

  final String source;

  _StringWrapper({
    required this.invalidChar,
    required this.leftPadding,
    required this.rightPadding,
    required this.source,
  }) : length = leftPadding + source.length + rightPadding;

  int codeUnitAt(int index) {
    if (index < 0 || index > length - 1) {
      throw RangeError.range(index, 0, length, 'index');
    }

    final offset = index - leftPadding;
    if (offset >= 0 && offset < source.length) {
      return source.codeUnitAt(offset);
    }

    return invalidChar;
  }

  bool hasCodeUnitAt(int index) {
    if (index < 0 || index > length - 1) {
      throw RangeError.range(index, 0, length, 'index');
    }

    return index >= leftPadding && index <= rightPadding && source.isNotEmpty;
  }

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

  String substring(int start, int end) {
    if (start < 0 || start > length) {
      throw RangeError.range(start, 0, length, 'index');
    }

    if (end < start || end > length) {
      throw RangeError.range(end, start, length, 'end');
    }

    final codeUnits = List.generate(end - start, (i) => codeUnitAt(start + i));
    return String.fromCharCodes(codeUnits);
  }
}

extension StringExt on String {
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

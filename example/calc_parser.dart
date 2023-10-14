import 'peg_parser_runtime.dart';
export 'peg_parser_runtime.dart';

void main(List<String> args) {
  const source = '1 + 2 * 3';
  const parser = CalcParser();
  final result = parseString(parser.parseStart, source);
  print(result);
}

class CalcParser {
  const CalcParser();

  num _calcBinary(num? left, ({String op, num expr}) next) {
    final op = next.op;
    final right = next.expr;
    left = left!;
    switch (op) {
      case '+':
        return left += right;
      case '-':
        return left -= right;
      case '/':
        return left /= right;
      case '*':
        return left *= right;
      default:
        throw StateError('Unknown operator: $op');
    }
  }

  num _prefix(String? operator, num operand) {
    if (operator == null) {
      return operand;
    }

    switch (operator) {
      case '+':
        return -operand;
      default:
        throw StateError('Unknown operator: $operator');
    }
  }

  /// CloseParenthesis =
  ///   ')' Spaces
  ///   ;
  void fastParseCloseParenthesis(State<String> state) {
    // ')' Spaces
    final $0 = state.pos;
    const $1 = ')';
    matchLiteral1(state, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// OpenParenthesis =
  ///   '(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<String> state) {
    // '(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    matchLiteral1(state, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  void fastParseSpaces(State<String> state) {
    // [ \n\r\t]*
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $1 = state.input.codeUnitAt(state.pos);
        state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16(State<String> state, int char) {
    final input = state.input;
    final pos = state.pos;
    if (pos < input.length) {
      state.ok = input.codeUnitAt(pos) == char;
      if (state.ok) {
        state.pos++;
        return char;
      }
      state.fail(const ErrorUnexpectedCharacter());
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral(State<String> state, String string, ParseError error) {
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
    final pos = state.pos;
    state.ok = pos < input.length &&
        input.codeUnitAt(pos) == string.codeUnitAt(0) &&
        input.startsWith(string, pos);
    if (state.ok) {
      state.pos += string.length;
      return string;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1(State<String> state, String string, ParseError error) {
    final input = state.input;
    final pos = state.pos;
    state.ok =
        pos < input.length && input.codeUnitAt(pos) == string.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
      state.ok = true;
      return string;
    }
    state.fail(error);
    return null;
  }

  /// num
  /// Add =
  ///   h:Mul t:(op:AddOp ↑ expr:Mul)* {}
  ///   ;
  num? parseAdd(State<String> state) {
    num? $0;
    // h:Mul t:(op:AddOp ↑ expr:Mul)* {}
    final $3 = state.pos;
    num? $1;
    // Mul
    $1 = parseMul(state);
    if (state.ok) {
      List<({String op, num expr})>? $2;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:AddOp ↑ expr:Mul
        final $9 = state.pos;
        var $8 = true;
        String? $6;
        // AddOp
        $6 = parseAddOp(state);
        if (state.ok) {
          $8 = false;
          state.ok = true;
          if (state.ok) {
            num? $7;
            // Mul
            $7 = parseMul(state);
            if (state.ok) {
              $5 = (op: $6!, expr: $7!);
            }
          }
        }
        if (!state.ok) {
          if (!$8) {
            state.isRecoverable = false;
          }
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        num? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// AddOp =
  ///   v:@expected('operator' ,'-' / '+') Spaces
  ///   ;
  String? parseAddOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'-' / '+') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $4 = state.failPos;
    final $5 = state.errorCount;
    final $10 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.runeAt(state.pos);
      state.pos += $6 > 0xffff ? 2 : 1;
      switch ($6) {
        case 45:
          state.ok = true;
          $1 = '-';
          break;
        case 43:
          state.ok = true;
          $1 = '+';
          break;
      }
    }
    if (!state.ok) {
      state.pos = $10;
      state.fail(const ErrorExpectedTags(['-', '+']));
    }
    if (!state.ok && state.canHandleError($4, $5)) {
      if (state.failPos == $3) {
        state.rollbackErrors($4, $5);
        state.fail(const ErrorExpectedTags(['operator']));
      }
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

  /// Expression =
  ///   Add
  ///   ;
  num? parseExpression(State<String> state) {
    num? $0;
    // Add
    // Add
    $0 = parseAdd(state);
    return $0;
  }

  /// num
  /// Mul =
  ///   h:Prefix t:(op:MulOp ↑ expr:Prefix)* {}
  ///   ;
  num? parseMul(State<String> state) {
    num? $0;
    // h:Prefix t:(op:MulOp ↑ expr:Prefix)* {}
    final $3 = state.pos;
    num? $1;
    // Prefix
    $1 = parsePrefix(state);
    if (state.ok) {
      List<({String op, num expr})>? $2;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:MulOp ↑ expr:Prefix
        final $9 = state.pos;
        var $8 = true;
        String? $6;
        // MulOp
        $6 = parseMulOp(state);
        if (state.ok) {
          $8 = false;
          state.ok = true;
          if (state.ok) {
            num? $7;
            // Prefix
            $7 = parsePrefix(state);
            if (state.ok) {
              $5 = (op: $6!, expr: $7!);
            }
          }
        }
        if (!state.ok) {
          if (!$8) {
            state.isRecoverable = false;
          }
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        num? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// MulOp =
  ///   v:@expected('operator' ,'/' / '*') Spaces
  ///   ;
  String? parseMulOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'/' / '*') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $4 = state.failPos;
    final $5 = state.errorCount;
    final $10 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.runeAt(state.pos);
      state.pos += $6 > 0xffff ? 2 : 1;
      switch ($6) {
        case 47:
          state.ok = true;
          $1 = '/';
          break;
        case 42:
          state.ok = true;
          $1 = '*';
          break;
      }
    }
    if (!state.ok) {
      state.pos = $10;
      state.fail(const ErrorExpectedTags(['/', '*']));
    }
    if (!state.ok && state.canHandleError($4, $5)) {
      if (state.failPos == $3) {
        state.rollbackErrors($4, $5);
        state.fail(const ErrorExpectedTags(['operator']));
      }
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

  /// Number =
  ///   v:@expected('number' ,Number_) Spaces
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // v:@expected('number' ,Number_) Spaces
    final $2 = state.pos;
    num? $1;
    final $3 = state.pos;
    final $4 = state.failPos;
    final $5 = state.errorCount;
    // Number_
    // num @inline Number_ = v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {} ;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
    String? $7;
    final $9 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $10 = state.pos;
    matchChar16(state, 45);
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      // [0]
      matchChar16(state, 48);
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $12 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $13 = state.input.codeUnitAt(state.pos);
          state.ok = $13 >= 49 && $13 <= 57;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $14 = state.input.codeUnitAt(state.pos);
              state.ok = $14 >= 48 && $14 <= 57;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              break;
            }
          }
          state.setOk(true);
        }
        if (!state.ok) {
          state.backtrack($12);
        }
      }
      if (state.ok) {
        // [.] ↑ [0-9]+
        final $16 = state.pos;
        var $15 = true;
        matchChar16(state, 46);
        if (state.ok) {
          $15 = false;
          state.ok = true;
          if (state.ok) {
            var $17 = false;
            while (true) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $18 = state.input.codeUnitAt(state.pos);
                state.ok = $18 >= 48 && $18 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
              if (!state.ok) {
                break;
              }
              $17 = true;
            }
            state.setOk($17);
          }
        }
        if (!state.ok) {
          if (!$15) {
            state.isRecoverable = false;
          }
          state.backtrack($16);
        }
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          // [eE] ↑ [-+]? [0-9]+
          final $20 = state.pos;
          var $19 = true;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $21 = state.input.codeUnitAt(state.pos);
            state.ok = $21 == 69 || $21 == 101;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $19 = false;
            state.ok = true;
            if (state.ok) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $22 = state.input.codeUnitAt(state.pos);
                state.ok = $22 == 43 || $22 == 45;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
              if (!state.ok) {
                state.setOk(true);
              }
              if (state.ok) {
                var $23 = false;
                while (true) {
                  state.ok = state.pos < state.input.length;
                  if (state.ok) {
                    final $24 = state.input.codeUnitAt(state.pos);
                    state.ok = $24 >= 48 && $24 <= 57;
                    if (state.ok) {
                      state.pos++;
                    } else {
                      state.fail(const ErrorUnexpectedCharacter());
                    }
                  } else {
                    state.fail(const ErrorUnexpectedEndOfInput());
                  }
                  if (!state.ok) {
                    break;
                  }
                  $23 = true;
                }
                state.setOk($23);
              }
            }
          }
          if (!state.ok) {
            if (!$19) {
              state.isRecoverable = false;
            }
            state.backtrack($20);
          }
          if (!state.ok) {
            state.setOk(true);
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($10);
    }
    if (state.ok) {
      $7 = state.input.substring($9, state.pos);
    }
    if (state.ok) {
      num? $$;
      final v = $7!;
      $$ = num.parse(v);
      $1 = $$;
    }
    if (!state.ok && state.canHandleError($4, $5)) {
      if (state.failPos == $3) {
        state.rollbackErrors($4, $5);
        state.fail(const ErrorExpectedTags(['number']));
      }
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

  /// num
  /// Prefix =
  ///   o:'-'? e:Primary {}
  ///   ;
  num? parsePrefix(State<String> state) {
    num? $0;
    // o:'-'? e:Primary {}
    final $3 = state.pos;
    String? $1;
    const $4 = '-';
    $1 = matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      num? $2;
      // Primary
      $2 = parsePrimary(state);
      if (state.ok) {
        num? $$;
        final o = $1;
        final e = $2!;
        $$ = _prefix(o, e);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Primary =
  ///     Number
  ///   / OpenParenthesis v:Number CloseParenthesis
  ///   ;
  num? parsePrimary(State<String> state) {
    num? $0;
    // Number
    // Number
    $0 = parseNumber(state);
    if (!state.ok && state.isRecoverable) {
      // OpenParenthesis v:Number CloseParenthesis
      final $3 = state.pos;
      // OpenParenthesis
      fastParseOpenParenthesis(state);
      if (state.ok) {
        num? $2;
        // Number
        $2 = parseNumber(state);
        if (state.ok) {
          // CloseParenthesis
          fastParseCloseParenthesis(state);
          if (state.ok) {
            $0 = $2;
          }
        }
      }
      if (!state.ok) {
        state.backtrack($3);
      }
    }
    return $0;
  }

  /// Start =
  ///   Spaces v:Expression @eof()
  ///   ;
  num? parseStart(State<String> state) {
    num? $0;
    // Spaces v:Expression @eof()
    final $2 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      num? $1;
      // Expression
      $1 = parseExpression(state);
      if (state.ok) {
        state.ok = state.pos >= state.input.length;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
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
}

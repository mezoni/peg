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
      case '-':
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
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 41;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
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
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 40;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
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
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c < 13 ? c >= 9 && c <= 10 : c <= 13 || c == 32);
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        state.pos++);
    state.ok = true;
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
    final $11 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    final $10 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.codeUnitAt(state.pos);
      state.pos++;
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
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $11) {
      state.lastFailPos = $11;
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
    final $11 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    final $10 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.codeUnitAt(state.pos);
      state.pos++;
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
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $11) {
      state.lastFailPos = $11;
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
    final $22 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // Number_
    // num @inline Number_ = v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {} ;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
    String? $7;
    final $9 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $10 = state.pos;
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos++;
    } else {
      state.fail(const ErrorUnexpectedCharacter());
    }
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      // [0]
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 48;
      if (state.ok) {
        state.pos++;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $12 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $13 = state.input.codeUnitAt(state.pos);
          state.ok = $13 >= 49 && $13 <= 57;
          if (state.ok) {
            state.pos++;
          }
        }
        if (!state.ok) {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (state.ok) {
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.codeUnitAt(state.pos)) == c &&
                  (c >= 48 && c <= 57);
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              state.pos++);
          state.ok = true;
        }
        if (!state.ok) {
          state.backtrack($12);
        }
      }
      if (state.ok) {
        // [.] ↑ [0-9]+
        final $15 = state.pos;
        var $14 = true;
        state.ok = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 46;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (state.ok) {
          $14 = false;
          state.ok = true;
          if (state.ok) {
            var $16 = false;
            for (var c = 0;
                state.pos < state.input.length &&
                    (c = state.input.codeUnitAt(state.pos)) == c &&
                    (c >= 48 && c <= 57);
                state.pos++,
                // ignore: curly_braces_in_flow_control_structures, empty_statements
                $16 = true);
            state.ok = $16;
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
          }
        }
        if (!state.ok) {
          if (!$14) {
            state.isRecoverable = false;
          }
          state.backtrack($15);
        }
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          // [eE] ↑ [-+]? [0-9]+
          final $18 = state.pos;
          var $17 = true;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $19 = state.input.codeUnitAt(state.pos);
            state.ok = $19 == 69 || $19 == 101;
            if (state.ok) {
              state.pos++;
            }
          }
          if (!state.ok) {
            state.fail(const ErrorUnexpectedCharacter());
          }
          if (state.ok) {
            $17 = false;
            state.ok = true;
            if (state.ok) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $20 = state.input.codeUnitAt(state.pos);
                state.ok = $20 == 43 || $20 == 45;
                if (state.ok) {
                  state.pos++;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
              }
              if (!state.ok) {
                state.setOk(true);
              }
              if (state.ok) {
                var $21 = false;
                for (var c = 0;
                    state.pos < state.input.length &&
                        (c = state.input.codeUnitAt(state.pos)) == c &&
                        (c >= 48 && c <= 57);
                    state.pos++,
                    // ignore: curly_braces_in_flow_control_structures, empty_statements
                    $21 = true);
                state.ok = $21;
                if (!state.ok) {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
            }
          }
          if (!state.ok) {
            if (!$17) {
              state.isRecoverable = false;
            }
            state.backtrack($18);
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
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['number']));
    }
    if (state.lastFailPos < $22) {
      state.lastFailPos = $22;
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
  ///   @expected('expression' ,Prefix_)
  ///   ;
  num? parsePrefix(State<String> state) {
    num? $0;
    // @expected('expression' ,Prefix_)
    final $2 = state.pos;
    final $19 = state.lastFailPos;
    final $4 = state.errorCount;
    state.lastFailPos = -1;
    // Prefix_
    // num @inline Prefix_ = o:'-'? e:Primary {} ;
    // o:'-'? e:Primary {}
    final $8 = state.pos;
    String? $6;
    const $9 = '-';
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      $6 = $9;
      state.pos++;
    } else {
      state.fail(const ErrorExpectedTags([$9]));
    }
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      num? $7;
      // @inline Primary = @expected('expression' ,Primary_) ;
      // @expected('expression' ,Primary_)
      final $11 = state.pos;
      final $18 = state.lastFailPos;
      final $13 = state.errorCount;
      state.lastFailPos = -1;
      // Primary_
      // @inline Primary_ = Number / OpenParenthesis v:Expression CloseParenthesis ;
      // Number
      // Number
      $7 = parseNumber(state);
      if (!state.ok && state.isRecoverable) {
        // OpenParenthesis v:Expression CloseParenthesis
        final $17 = state.pos;
        // OpenParenthesis
        fastParseOpenParenthesis(state);
        if (state.ok) {
          num? $16;
          // Expression
          $16 = parseExpression(state);
          if (state.ok) {
            // CloseParenthesis
            fastParseCloseParenthesis(state);
            if (state.ok) {
              $7 = $16;
            }
          }
        }
        if (!state.ok) {
          state.backtrack($17);
        }
      }
      if (!state.ok &&
          state.lastFailPos >= state.failPos &&
          state.lastFailPos == $11) {
        state.errorCount = $13;
        state.fail(const ErrorExpectedTags(['expression']));
      }
      if (state.lastFailPos < $18) {
        state.lastFailPos = $18;
      }
      if (state.ok) {
        num? $$;
        final o = $6;
        final e = $7!;
        $$ = _prefix(o, e);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($8);
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $2) {
      state.errorCount = $4;
      state.fail(const ErrorExpectedTags(['expression']));
    }
    if (state.lastFailPos < $19) {
      state.lastFailPos = $19;
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

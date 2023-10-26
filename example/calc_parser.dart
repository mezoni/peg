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
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 41;
    if ($2) {
      state.advance(1);
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

  /// OpenParenthesis =
  ///   '(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<String> state) {
    // '(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 40;
    if ($2) {
      state.advance(1);
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
  ///   [ \n\r\t]*
  ///   ;
  void fastParseSpaces(State<String> state) {
    // [ \n\r\t]*
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c < 13 ? c >= 9 && c <= 10 : c <= 13 || c == 32);
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        state.advance(1));
    state.setOk(true);
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
          state.setOk(true);
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
  ///   v:('-' / '+') Spaces
  ///   ;
  String? parseAddOp(State<String> state) {
    String? $0;
    // v:('-' / '+') Spaces
    final $2 = state.pos;
    String? $1;
    final $4 = state.pos;
    var $3 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 45:
          $3 = 1;
          $1 = '-';
          break;
        case 43:
          $3 = 1;
          $1 = '+';
          break;
      }
    }
    if ($3 > 0) {
      state.advance($3);
      state.setOk(true);
    } else {
      state.pos = $4;
      state.fail(const ErrorExpectedTags(['-', '+']));
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
          state.setOk(true);
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
  ///   v:('/' / '*') Spaces
  ///   ;
  String? parseMulOp(State<String> state) {
    String? $0;
    // v:('/' / '*') Spaces
    final $2 = state.pos;
    String? $1;
    final $4 = state.pos;
    var $3 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 47:
          $3 = 1;
          $1 = '/';
          break;
        case 42:
          $3 = 1;
          $1 = '*';
          break;
      }
    }
    if ($3 > 0) {
      state.advance($3);
      state.setOk(true);
    } else {
      state.pos = $4;
      state.fail(const ErrorExpectedTags(['/', '*']));
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
  /// Number =
  ///   v:$(([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) Spaces {}
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // v:$(([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) Spaces {}
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    // ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $4 = state.pos;
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.advance(1);
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // [1-9] [0-9]*
      final $6 = state.pos;
      if (state.pos < state.input.length) {
        final $7 = state.input.codeUnitAt(state.pos);
        final $8 = $7 >= 49 && $7 <= 57;
        if ($8) {
          state.advance(1);
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
                (c >= 48 && c <= 57);
            // ignore: curly_braces_in_flow_control_structures, empty_statements
            state.advance(1));
        state.setOk(true);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
    }
    if (state.ok) {
      // [.] ↑ [0-9]+
      final $10 = state.pos;
      var $9 = true;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 46;
        if (ok) {
          state.advance(1);
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $9 = false;
        state.setOk(true);
        if (state.ok) {
          var $11 = false;
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.codeUnitAt(state.pos)) == c &&
                  (c >= 48 && c <= 57);
              state.advance(1),
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              $11 = true);
          if ($11) {
            state.setOk($11);
          } else {
            state.pos < state.input.length
                ? state.fail(const ErrorUnexpectedCharacter())
                : state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
      }
      if (!state.ok) {
        if (!$9) {
          state.isRecoverable = false;
        }
        state.backtrack($10);
      }
      if (!state.ok) {
        state.setOk(true);
      }
      if (state.ok) {
        // [eE] ↑ [-+]? [0-9]+
        final $13 = state.pos;
        var $12 = true;
        if (state.pos < state.input.length) {
          final $14 = state.input.codeUnitAt(state.pos);
          final $15 = $14 == 69 || $14 == 101;
          if ($15) {
            state.advance(1);
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $12 = false;
          state.setOk(true);
          if (state.ok) {
            if (state.pos < state.input.length) {
              final $16 = state.input.codeUnitAt(state.pos);
              final $17 = $16 == 43 || $16 == 45;
              if ($17) {
                state.advance(1);
                state.setOk(true);
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
              var $18 = false;
              for (var c = 0;
                  state.pos < state.input.length &&
                      (c = state.input.codeUnitAt(state.pos)) == c &&
                      (c >= 48 && c <= 57);
                  state.advance(1),
                  // ignore: curly_braces_in_flow_control_structures, empty_statements
                  $18 = true);
              if ($18) {
                state.setOk($18);
              } else {
                state.pos < state.input.length
                    ? state.fail(const ErrorUnexpectedCharacter())
                    : state.fail(const ErrorUnexpectedEndOfInput());
              }
            }
          }
        }
        if (!state.ok) {
          if (!$12) {
            state.isRecoverable = false;
          }
          state.backtrack($13);
        }
        if (!state.ok) {
          state.setOk(true);
        }
      }
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
        num? $$;
        final v = $1!;
        $$ = num.parse(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// num
  /// Prefix =
  ///   @expected('expression', Prefix_)
  ///   ;
  num? parsePrefix(State<String> state) {
    num? $0;
    // @expected('expression', Prefix_)
    final $2 = state.pos;
    final $3 = state.errorCount;
    final $4 = state.failPos;
    final $5 = state.lastFailPos;
    state.lastFailPos = -1;
    // Prefix_
    // num @inline Prefix_ = o:'-'? e:Primary {} ;
    // o:'-'? e:Primary {}
    final $9 = state.pos;
    String? $7;
    const $10 = '-';
    final $11 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 45;
    if ($11) {
      state.advance(1);
      state.setOk(true);
      $7 = $10;
    } else {
      state.fail(const ErrorExpectedTags([$10]));
    }
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      num? $8;
      // @inline Primary = Number / OpenParenthesis v:Expression CloseParenthesis ;
      // Number
      // Number
      $8 = parseNumber(state);
      if (!state.ok && state.isRecoverable) {
        // OpenParenthesis v:Expression CloseParenthesis
        final $14 = state.pos;
        // OpenParenthesis
        fastParseOpenParenthesis(state);
        if (state.ok) {
          num? $13;
          // Expression
          $13 = parseExpression(state);
          if (state.ok) {
            // CloseParenthesis
            fastParseCloseParenthesis(state);
            if (state.ok) {
              $8 = $13;
            }
          }
        }
        if (!state.ok) {
          state.backtrack($14);
        }
      }
      if (state.ok) {
        num? $$;
        final o = $7;
        final e = $8!;
        $$ = _prefix(o, e);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($9);
    }
    if (!state.ok && state.lastFailPos == $2) {
      if (state.lastFailPos == $4) {
        state.errorCount = $3;
      } else if (state.lastFailPos > $4) {
        state.errorCount = 0;
      }
      state.fail(const ErrorExpectedTags(['expression']));
    }
    if (state.lastFailPos < $5) {
      state.lastFailPos = $5;
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
        if (state.pos >= state.input.length) {
          state.setOk(true);
        } else {
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

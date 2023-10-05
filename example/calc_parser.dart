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
  void fastParseCloseParenthesis(State<StringReader> state) {
    // ')' Spaces
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

  /// CloseParenthesis =
  ///   ')' Spaces
  ///   ;
  AsyncResult<Object?> fastParseCloseParenthesis$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    AsyncResult<Object?>? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // ')' Spaces
            $3 = state.pos;
            //  // ')'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            matchLiteral1Async(state, 41, ')', const ErrorExpectedTags([')']));
            $4.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $5 = fastParseSpaces$Async(state);
            $1 = 3;
            final $6 = $5!;
            if ($6.isComplete) {
              break;
            }
            $6.onComplete = $2;
            return;
          case 3:
            $5 = null;
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            $1 = 1;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// OpenParenthesis =
  ///   '(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<StringReader> state) {
    // '(' Spaces
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

  /// OpenParenthesis =
  ///   '(' Spaces
  ///   ;
  AsyncResult<Object?> fastParseOpenParenthesis$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    AsyncResult<Object?>? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '(' Spaces
            $3 = state.pos;
            //  // '('
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            matchLiteral1Async(state, 40, '(', const ErrorExpectedTags(['(']));
            $4.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $5 = fastParseSpaces$Async(state);
            $1 = 3;
            final $6 = $5!;
            if ($6.isComplete) {
              break;
            }
            $6.onComplete = $2;
            return;
          case 3:
            $5 = null;
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            $1 = 1;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  void fastParseSpaces(State<StringReader> state) {
    // [ \n\r\t]*
    while (state.pos < state.input.length) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
      if (!state.ok) {
        break;
      }
      state.pos += state.input.count;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [ \n\r\t]*
            //  // [ \n\r\t]*
            state.input.beginBuffering();
            //  // [ \n\r\t]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }

            state.ok = state.pos < $3.end;
            if (state.pos >= $3.start) {
              if (state.ok) {
                final c = $3.data.runeAt(state.pos - $3.start);
                state.ok = c == 13 || c >= 9 && c <= 10 || c == 32;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($3.start - state.pos));
            }
            $3.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 2;
              break;
            }
            $1 = 0;
            break;
          case 2:
            state.ok = true;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// num
  /// Add =
  ///   h:Mul t:(op:AddOp expr:Mul)* {}
  ///   ;
  num? parseAdd(State<StringReader> state) {
    num? $0;
    // h:Mul t:(op:AddOp expr:Mul)* {}
    final $1 = state.pos;
    num? $2;
    // Mul
    $2 = parseMul(state);
    if (state.ok) {
      List<({String op, num expr})>? $3;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:AddOp expr:Mul
        final $6 = state.pos;
        String? $7;
        // AddOp
        $7 = parseAddOp(state);
        if (state.ok) {
          num? $8;
          // Mul
          $8 = parseMul(state);
          if (state.ok) {
            $5 = (op: $7!, expr: $8!);
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
        num? $$;
        final h = $2!;
        final t = $3!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// num
  /// Add =
  ///   h:Mul t:(op:AddOp expr:Mul)* {}
  ///   ;
  AsyncResult<num> parseAdd$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $6;
    num? $4;
    AsyncResult<num>? $7;
    List<({String op, num expr})>? $5;
    List<({String op, num expr})>? $9;
    ({String op, num expr})? $10;
    int? $13;
    String? $11;
    AsyncResult<String>? $14;
    num? $12;
    AsyncResult<num>? $16;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // h:Mul t:(op:AddOp expr:Mul)* {}
            $6 = state.pos;
            //  // Mul
            $1 = -1;
            $7 = parseMul$Async(state);
            final $8 = $7!;
            $1 = 2;
            if ($8.isComplete) {
              break;
            }
            $8.onComplete = $2;
            return;
          case 2:
            $4 = $7!.value;
            $7 = null;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // (op:AddOp expr:Mul)*
            $9 = [];
            $1 = 3;
            break;
          case 3:
            state.input.beginBuffering();
            //  // (op:AddOp expr:Mul)
            $10 = null;
            //  // op:AddOp expr:Mul
            $10 = null;
            //  // op:AddOp expr:Mul
            $10 = null;
            $13 = state.pos;
            //  // AddOp
            $11 = null;
            $1 = -1;
            $14 = parseAddOp$Async(state);
            final $15 = $14!;
            $1 = 5;
            if ($15.isComplete) {
              break;
            }
            $15.onComplete = $2;
            return;
          case 5:
            $11 = $14!.value;
            $14 = null;
            if (!state.ok) {
              $1 = 4;
              break;
            }
            //  // Mul
            $12 = null;
            $1 = -1;
            $16 = parseMul$Async(state);
            final $17 = $16!;
            $1 = 6;
            if ($17.isComplete) {
              break;
            }
            $17.onComplete = $2;
            return;
          case 6:
            $12 = $16!.value;
            $16 = null;
            if (!state.ok) {
              state.pos = $13!;
              $1 = 4;
              break;
            }
            $10 = (op: $11!, expr: $12!);
            $1 = 4;
            break;
          case 4:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 7;
              break;
            }
            $9!.add($10!);
            $1 = 3;
            break;
          case 7:
            $5 = $9;
            $9 = null;
            state.ok = true;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            num? $$;
            final h = $4!;
            final t = $5!;
            $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// AddOp =
  ///   v:('-' / '+') Spaces
  ///   ;
  String? parseAddOp(State<StringReader> state) {
    String? $0;
    // v:('-' / '+') Spaces
    final $1 = state.pos;
    String? $2;
    state.ok = false;
    final $5 = state.input;
    if (state.pos < $5.length) {
      final $3 = $5.readChar(state.pos);
      // ignore: unused_local_variable
      final $4 = $5.count;
      switch ($3) {
        case 45:
          state.ok = true;
          state.pos += $4;
          $2 = '-';
          break;
        case 43:
          state.ok = true;
          state.pos += $4;
          $2 = '+';
          break;
      }
    }
    if (!state.ok) {
      state.fail(const ErrorExpectedTags(['-', '+']));
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

  /// AddOp =
  ///   v:('-' / '+') Spaces
  ///   ;
  AsyncResult<String> parseAddOp$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    int? $5;
    String? $4;
    AsyncResult<Object?>? $8;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:('-' / '+') Spaces
            $5 = state.pos;
            //  // ('-' / '+')
            //  // '-' / '+'
            //  // '-'
            //  // '-'
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            $4 = matchLiteral1Async(
                state, 45, '-', const ErrorExpectedTags(['-']));
            $6.endBuffering(state.pos);
            if (state.ok) {
              $1 = 2;
              break;
            }
            //  // '+'
            //  // '+'
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            $4 = matchLiteral1Async(
                state, 43, '+', const ErrorExpectedTags(['+']));
            $7.endBuffering(state.pos);
            $1 = 2;
            break;
          case 2:
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $8 = fastParseSpaces$Async(state);
            $1 = 5;
            final $9 = $8!;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 5:
            $8 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Expression =
  ///   Add
  ///   ;
  num? parseExpression(State<StringReader> state) {
    num? $0;
    // Add
    // Add
    $0 = parseAdd(state);
    return $0;
  }

  /// Expression =
  ///   Add
  ///   ;
  AsyncResult<num> parseExpression$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    AsyncResult<num>? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // Add
            //  // Add
            $1 = -1;
            $4 = parseAdd$Async(state);
            final $5 = $4!;
            $1 = 1;
            if ($5.isComplete) {
              break;
            }
            $5.onComplete = $2;
            return;
          case 1:
            $3 = $4!.value;
            $4 = null;
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// num
  /// Mul =
  ///   h:Prefix t:(op:MulOp expr:Prefix)* {}
  ///   ;
  num? parseMul(State<StringReader> state) {
    num? $0;
    // h:Prefix t:(op:MulOp expr:Prefix)* {}
    final $1 = state.pos;
    num? $2;
    // Prefix
    $2 = parsePrefix(state);
    if (state.ok) {
      List<({String op, num expr})>? $3;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:MulOp expr:Prefix
        final $6 = state.pos;
        String? $7;
        // MulOp
        $7 = parseMulOp(state);
        if (state.ok) {
          num? $8;
          // Prefix
          $8 = parsePrefix(state);
          if (state.ok) {
            $5 = (op: $7!, expr: $8!);
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
        num? $$;
        final h = $2!;
        final t = $3!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// num
  /// Mul =
  ///   h:Prefix t:(op:MulOp expr:Prefix)* {}
  ///   ;
  AsyncResult<num> parseMul$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $6;
    num? $4;
    AsyncResult<num>? $7;
    List<({String op, num expr})>? $5;
    List<({String op, num expr})>? $9;
    ({String op, num expr})? $10;
    int? $13;
    String? $11;
    AsyncResult<String>? $14;
    num? $12;
    AsyncResult<num>? $16;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // h:Prefix t:(op:MulOp expr:Prefix)* {}
            $6 = state.pos;
            //  // Prefix
            $1 = -1;
            $7 = parsePrefix$Async(state);
            final $8 = $7!;
            $1 = 2;
            if ($8.isComplete) {
              break;
            }
            $8.onComplete = $2;
            return;
          case 2:
            $4 = $7!.value;
            $7 = null;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // (op:MulOp expr:Prefix)*
            $9 = [];
            $1 = 3;
            break;
          case 3:
            state.input.beginBuffering();
            //  // (op:MulOp expr:Prefix)
            $10 = null;
            //  // op:MulOp expr:Prefix
            $10 = null;
            //  // op:MulOp expr:Prefix
            $10 = null;
            $13 = state.pos;
            //  // MulOp
            $11 = null;
            $1 = -1;
            $14 = parseMulOp$Async(state);
            final $15 = $14!;
            $1 = 5;
            if ($15.isComplete) {
              break;
            }
            $15.onComplete = $2;
            return;
          case 5:
            $11 = $14!.value;
            $14 = null;
            if (!state.ok) {
              $1 = 4;
              break;
            }
            //  // Prefix
            $12 = null;
            $1 = -1;
            $16 = parsePrefix$Async(state);
            final $17 = $16!;
            $1 = 6;
            if ($17.isComplete) {
              break;
            }
            $17.onComplete = $2;
            return;
          case 6:
            $12 = $16!.value;
            $16 = null;
            if (!state.ok) {
              state.pos = $13!;
              $1 = 4;
              break;
            }
            $10 = (op: $11!, expr: $12!);
            $1 = 4;
            break;
          case 4:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 7;
              break;
            }
            $9!.add($10!);
            $1 = 3;
            break;
          case 7:
            $5 = $9;
            $9 = null;
            state.ok = true;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            num? $$;
            final h = $4!;
            final t = $5!;
            $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// MulOp =
  ///   v:('/' / '*') Spaces
  ///   ;
  String? parseMulOp(State<StringReader> state) {
    String? $0;
    // v:('/' / '*') Spaces
    final $1 = state.pos;
    String? $2;
    state.ok = false;
    final $5 = state.input;
    if (state.pos < $5.length) {
      final $3 = $5.readChar(state.pos);
      // ignore: unused_local_variable
      final $4 = $5.count;
      switch ($3) {
        case 47:
          state.ok = true;
          state.pos += $4;
          $2 = '/';
          break;
        case 42:
          state.ok = true;
          state.pos += $4;
          $2 = '*';
          break;
      }
    }
    if (!state.ok) {
      state.fail(const ErrorExpectedTags(['/', '*']));
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

  /// MulOp =
  ///   v:('/' / '*') Spaces
  ///   ;
  AsyncResult<String> parseMulOp$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    int? $5;
    String? $4;
    AsyncResult<Object?>? $8;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:('/' / '*') Spaces
            $5 = state.pos;
            //  // ('/' / '*')
            //  // '/' / '*'
            //  // '/'
            //  // '/'
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            $4 = matchLiteral1Async(
                state, 47, '/', const ErrorExpectedTags(['/']));
            $6.endBuffering(state.pos);
            if (state.ok) {
              $1 = 2;
              break;
            }
            //  // '*'
            //  // '*'
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            $4 = matchLiteral1Async(
                state, 42, '*', const ErrorExpectedTags(['*']));
            $7.endBuffering(state.pos);
            $1 = 2;
            break;
          case 2:
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $8 = fastParseSpaces$Async(state);
            $1 = 5;
            final $9 = $8!;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 5:
            $8 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Number =
  ///   @errorHandler(NumberRaw)
  ///   ;
  num? parseNumber(State<StringReader> state) {
    num? $0;
    // @errorHandler(NumberRaw)
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // NumberRaw
    // NumberRaw
    $0 = parseNumberRaw(state);
    if (!state.ok && state._canHandleError($2, $3)) {
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      if (state.failPos != state.pos) {
        error = ErrorMessage(state.pos - state.failPos, 'Malformed number');
      } else {
        rollbackErrors = true;
        error = ErrorExpectedTags(['number']);
      }
      if (rollbackErrors == true) {
        state._rollbackErrors($2, $3);
        // ignore: unnecessary_null_comparison, prefer_conditional_assignment
        if (error == null) {
          error = const ErrorUnknownError();
        }
      }
      // ignore: unnecessary_null_comparison
      if (error != null) {
        state.failAt(state.failPos, error);
      }
    }
    return $0;
  }

  /// Number =
  ///   @errorHandler(NumberRaw)
  ///   ;
  AsyncResult<num> parseNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $4;
    int? $5;
    AsyncResult<num>? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @errorHandler(NumberRaw)
            //  // @errorHandler(NumberRaw)
            $4 = state.failPos;
            $5 = state.errorCount;
            //  // NumberRaw
            //  // NumberRaw
            //  // NumberRaw
            $1 = -1;
            $6 = parseNumberRaw$Async(state);
            final $7 = $6!;
            $1 = 1;
            if ($7.isComplete) {
              break;
            }
            $7.onComplete = $2;
            return;
          case 1:
            $3 = $6!.value;
            $6 = null;
            if (!state.ok && state._canHandleError($4!, $5!)) {
              ParseError? error;
              // ignore: prefer_final_locals
              var rollbackErrors = false;
              if (state.failPos != state.pos) {
                error =
                    ErrorMessage(state.pos - state.failPos, 'Malformed number');
              } else {
                rollbackErrors = true;
                error = ErrorExpectedTags(['number']);
              }
              if (rollbackErrors == true) {
                state._rollbackErrors($4!, $5!);
                // ignore: unnecessary_null_comparison, prefer_conditional_assignment
                if (error == null) {
                  error = const ErrorUnknownError();
                }
              }
              // ignore: unnecessary_null_comparison
              if (error != null) {
                state.failAt(state.failPos, error);
              }
            }
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// num
  /// NumberRaw =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  num? parseNumberRaw(State<StringReader> state) {
    num? $0;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
    final $4 = state.pos;
    matchChar(state, 45, const ErrorExpectedCharacter(45));
    state.ok = true;
    if (state.ok) {
      // [0]
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (!state.ok) {
        // [1-9] [0-9]*
        final $6 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $7 = state.input.readChar(state.pos);
          state.ok = $7 >= 49 && $7 <= 57;
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
            final $8 = state.input.readChar(state.pos);
            state.ok = $8 >= 48 && $8 <= 57;
            if (!state.ok) {
              break;
            }
            state.pos += state.input.count;
          }
          state.fail(const ErrorUnexpectedCharacter());
          state.ok = true;
        }
        if (!state.ok) {
          state.pos = $6;
        }
      }
      if (state.ok) {
        // [.] [0-9]+
        final $9 = state.pos;
        matchChar(state, 46, const ErrorExpectedCharacter(46));
        if (state.ok) {
          var $10 = false;
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $11 = state.input.readChar(state.pos);
              state.ok = $11 >= 48 && $11 <= 57;
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
            $10 = true;
          }
          state.ok = $10;
        }
        if (!state.ok) {
          state.pos = $9;
        }
        state.ok = true;
        if (state.ok) {
          // [eE] [-+]? [0-9]+
          final $12 = state.pos;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $13 = state.input.readChar(state.pos);
            state.ok = $13 == 69 || $13 == 101;
            if (state.ok) {
              state.pos += state.input.count;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $14 = state.input.readChar(state.pos);
              state.ok = $14 == 43 || $14 == 45;
              if (state.ok) {
                state.pos += state.input.count;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.ok = true;
            if (state.ok) {
              var $15 = false;
              while (true) {
                state.ok = state.pos < state.input.length;
                if (state.ok) {
                  final $16 = state.input.readChar(state.pos);
                  state.ok = $16 >= 48 && $16 <= 57;
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
                $15 = true;
              }
              state.ok = $15;
            }
          }
          if (!state.ok) {
            state.pos = $12;
          }
          state.ok = true;
        }
      }
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
        num? $$;
        final v = $2!;
        $$ = num.parse(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// num
  /// NumberRaw =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  AsyncResult<num> parseNumberRaw$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $5;
    String? $4;
    int? $6;
    int? $7;
    int? $10;
    int? $13;
    bool? $15;
    int? $17;
    bool? $20;
    AsyncResult<Object?>? $22;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
            $5 = state.pos;
            //  // $([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
            $6 = state.pos;
            state.input.beginBuffering();
            //  // ([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
            //  // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
            //  // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
            $7 = state.pos;
            //  // [-]?
            state.input.beginBuffering();
            //  // [-]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            matchCharAsync(state, 45, const ErrorExpectedCharacter(45));
            state.input.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // ([0] / [1-9] [0-9]*)
            //  // [0] / [1-9] [0-9]*
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 4;
              break;
            }
            //  // [1-9] [0-9]*
            $10 = state.pos;
            //  // [1-9]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }

            state.ok = state.pos < $11.end;
            if (state.pos >= $11.start) {
              if (state.ok) {
                final c = $11.data.runeAt(state.pos - $11.start);
                state.ok = c >= 49 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($11.start - state.pos));
            }
            $11.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [0-9]*
            $1 = 8;
            break;
          case 8:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 9;
            break;
          case 9:
            final $12 = state.input;
            if (state.pos + 1 >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $2;
              return;
            }

            state.ok = state.pos < $12.end;
            if (state.pos >= $12.start) {
              if (state.ok) {
                final c = $12.data.runeAt(state.pos - $12.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($12.start - state.pos));
            }
            $12.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 10;
              break;
            }
            $1 = 8;
            break;
          case 10:
            state.ok = true;
            if (!state.ok) {
              state.pos = $10!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            $1 = 4;
            break;
          case 4:
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            //  // ([.] [0-9]+)?
            state.input.beginBuffering();
            //  // ([.] [0-9]+)
            //  // [.] [0-9]+
            //  // [.] [0-9]+
            $13 = state.pos;
            //  // [.]
            state.input.beginBuffering();
            $1 = 12;
            break;
          case 12:
            final $14 = state.input;
            if (state.pos + 1 >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $2;
              return;
            }
            matchCharAsync(state, 46, const ErrorExpectedCharacter(46));
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 11;
              break;
            }
            //  // [0-9]+
            $15 = false;
            $1 = 13;
            break;
          case 13:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 14;
            break;
          case 14:
            final $16 = state.input;
            if (state.pos + 1 >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $2;
              return;
            }

            state.ok = state.pos < $16.end;
            if (state.pos >= $16.start) {
              if (state.ok) {
                final c = $16.data.runeAt(state.pos - $16.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($16.start - state.pos));
            }
            $16.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 15;
              break;
            }
            $15 = true;
            $1 = 13;
            break;
          case 15:
            state.ok = $15!;
            if (!state.ok) {
              state.pos = $13!;
              $1 = 11;
              break;
            }
            $1 = 11;
            break;
          case 11:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            //  // ([eE] [-+]? [0-9]+)?
            state.input.beginBuffering();
            //  // ([eE] [-+]? [0-9]+)
            //  // [eE] [-+]? [0-9]+
            //  // [eE] [-+]? [0-9]+
            $17 = state.pos;
            //  // [eE]
            state.input.beginBuffering();
            $1 = 17;
            break;
          case 17:
            final $18 = state.input;
            if (state.pos + 1 >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $2;
              return;
            }

            state.ok = state.pos < $18.end;
            if (state.pos >= $18.start) {
              if (state.ok) {
                final c = $18.data.runeAt(state.pos - $18.start);
                state.ok = c == 69 || c == 101;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($18.start - state.pos));
            }
            $18.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 16;
              break;
            }
            //  // [-+]?
            state.input.beginBuffering();
            //  // [-+]
            state.input.beginBuffering();
            $1 = 18;
            break;
          case 18:
            final $19 = state.input;
            if (state.pos + 1 >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $2;
              return;
            }

            state.ok = state.pos < $19.end;
            if (state.pos >= $19.start) {
              if (state.ok) {
                final c = $19.data.runeAt(state.pos - $19.start);
                state.ok = c == 43 || c == 45;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($19.start - state.pos));
            }
            $19.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $17!;
              $1 = 16;
              break;
            }
            //  // [0-9]+
            $20 = false;
            $1 = 19;
            break;
          case 19:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 20;
            break;
          case 20:
            final $21 = state.input;
            if (state.pos + 1 >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $2;
              return;
            }

            state.ok = state.pos < $21.end;
            if (state.pos >= $21.start) {
              if (state.ok) {
                final c = $21.data.runeAt(state.pos - $21.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($21.start - state.pos));
            }
            $21.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 21;
              break;
            }
            $20 = true;
            $1 = 19;
            break;
          case 21:
            state.ok = $20!;
            if (!state.ok) {
              state.pos = $17!;
              $1 = 16;
              break;
            }
            $1 = 16;
            break;
          case 16:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $4 = input.data.substring($6! - start, state.pos - start);
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $22 = fastParseSpaces$Async(state);
            $1 = 22;
            final $23 = $22!;
            if ($23.isComplete) {
              break;
            }
            $23.onComplete = $2;
            return;
          case 22:
            $22 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            num? $$;
            final v = $4!;
            $$ = num.parse(v);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// num
  /// Prefix =
  ///   o:'-'? e:Primary {}
  ///   ;
  num? parsePrefix(State<StringReader> state) {
    num? $0;
    // o:'-'? e:Primary {}
    final $1 = state.pos;
    String? $2;
    const $4 = '-';
    $2 = matchLiteral1(state, 45, $4, const ErrorExpectedTags([$4]));
    state.ok = true;
    if (state.ok) {
      num? $3;
      // Primary
      $3 = parsePrimary(state);
      if (state.ok) {
        num? $$;
        final o = $2;
        final e = $3!;
        $$ = _prefix(o, e);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// num
  /// Prefix =
  ///   o:'-'? e:Primary {}
  ///   ;
  AsyncResult<num> parsePrefix$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $6;
    String? $4;
    num? $5;
    AsyncResult<num>? $8;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // o:'-'? e:Primary {}
            $6 = state.pos;
            //  // '-'?
            state.input.beginBuffering();
            //  // '-'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            $4 = matchLiteral1Async(
                state, 45, '-', const ErrorExpectedTags(['-']));
            $7.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Primary
            $1 = -1;
            $8 = parsePrimary$Async(state);
            final $9 = $8!;
            $1 = 3;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 3:
            $5 = $8!.value;
            $8 = null;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            num? $$;
            final o = $4;
            final e = $5!;
            $$ = _prefix(o, e);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Primary =
  ///     Number
  ///   / OpenParenthesis v:Number CloseParenthesis
  ///   ;
  num? parsePrimary(State<StringReader> state) {
    num? $0;
    // Number
    // Number
    $0 = parseNumber(state);
    if (!state.ok) {
      // OpenParenthesis v:Number CloseParenthesis
      final $2 = state.pos;
      // OpenParenthesis
      fastParseOpenParenthesis(state);
      if (state.ok) {
        num? $3;
        // Number
        $3 = parseNumber(state);
        if (state.ok) {
          // CloseParenthesis
          fastParseCloseParenthesis(state);
          if (state.ok) {
            $0 = $3;
          }
        }
      }
      if (!state.ok) {
        state.pos = $2;
      }
    }
    return $0;
  }

  /// Primary =
  ///     Number
  ///   / OpenParenthesis v:Number CloseParenthesis
  ///   ;
  AsyncResult<num> parsePrimary$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    AsyncResult<num>? $4;
    int? $7;
    AsyncResult<Object?>? $8;
    num? $6;
    AsyncResult<num>? $10;
    AsyncResult<Object?>? $12;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // Number
            //  // Number
            $1 = -1;
            $4 = parseNumber$Async(state);
            final $5 = $4!;
            $1 = 2;
            if ($5.isComplete) {
              break;
            }
            $5.onComplete = $2;
            return;
          case 2:
            $3 = $4!.value;
            $4 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // OpenParenthesis v:Number CloseParenthesis
            $7 = state.pos;
            //  // OpenParenthesis
            $1 = -1;
            $8 = fastParseOpenParenthesis$Async(state);
            $1 = 4;
            final $9 = $8!;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 4:
            $8 = null;
            if (!state.ok) {
              $1 = 3;
              break;
            }
            //  // Number
            $1 = -1;
            $10 = parseNumber$Async(state);
            final $11 = $10!;
            $1 = 5;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 5:
            $6 = $10!.value;
            $10 = null;
            if (!state.ok) {
              state.pos = $7!;
              $1 = 3;
              break;
            }
            //  // CloseParenthesis
            $1 = -1;
            $12 = fastParseCloseParenthesis$Async(state);
            $1 = 6;
            final $13 = $12!;
            if ($13.isComplete) {
              break;
            }
            $13.onComplete = $2;
            return;
          case 6:
            $12 = null;
            if (!state.ok) {
              state.pos = $7!;
              $1 = 3;
              break;
            }
            $3 = $6;
            $1 = 3;
            break;
          case 3:
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Start =
  ///   Spaces v:Expression Eof
  ///   ;
  num? parseStart(State<StringReader> state) {
    num? $0;
    // Spaces v:Expression Eof
    final $1 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      num? $2;
      // Expression
      $2 = parseExpression(state);
      if (state.ok) {
        // @inline Eof = !. ;
        // !.
        final $4 = state.pos;
        final $6 = state.input;
        if (state.pos < $6.length) {
          $6.readChar(state.pos);
          state.pos += $6.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Start =
  ///   Spaces v:Expression Eof
  ///   ;
  AsyncResult<num> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $5;
    AsyncResult<Object?>? $6;
    num? $4;
    AsyncResult<num>? $8;
    int? $10;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // Spaces v:Expression Eof
            $5 = state.pos;
            //  // Spaces
            $1 = -1;
            $6 = fastParseSpaces$Async(state);
            $1 = 2;
            final $7 = $6!;
            if ($7.isComplete) {
              break;
            }
            $7.onComplete = $2;
            return;
          case 2:
            $6 = null;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Expression
            $1 = -1;
            $8 = parseExpression$Async(state);
            final $9 = $8!;
            $1 = 3;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 3:
            $4 = $8!.value;
            $8 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            //  // Eof
            //  // !.
            //  // !.
            //  // !.
            $10 = state.pos;
            state.input.beginBuffering();
            //  // .
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }

            if (state.pos >= $11.start) {
              state.ok = state.pos < $11.end;
              if (state.ok) {
                final c = $11.data.runeAt(state.pos - $11.start);
                state.pos += c > 0xffff ? 2 : 1;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking($11.start - state.pos));
            }
            $11.endBuffering(state.pos);
            state.input.endBuffering($10!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $10! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $10!;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
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
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(input.start - state.pos));
      return null;
    }
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
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(input.start - state.pos));
      return null;
    }
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
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(input.start - state.pos));
      return null;
    }
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
    } else if (error is ErrorBacktracking) {
      key = (ErrorBacktracking, error.length);
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
      if (_lastPosition > start) {
        if (_lastPosition == end) {
          this.data = '';
        } else {
          this.data = this.data.substring(_lastPosition - start);
        }

        start = _lastPosition;
      }
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

class ErrorBacktracking extends ParseError {
  static const message = 'Backtracking error';

  @override
  final int length;

  const ErrorBacktracking(this.length);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return ErrorMessage(length, ErrorBacktracking.message);
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

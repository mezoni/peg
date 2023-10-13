class Test2Parser {
  bool flag = false;

  String text = '';

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  void fastParseAndPredicate(State<String> state) {
    // &([0] [1] [2]) [0] [1] [2]
    final $0 = state.pos;
    final $1 = state.pos;
    final $2 = state.cuttingPos;
    // [0] [1] [2]
    final $3 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        matchChar16(state, 50);
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    state.cuttingPos = $2;
    if (state.ok) {
      state.pos = $1;
    }
    if (state.ok) {
      matchChar16(state, 48);
      if (state.ok) {
        matchChar16(state, 49);
        if (state.ok) {
          matchChar16(state, 50);
        }
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  AsyncResult<Object?> fastParseAndPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    int? $6;
    int? $7;
    int $11 = 0;
    Object? $13;
    Object? $15;
    Object? $17;
    void $1() {
      // &([0] [1] [2]) [0] [1] [2]
      if ($11 & 0x4 == 0) {
        $11 |= 0x4;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // &([0] [1] [2])
        if ($11 & 0x2 == 0) {
          $11 |= 0x2;
          state.input.beginBuffering();
          $4 = state.pos;
          $5 = state.cuttingPos;
        }
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($11 & 0x1 == 0) {
          $11 |= 0x1;
          $6 = 0;
          $7 = state.pos;
        }
        if ($6 == 0) {
          // [0]
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $6 = state.ok ? 1 : -1;
        }
        if ($6 == 1) {
          // [1]
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $6 = state.ok ? 2 : -1;
        }
        if ($6 == 2) {
          // [2]
          final $10 = state.input;
          if (state.pos >= $10.end && !$10.isClosed) {
            $10.sleep = true;
            $10.handle = $1;
            return;
          }
          matchChar16Async(state, 50);
          $6 = -1;
        }
        if (!state.ok) {
          state.backtrack($7!);
        }
        $11 &= ~0x1 & 0xffff;
        state.cuttingPos = $5!;
        if (state.ok) {
          state.pos = $4!;
        }
        state.input.endBuffering();
        $11 &= ~0x2 & 0xffff;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [0]
        $13 ??= state.input.beginBuffering();
        final $12 = state.input;
        if (state.pos >= $12.end && !$12.isClosed) {
          $12.sleep = true;
          $12.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $13 = null;
        $2 = state.ok ? 2 : -1;
      }
      if ($2 == 2) {
        // [1]
        $15 ??= state.input.beginBuffering();
        final $14 = state.input;
        if (state.pos >= $14.end && !$14.isClosed) {
          $14.sleep = true;
          $14.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $15 = null;
        $2 = state.ok ? 3 : -1;
      }
      if ($2 == 3) {
        // [2]
        $17 ??= state.input.beginBuffering();
        final $16 = state.input;
        if (state.pos >= $16.end && !$16.isClosed) {
          $16.sleep = true;
          $16.handle = $1;
          return;
        }
        matchChar16Async(state, 50);
        state.input.endBuffering();
        $17 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $11 &= ~0x4 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// AnyCharacter =
  ///   .
  ///   ;
  void fastParseAnyCharacter(State<String> state) {
    // .
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.pos += $1 > 0xffff ? 2 : 1;
      state.ok = true;
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// AnyCharacter =
  ///   .
  ///   ;
  AsyncResult<Object?> fastParseAnyCharacter$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    void $1() {
      // .
      // .
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      final $2 = readChar32Async(state);
      state.ok = $2 >= 0;
      if (state.ok) {
        state.pos += $2 > 0xffff ? 2 : 1;
      }
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  void fastParseCharacterClass(State<String> state) {
    // [0-9]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.codeUnitAt(state.pos);
      state.ok = $1 >= 48 && $1 <= 57;
      if (state.ok) {
        state.pos++;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClass$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // [0-9]
      // [0-9]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      final $2 = readChar16Async(state);
      if ($2 >= 0) {
        state.ok = $2 >= 48 && $2 <= 57;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  void fastParseCharacterClassChar32(State<String> state) {
    // [\u{1f680}]
    matchChar32(state, 128640);
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    void $1() {
      // [\u{1f680}]
      // [\u{1f680}]
      $3 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      matchChar32Async(state, 128640);
      state.input.endBuffering();
      $3 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  void fastParseCharacterClassCharNegate(State<String> state) {
    // [^0]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.runeAt(state.pos);
      state.ok = $1 != 48;
      if (state.ok) {
        state.pos += $1 > 0xffff ? 2 : 1;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassCharNegate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // [^0]
      // [^0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      final $2 = readChar32Async(state);
      if ($2 >= 0) {
        state.ok = $2 != 48;
        if (state.ok) {
          state.pos += $2 > 0xffff ? 2 : 1;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  void fastParseCharacterClassCharNegate32(State<String> state) {
    // [^\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.runeAt(state.pos);
      state.ok = $1 != 128640;
      if (state.ok) {
        state.pos += $1 > 0xffff ? 2 : 1;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassCharNegate32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // [^\u{1f680}]
      // [^\u{1f680}]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      final $2 = readChar32Async(state);
      if ($2 >= 0) {
        state.ok = $2 != 128640;
        if (state.ok) {
          state.pos += $2 > 0xffff ? 2 : 1;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  void fastParseCharacterClassRange32(State<String> state) {
    // [ -\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.runeAt(state.pos);
      state.ok = $1 >= 32 && $1 <= 128640;
      if (state.ok) {
        state.pos += $1 > 0xffff ? 2 : 1;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassRange32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // [ -\u{1f680}]
      // [ -\u{1f680}]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      final $2 = readChar32Async(state);
      if ($2 >= 0) {
        state.ok = $2 >= 32 && $2 <= 128640;
        if (state.ok) {
          state.pos += $2 > 0xffff ? 2 : 1;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Cut =
  ///     [0] [+] ↑ [1]
  ///   / [0]
  ///   ;
  void fastParseCut(State<String> state) {
    // [0] [+] ↑ [1]
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 43);
      if (state.ok) {
        state.cut(state.pos);
        if (state.ok) {
          matchChar16(state, 49);
        }
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
    if (!state.ok && state.isRecoverable) {
      // [0]
      matchChar16(state, 48);
    }
  }

  /// Cut =
  ///     [0] [+] ↑ [1]
  ///   / [0]
  ///   ;
  AsyncResult<Object?> fastParseCut$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    Object? $6;
    Object? $8;
    Object? $10;
    int $11 = 0;
    Object? $13;
    void $1() {
      if ($11 & 0x2 == 0) {
        $11 |= 0x2;
        $2 = 0;
      }
      if ($2 == 0) {
        // [0] [+] ↑ [1]
        if ($11 & 0x1 == 0) {
          $11 |= 0x1;
          $3 = 0;
          $4 = state.pos;
        }
        if ($3 == 0) {
          // [0]
          $6 ??= state.input.beginBuffering();
          final $5 = state.input;
          if (state.pos >= $5.end && !$5.isClosed) {
            $5.sleep = true;
            $5.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          state.input.endBuffering();
          $6 = null;
          $3 = state.ok ? 1 : -1;
        }
        if ($3 == 1) {
          // [+]
          $8 ??= state.input.beginBuffering();
          final $7 = state.input;
          if (state.pos >= $7.end && !$7.isClosed) {
            $7.sleep = true;
            $7.handle = $1;
            return;
          }
          matchChar16Async(state, 43);
          state.input.endBuffering();
          $8 = null;
          $3 = state.ok ? 2 : -1;
        }
        if ($3 == 2) {
          // ↑
          state.cut(state.pos);
          state.input.cut(state.pos);
          $3 = state.ok ? 3 : -1;
        }
        if ($3 == 3) {
          // [1]
          $10 ??= state.input.beginBuffering();
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          state.input.endBuffering();
          $10 = null;
          $3 = -1;
        }
        if (!state.ok) {
          state.backtrack($4!);
        }
        $11 &= ~0x1 & 0xffff;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($2 == 1) {
        // [0]
        // [0]
        $13 ??= state.input.beginBuffering();
        final $12 = state.input;
        if (state.pos >= $12.end && !$12.isClosed) {
          $12.sleep = true;
          $12.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $13 = null;
        $2 = -1;
      }
      $11 &= ~0x2 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Eof =
  ///   [0] @eof()
  ///   ;
  void fastParseEof(State<String> state) {
    // [0] @eof()
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      state.ok = state.pos >= state.input.length;
      if (!state.ok) {
        state.fail(const ErrorExpectedEndOfInput());
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Eof =
  ///   [0] @eof()
  ///   ;
  AsyncResult<Object?> fastParseEof$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    int $7 = 0;
    void $1() {
      // [0] @eof()
      if ($7 & 0x1 == 0) {
        $7 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // @eof()
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        state.ok = state.pos >= $6.end;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $7 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  void fastParseErrorHandler(State<String> state) {
    // @errorHandler([0])
    final $1 = state.pos;
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // [0]
    matchChar16(state, 48);
    if (!state.ok && state.canHandleError($2, $3)) {
      // ignore: unused_local_variable
      final start = $1;
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error = const ErrorMessage(0, 'error');
      if (rollbackErrors == true) {
        state.rollbackErrors($2, $3);
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
  }

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  AsyncResult<Object?> fastParseErrorHandler$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    Object? $6;
    int $7 = 0;
    void $1() {
      // @errorHandler([0])
      // @errorHandler([0])
      if ($7 & 0x1 == 0) {
        $7 |= 0x1;
        $2 = state.pos;
        $3 = state.failPos;
        $4 = state.errorCount;
      }
      // [0]
      // [0]
      // [0]
      $6 ??= state.input.beginBuffering();
      final $5 = state.input;
      if (state.pos >= $5.end && !$5.isClosed) {
        $5.sleep = true;
        $5.handle = $1;
        return;
      }
      matchChar16Async(state, 48);
      state.input.endBuffering();
      $6 = null;
      if (!state.ok && state.canHandleError($3!, $4!)) {
        // ignore: unused_local_variable
        final start = $2!;
        ParseError? error;
        // ignore: prefer_final_locals
        var rollbackErrors = false;
        rollbackErrors = true;
        error = const ErrorMessage(0, 'error');
        if (rollbackErrors == true) {
          state.rollbackErrors($3!, $4!);
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
      $7 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Expected =
  ///   @expected('digits' ,[0-9]{2,})
  ///   ;
  void fastParseExpected(State<String> state) {
    // @expected('digits' ,[0-9]{2,})
    final $1 = state.pos;
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // [0-9]{2,}
    final $5 = state.pos;
    var $6 = 0;
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $7 = state.input.codeUnitAt(state.pos);
        state.ok = $7 >= 48 && $7 <= 57;
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
      $6++;
    }
    state.setOk($6 >= 2);
    if (!state.ok) {
      state.backtrack($5);
    }
    if (!state.ok && state.canHandleError($2, $3)) {
      if (state.failPos == $1) {
        state.rollbackErrors($2, $3);
        state.fail(const ErrorExpectedTags(['digits']));
      }
    }
  }

  /// Expected =
  ///   @expected('digits' ,[0-9]{2,})
  ///   ;
  AsyncResult<Object?> fastParseExpected$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    int? $6;
    Object? $9;
    int $10 = 0;
    void $1() {
      // @expected('digits' ,[0-9]{2,})
      // @expected('digits' ,[0-9]{2,})
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $2 = state.pos;
        $3 = state.failPos;
        $4 = state.errorCount;
      }
      // [0-9]{2,}
      // [0-9]{2,}
      // [0-9]{2,}
      if ($5 == null) {
        $5 = 0;
        $6 = state.pos;
      }
      while (true) {
        // [0-9]
        $9 ??= state.input.beginBuffering();
        final $8 = state.input;
        if (state.pos >= $8.end && !$8.isClosed) {
          $8.sleep = true;
          $8.handle = $1;
          return;
        }
        final $7 = readChar16Async(state);
        if ($7 >= 0) {
          state.ok = $7 >= 48 && $7 <= 57;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        }
        state.input.endBuffering();
        $9 = null;
        if (!state.ok) {
          break;
        }
        $5 = $5! + 1;
      }
      state.setOk($5! >= 2);
      if (!state.ok) {
        state.backtrack($6!);
      }
      $5 = null;
      if (!state.ok && state.canHandleError($3!, $4!)) {
        if (state.failPos == $2!) {
          state.rollbackErrors($3!, $4!);
          state.fail(const ErrorExpectedTags(['digits']));
        }
      }
      $10 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  void fastParseLiteral0(State<String> state) {
    // ''
    state.ok = true;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  AsyncResult<Object?> fastParseLiteral0$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    void $1() {
      // ''
      // ''
      state.ok = true;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  void fastParseLiteral1(State<String> state) {
    // '0'
    const $1 = '0';
    matchLiteral1(state, $1, const ErrorExpectedTags([$1]));
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<Object?> fastParseLiteral1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // '0'
      // '0'
      $4 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      const $3 = '0';
      matchLiteral1Async(state, $3, const ErrorExpectedTags([$3]));
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  void fastParseLiteral2(State<String> state) {
    // '01'
    const $1 = '01';
    matchLiteral2(state, $1, const ErrorExpectedTags([$1]));
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<Object?> fastParseLiteral2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // '01'
      // '01'
      $4 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos + 1 >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      const $3 = '01';
      matchLiteral2Async(state, $3, const ErrorExpectedTags([$3]));
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  void fastParseLiterals(State<String> state) {
    final $4 = state.pos;
    state.ok = false;
    final $1 = state.input;
    if (state.pos < $1.length) {
      final $0 = $1.runeAt(state.pos);
      state.pos += $0 > 0xffff ? 2 : 1;
      switch ($0) {
        case 48:
          const $2 = '012';
          state.ok = $1.startsWith($2, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
          } else {
            state.ok = state.pos < $1.length && $1.runeAt(state.pos) == 49;
            if (state.ok) {
              state.pos += 1;
            }
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $4;
      state.fail(const ErrorExpectedTags(['012', '01']));
    }
  }

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  AsyncResult<Object?> fastParseLiterals$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    Object? $4;
    Object? $7;
    int $8 = 0;
    void $1() {
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
      }
      if ($2 == 0) {
        // '012'
        // '012'
        $4 ??= state.input.beginBuffering();
        final $3 = state.input;
        if (state.pos + 2 >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        const string = '012';
        matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
        state.input.endBuffering();
        $4 = null;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($2 == 1) {
        // '01'
        // '01'
        $7 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos + 1 >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        const $6 = '01';
        matchLiteral2Async(state, $6, const ErrorExpectedTags([$6]));
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  void fastParseMatchString(State<String> state) {
    // @matchString()
    final $1 = text;
    if ($1.isEmpty) {
      state.ok = true;
    } else {
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == $1.codeUnitAt(0) &&
          state.input.startsWith($1, state.pos);
      if (state.ok) {
        state.pos += $1.length;
      } else {
        state.fail(ErrorExpectedTags([$1]));
      }
    }
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  AsyncResult<Object?> fastParseMatchString$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // @matchString()
      // @matchString()
      $4 ??= state.input.beginBuffering();
      final $2 = state.input;
      final $3 = text;
      if (state.pos + $3.length - 1 < $2.end || $2.isClosed) {
        matchLiteralAsync(state, $3, ErrorExpectedTags([$3]));
      } else {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      state.input.endBuffering();
      $4 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  void fastParseNotPredicate(State<String> state) {
    // !([0] [1] [2]) [0] [1]
    final $0 = state.pos;
    final $1 = state.pos;
    // [0] [1] [2]
    final $2 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        matchChar16(state, 50);
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    state.setOk(!state.ok);
    if (!state.ok) {
      final length = $1 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(-1),
        2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($1);
    }
    if (state.ok) {
      matchChar16(state, 48);
      if (state.ok) {
        matchChar16(state, 49);
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  AsyncResult<Object?> fastParseNotPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    int? $6;
    int $10 = 0;
    Object? $12;
    Object? $14;
    void $1() {
      // !([0] [1] [2]) [0] [1]
      if ($10 & 0x4 == 0) {
        $10 |= 0x4;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // !([0] [1] [2])
        if ($10 & 0x2 == 0) {
          $10 |= 0x2;
          state.input.beginBuffering();
          $4 = state.pos;
        }
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($10 & 0x1 == 0) {
          $10 |= 0x1;
          $5 = 0;
          $6 = state.pos;
        }
        if ($5 == 0) {
          // [0]
          final $7 = state.input;
          if (state.pos >= $7.end && !$7.isClosed) {
            $7.sleep = true;
            $7.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $5 = state.ok ? 1 : -1;
        }
        if ($5 == 1) {
          // [1]
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $5 = state.ok ? 2 : -1;
        }
        if ($5 == 2) {
          // [2]
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 50);
          $5 = -1;
        }
        if (!state.ok) {
          state.backtrack($6!);
        }
        $10 &= ~0x1 & 0xffff;
        state.setOk(!state.ok);
        if (!state.ok) {
          final length = $4! - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(-1),
            2 => const ErrorUnexpectedInput(-2),
            _ => ErrorUnexpectedInput(length)
          });
          state.backtrack($4!);
        }
        state.input.endBuffering();
        $10 &= ~0x2 & 0xffff;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [0]
        $12 ??= state.input.beginBuffering();
        final $11 = state.input;
        if (state.pos >= $11.end && !$11.isClosed) {
          $11.sleep = true;
          $11.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $12 = null;
        $2 = state.ok ? 2 : -1;
      }
      if ($2 == 2) {
        // [1]
        $14 ??= state.input.beginBuffering();
        final $13 = state.input;
        if (state.pos >= $13.end && !$13.isClosed) {
          $13.sleep = true;
          $13.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $14 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $10 &= ~0x4 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  void fastParseOneOrMore(State<String> state) {
    // [0]+
    var $1 = false;
    while (true) {
      matchChar16(state, 48);
      if (!state.ok) {
        break;
      }
      $1 = true;
    }
    state.setOk($1);
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  AsyncResult<Object?> fastParseOneOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    bool? $2;
    Object? $4;
    void $1() {
      // [0]+
      // [0]+
      $2 ??= false;
      while (true) {
        // [0]
        $4 ??= state.input.beginBuffering();
        final $3 = state.input;
        if (state.pos >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $4 = null;
        if (!state.ok) {
          break;
        }
        $2 = true;
      }
      state.setOk($2!);
      $2 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  void fastParseOptional(State<String> state) {
    // [0]? [1]
    final $0 = state.pos;
    matchChar16(state, 48);
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      matchChar16(state, 49);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  AsyncResult<Object?> fastParseOptional$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // [0]? [1]
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]?
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        if (!state.ok) {
          state.setOk(true);
        }
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  void fastParseOrderedChoice2(State<String> state) {
    // [0]
    matchChar16(state, 48);
    if (!state.ok && state.isRecoverable) {
      // [1]
      matchChar16(state, 49);
    }
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  AsyncResult<Object?> fastParseOrderedChoice2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    Object? $4;
    Object? $6;
    int $7 = 0;
    void $1() {
      if ($7 & 0x1 == 0) {
        $7 |= 0x1;
        $2 = 0;
      }
      if ($2 == 0) {
        // [0]
        // [0]
        $4 ??= state.input.beginBuffering();
        final $3 = state.input;
        if (state.pos >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $4 = null;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($2 == 1) {
        // [1]
        // [1]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $6 = null;
        $2 = -1;
      }
      $7 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  void fastParseOrderedChoice3(State<String> state) {
    // [0]
    matchChar16(state, 48);
    if (!state.ok && state.isRecoverable) {
      // [1]
      matchChar16(state, 49);
      if (!state.ok && state.isRecoverable) {
        // [2]
        matchChar16(state, 50);
      }
    }
  }

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  AsyncResult<Object?> fastParseOrderedChoice3$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    Object? $4;
    Object? $6;
    Object? $8;
    int $9 = 0;
    void $1() {
      if ($9 & 0x1 == 0) {
        $9 |= 0x1;
        $2 = 0;
      }
      if ($2 == 0) {
        // [0]
        // [0]
        $4 ??= state.input.beginBuffering();
        final $3 = state.input;
        if (state.pos >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $4 = null;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($2 == 1) {
        // [1]
        // [1]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $6 = null;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 2
                : -1;
      }
      if ($2 == 2) {
        // [2]
        // [2]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        matchChar16Async(state, 50);
        state.input.endBuffering();
        $8 = null;
        $2 = -1;
      }
      $9 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  void fastParseRepetitionMax(State<String> state) {
    // [\u{1f680}]{,3}
    var $1 = 0;
    while ($1 < 3) {
      matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $1++;
    }
    state.setOk(true);
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    Object? $5;
    void $1() {
      // [\u{1f680}]{,3}
      // [\u{1f680}]{,3}
      $2 ??= 0;
      while (true) {
        // [\u{1f680}]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar32Async(state, 128640);
        state.input.endBuffering();
        $5 = null;
        if (!state.ok) {
          break;
        }
        final $3 = $2! + 1;
        $2 = $3;
        if ($3 == 3) {
          break;
        }
      }
      state.setOk(true);
      $2 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  void fastParseRepetitionMin(State<String> state) {
    // [\u{1f680}]{3,}
    final $1 = state.pos;
    var $2 = 0;
    while (true) {
      matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.setOk($2 >= 3);
    if (!state.ok) {
      state.backtrack($1);
    }
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMin$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    void $1() {
      // [\u{1f680}]{3,}
      // [\u{1f680}]{3,}
      if ($2 == null) {
        $2 = 0;
        $3 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar32Async(state, 128640);
        state.input.endBuffering();
        $5 = null;
        if (!state.ok) {
          break;
        }
        $2 = $2! + 1;
      }
      state.setOk($2! >= 3);
      if (!state.ok) {
        state.backtrack($3!);
      }
      $2 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  void fastParseRepetitionMinMax(State<String> state) {
    // [\u{1f680}]{2,3}
    final $1 = state.pos;
    var $2 = 0;
    while ($2 < 3) {
      matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.setOk($2 >= 2);
    if (!state.ok) {
      state.backtrack($1);
    }
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMinMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $4;
    Object? $6;
    void $1() {
      // [\u{1f680}]{2,3}
      // [\u{1f680}]{2,3}
      if ($2 == null) {
        $2 = 0;
        $4 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        matchChar32Async(state, 128640);
        state.input.endBuffering();
        $6 = null;
        if (!state.ok) {
          break;
        }
        var $3 = $2!;
        $3++;
        $2 = $3;
        if ($3 == 3) {
          break;
        }
      }
      state.setOk($2! >= 2);
      if (!state.ok) {
        state.backtrack($4!);
      }
      $2 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionN =
  ///   [\u{1f680}]{3,3}
  ///   ;
  void fastParseRepetitionN(State<String> state) {
    // [\u{1f680}]{3,3}
    final $1 = state.pos;
    var $2 = 0;
    while ($2 < 3) {
      matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.setOk($2 == 3);
    if (!state.ok) {
      state.backtrack($1);
    }
  }

  /// RepetitionN =
  ///   [\u{1f680}]{3,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionN$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $4;
    Object? $6;
    void $1() {
      // [\u{1f680}]{3,3}
      // [\u{1f680}]{3,3}
      if ($2 == null) {
        $2 = 0;
        $4 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        matchChar32Async(state, 128640);
        state.input.endBuffering();
        $6 = null;
        if (!state.ok) {
          break;
        }
        final $3 = $2! + 1;
        $2 = $3;
        if ($3 == 3) {
          break;
        }
      }
      state.setOk($2! == 3);
      if (!state.ok) {
        state.backtrack($4!);
      }
      $2 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  void fastParseSepBy(State<String> state) {
    // @sepBy([0], [,])
    var $1 = state.pos;
    while (true) {
      // [0]
      matchChar16(state, 48);
      if (!state.ok) {
        state.backtrack($1);
        break;
      }
      $1 = state.pos;
      // [,]
      matchChar16(state, 44);
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  AsyncResult<Object?> fastParseSepBy$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // @sepBy([0], [,])
      // @sepBy([0], [,])
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $3 = state.pos;
        $2 = 0;
      }
      while (true) {
        if ($2 == 0) {
          // [0]
          // [0]
          $5 ??= state.input.beginBuffering();
          final $4 = state.input;
          if (state.pos >= $4.end && !$4.isClosed) {
            $4.sleep = true;
            $4.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          state.input.endBuffering();
          $5 = null;
          if (!state.ok) {
            state.backtrack($3!);
            break;
          }
          $3 = state.pos;
          $2 = 1;
        }
        if ($2 == 1) {
          // [,]
          // [,]
          $7 ??= state.input.beginBuffering();
          final $6 = state.input;
          if (state.pos >= $6.end && !$6.isClosed) {
            $6.sleep = true;
            $6.handle = $1;
            return;
          }
          matchChar16Async(state, 44);
          state.input.endBuffering();
          $7 = null;
          if (!state.ok) {
            break;
          }
          $2 = 0;
        }
      }
      state.setOk(true);
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  void fastParseSequence1(State<String> state) {
    // [0]
    matchChar16(state, 48);
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    void $1() {
      // [0]
      // [0]
      $3 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      matchChar16Async(state, 48);
      state.input.endBuffering();
      $3 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  void fastParseSequence1WithAction(State<String> state) {
    // [0] <int>{}
    matchChar16(state, 48);
    if (state.ok) {
      // ignore: unused_local_variable
      int? $$;
      $$ = 0x30;
    }
  }

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    void $1() {
      // [0] <int>{}
      // [0]
      $3 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      matchChar16Async(state, 48);
      state.input.endBuffering();
      $3 = null;
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        $$ = 0x30;
      }
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  void fastParseSequence1WithVariable(State<String> state) {
    // v:[0]
    matchChar16(state, 48);
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    void $1() {
      // v:[0]
      // [0]
      $3 ??= state.input.beginBuffering();
      final $2 = state.input;
      if (state.pos >= $2.end && !$2.isClosed) {
        $2.sleep = true;
        $2.handle = $1;
        return;
      }
      matchChar16Async(state, 48);
      state.input.endBuffering();
      $3 = null;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  void fastParseSequence1WithVariableWithAction(State<String> state) {
    // v:[0] <int>{}
    int? $1;
    $1 = matchChar16(state, 48);
    if (state.ok) {
      // ignore: unused_local_variable
      int? $$;
      final v = $1!;
      $$ = v;
    }
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    Object? $4;
    void $1() {
      // v:[0] <int>{}
      // [0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      $2 = matchChar16Async(state, 48);
      state.input.endBuffering();
      $4 = null;
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v = $2!;
        $$ = v;
      }
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  void fastParseSequence2(State<String> state) {
    // [0] [1]
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // [0] [1]
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  void fastParseSequence2WithAction(State<String> state) {
    // [0] [1] <int>{}
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        $$ = 0x30;
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // [0] [1] <int>{}
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        $$ = 0x30;
      } else {
        state.backtrack($3!);
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  void fastParseSequence2WithVariable(State<String> state) {
    // v:[0] [1]
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // v:[0] [1]
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  void fastParseSequence2WithVariableWithAction(State<String> state) {
    // v:[0] [1] <int>{}
    final $0 = state.pos;
    int? $1;
    $1 = matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v = $1!;
        $$ = v;
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    int? $2;
    Object? $6;
    Object? $8;
    int $9 = 0;
    void $1() {
      // v:[0] [1] <int>{}
      if ($9 & 0x1 == 0) {
        $9 |= 0x1;
        $3 = 0;
        $4 = state.pos;
      }
      if ($3 == 0) {
        // [0]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $6 = null;
        $3 = state.ok ? 1 : -1;
      }
      if ($3 == 1) {
        // [1]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $8 = null;
        $3 = -1;
      }
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v = $2!;
        $$ = v;
      } else {
        state.backtrack($4!);
      }
      $9 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  void fastParseSequence2WithVariables(State<String> state) {
    // v1:[0] v2:[1]
    final $0 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariables$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // v1:[0] v2:[1]
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $2 = 0;
        $3 = state.pos;
      }
      if ($2 == 0) {
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $2 = state.ok ? 1 : -1;
      }
      if ($2 == 1) {
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $2 = -1;
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  void fastParseSequence2WithVariablesWithAction(State<String> state) {
    // v1:[0] v2:[1] <int>{}
    final $0 = state.pos;
    int? $1;
    $1 = matchChar16(state, 48);
    if (state.ok) {
      int? $2;
      $2 = matchChar16(state, 49);
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v1 = $1!;
        final v2 = $2!;
        $$ = v1 + v2;
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariablesWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $4;
    int? $5;
    int? $2;
    Object? $7;
    int? $3;
    Object? $9;
    int $10 = 0;
    void $1() {
      // v1:[0] v2:[1] <int>{}
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // [0]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $7 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // [1]
        $9 ??= state.input.beginBuffering();
        final $8 = state.input;
        if (state.pos >= $8.end && !$8.isClosed) {
          $8.sleep = true;
          $8.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $9 = null;
        $4 = -1;
      }
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v1 = $2!;
        final v2 = $3!;
        $$ = v1 + v2;
      } else {
        state.backtrack($5!);
      }
      $10 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  void fastParseSlice(State<String> state) {
    // $([0] [1] [2])
    // [0] [1] [2]
    final $2 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        matchChar16(state, 50);
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (!state.ok && state.isRecoverable) {
      // $([0] [1])
      // [0] [1]
      final $5 = state.pos;
      matchChar16(state, 48);
      if (state.ok) {
        matchChar16(state, 49);
      }
      if (!state.ok) {
        state.backtrack($5);
      }
    }
  }

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  AsyncResult<Object?> fastParseSlice$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    int? $4;
    int $8 = 0;
    Object? $9;
    int? $10;
    int? $11;
    Object? $14;
    void $1() {
      if ($8 & 0x4 == 0) {
        $8 |= 0x4;
        $2 = 0;
      }
      if ($2 == 0) {
        // $([0] [1] [2])
        // $([0] [1] [2])
        $9 ??= state.input.beginBuffering();
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($8 & 0x1 == 0) {
          $8 |= 0x1;
          $3 = 0;
          $4 = state.pos;
        }
        if ($3 == 0) {
          // [0]
          final $5 = state.input;
          if (state.pos >= $5.end && !$5.isClosed) {
            $5.sleep = true;
            $5.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $3 = state.ok ? 1 : -1;
        }
        if ($3 == 1) {
          // [1]
          final $6 = state.input;
          if (state.pos >= $6.end && !$6.isClosed) {
            $6.sleep = true;
            $6.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $3 = state.ok ? 2 : -1;
        }
        if ($3 == 2) {
          // [2]
          final $7 = state.input;
          if (state.pos >= $7.end && !$7.isClosed) {
            $7.sleep = true;
            $7.handle = $1;
            return;
          }
          matchChar16Async(state, 50);
          $3 = -1;
        }
        if (!state.ok) {
          state.backtrack($4!);
        }
        $8 &= ~0x1 & 0xffff;
        state.input.endBuffering();
        $9 = null;
        $2 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($2 == 1) {
        // $([0] [1])
        // $([0] [1])
        $14 ??= state.input.beginBuffering();
        // ([0] [1])
        // [0] [1]
        // [0] [1]
        if ($8 & 0x2 == 0) {
          $8 |= 0x2;
          $10 = 0;
          $11 = state.pos;
        }
        if ($10 == 0) {
          // [0]
          final $12 = state.input;
          if (state.pos >= $12.end && !$12.isClosed) {
            $12.sleep = true;
            $12.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $10 = state.ok ? 1 : -1;
        }
        if ($10 == 1) {
          // [1]
          final $13 = state.input;
          if (state.pos >= $13.end && !$13.isClosed) {
            $13.sleep = true;
            $13.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $10 = -1;
        }
        if (!state.ok) {
          state.backtrack($11!);
        }
        $8 &= ~0x2 & 0xffff;
        state.input.endBuffering();
        $14 = null;
        $2 = -1;
      }
      $8 &= ~0x4 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  void fastParseStringChars(State<String> state) {
    // @stringChars($[0-9]+, [\\], [t] <String>{})
    final $7 = state.input;
    while (state.pos < $7.length) {
      // $[0-9]+
      var $3 = false;
      while (true) {
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $4 = state.input.codeUnitAt(state.pos);
          state.ok = $4 >= 48 && $4 <= 57;
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
        $3 = true;
      }
      state.setOk($3);
      final pos = state.pos;
      // [\\]
      matchChar16(state, 92);
      if (!state.ok) {
        break;
      }
      // [t] <String>{}
      matchChar16(state, 116);
      if (state.ok) {
        // ignore: unused_local_variable
        String? $$;
        $$ = '\t';
      }
      if (!state.ok) {
        state.backtrack(pos);
        break;
      }
    }
    state.ok = true;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  AsyncResult<Object?> fastParseStringChars$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $2;
    int? $3;
    bool? $4;
    Object? $7;
    Object? $9;
    Object? $11;
    int $12 = 0;
    void $1() {
      // @stringChars($[0-9]+, [\\], [t] <String>{})
      // @stringChars($[0-9]+, [\\], [t] <String>{})
      if ($12 & 0x1 == 0) {
        $12 |= 0x1;
        $2 = 0;
      }
      while (true) {
        if ($2 == 0) {
          // $[0-9]+
          // $[0-9]+
          // $[0-9]+
          $7 ??= state.input.beginBuffering();
          // [0-9]+
          $4 ??= false;
          while (true) {
            // [0-9]
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              return;
            }
            final $5 = readChar16Async(state);
            if ($5 >= 0) {
              state.ok = $5 >= 48 && $5 <= 57;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            if (!state.ok) {
              break;
            }
            $4 = true;
          }
          state.setOk($4!);
          $4 = null;
          state.input.endBuffering();
          $7 = null;
          $3 = state.pos;
          $2 = 1;
        }
        if ($2 == 1) {
          // [\\]
          // [\\]
          // [\\]
          $9 ??= state.input.beginBuffering();
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          matchChar16Async(state, 92);
          state.input.endBuffering();
          $9 = null;
          if (!state.ok) {
            break;
          }
          $2 = 2;
        }
        if ($2 == 2) {
          // [t] <String>{}
          // [t] <String>{}
          // [t]
          $11 ??= state.input.beginBuffering();
          final $10 = state.input;
          if (state.pos >= $10.end && !$10.isClosed) {
            $10.sleep = true;
            $10.handle = $1;
            return;
          }
          matchChar16Async(state, 116);
          state.input.endBuffering();
          $11 = null;
          if (state.ok) {
            // ignore: unused_local_variable
            String? $$;
            $$ = '\t';
          }
          if (!state.ok) {
            state.backtrack($3!);
            break;
          }
          $2 = 0;
        }
      }
      state.ok = true;
      $12 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  void fastParseVerify(State<String> state) {
    // @verify(.)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    int? $1;
    // .
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.runeAt(state.pos);
      state.pos += $6 > 0xffff ? 2 : 1;
      state.ok = true;
      $1 = $6;
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $1!;
      ParseError? error;
      if ($$ != 0x30) {
        error = const ErrorMessage(0, 'error');
      }
      if (error != null) {
        if ($3 <= pos) {
          state.failPos = $3;
          state.errorCount = $2;
        }
        state.failAt(pos, error);
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  AsyncResult<Object?> fastParseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    int? $5;
    int? $2;
    int $8 = 0;
    void $1() {
      // @verify(.)
      // @verify(.)
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        state.input.beginBuffering();
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
      }
      // .
      // .
      // .
      final $7 = state.input;
      if (state.pos >= $7.end && !$7.isClosed) {
        $7.sleep = true;
        $7.handle = $1;
        return;
      }
      final $6 = readChar32Async(state);
      state.ok = $6 >= 0;
      if (state.ok) {
        state.pos += $6 > 0xffff ? 2 : 1;
        $2 = $6;
      }
      if (state.ok) {
        final pos = $3!;
        // ignore: unused_local_variable
        final $$ = $2!;
        ParseError? error;
        if ($$ != 0x30) {
          error = const ErrorMessage(0, 'error');
        }
        if (error != null) {
          if ($4! <= pos) {
            state.failPos = $4!;
            state.errorCount = $5!;
          }
          state.failAt(pos, error);
        }
      }
      if (!state.ok) {
        state.backtrack($3!);
      }
      state.input.endBuffering();
      $8 &= ~0x1 & 0xffff;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  void fastParseZeroOrMore(State<String> state) {
    // [0]*
    while (true) {
      matchChar16(state, 48);
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  AsyncResult<Object?> fastParseZeroOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    void $1() {
      // [0]*
      // [0]*
      while (true) {
        // [0]
        $3 ??= state.input.beginBuffering();
        final $2 = state.input;
        if (state.pos >= $2.end && !$2.isClosed) {
          $2.sleep = true;
          $2.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $3 = null;
        if (!state.ok) {
          break;
        }
      }
      state.setOk(true);
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
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
  int? matchChar16Async(State<ChunkedParsingSink> state, int char) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      state.ok = input.data.codeUnitAt(pos - start) == char;
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
  int? matchChar32(State<String> state, int char) {
    final input = state.input;
    final pos = state.pos;
    if (pos < input.length) {
      state.ok = input.runeAt(pos) == char;
      if (state.ok) {
        state.pos += char > 0xffff ? 2 : 1;
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
  int? matchChar32Async(State<ChunkedParsingSink> state, int char) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      state.ok = input.data.runeAt(pos - start) == char;
      if (state.ok) {
        state.pos += char > 0xffff ? 2 : 1;
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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1Async(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    state.ok = pos < input.end &&
        input.data.codeUnitAt(pos - start) == string.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral2(State<String> state, String string, ParseError error) {
    final input = state.input;
    final pos = state.pos;
    final pos2 = pos + 1;
    state.ok = pos2 < input.length &&
        input.codeUnitAt(pos) == string.codeUnitAt(0) &&
        input.codeUnitAt(pos2) == string.codeUnitAt(1);
    if (state.ok) {
      state.pos += 2;
      state.ok = true;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral2Async(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    final start = input.start;
    final data = input.data;
    final pos = state.pos;
    final index = pos - start;
    state.ok = pos + 1 < input.end &&
        data.codeUnitAt(index) == string.codeUnitAt(0) &&
        data.codeUnitAt(index + 1) == string.codeUnitAt(1);
    if (state.ok) {
      state.pos += 2;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteralAsync(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
    final start = input.start;
    final data = input.data;
    final pos = state.pos;
    final index = pos - start;
    state.ok = pos <= input.end &&
        data.codeUnitAt(index) == string.codeUnitAt(0) &&
        data.startsWith(string, index);
    if (state.ok) {
      state.pos += string.length;
      return string;
    }
    state.fail(error);
    return null;
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  List<Object?>? parseAndPredicate(State<String> state) {
    List<Object?>? $0;
    // &([0] [1] [2]) [0] [1] [2]
    final $1 = state.pos;
    List<Object?>? $2;
    final $6 = state.pos;
    final $7 = state.cuttingPos;
    // [0] [1] [2]
    final $8 = state.pos;
    int? $9;
    $9 = matchChar16(state, 48);
    if (state.ok) {
      int? $10;
      $10 = matchChar16(state, 49);
      if (state.ok) {
        int? $11;
        $11 = matchChar16(state, 50);
        if (state.ok) {
          $2 = [$9!, $10!, $11!];
        }
      }
    }
    if (!state.ok) {
      state.backtrack($8);
    }
    state.cuttingPos = $7;
    if (state.ok) {
      state.pos = $6;
    }
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 48);
      if (state.ok) {
        int? $4;
        $4 = matchChar16(state, 49);
        if (state.ok) {
          int? $5;
          $5 = matchChar16(state, 50);
          if (state.ok) {
            $0 = [$2!, $3!, $4!, $5!];
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  AsyncResult<List<Object?>> parseAndPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $7;
    int? $8;
    List<Object?>? $3;
    int? $9;
    int? $10;
    int? $14;
    int? $15;
    int? $11;
    int? $12;
    int? $13;
    int $19 = 0;
    int? $4;
    Object? $21;
    int? $5;
    Object? $23;
    int? $6;
    Object? $25;
    void $1() {
      // &([0] [1] [2]) [0] [1] [2]
      if ($19 & 0x4 == 0) {
        $19 |= 0x4;
        $7 = 0;
        $8 = state.pos;
      }
      if ($7 == 0) {
        // &([0] [1] [2])
        if ($19 & 0x2 == 0) {
          $19 |= 0x2;
          state.input.beginBuffering();
          $9 = state.pos;
          $10 = state.cuttingPos;
        }
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($19 & 0x1 == 0) {
          $19 |= 0x1;
          $14 = 0;
          $15 = state.pos;
        }
        if ($14 == 0) {
          // [0]
          final $16 = state.input;
          if (state.pos >= $16.end && !$16.isClosed) {
            $16.sleep = true;
            $16.handle = $1;
            return;
          }
          $11 = matchChar16Async(state, 48);
          $14 = state.ok ? 1 : -1;
        }
        if ($14 == 1) {
          // [1]
          final $17 = state.input;
          if (state.pos >= $17.end && !$17.isClosed) {
            $17.sleep = true;
            $17.handle = $1;
            return;
          }
          $12 = matchChar16Async(state, 49);
          $14 = state.ok ? 2 : -1;
        }
        if ($14 == 2) {
          // [2]
          final $18 = state.input;
          if (state.pos >= $18.end && !$18.isClosed) {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          $13 = matchChar16Async(state, 50);
          $14 = -1;
        }
        if (state.ok) {
          $3 = [$11!, $12!, $13!];
        } else {
          state.backtrack($15!);
        }
        $19 &= ~0x1 & 0xffff;
        state.cuttingPos = $10!;
        if (state.ok) {
          state.pos = $9!;
        }
        state.input.endBuffering();
        $19 &= ~0x2 & 0xffff;
        $7 = state.ok ? 1 : -1;
      }
      if ($7 == 1) {
        // [0]
        $21 ??= state.input.beginBuffering();
        final $20 = state.input;
        if (state.pos >= $20.end && !$20.isClosed) {
          $20.sleep = true;
          $20.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $21 = null;
        $7 = state.ok ? 2 : -1;
      }
      if ($7 == 2) {
        // [1]
        $23 ??= state.input.beginBuffering();
        final $22 = state.input;
        if (state.pos >= $22.end && !$22.isClosed) {
          $22.sleep = true;
          $22.handle = $1;
          return;
        }
        $5 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $23 = null;
        $7 = state.ok ? 3 : -1;
      }
      if ($7 == 3) {
        // [2]
        $25 ??= state.input.beginBuffering();
        final $24 = state.input;
        if (state.pos >= $24.end && !$24.isClosed) {
          $24.sleep = true;
          $24.handle = $1;
          return;
        }
        $6 = matchChar16Async(state, 50);
        state.input.endBuffering();
        $25 = null;
        $7 = -1;
      }
      if (state.ok) {
        $2 = [$3!, $4!, $5!, $6!];
      } else {
        state.backtrack($8!);
      }
      $19 &= ~0x4 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// AnyCharacter =
  ///   .
  ///   ;
  int? parseAnyCharacter(State<String> state) {
    int? $0;
    // .
    final $3 = state.input;
    if (state.pos < $3.length) {
      final $2 = $3.runeAt(state.pos);
      state.pos += $2 > 0xffff ? 2 : 1;
      state.ok = true;
      $0 = $2;
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// AnyCharacter =
  ///   .
  ///   ;
  AsyncResult<int> parseAnyCharacter$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    void $1() {
      // .
      // .
      final $4 = state.input;
      if (state.pos >= $4.end && !$4.isClosed) {
        $4.sleep = true;
        $4.handle = $1;
        return;
      }
      final $3 = readChar32Async(state);
      state.ok = $3 >= 0;
      if (state.ok) {
        state.pos += $3 > 0xffff ? 2 : 1;
        $2 = $3;
      }
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  int? parseCharacterClass(State<String> state) {
    int? $0;
    // [0-9]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.codeUnitAt(state.pos);
      state.ok = $2 >= 48 && $2 <= 57;
      if (state.ok) {
        state.pos++;
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  AsyncResult<int> parseCharacterClass$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $5;
    void $1() {
      // [0-9]
      // [0-9]
      $5 ??= state.input.beginBuffering();
      final $4 = state.input;
      if (state.pos >= $4.end && !$4.isClosed) {
        $4.sleep = true;
        $4.handle = $1;
        return;
      }
      final $3 = readChar16Async(state);
      if ($3 >= 0) {
        state.ok = $3 >= 48 && $3 <= 57;
        if (state.ok) {
          state.pos++;
          $2 = $3;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  int? parseCharacterClassChar32(State<String> state) {
    int? $0;
    // [\u{1f680}]
    $0 = matchChar32(state, 128640);
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $4;
    void $1() {
      // [\u{1f680}]
      // [\u{1f680}]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      $2 = matchChar32Async(state, 128640);
      state.input.endBuffering();
      $4 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  int? parseCharacterClassCharNegate(State<String> state) {
    int? $0;
    // [^0]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.runeAt(state.pos);
      state.ok = $2 != 48;
      if (state.ok) {
        state.pos += $2 > 0xffff ? 2 : 1;
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  AsyncResult<int> parseCharacterClassCharNegate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $5;
    void $1() {
      // [^0]
      // [^0]
      $5 ??= state.input.beginBuffering();
      final $4 = state.input;
      if (state.pos >= $4.end && !$4.isClosed) {
        $4.sleep = true;
        $4.handle = $1;
        return;
      }
      final $3 = readChar32Async(state);
      if ($3 >= 0) {
        state.ok = $3 != 48;
        if (state.ok) {
          state.pos += $3 > 0xffff ? 2 : 1;
          $2 = $3;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  int? parseCharacterClassCharNegate32(State<String> state) {
    int? $0;
    // [^\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.runeAt(state.pos);
      state.ok = $2 != 128640;
      if (state.ok) {
        state.pos += $2 > 0xffff ? 2 : 1;
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassCharNegate32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $5;
    void $1() {
      // [^\u{1f680}]
      // [^\u{1f680}]
      $5 ??= state.input.beginBuffering();
      final $4 = state.input;
      if (state.pos >= $4.end && !$4.isClosed) {
        $4.sleep = true;
        $4.handle = $1;
        return;
      }
      final $3 = readChar32Async(state);
      if ($3 >= 0) {
        state.ok = $3 != 128640;
        if (state.ok) {
          state.pos += $3 > 0xffff ? 2 : 1;
          $2 = $3;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  int? parseCharacterClassRange32(State<String> state) {
    int? $0;
    // [ -\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.runeAt(state.pos);
      state.ok = $2 >= 32 && $2 <= 128640;
      if (state.ok) {
        state.pos += $2 > 0xffff ? 2 : 1;
        $0 = $2;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassRange32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $5;
    void $1() {
      // [ -\u{1f680}]
      // [ -\u{1f680}]
      $5 ??= state.input.beginBuffering();
      final $4 = state.input;
      if (state.pos >= $4.end && !$4.isClosed) {
        $4.sleep = true;
        $4.handle = $1;
        return;
      }
      final $3 = readChar32Async(state);
      if ($3 >= 0) {
        state.ok = $3 >= 32 && $3 <= 128640;
        if (state.ok) {
          state.pos += $3 > 0xffff ? 2 : 1;
          $2 = $3;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Cut =
  ///     [0] [+] ↑ [1]
  ///   / [0]
  ///   ;
  Object? parseCut(State<String> state) {
    Object? $0;
    // [0] [+] ↑ [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 43);
      if (state.ok) {
        Object? $4;
        state.cut(state.pos);
        if (state.ok) {
          int? $5;
          $5 = matchChar16(state, 49);
          if (state.ok) {
            $0 = [$2!, $3!, $4, $5!];
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    if (!state.ok && state.isRecoverable) {
      // [0]
      $0 = matchChar16(state, 48);
    }
    return $0;
  }

  /// Cut =
  ///     [0] [+] ↑ [1]
  ///   / [0]
  ///   ;
  AsyncResult<Object?> parseCut$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    int? $3;
    int? $8;
    int? $9;
    int? $4;
    Object? $11;
    int? $5;
    Object? $13;
    Object? $6;
    int? $7;
    Object? $15;
    int $16 = 0;
    Object? $18;
    void $1() {
      if ($16 & 0x2 == 0) {
        $16 |= 0x2;
        $3 = 0;
      }
      if ($3 == 0) {
        // [0] [+] ↑ [1]
        if ($16 & 0x1 == 0) {
          $16 |= 0x1;
          $8 = 0;
          $9 = state.pos;
        }
        if ($8 == 0) {
          // [0]
          $11 ??= state.input.beginBuffering();
          final $10 = state.input;
          if (state.pos >= $10.end && !$10.isClosed) {
            $10.sleep = true;
            $10.handle = $1;
            return;
          }
          $4 = matchChar16Async(state, 48);
          state.input.endBuffering();
          $11 = null;
          $8 = state.ok ? 1 : -1;
        }
        if ($8 == 1) {
          // [+]
          $13 ??= state.input.beginBuffering();
          final $12 = state.input;
          if (state.pos >= $12.end && !$12.isClosed) {
            $12.sleep = true;
            $12.handle = $1;
            return;
          }
          $5 = matchChar16Async(state, 43);
          state.input.endBuffering();
          $13 = null;
          $8 = state.ok ? 2 : -1;
        }
        if ($8 == 2) {
          // ↑
          state.cut(state.pos);
          state.input.cut(state.pos);
          $8 = state.ok ? 3 : -1;
        }
        if ($8 == 3) {
          // [1]
          $15 ??= state.input.beginBuffering();
          final $14 = state.input;
          if (state.pos >= $14.end && !$14.isClosed) {
            $14.sleep = true;
            $14.handle = $1;
            return;
          }
          $7 = matchChar16Async(state, 49);
          state.input.endBuffering();
          $15 = null;
          $8 = -1;
        }
        if (state.ok) {
          $2 = [$4!, $5!, $6, $7!];
        } else {
          state.backtrack($9!);
        }
        $16 &= ~0x1 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // [0]
        // [0]
        $18 ??= state.input.beginBuffering();
        final $17 = state.input;
        if (state.pos >= $17.end && !$17.isClosed) {
          $17.sleep = true;
          $17.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $18 = null;
        $3 = -1;
      }
      $16 &= ~0x2 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Eof =
  ///   [0] @eof()
  ///   ;
  List<Object?>? parseEof(State<String> state) {
    List<Object?>? $0;
    // [0] @eof()
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      Object? $3;
      state.ok = state.pos >= state.input.length;
      if (!state.ok) {
        state.fail(const ErrorExpectedEndOfInput());
      }
      if (state.ok) {
        $0 = [$2!, $3];
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Eof =
  ///   [0] @eof()
  ///   ;
  AsyncResult<List<Object?>> parseEof$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $5;
    int? $6;
    int? $3;
    Object? $8;
    Object? $4;
    int $10 = 0;
    void $1() {
      // [0] @eof()
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // [0]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $8 = null;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // @eof()
        final $9 = state.input;
        if (state.pos >= $9.end && !$9.isClosed) {
          $9.sleep = true;
          $9.handle = $1;
          return;
        }
        state.ok = state.pos >= $9.end;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
        $5 = -1;
      }
      if (state.ok) {
        $2 = [$3!, $4];
      } else {
        state.backtrack($6!);
      }
      $10 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  int? parseErrorHandler(State<String> state) {
    int? $0;
    // @errorHandler([0])
    final $2 = state.pos;
    final $3 = state.failPos;
    final $4 = state.errorCount;
    // [0]
    $0 = matchChar16(state, 48);
    if (!state.ok && state.canHandleError($3, $4)) {
      // ignore: unused_local_variable
      final start = $2;
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error = const ErrorMessage(0, 'error');
      if (rollbackErrors == true) {
        state.rollbackErrors($3, $4);
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

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  AsyncResult<int> parseErrorHandler$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      // @errorHandler([0])
      // @errorHandler([0])
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
      }
      // [0]
      // [0]
      // [0]
      $7 ??= state.input.beginBuffering();
      final $6 = state.input;
      if (state.pos >= $6.end && !$6.isClosed) {
        $6.sleep = true;
        $6.handle = $1;
        return;
      }
      $2 = matchChar16Async(state, 48);
      state.input.endBuffering();
      $7 = null;
      if (!state.ok && state.canHandleError($4!, $5!)) {
        // ignore: unused_local_variable
        final start = $3!;
        ParseError? error;
        // ignore: prefer_final_locals
        var rollbackErrors = false;
        rollbackErrors = true;
        error = const ErrorMessage(0, 'error');
        if (rollbackErrors == true) {
          state.rollbackErrors($4!, $5!);
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
      $8 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Expected =
  ///   @expected('digits' ,[0-9]{2,})
  ///   ;
  List<int>? parseExpected(State<String> state) {
    List<int>? $0;
    // @expected('digits' ,[0-9]{2,})
    final $2 = state.pos;
    final $3 = state.failPos;
    final $4 = state.errorCount;
    // [0-9]{2,}
    final $6 = state.pos;
    final $7 = <int>[];
    while (true) {
      int? $8;
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $9 = state.input.codeUnitAt(state.pos);
        state.ok = $9 >= 48 && $9 <= 57;
        if (state.ok) {
          state.pos++;
          $8 = $9;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $7.add($8!);
    }
    state.setOk($7.length >= 2);
    if (state.ok) {
      $0 = $7;
    } else {
      state.backtrack($6);
    }
    if (!state.ok && state.canHandleError($3, $4)) {
      if (state.failPos == $2) {
        state.rollbackErrors($3, $4);
        state.fail(const ErrorExpectedTags(['digits']));
      }
    }
    return $0;
  }

  /// Expected =
  ///   @expected('digits' ,[0-9]{2,})
  ///   ;
  AsyncResult<List<int>> parseExpected$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    int? $3;
    int? $4;
    int? $5;
    List<int>? $6;
    int? $8;
    int? $7;
    Object? $11;
    int $12 = 0;
    void $1() {
      // @expected('digits' ,[0-9]{2,})
      // @expected('digits' ,[0-9]{2,})
      if ($12 & 0x1 == 0) {
        $12 |= 0x1;
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
      }
      // [0-9]{2,}
      // [0-9]{2,}
      // [0-9]{2,}
      if ($6 == null) {
        $6 = [];
        $8 = state.pos;
      }
      while (true) {
        // [0-9]
        $11 ??= state.input.beginBuffering();
        final $10 = state.input;
        if (state.pos >= $10.end && !$10.isClosed) {
          $10.sleep = true;
          $10.handle = $1;
          return;
        }
        final $9 = readChar16Async(state);
        if ($9 >= 0) {
          state.ok = $9 >= 48 && $9 <= 57;
          if (state.ok) {
            state.pos++;
            $7 = $9;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        }
        state.input.endBuffering();
        $11 = null;
        if (!state.ok) {
          break;
        }
        $6!.add($7!);
        $7 = null;
      }
      state.setOk($6!.length >= 2);
      if (state.ok) {
        $2 = $6;
        $6 = null;
      } else {
        state.backtrack($8!);
      }
      $6 = null;
      if (!state.ok && state.canHandleError($4!, $5!)) {
        if (state.failPos == $3!) {
          state.rollbackErrors($4!, $5!);
          state.fail(const ErrorExpectedTags(['digits']));
        }
      }
      $12 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  String? parseLiteral0(State<String> state) {
    String? $0;
    // ''
    state.ok = true;
    if (state.ok) {
      $0 = '';
    }
    return $0;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  AsyncResult<String> parseLiteral0$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    void $1() {
      // ''
      // ''
      state.ok = true;
      $2 = '';
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  String? parseLiteral1(State<String> state) {
    String? $0;
    // '0'
    const $2 = '0';
    $0 = matchLiteral1(state, $2, const ErrorExpectedTags([$2]));
    return $0;
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<String> parseLiteral1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    Object? $5;
    void $1() {
      // '0'
      // '0'
      $5 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      const $4 = '0';
      $2 = matchLiteral1Async(state, $4, const ErrorExpectedTags([$4]));
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  String? parseLiteral2(State<String> state) {
    String? $0;
    // '01'
    const $2 = '01';
    $0 = matchLiteral2(state, $2, const ErrorExpectedTags([$2]));
    return $0;
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<String> parseLiteral2$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    Object? $5;
    void $1() {
      // '01'
      // '01'
      $5 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos + 1 >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      const $4 = '01';
      $2 = matchLiteral2Async(state, $4, const ErrorExpectedTags([$4]));
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  String? parseLiterals(State<String> state) {
    String? $0;
    final $5 = state.pos;
    state.ok = false;
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.pos += $1 > 0xffff ? 2 : 1;
      switch ($1) {
        case 48:
          const $3 = '012';
          state.ok = $2.startsWith($3, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
            $0 = $3;
          } else {
            state.ok = state.pos < $2.length && $2.runeAt(state.pos) == 49;
            if (state.ok) {
              state.pos += 1;
              $0 = '01';
            }
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $5;
      state.fail(const ErrorExpectedTags(['012', '01']));
    }
    return $0;
  }

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  AsyncResult<String> parseLiterals$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    int? $3;
    Object? $5;
    Object? $8;
    int $9 = 0;
    void $1() {
      if ($9 & 0x1 == 0) {
        $9 |= 0x1;
        $3 = 0;
      }
      if ($3 == 0) {
        // '012'
        // '012'
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos + 2 >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        const string = '012';
        $2 =
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
        state.input.endBuffering();
        $5 = null;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // '01'
        // '01'
        $8 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos + 1 >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        const $7 = '01';
        $2 = matchLiteral2Async(state, $7, const ErrorExpectedTags([$7]));
        state.input.endBuffering();
        $8 = null;
        $3 = -1;
      }
      $9 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  String? parseMatchString(State<String> state) {
    String? $0;
    // @matchString()
    final $2 = text;
    if ($2.isEmpty) {
      state.ok = true;
      $0 = '';
    } else {
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == $2.codeUnitAt(0) &&
          state.input.startsWith($2, state.pos);
      if (state.ok) {
        state.pos += $2.length;
        $0 = $2;
      } else {
        state.fail(ErrorExpectedTags([$2]));
      }
    }
    return $0;
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  AsyncResult<String> parseMatchString$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    Object? $5;
    void $1() {
      // @matchString()
      // @matchString()
      $5 ??= state.input.beginBuffering();
      final $3 = state.input;
      final $4 = text;
      if (state.pos + $4.length - 1 < $3.end || $3.isClosed) {
        $2 = matchLiteralAsync(state, $4, ErrorExpectedTags([$4]));
      } else {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      state.input.endBuffering();
      $5 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  List<Object?>? parseNotPredicate(State<String> state) {
    List<Object?>? $0;
    // !([0] [1] [2]) [0] [1]
    final $1 = state.pos;
    Object? $2;
    final $5 = state.pos;
    // [0] [1] [2]
    final $6 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        matchChar16(state, 50);
      }
    }
    if (!state.ok) {
      state.backtrack($6);
    }
    state.setOk(!state.ok);
    if (!state.ok) {
      final length = $5 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(-1),
        2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($5);
    }
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 48);
      if (state.ok) {
        int? $4;
        $4 = matchChar16(state, 49);
        if (state.ok) {
          $0 = [$2, $3!, $4!];
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  AsyncResult<List<Object?>> parseNotPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $6;
    int? $7;
    Object? $3;
    int? $8;
    int? $9;
    int? $10;
    int $14 = 0;
    int? $4;
    Object? $16;
    int? $5;
    Object? $18;
    void $1() {
      // !([0] [1] [2]) [0] [1]
      if ($14 & 0x4 == 0) {
        $14 |= 0x4;
        $6 = 0;
        $7 = state.pos;
      }
      if ($6 == 0) {
        // !([0] [1] [2])
        if ($14 & 0x2 == 0) {
          $14 |= 0x2;
          state.input.beginBuffering();
          $8 = state.pos;
        }
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($14 & 0x1 == 0) {
          $14 |= 0x1;
          $9 = 0;
          $10 = state.pos;
        }
        if ($9 == 0) {
          // [0]
          final $11 = state.input;
          if (state.pos >= $11.end && !$11.isClosed) {
            $11.sleep = true;
            $11.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $9 = state.ok ? 1 : -1;
        }
        if ($9 == 1) {
          // [1]
          final $12 = state.input;
          if (state.pos >= $12.end && !$12.isClosed) {
            $12.sleep = true;
            $12.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $9 = state.ok ? 2 : -1;
        }
        if ($9 == 2) {
          // [2]
          final $13 = state.input;
          if (state.pos >= $13.end && !$13.isClosed) {
            $13.sleep = true;
            $13.handle = $1;
            return;
          }
          matchChar16Async(state, 50);
          $9 = -1;
        }
        if (!state.ok) {
          state.backtrack($10!);
        }
        $14 &= ~0x1 & 0xffff;
        state.setOk(!state.ok);
        if (!state.ok) {
          final length = $8! - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(-1),
            2 => const ErrorUnexpectedInput(-2),
            _ => ErrorUnexpectedInput(length)
          });
          state.backtrack($8!);
        }
        state.input.endBuffering();
        $14 &= ~0x2 & 0xffff;
        $6 = state.ok ? 1 : -1;
      }
      if ($6 == 1) {
        // [0]
        $16 ??= state.input.beginBuffering();
        final $15 = state.input;
        if (state.pos >= $15.end && !$15.isClosed) {
          $15.sleep = true;
          $15.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $16 = null;
        $6 = state.ok ? 2 : -1;
      }
      if ($6 == 2) {
        // [1]
        $18 ??= state.input.beginBuffering();
        final $17 = state.input;
        if (state.pos >= $17.end && !$17.isClosed) {
          $17.sleep = true;
          $17.handle = $1;
          return;
        }
        $5 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $18 = null;
        $6 = -1;
      }
      if (state.ok) {
        $2 = [$3, $4!, $5!];
      } else {
        state.backtrack($7!);
      }
      $14 &= ~0x4 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  List<int>? parseOneOrMore(State<String> state) {
    List<int>? $0;
    // [0]+
    final $2 = <int>[];
    while (true) {
      int? $3;
      $3 = matchChar16(state, 48);
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.setOk($2.isNotEmpty);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  AsyncResult<List<int>> parseOneOrMore$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $4;
    Object? $6;
    void $1() {
      // [0]+
      // [0]+
      $3 ??= [];
      while (true) {
        // [0]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $6 = null;
        if (!state.ok) {
          $4 = null;
          break;
        }
        $3!.add($4!);
        $4 = null;
      }
      state.setOk($3!.isNotEmpty);
      if (state.ok) {
        $2 = $3;
      }
      $3 = null;
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  List<Object?>? parseOptional(State<String> state) {
    List<Object?>? $0;
    // [0]? [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 49);
      if (state.ok) {
        $0 = [$2, $3!];
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  AsyncResult<List<Object?>> parseOptional$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $5;
    int? $6;
    int? $3;
    Object? $8;
    int? $4;
    Object? $10;
    int $11 = 0;
    void $1() {
      // [0]? [1]
      if ($11 & 0x1 == 0) {
        $11 |= 0x1;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // [0]?
        // [0]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $8 = null;
        if (!state.ok) {
          state.setOk(true);
        }
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // [1]
        $10 ??= state.input.beginBuffering();
        final $9 = state.input;
        if (state.pos >= $9.end && !$9.isClosed) {
          $9.sleep = true;
          $9.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $10 = null;
        $5 = -1;
      }
      if (state.ok) {
        $2 = [$3, $4!];
      } else {
        state.backtrack($6!);
      }
      $11 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  int? parseOrderedChoice2(State<String> state) {
    int? $0;
    // [0]
    $0 = matchChar16(state, 48);
    if (!state.ok && state.isRecoverable) {
      // [1]
      $0 = matchChar16(state, 49);
    }
    return $0;
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  AsyncResult<int> parseOrderedChoice2$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    int $8 = 0;
    void $1() {
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        $3 = 0;
      }
      if ($3 == 0) {
        // [0]
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // [1]
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $3 = -1;
      }
      $8 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  int? parseOrderedChoice3(State<String> state) {
    int? $0;
    // [0]
    $0 = matchChar16(state, 48);
    if (!state.ok && state.isRecoverable) {
      // [1]
      $0 = matchChar16(state, 49);
      if (!state.ok && state.isRecoverable) {
        // [2]
        $0 = matchChar16(state, 50);
      }
    }
    return $0;
  }

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  AsyncResult<int> parseOrderedChoice3$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    Object? $5;
    Object? $7;
    Object? $9;
    int $10 = 0;
    void $1() {
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $3 = 0;
      }
      if ($3 == 0) {
        // [0]
        // [0]
        $5 ??= state.input.beginBuffering();
        final $4 = state.input;
        if (state.pos >= $4.end && !$4.isClosed) {
          $4.sleep = true;
          $4.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $5 = null;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // [1]
        // [1]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $7 = null;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 2
                : -1;
      }
      if ($3 == 2) {
        // [2]
        // [2]
        $9 ??= state.input.beginBuffering();
        final $8 = state.input;
        if (state.pos >= $8.end && !$8.isClosed) {
          $8.sleep = true;
          $8.handle = $1;
          return;
        }
        $2 = matchChar16Async(state, 50);
        state.input.endBuffering();
        $9 = null;
        $3 = -1;
      }
      $10 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  List<int>? parseRepetitionMax(State<String> state) {
    List<int>? $0;
    // [\u{1f680}]{,3}
    final $2 = <int>[];
    while ($2.length < 3) {
      int? $3;
      $3 = matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  AsyncResult<List<int>> parseRepetitionMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $5;
    Object? $7;
    void $1() {
      // [\u{1f680}]{,3}
      // [\u{1f680}]{,3}
      $3 ??= [];
      while (true) {
        // [\u{1f680}]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $5 = matchChar32Async(state, 128640);
        state.input.endBuffering();
        $7 = null;
        if (!state.ok) {
          $5 = null;
          break;
        }
        final $4 = $3!;
        $4.add($5!);
        $5 = null;
        if ($4.length == 3) {
          break;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $3;
      }
      $3 = null;
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  List<int>? parseRepetitionMin(State<String> state) {
    List<int>? $0;
    // [\u{1f680}]{3,}
    final $2 = state.pos;
    final $3 = <int>[];
    while (true) {
      int? $4;
      $4 = matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.setOk($3.length >= 3);
    if (state.ok) {
      $0 = $3;
    } else {
      state.backtrack($2);
    }
    return $0;
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  AsyncResult<List<int>> parseRepetitionMin$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $5;
    int? $4;
    Object? $7;
    void $1() {
      // [\u{1f680}]{3,}
      // [\u{1f680}]{3,}
      if ($3 == null) {
        $3 = [];
        $5 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $4 = matchChar32Async(state, 128640);
        state.input.endBuffering();
        $7 = null;
        if (!state.ok) {
          break;
        }
        $3!.add($4!);
        $4 = null;
      }
      state.setOk($3!.length >= 3);
      if (state.ok) {
        $2 = $3;
        $3 = null;
      } else {
        state.backtrack($5!);
      }
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  List<int>? parseRepetitionMinMax(State<String> state) {
    List<int>? $0;
    // [\u{1f680}]{2,3}
    final $2 = state.pos;
    final $3 = <int>[];
    while ($3.length < 3) {
      int? $4;
      $4 = matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.setOk($3.length >= 2);
    if (state.ok) {
      $0 = $3;
    } else {
      state.backtrack($2);
    }
    return $0;
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  AsyncResult<List<int>> parseRepetitionMinMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $6;
    int? $5;
    Object? $8;
    void $1() {
      // [\u{1f680}]{2,3}
      // [\u{1f680}]{2,3}
      if ($3 == null) {
        $3 = [];
        $6 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $5 = matchChar32Async(state, 128640);
        state.input.endBuffering();
        $8 = null;
        if (!state.ok) {
          break;
        }
        final $4 = $3!;
        $4.add($5!);
        $5 = null;
        if ($4.length == 3) {
          break;
        }
      }
      state.setOk($3!.length >= 2);
      if (state.ok) {
        $2 = $3;
        $3 = null;
      } else {
        state.backtrack($6!);
      }
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// RepetitionN =
  ///   [\u{1f680}]{3,3}
  ///   ;
  List<int>? parseRepetitionN(State<String> state) {
    List<int>? $0;
    // [\u{1f680}]{3,3}
    final $2 = state.pos;
    final $3 = <int>[];
    while ($3.length < 3) {
      int? $4;
      $4 = matchChar32(state, 128640);
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.setOk($3.length == 3);
    if (state.ok) {
      $0 = $3;
    } else {
      state.backtrack($2);
    }
    return $0;
  }

  /// RepetitionN =
  ///   [\u{1f680}]{3,3}
  ///   ;
  AsyncResult<List<int>> parseRepetitionN$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $6;
    int? $5;
    Object? $8;
    void $1() {
      // [\u{1f680}]{3,3}
      // [\u{1f680}]{3,3}
      if ($3 == null) {
        $3 = [];
        $6 = state.pos;
      }
      while (true) {
        // [\u{1f680}]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $5 = matchChar32Async(state, 128640);
        state.input.endBuffering();
        $8 = null;
        if (!state.ok) {
          $5 = null;
          break;
        }
        final $4 = $3!;
        $4.add($5!);
        $5 = null;
        if ($4.length == 3) {
          break;
        }
      }
      state.setOk($3!.length == 3);
      if (state.ok) {
        $2 = $3;
        $3 = null;
      } else {
        state.backtrack($6!);
      }
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  List<int>? parseSepBy(State<String> state) {
    List<int>? $0;
    // @sepBy([0], [,])
    final $2 = <int>[];
    var $4 = state.pos;
    while (true) {
      int? $3;
      // [0]
      $3 = matchChar16(state, 48);
      if (!state.ok) {
        state.backtrack($4);
        break;
      }
      $2.add($3!);
      $4 = state.pos;
      // [,]
      matchChar16(state, 44);
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  AsyncResult<List<int>> parseSepBy$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    int? $3;
    List<int>? $4;
    int? $6;
    Object? $8;
    Object? $10;
    int $11 = 0;
    void $1() {
      // @sepBy([0], [,])
      // @sepBy([0], [,])
      if ($11 & 0x1 == 0) {
        $11 |= 0x1;
        $4 = [];
        $6 = state.pos;
        $3 = 0;
      }
      while (true) {
        if ($3 == 0) {
          int? $5;
          // [0]
          // [0]
          $8 ??= state.input.beginBuffering();
          final $7 = state.input;
          if (state.pos >= $7.end && !$7.isClosed) {
            $7.sleep = true;
            $7.handle = $1;
            return;
          }
          $5 = matchChar16Async(state, 48);
          state.input.endBuffering();
          $8 = null;
          if (!state.ok) {
            state.backtrack($6!);
            $5 = null;
            break;
          }
          $4!.add($5!);
          $5 = null;
          $6 = state.pos;
          $3 = 1;
        }
        if ($3 == 1) {
          // [,]
          // [,]
          $10 ??= state.input.beginBuffering();
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 44);
          state.input.endBuffering();
          $10 = null;
          if (!state.ok) {
            break;
          }
          $3 = 0;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
        $4 = null;
      }
      $11 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  int? parseSequence1(State<String> state) {
    int? $0;
    // [0]
    $0 = matchChar16(state, 48);
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<int> parseSequence1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $4;
    void $1() {
      // [0]
      // [0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      $2 = matchChar16Async(state, 48);
      state.input.endBuffering();
      $4 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  int? parseSequence1WithAction(State<String> state) {
    int? $0;
    // [0] <int>{}
    matchChar16(state, 48);
    if (state.ok) {
      int? $$;
      $$ = 0x30;
      $0 = $$;
    }
    return $0;
  }

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  AsyncResult<int> parseSequence1WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $4;
    void $1() {
      // [0] <int>{}
      // [0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      matchChar16Async(state, 48);
      state.input.endBuffering();
      $4 = null;
      if (state.ok) {
        int? $$;
        $$ = 0x30;
        $2 = $$;
      }
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  int? parseSequence1WithVariable(State<String> state) {
    int? $0;
    // v:[0]
    $0 = matchChar16(state, 48);
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<int> parseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $4;
    void $1() {
      // v:[0]
      // [0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      $2 = matchChar16Async(state, 48);
      state.input.endBuffering();
      $4 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  int? parseSequence1WithVariableWithAction(State<String> state) {
    int? $0;
    // v:[0] <int>{}
    $0 = matchChar16(state, 48);
    if (state.ok) {
      int? $$;
      final v = $0!;
      $$ = v;
      $0 = $$;
    }
    return $0;
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  AsyncResult<int> parseSequence1WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    Object? $4;
    void $1() {
      // v:[0] <int>{}
      // [0]
      $4 ??= state.input.beginBuffering();
      final $3 = state.input;
      if (state.pos >= $3.end && !$3.isClosed) {
        $3.sleep = true;
        $3.handle = $1;
        return;
      }
      $2 = matchChar16Async(state, 48);
      state.input.endBuffering();
      $4 = null;
      if (state.ok) {
        int? $$;
        final v = $2!;
        $$ = v;
        $2 = $$;
      }
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  List<Object?>? parseSequence2(State<String> state) {
    List<Object?>? $0;
    // [0] [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 49);
      if (state.ok) {
        $0 = [$2!, $3!];
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  AsyncResult<List<Object?>> parseSequence2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $5;
    int? $6;
    int? $3;
    Object? $8;
    int? $4;
    Object? $10;
    int $11 = 0;
    void $1() {
      // [0] [1]
      if ($11 & 0x1 == 0) {
        $11 |= 0x1;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // [0]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $8 = null;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // [1]
        $10 ??= state.input.beginBuffering();
        final $9 = state.input;
        if (state.pos >= $9.end && !$9.isClosed) {
          $9.sleep = true;
          $9.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $10 = null;
        $5 = -1;
      }
      if (state.ok) {
        $2 = [$3!, $4!];
      } else {
        state.backtrack($6!);
      }
      $11 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  int? parseSequence2WithAction(State<String> state) {
    int? $0;
    // [0] [1] <int>{}
    final $1 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        int? $$;
        $$ = 0x30;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    int? $4;
    Object? $6;
    Object? $8;
    int $9 = 0;
    void $1() {
      // [0] [1] <int>{}
      if ($9 & 0x1 == 0) {
        $9 |= 0x1;
        $3 = 0;
        $4 = state.pos;
      }
      if ($3 == 0) {
        // [0]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        matchChar16Async(state, 48);
        state.input.endBuffering();
        $6 = null;
        $3 = state.ok ? 1 : -1;
      }
      if ($3 == 1) {
        // [1]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $8 = null;
        $3 = -1;
      }
      if (state.ok) {
        int? $$;
        $$ = 0x30;
        $2 = $$;
      } else {
        state.backtrack($4!);
      }
      $9 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  int? parseSequence2WithVariable(State<String> state) {
    int? $0;
    // v:[0] [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  AsyncResult<int> parseSequence2WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $4;
    int? $5;
    int? $3;
    Object? $7;
    Object? $9;
    int $10 = 0;
    void $1() {
      // v:[0] [1]
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // [0]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $7 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // [1]
        $9 ??= state.input.beginBuffering();
        final $8 = state.input;
        if (state.pos >= $8.end && !$8.isClosed) {
          $8.sleep = true;
          $8.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $9 = null;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
      }
      $10 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  int? parseSequence2WithVariableWithAction(State<String> state) {
    int? $0;
    // v:[0] [1] <int>{}
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        int? $$;
        final v = $2!;
        $$ = v;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $4;
    int? $5;
    int? $3;
    Object? $7;
    Object? $9;
    int $10 = 0;
    void $1() {
      // v:[0] [1] <int>{}
      if ($10 & 0x1 == 0) {
        $10 |= 0x1;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // [0]
        $7 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $7 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // [1]
        $9 ??= state.input.beginBuffering();
        final $8 = state.input;
        if (state.pos >= $8.end && !$8.isClosed) {
          $8.sleep = true;
          $8.handle = $1;
          return;
        }
        matchChar16Async(state, 49);
        state.input.endBuffering();
        $9 = null;
        $4 = -1;
      }
      if (state.ok) {
        int? $$;
        final v = $3!;
        $$ = v;
        $2 = $$;
      } else {
        state.backtrack($5!);
      }
      $10 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  ({int v1, int v2})? parseSequence2WithVariables(State<String> state) {
    ({int v1, int v2})? $0;
    // v1:[0] v2:[1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 49);
      if (state.ok) {
        $0 = (v1: $2!, v2: $3!);
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  AsyncResult<({int v1, int v2})> parseSequence2WithVariables$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<({int v1, int v2})>();
    ({int v1, int v2})? $2;
    int? $5;
    int? $6;
    int? $3;
    Object? $8;
    int? $4;
    Object? $10;
    int $11 = 0;
    void $1() {
      // v1:[0] v2:[1]
      if ($11 & 0x1 == 0) {
        $11 |= 0x1;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // [0]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $8 = null;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // [1]
        $10 ??= state.input.beginBuffering();
        final $9 = state.input;
        if (state.pos >= $9.end && !$9.isClosed) {
          $9.sleep = true;
          $9.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $10 = null;
        $5 = -1;
      }
      if (state.ok) {
        $2 = (v1: $3!, v2: $4!);
      } else {
        state.backtrack($6!);
      }
      $11 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  int? parseSequence2WithVariablesWithAction(State<String> state) {
    int? $0;
    // v1:[0] v2:[1] <int>{}
    final $1 = state.pos;
    int? $2;
    $2 = matchChar16(state, 48);
    if (state.ok) {
      int? $3;
      $3 = matchChar16(state, 49);
      if (state.ok) {
        int? $$;
        final v1 = $2!;
        final v2 = $3!;
        $$ = v1 + v2;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithVariablesWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $5;
    int? $6;
    int? $3;
    Object? $8;
    int? $4;
    Object? $10;
    int $11 = 0;
    void $1() {
      // v1:[0] v2:[1] <int>{}
      if ($11 & 0x1 == 0) {
        $11 |= 0x1;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // [0]
        $8 ??= state.input.beginBuffering();
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        $3 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $8 = null;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // [1]
        $10 ??= state.input.beginBuffering();
        final $9 = state.input;
        if (state.pos >= $9.end && !$9.isClosed) {
          $9.sleep = true;
          $9.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 49);
        state.input.endBuffering();
        $10 = null;
        $5 = -1;
      }
      if (state.ok) {
        int? $$;
        final v1 = $3!;
        final v2 = $4!;
        $$ = v1 + v2;
        $2 = $$;
      } else {
        state.backtrack($6!);
      }
      $11 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  String? parseSlice(State<String> state) {
    String? $0;
    // $([0] [1] [2])
    final $2 = state.pos;
    // [0] [1] [2]
    final $3 = state.pos;
    matchChar16(state, 48);
    if (state.ok) {
      matchChar16(state, 49);
      if (state.ok) {
        matchChar16(state, 50);
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    if (!state.ok && state.isRecoverable) {
      // $([0] [1])
      final $5 = state.pos;
      // [0] [1]
      final $6 = state.pos;
      matchChar16(state, 48);
      if (state.ok) {
        matchChar16(state, 49);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (state.ok) {
        $0 = state.input.substring($5, state.pos);
      }
    }
    return $0;
  }

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  AsyncResult<String> parseSlice$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    int? $3;
    int? $4;
    int? $5;
    int? $6;
    int $10 = 0;
    int? $11;
    int? $12;
    int? $13;
    void $1() {
      if ($10 & 0x10 == 0) {
        $10 |= 0x10;
        $3 = 0;
      }
      if ($3 == 0) {
        // $([0] [1] [2])
        // $([0] [1] [2])
        if ($10 & 0x2 == 0) {
          $10 |= 0x2;
          state.input.beginBuffering();
          $4 = state.pos;
        }
        // ([0] [1] [2])
        // [0] [1] [2]
        // [0] [1] [2]
        if ($10 & 0x1 == 0) {
          $10 |= 0x1;
          $5 = 0;
          $6 = state.pos;
        }
        if ($5 == 0) {
          // [0]
          final $7 = state.input;
          if (state.pos >= $7.end && !$7.isClosed) {
            $7.sleep = true;
            $7.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $5 = state.ok ? 1 : -1;
        }
        if ($5 == 1) {
          // [1]
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $5 = state.ok ? 2 : -1;
        }
        if ($5 == 2) {
          // [2]
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 50);
          $5 = -1;
        }
        if (!state.ok) {
          state.backtrack($6!);
        }
        $10 &= ~0x1 & 0xffff;
        if (state.ok) {
          final input = state.input;
          final start = input.start;
          final pos = $4!;
          $2 = input.data.substring(pos - start, state.pos - start);
        }
        state.input.endBuffering();
        $10 &= ~0x2 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // $([0] [1])
        // $([0] [1])
        if ($10 & 0x8 == 0) {
          $10 |= 0x8;
          state.input.beginBuffering();
          $11 = state.pos;
        }
        // ([0] [1])
        // [0] [1]
        // [0] [1]
        if ($10 & 0x4 == 0) {
          $10 |= 0x4;
          $12 = 0;
          $13 = state.pos;
        }
        if ($12 == 0) {
          // [0]
          final $14 = state.input;
          if (state.pos >= $14.end && !$14.isClosed) {
            $14.sleep = true;
            $14.handle = $1;
            return;
          }
          matchChar16Async(state, 48);
          $12 = state.ok ? 1 : -1;
        }
        if ($12 == 1) {
          // [1]
          final $15 = state.input;
          if (state.pos >= $15.end && !$15.isClosed) {
            $15.sleep = true;
            $15.handle = $1;
            return;
          }
          matchChar16Async(state, 49);
          $12 = -1;
        }
        if (!state.ok) {
          state.backtrack($13!);
        }
        $10 &= ~0x4 & 0xffff;
        if (state.ok) {
          final input = state.input;
          final start = input.start;
          final pos = $11!;
          $2 = input.data.substring(pos - start, state.pos - start);
        }
        state.input.endBuffering();
        $10 &= ~0x8 & 0xffff;
        $3 = -1;
      }
      $10 &= ~0x10 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Start =
  ///     (v:AndPredicate AndPredicate)
  ///   / (v:AnyCharacter AnyCharacter)
  ///   / (v:CharacterClass CharacterClass)
  ///   / (v:CharacterClassChar32 CharacterClassChar32)
  ///   / (v:CharacterClassCharNegate CharacterClassCharNegate)
  ///   / (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
  ///   / (v:CharacterClassRange32 CharacterClassRange32)
  ///   / (v:Cut Cut)
  ///   / (v:ErrorHandler ErrorHandler)
  ///   / (v:Eof Eof)
  ///   / (v:Expected Expected)
  ///   / (v:Literal0 Literal0)
  ///   / (v:Literal1 Literal1)
  ///   / (v:Literal2 Literal2)
  ///   / (v:Literals Literals)
  ///   / (v:MatchString MatchString)
  ///   / (v:NotPredicate NotPredicate)
  ///   / (v:OneOrMore OneOrMore)
  ///   / (v:OrderedChoice2 OrderedChoice2)
  ///   / (v:OrderedChoice3 OrderedChoice3)
  ///   / (v:Optional Optional)
  ///   / (v:RepetitionMax RepetitionMax)
  ///   / (v:RepetitionMin RepetitionMin)
  ///   / (v:RepetitionMinMax RepetitionMinMax)
  ///   / (v:RepetitionN RepetitionN)
  ///   / (v:SepBy SepBy)
  ///   / (v:Sequence1 Sequence1)
  ///   / (v:Sequence1WithAction Sequence1WithAction)
  ///   / (v:Sequence1WithVariable Sequence1WithVariable)
  ///   / (v:Sequence1WithVariable Sequence1WithVariable)
  ///   / (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
  ///   / (v:Sequence2 Sequence2)
  ///   / (v:Sequence2WithAction Sequence2WithAction)
  ///   / (v:Sequence2WithVariable Sequence2WithVariable)
  ///   / (v:Sequence2WithVariables Sequence2WithVariables)
  ///   / (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
  ///   / (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
  ///   / (v:Slice Slice)
  ///   / (v:StringChars StringChars)
  ///   / (v:Verify Verify)
  ///   / (v:ZeroOrMore ZeroOrMore)
  ///   ;
  Object? parseStart(State<String> state) {
    Object? $0;
    // (v:AndPredicate AndPredicate)
    // v:AndPredicate AndPredicate
    final $2 = state.pos;
    List<Object?>? $3;
    // AndPredicate
    $3 = parseAndPredicate(state);
    if (state.ok) {
      // AndPredicate
      fastParseAndPredicate(state);
      if (state.ok) {
        $0 = $3;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (!state.ok && state.isRecoverable) {
      // (v:AnyCharacter AnyCharacter)
      // v:AnyCharacter AnyCharacter
      final $5 = state.pos;
      int? $6;
      // AnyCharacter
      $6 = parseAnyCharacter(state);
      if (state.ok) {
        // AnyCharacter
        fastParseAnyCharacter(state);
        if (state.ok) {
          $0 = $6;
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
      if (!state.ok && state.isRecoverable) {
        // (v:CharacterClass CharacterClass)
        // v:CharacterClass CharacterClass
        final $8 = state.pos;
        int? $9;
        // CharacterClass
        $9 = parseCharacterClass(state);
        if (state.ok) {
          // CharacterClass
          fastParseCharacterClass(state);
          if (state.ok) {
            $0 = $9;
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok && state.isRecoverable) {
          // (v:CharacterClassChar32 CharacterClassChar32)
          // v:CharacterClassChar32 CharacterClassChar32
          final $11 = state.pos;
          int? $12;
          // CharacterClassChar32
          $12 = parseCharacterClassChar32(state);
          if (state.ok) {
            // CharacterClassChar32
            fastParseCharacterClassChar32(state);
            if (state.ok) {
              $0 = $12;
            }
          }
          if (!state.ok) {
            state.backtrack($11);
          }
          if (!state.ok && state.isRecoverable) {
            // (v:CharacterClassCharNegate CharacterClassCharNegate)
            // v:CharacterClassCharNegate CharacterClassCharNegate
            final $14 = state.pos;
            int? $15;
            // CharacterClassCharNegate
            $15 = parseCharacterClassCharNegate(state);
            if (state.ok) {
              // CharacterClassCharNegate
              fastParseCharacterClassCharNegate(state);
              if (state.ok) {
                $0 = $15;
              }
            }
            if (!state.ok) {
              state.backtrack($14);
            }
            if (!state.ok && state.isRecoverable) {
              // (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
              // v:CharacterClassCharNegate32 CharacterClassCharNegate32
              final $17 = state.pos;
              int? $18;
              // CharacterClassCharNegate32
              $18 = parseCharacterClassCharNegate32(state);
              if (state.ok) {
                // CharacterClassCharNegate32
                fastParseCharacterClassCharNegate32(state);
                if (state.ok) {
                  $0 = $18;
                }
              }
              if (!state.ok) {
                state.backtrack($17);
              }
              if (!state.ok && state.isRecoverable) {
                // (v:CharacterClassRange32 CharacterClassRange32)
                // v:CharacterClassRange32 CharacterClassRange32
                final $20 = state.pos;
                int? $21;
                // CharacterClassRange32
                $21 = parseCharacterClassRange32(state);
                if (state.ok) {
                  // CharacterClassRange32
                  fastParseCharacterClassRange32(state);
                  if (state.ok) {
                    $0 = $21;
                  }
                }
                if (!state.ok) {
                  state.backtrack($20);
                }
                if (!state.ok && state.isRecoverable) {
                  // (v:Cut Cut)
                  // v:Cut Cut
                  final $23 = state.pos;
                  Object? $24;
                  // Cut
                  $24 = parseCut(state);
                  if (state.ok) {
                    // Cut
                    fastParseCut(state);
                    if (state.ok) {
                      $0 = $24;
                    }
                  }
                  if (!state.ok) {
                    state.backtrack($23);
                  }
                  if (!state.ok && state.isRecoverable) {
                    // (v:ErrorHandler ErrorHandler)
                    // v:ErrorHandler ErrorHandler
                    final $26 = state.pos;
                    int? $27;
                    // ErrorHandler
                    $27 = parseErrorHandler(state);
                    if (state.ok) {
                      // ErrorHandler
                      fastParseErrorHandler(state);
                      if (state.ok) {
                        $0 = $27;
                      }
                    }
                    if (!state.ok) {
                      state.backtrack($26);
                    }
                    if (!state.ok && state.isRecoverable) {
                      // (v:Eof Eof)
                      // v:Eof Eof
                      final $29 = state.pos;
                      List<Object?>? $30;
                      // Eof
                      $30 = parseEof(state);
                      if (state.ok) {
                        // Eof
                        fastParseEof(state);
                        if (state.ok) {
                          $0 = $30;
                        }
                      }
                      if (!state.ok) {
                        state.backtrack($29);
                      }
                      if (!state.ok && state.isRecoverable) {
                        // (v:Expected Expected)
                        // v:Expected Expected
                        final $32 = state.pos;
                        List<int>? $33;
                        // Expected
                        $33 = parseExpected(state);
                        if (state.ok) {
                          // Expected
                          fastParseExpected(state);
                          if (state.ok) {
                            $0 = $33;
                          }
                        }
                        if (!state.ok) {
                          state.backtrack($32);
                        }
                        if (!state.ok && state.isRecoverable) {
                          // (v:Literal0 Literal0)
                          // v:Literal0 Literal0
                          final $35 = state.pos;
                          String? $36;
                          // Literal0
                          $36 = parseLiteral0(state);
                          if (state.ok) {
                            // Literal0
                            fastParseLiteral0(state);
                            if (state.ok) {
                              $0 = $36;
                            }
                          }
                          if (!state.ok) {
                            state.backtrack($35);
                          }
                          if (!state.ok && state.isRecoverable) {
                            // (v:Literal1 Literal1)
                            // v:Literal1 Literal1
                            final $38 = state.pos;
                            String? $39;
                            // Literal1
                            $39 = parseLiteral1(state);
                            if (state.ok) {
                              // Literal1
                              fastParseLiteral1(state);
                              if (state.ok) {
                                $0 = $39;
                              }
                            }
                            if (!state.ok) {
                              state.backtrack($38);
                            }
                            if (!state.ok && state.isRecoverable) {
                              // (v:Literal2 Literal2)
                              // v:Literal2 Literal2
                              final $41 = state.pos;
                              String? $42;
                              // Literal2
                              $42 = parseLiteral2(state);
                              if (state.ok) {
                                // Literal2
                                fastParseLiteral2(state);
                                if (state.ok) {
                                  $0 = $42;
                                }
                              }
                              if (!state.ok) {
                                state.backtrack($41);
                              }
                              if (!state.ok && state.isRecoverable) {
                                // (v:Literals Literals)
                                // v:Literals Literals
                                final $44 = state.pos;
                                String? $45;
                                // Literals
                                $45 = parseLiterals(state);
                                if (state.ok) {
                                  // Literals
                                  fastParseLiterals(state);
                                  if (state.ok) {
                                    $0 = $45;
                                  }
                                }
                                if (!state.ok) {
                                  state.backtrack($44);
                                }
                                if (!state.ok && state.isRecoverable) {
                                  // (v:MatchString MatchString)
                                  // v:MatchString MatchString
                                  final $47 = state.pos;
                                  String? $48;
                                  // MatchString
                                  $48 = parseMatchString(state);
                                  if (state.ok) {
                                    // MatchString
                                    fastParseMatchString(state);
                                    if (state.ok) {
                                      $0 = $48;
                                    }
                                  }
                                  if (!state.ok) {
                                    state.backtrack($47);
                                  }
                                  if (!state.ok && state.isRecoverable) {
                                    // (v:NotPredicate NotPredicate)
                                    // v:NotPredicate NotPredicate
                                    final $50 = state.pos;
                                    List<Object?>? $51;
                                    // NotPredicate
                                    $51 = parseNotPredicate(state);
                                    if (state.ok) {
                                      // NotPredicate
                                      fastParseNotPredicate(state);
                                      if (state.ok) {
                                        $0 = $51;
                                      }
                                    }
                                    if (!state.ok) {
                                      state.backtrack($50);
                                    }
                                    if (!state.ok && state.isRecoverable) {
                                      // (v:OneOrMore OneOrMore)
                                      // v:OneOrMore OneOrMore
                                      final $53 = state.pos;
                                      List<int>? $54;
                                      // OneOrMore
                                      $54 = parseOneOrMore(state);
                                      if (state.ok) {
                                        // OneOrMore
                                        fastParseOneOrMore(state);
                                        if (state.ok) {
                                          $0 = $54;
                                        }
                                      }
                                      if (!state.ok) {
                                        state.backtrack($53);
                                      }
                                      if (!state.ok && state.isRecoverable) {
                                        // (v:OrderedChoice2 OrderedChoice2)
                                        // v:OrderedChoice2 OrderedChoice2
                                        final $56 = state.pos;
                                        int? $57;
                                        // OrderedChoice2
                                        $57 = parseOrderedChoice2(state);
                                        if (state.ok) {
                                          // OrderedChoice2
                                          fastParseOrderedChoice2(state);
                                          if (state.ok) {
                                            $0 = $57;
                                          }
                                        }
                                        if (!state.ok) {
                                          state.backtrack($56);
                                        }
                                        if (!state.ok && state.isRecoverable) {
                                          // (v:OrderedChoice3 OrderedChoice3)
                                          // v:OrderedChoice3 OrderedChoice3
                                          final $59 = state.pos;
                                          int? $60;
                                          // OrderedChoice3
                                          $60 = parseOrderedChoice3(state);
                                          if (state.ok) {
                                            // OrderedChoice3
                                            fastParseOrderedChoice3(state);
                                            if (state.ok) {
                                              $0 = $60;
                                            }
                                          }
                                          if (!state.ok) {
                                            state.backtrack($59);
                                          }
                                          if (!state.ok &&
                                              state.isRecoverable) {
                                            // (v:Optional Optional)
                                            // v:Optional Optional
                                            final $62 = state.pos;
                                            List<Object?>? $63;
                                            // Optional
                                            $63 = parseOptional(state);
                                            if (state.ok) {
                                              // Optional
                                              fastParseOptional(state);
                                              if (state.ok) {
                                                $0 = $63;
                                              }
                                            }
                                            if (!state.ok) {
                                              state.backtrack($62);
                                            }
                                            if (!state.ok &&
                                                state.isRecoverable) {
                                              // (v:RepetitionMax RepetitionMax)
                                              // v:RepetitionMax RepetitionMax
                                              final $65 = state.pos;
                                              List<int>? $66;
                                              // RepetitionMax
                                              $66 = parseRepetitionMax(state);
                                              if (state.ok) {
                                                // RepetitionMax
                                                fastParseRepetitionMax(state);
                                                if (state.ok) {
                                                  $0 = $66;
                                                }
                                              }
                                              if (!state.ok) {
                                                state.backtrack($65);
                                              }
                                              if (!state.ok &&
                                                  state.isRecoverable) {
                                                // (v:RepetitionMin RepetitionMin)
                                                // v:RepetitionMin RepetitionMin
                                                final $68 = state.pos;
                                                List<int>? $69;
                                                // RepetitionMin
                                                $69 = parseRepetitionMin(state);
                                                if (state.ok) {
                                                  // RepetitionMin
                                                  fastParseRepetitionMin(state);
                                                  if (state.ok) {
                                                    $0 = $69;
                                                  }
                                                }
                                                if (!state.ok) {
                                                  state.backtrack($68);
                                                }
                                                if (!state.ok &&
                                                    state.isRecoverable) {
                                                  // (v:RepetitionMinMax RepetitionMinMax)
                                                  // v:RepetitionMinMax RepetitionMinMax
                                                  final $71 = state.pos;
                                                  List<int>? $72;
                                                  // RepetitionMinMax
                                                  $72 = parseRepetitionMinMax(
                                                      state);
                                                  if (state.ok) {
                                                    // RepetitionMinMax
                                                    fastParseRepetitionMinMax(
                                                        state);
                                                    if (state.ok) {
                                                      $0 = $72;
                                                    }
                                                  }
                                                  if (!state.ok) {
                                                    state.backtrack($71);
                                                  }
                                                  if (!state.ok &&
                                                      state.isRecoverable) {
                                                    // (v:RepetitionN RepetitionN)
                                                    // v:RepetitionN RepetitionN
                                                    final $74 = state.pos;
                                                    List<int>? $75;
                                                    // RepetitionN
                                                    $75 =
                                                        parseRepetitionN(state);
                                                    if (state.ok) {
                                                      // RepetitionN
                                                      fastParseRepetitionN(
                                                          state);
                                                      if (state.ok) {
                                                        $0 = $75;
                                                      }
                                                    }
                                                    if (!state.ok) {
                                                      state.backtrack($74);
                                                    }
                                                    if (!state.ok &&
                                                        state.isRecoverable) {
                                                      // (v:SepBy SepBy)
                                                      // v:SepBy SepBy
                                                      final $77 = state.pos;
                                                      List<int>? $78;
                                                      // SepBy
                                                      $78 = parseSepBy(state);
                                                      if (state.ok) {
                                                        // SepBy
                                                        fastParseSepBy(state);
                                                        if (state.ok) {
                                                          $0 = $78;
                                                        }
                                                      }
                                                      if (!state.ok) {
                                                        state.backtrack($77);
                                                      }
                                                      if (!state.ok &&
                                                          state.isRecoverable) {
                                                        // (v:Sequence1 Sequence1)
                                                        // v:Sequence1 Sequence1
                                                        final $80 = state.pos;
                                                        int? $81;
                                                        // Sequence1
                                                        $81 = parseSequence1(
                                                            state);
                                                        if (state.ok) {
                                                          // Sequence1
                                                          fastParseSequence1(
                                                              state);
                                                          if (state.ok) {
                                                            $0 = $81;
                                                          }
                                                        }
                                                        if (!state.ok) {
                                                          state.backtrack($80);
                                                        }
                                                        if (!state.ok &&
                                                            state
                                                                .isRecoverable) {
                                                          // (v:Sequence1WithAction Sequence1WithAction)
                                                          // v:Sequence1WithAction Sequence1WithAction
                                                          final $83 = state.pos;
                                                          int? $84;
                                                          // Sequence1WithAction
                                                          $84 =
                                                              parseSequence1WithAction(
                                                                  state);
                                                          if (state.ok) {
                                                            // Sequence1WithAction
                                                            fastParseSequence1WithAction(
                                                                state);
                                                            if (state.ok) {
                                                              $0 = $84;
                                                            }
                                                          }
                                                          if (!state.ok) {
                                                            state
                                                                .backtrack($83);
                                                          }
                                                          if (!state.ok &&
                                                              state
                                                                  .isRecoverable) {
                                                            // (v:Sequence1WithVariable Sequence1WithVariable)
                                                            // v:Sequence1WithVariable Sequence1WithVariable
                                                            final $86 =
                                                                state.pos;
                                                            int? $87;
                                                            // Sequence1WithVariable
                                                            $87 =
                                                                parseSequence1WithVariable(
                                                                    state);
                                                            if (state.ok) {
                                                              // Sequence1WithVariable
                                                              fastParseSequence1WithVariable(
                                                                  state);
                                                              if (state.ok) {
                                                                $0 = $87;
                                                              }
                                                            }
                                                            if (!state.ok) {
                                                              state.backtrack(
                                                                  $86);
                                                            }
                                                            if (!state.ok &&
                                                                state
                                                                    .isRecoverable) {
                                                              // (v:Sequence1WithVariable Sequence1WithVariable)
                                                              // v:Sequence1WithVariable Sequence1WithVariable
                                                              final $89 =
                                                                  state.pos;
                                                              int? $90;
                                                              // Sequence1WithVariable
                                                              $90 =
                                                                  parseSequence1WithVariable(
                                                                      state);
                                                              if (state.ok) {
                                                                // Sequence1WithVariable
                                                                fastParseSequence1WithVariable(
                                                                    state);
                                                                if (state.ok) {
                                                                  $0 = $90;
                                                                }
                                                              }
                                                              if (!state.ok) {
                                                                state.backtrack(
                                                                    $89);
                                                              }
                                                              if (!state.ok &&
                                                                  state
                                                                      .isRecoverable) {
                                                                // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
                                                                // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
                                                                final $92 =
                                                                    state.pos;
                                                                int? $93;
                                                                // Sequence1WithVariableWithAction
                                                                $93 =
                                                                    parseSequence1WithVariableWithAction(
                                                                        state);
                                                                if (state.ok) {
                                                                  // Sequence1WithVariableWithAction
                                                                  fastParseSequence1WithVariableWithAction(
                                                                      state);
                                                                  if (state
                                                                      .ok) {
                                                                    $0 = $93;
                                                                  }
                                                                }
                                                                if (!state.ok) {
                                                                  state
                                                                      .backtrack(
                                                                          $92);
                                                                }
                                                                if (!state.ok &&
                                                                    state
                                                                        .isRecoverable) {
                                                                  // (v:Sequence2 Sequence2)
                                                                  // v:Sequence2 Sequence2
                                                                  final $95 =
                                                                      state.pos;
                                                                  List<Object?>?
                                                                      $96;
                                                                  // Sequence2
                                                                  $96 =
                                                                      parseSequence2(
                                                                          state);
                                                                  if (state
                                                                      .ok) {
                                                                    // Sequence2
                                                                    fastParseSequence2(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      $0 = $96;
                                                                    }
                                                                  }
                                                                  if (!state
                                                                      .ok) {
                                                                    state.backtrack(
                                                                        $95);
                                                                  }
                                                                  if (!state
                                                                          .ok &&
                                                                      state
                                                                          .isRecoverable) {
                                                                    // (v:Sequence2WithAction Sequence2WithAction)
                                                                    // v:Sequence2WithAction Sequence2WithAction
                                                                    final $98 =
                                                                        state
                                                                            .pos;
                                                                    int? $99;
                                                                    // Sequence2WithAction
                                                                    $99 = parseSequence2WithAction(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      // Sequence2WithAction
                                                                      fastParseSequence2WithAction(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        $0 =
                                                                            $99;
                                                                      }
                                                                    }
                                                                    if (!state
                                                                        .ok) {
                                                                      state.backtrack(
                                                                          $98);
                                                                    }
                                                                    if (!state
                                                                            .ok &&
                                                                        state
                                                                            .isRecoverable) {
                                                                      // (v:Sequence2WithVariable Sequence2WithVariable)
                                                                      // v:Sequence2WithVariable Sequence2WithVariable
                                                                      final $101 =
                                                                          state
                                                                              .pos;
                                                                      int? $102;
                                                                      // Sequence2WithVariable
                                                                      $102 = parseSequence2WithVariable(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        // Sequence2WithVariable
                                                                        fastParseSequence2WithVariable(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          $0 =
                                                                              $102;
                                                                        }
                                                                      }
                                                                      if (!state
                                                                          .ok) {
                                                                        state.backtrack(
                                                                            $101);
                                                                      }
                                                                      if (!state
                                                                              .ok &&
                                                                          state
                                                                              .isRecoverable) {
                                                                        // (v:Sequence2WithVariables Sequence2WithVariables)
                                                                        // v:Sequence2WithVariables Sequence2WithVariables
                                                                        final $104 =
                                                                            state.pos;
                                                                        ({
                                                                          int v1,
                                                                          int v2
                                                                        })? $105;
                                                                        // Sequence2WithVariables
                                                                        $105 = parseSequence2WithVariables(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          // Sequence2WithVariables
                                                                          fastParseSequence2WithVariables(
                                                                              state);
                                                                          if (state
                                                                              .ok) {
                                                                            $0 =
                                                                                $105;
                                                                          }
                                                                        }
                                                                        if (!state
                                                                            .ok) {
                                                                          state.backtrack(
                                                                              $104);
                                                                        }
                                                                        if (!state.ok &&
                                                                            state.isRecoverable) {
                                                                          // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
                                                                          // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
                                                                          final $107 =
                                                                              state.pos;
                                                                          int?
                                                                              $108;
                                                                          // Sequence2WithVariableWithAction
                                                                          $108 =
                                                                              parseSequence2WithVariableWithAction(state);
                                                                          if (state
                                                                              .ok) {
                                                                            // Sequence2WithVariableWithAction
                                                                            fastParseSequence2WithVariableWithAction(state);
                                                                            if (state.ok) {
                                                                              $0 = $108;
                                                                            }
                                                                          }
                                                                          if (!state
                                                                              .ok) {
                                                                            state.backtrack($107);
                                                                          }
                                                                          if (!state.ok &&
                                                                              state.isRecoverable) {
                                                                            // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
                                                                            // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
                                                                            final $110 =
                                                                                state.pos;
                                                                            int?
                                                                                $111;
                                                                            // Sequence2WithVariablesWithAction
                                                                            $111 =
                                                                                parseSequence2WithVariablesWithAction(state);
                                                                            if (state.ok) {
                                                                              // Sequence2WithVariablesWithAction
                                                                              fastParseSequence2WithVariablesWithAction(state);
                                                                              if (state.ok) {
                                                                                $0 = $111;
                                                                              }
                                                                            }
                                                                            if (!state.ok) {
                                                                              state.backtrack($110);
                                                                            }
                                                                            if (!state.ok &&
                                                                                state.isRecoverable) {
                                                                              // (v:Slice Slice)
                                                                              // v:Slice Slice
                                                                              final $113 = state.pos;
                                                                              String? $114;
                                                                              // Slice
                                                                              $114 = parseSlice(state);
                                                                              if (state.ok) {
                                                                                // Slice
                                                                                fastParseSlice(state);
                                                                                if (state.ok) {
                                                                                  $0 = $114;
                                                                                }
                                                                              }
                                                                              if (!state.ok) {
                                                                                state.backtrack($113);
                                                                              }
                                                                              if (!state.ok && state.isRecoverable) {
                                                                                // (v:StringChars StringChars)
                                                                                // v:StringChars StringChars
                                                                                final $116 = state.pos;
                                                                                String? $117;
                                                                                // StringChars
                                                                                $117 = parseStringChars(state);
                                                                                if (state.ok) {
                                                                                  // StringChars
                                                                                  fastParseStringChars(state);
                                                                                  if (state.ok) {
                                                                                    $0 = $117;
                                                                                  }
                                                                                }
                                                                                if (!state.ok) {
                                                                                  state.backtrack($116);
                                                                                }
                                                                                if (!state.ok && state.isRecoverable) {
                                                                                  // (v:Verify Verify)
                                                                                  // v:Verify Verify
                                                                                  final $119 = state.pos;
                                                                                  int? $120;
                                                                                  // Verify
                                                                                  $120 = parseVerify(state);
                                                                                  if (state.ok) {
                                                                                    // Verify
                                                                                    fastParseVerify(state);
                                                                                    if (state.ok) {
                                                                                      $0 = $120;
                                                                                    }
                                                                                  }
                                                                                  if (!state.ok) {
                                                                                    state.backtrack($119);
                                                                                  }
                                                                                  if (!state.ok && state.isRecoverable) {
                                                                                    // (v:ZeroOrMore ZeroOrMore)
                                                                                    // v:ZeroOrMore ZeroOrMore
                                                                                    final $122 = state.pos;
                                                                                    List<int>? $123;
                                                                                    // ZeroOrMore
                                                                                    $123 = parseZeroOrMore(state);
                                                                                    if (state.ok) {
                                                                                      // ZeroOrMore
                                                                                      fastParseZeroOrMore(state);
                                                                                      if (state.ok) {
                                                                                        $0 = $123;
                                                                                      }
                                                                                    }
                                                                                    if (!state.ok) {
                                                                                      state.backtrack($122);
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

  /// Start =
  ///     (v:AndPredicate AndPredicate)
  ///   / (v:AnyCharacter AnyCharacter)
  ///   / (v:CharacterClass CharacterClass)
  ///   / (v:CharacterClassChar32 CharacterClassChar32)
  ///   / (v:CharacterClassCharNegate CharacterClassCharNegate)
  ///   / (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
  ///   / (v:CharacterClassRange32 CharacterClassRange32)
  ///   / (v:Cut Cut)
  ///   / (v:ErrorHandler ErrorHandler)
  ///   / (v:Eof Eof)
  ///   / (v:Expected Expected)
  ///   / (v:Literal0 Literal0)
  ///   / (v:Literal1 Literal1)
  ///   / (v:Literal2 Literal2)
  ///   / (v:Literals Literals)
  ///   / (v:MatchString MatchString)
  ///   / (v:NotPredicate NotPredicate)
  ///   / (v:OneOrMore OneOrMore)
  ///   / (v:OrderedChoice2 OrderedChoice2)
  ///   / (v:OrderedChoice3 OrderedChoice3)
  ///   / (v:Optional Optional)
  ///   / (v:RepetitionMax RepetitionMax)
  ///   / (v:RepetitionMin RepetitionMin)
  ///   / (v:RepetitionMinMax RepetitionMinMax)
  ///   / (v:RepetitionN RepetitionN)
  ///   / (v:SepBy SepBy)
  ///   / (v:Sequence1 Sequence1)
  ///   / (v:Sequence1WithAction Sequence1WithAction)
  ///   / (v:Sequence1WithVariable Sequence1WithVariable)
  ///   / (v:Sequence1WithVariable Sequence1WithVariable)
  ///   / (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
  ///   / (v:Sequence2 Sequence2)
  ///   / (v:Sequence2WithAction Sequence2WithAction)
  ///   / (v:Sequence2WithVariable Sequence2WithVariable)
  ///   / (v:Sequence2WithVariables Sequence2WithVariables)
  ///   / (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
  ///   / (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
  ///   / (v:Slice Slice)
  ///   / (v:StringChars StringChars)
  ///   / (v:Verify Verify)
  ///   / (v:ZeroOrMore ZeroOrMore)
  ///   ;
  AsyncResult<Object?> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    int? $3;
    int? $5;
    int? $6;
    List<Object?>? $4;
    AsyncResult<List<Object?>>? $7;
    int $9 = 0;
    AsyncResult<Object?>? $10;
    int? $13;
    int? $14;
    int? $12;
    AsyncResult<int>? $15;
    AsyncResult<Object?>? $17;
    int? $20;
    int? $21;
    int? $19;
    AsyncResult<int>? $22;
    AsyncResult<Object?>? $24;
    int? $27;
    int? $28;
    int? $26;
    AsyncResult<int>? $29;
    AsyncResult<Object?>? $31;
    int? $34;
    int? $35;
    int? $33;
    AsyncResult<int>? $36;
    AsyncResult<Object?>? $38;
    int? $41;
    int? $42;
    int? $40;
    AsyncResult<int>? $43;
    AsyncResult<Object?>? $45;
    int $47 = 0;
    int? $49;
    int? $50;
    int? $48;
    AsyncResult<int>? $51;
    AsyncResult<Object?>? $53;
    int? $56;
    int? $57;
    Object? $55;
    AsyncResult<Object?>? $58;
    AsyncResult<Object?>? $60;
    int? $63;
    int? $64;
    int? $62;
    AsyncResult<int>? $65;
    AsyncResult<Object?>? $67;
    int? $70;
    int? $71;
    List<Object?>? $69;
    AsyncResult<List<Object?>>? $72;
    AsyncResult<Object?>? $74;
    int? $77;
    int? $78;
    List<int>? $76;
    AsyncResult<List<int>>? $79;
    AsyncResult<Object?>? $81;
    int $83 = 0;
    int? $85;
    int? $86;
    String? $84;
    AsyncResult<String>? $87;
    AsyncResult<Object?>? $89;
    int? $92;
    int? $93;
    String? $91;
    AsyncResult<String>? $94;
    AsyncResult<Object?>? $96;
    int? $99;
    int? $100;
    String? $98;
    AsyncResult<String>? $101;
    AsyncResult<Object?>? $103;
    int? $106;
    int? $107;
    String? $105;
    AsyncResult<String>? $108;
    AsyncResult<Object?>? $110;
    int? $113;
    int? $114;
    String? $112;
    AsyncResult<String>? $115;
    AsyncResult<Object?>? $117;
    int? $120;
    int? $121;
    List<Object?>? $119;
    AsyncResult<List<Object?>>? $122;
    int $124 = 0;
    AsyncResult<Object?>? $125;
    int? $128;
    int? $129;
    List<int>? $127;
    AsyncResult<List<int>>? $130;
    AsyncResult<Object?>? $132;
    int? $135;
    int? $136;
    int? $134;
    AsyncResult<int>? $137;
    AsyncResult<Object?>? $139;
    int? $142;
    int? $143;
    int? $141;
    AsyncResult<int>? $144;
    AsyncResult<Object?>? $146;
    int? $149;
    int? $150;
    List<Object?>? $148;
    AsyncResult<List<Object?>>? $151;
    AsyncResult<Object?>? $153;
    int? $156;
    int? $157;
    List<int>? $155;
    AsyncResult<List<int>>? $158;
    AsyncResult<Object?>? $160;
    int $162 = 0;
    int? $164;
    int? $165;
    List<int>? $163;
    AsyncResult<List<int>>? $166;
    AsyncResult<Object?>? $168;
    int? $171;
    int? $172;
    List<int>? $170;
    AsyncResult<List<int>>? $173;
    AsyncResult<Object?>? $175;
    int? $178;
    int? $179;
    List<int>? $177;
    AsyncResult<List<int>>? $180;
    AsyncResult<Object?>? $182;
    int? $185;
    int? $186;
    List<int>? $184;
    AsyncResult<List<int>>? $187;
    AsyncResult<Object?>? $189;
    int? $192;
    int? $193;
    int? $191;
    AsyncResult<int>? $194;
    AsyncResult<Object?>? $196;
    int $198 = 0;
    int? $200;
    int? $201;
    int? $199;
    AsyncResult<int>? $202;
    AsyncResult<Object?>? $204;
    int? $207;
    int? $208;
    int? $206;
    AsyncResult<int>? $209;
    AsyncResult<Object?>? $211;
    int? $214;
    int? $215;
    int? $213;
    AsyncResult<int>? $216;
    AsyncResult<Object?>? $218;
    int? $221;
    int? $222;
    int? $220;
    AsyncResult<int>? $223;
    AsyncResult<Object?>? $225;
    int? $228;
    int? $229;
    List<Object?>? $227;
    AsyncResult<List<Object?>>? $230;
    AsyncResult<Object?>? $232;
    int? $235;
    int? $236;
    int? $234;
    AsyncResult<int>? $237;
    int $239 = 0;
    AsyncResult<Object?>? $240;
    int? $243;
    int? $244;
    int? $242;
    AsyncResult<int>? $245;
    AsyncResult<Object?>? $247;
    int? $250;
    int? $251;
    ({int v1, int v2})? $249;
    AsyncResult<({int v1, int v2})>? $252;
    AsyncResult<Object?>? $254;
    int? $257;
    int? $258;
    int? $256;
    AsyncResult<int>? $259;
    AsyncResult<Object?>? $261;
    int? $264;
    int? $265;
    int? $263;
    AsyncResult<int>? $266;
    AsyncResult<Object?>? $268;
    int? $271;
    int? $272;
    String? $270;
    AsyncResult<String>? $273;
    AsyncResult<Object?>? $275;
    int $277 = 0;
    int? $279;
    int? $280;
    String? $278;
    AsyncResult<String>? $281;
    AsyncResult<Object?>? $283;
    int? $286;
    int? $287;
    int? $285;
    AsyncResult<int>? $288;
    AsyncResult<Object?>? $290;
    int? $293;
    int? $294;
    List<int>? $292;
    AsyncResult<List<int>>? $295;
    AsyncResult<Object?>? $297;
    void $1() {
      if ($277 & 0x800 == 0) {
        $277 |= 0x800;
        $3 = 0;
      }
      if ($3 == 0) {
        // (v:AndPredicate AndPredicate)
        // (v:AndPredicate AndPredicate)
        // v:AndPredicate AndPredicate
        // v:AndPredicate AndPredicate
        if ($9 & 0x4 == 0) {
          $9 |= 0x4;
          $5 = 0;
          $6 = state.pos;
        }
        if ($5 == 0) {
          // AndPredicate
          if ($9 & 0x1 == 0) {
            $9 |= 0x1;
            $7 = parseAndPredicate$Async(state);
            final $8 = $7!;
            if (!$8.isComplete) {
              $8.onComplete = $1;
              return;
            }
          }
          $4 = $7!.value;
          $9 &= ~0x1 & 0xffff;
          $5 = state.ok ? 1 : -1;
        }
        if ($5 == 1) {
          // AndPredicate
          if ($9 & 0x2 == 0) {
            $9 |= 0x2;
            $10 = fastParseAndPredicate$Async(state);
            final $11 = $10!;
            if (!$11.isComplete) {
              $11.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x2 & 0xffff;
          $5 = -1;
        }
        if (state.ok) {
          $2 = $4;
        } else {
          state.backtrack($6!);
        }
        $9 &= ~0x4 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
      }
      if ($3 == 1) {
        // (v:AnyCharacter AnyCharacter)
        // (v:AnyCharacter AnyCharacter)
        // v:AnyCharacter AnyCharacter
        // v:AnyCharacter AnyCharacter
        if ($9 & 0x20 == 0) {
          $9 |= 0x20;
          $13 = 0;
          $14 = state.pos;
        }
        if ($13 == 0) {
          // AnyCharacter
          if ($9 & 0x8 == 0) {
            $9 |= 0x8;
            $15 = parseAnyCharacter$Async(state);
            final $16 = $15!;
            if (!$16.isComplete) {
              $16.onComplete = $1;
              return;
            }
          }
          $12 = $15!.value;
          $9 &= ~0x8 & 0xffff;
          $13 = state.ok ? 1 : -1;
        }
        if ($13 == 1) {
          // AnyCharacter
          if ($9 & 0x10 == 0) {
            $9 |= 0x10;
            $17 = fastParseAnyCharacter$Async(state);
            final $18 = $17!;
            if (!$18.isComplete) {
              $18.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x10 & 0xffff;
          $13 = -1;
        }
        if (state.ok) {
          $2 = $12;
        } else {
          state.backtrack($14!);
        }
        $9 &= ~0x20 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 2
                : -1;
      }
      if ($3 == 2) {
        // (v:CharacterClass CharacterClass)
        // (v:CharacterClass CharacterClass)
        // v:CharacterClass CharacterClass
        // v:CharacterClass CharacterClass
        if ($9 & 0x100 == 0) {
          $9 |= 0x100;
          $20 = 0;
          $21 = state.pos;
        }
        if ($20 == 0) {
          // CharacterClass
          if ($9 & 0x40 == 0) {
            $9 |= 0x40;
            $22 = parseCharacterClass$Async(state);
            final $23 = $22!;
            if (!$23.isComplete) {
              $23.onComplete = $1;
              return;
            }
          }
          $19 = $22!.value;
          $9 &= ~0x40 & 0xffff;
          $20 = state.ok ? 1 : -1;
        }
        if ($20 == 1) {
          // CharacterClass
          if ($9 & 0x80 == 0) {
            $9 |= 0x80;
            $24 = fastParseCharacterClass$Async(state);
            final $25 = $24!;
            if (!$25.isComplete) {
              $25.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x80 & 0xffff;
          $20 = -1;
        }
        if (state.ok) {
          $2 = $19;
        } else {
          state.backtrack($21!);
        }
        $9 &= ~0x100 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 3
                : -1;
      }
      if ($3 == 3) {
        // (v:CharacterClassChar32 CharacterClassChar32)
        // (v:CharacterClassChar32 CharacterClassChar32)
        // v:CharacterClassChar32 CharacterClassChar32
        // v:CharacterClassChar32 CharacterClassChar32
        if ($9 & 0x800 == 0) {
          $9 |= 0x800;
          $27 = 0;
          $28 = state.pos;
        }
        if ($27 == 0) {
          // CharacterClassChar32
          if ($9 & 0x200 == 0) {
            $9 |= 0x200;
            $29 = parseCharacterClassChar32$Async(state);
            final $30 = $29!;
            if (!$30.isComplete) {
              $30.onComplete = $1;
              return;
            }
          }
          $26 = $29!.value;
          $9 &= ~0x200 & 0xffff;
          $27 = state.ok ? 1 : -1;
        }
        if ($27 == 1) {
          // CharacterClassChar32
          if ($9 & 0x400 == 0) {
            $9 |= 0x400;
            $31 = fastParseCharacterClassChar32$Async(state);
            final $32 = $31!;
            if (!$32.isComplete) {
              $32.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x400 & 0xffff;
          $27 = -1;
        }
        if (state.ok) {
          $2 = $26;
        } else {
          state.backtrack($28!);
        }
        $9 &= ~0x800 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 4
                : -1;
      }
      if ($3 == 4) {
        // (v:CharacterClassCharNegate CharacterClassCharNegate)
        // (v:CharacterClassCharNegate CharacterClassCharNegate)
        // v:CharacterClassCharNegate CharacterClassCharNegate
        // v:CharacterClassCharNegate CharacterClassCharNegate
        if ($9 & 0x4000 == 0) {
          $9 |= 0x4000;
          $34 = 0;
          $35 = state.pos;
        }
        if ($34 == 0) {
          // CharacterClassCharNegate
          if ($9 & 0x1000 == 0) {
            $9 |= 0x1000;
            $36 = parseCharacterClassCharNegate$Async(state);
            final $37 = $36!;
            if (!$37.isComplete) {
              $37.onComplete = $1;
              return;
            }
          }
          $33 = $36!.value;
          $9 &= ~0x1000 & 0xffff;
          $34 = state.ok ? 1 : -1;
        }
        if ($34 == 1) {
          // CharacterClassCharNegate
          if ($9 & 0x2000 == 0) {
            $9 |= 0x2000;
            $38 = fastParseCharacterClassCharNegate$Async(state);
            final $39 = $38!;
            if (!$39.isComplete) {
              $39.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x2000 & 0xffff;
          $34 = -1;
        }
        if (state.ok) {
          $2 = $33;
        } else {
          state.backtrack($35!);
        }
        $9 &= ~0x4000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 5
                : -1;
      }
      if ($3 == 5) {
        // (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
        // (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
        // v:CharacterClassCharNegate32 CharacterClassCharNegate32
        // v:CharacterClassCharNegate32 CharacterClassCharNegate32
        if ($47 & 0x2 == 0) {
          $47 |= 0x2;
          $41 = 0;
          $42 = state.pos;
        }
        if ($41 == 0) {
          // CharacterClassCharNegate32
          if ($9 & 0x8000 == 0) {
            $9 |= 0x8000;
            $43 = parseCharacterClassCharNegate32$Async(state);
            final $44 = $43!;
            if (!$44.isComplete) {
              $44.onComplete = $1;
              return;
            }
          }
          $40 = $43!.value;
          $9 &= ~0x8000 & 0xffff;
          $41 = state.ok ? 1 : -1;
        }
        if ($41 == 1) {
          // CharacterClassCharNegate32
          if ($47 & 0x1 == 0) {
            $47 |= 0x1;
            $45 = fastParseCharacterClassCharNegate32$Async(state);
            final $46 = $45!;
            if (!$46.isComplete) {
              $46.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x1 & 0xffff;
          $41 = -1;
        }
        if (state.ok) {
          $2 = $40;
        } else {
          state.backtrack($42!);
        }
        $47 &= ~0x2 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 6
                : -1;
      }
      if ($3 == 6) {
        // (v:CharacterClassRange32 CharacterClassRange32)
        // (v:CharacterClassRange32 CharacterClassRange32)
        // v:CharacterClassRange32 CharacterClassRange32
        // v:CharacterClassRange32 CharacterClassRange32
        if ($47 & 0x10 == 0) {
          $47 |= 0x10;
          $49 = 0;
          $50 = state.pos;
        }
        if ($49 == 0) {
          // CharacterClassRange32
          if ($47 & 0x4 == 0) {
            $47 |= 0x4;
            $51 = parseCharacterClassRange32$Async(state);
            final $52 = $51!;
            if (!$52.isComplete) {
              $52.onComplete = $1;
              return;
            }
          }
          $48 = $51!.value;
          $47 &= ~0x4 & 0xffff;
          $49 = state.ok ? 1 : -1;
        }
        if ($49 == 1) {
          // CharacterClassRange32
          if ($47 & 0x8 == 0) {
            $47 |= 0x8;
            $53 = fastParseCharacterClassRange32$Async(state);
            final $54 = $53!;
            if (!$54.isComplete) {
              $54.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x8 & 0xffff;
          $49 = -1;
        }
        if (state.ok) {
          $2 = $48;
        } else {
          state.backtrack($50!);
        }
        $47 &= ~0x10 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 7
                : -1;
      }
      if ($3 == 7) {
        // (v:Cut Cut)
        // (v:Cut Cut)
        // v:Cut Cut
        // v:Cut Cut
        if ($47 & 0x80 == 0) {
          $47 |= 0x80;
          $56 = 0;
          $57 = state.pos;
        }
        if ($56 == 0) {
          // Cut
          if ($47 & 0x20 == 0) {
            $47 |= 0x20;
            $58 = parseCut$Async(state);
            final $59 = $58!;
            if (!$59.isComplete) {
              $59.onComplete = $1;
              return;
            }
          }
          $55 = $58!.value;
          $47 &= ~0x20 & 0xffff;
          $56 = state.ok ? 1 : -1;
        }
        if ($56 == 1) {
          // Cut
          if ($47 & 0x40 == 0) {
            $47 |= 0x40;
            $60 = fastParseCut$Async(state);
            final $61 = $60!;
            if (!$61.isComplete) {
              $61.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x40 & 0xffff;
          $56 = -1;
        }
        if (state.ok) {
          $2 = $55;
        } else {
          state.backtrack($57!);
        }
        $47 &= ~0x80 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 8
                : -1;
      }
      if ($3 == 8) {
        // (v:ErrorHandler ErrorHandler)
        // (v:ErrorHandler ErrorHandler)
        // v:ErrorHandler ErrorHandler
        // v:ErrorHandler ErrorHandler
        if ($47 & 0x400 == 0) {
          $47 |= 0x400;
          $63 = 0;
          $64 = state.pos;
        }
        if ($63 == 0) {
          // ErrorHandler
          if ($47 & 0x100 == 0) {
            $47 |= 0x100;
            $65 = parseErrorHandler$Async(state);
            final $66 = $65!;
            if (!$66.isComplete) {
              $66.onComplete = $1;
              return;
            }
          }
          $62 = $65!.value;
          $47 &= ~0x100 & 0xffff;
          $63 = state.ok ? 1 : -1;
        }
        if ($63 == 1) {
          // ErrorHandler
          if ($47 & 0x200 == 0) {
            $47 |= 0x200;
            $67 = fastParseErrorHandler$Async(state);
            final $68 = $67!;
            if (!$68.isComplete) {
              $68.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x200 & 0xffff;
          $63 = -1;
        }
        if (state.ok) {
          $2 = $62;
        } else {
          state.backtrack($64!);
        }
        $47 &= ~0x400 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 9
                : -1;
      }
      if ($3 == 9) {
        // (v:Eof Eof)
        // (v:Eof Eof)
        // v:Eof Eof
        // v:Eof Eof
        if ($47 & 0x2000 == 0) {
          $47 |= 0x2000;
          $70 = 0;
          $71 = state.pos;
        }
        if ($70 == 0) {
          // Eof
          if ($47 & 0x800 == 0) {
            $47 |= 0x800;
            $72 = parseEof$Async(state);
            final $73 = $72!;
            if (!$73.isComplete) {
              $73.onComplete = $1;
              return;
            }
          }
          $69 = $72!.value;
          $47 &= ~0x800 & 0xffff;
          $70 = state.ok ? 1 : -1;
        }
        if ($70 == 1) {
          // Eof
          if ($47 & 0x1000 == 0) {
            $47 |= 0x1000;
            $74 = fastParseEof$Async(state);
            final $75 = $74!;
            if (!$75.isComplete) {
              $75.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x1000 & 0xffff;
          $70 = -1;
        }
        if (state.ok) {
          $2 = $69;
        } else {
          state.backtrack($71!);
        }
        $47 &= ~0x2000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 10
                : -1;
      }
      if ($3 == 10) {
        // (v:Expected Expected)
        // (v:Expected Expected)
        // v:Expected Expected
        // v:Expected Expected
        if ($83 & 0x1 == 0) {
          $83 |= 0x1;
          $77 = 0;
          $78 = state.pos;
        }
        if ($77 == 0) {
          // Expected
          if ($47 & 0x4000 == 0) {
            $47 |= 0x4000;
            $79 = parseExpected$Async(state);
            final $80 = $79!;
            if (!$80.isComplete) {
              $80.onComplete = $1;
              return;
            }
          }
          $76 = $79!.value;
          $47 &= ~0x4000 & 0xffff;
          $77 = state.ok ? 1 : -1;
        }
        if ($77 == 1) {
          // Expected
          if ($47 & 0x8000 == 0) {
            $47 |= 0x8000;
            $81 = fastParseExpected$Async(state);
            final $82 = $81!;
            if (!$82.isComplete) {
              $82.onComplete = $1;
              return;
            }
          }
          $47 &= ~0x8000 & 0xffff;
          $77 = -1;
        }
        if (state.ok) {
          $2 = $76;
        } else {
          state.backtrack($78!);
        }
        $83 &= ~0x1 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 11
                : -1;
      }
      if ($3 == 11) {
        // (v:Literal0 Literal0)
        // (v:Literal0 Literal0)
        // v:Literal0 Literal0
        // v:Literal0 Literal0
        if ($83 & 0x8 == 0) {
          $83 |= 0x8;
          $85 = 0;
          $86 = state.pos;
        }
        if ($85 == 0) {
          // Literal0
          if ($83 & 0x2 == 0) {
            $83 |= 0x2;
            $87 = parseLiteral0$Async(state);
            final $88 = $87!;
            if (!$88.isComplete) {
              $88.onComplete = $1;
              return;
            }
          }
          $84 = $87!.value;
          $83 &= ~0x2 & 0xffff;
          $85 = state.ok ? 1 : -1;
        }
        if ($85 == 1) {
          // Literal0
          if ($83 & 0x4 == 0) {
            $83 |= 0x4;
            $89 = fastParseLiteral0$Async(state);
            final $90 = $89!;
            if (!$90.isComplete) {
              $90.onComplete = $1;
              return;
            }
          }
          $83 &= ~0x4 & 0xffff;
          $85 = -1;
        }
        if (state.ok) {
          $2 = $84;
        } else {
          state.backtrack($86!);
        }
        $83 &= ~0x8 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 12
                : -1;
      }
      if ($3 == 12) {
        // (v:Literal1 Literal1)
        // (v:Literal1 Literal1)
        // v:Literal1 Literal1
        // v:Literal1 Literal1
        if ($83 & 0x40 == 0) {
          $83 |= 0x40;
          $92 = 0;
          $93 = state.pos;
        }
        if ($92 == 0) {
          // Literal1
          if ($83 & 0x10 == 0) {
            $83 |= 0x10;
            $94 = parseLiteral1$Async(state);
            final $95 = $94!;
            if (!$95.isComplete) {
              $95.onComplete = $1;
              return;
            }
          }
          $91 = $94!.value;
          $83 &= ~0x10 & 0xffff;
          $92 = state.ok ? 1 : -1;
        }
        if ($92 == 1) {
          // Literal1
          if ($83 & 0x20 == 0) {
            $83 |= 0x20;
            $96 = fastParseLiteral1$Async(state);
            final $97 = $96!;
            if (!$97.isComplete) {
              $97.onComplete = $1;
              return;
            }
          }
          $83 &= ~0x20 & 0xffff;
          $92 = -1;
        }
        if (state.ok) {
          $2 = $91;
        } else {
          state.backtrack($93!);
        }
        $83 &= ~0x40 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 13
                : -1;
      }
      if ($3 == 13) {
        // (v:Literal2 Literal2)
        // (v:Literal2 Literal2)
        // v:Literal2 Literal2
        // v:Literal2 Literal2
        if ($83 & 0x200 == 0) {
          $83 |= 0x200;
          $99 = 0;
          $100 = state.pos;
        }
        if ($99 == 0) {
          // Literal2
          if ($83 & 0x80 == 0) {
            $83 |= 0x80;
            $101 = parseLiteral2$Async(state);
            final $102 = $101!;
            if (!$102.isComplete) {
              $102.onComplete = $1;
              return;
            }
          }
          $98 = $101!.value;
          $83 &= ~0x80 & 0xffff;
          $99 = state.ok ? 1 : -1;
        }
        if ($99 == 1) {
          // Literal2
          if ($83 & 0x100 == 0) {
            $83 |= 0x100;
            $103 = fastParseLiteral2$Async(state);
            final $104 = $103!;
            if (!$104.isComplete) {
              $104.onComplete = $1;
              return;
            }
          }
          $83 &= ~0x100 & 0xffff;
          $99 = -1;
        }
        if (state.ok) {
          $2 = $98;
        } else {
          state.backtrack($100!);
        }
        $83 &= ~0x200 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 14
                : -1;
      }
      if ($3 == 14) {
        // (v:Literals Literals)
        // (v:Literals Literals)
        // v:Literals Literals
        // v:Literals Literals
        if ($83 & 0x1000 == 0) {
          $83 |= 0x1000;
          $106 = 0;
          $107 = state.pos;
        }
        if ($106 == 0) {
          // Literals
          if ($83 & 0x400 == 0) {
            $83 |= 0x400;
            $108 = parseLiterals$Async(state);
            final $109 = $108!;
            if (!$109.isComplete) {
              $109.onComplete = $1;
              return;
            }
          }
          $105 = $108!.value;
          $83 &= ~0x400 & 0xffff;
          $106 = state.ok ? 1 : -1;
        }
        if ($106 == 1) {
          // Literals
          if ($83 & 0x800 == 0) {
            $83 |= 0x800;
            $110 = fastParseLiterals$Async(state);
            final $111 = $110!;
            if (!$111.isComplete) {
              $111.onComplete = $1;
              return;
            }
          }
          $83 &= ~0x800 & 0xffff;
          $106 = -1;
        }
        if (state.ok) {
          $2 = $105;
        } else {
          state.backtrack($107!);
        }
        $83 &= ~0x1000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 15
                : -1;
      }
      if ($3 == 15) {
        // (v:MatchString MatchString)
        // (v:MatchString MatchString)
        // v:MatchString MatchString
        // v:MatchString MatchString
        if ($83 & 0x8000 == 0) {
          $83 |= 0x8000;
          $113 = 0;
          $114 = state.pos;
        }
        if ($113 == 0) {
          // MatchString
          if ($83 & 0x2000 == 0) {
            $83 |= 0x2000;
            $115 = parseMatchString$Async(state);
            final $116 = $115!;
            if (!$116.isComplete) {
              $116.onComplete = $1;
              return;
            }
          }
          $112 = $115!.value;
          $83 &= ~0x2000 & 0xffff;
          $113 = state.ok ? 1 : -1;
        }
        if ($113 == 1) {
          // MatchString
          if ($83 & 0x4000 == 0) {
            $83 |= 0x4000;
            $117 = fastParseMatchString$Async(state);
            final $118 = $117!;
            if (!$118.isComplete) {
              $118.onComplete = $1;
              return;
            }
          }
          $83 &= ~0x4000 & 0xffff;
          $113 = -1;
        }
        if (state.ok) {
          $2 = $112;
        } else {
          state.backtrack($114!);
        }
        $83 &= ~0x8000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 16
                : -1;
      }
      if ($3 == 16) {
        // (v:NotPredicate NotPredicate)
        // (v:NotPredicate NotPredicate)
        // v:NotPredicate NotPredicate
        // v:NotPredicate NotPredicate
        if ($124 & 0x4 == 0) {
          $124 |= 0x4;
          $120 = 0;
          $121 = state.pos;
        }
        if ($120 == 0) {
          // NotPredicate
          if ($124 & 0x1 == 0) {
            $124 |= 0x1;
            $122 = parseNotPredicate$Async(state);
            final $123 = $122!;
            if (!$123.isComplete) {
              $123.onComplete = $1;
              return;
            }
          }
          $119 = $122!.value;
          $124 &= ~0x1 & 0xffff;
          $120 = state.ok ? 1 : -1;
        }
        if ($120 == 1) {
          // NotPredicate
          if ($124 & 0x2 == 0) {
            $124 |= 0x2;
            $125 = fastParseNotPredicate$Async(state);
            final $126 = $125!;
            if (!$126.isComplete) {
              $126.onComplete = $1;
              return;
            }
          }
          $124 &= ~0x2 & 0xffff;
          $120 = -1;
        }
        if (state.ok) {
          $2 = $119;
        } else {
          state.backtrack($121!);
        }
        $124 &= ~0x4 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 17
                : -1;
      }
      if ($3 == 17) {
        // (v:OneOrMore OneOrMore)
        // (v:OneOrMore OneOrMore)
        // v:OneOrMore OneOrMore
        // v:OneOrMore OneOrMore
        if ($124 & 0x20 == 0) {
          $124 |= 0x20;
          $128 = 0;
          $129 = state.pos;
        }
        if ($128 == 0) {
          // OneOrMore
          if ($124 & 0x8 == 0) {
            $124 |= 0x8;
            $130 = parseOneOrMore$Async(state);
            final $131 = $130!;
            if (!$131.isComplete) {
              $131.onComplete = $1;
              return;
            }
          }
          $127 = $130!.value;
          $124 &= ~0x8 & 0xffff;
          $128 = state.ok ? 1 : -1;
        }
        if ($128 == 1) {
          // OneOrMore
          if ($124 & 0x10 == 0) {
            $124 |= 0x10;
            $132 = fastParseOneOrMore$Async(state);
            final $133 = $132!;
            if (!$133.isComplete) {
              $133.onComplete = $1;
              return;
            }
          }
          $124 &= ~0x10 & 0xffff;
          $128 = -1;
        }
        if (state.ok) {
          $2 = $127;
        } else {
          state.backtrack($129!);
        }
        $124 &= ~0x20 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 18
                : -1;
      }
      if ($3 == 18) {
        // (v:OrderedChoice2 OrderedChoice2)
        // (v:OrderedChoice2 OrderedChoice2)
        // v:OrderedChoice2 OrderedChoice2
        // v:OrderedChoice2 OrderedChoice2
        if ($124 & 0x100 == 0) {
          $124 |= 0x100;
          $135 = 0;
          $136 = state.pos;
        }
        if ($135 == 0) {
          // OrderedChoice2
          if ($124 & 0x40 == 0) {
            $124 |= 0x40;
            $137 = parseOrderedChoice2$Async(state);
            final $138 = $137!;
            if (!$138.isComplete) {
              $138.onComplete = $1;
              return;
            }
          }
          $134 = $137!.value;
          $124 &= ~0x40 & 0xffff;
          $135 = state.ok ? 1 : -1;
        }
        if ($135 == 1) {
          // OrderedChoice2
          if ($124 & 0x80 == 0) {
            $124 |= 0x80;
            $139 = fastParseOrderedChoice2$Async(state);
            final $140 = $139!;
            if (!$140.isComplete) {
              $140.onComplete = $1;
              return;
            }
          }
          $124 &= ~0x80 & 0xffff;
          $135 = -1;
        }
        if (state.ok) {
          $2 = $134;
        } else {
          state.backtrack($136!);
        }
        $124 &= ~0x100 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 19
                : -1;
      }
      if ($3 == 19) {
        // (v:OrderedChoice3 OrderedChoice3)
        // (v:OrderedChoice3 OrderedChoice3)
        // v:OrderedChoice3 OrderedChoice3
        // v:OrderedChoice3 OrderedChoice3
        if ($124 & 0x800 == 0) {
          $124 |= 0x800;
          $142 = 0;
          $143 = state.pos;
        }
        if ($142 == 0) {
          // OrderedChoice3
          if ($124 & 0x200 == 0) {
            $124 |= 0x200;
            $144 = parseOrderedChoice3$Async(state);
            final $145 = $144!;
            if (!$145.isComplete) {
              $145.onComplete = $1;
              return;
            }
          }
          $141 = $144!.value;
          $124 &= ~0x200 & 0xffff;
          $142 = state.ok ? 1 : -1;
        }
        if ($142 == 1) {
          // OrderedChoice3
          if ($124 & 0x400 == 0) {
            $124 |= 0x400;
            $146 = fastParseOrderedChoice3$Async(state);
            final $147 = $146!;
            if (!$147.isComplete) {
              $147.onComplete = $1;
              return;
            }
          }
          $124 &= ~0x400 & 0xffff;
          $142 = -1;
        }
        if (state.ok) {
          $2 = $141;
        } else {
          state.backtrack($143!);
        }
        $124 &= ~0x800 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 20
                : -1;
      }
      if ($3 == 20) {
        // (v:Optional Optional)
        // (v:Optional Optional)
        // v:Optional Optional
        // v:Optional Optional
        if ($124 & 0x4000 == 0) {
          $124 |= 0x4000;
          $149 = 0;
          $150 = state.pos;
        }
        if ($149 == 0) {
          // Optional
          if ($124 & 0x1000 == 0) {
            $124 |= 0x1000;
            $151 = parseOptional$Async(state);
            final $152 = $151!;
            if (!$152.isComplete) {
              $152.onComplete = $1;
              return;
            }
          }
          $148 = $151!.value;
          $124 &= ~0x1000 & 0xffff;
          $149 = state.ok ? 1 : -1;
        }
        if ($149 == 1) {
          // Optional
          if ($124 & 0x2000 == 0) {
            $124 |= 0x2000;
            $153 = fastParseOptional$Async(state);
            final $154 = $153!;
            if (!$154.isComplete) {
              $154.onComplete = $1;
              return;
            }
          }
          $124 &= ~0x2000 & 0xffff;
          $149 = -1;
        }
        if (state.ok) {
          $2 = $148;
        } else {
          state.backtrack($150!);
        }
        $124 &= ~0x4000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 21
                : -1;
      }
      if ($3 == 21) {
        // (v:RepetitionMax RepetitionMax)
        // (v:RepetitionMax RepetitionMax)
        // v:RepetitionMax RepetitionMax
        // v:RepetitionMax RepetitionMax
        if ($162 & 0x2 == 0) {
          $162 |= 0x2;
          $156 = 0;
          $157 = state.pos;
        }
        if ($156 == 0) {
          // RepetitionMax
          if ($124 & 0x8000 == 0) {
            $124 |= 0x8000;
            $158 = parseRepetitionMax$Async(state);
            final $159 = $158!;
            if (!$159.isComplete) {
              $159.onComplete = $1;
              return;
            }
          }
          $155 = $158!.value;
          $124 &= ~0x8000 & 0xffff;
          $156 = state.ok ? 1 : -1;
        }
        if ($156 == 1) {
          // RepetitionMax
          if ($162 & 0x1 == 0) {
            $162 |= 0x1;
            $160 = fastParseRepetitionMax$Async(state);
            final $161 = $160!;
            if (!$161.isComplete) {
              $161.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x1 & 0xffff;
          $156 = -1;
        }
        if (state.ok) {
          $2 = $155;
        } else {
          state.backtrack($157!);
        }
        $162 &= ~0x2 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 22
                : -1;
      }
      if ($3 == 22) {
        // (v:RepetitionMin RepetitionMin)
        // (v:RepetitionMin RepetitionMin)
        // v:RepetitionMin RepetitionMin
        // v:RepetitionMin RepetitionMin
        if ($162 & 0x10 == 0) {
          $162 |= 0x10;
          $164 = 0;
          $165 = state.pos;
        }
        if ($164 == 0) {
          // RepetitionMin
          if ($162 & 0x4 == 0) {
            $162 |= 0x4;
            $166 = parseRepetitionMin$Async(state);
            final $167 = $166!;
            if (!$167.isComplete) {
              $167.onComplete = $1;
              return;
            }
          }
          $163 = $166!.value;
          $162 &= ~0x4 & 0xffff;
          $164 = state.ok ? 1 : -1;
        }
        if ($164 == 1) {
          // RepetitionMin
          if ($162 & 0x8 == 0) {
            $162 |= 0x8;
            $168 = fastParseRepetitionMin$Async(state);
            final $169 = $168!;
            if (!$169.isComplete) {
              $169.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x8 & 0xffff;
          $164 = -1;
        }
        if (state.ok) {
          $2 = $163;
        } else {
          state.backtrack($165!);
        }
        $162 &= ~0x10 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 23
                : -1;
      }
      if ($3 == 23) {
        // (v:RepetitionMinMax RepetitionMinMax)
        // (v:RepetitionMinMax RepetitionMinMax)
        // v:RepetitionMinMax RepetitionMinMax
        // v:RepetitionMinMax RepetitionMinMax
        if ($162 & 0x80 == 0) {
          $162 |= 0x80;
          $171 = 0;
          $172 = state.pos;
        }
        if ($171 == 0) {
          // RepetitionMinMax
          if ($162 & 0x20 == 0) {
            $162 |= 0x20;
            $173 = parseRepetitionMinMax$Async(state);
            final $174 = $173!;
            if (!$174.isComplete) {
              $174.onComplete = $1;
              return;
            }
          }
          $170 = $173!.value;
          $162 &= ~0x20 & 0xffff;
          $171 = state.ok ? 1 : -1;
        }
        if ($171 == 1) {
          // RepetitionMinMax
          if ($162 & 0x40 == 0) {
            $162 |= 0x40;
            $175 = fastParseRepetitionMinMax$Async(state);
            final $176 = $175!;
            if (!$176.isComplete) {
              $176.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x40 & 0xffff;
          $171 = -1;
        }
        if (state.ok) {
          $2 = $170;
        } else {
          state.backtrack($172!);
        }
        $162 &= ~0x80 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 24
                : -1;
      }
      if ($3 == 24) {
        // (v:RepetitionN RepetitionN)
        // (v:RepetitionN RepetitionN)
        // v:RepetitionN RepetitionN
        // v:RepetitionN RepetitionN
        if ($162 & 0x400 == 0) {
          $162 |= 0x400;
          $178 = 0;
          $179 = state.pos;
        }
        if ($178 == 0) {
          // RepetitionN
          if ($162 & 0x100 == 0) {
            $162 |= 0x100;
            $180 = parseRepetitionN$Async(state);
            final $181 = $180!;
            if (!$181.isComplete) {
              $181.onComplete = $1;
              return;
            }
          }
          $177 = $180!.value;
          $162 &= ~0x100 & 0xffff;
          $178 = state.ok ? 1 : -1;
        }
        if ($178 == 1) {
          // RepetitionN
          if ($162 & 0x200 == 0) {
            $162 |= 0x200;
            $182 = fastParseRepetitionN$Async(state);
            final $183 = $182!;
            if (!$183.isComplete) {
              $183.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x200 & 0xffff;
          $178 = -1;
        }
        if (state.ok) {
          $2 = $177;
        } else {
          state.backtrack($179!);
        }
        $162 &= ~0x400 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 25
                : -1;
      }
      if ($3 == 25) {
        // (v:SepBy SepBy)
        // (v:SepBy SepBy)
        // v:SepBy SepBy
        // v:SepBy SepBy
        if ($162 & 0x2000 == 0) {
          $162 |= 0x2000;
          $185 = 0;
          $186 = state.pos;
        }
        if ($185 == 0) {
          // SepBy
          if ($162 & 0x800 == 0) {
            $162 |= 0x800;
            $187 = parseSepBy$Async(state);
            final $188 = $187!;
            if (!$188.isComplete) {
              $188.onComplete = $1;
              return;
            }
          }
          $184 = $187!.value;
          $162 &= ~0x800 & 0xffff;
          $185 = state.ok ? 1 : -1;
        }
        if ($185 == 1) {
          // SepBy
          if ($162 & 0x1000 == 0) {
            $162 |= 0x1000;
            $189 = fastParseSepBy$Async(state);
            final $190 = $189!;
            if (!$190.isComplete) {
              $190.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x1000 & 0xffff;
          $185 = -1;
        }
        if (state.ok) {
          $2 = $184;
        } else {
          state.backtrack($186!);
        }
        $162 &= ~0x2000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 26
                : -1;
      }
      if ($3 == 26) {
        // (v:Sequence1 Sequence1)
        // (v:Sequence1 Sequence1)
        // v:Sequence1 Sequence1
        // v:Sequence1 Sequence1
        if ($198 & 0x1 == 0) {
          $198 |= 0x1;
          $192 = 0;
          $193 = state.pos;
        }
        if ($192 == 0) {
          // Sequence1
          if ($162 & 0x4000 == 0) {
            $162 |= 0x4000;
            $194 = parseSequence1$Async(state);
            final $195 = $194!;
            if (!$195.isComplete) {
              $195.onComplete = $1;
              return;
            }
          }
          $191 = $194!.value;
          $162 &= ~0x4000 & 0xffff;
          $192 = state.ok ? 1 : -1;
        }
        if ($192 == 1) {
          // Sequence1
          if ($162 & 0x8000 == 0) {
            $162 |= 0x8000;
            $196 = fastParseSequence1$Async(state);
            final $197 = $196!;
            if (!$197.isComplete) {
              $197.onComplete = $1;
              return;
            }
          }
          $162 &= ~0x8000 & 0xffff;
          $192 = -1;
        }
        if (state.ok) {
          $2 = $191;
        } else {
          state.backtrack($193!);
        }
        $198 &= ~0x1 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 27
                : -1;
      }
      if ($3 == 27) {
        // (v:Sequence1WithAction Sequence1WithAction)
        // (v:Sequence1WithAction Sequence1WithAction)
        // v:Sequence1WithAction Sequence1WithAction
        // v:Sequence1WithAction Sequence1WithAction
        if ($198 & 0x8 == 0) {
          $198 |= 0x8;
          $200 = 0;
          $201 = state.pos;
        }
        if ($200 == 0) {
          // Sequence1WithAction
          if ($198 & 0x2 == 0) {
            $198 |= 0x2;
            $202 = parseSequence1WithAction$Async(state);
            final $203 = $202!;
            if (!$203.isComplete) {
              $203.onComplete = $1;
              return;
            }
          }
          $199 = $202!.value;
          $198 &= ~0x2 & 0xffff;
          $200 = state.ok ? 1 : -1;
        }
        if ($200 == 1) {
          // Sequence1WithAction
          if ($198 & 0x4 == 0) {
            $198 |= 0x4;
            $204 = fastParseSequence1WithAction$Async(state);
            final $205 = $204!;
            if (!$205.isComplete) {
              $205.onComplete = $1;
              return;
            }
          }
          $198 &= ~0x4 & 0xffff;
          $200 = -1;
        }
        if (state.ok) {
          $2 = $199;
        } else {
          state.backtrack($201!);
        }
        $198 &= ~0x8 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 28
                : -1;
      }
      if ($3 == 28) {
        // (v:Sequence1WithVariable Sequence1WithVariable)
        // (v:Sequence1WithVariable Sequence1WithVariable)
        // v:Sequence1WithVariable Sequence1WithVariable
        // v:Sequence1WithVariable Sequence1WithVariable
        if ($198 & 0x40 == 0) {
          $198 |= 0x40;
          $207 = 0;
          $208 = state.pos;
        }
        if ($207 == 0) {
          // Sequence1WithVariable
          if ($198 & 0x10 == 0) {
            $198 |= 0x10;
            $209 = parseSequence1WithVariable$Async(state);
            final $210 = $209!;
            if (!$210.isComplete) {
              $210.onComplete = $1;
              return;
            }
          }
          $206 = $209!.value;
          $198 &= ~0x10 & 0xffff;
          $207 = state.ok ? 1 : -1;
        }
        if ($207 == 1) {
          // Sequence1WithVariable
          if ($198 & 0x20 == 0) {
            $198 |= 0x20;
            $211 = fastParseSequence1WithVariable$Async(state);
            final $212 = $211!;
            if (!$212.isComplete) {
              $212.onComplete = $1;
              return;
            }
          }
          $198 &= ~0x20 & 0xffff;
          $207 = -1;
        }
        if (state.ok) {
          $2 = $206;
        } else {
          state.backtrack($208!);
        }
        $198 &= ~0x40 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 29
                : -1;
      }
      if ($3 == 29) {
        // (v:Sequence1WithVariable Sequence1WithVariable)
        // (v:Sequence1WithVariable Sequence1WithVariable)
        // v:Sequence1WithVariable Sequence1WithVariable
        // v:Sequence1WithVariable Sequence1WithVariable
        if ($198 & 0x200 == 0) {
          $198 |= 0x200;
          $214 = 0;
          $215 = state.pos;
        }
        if ($214 == 0) {
          // Sequence1WithVariable
          if ($198 & 0x80 == 0) {
            $198 |= 0x80;
            $216 = parseSequence1WithVariable$Async(state);
            final $217 = $216!;
            if (!$217.isComplete) {
              $217.onComplete = $1;
              return;
            }
          }
          $213 = $216!.value;
          $198 &= ~0x80 & 0xffff;
          $214 = state.ok ? 1 : -1;
        }
        if ($214 == 1) {
          // Sequence1WithVariable
          if ($198 & 0x100 == 0) {
            $198 |= 0x100;
            $218 = fastParseSequence1WithVariable$Async(state);
            final $219 = $218!;
            if (!$219.isComplete) {
              $219.onComplete = $1;
              return;
            }
          }
          $198 &= ~0x100 & 0xffff;
          $214 = -1;
        }
        if (state.ok) {
          $2 = $213;
        } else {
          state.backtrack($215!);
        }
        $198 &= ~0x200 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 30
                : -1;
      }
      if ($3 == 30) {
        // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
        // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
        // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
        // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
        if ($198 & 0x1000 == 0) {
          $198 |= 0x1000;
          $221 = 0;
          $222 = state.pos;
        }
        if ($221 == 0) {
          // Sequence1WithVariableWithAction
          if ($198 & 0x400 == 0) {
            $198 |= 0x400;
            $223 = parseSequence1WithVariableWithAction$Async(state);
            final $224 = $223!;
            if (!$224.isComplete) {
              $224.onComplete = $1;
              return;
            }
          }
          $220 = $223!.value;
          $198 &= ~0x400 & 0xffff;
          $221 = state.ok ? 1 : -1;
        }
        if ($221 == 1) {
          // Sequence1WithVariableWithAction
          if ($198 & 0x800 == 0) {
            $198 |= 0x800;
            $225 = fastParseSequence1WithVariableWithAction$Async(state);
            final $226 = $225!;
            if (!$226.isComplete) {
              $226.onComplete = $1;
              return;
            }
          }
          $198 &= ~0x800 & 0xffff;
          $221 = -1;
        }
        if (state.ok) {
          $2 = $220;
        } else {
          state.backtrack($222!);
        }
        $198 &= ~0x1000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 31
                : -1;
      }
      if ($3 == 31) {
        // (v:Sequence2 Sequence2)
        // (v:Sequence2 Sequence2)
        // v:Sequence2 Sequence2
        // v:Sequence2 Sequence2
        if ($198 & 0x8000 == 0) {
          $198 |= 0x8000;
          $228 = 0;
          $229 = state.pos;
        }
        if ($228 == 0) {
          // Sequence2
          if ($198 & 0x2000 == 0) {
            $198 |= 0x2000;
            $230 = parseSequence2$Async(state);
            final $231 = $230!;
            if (!$231.isComplete) {
              $231.onComplete = $1;
              return;
            }
          }
          $227 = $230!.value;
          $198 &= ~0x2000 & 0xffff;
          $228 = state.ok ? 1 : -1;
        }
        if ($228 == 1) {
          // Sequence2
          if ($198 & 0x4000 == 0) {
            $198 |= 0x4000;
            $232 = fastParseSequence2$Async(state);
            final $233 = $232!;
            if (!$233.isComplete) {
              $233.onComplete = $1;
              return;
            }
          }
          $198 &= ~0x4000 & 0xffff;
          $228 = -1;
        }
        if (state.ok) {
          $2 = $227;
        } else {
          state.backtrack($229!);
        }
        $198 &= ~0x8000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 32
                : -1;
      }
      if ($3 == 32) {
        // (v:Sequence2WithAction Sequence2WithAction)
        // (v:Sequence2WithAction Sequence2WithAction)
        // v:Sequence2WithAction Sequence2WithAction
        // v:Sequence2WithAction Sequence2WithAction
        if ($239 & 0x4 == 0) {
          $239 |= 0x4;
          $235 = 0;
          $236 = state.pos;
        }
        if ($235 == 0) {
          // Sequence2WithAction
          if ($239 & 0x1 == 0) {
            $239 |= 0x1;
            $237 = parseSequence2WithAction$Async(state);
            final $238 = $237!;
            if (!$238.isComplete) {
              $238.onComplete = $1;
              return;
            }
          }
          $234 = $237!.value;
          $239 &= ~0x1 & 0xffff;
          $235 = state.ok ? 1 : -1;
        }
        if ($235 == 1) {
          // Sequence2WithAction
          if ($239 & 0x2 == 0) {
            $239 |= 0x2;
            $240 = fastParseSequence2WithAction$Async(state);
            final $241 = $240!;
            if (!$241.isComplete) {
              $241.onComplete = $1;
              return;
            }
          }
          $239 &= ~0x2 & 0xffff;
          $235 = -1;
        }
        if (state.ok) {
          $2 = $234;
        } else {
          state.backtrack($236!);
        }
        $239 &= ~0x4 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 33
                : -1;
      }
      if ($3 == 33) {
        // (v:Sequence2WithVariable Sequence2WithVariable)
        // (v:Sequence2WithVariable Sequence2WithVariable)
        // v:Sequence2WithVariable Sequence2WithVariable
        // v:Sequence2WithVariable Sequence2WithVariable
        if ($239 & 0x20 == 0) {
          $239 |= 0x20;
          $243 = 0;
          $244 = state.pos;
        }
        if ($243 == 0) {
          // Sequence2WithVariable
          if ($239 & 0x8 == 0) {
            $239 |= 0x8;
            $245 = parseSequence2WithVariable$Async(state);
            final $246 = $245!;
            if (!$246.isComplete) {
              $246.onComplete = $1;
              return;
            }
          }
          $242 = $245!.value;
          $239 &= ~0x8 & 0xffff;
          $243 = state.ok ? 1 : -1;
        }
        if ($243 == 1) {
          // Sequence2WithVariable
          if ($239 & 0x10 == 0) {
            $239 |= 0x10;
            $247 = fastParseSequence2WithVariable$Async(state);
            final $248 = $247!;
            if (!$248.isComplete) {
              $248.onComplete = $1;
              return;
            }
          }
          $239 &= ~0x10 & 0xffff;
          $243 = -1;
        }
        if (state.ok) {
          $2 = $242;
        } else {
          state.backtrack($244!);
        }
        $239 &= ~0x20 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 34
                : -1;
      }
      if ($3 == 34) {
        // (v:Sequence2WithVariables Sequence2WithVariables)
        // (v:Sequence2WithVariables Sequence2WithVariables)
        // v:Sequence2WithVariables Sequence2WithVariables
        // v:Sequence2WithVariables Sequence2WithVariables
        if ($239 & 0x100 == 0) {
          $239 |= 0x100;
          $250 = 0;
          $251 = state.pos;
        }
        if ($250 == 0) {
          // Sequence2WithVariables
          if ($239 & 0x40 == 0) {
            $239 |= 0x40;
            $252 = parseSequence2WithVariables$Async(state);
            final $253 = $252!;
            if (!$253.isComplete) {
              $253.onComplete = $1;
              return;
            }
          }
          $249 = $252!.value;
          $239 &= ~0x40 & 0xffff;
          $250 = state.ok ? 1 : -1;
        }
        if ($250 == 1) {
          // Sequence2WithVariables
          if ($239 & 0x80 == 0) {
            $239 |= 0x80;
            $254 = fastParseSequence2WithVariables$Async(state);
            final $255 = $254!;
            if (!$255.isComplete) {
              $255.onComplete = $1;
              return;
            }
          }
          $239 &= ~0x80 & 0xffff;
          $250 = -1;
        }
        if (state.ok) {
          $2 = $249;
        } else {
          state.backtrack($251!);
        }
        $239 &= ~0x100 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 35
                : -1;
      }
      if ($3 == 35) {
        // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
        // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
        // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
        // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
        if ($239 & 0x800 == 0) {
          $239 |= 0x800;
          $257 = 0;
          $258 = state.pos;
        }
        if ($257 == 0) {
          // Sequence2WithVariableWithAction
          if ($239 & 0x200 == 0) {
            $239 |= 0x200;
            $259 = parseSequence2WithVariableWithAction$Async(state);
            final $260 = $259!;
            if (!$260.isComplete) {
              $260.onComplete = $1;
              return;
            }
          }
          $256 = $259!.value;
          $239 &= ~0x200 & 0xffff;
          $257 = state.ok ? 1 : -1;
        }
        if ($257 == 1) {
          // Sequence2WithVariableWithAction
          if ($239 & 0x400 == 0) {
            $239 |= 0x400;
            $261 = fastParseSequence2WithVariableWithAction$Async(state);
            final $262 = $261!;
            if (!$262.isComplete) {
              $262.onComplete = $1;
              return;
            }
          }
          $239 &= ~0x400 & 0xffff;
          $257 = -1;
        }
        if (state.ok) {
          $2 = $256;
        } else {
          state.backtrack($258!);
        }
        $239 &= ~0x800 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 36
                : -1;
      }
      if ($3 == 36) {
        // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
        // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
        // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
        // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
        if ($239 & 0x4000 == 0) {
          $239 |= 0x4000;
          $264 = 0;
          $265 = state.pos;
        }
        if ($264 == 0) {
          // Sequence2WithVariablesWithAction
          if ($239 & 0x1000 == 0) {
            $239 |= 0x1000;
            $266 = parseSequence2WithVariablesWithAction$Async(state);
            final $267 = $266!;
            if (!$267.isComplete) {
              $267.onComplete = $1;
              return;
            }
          }
          $263 = $266!.value;
          $239 &= ~0x1000 & 0xffff;
          $264 = state.ok ? 1 : -1;
        }
        if ($264 == 1) {
          // Sequence2WithVariablesWithAction
          if ($239 & 0x2000 == 0) {
            $239 |= 0x2000;
            $268 = fastParseSequence2WithVariablesWithAction$Async(state);
            final $269 = $268!;
            if (!$269.isComplete) {
              $269.onComplete = $1;
              return;
            }
          }
          $239 &= ~0x2000 & 0xffff;
          $264 = -1;
        }
        if (state.ok) {
          $2 = $263;
        } else {
          state.backtrack($265!);
        }
        $239 &= ~0x4000 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 37
                : -1;
      }
      if ($3 == 37) {
        // (v:Slice Slice)
        // (v:Slice Slice)
        // v:Slice Slice
        // v:Slice Slice
        if ($277 & 0x2 == 0) {
          $277 |= 0x2;
          $271 = 0;
          $272 = state.pos;
        }
        if ($271 == 0) {
          // Slice
          if ($239 & 0x8000 == 0) {
            $239 |= 0x8000;
            $273 = parseSlice$Async(state);
            final $274 = $273!;
            if (!$274.isComplete) {
              $274.onComplete = $1;
              return;
            }
          }
          $270 = $273!.value;
          $239 &= ~0x8000 & 0xffff;
          $271 = state.ok ? 1 : -1;
        }
        if ($271 == 1) {
          // Slice
          if ($277 & 0x1 == 0) {
            $277 |= 0x1;
            $275 = fastParseSlice$Async(state);
            final $276 = $275!;
            if (!$276.isComplete) {
              $276.onComplete = $1;
              return;
            }
          }
          $277 &= ~0x1 & 0xffff;
          $271 = -1;
        }
        if (state.ok) {
          $2 = $270;
        } else {
          state.backtrack($272!);
        }
        $277 &= ~0x2 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 38
                : -1;
      }
      if ($3 == 38) {
        // (v:StringChars StringChars)
        // (v:StringChars StringChars)
        // v:StringChars StringChars
        // v:StringChars StringChars
        if ($277 & 0x10 == 0) {
          $277 |= 0x10;
          $279 = 0;
          $280 = state.pos;
        }
        if ($279 == 0) {
          // StringChars
          if ($277 & 0x4 == 0) {
            $277 |= 0x4;
            $281 = parseStringChars$Async(state);
            final $282 = $281!;
            if (!$282.isComplete) {
              $282.onComplete = $1;
              return;
            }
          }
          $278 = $281!.value;
          $277 &= ~0x4 & 0xffff;
          $279 = state.ok ? 1 : -1;
        }
        if ($279 == 1) {
          // StringChars
          if ($277 & 0x8 == 0) {
            $277 |= 0x8;
            $283 = fastParseStringChars$Async(state);
            final $284 = $283!;
            if (!$284.isComplete) {
              $284.onComplete = $1;
              return;
            }
          }
          $277 &= ~0x8 & 0xffff;
          $279 = -1;
        }
        if (state.ok) {
          $2 = $278;
        } else {
          state.backtrack($280!);
        }
        $277 &= ~0x10 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 39
                : -1;
      }
      if ($3 == 39) {
        // (v:Verify Verify)
        // (v:Verify Verify)
        // v:Verify Verify
        // v:Verify Verify
        if ($277 & 0x80 == 0) {
          $277 |= 0x80;
          $286 = 0;
          $287 = state.pos;
        }
        if ($286 == 0) {
          // Verify
          if ($277 & 0x20 == 0) {
            $277 |= 0x20;
            $288 = parseVerify$Async(state);
            final $289 = $288!;
            if (!$289.isComplete) {
              $289.onComplete = $1;
              return;
            }
          }
          $285 = $288!.value;
          $277 &= ~0x20 & 0xffff;
          $286 = state.ok ? 1 : -1;
        }
        if ($286 == 1) {
          // Verify
          if ($277 & 0x40 == 0) {
            $277 |= 0x40;
            $290 = fastParseVerify$Async(state);
            final $291 = $290!;
            if (!$291.isComplete) {
              $291.onComplete = $1;
              return;
            }
          }
          $277 &= ~0x40 & 0xffff;
          $286 = -1;
        }
        if (state.ok) {
          $2 = $285;
        } else {
          state.backtrack($287!);
        }
        $277 &= ~0x80 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 40
                : -1;
      }
      if ($3 == 40) {
        // (v:ZeroOrMore ZeroOrMore)
        // (v:ZeroOrMore ZeroOrMore)
        // v:ZeroOrMore ZeroOrMore
        // v:ZeroOrMore ZeroOrMore
        if ($277 & 0x400 == 0) {
          $277 |= 0x400;
          $293 = 0;
          $294 = state.pos;
        }
        if ($293 == 0) {
          // ZeroOrMore
          if ($277 & 0x100 == 0) {
            $277 |= 0x100;
            $295 = parseZeroOrMore$Async(state);
            final $296 = $295!;
            if (!$296.isComplete) {
              $296.onComplete = $1;
              return;
            }
          }
          $292 = $295!.value;
          $277 &= ~0x100 & 0xffff;
          $293 = state.ok ? 1 : -1;
        }
        if ($293 == 1) {
          // ZeroOrMore
          if ($277 & 0x200 == 0) {
            $277 |= 0x200;
            $297 = fastParseZeroOrMore$Async(state);
            final $298 = $297!;
            if (!$298.isComplete) {
              $298.onComplete = $1;
              return;
            }
          }
          $277 &= ~0x200 & 0xffff;
          $293 = -1;
        }
        if (state.ok) {
          $2 = $292;
        } else {
          state.backtrack($294!);
        }
        $277 &= ~0x400 & 0xffff;
        $3 = -1;
      }
      $277 &= ~0x800 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  String? parseStringChars(State<String> state) {
    String? $0;
    // @stringChars($[0-9]+, [\\], [t] <String>{})
    final $10 = state.input;
    List<String>? $11;
    String? $12;
    while (state.pos < $10.length) {
      String? $2;
      // $[0-9]+
      final $5 = state.pos;
      var $6 = false;
      while (true) {
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $7 = state.input.codeUnitAt(state.pos);
          state.ok = $7 >= 48 && $7 <= 57;
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
        $6 = true;
      }
      state.setOk($6);
      if (state.ok) {
        $2 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        final v = $2!;
        if ($12 == null) {
          $12 = v;
        } else if ($11 == null) {
          $11 = [$12, v];
        } else {
          $11.add(v);
        }
      }
      final pos = state.pos;
      // [\\]
      matchChar16(state, 92);
      if (!state.ok) {
        break;
      }
      String? $3;
      // [t] <String>{}
      matchChar16(state, 116);
      if (state.ok) {
        String? $$;
        $$ = '\t';
        $3 = $$;
      }
      if (!state.ok) {
        state.backtrack(pos);
        break;
      }
      if ($12 == null) {
        $12 = $3!;
      } else {
        if ($11 == null) {
          $11 = [$12, $3!];
        } else {
          $11.add($3!);
        }
      }
    }
    state.ok = true;
    if ($12 == null) {
      $0 = '';
    } else if ($11 == null) {
      $0 = $12;
    } else {
      $0 = $11.join();
    }
    return $0;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  AsyncResult<String> parseStringChars$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    int? $3;
    int? $4;
    List<String>? $7;
    String? $8;
    String? $5;
    int? $9;
    bool? $10;
    int $13 = 0;
    Object? $15;
    String? $6;
    Object? $17;
    void $1() {
      // @stringChars($[0-9]+, [\\], [t] <String>{})
      // @stringChars($[0-9]+, [\\], [t] <String>{})
      if ($13 & 0x2 == 0) {
        $13 |= 0x2;
        $7 = null;
        $8 = null;
        $3 = 0;
      }
      while (true) {
        if ($3 == 0) {
          // $[0-9]+
          // $[0-9]+
          // $[0-9]+
          if ($13 & 0x1 == 0) {
            $13 |= 0x1;
            state.input.beginBuffering();
            $9 = state.pos;
          }
          // [0-9]+
          $10 ??= false;
          while (true) {
            // [0-9]
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              return;
            }
            final $11 = readChar16Async(state);
            if ($11 >= 0) {
              state.ok = $11 >= 48 && $11 <= 57;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            if (!state.ok) {
              break;
            }
            $10 = true;
          }
          state.setOk($10!);
          $10 = null;
          if (state.ok) {
            final input = state.input;
            final start = input.start;
            final pos = $9!;
            $5 = input.data.substring(pos - start, state.pos - start);
          }
          state.input.endBuffering();
          $13 &= ~0x1 & 0xffff;
          if (state.ok) {
            final v = $5!;
            if ($8 == null) {
              $8 = v;
            } else if ($7 == null) {
              $7 = [$8!, v];
            } else {
              $7!.add(v);
            }
          }
          $4 = state.pos;
          $3 = 1;
        }
        if ($3 == 1) {
          // [\\]
          // [\\]
          // [\\]
          $15 ??= state.input.beginBuffering();
          final $14 = state.input;
          if (state.pos >= $14.end && !$14.isClosed) {
            $14.sleep = true;
            $14.handle = $1;
            return;
          }
          matchChar16Async(state, 92);
          state.input.endBuffering();
          $15 = null;
          if (!state.ok) {
            break;
          }
          $3 = 2;
        }
        if ($3 == 2) {
          // [t] <String>{}
          // [t] <String>{}
          // [t]
          $17 ??= state.input.beginBuffering();
          final $16 = state.input;
          if (state.pos >= $16.end && !$16.isClosed) {
            $16.sleep = true;
            $16.handle = $1;
            return;
          }
          matchChar16Async(state, 116);
          state.input.endBuffering();
          $17 = null;
          if (state.ok) {
            String? $$;
            $$ = '\t';
            $6 = $$;
          }
          if (!state.ok) {
            state.backtrack($4!);
            break;
          }
          if ($8 == null) {
            $8 = $6!;
          } else {
            if ($7 == null) {
              $7 = [$8!, $6!];
            } else {
              $7!.add($6!);
            }
          }
          $3 = 0;
        }
      }
      state.ok = true;
      if ($8 == null) {
        $2 = '';
      } else if ($7 == null) {
        $2 = $8!;
      } else {
        $2 = $7!.join();
      }
      $13 &= ~0x2 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  int? parseVerify(State<String> state) {
    int? $0;
    // @verify(.)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    // .
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.runeAt(state.pos);
      state.pos += $6 > 0xffff ? 2 : 1;
      state.ok = true;
      $0 = $6;
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $0!;
      ParseError? error;
      if ($$ != 0x30) {
        error = const ErrorMessage(0, 'error');
      }
      if (error != null) {
        if ($3 <= pos) {
          state.failPos = $3;
          state.errorCount = $2;
        }
        state.failAt(pos, error);
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    return $0;
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  AsyncResult<int> parseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    int $8 = 0;
    void $1() {
      // @verify(.)
      // @verify(.)
      if ($8 & 0x1 == 0) {
        $8 |= 0x1;
        state.input.beginBuffering();
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
      }
      // .
      // .
      // .
      final $7 = state.input;
      if (state.pos >= $7.end && !$7.isClosed) {
        $7.sleep = true;
        $7.handle = $1;
        return;
      }
      final $6 = readChar32Async(state);
      state.ok = $6 >= 0;
      if (state.ok) {
        state.pos += $6 > 0xffff ? 2 : 1;
        $2 = $6;
      }
      if (state.ok) {
        final pos = $3!;
        // ignore: unused_local_variable
        final $$ = $2!;
        ParseError? error;
        if ($$ != 0x30) {
          error = const ErrorMessage(0, 'error');
        }
        if (error != null) {
          if ($4! <= pos) {
            state.failPos = $4!;
            state.errorCount = $5!;
          }
          state.failAt(pos, error);
        }
      }
      if (!state.ok) {
        $2 = null;
        state.backtrack($3!);
      }
      state.input.endBuffering();
      $8 &= ~0x1 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  List<int>? parseZeroOrMore(State<String> state) {
    List<int>? $0;
    // [0]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      $3 = matchChar16(state, 48);
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  AsyncResult<List<int>> parseZeroOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    List<int>? $3;
    int? $4;
    Object? $6;
    void $1() {
      // [0]*
      // [0]*
      $3 ??= [];
      while (true) {
        // [0]
        $6 ??= state.input.beginBuffering();
        final $5 = state.input;
        if (state.pos >= $5.end && !$5.isClosed) {
          $5.sleep = true;
          $5.handle = $1;
          return;
        }
        $4 = matchChar16Async(state, 48);
        state.input.endBuffering();
        $6 = null;
        if (!state.ok) {
          $4 = null;
          break;
        }
        $3!.add($4!);
        $4 = null;
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $3;
      }
      $3 = null;
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar16Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      return input.data.codeUnitAt(pos - start);
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return -1;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar32Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      return input.data.runeAt(pos - start);
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return -1;
  }
}

void fastParseString(
    void Function(State<String> state) fastParse, String source) {
  final result = tryParse(fastParse, source);
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

O parseString<O>(O? Function(State<String> state) parse, String source) {
  final result = tryParse(parse, source);
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
      errors.map((e) => e.length < 0 ? offset - e.length : offset).toSet();
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

    if (this.data.isEmpty) {
      this.data = data;
    } else {
      this.data = '${this.data}$data';
    }

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
      if (_cuttingPosition == end) {
        this.data = '';
      } else {
        this.data = this.data.substring(_cuttingPosition - start);
      }

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
        if (offset >= input.start && offset <= input.end) {
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
  Object? context;

  int cuttingPos = 0;

  final List<ParseError?> errors = List.filled(64, null, growable: false);

  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool isRecoverable = true;

  bool ok = false;

  int pos = 0;

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void backtrack(int pos) {
    if (pos >= cuttingPos) {
      this.pos = pos;
      return;
    }
    isRecoverable = false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  bool canHandleError(int failPos, int errorCount) {
    return failPos == this.failPos
        ? errorCount < this.errorCount
        : failPos < this.failPos;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void cut(int pos) {
    if (cuttingPos < pos) {
      cuttingPos = pos;
    }
  }

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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  void rollbackErrors(int failPos, int errorCount) {
    if (this.failPos == failPos) {
      this.errorCount = errorCount;
    } else if (this.failPos > failPos) {
      this.errorCount = 0;
    }
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
        return '$pos:';
      }
      var length = input.length - pos;
      length = length > 40 ? 40 : length;
      final string = input.substring(pos, pos + length);
      return '$pos:$string';
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

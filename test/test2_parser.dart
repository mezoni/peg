class Test2Parser {
  bool flag = false;

  String text = '';

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  void fastParseAndPredicate(State<StringReader> state) {
    // &([0] [1] [2]) [0] [1] [2]
    final $0 = state.pos;
    final $1 = state.pos;
    // [0] [1] [2]
    final $2 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (state.ok) {
      state.pos = $1;
    }
    if (state.ok) {
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        matchChar(state, 49, const ErrorExpectedCharacter(49));
        if (state.ok) {
          matchChar(state, 50, const ErrorExpectedCharacter(50));
        }
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  AsyncResult<Object?> fastParseAndPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // &([0] [1] [2]) [0] [1] [2]
            $3 = state.pos;
            //  // &([0] [1] [2])
            $4 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering($4!);
            if (state.ok) {
              state.pos = $4!;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [0]
            state.input.beginBuffering();
            $1 = 6;
            break;
          case 6:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $10 = state.input;
            if (state.pos + 1 < $10.end || $10.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $11 = state.input;
            if (state.pos + 1 < $11.end || $11.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }
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

  /// AnyCharacter =
  ///   .
  ///   ;
  void fastParseAnyCharacter(State<StringReader> state) {
    // .
    final $1 = state.input;
    if (state.pos < $1.length) {
      $1.readChar(state.pos);
      state.pos += $1.count;
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // .
            //  // .
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

            if (state.pos >= $3.start) {
              state.ok = state.pos < $3.end;
              if (state.ok) {
                final c = $3.data.runeAt(state.pos - $3.start);
                state.pos += c > 0xffff ? 2 : 1;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $3.endBuffering(state.pos);
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

  /// Buffer =
  ///     @buffer(([0] [1] [2]))
  ///   / ([0] [1])
  ///   ;
  void fastParseBuffer(State<StringReader> state) {
    // @buffer(([0] [1] [2]))
    // ([0] [1] [2])
    // [0] [1] [2]
    final $2 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (!state.ok) {
      // ([0] [1])
      // [0] [1]
      final $4 = state.pos;
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        matchChar(state, 49, const ErrorExpectedCharacter(49));
      }
      if (!state.ok) {
        state.pos = $4;
      }
    }
  }

  /// Buffer =
  ///     @buffer(([0] [1] [2]))
  ///   / ([0] [1])
  ///   ;
  AsyncResult<Object?> fastParseBuffer$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @buffer(([0] [1] [2]))
            //  // @buffer(([0] [1] [2]))
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // ([0] [1] [2])
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // ([0] [1])
            //  // ([0] [1])
            //  // [0] [1]
            //  // [0] [1]
            $7 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
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

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  void fastParseCharacterClass(State<StringReader> state) {
    // [0-9]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 >= 48 && $1 <= 57;
      if (state.ok) {
        state.pos += state.input.count;
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0-9]
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              state.ok = state.pos < $3.end;
              if (state.pos >= $3.start) {
                if (state.ok) {
                  final c = $3.data.runeAt(state.pos - $3.start);
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
                state.fail(ErrorBacktracking(state.pos));
              }
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  void fastParseCharacterClassChar32(State<StringReader> state) {
    // [\u{1f680}]
    matchChar(state, 128640, const ErrorExpectedCharacter(128640));
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  void fastParseCharacterClassRange32(State<StringReader> state) {
    // [ -\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 >= 32 && $1 <= 128640;
      if (state.ok) {
        state.pos += state.input.count;
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [ -\u{1f680}]
            //  // [ -\u{1f680}]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              state.ok = state.pos < $3.end;
              if (state.pos >= $3.start) {
                if (state.ok) {
                  final c = $3.data.runeAt(state.pos - $3.start);
                  state.ok = c >= 32 && c <= 128640;
                  if (state.ok) {
                    state.pos += c > 0xffff ? 2 : 1;
                  } else {
                    state.fail(const ErrorUnexpectedCharacter());
                  }
                } else {
                  state.fail(const ErrorUnexpectedEndOfInput());
                }
              } else {
                state.fail(ErrorBacktracking(state.pos));
              }
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// Eof =
  ///   [0] !.
  ///   ;
  void fastParseEof(State<StringReader> state) {
    // [0] !.
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      final $1 = state.pos;
      final $3 = state.input;
      if (state.pos < $3.length) {
        $3.readChar(state.pos);
        state.pos += $3.count;
        state.ok = true;
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      state.ok = !state.ok;
      if (!state.ok) {
        final length = $1 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          1 => const ErrorUnexpectedInput(1),
          2 => const ErrorUnexpectedInput(2),
          _ => ErrorUnexpectedInput(length)
        });
      }
      state.pos = $1;
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Eof =
  ///   [0] !.
  ///   ;
  AsyncResult<Object?> fastParseEof$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] !.
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // !.
            $5 = state.pos;
            state.input.beginBuffering();
            //  // .
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

            if (state.pos >= $6.start) {
              state.ok = state.pos < $6.end;
              if (state.ok) {
                final c = $6.data.runeAt(state.pos - $6.start);
                state.pos += c > 0xffff ? 2 : 1;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $6.endBuffering(state.pos);
            state.input.endBuffering($5!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $5! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $5!;
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

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  void fastParseErrorHandler(State<StringReader> state) {
    // @errorHandler([0])
    final $1 = state.failPos;
    final $2 = state.errorCount;
    // [0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok && state._canHandleError($1, $2)) {
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error = const ErrorMessage(0, 'error');
      if (rollbackErrors == true) {
        state._rollbackErrors($1, $2);
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
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @errorHandler([0])
            //  // @errorHandler([0])
            $3 = state.failPos;
            $4 = state.errorCount;
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok && state._canHandleError($3!, $4!)) {
              ParseError? error;
              // ignore: prefer_final_locals
              var rollbackErrors = false;
              rollbackErrors = true;
              error = const ErrorMessage(0, 'error');
              if (rollbackErrors == true) {
                state._rollbackErrors($3!, $4!);
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

  /// Literal0 =
  ///   ''
  ///   ;
  void fastParseLiteral0(State<StringReader> state) {
    // ''
    state.ok = true;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  AsyncResult<Object?> fastParseLiteral0$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // ''
            //  // ''
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

  /// Literal1 =
  ///   '0'
  ///   ;
  void fastParseLiteral1(State<StringReader> state) {
    // '0'
    const $1 = '0';
    matchLiteral1(state, 48, $1, const ErrorExpectedTags([$1]));
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<Object?> fastParseLiteral1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '0'
            //  // '0'
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchLiteral1Async(
                  state, 48, '0', const ErrorExpectedTags(['0']));
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// Literal2 =
  ///   '01'
  ///   ;
  void fastParseLiteral2(State<StringReader> state) {
    // '01'
    const $1 = '01';
    matchLiteral(state, $1, const ErrorExpectedTags([$1]));
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<Object?> fastParseLiteral2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '01'
            //  // '01'
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              const string = '01';
              matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  void fastParseLiterals(State<StringReader> state) {
    state.ok = false;
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $0 = $2.readChar(state.pos);
      // ignore: unused_local_variable
      final $1 = $2.count;
      switch ($0) {
        case 48:
          const $3 = '012';
          state.ok = $2.startsWith($3, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          } else {
            state.ok = $2.matchChar(49, state.pos + $1);
            if (state.ok) {
              state.pos += $1 + $2.count;
            }
          }
          break;
      }
    }
    if (!state.ok) {
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '012'
            //  // '012'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $3 = state.input;
            if (state.pos + 2 < $3.end || $3.isClosed) {
              const string = '012';
              matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // '01'
            //  // '01'
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              const string = '01';
              matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// MatchString =
  ///   @matchString()
  ///   ;
  void fastParseMatchString(State<StringReader> state) {
    // @matchString()
    final $1 = text;
    matchLiteral(state, $1, ErrorExpectedTags([$1]));
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  AsyncResult<Object?> fastParseMatchString$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @matchString()
            //  // @matchString()
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            final $4 = text;
            if (state.pos + $4.length - 1 < $3.end || $3.isClosed) {
              matchLiteralAsync(state, $4, ErrorExpectedTags([$4]));
              $3.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  void fastParseNotPredicate(State<StringReader> state) {
    // !([0] [1] [2]) [0] [1]
    final $0 = state.pos;
    final $1 = state.pos;
    // [0] [1] [2]
    final $3 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $3;
    }
    state.ok = !state.ok;
    if (!state.ok) {
      final length = $1 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(1),
        2 => const ErrorUnexpectedInput(2),
        _ => ErrorUnexpectedInput(length)
      });
    }
    state.pos = $1;
    if (state.ok) {
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        matchChar(state, 49, const ErrorExpectedCharacter(49));
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  AsyncResult<Object?> fastParseNotPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // !([0] [1] [2]) [0] [1]
            $3 = state.pos;
            //  // !([0] [1] [2])
            $4 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering($4!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $4! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $4!;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [0]
            state.input.beginBuffering();
            $1 = 6;
            break;
          case 6:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $10 = state.input;
            if (state.pos + 1 < $10.end || $10.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
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

  /// OneOrMore =
  ///   [0]+
  ///   ;
  void fastParseOneOrMore(State<StringReader> state) {
    // [0]+
    var $1 = false;
    while (true) {
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (!state.ok) {
        break;
      }
      $1 = true;
    }
    state.ok = $1;
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  AsyncResult<Object?> fastParseOneOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    bool? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]+
            //  // [0]+
            $3 = false;
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            $3 = true;
            $1 = 1;
            break;
          case 3:
            state.ok = $3!;
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

  /// Optional =
  ///   [0]? [1]
  ///   ;
  void fastParseOptional(State<StringReader> state) {
    // [0]? [1]
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    state.ok = true;
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  AsyncResult<Object?> fastParseOptional$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]? [1]
            $3 = state.pos;
            //  // [0]?
            state.input.beginBuffering();
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  void fastParseOrderedChoice2(State<StringReader> state) {
    // [0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok) {
      // [1]
      matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  AsyncResult<Object?> fastParseOrderedChoice2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  void fastParseOrderedChoice3(State<StringReader> state) {
    // [0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok) {
      // [1]
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (!state.ok) {
        // [2]
        matchChar(state, 50, const ErrorExpectedCharacter(50));
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [2]
            //  // [2]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
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

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  void fastParseRepetitionMax(State<StringReader> state) {
    // [\u{1f680}]{,3}
    var $1 = 0;
    while ($1 < 3) {
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $1++;
    }
    state.ok = true;
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{,3}
            //  // [\u{1f680}]{,3}
            $3 = 0;
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            var $4 = $3!;
            $4++;
            $3 = $4;
            $1 = $4 < 3 ? 1 : 3;
            break;
          case 3:
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

  /// RepetitionMin =
  ///     [\u{1f680}]{3,}
  ///   / [\u{1f680}]
  ///   ;
  void fastParseRepetitionMin(State<StringReader> state) {
    // [\u{1f680}]{3,}
    final $1 = state.pos;
    var $2 = 0;
    while (true) {
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.ok = $2 >= 3;
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // [\u{1f680}]
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
  }

  /// RepetitionMin =
  ///     [\u{1f680}]{3,}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMin$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{3,}
            //  // [\u{1f680}]{3,}
            $3 = 0;
            $4 = 0;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            if ($4! >= 3) {
              state.input.beginBuffering();
            }
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering($3!);
              $1 = 4;
              break;
            }
            var $5 = $4!;
            $5++;
            $4 = $5;
            if ($5 >= 3) {
              state.input.endBuffering(state.pos);
            }
            $1 = 2;
            break;
          case 4:
            state.ok = $4! >= 3;
            if (!state.ok) {
              state.pos = $3!;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
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

  /// RepetitionMinMax =
  ///     [\u{1f680}]{2,3}
  ///   / [\u{1f680}]
  ///   ;
  void fastParseRepetitionMinMax(State<StringReader> state) {
    // [\u{1f680}]{2,3}
    final $1 = state.pos;
    var $2 = 0;
    while ($2 < 3) {
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.ok = $2 >= 2;
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // [\u{1f680}]
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
  }

  /// RepetitionMinMax =
  ///     [\u{1f680}]{2,3}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMinMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{2,3}
            //  // [\u{1f680}]{2,3}
            $3 = 0;
            $4 = 0;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            if ($4! >= 2) {
              state.input.beginBuffering();
            }
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering($3!);
              $1 = 4;
              break;
            }
            var $5 = $4!;
            $5++;
            $4 = $5;
            if ($5 >= 2) {
              state.input.endBuffering(state.pos);
            }
            $1 = $5 < 3 ? 2 : 4;
            break;
          case 4:
            state.ok = $4! >= 2;
            if (!state.ok) {
              state.pos = $3!;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
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

  /// RepetitionN =
  ///     [\u{1f680}]{3,3}
  ///   / [\u{1f680}]
  ///   ;
  void fastParseRepetitionN(State<StringReader> state) {
    // [\u{1f680}]{3,3}
    final $1 = state.pos;
    var $2 = 0;
    while ($2 < 3) {
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.ok = $2 == 3;
    if (!state.ok) {
      state.pos = $1;
    }
    if (!state.ok) {
      // [\u{1f680}]
      matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
  }

  /// RepetitionN =
  ///     [\u{1f680}]{3,3}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseRepetitionN$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{3,3}
            //  // [\u{1f680}]{3,3}
            $3 = 0;
            $4 = 0;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 4;
              break;
            }
            var $5 = $4!;
            $5++;
            $4 = $5;
            $1 = $5 < 3 ? 2 : 4;
            break;
          case 4:
            state.ok = $4! == 3;
            if (!state.ok) {
              state.pos = $3!;
            }
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
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

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  void fastParseSepBy(State<StringReader> state) {
    // @sepBy([0], [,])
    // [0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      while (true) {
        final $1 = state.pos;
        // [,]
        matchChar(state, 44, const ErrorExpectedCharacter(44));
        if (!state.ok) {
          break;
        }
        // [0]
        matchChar(state, 48, const ErrorExpectedCharacter(48));
        if (!state.ok) {
          state.pos = $1;
          break;
        }
      }
    }
    state.ok = true;
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  AsyncResult<Object?> fastParseSepBy$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @sepBy([0], [,])
            //  // @sepBy([0], [,])
            state.input.beginBuffering();
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            $1 = 3;
            break;
          case 3:
            $4 = state.pos;
            state.input.beginBuffering();
            //  // [,]
            //  // [,]
            //  // [,]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 44, const ErrorExpectedCharacter(44));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $4!;
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            state.input.endBuffering(state.pos);
            $1 = 3;
            break;
          case 1:
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

  /// Sequence1 =
  ///   [0]
  ///   ;
  void fastParseSequence1(State<StringReader> state) {
    // [0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  void fastParseSequence1WithAction(State<StringReader> state) {
    // [0] <int>{}
    matchChar(state, 48, const ErrorExpectedCharacter(48));
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
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] <int>{}
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              $$ = 0x30;
            }
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

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  void fastParseSequence1WithVariable(State<StringReader> state) {
    // v:[0]
    matchChar(state, 48, const ErrorExpectedCharacter(48));
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  void fastParseSequence1WithVariableWithAction(State<StringReader> state) {
    // v:[0] <int>{}
    int? $1;
    $1 = matchChar(state, 48, const ErrorExpectedCharacter(48));
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] <int>{}
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              final v = $3!;
              $$ = v;
            }
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

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  void fastParseSequence2(State<StringReader> state) {
    // [0] [1]
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] [1]
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  void fastParseSequence2WithAction(State<StringReader> state) {
    // [0] [1] <int>{}
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        $$ = 0x30;
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] [1] <int>{}
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 1;
              break;
            }
            // ignore: unused_local_variable
            int? $$;
            $$ = 0x30;
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

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  void fastParseSequence2WithVariable(State<StringReader> state) {
    // v:[0] [1]
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] [1]
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  void fastParseSequence2WithVariableWithAction(State<StringReader> state) {
    // v:[0] [1] <int>{}
    final $0 = state.pos;
    int? $1;
    $1 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v = $1!;
        $$ = v;
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $4;
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] [1] <int>{}
            $4 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $4!;
              $1 = 1;
              break;
            }
            // ignore: unused_local_variable
            int? $$;
            final v = $3!;
            $$ = v;
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

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  void fastParseSequence2WithVariables(State<StringReader> state) {
    // v1:[0] v2:[1]
    final $0 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariables$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v1:[0] v2:[1]
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  void fastParseSequence2WithVariablesWithAction(State<StringReader> state) {
    // v1:[0] v2:[1] <int>{}
    final $0 = state.pos;
    int? $1;
    $1 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $2;
      $2 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v1 = $1!;
        final v2 = $2!;
        $$ = v1 + v2;
      }
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariablesWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $5;
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v1:[0] v2:[1] <int>{}
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            // ignore: unused_local_variable
            int? $$;
            final v1 = $3!;
            final v2 = $4!;
            $$ = v1 + v2;
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

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  void fastParseSlice(State<StringReader> state) {
    // $([0] [1] [2])
    // [0] [1] [2]
    final $2 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (!state.ok) {
      // $([0] [1])
      // [0] [1]
      final $5 = state.pos;
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        matchChar(state, 49, const ErrorExpectedCharacter(49));
      }
      if (!state.ok) {
        state.pos = $5;
      }
    }
  }

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  AsyncResult<Object?> fastParseSlice$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $3;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // $([0] [1] [2])
            //  // $([0] [1] [2])
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $3 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $3!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // $([0] [1])
            //  // $([0] [1])
            state.input.beginBuffering();
            //  // ([0] [1])
            //  // [0] [1]
            //  // [0] [1]
            $7 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            state.input.endBuffering(state.pos);
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

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  void fastParseStringChars(State<StringReader> state) {
    // @stringChars($[0-9]+, [\\], [t] <String>{})
    final $7 = state.input;
    while (state.pos < $7.length) {
      // $[0-9]+
      var $3 = false;
      while (true) {
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $4 = state.input.readChar(state.pos);
          state.ok = $4 >= 48 && $4 <= 57;
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
        $3 = true;
      }
      state.ok = $3;
      final pos = state.pos;
      // [\\]
      matchChar(state, 92, const ErrorExpectedCharacter(92));
      if (!state.ok) {
        break;
      }
      // [t] <String>{}
      matchChar(state, 116, const ErrorExpectedCharacter(116));
      if (state.ok) {
        // ignore: unused_local_variable
        String? $$;
        $$ = '\t';
      }
      if (!state.ok) {
        state.pos = pos;
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
    bool? $3;
    bool? $4;
    int? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @stringChars($[0-9]+, [\\], [t] <String>{})
            //  // @stringChars($[0-9]+, [\\], [t] <String>{})
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // $[0-9]+
            //  // $[0-9]+
            //  // $[0-9]+
            state.input.beginBuffering();
            //  // [0-9]+
            $4 = false;
            $1 = 2;
            break;
          case 2:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              state.ok = state.pos < $5.end;
              if (state.pos >= $5.start) {
                if (state.ok) {
                  final c = $5.data.runeAt(state.pos - $5.start);
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
                state.fail(ErrorBacktracking(state.pos));
              }
              $5.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 4;
              break;
            }
            $4 = true;
            $1 = 2;
            break;
          case 4:
            state.ok = $4!;
            state.input.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            $3 = state.ok;
            $1 = 5;
            break;
          case 5:
            $6 = state.pos;
            state.input.beginBuffering();
            //  // [\\]
            //  // [\\]
            //  // [\\]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 92, const ErrorExpectedCharacter(92));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = $3 == true ? 1 : 6;
              break;
            }
            //  // [t] <String>{}
            //  // [t] <String>{}
            //  // [t]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 116, const ErrorExpectedCharacter(116));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (state.ok) {
              // ignore: unused_local_variable
              String? $$;
              $$ = '\t';
            }
            if (!state.ok) {
              state.pos = $6!;
              state.input.endBuffering(state.pos);
              $1 = 6;
              break;
            }
            state.input.endBuffering(state.pos);
            $1 = 1;
            break;
          case 6:
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

  /// Verify =
  ///   @verify(.)
  ///   ;
  void fastParseVerify(State<StringReader> state) {
    // @verify(.)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    int? $1;
    // .
    final $6 = state.input;
    if (state.pos < $6.length) {
      $1 = $6.readChar(state.pos);
      state.pos += $6.count;
      state.ok = true;
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
      state.pos = $4;
    }
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  AsyncResult<Object?> fastParseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    int? $4;
    int? $5;
    int? $6;
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @verify(.)
            //  // @verify(.)
            $4 = state.pos;
            $5 = state.failPos;
            $6 = state.errorCount;
            state.input.beginBuffering();
            //  // .
            //  // .
            //  // .
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            $3 = null;
            if (state.pos >= $7.start) {
              state.ok = state.pos < $7.end;
              if (state.ok) {
                final c = $7.data.runeAt(state.pos - $7.start);
                state.pos += c > 0xffff ? 2 : 1;
                $3 = c;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $7.endBuffering(state.pos);
            if (state.ok) {
              final pos = $4!;
              // ignore: unused_local_variable
              final $$ = $3!;
              ParseError? error;
              if ($$ != 0x30) {
                error = const ErrorMessage(0, 'error');
              }
              if (error != null) {
                final failPos = $5!;
                if (failPos <= pos) {
                  state.failPos = failPos;
                  state.errorCount = $6!;
                }
                state.failAt(pos, error);
              }
            }
            if (!state.ok) {
              state.pos = $4!;
            }
            state.input.endBuffering(state.pos);
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

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  void fastParseZeroOrMore(State<StringReader> state) {
    // [0]*
    while (state.pos < state.input.length) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 == 48;
      if (!state.ok) {
        break;
      }
      state.pos += state.input.count;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  AsyncResult<Object?> fastParseZeroOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]*
            //  // [0]*
            state.input.beginBuffering();
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 < $3.end || $3.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }
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

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  List<Object?>? parseAndPredicate(State<StringReader> state) {
    List<Object?>? $0;
    // &([0] [1] [2]) [0] [1] [2]
    final $1 = state.pos;
    List<Object?>? $2;
    final $6 = state.pos;
    // [0] [1] [2]
    final $7 = state.pos;
    int? $8;
    $8 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $9;
      $9 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        int? $10;
        $10 = matchChar(state, 50, const ErrorExpectedCharacter(50));
        if (state.ok) {
          $2 = [$8!, $9!, $10!];
        }
      }
    }
    if (!state.ok) {
      state.pos = $7;
    }
    if (state.ok) {
      state.pos = $6;
    }
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        int? $4;
        $4 = matchChar(state, 49, const ErrorExpectedCharacter(49));
        if (state.ok) {
          int? $5;
          $5 = matchChar(state, 50, const ErrorExpectedCharacter(50));
          if (state.ok) {
            $0 = [$2!, $3!, $4!, $5!];
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  AsyncResult<List<Object?>> parseAndPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $8;
    List<Object?>? $4;
    int? $9;
    int? $13;
    int? $10;
    int? $11;
    int? $12;
    int? $5;
    int? $6;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // &([0] [1] [2]) [0] [1] [2]
            $8 = state.pos;
            //  // &([0] [1] [2])
            $9 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $13 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $14 = state.input;
            if (state.pos + 1 < $14.end || $14.isClosed) {
              $10 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $14.sleep = true;
              $14.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $15 = state.input;
            if (state.pos + 1 < $15.end || $15.isClosed) {
              $11 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $15.sleep = true;
              $15.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $13!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $16 = state.input;
            if (state.pos + 1 < $16.end || $16.isClosed) {
              $12 = matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $16.sleep = true;
              $16.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $13!;
              $1 = 2;
              break;
            }
            $4 = [$10!, $11!, $12!];
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering($9!);
            if (state.ok) {
              state.pos = $9!;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [0]
            state.input.beginBuffering();
            $1 = 6;
            break;
          case 6:
            final $17 = state.input;
            if (state.pos + 1 < $17.end || $17.isClosed) {
              $5 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $17.sleep = true;
              $17.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $8!;
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $18 = state.input;
            if (state.pos + 1 < $18.end || $18.isClosed) {
              $6 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $18.sleep = true;
              $18.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $8!;
              $1 = 1;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $19 = state.input;
            if (state.pos + 1 < $19.end || $19.isClosed) {
              $7 = matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $19.sleep = true;
              $19.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $8!;
              $1 = 1;
              break;
            }
            $3 = [$4!, $5!, $6!, $7!];
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

  /// AnyCharacter =
  ///   .
  ///   ;
  int? parseAnyCharacter(State<StringReader> state) {
    int? $0;
    // .
    final $2 = state.input;
    if (state.pos < $2.length) {
      $0 = $2.readChar(state.pos);
      state.pos += $2.count;
      state.ok = true;
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // .
            //  // .
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            $3 = null;
            if (state.pos >= $4.start) {
              state.ok = state.pos < $4.end;
              if (state.ok) {
                final c = $4.data.runeAt(state.pos - $4.start);
                state.pos += c > 0xffff ? 2 : 1;
                $3 = c;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $4.endBuffering(state.pos);
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

  /// Buffer =
  ///     @buffer(([0] [1] [2]))
  ///   / ([0] [1])
  ///   ;
  List<Object?>? parseBuffer(State<StringReader> state) {
    List<Object?>? $0;
    // @buffer(([0] [1] [2]))
    // ([0] [1] [2])
    // [0] [1] [2]
    final $3 = state.pos;
    int? $4;
    $4 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $5;
      $5 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        int? $6;
        $6 = matchChar(state, 50, const ErrorExpectedCharacter(50));
        if (state.ok) {
          $0 = [$4!, $5!, $6!];
        }
      }
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (!state.ok) {
      // ([0] [1])
      // [0] [1]
      final $8 = state.pos;
      int? $9;
      $9 = matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        int? $10;
        $10 = matchChar(state, 49, const ErrorExpectedCharacter(49));
        if (state.ok) {
          $0 = [$9!, $10!];
        }
      }
      if (!state.ok) {
        state.pos = $8;
      }
    }
    return $0;
  }

  /// Buffer =
  ///     @buffer(([0] [1] [2]))
  ///   / ([0] [1])
  ///   ;
  AsyncResult<List<Object?>> parseBuffer$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $7;
    int? $4;
    int? $5;
    int? $6;
    int? $13;
    int? $11;
    int? $12;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @buffer(([0] [1] [2]))
            //  // @buffer(([0] [1] [2]))
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // ([0] [1] [2])
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $7 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              $5 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos + 1 < $10.end || $10.isClosed) {
              $6 = matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            $3 = [$4!, $5!, $6!];
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // ([0] [1])
            //  // ([0] [1])
            //  // [0] [1]
            //  // [0] [1]
            $13 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $14 = state.input;
            if (state.pos + 1 < $14.end || $14.isClosed) {
              $11 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $14.sleep = true;
              $14.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $15 = state.input;
            if (state.pos + 1 < $15.end || $15.isClosed) {
              $12 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $15.sleep = true;
              $15.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $13!;
              $1 = 6;
              break;
            }
            $3 = [$11!, $12!];
            $1 = 6;
            break;
          case 6:
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

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  int? parseCharacterClass(State<StringReader> state) {
    int? $0;
    // [0-9]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.readChar(state.pos);
      state.ok = $2 >= 48 && $2 <= 57;
      if (state.ok) {
        state.pos += state.input.count;
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0-9]
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = null;
              state.ok = state.pos < $4.end;
              if (state.pos >= $4.start) {
                if (state.ok) {
                  final c = $4.data.runeAt(state.pos - $4.start);
                  state.ok = c >= 48 && c <= 57;
                  if (state.ok) {
                    state.pos += c > 0xffff ? 2 : 1;
                    $3 = c;
                  } else {
                    state.fail(const ErrorUnexpectedCharacter());
                  }
                } else {
                  state.fail(const ErrorUnexpectedEndOfInput());
                }
              } else {
                state.fail(ErrorBacktracking(state.pos));
              }
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  int? parseCharacterClassChar32(State<StringReader> state) {
    int? $0;
    // [\u{1f680}]
    $0 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  int? parseCharacterClassRange32(State<StringReader> state) {
    int? $0;
    // [ -\u{1f680}]
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $2 = state.input.readChar(state.pos);
      state.ok = $2 >= 32 && $2 <= 128640;
      if (state.ok) {
        state.pos += state.input.count;
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [ -\u{1f680}]
            //  // [ -\u{1f680}]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = null;
              state.ok = state.pos < $4.end;
              if (state.pos >= $4.start) {
                if (state.ok) {
                  final c = $4.data.runeAt(state.pos - $4.start);
                  state.ok = c >= 32 && c <= 128640;
                  if (state.ok) {
                    state.pos += c > 0xffff ? 2 : 1;
                    $3 = c;
                  } else {
                    state.fail(const ErrorUnexpectedCharacter());
                  }
                } else {
                  state.fail(const ErrorUnexpectedEndOfInput());
                }
              } else {
                state.fail(ErrorBacktracking(state.pos));
              }
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// Eof =
  ///   [0] !.
  ///   ;
  List<Object?>? parseEof(State<StringReader> state) {
    List<Object?>? $0;
    // [0] !.
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      Object? $3;
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
        $0 = [$2!, $3];
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Eof =
  ///   [0] !.
  ///   ;
  AsyncResult<List<Object?>> parseEof$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $6;
    int? $4;
    Object? $5;
    int? $8;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] !.
            $6 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // !.
            $8 = state.pos;
            state.input.beginBuffering();
            //  // .
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $9 = state.input;
            if (state.pos + 1 >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }

            if (state.pos >= $9.start) {
              state.ok = state.pos < $9.end;
              if (state.ok) {
                final c = $9.data.runeAt(state.pos - $9.start);
                state.pos += c > 0xffff ? 2 : 1;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $9.endBuffering(state.pos);
            state.input.endBuffering($8!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $8! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $8!;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            $3 = [$4!, $5];
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

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  int? parseErrorHandler(State<StringReader> state) {
    int? $0;
    // @errorHandler([0])
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // [0]
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok && state._canHandleError($2, $3)) {
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error = const ErrorMessage(0, 'error');
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

  /// ErrorHandler =
  ///   @errorHandler([0])
  ///   ;
  AsyncResult<int> parseErrorHandler$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @errorHandler([0])
            //  // @errorHandler([0])
            $4 = state.failPos;
            $5 = state.errorCount;
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok && state._canHandleError($4!, $5!)) {
              ParseError? error;
              // ignore: prefer_final_locals
              var rollbackErrors = false;
              rollbackErrors = true;
              error = const ErrorMessage(0, 'error');
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

  /// Literal0 =
  ///   ''
  ///   ;
  String? parseLiteral0(State<StringReader> state) {
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
    String? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // ''
            //  // ''
            state.ok = true;
            $3 = '';
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

  /// Literal1 =
  ///   '0'
  ///   ;
  String? parseLiteral1(State<StringReader> state) {
    String? $0;
    // '0'
    const $2 = '0';
    $0 = matchLiteral1(state, 48, $2, const ErrorExpectedTags([$2]));
    return $0;
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<String> parseLiteral1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '0'
            //  // '0'
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchLiteral1Async(
                  state, 48, '0', const ErrorExpectedTags(['0']));
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// Literal2 =
  ///   '01'
  ///   ;
  String? parseLiteral2(State<StringReader> state) {
    String? $0;
    // '01'
    const $2 = '01';
    $0 = matchLiteral(state, $2, const ErrorExpectedTags([$2]));
    return $0;
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<String> parseLiteral2$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '01'
            //  // '01'
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              const string = '01';
              $3 = matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// Literals =
  ///     '012'
  ///   / '01'
  ///   ;
  String? parseLiterals(State<StringReader> state) {
    String? $0;
    state.ok = false;
    final $3 = state.input;
    if (state.pos < $3.length) {
      final $1 = $3.readChar(state.pos);
      // ignore: unused_local_variable
      final $2 = $3.count;
      switch ($1) {
        case 48:
          const $4 = '012';
          state.ok = $3.startsWith($4, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $4;
          } else {
            state.ok = $3.matchChar(49, state.pos + $2);
            if (state.ok) {
              state.pos += $2 + $3.count;
              $0 = '01';
            }
          }
          break;
      }
    }
    if (!state.ok) {
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
    String? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '012'
            //  // '012'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 2 < $4.end || $4.isClosed) {
              const string = '012';
              $3 = matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // '01'
            //  // '01'
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              const string = '01';
              $3 = matchLiteralAsync(
                  state, string, const ErrorExpectedTags([string]));
              $5.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// MatchString =
  ///   @matchString()
  ///   ;
  String? parseMatchString(State<StringReader> state) {
    String? $0;
    // @matchString()
    final $2 = text;
    $0 = matchLiteral(state, $2, ErrorExpectedTags([$2]));
    return $0;
  }

  /// MatchString =
  ///   @matchString()
  ///   ;
  AsyncResult<String> parseMatchString$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @matchString()
            //  // @matchString()
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            final $5 = text;
            if (state.pos + $5.length - 1 < $4.end || $4.isClosed) {
              $3 = matchLiteralAsync(state, $5, ErrorExpectedTags([$5]));
              $4.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  List<Object?>? parseNotPredicate(State<StringReader> state) {
    List<Object?>? $0;
    // !([0] [1] [2]) [0] [1]
    final $1 = state.pos;
    Object? $2;
    final $5 = state.pos;
    // [0] [1] [2]
    final $7 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $7;
    }
    state.ok = !state.ok;
    if (!state.ok) {
      final length = $5 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        1 => const ErrorUnexpectedInput(1),
        2 => const ErrorUnexpectedInput(2),
        _ => ErrorUnexpectedInput(length)
      });
    }
    state.pos = $5;
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        int? $4;
        $4 = matchChar(state, 49, const ErrorExpectedCharacter(49));
        if (state.ok) {
          $0 = [$2, $3!, $4!];
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// NotPredicate =
  ///   !([0] [1] [2]) [0] [1]
  ///   ;
  AsyncResult<List<Object?>> parseNotPredicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $7;
    Object? $4;
    int? $8;
    int? $9;
    int? $5;
    int? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // !([0] [1] [2]) [0] [1]
            $7 = state.pos;
            //  // !([0] [1] [2])
            $8 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $9 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $10 = state.input;
            if (state.pos + 1 < $10.end || $10.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $11 = state.input;
            if (state.pos + 1 < $11.end || $11.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $9!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $12 = state.input;
            if (state.pos + 1 < $12.end || $12.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $12.sleep = true;
              $12.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $9!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering($8!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $8! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $8!;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [0]
            state.input.beginBuffering();
            $1 = 6;
            break;
          case 6:
            final $13 = state.input;
            if (state.pos + 1 < $13.end || $13.isClosed) {
              $5 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $13.sleep = true;
              $13.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $14 = state.input;
            if (state.pos + 1 < $14.end || $14.isClosed) {
              $6 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $14.sleep = true;
              $14.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 1;
              break;
            }
            $3 = [$4, $5!, $6!];
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

  /// OneOrMore =
  ///   [0]+
  ///   ;
  List<int>? parseOneOrMore(State<StringReader> state) {
    List<int>? $0;
    // [0]+
    final $2 = <int>[];
    while (true) {
      int? $3;
      $3 = matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.ok = $2.isNotEmpty;
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
    List<int>? $3;
    List<int>? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]+
            //  // [0]+
            $4 = [];
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // [0]
            $5 = null;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $5 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            $4!.add($5!);
            $1 = 1;
            break;
          case 3:
            state.ok = $4!.isNotEmpty;
            if (state.ok) {
              $3 = $4;
            }
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

  /// Optional =
  ///   [0]? [1]
  ///   ;
  List<Object?>? parseOptional(State<StringReader> state) {
    List<Object?>? $0;
    // [0]? [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    state.ok = true;
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        $0 = [$2, $3!];
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Optional =
  ///   [0]? [1]
  ///   ;
  AsyncResult<List<Object?>> parseOptional$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $6;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]? [1]
            $6 = state.pos;
            //  // [0]?
            state.input.beginBuffering();
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $5 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            $3 = [$4, $5!];
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

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  int? parseOrderedChoice2(State<StringReader> state) {
    int? $0;
    // [0]
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok) {
      // [1]
      $0 = matchChar(state, 49, const ErrorExpectedCharacter(49));
    }
    return $0;
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  AsyncResult<int> parseOrderedChoice2$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              $3 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
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

  /// OrderedChoice3 =
  ///     [0]
  ///   / [1]
  ///   / [2]
  ///   ;
  int? parseOrderedChoice3(State<StringReader> state) {
    int? $0;
    // [0]
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (!state.ok) {
      // [1]
      $0 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (!state.ok) {
        // [2]
        $0 = matchChar(state, 50, const ErrorExpectedCharacter(50));
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              $3 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [2]
            //  // [2]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $3 = matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
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

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  List<int>? parseRepetitionMax(State<StringReader> state) {
    List<int>? $0;
    // [\u{1f680}]{,3}
    final $2 = <int>[];
    while ($2.length < 3) {
      int? $3;
      $3 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.ok = true;
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
    List<int>? $3;
    List<int>? $4;
    int? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{,3}
            //  // [\u{1f680}]{,3}
            $4 = [];
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // [\u{1f680}]
            $6 = null;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $6 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            final $5 = $4!;
            $5.add($6!);
            $1 = $5.length < 3 ? 1 : 3;
            break;
          case 3:
            state.ok = true;
            $3 = $4;
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

  /// RepetitionMin =
  ///     [\u{1f680}]{3,}
  ///   / [\u{1f680}]
  ///   ;
  Object? parseRepetitionMin(State<StringReader> state) {
    Object? $0;
    // [\u{1f680}]{3,}
    final $2 = state.pos;
    final $3 = <int>[];
    while (true) {
      int? $4;
      $4 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ok = $3.length >= 3;
    if (state.ok) {
      $0 = $3;
    } else {
      state.pos = $2;
    }
    if (!state.ok) {
      // [\u{1f680}]
      $0 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
    return $0;
  }

  /// RepetitionMin =
  ///     [\u{1f680}]{3,}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> parseRepetitionMin$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    int? $4;
    List<int>? $5;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{3,}
            //  // [\u{1f680}]{3,}
            $4 = 0;
            $5 = [];
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            if ($5!.length >= 3) {
              state.input.beginBuffering();
            }
            //  // [\u{1f680}]
            $7 = null;
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $7 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering($4!);
              $1 = 4;
              break;
            }
            final $6 = $5!;
            $6.add($7!);
            if ($6.length >= 3) {
              state.input.endBuffering(state.pos);
            }
            $1 = 2;
            break;
          case 4:
            state.ok = $5!.length >= 3;
            if (state.ok) {
              $3 = $5;
              $5 = null;
            } else {
              state.pos = $4!;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              $3 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
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

  /// RepetitionMinMax =
  ///     [\u{1f680}]{2,3}
  ///   / [\u{1f680}]
  ///   ;
  Object? parseRepetitionMinMax(State<StringReader> state) {
    Object? $0;
    // [\u{1f680}]{2,3}
    final $2 = state.pos;
    final $3 = <int>[];
    while ($3.length < 3) {
      int? $4;
      $4 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ok = $3.length >= 2;
    if (state.ok) {
      $0 = $3;
    } else {
      state.pos = $2;
    }
    if (!state.ok) {
      // [\u{1f680}]
      $0 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
    return $0;
  }

  /// RepetitionMinMax =
  ///     [\u{1f680}]{2,3}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> parseRepetitionMinMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    int? $4;
    List<int>? $5;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{2,3}
            //  // [\u{1f680}]{2,3}
            $4 = 0;
            $5 = [];
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            if ($5!.length >= 2) {
              state.input.beginBuffering();
            }
            //  // [\u{1f680}]
            $7 = null;
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $7 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering($4!);
              $1 = 4;
              break;
            }
            final $6 = $5!;
            $6.add($7!);
            if ($6.length >= 2) {
              state.input.endBuffering(state.pos);
            }
            $1 = $6.length < 3 ? 2 : 4;
            break;
          case 4:
            state.ok = $5!.length >= 2;
            if (state.ok) {
              $3 = $5;
              $5 = null;
            } else {
              state.pos = $4!;
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              $3 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
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

  /// RepetitionN =
  ///     [\u{1f680}]{3,3}
  ///   / [\u{1f680}]
  ///   ;
  Object? parseRepetitionN(State<StringReader> state) {
    Object? $0;
    // [\u{1f680}]{3,3}
    final $2 = state.pos;
    final $3 = <int>[];
    while ($3.length < 3) {
      int? $4;
      $4 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ok = $3.length == 3;
    if (state.ok) {
      $0 = $3;
    } else {
      state.pos = $2;
    }
    if (!state.ok) {
      // [\u{1f680}]
      $0 = matchChar(state, 128640, const ErrorExpectedCharacter(128640));
    }
    return $0;
  }

  /// RepetitionN =
  ///     [\u{1f680}]{3,3}
  ///   / [\u{1f680}]
  ///   ;
  AsyncResult<Object?> parseRepetitionN$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    int? $4;
    List<int>? $5;
    int? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [\u{1f680}]{3,3}
            //  // [\u{1f680}]{3,3}
            $4 = 0;
            $5 = [];
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            //  // [\u{1f680}]
            $7 = null;
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $7 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 4;
              break;
            }
            final $6 = $5!;
            $6.add($7!);
            $1 = $6.length < 3 ? 2 : 4;
            break;
          case 4:
            state.ok = $5!.length == 3;
            if (state.ok) {
              $3 = $5;
              $5 = null;
            } else {
              state.pos = $4!;
            }
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // [\u{1f680}]
            //  // [\u{1f680}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 < $9.end || $9.isClosed) {
              $3 = matchCharAsync(
                  state, 128640, const ErrorExpectedCharacter(128640));
              state.input.endBuffering(state.pos);
            } else {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
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

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  List<int>? parseSepBy(State<StringReader> state) {
    List<int>? $0;
    // @sepBy([0], [,])
    final $3 = <int>[];
    int? $4;
    // [0]
    $4 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      $3.add($4!);
      while (true) {
        final $2 = state.pos;
        // [,]
        matchChar(state, 44, const ErrorExpectedCharacter(44));
        if (!state.ok) {
          $0 = $3;
          break;
        }
        // [0]
        $4 = matchChar(state, 48, const ErrorExpectedCharacter(48));
        if (!state.ok) {
          state.pos = $2;
          break;
        }
        $3.add($4!);
      }
    }
    state.ok = true;
    if (state.ok) {
      $0 = $3;
    }
    return $0;
  }

  /// SepBy =
  ///   @sepBy([0], [,])
  ///   ;
  AsyncResult<List<int>> parseSepBy$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $3;
    int? $4;
    int? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @sepBy([0], [,])
            //  // @sepBy([0], [,])
            state.input.beginBuffering();
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            $3 = [];
            if (!state.ok) {
              $1 = 1;
              break;
            }
            $3!.add($4!);
            $1 = 3;
            break;
          case 3:
            $6 = state.pos;
            state.input.beginBuffering();
            //  // [,]
            //  // [,]
            //  // [,]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 44, const ErrorExpectedCharacter(44));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            //  // [0]
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $6!;
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            state.input.endBuffering(state.pos);
            $3!.add($4!);
            $1 = 3;
            break;
          case 1:
            state.ok = true;
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

  /// Sequence1 =
  ///   [0]
  ///   ;
  int? parseSequence1(State<StringReader> state) {
    int? $0;
    // [0]
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<int> parseSequence1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  int? parseSequence1WithAction(State<StringReader> state) {
    int? $0;
    // [0] <int>{}
    matchChar(state, 48, const ErrorExpectedCharacter(48));
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] <int>{}
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              int? $$;
              $$ = 0x30;
              $3 = $$;
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

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  int? parseSequence1WithVariable(State<StringReader> state) {
    int? $0;
    // v:[0]
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<int> parseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
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

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  int? parseSequence1WithVariableWithAction(State<StringReader> state) {
    int? $0;
    // v:[0] <int>{}
    $0 = matchChar(state, 48, const ErrorExpectedCharacter(48));
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
    int? $3;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] <int>{}
            //  // [0]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + 1 < $4.end || $4.isClosed) {
              $3 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $4.sleep = true;
              $4.handle = $2;
              return;
            }
            if (state.ok) {
              int? $$;
              final v = $3!;
              $$ = v;
              $3 = $$;
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

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  List<Object?>? parseSequence2(State<StringReader> state) {
    List<Object?>? $0;
    // [0] [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        $0 = [$2!, $3!];
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2 =
  ///   [0] [1]
  ///   ;
  AsyncResult<List<Object?>> parseSequence2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    int? $6;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] [1]
            $6 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $5 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            $3 = [$4!, $5!];
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

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  int? parseSequence2WithAction(State<StringReader> state) {
    int? $0;
    // [0] [1] <int>{}
    final $1 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        int? $$;
        $$ = 0x30;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2WithAction =
  ///   [0] [1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0] [1] <int>{}
            $4 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $5 = state.input;
            if (state.pos + 1 < $5.end || $5.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $4!;
              $1 = 1;
              break;
            }
            int? $$;
            $$ = 0x30;
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

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  int? parseSequence2WithVariable(State<StringReader> state) {
    int? $0;
    // v:[0] [1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2WithVariable =
  ///   v:[0] [1]
  ///   ;
  AsyncResult<int> parseSequence2WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $5;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] [1]
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
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

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  int? parseSequence2WithVariableWithAction(State<StringReader> state) {
    int? $0;
    // v:[0] [1] <int>{}
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        int? $$;
        final v = $2!;
        $$ = v;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $5;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:[0] [1] <int>{}
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            int? $$;
            final v = $4!;
            $$ = v;
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

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  ({int v1, int v2})? parseSequence2WithVariables(State<StringReader> state) {
    ({int v1, int v2})? $0;
    // v1:[0] v2:[1]
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        $0 = (v1: $2!, v2: $3!);
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2WithVariables =
  ///   v1:[0] v2:[1]
  ///   ;
  AsyncResult<({int v1, int v2})> parseSequence2WithVariables$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<({int v1, int v2})>();
    ({int v1, int v2})? $3;
    int? $6;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v1:[0] v2:[1]
            $6 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $5 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            $3 = (v1: $4!, v2: $5!);
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

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  int? parseSequence2WithVariablesWithAction(State<StringReader> state) {
    int? $0;
    // v1:[0] v2:[1] <int>{}
    final $1 = state.pos;
    int? $2;
    $2 = matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      int? $3;
      $3 = matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        int? $$;
        final v1 = $2!;
        final v2 = $3!;
        $$ = v1 + v2;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  AsyncResult<int> parseSequence2WithVariablesWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $6;
    int? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v1:[0] v2:[1] <int>{}
            $6 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              $4 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              $5 = matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            int? $$;
            final v1 = $4!;
            final v2 = $5!;
            $$ = v1 + v2;
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

  /// Slice =
  ///     $([0] [1] [2])
  ///   / $([0] [1])
  ///   ;
  String? parseSlice(State<StringReader> state) {
    String? $0;
    // $([0] [1] [2])
    final $2 = state.pos;
    // [0] [1] [2]
    final $3 = state.pos;
    matchChar(state, 48, const ErrorExpectedCharacter(48));
    if (state.ok) {
      matchChar(state, 49, const ErrorExpectedCharacter(49));
      if (state.ok) {
        matchChar(state, 50, const ErrorExpectedCharacter(50));
      }
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    if (!state.ok) {
      // $([0] [1])
      final $5 = state.pos;
      // [0] [1]
      final $6 = state.pos;
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (state.ok) {
        matchChar(state, 49, const ErrorExpectedCharacter(49));
      }
      if (!state.ok) {
        state.pos = $6;
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
    String? $3;
    int? $4;
    int? $5;
    int? $9;
    int? $10;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // $([0] [1] [2])
            //  // $([0] [1] [2])
            $4 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1] [2])
            //  // [0] [1] [2]
            //  // [0] [1] [2]
            $5 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos + 1 < $7.end || $7.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
              $1 = 2;
              break;
            }
            //  // [2]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos + 1 < $8.end || $8.isClosed) {
              matchCharAsync(state, 50, const ErrorExpectedCharacter(50));
              state.input.endBuffering(state.pos);
            } else {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $5!;
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
              $3 = input.data.substring($4! - start, state.pos - start);
            }
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // $([0] [1])
            //  // $([0] [1])
            $9 = state.pos;
            state.input.beginBuffering();
            //  // ([0] [1])
            //  // [0] [1]
            //  // [0] [1]
            $10 = state.pos;
            //  // [0]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $11 = state.input;
            if (state.pos + 1 < $11.end || $11.isClosed) {
              matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [1]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $12 = state.input;
            if (state.pos + 1 < $12.end || $12.isClosed) {
              matchCharAsync(state, 49, const ErrorExpectedCharacter(49));
              state.input.endBuffering(state.pos);
            } else {
              $12.sleep = true;
              $12.handle = $2;
              return;
            }
            if (!state.ok) {
              state.pos = $10!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $3 = input.data.substring($9! - start, state.pos - start);
            }
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
  ///     (v:AndPredicate AndPredicate)
  ///   / (v:AnyCharacter AnyCharacter)
  ///   / (v:Buffer Buffer)
  ///   / (v:CharacterClass CharacterClass)
  ///   / (v:CharacterClassChar32 CharacterClassChar32)
  ///   / (v:CharacterClassRange32 CharacterClassRange32)
  ///   / (v:ErrorHandler ErrorHandler)
  ///   / (v:Eof Eof)
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
  Object? parseStart(State<StringReader> state) {
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
      state.pos = $2;
    }
    if (!state.ok) {
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
        state.pos = $5;
      }
      if (!state.ok) {
        // (v:Buffer Buffer)
        // v:Buffer Buffer
        final $8 = state.pos;
        List<Object?>? $9;
        // Buffer
        $9 = parseBuffer(state);
        if (state.ok) {
          // Buffer
          fastParseBuffer(state);
          if (state.ok) {
            $0 = $9;
          }
        }
        if (!state.ok) {
          state.pos = $8;
        }
        if (!state.ok) {
          // (v:CharacterClass CharacterClass)
          // v:CharacterClass CharacterClass
          final $11 = state.pos;
          int? $12;
          // CharacterClass
          $12 = parseCharacterClass(state);
          if (state.ok) {
            // CharacterClass
            fastParseCharacterClass(state);
            if (state.ok) {
              $0 = $12;
            }
          }
          if (!state.ok) {
            state.pos = $11;
          }
          if (!state.ok) {
            // (v:CharacterClassChar32 CharacterClassChar32)
            // v:CharacterClassChar32 CharacterClassChar32
            final $14 = state.pos;
            int? $15;
            // CharacterClassChar32
            $15 = parseCharacterClassChar32(state);
            if (state.ok) {
              // CharacterClassChar32
              fastParseCharacterClassChar32(state);
              if (state.ok) {
                $0 = $15;
              }
            }
            if (!state.ok) {
              state.pos = $14;
            }
            if (!state.ok) {
              // (v:CharacterClassRange32 CharacterClassRange32)
              // v:CharacterClassRange32 CharacterClassRange32
              final $17 = state.pos;
              int? $18;
              // CharacterClassRange32
              $18 = parseCharacterClassRange32(state);
              if (state.ok) {
                // CharacterClassRange32
                fastParseCharacterClassRange32(state);
                if (state.ok) {
                  $0 = $18;
                }
              }
              if (!state.ok) {
                state.pos = $17;
              }
              if (!state.ok) {
                // (v:ErrorHandler ErrorHandler)
                // v:ErrorHandler ErrorHandler
                final $20 = state.pos;
                int? $21;
                // ErrorHandler
                $21 = parseErrorHandler(state);
                if (state.ok) {
                  // ErrorHandler
                  fastParseErrorHandler(state);
                  if (state.ok) {
                    $0 = $21;
                  }
                }
                if (!state.ok) {
                  state.pos = $20;
                }
                if (!state.ok) {
                  // (v:Eof Eof)
                  // v:Eof Eof
                  final $23 = state.pos;
                  List<Object?>? $24;
                  // Eof
                  $24 = parseEof(state);
                  if (state.ok) {
                    // Eof
                    fastParseEof(state);
                    if (state.ok) {
                      $0 = $24;
                    }
                  }
                  if (!state.ok) {
                    state.pos = $23;
                  }
                  if (!state.ok) {
                    // (v:Literal0 Literal0)
                    // v:Literal0 Literal0
                    final $26 = state.pos;
                    String? $27;
                    // Literal0
                    $27 = parseLiteral0(state);
                    if (state.ok) {
                      // Literal0
                      fastParseLiteral0(state);
                      if (state.ok) {
                        $0 = $27;
                      }
                    }
                    if (!state.ok) {
                      state.pos = $26;
                    }
                    if (!state.ok) {
                      // (v:Literal1 Literal1)
                      // v:Literal1 Literal1
                      final $29 = state.pos;
                      String? $30;
                      // Literal1
                      $30 = parseLiteral1(state);
                      if (state.ok) {
                        // Literal1
                        fastParseLiteral1(state);
                        if (state.ok) {
                          $0 = $30;
                        }
                      }
                      if (!state.ok) {
                        state.pos = $29;
                      }
                      if (!state.ok) {
                        // (v:Literal2 Literal2)
                        // v:Literal2 Literal2
                        final $32 = state.pos;
                        String? $33;
                        // Literal2
                        $33 = parseLiteral2(state);
                        if (state.ok) {
                          // Literal2
                          fastParseLiteral2(state);
                          if (state.ok) {
                            $0 = $33;
                          }
                        }
                        if (!state.ok) {
                          state.pos = $32;
                        }
                        if (!state.ok) {
                          // (v:Literals Literals)
                          // v:Literals Literals
                          final $35 = state.pos;
                          String? $36;
                          // Literals
                          $36 = parseLiterals(state);
                          if (state.ok) {
                            // Literals
                            fastParseLiterals(state);
                            if (state.ok) {
                              $0 = $36;
                            }
                          }
                          if (!state.ok) {
                            state.pos = $35;
                          }
                          if (!state.ok) {
                            // (v:MatchString MatchString)
                            // v:MatchString MatchString
                            final $38 = state.pos;
                            String? $39;
                            // MatchString
                            $39 = parseMatchString(state);
                            if (state.ok) {
                              // MatchString
                              fastParseMatchString(state);
                              if (state.ok) {
                                $0 = $39;
                              }
                            }
                            if (!state.ok) {
                              state.pos = $38;
                            }
                            if (!state.ok) {
                              // (v:NotPredicate NotPredicate)
                              // v:NotPredicate NotPredicate
                              final $41 = state.pos;
                              List<Object?>? $42;
                              // NotPredicate
                              $42 = parseNotPredicate(state);
                              if (state.ok) {
                                // NotPredicate
                                fastParseNotPredicate(state);
                                if (state.ok) {
                                  $0 = $42;
                                }
                              }
                              if (!state.ok) {
                                state.pos = $41;
                              }
                              if (!state.ok) {
                                // (v:OneOrMore OneOrMore)
                                // v:OneOrMore OneOrMore
                                final $44 = state.pos;
                                List<int>? $45;
                                // OneOrMore
                                $45 = parseOneOrMore(state);
                                if (state.ok) {
                                  // OneOrMore
                                  fastParseOneOrMore(state);
                                  if (state.ok) {
                                    $0 = $45;
                                  }
                                }
                                if (!state.ok) {
                                  state.pos = $44;
                                }
                                if (!state.ok) {
                                  // (v:OrderedChoice2 OrderedChoice2)
                                  // v:OrderedChoice2 OrderedChoice2
                                  final $47 = state.pos;
                                  int? $48;
                                  // OrderedChoice2
                                  $48 = parseOrderedChoice2(state);
                                  if (state.ok) {
                                    // OrderedChoice2
                                    fastParseOrderedChoice2(state);
                                    if (state.ok) {
                                      $0 = $48;
                                    }
                                  }
                                  if (!state.ok) {
                                    state.pos = $47;
                                  }
                                  if (!state.ok) {
                                    // (v:OrderedChoice3 OrderedChoice3)
                                    // v:OrderedChoice3 OrderedChoice3
                                    final $50 = state.pos;
                                    int? $51;
                                    // OrderedChoice3
                                    $51 = parseOrderedChoice3(state);
                                    if (state.ok) {
                                      // OrderedChoice3
                                      fastParseOrderedChoice3(state);
                                      if (state.ok) {
                                        $0 = $51;
                                      }
                                    }
                                    if (!state.ok) {
                                      state.pos = $50;
                                    }
                                    if (!state.ok) {
                                      // (v:Optional Optional)
                                      // v:Optional Optional
                                      final $53 = state.pos;
                                      List<Object?>? $54;
                                      // Optional
                                      $54 = parseOptional(state);
                                      if (state.ok) {
                                        // Optional
                                        fastParseOptional(state);
                                        if (state.ok) {
                                          $0 = $54;
                                        }
                                      }
                                      if (!state.ok) {
                                        state.pos = $53;
                                      }
                                      if (!state.ok) {
                                        // (v:RepetitionMax RepetitionMax)
                                        // v:RepetitionMax RepetitionMax
                                        final $56 = state.pos;
                                        List<int>? $57;
                                        // RepetitionMax
                                        $57 = parseRepetitionMax(state);
                                        if (state.ok) {
                                          // RepetitionMax
                                          fastParseRepetitionMax(state);
                                          if (state.ok) {
                                            $0 = $57;
                                          }
                                        }
                                        if (!state.ok) {
                                          state.pos = $56;
                                        }
                                        if (!state.ok) {
                                          // (v:RepetitionMin RepetitionMin)
                                          // v:RepetitionMin RepetitionMin
                                          final $59 = state.pos;
                                          Object? $60;
                                          // RepetitionMin
                                          $60 = parseRepetitionMin(state);
                                          if (state.ok) {
                                            // RepetitionMin
                                            fastParseRepetitionMin(state);
                                            if (state.ok) {
                                              $0 = $60;
                                            }
                                          }
                                          if (!state.ok) {
                                            state.pos = $59;
                                          }
                                          if (!state.ok) {
                                            // (v:RepetitionMinMax RepetitionMinMax)
                                            // v:RepetitionMinMax RepetitionMinMax
                                            final $62 = state.pos;
                                            Object? $63;
                                            // RepetitionMinMax
                                            $63 = parseRepetitionMinMax(state);
                                            if (state.ok) {
                                              // RepetitionMinMax
                                              fastParseRepetitionMinMax(state);
                                              if (state.ok) {
                                                $0 = $63;
                                              }
                                            }
                                            if (!state.ok) {
                                              state.pos = $62;
                                            }
                                            if (!state.ok) {
                                              // (v:RepetitionN RepetitionN)
                                              // v:RepetitionN RepetitionN
                                              final $65 = state.pos;
                                              Object? $66;
                                              // RepetitionN
                                              $66 = parseRepetitionN(state);
                                              if (state.ok) {
                                                // RepetitionN
                                                fastParseRepetitionN(state);
                                                if (state.ok) {
                                                  $0 = $66;
                                                }
                                              }
                                              if (!state.ok) {
                                                state.pos = $65;
                                              }
                                              if (!state.ok) {
                                                // (v:SepBy SepBy)
                                                // v:SepBy SepBy
                                                final $68 = state.pos;
                                                List<int>? $69;
                                                // SepBy
                                                $69 = parseSepBy(state);
                                                if (state.ok) {
                                                  // SepBy
                                                  fastParseSepBy(state);
                                                  if (state.ok) {
                                                    $0 = $69;
                                                  }
                                                }
                                                if (!state.ok) {
                                                  state.pos = $68;
                                                }
                                                if (!state.ok) {
                                                  // (v:Sequence1 Sequence1)
                                                  // v:Sequence1 Sequence1
                                                  final $71 = state.pos;
                                                  int? $72;
                                                  // Sequence1
                                                  $72 = parseSequence1(state);
                                                  if (state.ok) {
                                                    // Sequence1
                                                    fastParseSequence1(state);
                                                    if (state.ok) {
                                                      $0 = $72;
                                                    }
                                                  }
                                                  if (!state.ok) {
                                                    state.pos = $71;
                                                  }
                                                  if (!state.ok) {
                                                    // (v:Sequence1WithAction Sequence1WithAction)
                                                    // v:Sequence1WithAction Sequence1WithAction
                                                    final $74 = state.pos;
                                                    int? $75;
                                                    // Sequence1WithAction
                                                    $75 =
                                                        parseSequence1WithAction(
                                                            state);
                                                    if (state.ok) {
                                                      // Sequence1WithAction
                                                      fastParseSequence1WithAction(
                                                          state);
                                                      if (state.ok) {
                                                        $0 = $75;
                                                      }
                                                    }
                                                    if (!state.ok) {
                                                      state.pos = $74;
                                                    }
                                                    if (!state.ok) {
                                                      // (v:Sequence1WithVariable Sequence1WithVariable)
                                                      // v:Sequence1WithVariable Sequence1WithVariable
                                                      final $77 = state.pos;
                                                      int? $78;
                                                      // Sequence1WithVariable
                                                      $78 =
                                                          parseSequence1WithVariable(
                                                              state);
                                                      if (state.ok) {
                                                        // Sequence1WithVariable
                                                        fastParseSequence1WithVariable(
                                                            state);
                                                        if (state.ok) {
                                                          $0 = $78;
                                                        }
                                                      }
                                                      if (!state.ok) {
                                                        state.pos = $77;
                                                      }
                                                      if (!state.ok) {
                                                        // (v:Sequence1WithVariable Sequence1WithVariable)
                                                        // v:Sequence1WithVariable Sequence1WithVariable
                                                        final $80 = state.pos;
                                                        int? $81;
                                                        // Sequence1WithVariable
                                                        $81 =
                                                            parseSequence1WithVariable(
                                                                state);
                                                        if (state.ok) {
                                                          // Sequence1WithVariable
                                                          fastParseSequence1WithVariable(
                                                              state);
                                                          if (state.ok) {
                                                            $0 = $81;
                                                          }
                                                        }
                                                        if (!state.ok) {
                                                          state.pos = $80;
                                                        }
                                                        if (!state.ok) {
                                                          // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
                                                          // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
                                                          final $83 = state.pos;
                                                          int? $84;
                                                          // Sequence1WithVariableWithAction
                                                          $84 =
                                                              parseSequence1WithVariableWithAction(
                                                                  state);
                                                          if (state.ok) {
                                                            // Sequence1WithVariableWithAction
                                                            fastParseSequence1WithVariableWithAction(
                                                                state);
                                                            if (state.ok) {
                                                              $0 = $84;
                                                            }
                                                          }
                                                          if (!state.ok) {
                                                            state.pos = $83;
                                                          }
                                                          if (!state.ok) {
                                                            // (v:Sequence2 Sequence2)
                                                            // v:Sequence2 Sequence2
                                                            final $86 =
                                                                state.pos;
                                                            List<Object?>? $87;
                                                            // Sequence2
                                                            $87 =
                                                                parseSequence2(
                                                                    state);
                                                            if (state.ok) {
                                                              // Sequence2
                                                              fastParseSequence2(
                                                                  state);
                                                              if (state.ok) {
                                                                $0 = $87;
                                                              }
                                                            }
                                                            if (!state.ok) {
                                                              state.pos = $86;
                                                            }
                                                            if (!state.ok) {
                                                              // (v:Sequence2WithAction Sequence2WithAction)
                                                              // v:Sequence2WithAction Sequence2WithAction
                                                              final $89 =
                                                                  state.pos;
                                                              int? $90;
                                                              // Sequence2WithAction
                                                              $90 =
                                                                  parseSequence2WithAction(
                                                                      state);
                                                              if (state.ok) {
                                                                // Sequence2WithAction
                                                                fastParseSequence2WithAction(
                                                                    state);
                                                                if (state.ok) {
                                                                  $0 = $90;
                                                                }
                                                              }
                                                              if (!state.ok) {
                                                                state.pos = $89;
                                                              }
                                                              if (!state.ok) {
                                                                // (v:Sequence2WithVariable Sequence2WithVariable)
                                                                // v:Sequence2WithVariable Sequence2WithVariable
                                                                final $92 =
                                                                    state.pos;
                                                                int? $93;
                                                                // Sequence2WithVariable
                                                                $93 =
                                                                    parseSequence2WithVariable(
                                                                        state);
                                                                if (state.ok) {
                                                                  // Sequence2WithVariable
                                                                  fastParseSequence2WithVariable(
                                                                      state);
                                                                  if (state
                                                                      .ok) {
                                                                    $0 = $93;
                                                                  }
                                                                }
                                                                if (!state.ok) {
                                                                  state.pos =
                                                                      $92;
                                                                }
                                                                if (!state.ok) {
                                                                  // (v:Sequence2WithVariables Sequence2WithVariables)
                                                                  // v:Sequence2WithVariables Sequence2WithVariables
                                                                  final $95 =
                                                                      state.pos;
                                                                  ({
                                                                    int v1,
                                                                    int v2
                                                                  })? $96;
                                                                  // Sequence2WithVariables
                                                                  $96 =
                                                                      parseSequence2WithVariables(
                                                                          state);
                                                                  if (state
                                                                      .ok) {
                                                                    // Sequence2WithVariables
                                                                    fastParseSequence2WithVariables(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      $0 = $96;
                                                                    }
                                                                  }
                                                                  if (!state
                                                                      .ok) {
                                                                    state.pos =
                                                                        $95;
                                                                  }
                                                                  if (!state
                                                                      .ok) {
                                                                    // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
                                                                    // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
                                                                    final $98 =
                                                                        state
                                                                            .pos;
                                                                    int? $99;
                                                                    // Sequence2WithVariableWithAction
                                                                    $99 = parseSequence2WithVariableWithAction(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      // Sequence2WithVariableWithAction
                                                                      fastParseSequence2WithVariableWithAction(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        $0 =
                                                                            $99;
                                                                      }
                                                                    }
                                                                    if (!state
                                                                        .ok) {
                                                                      state.pos =
                                                                          $98;
                                                                    }
                                                                    if (!state
                                                                        .ok) {
                                                                      // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
                                                                      // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
                                                                      final $101 =
                                                                          state
                                                                              .pos;
                                                                      int? $102;
                                                                      // Sequence2WithVariablesWithAction
                                                                      $102 = parseSequence2WithVariablesWithAction(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        // Sequence2WithVariablesWithAction
                                                                        fastParseSequence2WithVariablesWithAction(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          $0 =
                                                                              $102;
                                                                        }
                                                                      }
                                                                      if (!state
                                                                          .ok) {
                                                                        state.pos =
                                                                            $101;
                                                                      }
                                                                      if (!state
                                                                          .ok) {
                                                                        // (v:Slice Slice)
                                                                        // v:Slice Slice
                                                                        final $104 =
                                                                            state.pos;
                                                                        String?
                                                                            $105;
                                                                        // Slice
                                                                        $105 = parseSlice(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          // Slice
                                                                          fastParseSlice(
                                                                              state);
                                                                          if (state
                                                                              .ok) {
                                                                            $0 =
                                                                                $105;
                                                                          }
                                                                        }
                                                                        if (!state
                                                                            .ok) {
                                                                          state.pos =
                                                                              $104;
                                                                        }
                                                                        if (!state
                                                                            .ok) {
                                                                          // (v:StringChars StringChars)
                                                                          // v:StringChars StringChars
                                                                          final $107 =
                                                                              state.pos;
                                                                          String?
                                                                              $108;
                                                                          // StringChars
                                                                          $108 =
                                                                              parseStringChars(state);
                                                                          if (state
                                                                              .ok) {
                                                                            // StringChars
                                                                            fastParseStringChars(state);
                                                                            if (state.ok) {
                                                                              $0 = $108;
                                                                            }
                                                                          }
                                                                          if (!state
                                                                              .ok) {
                                                                            state.pos =
                                                                                $107;
                                                                          }
                                                                          if (!state
                                                                              .ok) {
                                                                            // (v:Verify Verify)
                                                                            // v:Verify Verify
                                                                            final $110 =
                                                                                state.pos;
                                                                            int?
                                                                                $111;
                                                                            // Verify
                                                                            $111 =
                                                                                parseVerify(state);
                                                                            if (state.ok) {
                                                                              // Verify
                                                                              fastParseVerify(state);
                                                                              if (state.ok) {
                                                                                $0 = $111;
                                                                              }
                                                                            }
                                                                            if (!state.ok) {
                                                                              state.pos = $110;
                                                                            }
                                                                            if (!state.ok) {
                                                                              // (v:ZeroOrMore ZeroOrMore)
                                                                              // v:ZeroOrMore ZeroOrMore
                                                                              final $113 = state.pos;
                                                                              List<int>? $114;
                                                                              // ZeroOrMore
                                                                              $114 = parseZeroOrMore(state);
                                                                              if (state.ok) {
                                                                                // ZeroOrMore
                                                                                fastParseZeroOrMore(state);
                                                                                if (state.ok) {
                                                                                  $0 = $114;
                                                                                }
                                                                              }
                                                                              if (!state.ok) {
                                                                                state.pos = $113;
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
  ///   / (v:Buffer Buffer)
  ///   / (v:CharacterClass CharacterClass)
  ///   / (v:CharacterClassChar32 CharacterClassChar32)
  ///   / (v:CharacterClassRange32 CharacterClassRange32)
  ///   / (v:ErrorHandler ErrorHandler)
  ///   / (v:Eof Eof)
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
    Object? $3;
    int? $5;
    List<Object?>? $4;
    AsyncResult<List<Object?>>? $6;
    AsyncResult<Object?>? $8;
    int? $11;
    int? $10;
    AsyncResult<int>? $12;
    AsyncResult<Object?>? $14;
    int? $17;
    List<Object?>? $16;
    AsyncResult<List<Object?>>? $18;
    AsyncResult<Object?>? $20;
    int? $23;
    int? $22;
    AsyncResult<int>? $24;
    AsyncResult<Object?>? $26;
    int? $29;
    int? $28;
    AsyncResult<int>? $30;
    AsyncResult<Object?>? $32;
    int? $35;
    int? $34;
    AsyncResult<int>? $36;
    AsyncResult<Object?>? $38;
    int? $41;
    int? $40;
    AsyncResult<int>? $42;
    AsyncResult<Object?>? $44;
    int? $47;
    List<Object?>? $46;
    AsyncResult<List<Object?>>? $48;
    AsyncResult<Object?>? $50;
    int? $53;
    String? $52;
    AsyncResult<String>? $54;
    AsyncResult<Object?>? $56;
    int? $59;
    String? $58;
    AsyncResult<String>? $60;
    AsyncResult<Object?>? $62;
    int? $65;
    String? $64;
    AsyncResult<String>? $66;
    AsyncResult<Object?>? $68;
    int? $71;
    String? $70;
    AsyncResult<String>? $72;
    AsyncResult<Object?>? $74;
    int? $77;
    String? $76;
    AsyncResult<String>? $78;
    AsyncResult<Object?>? $80;
    int? $83;
    List<Object?>? $82;
    AsyncResult<List<Object?>>? $84;
    AsyncResult<Object?>? $86;
    int? $89;
    List<int>? $88;
    AsyncResult<List<int>>? $90;
    AsyncResult<Object?>? $92;
    int? $95;
    int? $94;
    AsyncResult<int>? $96;
    AsyncResult<Object?>? $98;
    int? $101;
    int? $100;
    AsyncResult<int>? $102;
    AsyncResult<Object?>? $104;
    int? $107;
    List<Object?>? $106;
    AsyncResult<List<Object?>>? $108;
    AsyncResult<Object?>? $110;
    int? $113;
    List<int>? $112;
    AsyncResult<List<int>>? $114;
    AsyncResult<Object?>? $116;
    int? $119;
    Object? $118;
    AsyncResult<Object?>? $120;
    AsyncResult<Object?>? $122;
    int? $125;
    Object? $124;
    AsyncResult<Object?>? $126;
    AsyncResult<Object?>? $128;
    int? $131;
    Object? $130;
    AsyncResult<Object?>? $132;
    AsyncResult<Object?>? $134;
    int? $137;
    List<int>? $136;
    AsyncResult<List<int>>? $138;
    AsyncResult<Object?>? $140;
    int? $143;
    int? $142;
    AsyncResult<int>? $144;
    AsyncResult<Object?>? $146;
    int? $149;
    int? $148;
    AsyncResult<int>? $150;
    AsyncResult<Object?>? $152;
    int? $155;
    int? $154;
    AsyncResult<int>? $156;
    AsyncResult<Object?>? $158;
    int? $161;
    int? $160;
    AsyncResult<int>? $162;
    AsyncResult<Object?>? $164;
    int? $167;
    int? $166;
    AsyncResult<int>? $168;
    AsyncResult<Object?>? $170;
    int? $173;
    List<Object?>? $172;
    AsyncResult<List<Object?>>? $174;
    AsyncResult<Object?>? $176;
    int? $179;
    int? $178;
    AsyncResult<int>? $180;
    AsyncResult<Object?>? $182;
    int? $185;
    int? $184;
    AsyncResult<int>? $186;
    AsyncResult<Object?>? $188;
    int? $191;
    ({int v1, int v2})? $190;
    AsyncResult<({int v1, int v2})>? $192;
    AsyncResult<Object?>? $194;
    int? $197;
    int? $196;
    AsyncResult<int>? $198;
    AsyncResult<Object?>? $200;
    int? $203;
    int? $202;
    AsyncResult<int>? $204;
    AsyncResult<Object?>? $206;
    int? $209;
    String? $208;
    AsyncResult<String>? $210;
    AsyncResult<Object?>? $212;
    int? $215;
    String? $214;
    AsyncResult<String>? $216;
    AsyncResult<Object?>? $218;
    int? $221;
    int? $220;
    AsyncResult<int>? $222;
    AsyncResult<Object?>? $224;
    int? $227;
    List<int>? $226;
    AsyncResult<List<int>>? $228;
    AsyncResult<Object?>? $230;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // (v:AndPredicate AndPredicate)
            //  // (v:AndPredicate AndPredicate)
            //  // v:AndPredicate AndPredicate
            //  // v:AndPredicate AndPredicate
            $5 = state.pos;
            //  // AndPredicate
            $1 = -1;
            $6 = parseAndPredicate$Async(state);
            final $7 = $6!;
            $1 = 3;
            if ($7.isComplete) {
              break;
            }
            $7.onComplete = $2;
            return;
          case 3:
            $4 = $6!.value;
            $6 = null;
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // AndPredicate
            $1 = -1;
            $8 = fastParseAndPredicate$Async(state);
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
              state.pos = $5!;
              $1 = 2;
              break;
            }
            $3 = $4;
            $1 = 2;
            break;
          case 2:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:AnyCharacter AnyCharacter)
            //  // (v:AnyCharacter AnyCharacter)
            //  // v:AnyCharacter AnyCharacter
            //  // v:AnyCharacter AnyCharacter
            $11 = state.pos;
            //  // AnyCharacter
            $1 = -1;
            $12 = parseAnyCharacter$Async(state);
            final $13 = $12!;
            $1 = 6;
            if ($13.isComplete) {
              break;
            }
            $13.onComplete = $2;
            return;
          case 6:
            $10 = $12!.value;
            $12 = null;
            if (!state.ok) {
              $1 = 5;
              break;
            }
            //  // AnyCharacter
            $1 = -1;
            $14 = fastParseAnyCharacter$Async(state);
            $1 = 7;
            final $15 = $14!;
            if ($15.isComplete) {
              break;
            }
            $15.onComplete = $2;
            return;
          case 7:
            $14 = null;
            if (!state.ok) {
              state.pos = $11!;
              $1 = 5;
              break;
            }
            $3 = $10;
            $1 = 5;
            break;
          case 5:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Buffer Buffer)
            //  // (v:Buffer Buffer)
            //  // v:Buffer Buffer
            //  // v:Buffer Buffer
            $17 = state.pos;
            //  // Buffer
            $1 = -1;
            $18 = parseBuffer$Async(state);
            final $19 = $18!;
            $1 = 9;
            if ($19.isComplete) {
              break;
            }
            $19.onComplete = $2;
            return;
          case 9:
            $16 = $18!.value;
            $18 = null;
            if (!state.ok) {
              $1 = 8;
              break;
            }
            //  // Buffer
            $1 = -1;
            $20 = fastParseBuffer$Async(state);
            $1 = 10;
            final $21 = $20!;
            if ($21.isComplete) {
              break;
            }
            $21.onComplete = $2;
            return;
          case 10:
            $20 = null;
            if (!state.ok) {
              state.pos = $17!;
              $1 = 8;
              break;
            }
            $3 = $16;
            $1 = 8;
            break;
          case 8:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:CharacterClass CharacterClass)
            //  // (v:CharacterClass CharacterClass)
            //  // v:CharacterClass CharacterClass
            //  // v:CharacterClass CharacterClass
            $23 = state.pos;
            //  // CharacterClass
            $1 = -1;
            $24 = parseCharacterClass$Async(state);
            final $25 = $24!;
            $1 = 12;
            if ($25.isComplete) {
              break;
            }
            $25.onComplete = $2;
            return;
          case 12:
            $22 = $24!.value;
            $24 = null;
            if (!state.ok) {
              $1 = 11;
              break;
            }
            //  // CharacterClass
            $1 = -1;
            $26 = fastParseCharacterClass$Async(state);
            $1 = 13;
            final $27 = $26!;
            if ($27.isComplete) {
              break;
            }
            $27.onComplete = $2;
            return;
          case 13:
            $26 = null;
            if (!state.ok) {
              state.pos = $23!;
              $1 = 11;
              break;
            }
            $3 = $22;
            $1 = 11;
            break;
          case 11:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:CharacterClassChar32 CharacterClassChar32)
            //  // (v:CharacterClassChar32 CharacterClassChar32)
            //  // v:CharacterClassChar32 CharacterClassChar32
            //  // v:CharacterClassChar32 CharacterClassChar32
            $29 = state.pos;
            //  // CharacterClassChar32
            $1 = -1;
            $30 = parseCharacterClassChar32$Async(state);
            final $31 = $30!;
            $1 = 15;
            if ($31.isComplete) {
              break;
            }
            $31.onComplete = $2;
            return;
          case 15:
            $28 = $30!.value;
            $30 = null;
            if (!state.ok) {
              $1 = 14;
              break;
            }
            //  // CharacterClassChar32
            $1 = -1;
            $32 = fastParseCharacterClassChar32$Async(state);
            $1 = 16;
            final $33 = $32!;
            if ($33.isComplete) {
              break;
            }
            $33.onComplete = $2;
            return;
          case 16:
            $32 = null;
            if (!state.ok) {
              state.pos = $29!;
              $1 = 14;
              break;
            }
            $3 = $28;
            $1 = 14;
            break;
          case 14:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:CharacterClassRange32 CharacterClassRange32)
            //  // (v:CharacterClassRange32 CharacterClassRange32)
            //  // v:CharacterClassRange32 CharacterClassRange32
            //  // v:CharacterClassRange32 CharacterClassRange32
            $35 = state.pos;
            //  // CharacterClassRange32
            $1 = -1;
            $36 = parseCharacterClassRange32$Async(state);
            final $37 = $36!;
            $1 = 18;
            if ($37.isComplete) {
              break;
            }
            $37.onComplete = $2;
            return;
          case 18:
            $34 = $36!.value;
            $36 = null;
            if (!state.ok) {
              $1 = 17;
              break;
            }
            //  // CharacterClassRange32
            $1 = -1;
            $38 = fastParseCharacterClassRange32$Async(state);
            $1 = 19;
            final $39 = $38!;
            if ($39.isComplete) {
              break;
            }
            $39.onComplete = $2;
            return;
          case 19:
            $38 = null;
            if (!state.ok) {
              state.pos = $35!;
              $1 = 17;
              break;
            }
            $3 = $34;
            $1 = 17;
            break;
          case 17:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:ErrorHandler ErrorHandler)
            //  // (v:ErrorHandler ErrorHandler)
            //  // v:ErrorHandler ErrorHandler
            //  // v:ErrorHandler ErrorHandler
            $41 = state.pos;
            //  // ErrorHandler
            $1 = -1;
            $42 = parseErrorHandler$Async(state);
            final $43 = $42!;
            $1 = 21;
            if ($43.isComplete) {
              break;
            }
            $43.onComplete = $2;
            return;
          case 21:
            $40 = $42!.value;
            $42 = null;
            if (!state.ok) {
              $1 = 20;
              break;
            }
            //  // ErrorHandler
            $1 = -1;
            $44 = fastParseErrorHandler$Async(state);
            $1 = 22;
            final $45 = $44!;
            if ($45.isComplete) {
              break;
            }
            $45.onComplete = $2;
            return;
          case 22:
            $44 = null;
            if (!state.ok) {
              state.pos = $41!;
              $1 = 20;
              break;
            }
            $3 = $40;
            $1 = 20;
            break;
          case 20:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Eof Eof)
            //  // (v:Eof Eof)
            //  // v:Eof Eof
            //  // v:Eof Eof
            $47 = state.pos;
            //  // Eof
            $1 = -1;
            $48 = parseEof$Async(state);
            final $49 = $48!;
            $1 = 24;
            if ($49.isComplete) {
              break;
            }
            $49.onComplete = $2;
            return;
          case 24:
            $46 = $48!.value;
            $48 = null;
            if (!state.ok) {
              $1 = 23;
              break;
            }
            //  // Eof
            $1 = -1;
            $50 = fastParseEof$Async(state);
            $1 = 25;
            final $51 = $50!;
            if ($51.isComplete) {
              break;
            }
            $51.onComplete = $2;
            return;
          case 25:
            $50 = null;
            if (!state.ok) {
              state.pos = $47!;
              $1 = 23;
              break;
            }
            $3 = $46;
            $1 = 23;
            break;
          case 23:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Literal0 Literal0)
            //  // (v:Literal0 Literal0)
            //  // v:Literal0 Literal0
            //  // v:Literal0 Literal0
            $53 = state.pos;
            //  // Literal0
            $1 = -1;
            $54 = parseLiteral0$Async(state);
            final $55 = $54!;
            $1 = 27;
            if ($55.isComplete) {
              break;
            }
            $55.onComplete = $2;
            return;
          case 27:
            $52 = $54!.value;
            $54 = null;
            if (!state.ok) {
              $1 = 26;
              break;
            }
            //  // Literal0
            $1 = -1;
            $56 = fastParseLiteral0$Async(state);
            $1 = 28;
            final $57 = $56!;
            if ($57.isComplete) {
              break;
            }
            $57.onComplete = $2;
            return;
          case 28:
            $56 = null;
            if (!state.ok) {
              state.pos = $53!;
              $1 = 26;
              break;
            }
            $3 = $52;
            $1 = 26;
            break;
          case 26:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Literal1 Literal1)
            //  // (v:Literal1 Literal1)
            //  // v:Literal1 Literal1
            //  // v:Literal1 Literal1
            $59 = state.pos;
            //  // Literal1
            $1 = -1;
            $60 = parseLiteral1$Async(state);
            final $61 = $60!;
            $1 = 30;
            if ($61.isComplete) {
              break;
            }
            $61.onComplete = $2;
            return;
          case 30:
            $58 = $60!.value;
            $60 = null;
            if (!state.ok) {
              $1 = 29;
              break;
            }
            //  // Literal1
            $1 = -1;
            $62 = fastParseLiteral1$Async(state);
            $1 = 31;
            final $63 = $62!;
            if ($63.isComplete) {
              break;
            }
            $63.onComplete = $2;
            return;
          case 31:
            $62 = null;
            if (!state.ok) {
              state.pos = $59!;
              $1 = 29;
              break;
            }
            $3 = $58;
            $1 = 29;
            break;
          case 29:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Literal2 Literal2)
            //  // (v:Literal2 Literal2)
            //  // v:Literal2 Literal2
            //  // v:Literal2 Literal2
            $65 = state.pos;
            //  // Literal2
            $1 = -1;
            $66 = parseLiteral2$Async(state);
            final $67 = $66!;
            $1 = 33;
            if ($67.isComplete) {
              break;
            }
            $67.onComplete = $2;
            return;
          case 33:
            $64 = $66!.value;
            $66 = null;
            if (!state.ok) {
              $1 = 32;
              break;
            }
            //  // Literal2
            $1 = -1;
            $68 = fastParseLiteral2$Async(state);
            $1 = 34;
            final $69 = $68!;
            if ($69.isComplete) {
              break;
            }
            $69.onComplete = $2;
            return;
          case 34:
            $68 = null;
            if (!state.ok) {
              state.pos = $65!;
              $1 = 32;
              break;
            }
            $3 = $64;
            $1 = 32;
            break;
          case 32:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Literals Literals)
            //  // (v:Literals Literals)
            //  // v:Literals Literals
            //  // v:Literals Literals
            $71 = state.pos;
            //  // Literals
            $1 = -1;
            $72 = parseLiterals$Async(state);
            final $73 = $72!;
            $1 = 36;
            if ($73.isComplete) {
              break;
            }
            $73.onComplete = $2;
            return;
          case 36:
            $70 = $72!.value;
            $72 = null;
            if (!state.ok) {
              $1 = 35;
              break;
            }
            //  // Literals
            $1 = -1;
            $74 = fastParseLiterals$Async(state);
            $1 = 37;
            final $75 = $74!;
            if ($75.isComplete) {
              break;
            }
            $75.onComplete = $2;
            return;
          case 37:
            $74 = null;
            if (!state.ok) {
              state.pos = $71!;
              $1 = 35;
              break;
            }
            $3 = $70;
            $1 = 35;
            break;
          case 35:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:MatchString MatchString)
            //  // (v:MatchString MatchString)
            //  // v:MatchString MatchString
            //  // v:MatchString MatchString
            $77 = state.pos;
            //  // MatchString
            $1 = -1;
            $78 = parseMatchString$Async(state);
            final $79 = $78!;
            $1 = 39;
            if ($79.isComplete) {
              break;
            }
            $79.onComplete = $2;
            return;
          case 39:
            $76 = $78!.value;
            $78 = null;
            if (!state.ok) {
              $1 = 38;
              break;
            }
            //  // MatchString
            $1 = -1;
            $80 = fastParseMatchString$Async(state);
            $1 = 40;
            final $81 = $80!;
            if ($81.isComplete) {
              break;
            }
            $81.onComplete = $2;
            return;
          case 40:
            $80 = null;
            if (!state.ok) {
              state.pos = $77!;
              $1 = 38;
              break;
            }
            $3 = $76;
            $1 = 38;
            break;
          case 38:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:NotPredicate NotPredicate)
            //  // (v:NotPredicate NotPredicate)
            //  // v:NotPredicate NotPredicate
            //  // v:NotPredicate NotPredicate
            $83 = state.pos;
            //  // NotPredicate
            $1 = -1;
            $84 = parseNotPredicate$Async(state);
            final $85 = $84!;
            $1 = 42;
            if ($85.isComplete) {
              break;
            }
            $85.onComplete = $2;
            return;
          case 42:
            $82 = $84!.value;
            $84 = null;
            if (!state.ok) {
              $1 = 41;
              break;
            }
            //  // NotPredicate
            $1 = -1;
            $86 = fastParseNotPredicate$Async(state);
            $1 = 43;
            final $87 = $86!;
            if ($87.isComplete) {
              break;
            }
            $87.onComplete = $2;
            return;
          case 43:
            $86 = null;
            if (!state.ok) {
              state.pos = $83!;
              $1 = 41;
              break;
            }
            $3 = $82;
            $1 = 41;
            break;
          case 41:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:OneOrMore OneOrMore)
            //  // (v:OneOrMore OneOrMore)
            //  // v:OneOrMore OneOrMore
            //  // v:OneOrMore OneOrMore
            $89 = state.pos;
            //  // OneOrMore
            $1 = -1;
            $90 = parseOneOrMore$Async(state);
            final $91 = $90!;
            $1 = 45;
            if ($91.isComplete) {
              break;
            }
            $91.onComplete = $2;
            return;
          case 45:
            $88 = $90!.value;
            $90 = null;
            if (!state.ok) {
              $1 = 44;
              break;
            }
            //  // OneOrMore
            $1 = -1;
            $92 = fastParseOneOrMore$Async(state);
            $1 = 46;
            final $93 = $92!;
            if ($93.isComplete) {
              break;
            }
            $93.onComplete = $2;
            return;
          case 46:
            $92 = null;
            if (!state.ok) {
              state.pos = $89!;
              $1 = 44;
              break;
            }
            $3 = $88;
            $1 = 44;
            break;
          case 44:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:OrderedChoice2 OrderedChoice2)
            //  // (v:OrderedChoice2 OrderedChoice2)
            //  // v:OrderedChoice2 OrderedChoice2
            //  // v:OrderedChoice2 OrderedChoice2
            $95 = state.pos;
            //  // OrderedChoice2
            $1 = -1;
            $96 = parseOrderedChoice2$Async(state);
            final $97 = $96!;
            $1 = 48;
            if ($97.isComplete) {
              break;
            }
            $97.onComplete = $2;
            return;
          case 48:
            $94 = $96!.value;
            $96 = null;
            if (!state.ok) {
              $1 = 47;
              break;
            }
            //  // OrderedChoice2
            $1 = -1;
            $98 = fastParseOrderedChoice2$Async(state);
            $1 = 49;
            final $99 = $98!;
            if ($99.isComplete) {
              break;
            }
            $99.onComplete = $2;
            return;
          case 49:
            $98 = null;
            if (!state.ok) {
              state.pos = $95!;
              $1 = 47;
              break;
            }
            $3 = $94;
            $1 = 47;
            break;
          case 47:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:OrderedChoice3 OrderedChoice3)
            //  // (v:OrderedChoice3 OrderedChoice3)
            //  // v:OrderedChoice3 OrderedChoice3
            //  // v:OrderedChoice3 OrderedChoice3
            $101 = state.pos;
            //  // OrderedChoice3
            $1 = -1;
            $102 = parseOrderedChoice3$Async(state);
            final $103 = $102!;
            $1 = 51;
            if ($103.isComplete) {
              break;
            }
            $103.onComplete = $2;
            return;
          case 51:
            $100 = $102!.value;
            $102 = null;
            if (!state.ok) {
              $1 = 50;
              break;
            }
            //  // OrderedChoice3
            $1 = -1;
            $104 = fastParseOrderedChoice3$Async(state);
            $1 = 52;
            final $105 = $104!;
            if ($105.isComplete) {
              break;
            }
            $105.onComplete = $2;
            return;
          case 52:
            $104 = null;
            if (!state.ok) {
              state.pos = $101!;
              $1 = 50;
              break;
            }
            $3 = $100;
            $1 = 50;
            break;
          case 50:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Optional Optional)
            //  // (v:Optional Optional)
            //  // v:Optional Optional
            //  // v:Optional Optional
            $107 = state.pos;
            //  // Optional
            $1 = -1;
            $108 = parseOptional$Async(state);
            final $109 = $108!;
            $1 = 54;
            if ($109.isComplete) {
              break;
            }
            $109.onComplete = $2;
            return;
          case 54:
            $106 = $108!.value;
            $108 = null;
            if (!state.ok) {
              $1 = 53;
              break;
            }
            //  // Optional
            $1 = -1;
            $110 = fastParseOptional$Async(state);
            $1 = 55;
            final $111 = $110!;
            if ($111.isComplete) {
              break;
            }
            $111.onComplete = $2;
            return;
          case 55:
            $110 = null;
            if (!state.ok) {
              state.pos = $107!;
              $1 = 53;
              break;
            }
            $3 = $106;
            $1 = 53;
            break;
          case 53:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:RepetitionMax RepetitionMax)
            //  // (v:RepetitionMax RepetitionMax)
            //  // v:RepetitionMax RepetitionMax
            //  // v:RepetitionMax RepetitionMax
            $113 = state.pos;
            //  // RepetitionMax
            $1 = -1;
            $114 = parseRepetitionMax$Async(state);
            final $115 = $114!;
            $1 = 57;
            if ($115.isComplete) {
              break;
            }
            $115.onComplete = $2;
            return;
          case 57:
            $112 = $114!.value;
            $114 = null;
            if (!state.ok) {
              $1 = 56;
              break;
            }
            //  // RepetitionMax
            $1 = -1;
            $116 = fastParseRepetitionMax$Async(state);
            $1 = 58;
            final $117 = $116!;
            if ($117.isComplete) {
              break;
            }
            $117.onComplete = $2;
            return;
          case 58:
            $116 = null;
            if (!state.ok) {
              state.pos = $113!;
              $1 = 56;
              break;
            }
            $3 = $112;
            $1 = 56;
            break;
          case 56:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:RepetitionMin RepetitionMin)
            //  // (v:RepetitionMin RepetitionMin)
            //  // v:RepetitionMin RepetitionMin
            //  // v:RepetitionMin RepetitionMin
            $119 = state.pos;
            //  // RepetitionMin
            $1 = -1;
            $120 = parseRepetitionMin$Async(state);
            final $121 = $120!;
            $1 = 60;
            if ($121.isComplete) {
              break;
            }
            $121.onComplete = $2;
            return;
          case 60:
            $118 = $120!.value;
            $120 = null;
            if (!state.ok) {
              $1 = 59;
              break;
            }
            //  // RepetitionMin
            $1 = -1;
            $122 = fastParseRepetitionMin$Async(state);
            $1 = 61;
            final $123 = $122!;
            if ($123.isComplete) {
              break;
            }
            $123.onComplete = $2;
            return;
          case 61:
            $122 = null;
            if (!state.ok) {
              state.pos = $119!;
              $1 = 59;
              break;
            }
            $3 = $118;
            $1 = 59;
            break;
          case 59:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:RepetitionMinMax RepetitionMinMax)
            //  // (v:RepetitionMinMax RepetitionMinMax)
            //  // v:RepetitionMinMax RepetitionMinMax
            //  // v:RepetitionMinMax RepetitionMinMax
            $125 = state.pos;
            //  // RepetitionMinMax
            $1 = -1;
            $126 = parseRepetitionMinMax$Async(state);
            final $127 = $126!;
            $1 = 63;
            if ($127.isComplete) {
              break;
            }
            $127.onComplete = $2;
            return;
          case 63:
            $124 = $126!.value;
            $126 = null;
            if (!state.ok) {
              $1 = 62;
              break;
            }
            //  // RepetitionMinMax
            $1 = -1;
            $128 = fastParseRepetitionMinMax$Async(state);
            $1 = 64;
            final $129 = $128!;
            if ($129.isComplete) {
              break;
            }
            $129.onComplete = $2;
            return;
          case 64:
            $128 = null;
            if (!state.ok) {
              state.pos = $125!;
              $1 = 62;
              break;
            }
            $3 = $124;
            $1 = 62;
            break;
          case 62:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:RepetitionN RepetitionN)
            //  // (v:RepetitionN RepetitionN)
            //  // v:RepetitionN RepetitionN
            //  // v:RepetitionN RepetitionN
            $131 = state.pos;
            //  // RepetitionN
            $1 = -1;
            $132 = parseRepetitionN$Async(state);
            final $133 = $132!;
            $1 = 66;
            if ($133.isComplete) {
              break;
            }
            $133.onComplete = $2;
            return;
          case 66:
            $130 = $132!.value;
            $132 = null;
            if (!state.ok) {
              $1 = 65;
              break;
            }
            //  // RepetitionN
            $1 = -1;
            $134 = fastParseRepetitionN$Async(state);
            $1 = 67;
            final $135 = $134!;
            if ($135.isComplete) {
              break;
            }
            $135.onComplete = $2;
            return;
          case 67:
            $134 = null;
            if (!state.ok) {
              state.pos = $131!;
              $1 = 65;
              break;
            }
            $3 = $130;
            $1 = 65;
            break;
          case 65:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:SepBy SepBy)
            //  // (v:SepBy SepBy)
            //  // v:SepBy SepBy
            //  // v:SepBy SepBy
            $137 = state.pos;
            //  // SepBy
            $1 = -1;
            $138 = parseSepBy$Async(state);
            final $139 = $138!;
            $1 = 69;
            if ($139.isComplete) {
              break;
            }
            $139.onComplete = $2;
            return;
          case 69:
            $136 = $138!.value;
            $138 = null;
            if (!state.ok) {
              $1 = 68;
              break;
            }
            //  // SepBy
            $1 = -1;
            $140 = fastParseSepBy$Async(state);
            $1 = 70;
            final $141 = $140!;
            if ($141.isComplete) {
              break;
            }
            $141.onComplete = $2;
            return;
          case 70:
            $140 = null;
            if (!state.ok) {
              state.pos = $137!;
              $1 = 68;
              break;
            }
            $3 = $136;
            $1 = 68;
            break;
          case 68:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence1 Sequence1)
            //  // (v:Sequence1 Sequence1)
            //  // v:Sequence1 Sequence1
            //  // v:Sequence1 Sequence1
            $143 = state.pos;
            //  // Sequence1
            $1 = -1;
            $144 = parseSequence1$Async(state);
            final $145 = $144!;
            $1 = 72;
            if ($145.isComplete) {
              break;
            }
            $145.onComplete = $2;
            return;
          case 72:
            $142 = $144!.value;
            $144 = null;
            if (!state.ok) {
              $1 = 71;
              break;
            }
            //  // Sequence1
            $1 = -1;
            $146 = fastParseSequence1$Async(state);
            $1 = 73;
            final $147 = $146!;
            if ($147.isComplete) {
              break;
            }
            $147.onComplete = $2;
            return;
          case 73:
            $146 = null;
            if (!state.ok) {
              state.pos = $143!;
              $1 = 71;
              break;
            }
            $3 = $142;
            $1 = 71;
            break;
          case 71:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence1WithAction Sequence1WithAction)
            //  // (v:Sequence1WithAction Sequence1WithAction)
            //  // v:Sequence1WithAction Sequence1WithAction
            //  // v:Sequence1WithAction Sequence1WithAction
            $149 = state.pos;
            //  // Sequence1WithAction
            $1 = -1;
            $150 = parseSequence1WithAction$Async(state);
            final $151 = $150!;
            $1 = 75;
            if ($151.isComplete) {
              break;
            }
            $151.onComplete = $2;
            return;
          case 75:
            $148 = $150!.value;
            $150 = null;
            if (!state.ok) {
              $1 = 74;
              break;
            }
            //  // Sequence1WithAction
            $1 = -1;
            $152 = fastParseSequence1WithAction$Async(state);
            $1 = 76;
            final $153 = $152!;
            if ($153.isComplete) {
              break;
            }
            $153.onComplete = $2;
            return;
          case 76:
            $152 = null;
            if (!state.ok) {
              state.pos = $149!;
              $1 = 74;
              break;
            }
            $3 = $148;
            $1 = 74;
            break;
          case 74:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence1WithVariable Sequence1WithVariable)
            //  // (v:Sequence1WithVariable Sequence1WithVariable)
            //  // v:Sequence1WithVariable Sequence1WithVariable
            //  // v:Sequence1WithVariable Sequence1WithVariable
            $155 = state.pos;
            //  // Sequence1WithVariable
            $1 = -1;
            $156 = parseSequence1WithVariable$Async(state);
            final $157 = $156!;
            $1 = 78;
            if ($157.isComplete) {
              break;
            }
            $157.onComplete = $2;
            return;
          case 78:
            $154 = $156!.value;
            $156 = null;
            if (!state.ok) {
              $1 = 77;
              break;
            }
            //  // Sequence1WithVariable
            $1 = -1;
            $158 = fastParseSequence1WithVariable$Async(state);
            $1 = 79;
            final $159 = $158!;
            if ($159.isComplete) {
              break;
            }
            $159.onComplete = $2;
            return;
          case 79:
            $158 = null;
            if (!state.ok) {
              state.pos = $155!;
              $1 = 77;
              break;
            }
            $3 = $154;
            $1 = 77;
            break;
          case 77:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence1WithVariable Sequence1WithVariable)
            //  // (v:Sequence1WithVariable Sequence1WithVariable)
            //  // v:Sequence1WithVariable Sequence1WithVariable
            //  // v:Sequence1WithVariable Sequence1WithVariable
            $161 = state.pos;
            //  // Sequence1WithVariable
            $1 = -1;
            $162 = parseSequence1WithVariable$Async(state);
            final $163 = $162!;
            $1 = 81;
            if ($163.isComplete) {
              break;
            }
            $163.onComplete = $2;
            return;
          case 81:
            $160 = $162!.value;
            $162 = null;
            if (!state.ok) {
              $1 = 80;
              break;
            }
            //  // Sequence1WithVariable
            $1 = -1;
            $164 = fastParseSequence1WithVariable$Async(state);
            $1 = 82;
            final $165 = $164!;
            if ($165.isComplete) {
              break;
            }
            $165.onComplete = $2;
            return;
          case 82:
            $164 = null;
            if (!state.ok) {
              state.pos = $161!;
              $1 = 80;
              break;
            }
            $3 = $160;
            $1 = 80;
            break;
          case 80:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
            //  // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
            //  // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
            //  // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
            $167 = state.pos;
            //  // Sequence1WithVariableWithAction
            $1 = -1;
            $168 = parseSequence1WithVariableWithAction$Async(state);
            final $169 = $168!;
            $1 = 84;
            if ($169.isComplete) {
              break;
            }
            $169.onComplete = $2;
            return;
          case 84:
            $166 = $168!.value;
            $168 = null;
            if (!state.ok) {
              $1 = 83;
              break;
            }
            //  // Sequence1WithVariableWithAction
            $1 = -1;
            $170 = fastParseSequence1WithVariableWithAction$Async(state);
            $1 = 85;
            final $171 = $170!;
            if ($171.isComplete) {
              break;
            }
            $171.onComplete = $2;
            return;
          case 85:
            $170 = null;
            if (!state.ok) {
              state.pos = $167!;
              $1 = 83;
              break;
            }
            $3 = $166;
            $1 = 83;
            break;
          case 83:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2 Sequence2)
            //  // (v:Sequence2 Sequence2)
            //  // v:Sequence2 Sequence2
            //  // v:Sequence2 Sequence2
            $173 = state.pos;
            //  // Sequence2
            $1 = -1;
            $174 = parseSequence2$Async(state);
            final $175 = $174!;
            $1 = 87;
            if ($175.isComplete) {
              break;
            }
            $175.onComplete = $2;
            return;
          case 87:
            $172 = $174!.value;
            $174 = null;
            if (!state.ok) {
              $1 = 86;
              break;
            }
            //  // Sequence2
            $1 = -1;
            $176 = fastParseSequence2$Async(state);
            $1 = 88;
            final $177 = $176!;
            if ($177.isComplete) {
              break;
            }
            $177.onComplete = $2;
            return;
          case 88:
            $176 = null;
            if (!state.ok) {
              state.pos = $173!;
              $1 = 86;
              break;
            }
            $3 = $172;
            $1 = 86;
            break;
          case 86:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2WithAction Sequence2WithAction)
            //  // (v:Sequence2WithAction Sequence2WithAction)
            //  // v:Sequence2WithAction Sequence2WithAction
            //  // v:Sequence2WithAction Sequence2WithAction
            $179 = state.pos;
            //  // Sequence2WithAction
            $1 = -1;
            $180 = parseSequence2WithAction$Async(state);
            final $181 = $180!;
            $1 = 90;
            if ($181.isComplete) {
              break;
            }
            $181.onComplete = $2;
            return;
          case 90:
            $178 = $180!.value;
            $180 = null;
            if (!state.ok) {
              $1 = 89;
              break;
            }
            //  // Sequence2WithAction
            $1 = -1;
            $182 = fastParseSequence2WithAction$Async(state);
            $1 = 91;
            final $183 = $182!;
            if ($183.isComplete) {
              break;
            }
            $183.onComplete = $2;
            return;
          case 91:
            $182 = null;
            if (!state.ok) {
              state.pos = $179!;
              $1 = 89;
              break;
            }
            $3 = $178;
            $1 = 89;
            break;
          case 89:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2WithVariable Sequence2WithVariable)
            //  // (v:Sequence2WithVariable Sequence2WithVariable)
            //  // v:Sequence2WithVariable Sequence2WithVariable
            //  // v:Sequence2WithVariable Sequence2WithVariable
            $185 = state.pos;
            //  // Sequence2WithVariable
            $1 = -1;
            $186 = parseSequence2WithVariable$Async(state);
            final $187 = $186!;
            $1 = 93;
            if ($187.isComplete) {
              break;
            }
            $187.onComplete = $2;
            return;
          case 93:
            $184 = $186!.value;
            $186 = null;
            if (!state.ok) {
              $1 = 92;
              break;
            }
            //  // Sequence2WithVariable
            $1 = -1;
            $188 = fastParseSequence2WithVariable$Async(state);
            $1 = 94;
            final $189 = $188!;
            if ($189.isComplete) {
              break;
            }
            $189.onComplete = $2;
            return;
          case 94:
            $188 = null;
            if (!state.ok) {
              state.pos = $185!;
              $1 = 92;
              break;
            }
            $3 = $184;
            $1 = 92;
            break;
          case 92:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2WithVariables Sequence2WithVariables)
            //  // (v:Sequence2WithVariables Sequence2WithVariables)
            //  // v:Sequence2WithVariables Sequence2WithVariables
            //  // v:Sequence2WithVariables Sequence2WithVariables
            $191 = state.pos;
            //  // Sequence2WithVariables
            $1 = -1;
            $192 = parseSequence2WithVariables$Async(state);
            final $193 = $192!;
            $1 = 96;
            if ($193.isComplete) {
              break;
            }
            $193.onComplete = $2;
            return;
          case 96:
            $190 = $192!.value;
            $192 = null;
            if (!state.ok) {
              $1 = 95;
              break;
            }
            //  // Sequence2WithVariables
            $1 = -1;
            $194 = fastParseSequence2WithVariables$Async(state);
            $1 = 97;
            final $195 = $194!;
            if ($195.isComplete) {
              break;
            }
            $195.onComplete = $2;
            return;
          case 97:
            $194 = null;
            if (!state.ok) {
              state.pos = $191!;
              $1 = 95;
              break;
            }
            $3 = $190;
            $1 = 95;
            break;
          case 95:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
            //  // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
            //  // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
            //  // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
            $197 = state.pos;
            //  // Sequence2WithVariableWithAction
            $1 = -1;
            $198 = parseSequence2WithVariableWithAction$Async(state);
            final $199 = $198!;
            $1 = 99;
            if ($199.isComplete) {
              break;
            }
            $199.onComplete = $2;
            return;
          case 99:
            $196 = $198!.value;
            $198 = null;
            if (!state.ok) {
              $1 = 98;
              break;
            }
            //  // Sequence2WithVariableWithAction
            $1 = -1;
            $200 = fastParseSequence2WithVariableWithAction$Async(state);
            $1 = 100;
            final $201 = $200!;
            if ($201.isComplete) {
              break;
            }
            $201.onComplete = $2;
            return;
          case 100:
            $200 = null;
            if (!state.ok) {
              state.pos = $197!;
              $1 = 98;
              break;
            }
            $3 = $196;
            $1 = 98;
            break;
          case 98:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
            //  // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
            //  // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
            //  // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
            $203 = state.pos;
            //  // Sequence2WithVariablesWithAction
            $1 = -1;
            $204 = parseSequence2WithVariablesWithAction$Async(state);
            final $205 = $204!;
            $1 = 102;
            if ($205.isComplete) {
              break;
            }
            $205.onComplete = $2;
            return;
          case 102:
            $202 = $204!.value;
            $204 = null;
            if (!state.ok) {
              $1 = 101;
              break;
            }
            //  // Sequence2WithVariablesWithAction
            $1 = -1;
            $206 = fastParseSequence2WithVariablesWithAction$Async(state);
            $1 = 103;
            final $207 = $206!;
            if ($207.isComplete) {
              break;
            }
            $207.onComplete = $2;
            return;
          case 103:
            $206 = null;
            if (!state.ok) {
              state.pos = $203!;
              $1 = 101;
              break;
            }
            $3 = $202;
            $1 = 101;
            break;
          case 101:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Slice Slice)
            //  // (v:Slice Slice)
            //  // v:Slice Slice
            //  // v:Slice Slice
            $209 = state.pos;
            //  // Slice
            $1 = -1;
            $210 = parseSlice$Async(state);
            final $211 = $210!;
            $1 = 105;
            if ($211.isComplete) {
              break;
            }
            $211.onComplete = $2;
            return;
          case 105:
            $208 = $210!.value;
            $210 = null;
            if (!state.ok) {
              $1 = 104;
              break;
            }
            //  // Slice
            $1 = -1;
            $212 = fastParseSlice$Async(state);
            $1 = 106;
            final $213 = $212!;
            if ($213.isComplete) {
              break;
            }
            $213.onComplete = $2;
            return;
          case 106:
            $212 = null;
            if (!state.ok) {
              state.pos = $209!;
              $1 = 104;
              break;
            }
            $3 = $208;
            $1 = 104;
            break;
          case 104:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:StringChars StringChars)
            //  // (v:StringChars StringChars)
            //  // v:StringChars StringChars
            //  // v:StringChars StringChars
            $215 = state.pos;
            //  // StringChars
            $1 = -1;
            $216 = parseStringChars$Async(state);
            final $217 = $216!;
            $1 = 108;
            if ($217.isComplete) {
              break;
            }
            $217.onComplete = $2;
            return;
          case 108:
            $214 = $216!.value;
            $216 = null;
            if (!state.ok) {
              $1 = 107;
              break;
            }
            //  // StringChars
            $1 = -1;
            $218 = fastParseStringChars$Async(state);
            $1 = 109;
            final $219 = $218!;
            if ($219.isComplete) {
              break;
            }
            $219.onComplete = $2;
            return;
          case 109:
            $218 = null;
            if (!state.ok) {
              state.pos = $215!;
              $1 = 107;
              break;
            }
            $3 = $214;
            $1 = 107;
            break;
          case 107:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:Verify Verify)
            //  // (v:Verify Verify)
            //  // v:Verify Verify
            //  // v:Verify Verify
            $221 = state.pos;
            //  // Verify
            $1 = -1;
            $222 = parseVerify$Async(state);
            final $223 = $222!;
            $1 = 111;
            if ($223.isComplete) {
              break;
            }
            $223.onComplete = $2;
            return;
          case 111:
            $220 = $222!.value;
            $222 = null;
            if (!state.ok) {
              $1 = 110;
              break;
            }
            //  // Verify
            $1 = -1;
            $224 = fastParseVerify$Async(state);
            $1 = 112;
            final $225 = $224!;
            if ($225.isComplete) {
              break;
            }
            $225.onComplete = $2;
            return;
          case 112:
            $224 = null;
            if (!state.ok) {
              state.pos = $221!;
              $1 = 110;
              break;
            }
            $3 = $220;
            $1 = 110;
            break;
          case 110:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // (v:ZeroOrMore ZeroOrMore)
            //  // (v:ZeroOrMore ZeroOrMore)
            //  // v:ZeroOrMore ZeroOrMore
            //  // v:ZeroOrMore ZeroOrMore
            $227 = state.pos;
            //  // ZeroOrMore
            $1 = -1;
            $228 = parseZeroOrMore$Async(state);
            final $229 = $228!;
            $1 = 114;
            if ($229.isComplete) {
              break;
            }
            $229.onComplete = $2;
            return;
          case 114:
            $226 = $228!.value;
            $228 = null;
            if (!state.ok) {
              $1 = 113;
              break;
            }
            //  // ZeroOrMore
            $1 = -1;
            $230 = fastParseZeroOrMore$Async(state);
            $1 = 115;
            final $231 = $230!;
            if ($231.isComplete) {
              break;
            }
            $231.onComplete = $2;
            return;
          case 115:
            $230 = null;
            if (!state.ok) {
              state.pos = $227!;
              $1 = 113;
              break;
            }
            $3 = $226;
            $1 = 113;
            break;
          case 113:
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

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  String? parseStringChars(State<StringReader> state) {
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
          final $7 = state.input.readChar(state.pos);
          state.ok = $7 >= 48 && $7 <= 57;
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
        $6 = true;
      }
      state.ok = $6;
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
      matchChar(state, 92, const ErrorExpectedCharacter(92));
      if (!state.ok) {
        break;
      }
      String? $3;
      // [t] <String>{}
      matchChar(state, 116, const ErrorExpectedCharacter(116));
      if (state.ok) {
        String? $$;
        $$ = '\t';
        $3 = $$;
      }
      if (!state.ok) {
        state.pos = pos;
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
    String? $3;
    List<String>? $4;
    bool? $5;
    String? $6;
    int? $8;
    bool? $9;
    int? $11;
    String? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @stringChars($[0-9]+, [\\], [t] <String>{})
            //  // @stringChars($[0-9]+, [\\], [t] <String>{})
            $4 = [];
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // $[0-9]+
            //  // $[0-9]+
            //  // $[0-9]+
            $8 = state.pos;
            state.input.beginBuffering();
            //  // [0-9]+
            $9 = false;
            $1 = 2;
            break;
          case 2:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $10 = state.input;
            if (state.pos + 1 < $10.end || $10.isClosed) {
              state.ok = state.pos < $10.end;
              if (state.pos >= $10.start) {
                if (state.ok) {
                  final c = $10.data.runeAt(state.pos - $10.start);
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
                state.fail(ErrorBacktracking(state.pos));
              }
              $10.endBuffering(state.pos);
            } else {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 4;
              break;
            }
            $9 = true;
            $1 = 2;
            break;
          case 4:
            state.ok = $9!;
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $6 = input.data.substring($8! - start, state.pos - start);
            }
            state.input.endBuffering(state.pos);
            $5 = state.ok;
            if (state.ok) {
              $4!.add($6!);
            }
            $1 = 5;
            break;
          case 5:
            $11 = state.pos;
            state.input.beginBuffering();
            //  // [\\]
            //  // [\\]
            //  // [\\]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $12 = state.input;
            if (state.pos + 1 < $12.end || $12.isClosed) {
              matchCharAsync(state, 92, const ErrorExpectedCharacter(92));
              state.input.endBuffering(state.pos);
            } else {
              $12.sleep = true;
              $12.handle = $2;
              return;
            }
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = $5 == true ? 1 : 6;
              break;
            }
            //  // [t] <String>{}
            //  // [t] <String>{}
            //  // [t]
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $13 = state.input;
            if (state.pos + 1 < $13.end || $13.isClosed) {
              matchCharAsync(state, 116, const ErrorExpectedCharacter(116));
              state.input.endBuffering(state.pos);
            } else {
              $13.sleep = true;
              $13.handle = $2;
              return;
            }
            if (state.ok) {
              String? $$;
              $$ = '\t';
              $7 = $$;
            }
            if (!state.ok) {
              state.pos = $11!;
              state.input.endBuffering(state.pos);
              $1 = 6;
              break;
            }
            state.input.endBuffering(state.pos);
            $4!.add($7!);
            $1 = 1;
            break;
          case 6:
            $3 = ($4)!.join();
            $4 = null;
            state.ok = true;
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

  /// Verify =
  ///   @verify(.)
  ///   ;
  int? parseVerify(State<StringReader> state) {
    int? $0;
    // @verify(.)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    // .
    final $6 = state.input;
    if (state.pos < $6.length) {
      $0 = $6.readChar(state.pos);
      state.pos += $6.count;
      state.ok = true;
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
      $0 = null;
      state.pos = $4;
    }
    return $0;
  }

  /// Verify =
  ///   @verify(.)
  ///   ;
  AsyncResult<int> parseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $4;
    int? $5;
    int? $6;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @verify(.)
            //  // @verify(.)
            $4 = state.pos;
            $5 = state.failPos;
            $6 = state.errorCount;
            state.input.beginBuffering();
            //  // .
            //  // .
            //  // .
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            $3 = null;
            if (state.pos >= $7.start) {
              state.ok = state.pos < $7.end;
              if (state.ok) {
                final c = $7.data.runeAt(state.pos - $7.start);
                state.pos += c > 0xffff ? 2 : 1;
                $3 = c;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $7.endBuffering(state.pos);
            if (state.ok) {
              final pos = $4!;
              // ignore: unused_local_variable
              final $$ = $3!;
              ParseError? error;
              if ($$ != 0x30) {
                error = const ErrorMessage(0, 'error');
              }
              if (error != null) {
                final failPos = $5!;
                if (failPos <= pos) {
                  state.failPos = failPos;
                  state.errorCount = $6!;
                }
                state.failAt(pos, error);
              }
            }
            if (!state.ok) {
              $3 = null;
              state.pos = $4!;
            }
            state.input.endBuffering(state.pos);
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

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  List<int>? parseZeroOrMore(State<StringReader> state) {
    List<int>? $0;
    // [0]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      $3 = matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (!state.ok) {
        state.ok = true;
        break;
      }
      $2.add($3!);
    }
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
    List<int>? $3;
    List<int>? $4;
    int? $5;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [0]*
            //  // [0]*
            $4 = [];
            $1 = 1;
            break;
          case 1:
            state.input.beginBuffering();
            //  // [0]
            $5 = null;
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 < $6.end || $6.isClosed) {
              $5 = matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
              state.input.endBuffering(state.pos);
            } else {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            $4!.add($5!);
            $1 = 1;
            break;
          case 3:
            $3 = $4;
            $4 = null;
            state.ok = true;
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
      state.fail(ErrorBacktracking(state.pos));
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
      state.fail(ErrorBacktracking(state.pos));
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
      state.fail(ErrorBacktracking(state.pos));
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
      key = (ErrorBacktracking, error.position);
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
  int bufferLoad = 0;

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
    if (bufferLoad < this.data.length) {
      bufferLoad = this.data.length;
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
  static const message = 'Backtracking error to position {{0}}';

  final int position;

  const ErrorBacktracking(this.position);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return ErrorMessage(0, ErrorBacktracking.message, [position]);
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

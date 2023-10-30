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
    // [0] [1] [2]
    final $2 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (state.ok) {
      state.backtrack($1);
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 50;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
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
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.pos;
            state.input.beginBuffering();
            $5 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            state.input.endBuffering();
            if (state.ok) {
              state.backtrack($4);
            }
            final $20 = state.ok;
            if (!$20) {
              $2 = 6;
              break;
            }
            $2 = 7;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 7:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 7;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $21 = state.ok;
            if (!$21) {
              $2 = 8;
              break;
            }
            $2 = 9;
            break;
          case 8:
            $2 = 6;
            break;
          case 9:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $2 = 9;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $22 = state.ok;
            if (!$22) {
              $2 = 10;
              break;
            }
            $2 = 11;
            break;
          case 10:
            $2 = 8;
            break;
          case 11:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $2 = 11;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 10;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// AnyCharacter =
  ///   .
  ///   ;
  void fastParseAnyCharacter(State<String> state) {
    // .
    if (state.pos < state.input.length) {
      final c = state.input.runeAt(state.pos);
      state.pos += c > 0xffff ? 2 : 1;
      state.setOk(true);
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final c = $3.data.runeAt(state.pos - $3.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  void fastParseCharacterClass(State<String> state) {
    // [0-9]
    if (state.pos < state.input.length) {
      final $1 = state.input.codeUnitAt(state.pos);
      final $2 = $1 >= 48 && $1 <= 57;
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

  /// CharacterClass =
  ///   [0-9]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClass$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final $4 = $3.data.codeUnitAt(state.pos - $3.start);
              final $5 = $4 >= 48 && $4 <= 57;
              if ($5) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  void fastParseCharacterClassChar32(State<String> state) {
    // [\u{1f680}]
    if (state.pos < state.input.length) {
      final ok = state.input.runeAt(state.pos) == 128640;
      if (ok) {
        state.pos += 2;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<Object?> fastParseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.runeAt(state.pos - $3.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  void fastParseCharacterClassCharNegate(State<String> state) {
    // [^0]
    if (state.pos < state.input.length) {
      final $1 = state.input.runeAt(state.pos);
      final $2 = $1 != 48;
      if ($2) {
        state.pos += $1 > 0xffff ? 2 : 1;
        state.setOk(true);
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final $4 = $3.data.runeAt(state.pos - $3.start);
              final $5 = $4 != 48;
              if ($5) {
                state.pos += $4 > 0xffff ? 2 : 1;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  void fastParseCharacterClassCharNegate32(State<String> state) {
    // [^\u{1f680}]
    if (state.pos < state.input.length) {
      final $1 = state.input.runeAt(state.pos);
      final $2 = $1 != 128640;
      if ($2) {
        state.pos += $1 > 0xffff ? 2 : 1;
        state.setOk(true);
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final $4 = $3.data.runeAt(state.pos - $3.start);
              final $5 = $4 != 128640;
              if ($5) {
                state.pos += $4 > 0xffff ? 2 : 1;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  void fastParseCharacterClassRange32(State<String> state) {
    // [ -\u{1f680}]
    if (state.pos < state.input.length) {
      final $1 = state.input.runeAt(state.pos);
      final $2 = $1 >= 32 && $1 <= 128640;
      if ($2) {
        state.pos += $1 > 0xffff ? 2 : 1;
        state.setOk(true);
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final $4 = $3.data.runeAt(state.pos - $3.start);
              final $5 = $4 >= 32 && $4 <= 128640;
              if ($5) {
                state.pos += $4 > 0xffff ? 2 : 1;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    final $2 = state.pos;
    var $0 = true;
    final $1 = state.ignoreErrors;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 43;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $0 = false;
        state.ignoreErrors = false;
        state.setOk(true);
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 49;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
      }
    }
    if (!state.ok) {
      if (!$0) {
        state.isRecoverable = false;
      }
      state.backtrack($2);
    }
    state.ignoreErrors = $1;
    if (!state.ok && state.isRecoverable) {
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
  }

  /// Cut =
  ///     [0] [+] ↑ [1]
  ///   / [0]
  ///   ;
  AsyncResult<Object?> fastParseCut$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late bool $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.input.beginBuffering();
            $5 = state.pos;
            $4 = true;
            $3 = state.ignoreErrors;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $14 = state.ok;
            if (!$14) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              if (!$4) {
                state.isRecoverable = false;
              }
              state.backtrack($5);
            }
            state.ignoreErrors = $3;
            state.input.endBuffering();
            final $17 = !state.ok && state.isRecoverable;
            if (!$17) {
              $2 = 7;
              break;
            }
            $2 = 8;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 43;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $15 = state.ok;
            if (!$15) {
              $2 = 4;
              break;
            }
            $4 = false;
            state.ignoreErrors = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $16 = state.ok;
            if (!$16) {
              $2 = 5;
              break;
            }
            $2 = 6;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            $2 = 4;
            break;
          case 6:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 6;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 5;
            break;
          case 7:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 8:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 8;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 7;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Cut1 =
  ///     [0] ↑
  ///   / [1]
  ///   ;
  void fastParseCut1(State<String> state) {
    // [0] ↑
    final $2 = state.pos;
    var $0 = true;
    final $1 = state.ignoreErrors;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $0 = false;
      state.ignoreErrors = false;
      state.setOk(true);
    }
    if (!state.ok) {
      if (!$0) {
        state.isRecoverable = false;
      }
      state.backtrack($2);
    }
    state.ignoreErrors = $1;
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
  }

  /// Cut1 =
  ///     [0] ↑
  ///   / [1]
  ///   ;
  AsyncResult<Object?> fastParseCut1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late bool $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $5 = state.pos;
            $4 = true;
            $3 = state.ignoreErrors;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $4 = false;
              state.ignoreErrors = false;
              state.setOk(true);
              state.input.cut(state.pos);
            }
            if (!state.ok) {
              if (!$4) {
                state.isRecoverable = false;
              }
              state.backtrack($5);
            }
            state.ignoreErrors = $3;
            final $10 = !state.ok && state.isRecoverable;
            if (!$10) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CutWithInner =
  ///     [0] ↑ ([a] / [b]) [1]
  ///   / [0]
  ///   ;
  void fastParseCutWithInner(State<String> state) {
    // [0] ↑ ([a] / [b]) [1]
    final $2 = state.pos;
    var $0 = true;
    final $1 = state.ignoreErrors;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $0 = false;
      state.ignoreErrors = false;
      state.setOk(true);
      if (state.ok) {
        // [a]
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 97;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (!state.ok && state.isRecoverable) {
          // [b]
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 98;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 49;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
      }
    }
    if (!state.ok) {
      if (!$0) {
        state.isRecoverable = false;
      }
      state.backtrack($2);
    }
    state.ignoreErrors = $1;
    if (!state.ok && state.isRecoverable) {
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
  }

  /// CutWithInner =
  ///     [0] ↑ ([a] / [b]) [1]
  ///   / [0]
  ///   ;
  AsyncResult<Object?> fastParseCutWithInner$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late bool $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.input.beginBuffering();
            $5 = state.pos;
            $4 = true;
            $3 = state.ignoreErrors;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $16 = state.ok;
            if (!$16) {
              $2 = 2;
              break;
            }
            $4 = false;
            state.ignoreErrors = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $17 = state.ok;
            if (!$17) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 2:
            if (!state.ok) {
              if (!$4) {
                state.isRecoverable = false;
              }
              state.backtrack($5);
            }
            state.ignoreErrors = $3;
            state.input.endBuffering();
            final $20 = !state.ok && state.isRecoverable;
            if (!$20) {
              $2 = 9;
              break;
            }
            $2 = 10;
            break;
          case 3:
            $2 = 2;
            break;
          case 4:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 4;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 97;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = !state.ok && state.isRecoverable;
            if (!$18) {
              $2 = 5;
              break;
            }
            $2 = 6;
            break;
          case 5:
            final $19 = state.ok;
            if (!$19) {
              $2 = 7;
              break;
            }
            $2 = 8;
            break;
          case 6:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 6;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 98;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 5;
            break;
          case 7:
            $2 = 3;
            break;
          case 8:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 8;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 7;
            break;
          case 9:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 10:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $2 = 10;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos >= state.input.length) {
        state.setOk(true);
      } else {
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
    var $2 = 0;
    late int $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = state.ok;
            if (!$8) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos >= $6.end) {
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Expected =
  ///   @expected('digits', [0-9]{2,})
  ///   ;
  void fastParseExpected(State<String> state) {
    // @expected('digits', [0-9]{2,})
    final $1 = state.pos;
    final $2 = state.errorCount;
    final $3 = state.failPos;
    final $4 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0-9]{2,}
    final $7 = state.pos;
    var $8 = 0;
    final $6 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $8 >= 2;
      if (state.pos < state.input.length) {
        final $9 = state.input.codeUnitAt(state.pos);
        final $10 = $9 >= 48 && $9 <= 57;
        if ($10) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $8++;
    }
    state.ignoreErrors = $6;
    if ($8 >= 2) {
      state.setOk(true);
    } else {
      state.backtrack($7);
    }
    if (!state.ok && state.lastFailPos == $1) {
      if (state.lastFailPos == $3) {
        state.errorCount = $2;
      } else if (state.lastFailPos > $3) {
        state.errorCount = 0;
      }
      state.fail(const ErrorExpectedTags(['digits']));
    }
    if (state.lastFailPos < $4) {
      state.lastFailPos = $4;
    }
  }

  /// Expected =
  ///   @expected('digits', [0-9]{2,})
  ///   ;
  AsyncResult<Object?> fastParseExpected$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    late int $6;
    late bool $7;
    late int $8;
    late int $9;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.errorCount;
            $5 = state.failPos;
            $6 = state.lastFailPos;
            state.lastFailPos = -1;
            $8 = state.pos;
            $9 = 0;
            $7 = state.ignoreErrors;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $7;
            final $10 = $9 >= 2;
            if ($10) {
              state.setOk(true);
            } else {
              state.backtrack($8);
            }
            if (!state.ok && state.lastFailPos == $3) {
              if (state.lastFailPos == $5) {
                state.errorCount = $4;
              } else if (state.lastFailPos > $5) {
                state.errorCount = 0;
              }
              state.fail(const ErrorExpectedTags(['digits']));
            }
            if (state.lastFailPos < $6) {
              state.lastFailPos = $6;
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            state.ignoreErrors = $9 >= 2;
            $2 = 3;
            break;
          case 3:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $11.end) {
              final $12 = $11.data.codeUnitAt(state.pos - $11.start);
              final $13 = $12 >= 48 && $12 <= 57;
              if ($13) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $9++;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Indicate =
  ///   @indicate('error', [0] [1] [2])
  ///   ;
  void fastParseIndicate(State<String> state) {
    // @indicate('error', [0] [1] [2])
    final $4 = state.pos;
    final $1 = state.errorCount;
    final $2 = state.failPos;
    final $3 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0] [1] [2]
    final $5 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    if (!state.ok) {
      if (state.lastFailPos == $2) {
        state.errorCount = $1;
      } else if (state.lastFailPos > $2) {
        state.errorCount = 0;
      }
      final length = $4 - state.lastFailPos;
      state.failAt(state.lastFailPos, ErrorMessage(length, 'error'));
    }
    if (state.lastFailPos < $3) {
      state.lastFailPos = $3;
    }
  }

  /// Indicate =
  ///   @indicate('error', [0] [1] [2])
  ///   ;
  AsyncResult<Object?> fastParseIndicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    late int $6;
    late int $7;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $6 = state.pos;
            $3 = state.errorCount;
            $4 = state.failPos;
            $5 = state.lastFailPos;
            state.lastFailPos = -1;
            state.input.beginBuffering();
            $7 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $14 = state.ok;
            if (!$14) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($7);
            }
            state.input.endBuffering();
            if (!state.ok) {
              if (state.lastFailPos == $4) {
                state.errorCount = $3;
              } else if (state.lastFailPos > $4) {
                state.errorCount = 0;
              }
              final length = $6 - state.lastFailPos;
              state.failAt(state.lastFailPos, ErrorMessage(length, 'error'));
            }
            if (state.lastFailPos < $5) {
              state.lastFailPos = $5;
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $15 = state.ok;
            if (!$15) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// List =
  ///   @list([0], [,] v:[0])
  ///   ;
  void fastParseList(State<String> state) {
    // @list([0], [,] v:[0])
    final $1 = state.ignoreErrors;
    state.ignoreErrors = true;
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      while (true) {
        // [,] v:[0]
        final $4 = state.pos;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 44;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 48;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
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
    }
    state.ignoreErrors = $1;
    state.setOk(true);
  }

  /// List =
  ///   @list([0], [,] v:[0])
  ///   ;
  AsyncResult<Object?> fastParseList$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $6;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = state.ok;
            if (!$11) {
              $2 = 2;
              break;
            }
            $2 = 4;
            break;
          case 2:
            state.ignoreErrors = $3;
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            $2 = 2;
            break;
          case 4:
            $6 = state.pos;
            $2 = 5;
            break;
          case 5:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 44;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $13 = state.ok;
            if (!$13) {
              $2 = 6;
              break;
            }
            $2 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($6);
            }
            if (!state.ok) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 7:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $2 = 7;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 6;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// List1 =
  ///   @list1([0], [,] v:[0])
  ///   ;
  void fastParseList1(State<String> state) {
    // @list1([0], [,] v:[0])
    var $1 = false;
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $1 = true;
      final $2 = state.ignoreErrors;
      state.ignoreErrors = true;
      while (true) {
        // [,] v:[0]
        final $5 = state.pos;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 44;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 48;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
        if (!state.ok) {
          state.backtrack($5);
        }
        if (!state.ok) {
          break;
        }
      }
      state.ignoreErrors = $2;
    }
    state.setOk($1);
  }

  /// List1 =
  ///   @list1([0], [,] v:[0])
  ///   ;
  AsyncResult<Object?> fastParseList1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late bool $4;
    late int $7;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = false;
            $2 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $12 = state.ok;
            if (!$12) {
              $2 = 2;
              break;
            }
            $4 = true;
            $3 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 4;
            break;
          case 2:
            state.setOk($4);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            state.ignoreErrors = $3;
            $2 = 2;
            break;
          case 4:
            $7 = state.pos;
            $2 = 5;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 44;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $14 = state.ok;
            if (!$14) {
              $2 = 6;
              break;
            }
            $2 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($7);
            }
            if (!state.ok) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 7:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 7;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 6;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Literal0 =
  ///   ''
  ///   ;
  void fastParseLiteral0(State<String> state) {
    // ''
    state.setOk(true);
  }

  /// Literal0 =
  ///   ''
  ///   ;
  AsyncResult<Object?> fastParseLiteral0$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48;
    if ($2) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<Object?> fastParseLiteral1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            const $4 = '0';
            final $5 = state.pos < $3.end &&
                $3.data.codeUnitAt(state.pos - $3.start) == 48;
            if ($5) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$4]));
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Literal10 =
  ///   '0123456789'
  ///   ;
  void fastParseLiteral10(State<String> state) {
    // '0123456789'
    const $1 = '0123456789';
    final $2 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48 &&
        state.input.startsWith($1, state.pos);
    if ($2) {
      state.pos += 10;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
  }

  /// Literal10 =
  ///   '0123456789'
  ///   ;
  AsyncResult<Object?> fastParseLiteral10$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos + 9 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            final $4 = state.input;
            const $5 = '0123456789';
            final $7 = state.pos - $4.start;
            final $6 = state.pos < $4.end &&
                $4.data.codeUnitAt($7) == 48 &&
                $4.data.startsWith($5, $7);
            if ($6) {
              state.pos += 10;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$5]));
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    final $2 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48 &&
        state.input.codeUnitAt(state.pos + 1) == 49;
    if ($2) {
      state.pos += 2;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<Object?> fastParseLiteral2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos + 1 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            const $4 = '01';
            final $5 = state.pos + 1 < $3.end &&
                $3.data.codeUnitAt(state.pos - $3.start) == 48 &&
                $3.data.codeUnitAt(state.pos - $3.start + 1) == 49;
            if ($5) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$4]));
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Literals =
  ///     '0123'
  ///   / '012'
  ///   / '01'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'A'
  ///   ;
  void fastParseLiterals(State<String> state) {
    final $1 = state.pos;
    var $0 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 48:
          final ok = pos2 + 2 < input.length &&
              input.codeUnitAt(pos2) == 49 &&
              input.codeUnitAt(pos2 + 1) == 50 &&
              input.codeUnitAt(pos2 + 2) == 51;
          if (ok) {
            $0 = 4;
          } else {
            final ok = pos2 + 1 < input.length &&
                input.codeUnitAt(pos2) == 49 &&
                input.codeUnitAt(pos2 + 1) == 50;
            if (ok) {
              $0 = 3;
            } else {
              final ok = pos2 < input.length && input.codeUnitAt(pos2) == 49;
              if (ok) {
                $0 = 2;
              }
            }
          }
          break;
        case 97:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
          if (ok) {
            $0 = 2;
          } else {
            $0 = 1;
          }
          break;
        case 65:
          $0 = 1;
          break;
      }
    }
    if ($0 > 0) {
      state.pos += $0;
      state.setOk(true);
    } else {
      state.pos = $1;
      state
          .fail(const ErrorExpectedTags(['0123', '012', '01', 'ab', 'a', 'A']));
    }
  }

  /// Literals =
  ///     '0123'
  ///   / '012'
  ///   / '01'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'A'
  ///   ;
  AsyncResult<Object?> fastParseLiterals$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos + 3 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            const $4 = '0123';
            final $5 = state.pos + 3 < $3.end &&
                $3.data.codeUnitAt(state.pos - $3.start) == 48 &&
                $3.data.codeUnitAt(state.pos - $3.start + 1) == 49 &&
                $3.data.codeUnitAt(state.pos - $3.start + 2) == 50 &&
                $3.data.codeUnitAt(state.pos - $3.start + 3) == 51;
            if ($5) {
              state.pos += 4;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$4]));
            }
            final $27 = !state.ok && state.isRecoverable;
            if (!$27) {
              $2 = 1;
              break;
            }
            $2 = 2;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $7 = state.input;
            if (state.pos + 2 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 2;
              return;
            }
            const $8 = '012';
            final $9 = state.pos + 2 < $7.end &&
                $7.data.codeUnitAt(state.pos - $7.start) == 48 &&
                $7.data.codeUnitAt(state.pos - $7.start + 1) == 49 &&
                $7.data.codeUnitAt(state.pos - $7.start + 2) == 50;
            if ($9) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$8]));
            }
            final $28 = !state.ok && state.isRecoverable;
            if (!$28) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 3:
            $2 = 1;
            break;
          case 4:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $2 = 4;
              return;
            }
            const $12 = '01';
            final $13 = state.pos + 1 < $11.end &&
                $11.data.codeUnitAt(state.pos - $11.start) == 48 &&
                $11.data.codeUnitAt(state.pos - $11.start + 1) == 49;
            if ($13) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$12]));
            }
            final $29 = !state.ok && state.isRecoverable;
            if (!$29) {
              $2 = 5;
              break;
            }
            $2 = 6;
            break;
          case 5:
            $2 = 3;
            break;
          case 6:
            final $15 = state.input;
            if (state.pos + 1 >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $2 = 6;
              return;
            }
            const $16 = 'ab';
            final $17 = state.pos + 1 < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 97 &&
                $15.data.codeUnitAt(state.pos - $15.start + 1) == 98;
            if ($17) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$16]));
            }
            final $30 = !state.ok && state.isRecoverable;
            if (!$30) {
              $2 = 7;
              break;
            }
            $2 = 8;
            break;
          case 7:
            $2 = 5;
            break;
          case 8:
            final $19 = state.input;
            if (state.pos >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $2 = 8;
              return;
            }
            const $20 = 'a';
            final $21 = state.pos < $19.end &&
                $19.data.codeUnitAt(state.pos - $19.start) == 97;
            if ($21) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$20]));
            }
            final $31 = !state.ok && state.isRecoverable;
            if (!$31) {
              $2 = 9;
              break;
            }
            $2 = 10;
            break;
          case 9:
            $2 = 7;
            break;
          case 10:
            final $23 = state.input;
            if (state.pos >= $23.end && !$23.isClosed) {
              $23.sleep = true;
              $23.handle = $1;
              $2 = 10;
              return;
            }
            const $24 = 'A';
            final $25 = state.pos < $23.end &&
                $23.data.codeUnitAt(state.pos - $23.start) == 65;
            if ($25) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$24]));
            }
            $2 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
      state.setOk(true);
    } else {
      final ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == $1.codeUnitAt(0) &&
          state.input.startsWith($1, state.pos);
      if (ok) {
        state.pos += $1.length;
        state.setOk(true);
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
    var $2 = 0;
    late String $7;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $7 = text;
            final $9 = $7.isEmpty;
            if (!$9) {
              $2 = 1;
              break;
            }
            state.setOk(true);
            $2 = 2;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos + $7.length - 1 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            final $3 = $4.data;
            final $6 = state.pos - $4.start;
            final $5 =
                $3.codeUnitAt($6) == $7.codeUnitAt(0) && $3.startsWith($7, $6);
            if ($5) {
              state.pos += $7.length;
              state.setOk(true);
            } else {
              state.fail(ErrorExpectedTags([$7]));
            }
            $2 = 2;
            break;
          case 2:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Message =
  ///   @message('error', [0] [1] [2])
  ///   ;
  void fastParseMessage(State<String> state) {
    // @message('error', [0] [1] [2])
    final $1 = state.errorCount;
    final $2 = state.failPos;
    final $3 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0] [1] [2]
    final $4 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (!state.ok) {
      if (state.lastFailPos == $2) {
        state.errorCount = $1;
      } else if (state.lastFailPos > $2) {
        state.errorCount = 0;
      }
      state.failAt(state.lastFailPos, ErrorMessage(0, 'error'));
    }
    if (state.lastFailPos < $3) {
      state.lastFailPos = $3;
    }
  }

  /// Message =
  ///   @message('error', [0] [1] [2])
  ///   ;
  AsyncResult<Object?> fastParseMessage$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    late int $6;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.errorCount;
            $4 = state.failPos;
            $5 = state.lastFailPos;
            state.lastFailPos = -1;
            state.input.beginBuffering();
            $6 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $13 = state.ok;
            if (!$13) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            state.input.endBuffering();
            if (!state.ok) {
              if (state.lastFailPos == $4) {
                state.errorCount = $3;
              } else if (state.lastFailPos > $4) {
                state.errorCount = 0;
              }
              state.failAt(state.lastFailPos, ErrorMessage(0, 'error'));
            }
            if (state.lastFailPos < $5) {
              state.lastFailPos = $5;
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $14 = state.ok;
            if (!$14) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (state.ok) {
      final length = $1 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        -1 => const ErrorUnexpectedInput(-1),
        -2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($1);
    } else {
      state.setOk(true);
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.pos;
            state.input.beginBuffering();
            $5 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $16 = state.ok;
            if (!$16) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            state.input.endBuffering();
            if (state.ok) {
              final length = $4 - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                -1 => const ErrorUnexpectedInput(-1),
                -2 => const ErrorUnexpectedInput(-2),
                _ => ErrorUnexpectedInput(length)
              });
              state.backtrack($4);
            } else {
              state.setOk(true);
            }
            final $18 = state.ok;
            if (!$18) {
              $2 = 6;
              break;
            }
            $2 = 7;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $17 = state.ok;
            if (!$17) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 7:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 7;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $2 = 8;
              break;
            }
            $2 = 9;
            break;
          case 8:
            $2 = 6;
            break;
          case 9:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $2 = 9;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 8;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// NotPredicate2 =
  ///     !([0] [3] 'abc' 'foo') [0] [3] 'abc'
  ///   / [0] [3] [2]
  ///   ;
  void fastParseNotPredicate2(State<String> state) {
    // !([0] [3] 'abc' 'foo') [0] [3] 'abc'
    final $0 = state.pos;
    final $1 = state.pos;
    // [0] [3] 'abc' 'foo'
    final $2 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 51;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        const $3 = 'abc';
        final $4 = state.pos + 2 < state.input.length &&
            state.input.codeUnitAt(state.pos) == 97 &&
            state.input.codeUnitAt(state.pos + 1) == 98 &&
            state.input.codeUnitAt(state.pos + 2) == 99;
        if ($4) {
          state.pos += 3;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$3]));
        }
        if (state.ok) {
          const $5 = 'foo';
          final $6 = state.pos + 2 < state.input.length &&
              state.input.codeUnitAt(state.pos) == 102 &&
              state.input.codeUnitAt(state.pos + 1) == 111 &&
              state.input.codeUnitAt(state.pos + 2) == 111;
          if ($6) {
            state.pos += 3;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$5]));
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (state.ok) {
      final length = $1 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        -1 => const ErrorUnexpectedInput(-1),
        -2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($1);
    } else {
      state.setOk(true);
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 51;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          const $7 = 'abc';
          final $8 = state.pos + 2 < state.input.length &&
              state.input.codeUnitAt(state.pos) == 97 &&
              state.input.codeUnitAt(state.pos + 1) == 98 &&
              state.input.codeUnitAt(state.pos + 2) == 99;
          if ($8) {
            state.pos += 3;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$7]));
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($0);
    }
    if (!state.ok && state.isRecoverable) {
      // [0] [3] [2]
      final $9 = state.pos;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 51;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 50;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
      }
      if (!state.ok) {
        state.backtrack($9);
      }
    }
  }

  /// NotPredicate2 =
  ///     !([0] [3] 'abc' 'foo') [0] [3] 'abc'
  ///   / [0] [3] [2]
  ///   ;
  AsyncResult<Object?> fastParseNotPredicate2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $4;
    late int $5;
    late int $26;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.pos;
            state.input.beginBuffering();
            $5 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $33 = state.ok;
            if (!$33) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            state.input.endBuffering();
            if (state.ok) {
              final length = $4 - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                -1 => const ErrorUnexpectedInput(-1),
                -2 => const ErrorUnexpectedInput(-2),
                _ => ErrorUnexpectedInput(length)
              });
              state.backtrack($4);
            } else {
              state.setOk(true);
            }
            final $36 = state.ok;
            if (!$36) {
              $2 = 8;
              break;
            }
            $2 = 9;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $34 = state.ok;
            if (!$34) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos + 2 >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 5;
              return;
            }
            const $11 = 'abc';
            final $12 = state.pos + 2 < $10.end &&
                $10.data.codeUnitAt(state.pos - $10.start) == 97 &&
                $10.data.codeUnitAt(state.pos - $10.start + 1) == 98 &&
                $10.data.codeUnitAt(state.pos - $10.start + 2) == 99;
            if ($12) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$11]));
            }
            final $35 = state.ok;
            if (!$35) {
              $2 = 6;
              break;
            }
            $2 = 7;
            break;
          case 6:
            $2 = 4;
            break;
          case 7:
            final $14 = state.input;
            if (state.pos + 2 >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $2 = 7;
              return;
            }
            const $15 = 'foo';
            final $16 = state.pos + 2 < $14.end &&
                $14.data.codeUnitAt(state.pos - $14.start) == 102 &&
                $14.data.codeUnitAt(state.pos - $14.start + 1) == 111 &&
                $14.data.codeUnitAt(state.pos - $14.start + 2) == 111;
            if ($16) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$15]));
            }
            $2 = 6;
            break;
          case 8:
            if (!state.ok) {
              state.backtrack($3);
            }
            final $39 = !state.ok && state.isRecoverable;
            if (!$39) {
              $2 = 14;
              break;
            }
            $26 = state.pos;
            $2 = 15;
            break;
          case 9:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $2 = 9;
              return;
            }
            if (state.pos < $18.end) {
              final ok = $18.data.codeUnitAt(state.pos - $18.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $37 = state.ok;
            if (!$37) {
              $2 = 10;
              break;
            }
            $2 = 11;
            break;
          case 10:
            $2 = 8;
            break;
          case 11:
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $2 = 11;
              return;
            }
            if (state.pos < $20.end) {
              final ok = $20.data.codeUnitAt(state.pos - $20.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $38 = state.ok;
            if (!$38) {
              $2 = 12;
              break;
            }
            $2 = 13;
            break;
          case 12:
            $2 = 10;
            break;
          case 13:
            final $22 = state.input;
            if (state.pos + 2 >= $22.end && !$22.isClosed) {
              $22.sleep = true;
              $22.handle = $1;
              $2 = 13;
              return;
            }
            const $23 = 'abc';
            final $24 = state.pos + 2 < $22.end &&
                $22.data.codeUnitAt(state.pos - $22.start) == 97 &&
                $22.data.codeUnitAt(state.pos - $22.start + 1) == 98 &&
                $22.data.codeUnitAt(state.pos - $22.start + 2) == 99;
            if ($24) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$23]));
            }
            $2 = 12;
            break;
          case 14:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 15:
            final $27 = state.input;
            if (state.pos >= $27.end && !$27.isClosed) {
              $27.sleep = true;
              $27.handle = $1;
              $2 = 15;
              return;
            }
            if (state.pos < $27.end) {
              final ok = $27.data.codeUnitAt(state.pos - $27.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $40 = state.ok;
            if (!$40) {
              $2 = 16;
              break;
            }
            $2 = 17;
            break;
          case 16:
            if (!state.ok) {
              state.backtrack($26);
            }
            $2 = 14;
            break;
          case 17:
            final $29 = state.input;
            if (state.pos >= $29.end && !$29.isClosed) {
              $29.sleep = true;
              $29.handle = $1;
              $2 = 17;
              return;
            }
            if (state.pos < $29.end) {
              final ok = $29.data.codeUnitAt(state.pos - $29.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $41 = state.ok;
            if (!$41) {
              $2 = 18;
              break;
            }
            $2 = 19;
            break;
          case 18:
            $2 = 16;
            break;
          case 19:
            final $31 = state.input;
            if (state.pos >= $31.end && !$31.isClosed) {
              $31.sleep = true;
              $31.handle = $1;
              $2 = 19;
              return;
            }
            if (state.pos < $31.end) {
              final ok = $31.data.codeUnitAt(state.pos - $31.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 18;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c == 48);
        state.pos++,
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        $1 = true);
    if ($1) {
      state.setOk($1);
    } else {
      state.pos < state.input.length
          ? state.fail(const ErrorUnexpectedCharacter())
          : state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  AsyncResult<Object?> fastParseOneOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $7;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $7 = 0;
            $2 = 1;
            break;
          case 1:
            final $5 = state.input;
            var $8 = false;
            while (state.pos < $5.end) {
              final $3 = $5.data.codeUnitAt(state.pos - $5.start);
              final $4 = $3 == 48;
              if (!$4) {
                $8 = true;
                break;
              }
              state.pos++;
              $7++;
            }
            if (!$8 && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 1;
              return;
            }
            if ($7 != 0) {
              state.setOk(true);
            } else {
              $5.isClosed
                  ? state.fail(const ErrorUnexpectedEndOfInput())
                  : state.fail(const ErrorUnexpectedCharacter());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// OneOrMoreLiteral =
  ///   'abc'+
  ///   ;
  void fastParseOneOrMoreLiteral(State<String> state) {
    // 'abc'+
    var $2 = false;
    final $1 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $2;
      const $3 = 'abc';
      final $4 = state.pos + 2 < state.input.length &&
          state.input.codeUnitAt(state.pos) == 97 &&
          state.input.codeUnitAt(state.pos + 1) == 98 &&
          state.input.codeUnitAt(state.pos + 2) == 99;
      if ($4) {
        state.pos += 3;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$3]));
      }
      if (!state.ok) {
        break;
      }
      $2 = true;
    }
    state.ignoreErrors = $1;
    state.setOk($2);
  }

  /// OneOrMoreLiteral =
  ///   'abc'+
  ///   ;
  AsyncResult<Object?> fastParseOneOrMoreLiteral$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late bool $4;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = false;
            $3 = state.ignoreErrors;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            state.setOk($4);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            state.ignoreErrors = $4;
            $2 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos + 2 >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 3;
              return;
            }
            const $6 = 'abc';
            final $7 = state.pos + 2 < $5.end &&
                $5.data.codeUnitAt(state.pos - $5.start) == 97 &&
                $5.data.codeUnitAt(state.pos - $5.start + 1) == 98 &&
                $5.data.codeUnitAt(state.pos - $5.start + 2) == 99;
            if ($7) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$6]));
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $4 = true;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    final $1 = state.ignoreErrors;
    state.ignoreErrors = true;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    state.ignoreErrors = $1;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $2 = 0;
    late int $3;
    late bool $4;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.ignoreErrors = $4;
            if (!state.ok) {
              state.setOk(true);
            }
            final $9 = state.ok;
            if (!$9) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
  }

  /// OrderedChoice2 =
  ///     [0]
  ///   / [1]
  ///   ;
  AsyncResult<Object?> fastParseOrderedChoice2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.codeUnitAt(state.pos - $3.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $7 = !state.ok && state.isRecoverable;
            if (!$7) {
              $2 = 1;
              break;
            }
            $2 = 2;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 2;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 1;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok && state.isRecoverable) {
        // [2]
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.codeUnitAt(state.pos - $3.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $9 = !state.ok && state.isRecoverable;
            if (!$9) {
              $2 = 1;
              break;
            }
            $2 = 2;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 2;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $10 = !state.ok && state.isRecoverable;
            if (!$10) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 3:
            $2 = 1;
            break;
          case 4:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 4;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 3;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  void fastParseRepetitionMax(State<String> state) {
    // [\u{1f680}]{,3}
    var $2 = 0;
    final $1 = state.ignoreErrors;
    state.ignoreErrors = true;
    while ($2 < 3) {
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $2++;
    }
    state.ignoreErrors = $1;
    state.setOk(true);
  }

  /// RepetitionMax =
  ///   [\u{1f680}]{,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $4;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = 0;
            $3 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $7 = $4 < 3;
            if (!$7) {
              $2 = 1;
              break;
            }
            $2 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.runeAt(state.pos - $5.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $4++;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  void fastParseRepetitionMin(State<String> state) {
    // [\u{1f680}]{3,}
    final $2 = state.pos;
    var $3 = 0;
    final $1 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $3 >= 3;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $3++;
    }
    state.ignoreErrors = $1;
    if ($3 >= 3) {
      state.setOk(true);
    } else {
      state.backtrack($2);
    }
  }

  /// RepetitionMin =
  ///   [\u{1f680}]{3,}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMin$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = state.pos;
            $5 = 0;
            $3 = state.ignoreErrors;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            final $6 = $5 >= 3;
            if ($6) {
              state.setOk(true);
            } else {
              state.backtrack($4);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            state.ignoreErrors = $5 >= 3;
            $2 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.runeAt(state.pos - $7.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $5++;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  void fastParseRepetitionMinMax(State<String> state) {
    // [\u{1f680}]{2,3}
    final $2 = state.pos;
    var $3 = 0;
    final $1 = state.ignoreErrors;
    while ($3 < 3) {
      state.ignoreErrors = $3 >= 2;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $3++;
    }
    state.ignoreErrors = $1;
    if ($3 >= 2) {
      state.setOk(true);
    } else {
      state.backtrack($2);
    }
  }

  /// RepetitionMinMax =
  ///   [\u{1f680}]{2,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionMinMax$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = state.pos;
            $5 = 0;
            $3 = state.ignoreErrors;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            if ($5 >= 2) {
              state.setOk(true);
            } else {
              state.backtrack($4);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $8 = $5 < 3;
            if (!$8) {
              $2 = 1;
              break;
            }
            state.ignoreErrors = $5 >= 2;
            $2 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.runeAt(state.pos - $6.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $5++;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $2++;
    }
    if ($2 == 3) {
      state.setOk(true);
    } else {
      state.backtrack($1);
    }
  }

  /// RepetitionN =
  ///   [\u{1f680}]{3,3}
  ///   ;
  AsyncResult<Object?> fastParseRepetitionN$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $4;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = 0;
            $2 = 2;
            break;
          case 1:
            if ($4 == 3) {
              state.setOk(true);
            } else {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $7 = $4 < 3;
            if (!$7) {
              $2 = 1;
              break;
            }
            $2 = 3;
            break;
          case 3:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.runeAt(state.pos - $5.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $4++;
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  void fastParseSequence1(State<String> state) {
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.codeUnitAt(state.pos - $3.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence1WithAction =
  ///   [0] <int>{}
  ///   ;
  void fastParseSequence1WithAction(State<String> state) {
    // [0] <int>{}
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
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
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.codeUnitAt(state.pos - $3.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              $$ = 0x30;
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  void fastParseSequence1WithVariable(State<String> state) {
    // v:[0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final ok = $3.data.codeUnitAt(state.pos - $3.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  void fastParseSequence1WithVariableWithAction(State<String> state) {
    // v:[0] <int>{}
    int? $0;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      // ignore: unused_local_variable
      int? $$;
      final v = $0!;
      $$ = v;
    }
  }

  /// Sequence1WithVariableWithAction =
  ///   v:[0] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence1WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    int? $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $3 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              final v = $3!;
              $$ = v;
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $2 = 0;
    late int $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = state.ok;
            if (!$8) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $2 = 0;
    late int $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = state.ok;
            if (!$8) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              $$ = 0x30;
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $2 = 0;
    late int $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = state.ok;
            if (!$8) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  void fastParseSequence2WithVariableWithAction(State<String> state) {
    // v:[0] [1] <int>{}
    final $1 = state.pos;
    int? $0;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v = $0!;
        $$ = v;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
  }

  /// Sequence2WithVariableWithAction =
  ///   v:[0] [1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariableWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $4;
    int? $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $4 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $3 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $9 = state.ok;
            if (!$9) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($4);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              final v = $3!;
              $$ = v;
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $2 = 0;
    late int $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = state.ok;
            if (!$8) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  void fastParseSequence2WithVariablesWithAction(State<String> state) {
    // v1:[0] v2:[1] <int>{}
    final $2 = state.pos;
    int? $0;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $1;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $1 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        // ignore: unused_local_variable
        int? $$;
        final v1 = $0!;
        final v2 = $1!;
        $$ = v1 + v2;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
  }

  /// Sequence2WithVariablesWithAction =
  ///   v1:[0] v2:[1] <int>{}
  ///   ;
  AsyncResult<Object?> fastParseSequence2WithVariablesWithAction$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $5;
    int? $3;
    int? $4;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $5 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $3 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $10 = state.ok;
            if (!$10) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              int? $$;
              final v1 = $3!;
              final v2 = $4!;
              $$ = v1 + v2;
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    if (!state.ok && state.isRecoverable) {
      // $([0] [1])
      // [0] [1]
      final $5 = state.pos;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
    var $2 = 0;
    late int $3;
    late int $10;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.input.beginBuffering();
            $3 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $15 = state.ok;
            if (!$15) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($3);
            }
            state.input.endBuffering();
            final $17 = !state.ok && state.isRecoverable;
            if (!$17) {
              $2 = 6;
              break;
            }
            state.input.beginBuffering();
            $10 = state.pos;
            $2 = 7;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $16 = state.ok;
            if (!$16) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          case 6:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 7:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $2 = 7;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $2 = 8;
              break;
            }
            $2 = 9;
            break;
          case 8:
            if (!state.ok) {
              state.backtrack($10);
            }
            state.input.endBuffering();
            $2 = 6;
            break;
          case 9:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $2 = 9;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 8;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  void fastParseStringChars(State<String> state) {
    // @stringChars($[0-9]+, [\\], [t] <String>{})
    while (true) {
      // $[0-9]+
      var $3 = false;
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c >= 48 && c <= 57);
          state.pos++,
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          $3 = true);
      if ($3) {
        state.setOk($3);
      } else {
        state.pos < state.input.length
            ? state.fail(const ErrorUnexpectedCharacter())
            : state.fail(const ErrorUnexpectedEndOfInput());
      }
      final $6 = state.pos;
      // [\\]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 92;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      // [t] <String>{}
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 116;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        // ignore: unused_local_variable
        String? $$;
        $$ = '\t';
      }
      if (!state.ok) {
        state.backtrack($6);
        break;
      }
    }
    state.setOk(true);
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  AsyncResult<Object?> fastParseStringChars$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late int $8;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.input.beginBuffering();
            $8 = 0;
            $2 = 2;
            break;
          case 1:
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $6 = state.input;
            var $9 = false;
            while (state.pos < $6.end) {
              final $4 = $6.data.codeUnitAt(state.pos - $6.start);
              final $5 = $4 >= 48 && $4 <= 57;
              if (!$5) {
                $9 = true;
                break;
              }
              state.pos++;
              $8++;
            }
            if (!$9 && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 2;
              return;
            }
            if ($8 != 0) {
              state.setOk(true);
            } else {
              $6.isClosed
                  ? state.fail(const ErrorUnexpectedEndOfInput())
                  : state.fail(const ErrorUnexpectedCharacter());
            }
            state.input.endBuffering();
            $3 = state.pos;
            $2 = 3;
            break;
          case 3:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 92;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $2 = 4;
            break;
          case 4:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 4;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 116;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              // ignore: unused_local_variable
              String? $$;
              $$ = '\t';
            }
            if (!state.ok) {
              state.backtrack($3);
              $2 = 1;
              break;
            }
            $2 = 0;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Tag =
  ///   @tag('FOR', $([Ff] [Oo] [Rr]))
  ///   ;
  void fastParseTag(State<String> state) {
    // @tag('FOR', $([Ff] [Oo] [Rr]))
    final $1 = state.pos;
    final $2 = state.ignoreErrors;
    state.ignoreErrors = true;
    // $([Ff] [Oo] [Rr])
    // [Ff] [Oo] [Rr]
    final $5 = state.pos;
    if (state.pos < state.input.length) {
      final $6 = state.input.codeUnitAt(state.pos);
      final $7 = $6 == 70 || $6 == 102;
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
      if (state.pos < state.input.length) {
        final $8 = state.input.codeUnitAt(state.pos);
        final $9 = $8 == 79 || $8 == 111;
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
        if (state.pos < state.input.length) {
          final $10 = state.input.codeUnitAt(state.pos);
          final $11 = $10 == 82 || $10 == 114;
          if ($11) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    state.ignoreErrors = $2;
    if (!state.ok) {
      state.failAt($1, const ErrorExpectedTags(['FOR']));
    }
  }

  /// Tag =
  ///   @tag('FOR', $([Ff] [Oo] [Rr]))
  ///   ;
  AsyncResult<Object?> fastParseTag$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $3;
    late bool $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.pos;
            $4 = state.ignoreErrors;
            state.ignoreErrors = true;
            state.input.beginBuffering();
            $5 = state.pos;
            $2 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final $7 = $6.data.codeUnitAt(state.pos - $6.start);
              final $8 = $7 == 70 || $7 == 102;
              if ($8) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $2 = 2;
              break;
            }
            $2 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            state.input.endBuffering();
            state.ignoreErrors = $4;
            if (!state.ok) {
              state.failAt($3, const ErrorExpectedTags(['FOR']));
            }
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 3:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 3;
              return;
            }
            if (state.pos < $10.end) {
              final $11 = $10.data.codeUnitAt(state.pos - $10.start);
              final $12 = $11 == 79 || $11 == 111;
              if ($12) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            $2 = 2;
            break;
          case 5:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $2 = 5;
              return;
            }
            if (state.pos < $14.end) {
              final $15 = $14.data.codeUnitAt(state.pos - $14.start);
              final $16 = $15 == 82 || $15 == 114;
              if ($16) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Verify =
  ///     'abc'
  ///   / [5] [6] [7]
  ///   / Verify_
  ///   ;
  void fastParseVerify(State<String> state) {
    // 'abc'
    const $1 = 'abc';
    final $2 = state.pos + 2 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 97 &&
        state.input.codeUnitAt(state.pos + 1) == 98 &&
        state.input.codeUnitAt(state.pos + 2) == 99;
    if ($2) {
      state.pos += 3;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$1]));
    }
    if (!state.ok && state.isRecoverable) {
      // [5] [6] [7]
      final $3 = state.pos;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 53;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 54;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 55;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
      }
      if (!state.ok) {
        state.backtrack($3);
      }
      if (!state.ok && state.isRecoverable) {
        // Verify_
        // @inline Verify_ = @verify('error', [0-1]) ;
        // @verify('error', [0-1])
        final $8 = state.pos;
        int? $6;
        // [0-1]
        if (state.pos < state.input.length) {
          final $10 = state.input.codeUnitAt(state.pos);
          final $11 = $10 >= 48 && $10 <= 49;
          if ($11) {
            state.pos++;
            state.setOk(true);
            $6 = $10;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          // ignore: unused_local_variable
          final $$ = $6!;
          final $7 = (() => $$ == 0x30)();
          if (!$7) {
            state.fail(ErrorMessage($8 - state.pos, 'error'));
            state.backtrack($8);
          }
        }
      }
    }
  }

  /// Verify =
  ///     'abc'
  ///   / [5] [6] [7]
  ///   / Verify_
  ///   ;
  AsyncResult<Object?> fastParseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late int $7;
    late int $15;
    int? $14;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos + 2 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            const $4 = 'abc';
            final $5 = state.pos + 2 < $3.end &&
                $3.data.codeUnitAt(state.pos - $3.start) == 97 &&
                $3.data.codeUnitAt(state.pos - $3.start + 1) == 98 &&
                $3.data.codeUnitAt(state.pos - $3.start + 2) == 99;
            if ($5) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$4]));
            }
            final $21 = !state.ok && state.isRecoverable;
            if (!$21) {
              $2 = 1;
              break;
            }
            $7 = state.pos;
            $2 = 2;
            break;
          case 1:
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $2 = 2;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 53;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $22 = state.ok;
            if (!$22) {
              $2 = 3;
              break;
            }
            $2 = 4;
            break;
          case 3:
            if (!state.ok) {
              state.backtrack($7);
            }
            final $24 = !state.ok && state.isRecoverable;
            if (!$24) {
              $2 = 7;
              break;
            }
            $15 = state.pos;
            state.input.beginBuffering();
            $2 = 8;
            break;
          case 4:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $2 = 4;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 54;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $23 = state.ok;
            if (!$23) {
              $2 = 5;
              break;
            }
            $2 = 6;
            break;
          case 5:
            $2 = 3;
            break;
          case 6:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $2 = 6;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 55;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $2 = 5;
            break;
          case 7:
            $2 = 1;
            break;
          case 8:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $2 = 8;
              return;
            }
            if (state.pos < $17.end) {
              final $18 = $17.data.codeUnitAt(state.pos - $17.start);
              final $19 = $18 >= 48 && $18 <= 49;
              if ($19) {
                state.pos++;
                $14 = $18;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.input.endBuffering();
            if (state.ok) {
              // ignore: unused_local_variable
              final $$ = $14!;
              final $16 = (() => $$ == 0x30)();
              if (!$16) {
                state.fail(ErrorMessage($15 - state.pos, 'error'));
                state.backtrack($15);
              }
            }
            $2 = 7;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  void fastParseZeroOrMore(State<String> state) {
    // [0]*
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c == 48);
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        state.pos++);
    state.setOk(true);
  }

  /// ZeroOrMore =
  ///   [0]*
  ///   ;
  AsyncResult<Object?> fastParseZeroOrMore$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $5 = state.input;
            var $7 = false;
            while (state.pos < $5.end) {
              final $3 = $5.data.codeUnitAt(state.pos - $5.start);
              final $4 = $3 == 48;
              if (!$4) {
                $7 = true;
                break;
              }
              state.pos++;
            }
            if (!$7 && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $2 = 0;
              return;
            }
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// AndPredicate =
  ///   &([0] [1] [2]) [0] [1] [2]
  ///   ;
  List<Object?>? parseAndPredicate(State<String> state) {
    List<Object?>? $0;
    // &([0] [1] [2]) [0] [1] [2]
    final $5 = state.pos;
    Object? $1;
    final $6 = state.pos;
    // [0] [1] [2]
    final $7 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($7);
    }
    if (state.ok) {
      state.backtrack($6);
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $3;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $3 = 49;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $4;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 50;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $4 = 50;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $0 = [$1, $2!, $3!, $4!];
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($5);
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
    var $3 = 0;
    late int $8;
    Object? $4;
    late int $9;
    late int $10;
    int? $5;
    int? $6;
    int? $7;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = state.pos;
            $9 = state.pos;
            state.input.beginBuffering();
            $10 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($10);
            }
            state.input.endBuffering();
            if (state.ok) {
              state.backtrack($9);
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 6;
              break;
            }
            $3 = 7;
            break;
          case 3:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $15.end) {
              final ok = $15.data.codeUnitAt(state.pos - $15.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 4;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($8);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 7:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $17.end) {
              final ok = $17.data.codeUnitAt(state.pos - $17.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $26 = state.ok;
            if (!$26) {
              $3 = 8;
              break;
            }
            $3 = 9;
            break;
          case 8:
            $3 = 6;
            break;
          case 9:
            final $19 = state.input;
            if (state.pos >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $3 = 9;
              return;
            }
            if (state.pos < $19.end) {
              final ok = $19.data.codeUnitAt(state.pos - $19.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $6 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $27 = state.ok;
            if (!$27) {
              $3 = 10;
              break;
            }
            $3 = 11;
            break;
          case 10:
            $3 = 8;
            break;
          case 11:
            final $21 = state.input;
            if (state.pos >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $1;
              $3 = 11;
              return;
            }
            if (state.pos < $21.end) {
              final ok = $21.data.codeUnitAt(state.pos - $21.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $7 = 50;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4, $5!, $6!, $7!];
            }
            $3 = 10;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final c = state.input.runeAt(state.pos);
      state.pos += c > 0xffff ? 2 : 1;
      state.setOk(true);
      $0 = c;
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final c = $4.data.runeAt(state.pos - $4.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
              $2 = c;
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final $2 = state.input.codeUnitAt(state.pos);
      final $3 = $2 >= 48 && $2 <= 57;
      if ($3) {
        state.pos++;
        state.setOk(true);
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final $5 = $4.data.codeUnitAt(state.pos - $4.start);
              final $6 = $5 >= 48 && $5 <= 57;
              if ($6) {
                state.pos++;
                $2 = $5;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.runeAt(state.pos) == 128640;
      if (ok) {
        state.pos += 2;
        state.setOk(true);
        $0 = 128640;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// CharacterClassChar32 =
  ///   [\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassChar32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.runeAt(state.pos - $4.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
                $2 = 128640;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final $2 = state.input.runeAt(state.pos);
      final $3 = $2 != 48;
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
    return $0;
  }

  /// CharacterClassCharNegate =
  ///   [^0]
  ///   ;
  AsyncResult<int> parseCharacterClassCharNegate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final $5 = $4.data.runeAt(state.pos - $4.start);
              final $6 = $5 != 48;
              if ($6) {
                state.pos += $5 > 0xffff ? 2 : 1;
                $2 = $5;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final $2 = state.input.runeAt(state.pos);
      final $3 = $2 != 128640;
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
    return $0;
  }

  /// CharacterClassCharNegate32 =
  ///   [^\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassCharNegate32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final $5 = $4.data.runeAt(state.pos - $4.start);
              final $6 = $5 != 128640;
              if ($6) {
                state.pos += $5 > 0xffff ? 2 : 1;
                $2 = $5;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final $2 = state.input.runeAt(state.pos);
      final $3 = $2 >= 32 && $2 <= 128640;
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
    return $0;
  }

  /// CharacterClassRange32 =
  ///   [ -\u{1f680}]
  ///   ;
  AsyncResult<int> parseCharacterClassRange32$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final $5 = $4.data.runeAt(state.pos - $4.start);
              final $6 = $5 >= 32 && $5 <= 128640;
              if ($6) {
                state.pos += $5 > 0xffff ? 2 : 1;
                $2 = $5;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $7 = state.pos;
    var $5 = true;
    final $6 = state.ignoreErrors;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 43;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 43;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $5 = false;
        state.ignoreErrors = false;
        Object? $3;
        state.setOk(true);
        if (state.ok) {
          int? $4;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 49;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $4 = 49;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $0 = [$1!, $2!, $3, $4!];
          }
        }
      }
    }
    if (!state.ok) {
      if (!$5) {
        state.isRecoverable = false;
      }
      state.backtrack($7);
    }
    state.ignoreErrors = $6;
    if (!state.ok && state.isRecoverable) {
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $0 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $3 = 0;
    late bool $8;
    late bool $9;
    late int $10;
    int? $4;
    int? $5;
    Object? $6;
    int? $7;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            state.input.beginBuffering();
            $10 = state.pos;
            $9 = true;
            $8 = state.ignoreErrors;
            $3 = 1;
            break;
          case 1:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              if (!$9) {
                state.isRecoverable = false;
              }
              state.backtrack($10);
            }
            state.ignoreErrors = $8;
            state.input.endBuffering();
            final $22 = !state.ok && state.isRecoverable;
            if (!$22) {
              $3 = 7;
              break;
            }
            $3 = 8;
            break;
          case 3:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 43;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 43;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $20 = state.ok;
            if (!$20) {
              $3 = 4;
              break;
            }
            $9 = false;
            state.ignoreErrors = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $21 = state.ok;
            if (!$21) {
              $3 = 5;
              break;
            }
            $3 = 6;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            $3 = 4;
            break;
          case 6:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 6;
              return;
            }
            if (state.pos < $15.end) {
              final ok = $15.data.codeUnitAt(state.pos - $15.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $7 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4!, $5!, $6, $7!];
            }
            $3 = 5;
            break;
          case 7:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 8:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $17.end) {
              final ok = $17.data.codeUnitAt(state.pos - $17.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 7;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Cut1 =
  ///     [0] ↑
  ///   / [1]
  ///   ;
  Object? parseCut1(State<String> state) {
    Object? $0;
    // [0] ↑
    final $5 = state.pos;
    var $3 = true;
    final $4 = state.ignoreErrors;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $3 = false;
      state.ignoreErrors = false;
      Object? $2;
      state.setOk(true);
      if (state.ok) {
        $0 = [$1!, $2];
      }
    }
    if (!state.ok) {
      if (!$3) {
        state.isRecoverable = false;
      }
      state.backtrack($5);
    }
    state.ignoreErrors = $4;
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $0 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
    return $0;
  }

  /// Cut1 =
  ///     [0] ↑
  ///   / [1]
  ///   ;
  AsyncResult<Object?> parseCut1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    var $3 = 0;
    late bool $6;
    late bool $7;
    late int $8;
    int? $4;
    Object? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = state.pos;
            $7 = true;
            $6 = state.ignoreErrors;
            $3 = 1;
            break;
          case 1:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $7 = false;
              state.ignoreErrors = false;
              state.setOk(true);
              state.input.cut(state.pos);
              if (state.ok) {
                $2 = [$4!, $5];
              }
            }
            if (!state.ok) {
              if (!$7) {
                state.isRecoverable = false;
              }
              state.backtrack($8);
            }
            state.ignoreErrors = $6;
            final $13 = !state.ok && state.isRecoverable;
            if (!$13) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// CutWithInner =
  ///     [0] ↑ ([a] / [b]) [1]
  ///   / [0]
  ///   ;
  Object? parseCutWithInner(State<String> state) {
    Object? $0;
    // [0] ↑ ([a] / [b]) [1]
    final $7 = state.pos;
    var $5 = true;
    final $6 = state.ignoreErrors;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $5 = false;
      state.ignoreErrors = false;
      Object? $2;
      state.setOk(true);
      if (state.ok) {
        int? $3;
        // [a]
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 97;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $3 = 97;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (!state.ok && state.isRecoverable) {
          // [b]
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 98;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $3 = 98;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
        }
        if (state.ok) {
          int? $4;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 49;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $4 = 49;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $0 = [$1!, $2, $3!, $4!];
          }
        }
      }
    }
    if (!state.ok) {
      if (!$5) {
        state.isRecoverable = false;
      }
      state.backtrack($7);
    }
    state.ignoreErrors = $6;
    if (!state.ok && state.isRecoverable) {
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $0 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    }
    return $0;
  }

  /// CutWithInner =
  ///     [0] ↑ ([a] / [b]) [1]
  ///   / [0]
  ///   ;
  AsyncResult<Object?> parseCutWithInner$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    var $3 = 0;
    late bool $8;
    late bool $9;
    late int $10;
    int? $4;
    Object? $5;
    int? $6;
    int? $7;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            state.input.beginBuffering();
            $10 = state.pos;
            $9 = true;
            $8 = state.ignoreErrors;
            $3 = 1;
            break;
          case 1:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 2;
              break;
            }
            $9 = false;
            state.ignoreErrors = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $22 = state.ok;
            if (!$22) {
              $3 = 3;
              break;
            }
            $3 = 4;
            break;
          case 2:
            if (!state.ok) {
              if (!$9) {
                state.isRecoverable = false;
              }
              state.backtrack($10);
            }
            state.ignoreErrors = $8;
            state.input.endBuffering();
            final $25 = !state.ok && state.isRecoverable;
            if (!$25) {
              $3 = 9;
              break;
            }
            $3 = 10;
            break;
          case 3:
            $3 = 2;
            break;
          case 4:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 4;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 97;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $6 = 97;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $23 = !state.ok && state.isRecoverable;
            if (!$23) {
              $3 = 5;
              break;
            }
            $3 = 6;
            break;
          case 5:
            final $24 = state.ok;
            if (!$24) {
              $3 = 7;
              break;
            }
            $3 = 8;
            break;
          case 6:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 6;
              return;
            }
            if (state.pos < $15.end) {
              final ok = $15.data.codeUnitAt(state.pos - $15.start) == 98;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $6 = 98;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 5;
            break;
          case 7:
            $3 = 3;
            break;
          case 8:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $17.end) {
              final ok = $17.data.codeUnitAt(state.pos - $17.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $7 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4!, $5, $6!, $7!];
            }
            $3 = 7;
            break;
          case 9:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 10:
            final $19 = state.input;
            if (state.pos >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $3 = 10;
              return;
            }
            if (state.pos < $19.end) {
              final ok = $19.data.codeUnitAt(state.pos - $19.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      Object? $2;
      if (state.pos >= state.input.length) {
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedEndOfInput());
      }
      if (state.ok) {
        $0 = [$1!, $2];
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// Eof =
  ///   [0] @eof()
  ///   ;
  AsyncResult<List<Object?>> parseEof$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    var $3 = 0;
    late int $6;
    int? $4;
    Object? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = state.ok;
            if (!$11) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos >= $9.end) {
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4!, $5];
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Expected =
  ///   @expected('digits', [0-9]{2,})
  ///   ;
  List<int>? parseExpected(State<String> state) {
    List<int>? $0;
    // @expected('digits', [0-9]{2,})
    final $2 = state.pos;
    final $3 = state.errorCount;
    final $4 = state.failPos;
    final $5 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0-9]{2,}
    final $9 = state.pos;
    final $10 = <int>[];
    final $8 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $10.length >= 2;
      int? $7;
      if (state.pos < state.input.length) {
        final $11 = state.input.codeUnitAt(state.pos);
        final $12 = $11 >= 48 && $11 <= 57;
        if ($12) {
          state.pos++;
          state.setOk(true);
          $7 = $11;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $10.add($7!);
    }
    state.ignoreErrors = $8;
    if ($10.length >= 2) {
      state.setOk(true);
      $0 = $10;
    } else {
      state.backtrack($9);
    }
    if (!state.ok && state.lastFailPos == $2) {
      if (state.lastFailPos == $4) {
        state.errorCount = $3;
      } else if (state.lastFailPos > $4) {
        state.errorCount = 0;
      }
      state.fail(const ErrorExpectedTags(['digits']));
    }
    if (state.lastFailPos < $5) {
      state.lastFailPos = $5;
    }
    return $0;
  }

  /// Expected =
  ///   @expected('digits', [0-9]{2,})
  ///   ;
  AsyncResult<List<int>> parseExpected$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late int $4;
    late int $5;
    late int $6;
    late int $7;
    late bool $9;
    late int $10;
    late List<int> $11;
    int? $8;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = state.pos;
            $5 = state.errorCount;
            $6 = state.failPos;
            $7 = state.lastFailPos;
            state.lastFailPos = -1;
            $10 = state.pos;
            $11 = <int>[];
            $9 = state.ignoreErrors;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $9;
            if ($11.length >= 2) {
              state.setOk(true);
              $2 = $11;
            } else {
              state.backtrack($10);
            }
            if (!state.ok && state.lastFailPos == $4) {
              if (state.lastFailPos == $6) {
                state.errorCount = $5;
              } else if (state.lastFailPos > $6) {
                state.errorCount = 0;
              }
              state.fail(const ErrorExpectedTags(['digits']));
            }
            if (state.lastFailPos < $7) {
              state.lastFailPos = $7;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            state.ignoreErrors = $11.length >= 2;
            $3 = 3;
            break;
          case 3:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $12.end) {
              final $13 = $12.data.codeUnitAt(state.pos - $12.start);
              final $14 = $13 >= 48 && $13 <= 57;
              if ($14) {
                state.pos++;
                $8 = $13;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $11.add($8!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Indicate =
  ///   @indicate('error', [0] [1] [2])
  ///   ;
  List<Object?>? parseIndicate(State<String> state) {
    List<Object?>? $0;
    // @indicate('error', [0] [1] [2])
    final $5 = state.pos;
    final $2 = state.errorCount;
    final $3 = state.failPos;
    final $4 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0] [1] [2]
    final $9 = state.pos;
    int? $6;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $6 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $7;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $7 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $8;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $8 = 50;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $0 = [$6!, $7!, $8!];
        }
      }
    }
    if (!state.ok) {
      state.backtrack($9);
    }
    if (!state.ok) {
      if (state.lastFailPos == $3) {
        state.errorCount = $2;
      } else if (state.lastFailPos > $3) {
        state.errorCount = 0;
      }
      final length = $5 - state.lastFailPos;
      state.failAt(state.lastFailPos, ErrorMessage(length, 'error'));
    }
    if (state.lastFailPos < $4) {
      state.lastFailPos = $4;
    }
    return $0;
  }

  /// Indicate =
  ///   @indicate('error', [0] [1] [2])
  ///   ;
  AsyncResult<List<Object?>> parseIndicate$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    var $3 = 0;
    late int $4;
    late int $5;
    late int $6;
    late int $7;
    late int $11;
    int? $8;
    int? $9;
    int? $10;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $4 = state.errorCount;
            $5 = state.failPos;
            $6 = state.lastFailPos;
            state.lastFailPos = -1;
            state.input.beginBuffering();
            $11 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $8 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($11);
            }
            state.input.endBuffering();
            if (!state.ok) {
              if (state.lastFailPos == $5) {
                state.errorCount = $4;
              } else if (state.lastFailPos > $5) {
                state.errorCount = 0;
              }
              final length = $7 - state.lastFailPos;
              state.failAt(state.lastFailPos, ErrorMessage(length, 'error'));
            }
            if (state.lastFailPos < $6) {
              state.lastFailPos = $6;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $9 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $10 = 50;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$8!, $9!, $10!];
            }
            $3 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// List =
  ///   @list([0], [,] v:[0])
  ///   ;
  List<int>? parseList(State<String> state) {
    List<int>? $0;
    // @list([0], [,] v:[0])
    final $2 = <int>[];
    final $5 = state.ignoreErrors;
    state.ignoreErrors = true;
    int? $3;
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $3 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $2.add($3!);
      while (true) {
        int? $4;
        // [,] v:[0]
        final $9 = state.pos;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 44;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $8;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 48;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $8 = 48;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $4 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $2.add($4!);
      }
    }
    state.ignoreErrors = $5;
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// List =
  ///   @list([0], [,] v:[0])
  ///   ;
  AsyncResult<List<int>> parseList$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late bool $6;
    late List<int> $7;
    int? $4;
    int? $5;
    late int $11;
    int? $10;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = [];
            $6 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $16 = state.ok;
            if (!$16) {
              $3 = 2;
              break;
            }
            $7.add($4!);
            $3 = 4;
            break;
          case 2:
            state.ignoreErrors = $6;
            state.setOk(true);
            if (state.ok) {
              $2 = $7;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $3 = 2;
            break;
          case 4:
            $11 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 44;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $3 = 6;
              break;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($11);
            }
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $7.add($5!);
            $3 = 4;
            break;
          case 7:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $10 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $5 = $10;
            }
            $3 = 6;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// List1 =
  ///   @list1([0], [,] v:[0])
  ///   ;
  List<int>? parseList1(State<String> state) {
    List<int>? $0;
    // @list1([0], [,] v:[0])
    final $2 = <int>[];
    int? $3;
    // [0]
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $3 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      $2.add($3!);
      final $5 = state.ignoreErrors;
      state.ignoreErrors = true;
      while (true) {
        int? $4;
        // [,] v:[0]
        final $9 = state.pos;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 44;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $8;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 48;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $8 = 48;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $4 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $2.add($4!);
      }
      state.ignoreErrors = $5;
    }
    state.setOk($2.isNotEmpty);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// List1 =
  ///   @list1([0], [,] v:[0])
  ///   ;
  AsyncResult<List<int>> parseList1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late bool $6;
    late List<int> $7;
    int? $4;
    int? $5;
    late int $11;
    int? $10;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = [];
            $3 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $16 = state.ok;
            if (!$16) {
              $3 = 2;
              break;
            }
            $7.add($4!);
            $6 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 4;
            break;
          case 2:
            state.setOk($7.isNotEmpty);
            if (state.ok) {
              $2 = $7;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            state.ignoreErrors = $6;
            $3 = 2;
            break;
          case 4:
            $11 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 44;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $3 = 6;
              break;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($11);
            }
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $7.add($5!);
            $3 = 4;
            break;
          case 7:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $10 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $5 = $10;
            }
            $3 = 6;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    state.setOk(true);
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            state.setOk(true);
            $2 = '';
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48;
    if ($3) {
      state.pos++;
      state.setOk(true);
      $0 = $2;
    } else {
      state.fail(const ErrorExpectedTags([$2]));
    }
    return $0;
  }

  /// Literal1 =
  ///   '0'
  ///   ;
  AsyncResult<String> parseLiteral1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            const $5 = '0';
            final $6 = state.pos < $4.end &&
                $4.data.codeUnitAt(state.pos - $4.start) == 48;
            if ($6) {
              state.pos++;
              state.setOk(true);
              $2 = $5;
            } else {
              state.fail(const ErrorExpectedTags([$5]));
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Literal10 =
  ///   '0123456789'
  ///   ;
  String? parseLiteral10(State<String> state) {
    String? $0;
    // '0123456789'
    const $2 = '0123456789';
    final $3 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48 &&
        state.input.startsWith($2, state.pos);
    if ($3) {
      state.pos += 10;
      state.setOk(true);
      $0 = $2;
    } else {
      state.fail(const ErrorExpectedTags([$2]));
    }
    return $0;
  }

  /// Literal10 =
  ///   '0123456789'
  ///   ;
  AsyncResult<String> parseLiteral10$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos + 9 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            final $5 = state.input;
            const $6 = '0123456789';
            final $8 = state.pos - $5.start;
            final $7 = state.pos < $5.end &&
                $5.data.codeUnitAt($8) == 48 &&
                $5.data.startsWith($6, $8);
            if ($7) {
              state.pos += 10;
              state.setOk(true);
              $2 = $6;
            } else {
              state.fail(const ErrorExpectedTags([$6]));
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48 &&
        state.input.codeUnitAt(state.pos + 1) == 49;
    if ($3) {
      state.pos += 2;
      state.setOk(true);
      $0 = $2;
    } else {
      state.fail(const ErrorExpectedTags([$2]));
    }
    return $0;
  }

  /// Literal2 =
  ///   '01'
  ///   ;
  AsyncResult<String> parseLiteral2$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos + 1 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            const $5 = '01';
            final $6 = state.pos + 1 < $4.end &&
                $4.data.codeUnitAt(state.pos - $4.start) == 48 &&
                $4.data.codeUnitAt(state.pos - $4.start + 1) == 49;
            if ($6) {
              state.pos += 2;
              state.setOk(true);
              $2 = $5;
            } else {
              state.fail(const ErrorExpectedTags([$5]));
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Literals =
  ///     '0123'
  ///   / '012'
  ///   / '01'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'A'
  ///   ;
  String? parseLiterals(State<String> state) {
    String? $0;
    final $2 = state.pos;
    var $1 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 48:
          final ok = pos2 + 2 < input.length &&
              input.codeUnitAt(pos2) == 49 &&
              input.codeUnitAt(pos2 + 1) == 50 &&
              input.codeUnitAt(pos2 + 2) == 51;
          if (ok) {
            $1 = 4;
            $0 = '0123';
          } else {
            final ok = pos2 + 1 < input.length &&
                input.codeUnitAt(pos2) == 49 &&
                input.codeUnitAt(pos2 + 1) == 50;
            if (ok) {
              $1 = 3;
              $0 = '012';
            } else {
              final ok = pos2 < input.length && input.codeUnitAt(pos2) == 49;
              if (ok) {
                $1 = 2;
                $0 = '01';
              }
            }
          }
          break;
        case 97:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
          if (ok) {
            $1 = 2;
            $0 = 'ab';
          } else {
            $1 = 1;
            $0 = 'a';
          }
          break;
        case 65:
          $1 = 1;
          $0 = 'A';
          break;
      }
    }
    if ($1 > 0) {
      state.pos += $1;
      state.setOk(true);
    } else {
      state.pos = $2;
      state
          .fail(const ErrorExpectedTags(['0123', '012', '01', 'ab', 'a', 'A']));
    }
    return $0;
  }

  /// Literals =
  ///     '0123'
  ///   / '012'
  ///   / '01'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'A'
  ///   ;
  AsyncResult<String> parseLiterals$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos + 3 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            const $5 = '0123';
            final $6 = state.pos + 3 < $4.end &&
                $4.data.codeUnitAt(state.pos - $4.start) == 48 &&
                $4.data.codeUnitAt(state.pos - $4.start + 1) == 49 &&
                $4.data.codeUnitAt(state.pos - $4.start + 2) == 50 &&
                $4.data.codeUnitAt(state.pos - $4.start + 3) == 51;
            if ($6) {
              state.pos += 4;
              state.setOk(true);
              $2 = $5;
            } else {
              state.fail(const ErrorExpectedTags([$5]));
            }
            final $28 = !state.ok && state.isRecoverable;
            if (!$28) {
              $3 = 1;
              break;
            }
            $3 = 2;
            break;
          case 1:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $8 = state.input;
            if (state.pos + 2 >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 2;
              return;
            }
            const $9 = '012';
            final $10 = state.pos + 2 < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 48 &&
                $8.data.codeUnitAt(state.pos - $8.start + 1) == 49 &&
                $8.data.codeUnitAt(state.pos - $8.start + 2) == 50;
            if ($10) {
              state.pos += 3;
              state.setOk(true);
              $2 = $9;
            } else {
              state.fail(const ErrorExpectedTags([$9]));
            }
            final $29 = !state.ok && state.isRecoverable;
            if (!$29) {
              $3 = 3;
              break;
            }
            $3 = 4;
            break;
          case 3:
            $3 = 1;
            break;
          case 4:
            final $12 = state.input;
            if (state.pos + 1 >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 4;
              return;
            }
            const $13 = '01';
            final $14 = state.pos + 1 < $12.end &&
                $12.data.codeUnitAt(state.pos - $12.start) == 48 &&
                $12.data.codeUnitAt(state.pos - $12.start + 1) == 49;
            if ($14) {
              state.pos += 2;
              state.setOk(true);
              $2 = $13;
            } else {
              state.fail(const ErrorExpectedTags([$13]));
            }
            final $30 = !state.ok && state.isRecoverable;
            if (!$30) {
              $3 = 5;
              break;
            }
            $3 = 6;
            break;
          case 5:
            $3 = 3;
            break;
          case 6:
            final $16 = state.input;
            if (state.pos + 1 >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 6;
              return;
            }
            const $17 = 'ab';
            final $18 = state.pos + 1 < $16.end &&
                $16.data.codeUnitAt(state.pos - $16.start) == 97 &&
                $16.data.codeUnitAt(state.pos - $16.start + 1) == 98;
            if ($18) {
              state.pos += 2;
              state.setOk(true);
              $2 = $17;
            } else {
              state.fail(const ErrorExpectedTags([$17]));
            }
            final $31 = !state.ok && state.isRecoverable;
            if (!$31) {
              $3 = 7;
              break;
            }
            $3 = 8;
            break;
          case 7:
            $3 = 5;
            break;
          case 8:
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $3 = 8;
              return;
            }
            const $21 = 'a';
            final $22 = state.pos < $20.end &&
                $20.data.codeUnitAt(state.pos - $20.start) == 97;
            if ($22) {
              state.pos++;
              state.setOk(true);
              $2 = $21;
            } else {
              state.fail(const ErrorExpectedTags([$21]));
            }
            final $32 = !state.ok && state.isRecoverable;
            if (!$32) {
              $3 = 9;
              break;
            }
            $3 = 10;
            break;
          case 9:
            $3 = 7;
            break;
          case 10:
            final $24 = state.input;
            if (state.pos >= $24.end && !$24.isClosed) {
              $24.sleep = true;
              $24.handle = $1;
              $3 = 10;
              return;
            }
            const $25 = 'A';
            final $26 = state.pos < $24.end &&
                $24.data.codeUnitAt(state.pos - $24.start) == 65;
            if ($26) {
              state.pos++;
              state.setOk(true);
              $2 = $25;
            } else {
              state.fail(const ErrorExpectedTags([$25]));
            }
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
      state.setOk(true);
      $0 = '';
    } else {
      final ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == $2.codeUnitAt(0) &&
          state.input.startsWith($2, state.pos);
      if (ok) {
        state.pos += $2.length;
        state.setOk(true);
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
    var $3 = 0;
    late String $8;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = text;
            final $10 = $8.isEmpty;
            if (!$10) {
              $3 = 1;
              break;
            }
            state.setOk(true);
            $2 = $8;
            $3 = 2;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos + $8.length - 1 >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $3 = 1;
              return;
            }
            final $4 = $5.data;
            final $7 = state.pos - $5.start;
            final $6 =
                $4.codeUnitAt($7) == $8.codeUnitAt(0) && $4.startsWith($8, $7);
            if ($6) {
              state.pos += $8.length;
              state.setOk(true);
              $2 = $8;
            } else {
              state.fail(ErrorExpectedTags([$8]));
            }
            $3 = 2;
            break;
          case 2:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Message =
  ///   @message('error', [0] [1] [2])
  ///   ;
  List<Object?>? parseMessage(State<String> state) {
    List<Object?>? $0;
    // @message('error', [0] [1] [2])
    final $2 = state.errorCount;
    final $3 = state.failPos;
    final $4 = state.lastFailPos;
    state.lastFailPos = -1;
    // [0] [1] [2]
    final $8 = state.pos;
    int? $5;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $5 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $6;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $6 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $7;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $7 = 50;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $0 = [$5!, $6!, $7!];
        }
      }
    }
    if (!state.ok) {
      state.backtrack($8);
    }
    if (!state.ok) {
      if (state.lastFailPos == $3) {
        state.errorCount = $2;
      } else if (state.lastFailPos > $3) {
        state.errorCount = 0;
      }
      state.failAt(state.lastFailPos, ErrorMessage(0, 'error'));
    }
    if (state.lastFailPos < $4) {
      state.lastFailPos = $4;
    }
    return $0;
  }

  /// Message =
  ///   @message('error', [0] [1] [2])
  ///   ;
  AsyncResult<List<Object?>> parseMessage$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    var $3 = 0;
    late int $4;
    late int $5;
    late int $6;
    late int $10;
    int? $7;
    int? $8;
    int? $9;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = state.errorCount;
            $5 = state.failPos;
            $6 = state.lastFailPos;
            state.lastFailPos = -1;
            state.input.beginBuffering();
            $10 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $7 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $17 = state.ok;
            if (!$17) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($10);
            }
            state.input.endBuffering();
            if (!state.ok) {
              if (state.lastFailPos == $5) {
                state.errorCount = $4;
              } else if (state.lastFailPos > $5) {
                state.errorCount = 0;
              }
              state.failAt(state.lastFailPos, ErrorMessage(0, 'error'));
            }
            if (state.lastFailPos < $6) {
              state.lastFailPos = $6;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $8 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $15.end) {
              final ok = $15.data.codeUnitAt(state.pos - $15.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $9 = 50;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$7!, $8!, $9!];
            }
            $3 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos;
    Object? $1;
    final $5 = state.pos;
    // [0] [1] [2]
    final $6 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($6);
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
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $3;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $3 = 49;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $0 = [$1, $2!, $3!];
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
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
    var $3 = 0;
    late int $7;
    Object? $4;
    late int $8;
    late int $9;
    int? $5;
    int? $6;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $8 = state.pos;
            state.input.beginBuffering();
            $9 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $20 = state.ok;
            if (!$20) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($9);
            }
            state.input.endBuffering();
            if (state.ok) {
              final length = $8 - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                -1 => const ErrorUnexpectedInput(-1),
                -2 => const ErrorUnexpectedInput(-2),
                _ => ErrorUnexpectedInput(length)
              });
              state.backtrack($8);
            } else {
              state.setOk(true);
            }
            final $22 = state.ok;
            if (!$22) {
              $3 = 6;
              break;
            }
            $3 = 7;
            break;
          case 3:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 4;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($7);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 7:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 8;
              break;
            }
            $3 = 9;
            break;
          case 8:
            $3 = 6;
            break;
          case 9:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 9;
              return;
            }
            if (state.pos < $18.end) {
              final ok = $18.data.codeUnitAt(state.pos - $18.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $6 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4, $5!, $6!];
            }
            $3 = 8;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// NotPredicate2 =
  ///     !([0] [3] 'abc' 'foo') [0] [3] 'abc'
  ///   / [0] [3] [2]
  ///   ;
  List<Object?>? parseNotPredicate2(State<String> state) {
    List<Object?>? $0;
    // !([0] [3] 'abc' 'foo') [0] [3] 'abc'
    final $5 = state.pos;
    Object? $1;
    final $6 = state.pos;
    // [0] [3] 'abc' 'foo'
    final $7 = state.pos;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 51;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        const $8 = 'abc';
        final $9 = state.pos + 2 < state.input.length &&
            state.input.codeUnitAt(state.pos) == 97 &&
            state.input.codeUnitAt(state.pos + 1) == 98 &&
            state.input.codeUnitAt(state.pos + 2) == 99;
        if ($9) {
          state.pos += 3;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$8]));
        }
        if (state.ok) {
          const $10 = 'foo';
          final $11 = state.pos + 2 < state.input.length &&
              state.input.codeUnitAt(state.pos) == 102 &&
              state.input.codeUnitAt(state.pos + 1) == 111 &&
              state.input.codeUnitAt(state.pos + 2) == 111;
          if ($11) {
            state.pos += 3;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$10]));
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($7);
    }
    if (state.ok) {
      final length = $6 - state.pos;
      state.fail(switch (length) {
        0 => const ErrorUnexpectedInput(0),
        -1 => const ErrorUnexpectedInput(-1),
        -2 => const ErrorUnexpectedInput(-2),
        _ => ErrorUnexpectedInput(length)
      });
      state.backtrack($6);
    } else {
      state.setOk(true);
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $3;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 51;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $3 = 51;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          String? $4;
          const $12 = 'abc';
          final $13 = state.pos + 2 < state.input.length &&
              state.input.codeUnitAt(state.pos) == 97 &&
              state.input.codeUnitAt(state.pos + 1) == 98 &&
              state.input.codeUnitAt(state.pos + 2) == 99;
          if ($13) {
            state.pos += 3;
            state.setOk(true);
            $4 = $12;
          } else {
            state.fail(const ErrorExpectedTags([$12]));
          }
          if (state.ok) {
            $0 = [$1, $2!, $3!, $4!];
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    if (!state.ok && state.isRecoverable) {
      // [0] [3] [2]
      final $17 = state.pos;
      int? $14;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $14 = 48;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $15;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 51;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $15 = 51;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $16;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 50;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $16 = 50;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $0 = [$14!, $15!, $16!];
          }
        }
      }
      if (!state.ok) {
        state.backtrack($17);
      }
    }
    return $0;
  }

  /// NotPredicate2 =
  ///     !([0] [3] 'abc' 'foo') [0] [3] 'abc'
  ///   / [0] [3] [2]
  ///   ;
  AsyncResult<List<Object?>> parseNotPredicate2$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    var $3 = 0;
    late int $8;
    Object? $4;
    late int $9;
    late int $10;
    int? $5;
    int? $6;
    String? $7;
    late int $34;
    int? $31;
    int? $32;
    int? $33;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = state.pos;
            $9 = state.pos;
            state.input.beginBuffering();
            $10 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $11.end) {
              final ok = $11.data.codeUnitAt(state.pos - $11.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $41 = state.ok;
            if (!$41) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($10);
            }
            state.input.endBuffering();
            if (state.ok) {
              final length = $9 - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                -1 => const ErrorUnexpectedInput(-1),
                -2 => const ErrorUnexpectedInput(-2),
                _ => ErrorUnexpectedInput(length)
              });
              state.backtrack($9);
            } else {
              state.setOk(true);
            }
            final $44 = state.ok;
            if (!$44) {
              $3 = 8;
              break;
            }
            $3 = 9;
            break;
          case 3:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $42 = state.ok;
            if (!$42) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $15 = state.input;
            if (state.pos + 2 >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 5;
              return;
            }
            const $16 = 'abc';
            final $17 = state.pos + 2 < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 97 &&
                $15.data.codeUnitAt(state.pos - $15.start + 1) == 98 &&
                $15.data.codeUnitAt(state.pos - $15.start + 2) == 99;
            if ($17) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$16]));
            }
            final $43 = state.ok;
            if (!$43) {
              $3 = 6;
              break;
            }
            $3 = 7;
            break;
          case 6:
            $3 = 4;
            break;
          case 7:
            final $19 = state.input;
            if (state.pos + 2 >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $3 = 7;
              return;
            }
            const $20 = 'foo';
            final $21 = state.pos + 2 < $19.end &&
                $19.data.codeUnitAt(state.pos - $19.start) == 102 &&
                $19.data.codeUnitAt(state.pos - $19.start + 1) == 111 &&
                $19.data.codeUnitAt(state.pos - $19.start + 2) == 111;
            if ($21) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$20]));
            }
            $3 = 6;
            break;
          case 8:
            if (!state.ok) {
              state.backtrack($8);
            }
            final $47 = !state.ok && state.isRecoverable;
            if (!$47) {
              $3 = 14;
              break;
            }
            $34 = state.pos;
            $3 = 15;
            break;
          case 9:
            final $23 = state.input;
            if (state.pos >= $23.end && !$23.isClosed) {
              $23.sleep = true;
              $23.handle = $1;
              $3 = 9;
              return;
            }
            if (state.pos < $23.end) {
              final ok = $23.data.codeUnitAt(state.pos - $23.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $45 = state.ok;
            if (!$45) {
              $3 = 10;
              break;
            }
            $3 = 11;
            break;
          case 10:
            $3 = 8;
            break;
          case 11:
            final $25 = state.input;
            if (state.pos >= $25.end && !$25.isClosed) {
              $25.sleep = true;
              $25.handle = $1;
              $3 = 11;
              return;
            }
            if (state.pos < $25.end) {
              final ok = $25.data.codeUnitAt(state.pos - $25.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $6 = 51;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $46 = state.ok;
            if (!$46) {
              $3 = 12;
              break;
            }
            $3 = 13;
            break;
          case 12:
            $3 = 10;
            break;
          case 13:
            final $27 = state.input;
            if (state.pos + 2 >= $27.end && !$27.isClosed) {
              $27.sleep = true;
              $27.handle = $1;
              $3 = 13;
              return;
            }
            const $28 = 'abc';
            final $29 = state.pos + 2 < $27.end &&
                $27.data.codeUnitAt(state.pos - $27.start) == 97 &&
                $27.data.codeUnitAt(state.pos - $27.start + 1) == 98 &&
                $27.data.codeUnitAt(state.pos - $27.start + 2) == 99;
            if ($29) {
              state.pos += 3;
              state.setOk(true);
              $7 = $28;
            } else {
              state.fail(const ErrorExpectedTags([$28]));
            }
            if (state.ok) {
              $2 = [$4, $5!, $6!, $7!];
            }
            $3 = 12;
            break;
          case 14:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 15:
            final $35 = state.input;
            if (state.pos >= $35.end && !$35.isClosed) {
              $35.sleep = true;
              $35.handle = $1;
              $3 = 15;
              return;
            }
            if (state.pos < $35.end) {
              final ok = $35.data.codeUnitAt(state.pos - $35.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $31 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $48 = state.ok;
            if (!$48) {
              $3 = 16;
              break;
            }
            $3 = 17;
            break;
          case 16:
            if (!state.ok) {
              state.backtrack($34);
            }
            $3 = 14;
            break;
          case 17:
            final $37 = state.input;
            if (state.pos >= $37.end && !$37.isClosed) {
              $37.sleep = true;
              $37.handle = $1;
              $3 = 17;
              return;
            }
            if (state.pos < $37.end) {
              final ok = $37.data.codeUnitAt(state.pos - $37.start) == 51;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $32 = 51;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $49 = state.ok;
            if (!$49) {
              $3 = 18;
              break;
            }
            $3 = 19;
            break;
          case 18:
            $3 = 16;
            break;
          case 19:
            final $39 = state.input;
            if (state.pos >= $39.end && !$39.isClosed) {
              $39.sleep = true;
              $39.handle = $1;
              $3 = 19;
              return;
            }
            if (state.pos < $39.end) {
              final ok = $39.data.codeUnitAt(state.pos - $39.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $33 = 50;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$31!, $32!, $33!];
            }
            $3 = 18;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c == 48);
        state.pos++,
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        $2.add(c));
    if ($2.isNotEmpty) {
      state.setOk(true);
      $0 = $2;
    } else {
      state.pos < state.input.length
          ? state.fail(const ErrorUnexpectedCharacter())
          : state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// OneOrMore =
  ///   [0]+
  ///   ;
  AsyncResult<List<int>> parseOneOrMore$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late List<int> $8;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = <int>[];
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            var $9 = false;
            while (state.pos < $6.end) {
              final $4 = $6.data.codeUnitAt(state.pos - $6.start);
              final $5 = $4 == 48;
              if (!$5) {
                $9 = true;
                break;
              }
              state.pos++;
              $8.add($4);
            }
            if (!$9 && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            if ($8.isNotEmpty) {
              $2 = $8;
              state.setOk(true);
            } else {
              $6.isClosed
                  ? state.fail(const ErrorUnexpectedEndOfInput())
                  : state.fail(const ErrorUnexpectedCharacter());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// OneOrMoreLiteral =
  ///   'abc'+
  ///   ;
  List<String>? parseOneOrMoreLiteral(State<String> state) {
    List<String>? $0;
    // 'abc'+
    final $3 = <String>[];
    final $2 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $3.isNotEmpty;
      String? $4;
      const $5 = 'abc';
      final $6 = state.pos + 2 < state.input.length &&
          state.input.codeUnitAt(state.pos) == 97 &&
          state.input.codeUnitAt(state.pos + 1) == 98 &&
          state.input.codeUnitAt(state.pos + 2) == 99;
      if ($6) {
        state.pos += 3;
        state.setOk(true);
        $4 = $5;
      } else {
        state.fail(const ErrorExpectedTags([$5]));
      }
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ignoreErrors = $2;
    if ($3.isNotEmpty) {
      state.setOk(true);
      $0 = $3;
    }
    return $0;
  }

  /// OneOrMoreLiteral =
  ///   'abc'+
  ///   ;
  AsyncResult<List<String>> parseOneOrMoreLiteral$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<String>>();
    List<String>? $2;
    var $3 = 0;
    late bool $5;
    late List<String> $6;
    String? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = <String>[];
            $5 = state.ignoreErrors;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            if ($6.isNotEmpty) {
              state.setOk(true);
              $2 = $6;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            state.ignoreErrors = $6.isNotEmpty;
            $3 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 2 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 3;
              return;
            }
            const $8 = 'abc';
            final $9 = state.pos + 2 < $7.end &&
                $7.data.codeUnitAt(state.pos - $7.start) == 97 &&
                $7.data.codeUnitAt(state.pos - $7.start + 1) == 98 &&
                $7.data.codeUnitAt(state.pos - $7.start + 2) == 99;
            if ($9) {
              state.pos += 3;
              state.setOk(true);
              $4 = $8;
            } else {
              state.fail(const ErrorExpectedTags([$8]));
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $6.add($4!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    int? $1;
    final $4 = state.ignoreErrors;
    state.ignoreErrors = true;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    state.ignoreErrors = $4;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $0 = [$1, $2!];
      }
    }
    if (!state.ok) {
      state.backtrack($3);
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
    var $3 = 0;
    late int $6;
    int? $4;
    late bool $7;
    int? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $7 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.ignoreErrors = $7;
            if (!state.ok) {
              state.setOk(true);
            }
            final $12 = state.ok;
            if (!$12) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4, $5!];
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $0 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $8 = !state.ok && state.isRecoverable;
            if (!$8) {
              $3 = 1;
              break;
            }
            $3 = 2;
            break;
          case 1:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 2;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 1;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (!state.ok && state.isRecoverable) {
      // [1]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $0 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok && state.isRecoverable) {
        // [2]
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $0 = 50;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $10 = !state.ok && state.isRecoverable;
            if (!$10) {
              $3 = 1;
              break;
            }
            $3 = 2;
            break;
          case 1:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 2;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = !state.ok && state.isRecoverable;
            if (!$11) {
              $3 = 3;
              break;
            }
            $3 = 4;
            break;
          case 3:
            $3 = 1;
            break;
          case 4:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 4;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 50;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 3;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = <int>[];
    final $3 = state.ignoreErrors;
    state.ignoreErrors = true;
    while ($4.length < 3) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
          $2 = 128640;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $4.add($2!);
    }
    state.ignoreErrors = $3;
    state.setOk(true);
    if (state.ok) {
      $0 = $4;
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
    var $3 = 0;
    late bool $5;
    late List<int> $6;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = <int>[];
            $5 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            state.setOk(true);
            if (state.ok) {
              $2 = $6;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $9 = $6.length < 3;
            if (!$9) {
              $3 = 1;
              break;
            }
            $3 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.runeAt(state.pos - $7.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
                $4 = 128640;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $6.add($4!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos;
    final $5 = <int>[];
    final $3 = state.ignoreErrors;
    while (true) {
      state.ignoreErrors = $5.length >= 3;
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
          $2 = 128640;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $5.add($2!);
    }
    state.ignoreErrors = $3;
    if ($5.length >= 3) {
      state.setOk(true);
      $0 = $5;
    } else {
      state.backtrack($4);
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
    var $3 = 0;
    late bool $5;
    late int $6;
    late List<int> $7;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $7 = <int>[];
            $5 = state.ignoreErrors;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            if ($7.length >= 3) {
              state.setOk(true);
              $2 = $7;
            } else {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            state.ignoreErrors = $7.length >= 3;
            $3 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.runeAt(state.pos - $8.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
                $4 = 128640;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $7.add($4!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos;
    final $5 = <int>[];
    final $3 = state.ignoreErrors;
    while ($5.length < 3) {
      state.ignoreErrors = $5.length >= 2;
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
          $2 = 128640;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $5.add($2!);
    }
    state.ignoreErrors = $3;
    if ($5.length >= 2) {
      state.setOk(true);
      $0 = $5;
    } else {
      state.backtrack($4);
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
    var $3 = 0;
    late bool $5;
    late int $6;
    late List<int> $7;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $7 = <int>[];
            $5 = state.ignoreErrors;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            if ($7.length >= 2) {
              state.setOk(true);
              $2 = $7;
            } else {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $10 = $7.length < 3;
            if (!$10) {
              $3 = 1;
              break;
            }
            state.ignoreErrors = $7.length >= 2;
            $3 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.runeAt(state.pos - $8.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
                $4 = 128640;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $7.add($4!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    final $4 = <int>[];
    while ($4.length < 3) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.runeAt(state.pos) == 128640;
        if (ok) {
          state.pos += 2;
          state.setOk(true);
          $2 = 128640;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $4.add($2!);
    }
    if ($4.length == 3) {
      state.setOk(true);
      $0 = $4;
    } else {
      state.backtrack($3);
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
    var $3 = 0;
    late int $5;
    late List<int> $6;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $6 = <int>[];
            $3 = 2;
            break;
          case 1:
            if ($6.length == 3) {
              state.setOk(true);
              $2 = $6;
            } else {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $9 = $6.length < 3;
            if (!$9) {
              $3 = 1;
              break;
            }
            $3 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.runeAt(state.pos - $7.start) == 128640;
              if (ok) {
                state.pos += 2;
                state.setOk(true);
                $4 = 128640;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $6.add($4!);
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// Sequence1 =
  ///   [0]
  ///   ;
  AsyncResult<int> parseSequence1$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              int? $$;
              $$ = 0x30;
              $2 = $$;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return $0;
  }

  /// Sequence1WithVariable =
  ///   v:[0]
  ///   ;
  AsyncResult<int> parseSequence1WithVariable$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $0 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
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
    var $3 = 0;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $4.end) {
              final ok = $4.data.codeUnitAt(state.pos - $4.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $2 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              int? $$;
              final v = $2!;
              $$ = v;
              $2 = $$;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $0 = [$1!, $2!];
      }
    }
    if (!state.ok) {
      state.backtrack($3);
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
    var $3 = 0;
    late int $6;
    int? $4;
    int? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = state.ok;
            if (!$11) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$4!, $5!];
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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
    var $3 = 0;
    late int $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $5.end) {
              final ok = $5.data.codeUnitAt(state.pos - $5.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $9 = state.ok;
            if (!$9) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($4);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              int? $$;
              $$ = 0x30;
              $2 = $$;
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $2 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
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
    var $3 = 0;
    late int $5;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $10 = state.ok;
            if (!$10) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = $4;
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $2 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $$;
        final v = $1!;
        $$ = v;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
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
    var $3 = 0;
    late int $5;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $10 = state.ok;
            if (!$10) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              int? $$;
              final v = $4!;
              $$ = v;
              $2 = $$;
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        $0 = (v1: $1!, v2: $2!);
      }
    }
    if (!state.ok) {
      state.backtrack($3);
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
    var $3 = 0;
    late int $6;
    int? $4;
    int? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = state.ok;
            if (!$11) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = (v1: $4!, v2: $5!);
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $3 = state.pos;
    int? $1;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
        $1 = 48;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      int? $2;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $2 = 49;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $$;
        final v1 = $1!;
        final v2 = $2!;
        $$ = v1 + v2;
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
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
    var $3 = 0;
    late int $6;
    int? $4;
    int? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $7.end) {
              final ok = $7.data.codeUnitAt(state.pos - $7.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $4 = 48;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $11 = state.ok;
            if (!$11) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($6);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $9.end) {
              final ok = $9.data.codeUnitAt(state.pos - $9.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $5 = 49;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              int? $$;
              final v1 = $4!;
              final v2 = $5!;
              $$ = v1 + v2;
              $2 = $$;
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 48;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 49;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 50;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 49;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
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
    var $3 = 0;
    late int $4;
    late int $5;
    late int $12;
    late int $13;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = state.pos;
            state.input.beginBuffering();
            $5 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $6.end) {
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $18 = state.ok;
            if (!$18) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $2 = input.data.substring($4 - start, state.pos - start);
            }
            final $20 = !state.ok && state.isRecoverable;
            if (!$20) {
              $3 = 6;
              break;
            }
            $12 = state.pos;
            state.input.beginBuffering();
            $13 = state.pos;
            $3 = 7;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $8.end) {
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $19 = state.ok;
            if (!$19) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 50;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 4;
            break;
          case 6:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 7:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 8;
              break;
            }
            $3 = 9;
            break;
          case 8:
            if (!state.ok) {
              state.backtrack($13);
            }
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $2 = input.data.substring($12 - start, state.pos - start);
            }
            $3 = 6;
            break;
          case 9:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 9;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 49;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 8;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
  ///   / (v:Cut1 Cut1)
  ///   / (v:CutWithInner CutWithInner)
  ///   / (v:Eof Eof)
  ///   / (v:Expected Expected)
  ///   / (v:Indicate Indicate)
  ///   / (v:Literal0 Literal0)
  ///   / (v:Literal1 Literal1)
  ///   / (v:Literal2 Literal2)
  ///   / (v:Literal10 Literal10)
  ///   / (v:Literals Literals)
  ///   / (v:List List)
  ///   / (v:List1 List1)
  ///   / (v:MatchString MatchString)
  ///   / (v:Message Message)
  ///   / (v:NotPredicate NotPredicate)
  ///   / (v:NotPredicate2 NotPredicate2)
  ///   / (v:OneOrMore OneOrMore)
  ///   / (v:OneOrMoreLiteral OneOrMoreLiteral)
  ///   / (v:OrderedChoice2 OrderedChoice2)
  ///   / (v:OrderedChoice3 OrderedChoice3)
  ///   / (v:Optional Optional)
  ///   / (v:RepetitionMax RepetitionMax)
  ///   / (v:RepetitionMin RepetitionMin)
  ///   / (v:RepetitionMinMax RepetitionMinMax)
  ///   / (v:RepetitionN RepetitionN)
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
  ///   / (v:Tag Tag)
  ///   / (v:Verify Verify)
  ///   / (v:ZeroOrMore ZeroOrMore)
  ///   ;
  Object? parseStart(State<String> state) {
    Object? $0;
    // (v:AndPredicate AndPredicate)
    // v:AndPredicate AndPredicate
    final $3 = state.pos;
    List<Object?>? $2;
    // AndPredicate
    $2 = parseAndPredicate(state);
    if (state.ok) {
      // AndPredicate
      fastParseAndPredicate(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // (v:AnyCharacter AnyCharacter)
      // v:AnyCharacter AnyCharacter
      final $6 = state.pos;
      int? $5;
      // AnyCharacter
      $5 = parseAnyCharacter(state);
      if (state.ok) {
        // AnyCharacter
        fastParseAnyCharacter(state);
        if (state.ok) {
          $0 = $5;
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok && state.isRecoverable) {
        // (v:CharacterClass CharacterClass)
        // v:CharacterClass CharacterClass
        final $9 = state.pos;
        int? $8;
        // CharacterClass
        $8 = parseCharacterClass(state);
        if (state.ok) {
          // CharacterClass
          fastParseCharacterClass(state);
          if (state.ok) {
            $0 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok && state.isRecoverable) {
          // (v:CharacterClassChar32 CharacterClassChar32)
          // v:CharacterClassChar32 CharacterClassChar32
          final $12 = state.pos;
          int? $11;
          // CharacterClassChar32
          $11 = parseCharacterClassChar32(state);
          if (state.ok) {
            // CharacterClassChar32
            fastParseCharacterClassChar32(state);
            if (state.ok) {
              $0 = $11;
            }
          }
          if (!state.ok) {
            state.backtrack($12);
          }
          if (!state.ok && state.isRecoverable) {
            // (v:CharacterClassCharNegate CharacterClassCharNegate)
            // v:CharacterClassCharNegate CharacterClassCharNegate
            final $15 = state.pos;
            int? $14;
            // CharacterClassCharNegate
            $14 = parseCharacterClassCharNegate(state);
            if (state.ok) {
              // CharacterClassCharNegate
              fastParseCharacterClassCharNegate(state);
              if (state.ok) {
                $0 = $14;
              }
            }
            if (!state.ok) {
              state.backtrack($15);
            }
            if (!state.ok && state.isRecoverable) {
              // (v:CharacterClassCharNegate32 CharacterClassCharNegate32)
              // v:CharacterClassCharNegate32 CharacterClassCharNegate32
              final $18 = state.pos;
              int? $17;
              // CharacterClassCharNegate32
              $17 = parseCharacterClassCharNegate32(state);
              if (state.ok) {
                // CharacterClassCharNegate32
                fastParseCharacterClassCharNegate32(state);
                if (state.ok) {
                  $0 = $17;
                }
              }
              if (!state.ok) {
                state.backtrack($18);
              }
              if (!state.ok && state.isRecoverable) {
                // (v:CharacterClassRange32 CharacterClassRange32)
                // v:CharacterClassRange32 CharacterClassRange32
                final $21 = state.pos;
                int? $20;
                // CharacterClassRange32
                $20 = parseCharacterClassRange32(state);
                if (state.ok) {
                  // CharacterClassRange32
                  fastParseCharacterClassRange32(state);
                  if (state.ok) {
                    $0 = $20;
                  }
                }
                if (!state.ok) {
                  state.backtrack($21);
                }
                if (!state.ok && state.isRecoverable) {
                  // (v:Cut Cut)
                  // v:Cut Cut
                  final $24 = state.pos;
                  Object? $23;
                  // Cut
                  $23 = parseCut(state);
                  if (state.ok) {
                    // Cut
                    fastParseCut(state);
                    if (state.ok) {
                      $0 = $23;
                    }
                  }
                  if (!state.ok) {
                    state.backtrack($24);
                  }
                  if (!state.ok && state.isRecoverable) {
                    // (v:Cut1 Cut1)
                    // v:Cut1 Cut1
                    final $27 = state.pos;
                    Object? $26;
                    // Cut1
                    $26 = parseCut1(state);
                    if (state.ok) {
                      // Cut1
                      fastParseCut1(state);
                      if (state.ok) {
                        $0 = $26;
                      }
                    }
                    if (!state.ok) {
                      state.backtrack($27);
                    }
                    if (!state.ok && state.isRecoverable) {
                      // (v:CutWithInner CutWithInner)
                      // v:CutWithInner CutWithInner
                      final $30 = state.pos;
                      Object? $29;
                      // CutWithInner
                      $29 = parseCutWithInner(state);
                      if (state.ok) {
                        // CutWithInner
                        fastParseCutWithInner(state);
                        if (state.ok) {
                          $0 = $29;
                        }
                      }
                      if (!state.ok) {
                        state.backtrack($30);
                      }
                      if (!state.ok && state.isRecoverable) {
                        // (v:Eof Eof)
                        // v:Eof Eof
                        final $33 = state.pos;
                        List<Object?>? $32;
                        // Eof
                        $32 = parseEof(state);
                        if (state.ok) {
                          // Eof
                          fastParseEof(state);
                          if (state.ok) {
                            $0 = $32;
                          }
                        }
                        if (!state.ok) {
                          state.backtrack($33);
                        }
                        if (!state.ok && state.isRecoverable) {
                          // (v:Expected Expected)
                          // v:Expected Expected
                          final $36 = state.pos;
                          List<int>? $35;
                          // Expected
                          $35 = parseExpected(state);
                          if (state.ok) {
                            // Expected
                            fastParseExpected(state);
                            if (state.ok) {
                              $0 = $35;
                            }
                          }
                          if (!state.ok) {
                            state.backtrack($36);
                          }
                          if (!state.ok && state.isRecoverable) {
                            // (v:Indicate Indicate)
                            // v:Indicate Indicate
                            final $39 = state.pos;
                            List<Object?>? $38;
                            // Indicate
                            $38 = parseIndicate(state);
                            if (state.ok) {
                              // Indicate
                              fastParseIndicate(state);
                              if (state.ok) {
                                $0 = $38;
                              }
                            }
                            if (!state.ok) {
                              state.backtrack($39);
                            }
                            if (!state.ok && state.isRecoverable) {
                              // (v:Literal0 Literal0)
                              // v:Literal0 Literal0
                              final $42 = state.pos;
                              String? $41;
                              // Literal0
                              $41 = parseLiteral0(state);
                              if (state.ok) {
                                // Literal0
                                fastParseLiteral0(state);
                                if (state.ok) {
                                  $0 = $41;
                                }
                              }
                              if (!state.ok) {
                                state.backtrack($42);
                              }
                              if (!state.ok && state.isRecoverable) {
                                // (v:Literal1 Literal1)
                                // v:Literal1 Literal1
                                final $45 = state.pos;
                                String? $44;
                                // Literal1
                                $44 = parseLiteral1(state);
                                if (state.ok) {
                                  // Literal1
                                  fastParseLiteral1(state);
                                  if (state.ok) {
                                    $0 = $44;
                                  }
                                }
                                if (!state.ok) {
                                  state.backtrack($45);
                                }
                                if (!state.ok && state.isRecoverable) {
                                  // (v:Literal2 Literal2)
                                  // v:Literal2 Literal2
                                  final $48 = state.pos;
                                  String? $47;
                                  // Literal2
                                  $47 = parseLiteral2(state);
                                  if (state.ok) {
                                    // Literal2
                                    fastParseLiteral2(state);
                                    if (state.ok) {
                                      $0 = $47;
                                    }
                                  }
                                  if (!state.ok) {
                                    state.backtrack($48);
                                  }
                                  if (!state.ok && state.isRecoverable) {
                                    // (v:Literal10 Literal10)
                                    // v:Literal10 Literal10
                                    final $51 = state.pos;
                                    String? $50;
                                    // Literal10
                                    $50 = parseLiteral10(state);
                                    if (state.ok) {
                                      // Literal10
                                      fastParseLiteral10(state);
                                      if (state.ok) {
                                        $0 = $50;
                                      }
                                    }
                                    if (!state.ok) {
                                      state.backtrack($51);
                                    }
                                    if (!state.ok && state.isRecoverable) {
                                      // (v:Literals Literals)
                                      // v:Literals Literals
                                      final $54 = state.pos;
                                      String? $53;
                                      // Literals
                                      $53 = parseLiterals(state);
                                      if (state.ok) {
                                        // Literals
                                        fastParseLiterals(state);
                                        if (state.ok) {
                                          $0 = $53;
                                        }
                                      }
                                      if (!state.ok) {
                                        state.backtrack($54);
                                      }
                                      if (!state.ok && state.isRecoverable) {
                                        // (v:List List)
                                        // v:List List
                                        final $57 = state.pos;
                                        List<int>? $56;
                                        // List
                                        $56 = parseList(state);
                                        if (state.ok) {
                                          // List
                                          fastParseList(state);
                                          if (state.ok) {
                                            $0 = $56;
                                          }
                                        }
                                        if (!state.ok) {
                                          state.backtrack($57);
                                        }
                                        if (!state.ok && state.isRecoverable) {
                                          // (v:List1 List1)
                                          // v:List1 List1
                                          final $60 = state.pos;
                                          List<int>? $59;
                                          // List1
                                          $59 = parseList1(state);
                                          if (state.ok) {
                                            // List1
                                            fastParseList1(state);
                                            if (state.ok) {
                                              $0 = $59;
                                            }
                                          }
                                          if (!state.ok) {
                                            state.backtrack($60);
                                          }
                                          if (!state.ok &&
                                              state.isRecoverable) {
                                            // (v:MatchString MatchString)
                                            // v:MatchString MatchString
                                            final $63 = state.pos;
                                            String? $62;
                                            // MatchString
                                            $62 = parseMatchString(state);
                                            if (state.ok) {
                                              // MatchString
                                              fastParseMatchString(state);
                                              if (state.ok) {
                                                $0 = $62;
                                              }
                                            }
                                            if (!state.ok) {
                                              state.backtrack($63);
                                            }
                                            if (!state.ok &&
                                                state.isRecoverable) {
                                              // (v:Message Message)
                                              // v:Message Message
                                              final $66 = state.pos;
                                              List<Object?>? $65;
                                              // Message
                                              $65 = parseMessage(state);
                                              if (state.ok) {
                                                // Message
                                                fastParseMessage(state);
                                                if (state.ok) {
                                                  $0 = $65;
                                                }
                                              }
                                              if (!state.ok) {
                                                state.backtrack($66);
                                              }
                                              if (!state.ok &&
                                                  state.isRecoverable) {
                                                // (v:NotPredicate NotPredicate)
                                                // v:NotPredicate NotPredicate
                                                final $69 = state.pos;
                                                List<Object?>? $68;
                                                // NotPredicate
                                                $68 = parseNotPredicate(state);
                                                if (state.ok) {
                                                  // NotPredicate
                                                  fastParseNotPredicate(state);
                                                  if (state.ok) {
                                                    $0 = $68;
                                                  }
                                                }
                                                if (!state.ok) {
                                                  state.backtrack($69);
                                                }
                                                if (!state.ok &&
                                                    state.isRecoverable) {
                                                  // (v:NotPredicate2 NotPredicate2)
                                                  // v:NotPredicate2 NotPredicate2
                                                  final $72 = state.pos;
                                                  List<Object?>? $71;
                                                  // NotPredicate2
                                                  $71 =
                                                      parseNotPredicate2(state);
                                                  if (state.ok) {
                                                    // NotPredicate2
                                                    fastParseNotPredicate2(
                                                        state);
                                                    if (state.ok) {
                                                      $0 = $71;
                                                    }
                                                  }
                                                  if (!state.ok) {
                                                    state.backtrack($72);
                                                  }
                                                  if (!state.ok &&
                                                      state.isRecoverable) {
                                                    // (v:OneOrMore OneOrMore)
                                                    // v:OneOrMore OneOrMore
                                                    final $75 = state.pos;
                                                    List<int>? $74;
                                                    // OneOrMore
                                                    $74 = parseOneOrMore(state);
                                                    if (state.ok) {
                                                      // OneOrMore
                                                      fastParseOneOrMore(state);
                                                      if (state.ok) {
                                                        $0 = $74;
                                                      }
                                                    }
                                                    if (!state.ok) {
                                                      state.backtrack($75);
                                                    }
                                                    if (!state.ok &&
                                                        state.isRecoverable) {
                                                      // (v:OneOrMoreLiteral OneOrMoreLiteral)
                                                      // v:OneOrMoreLiteral OneOrMoreLiteral
                                                      final $78 = state.pos;
                                                      List<String>? $77;
                                                      // OneOrMoreLiteral
                                                      $77 =
                                                          parseOneOrMoreLiteral(
                                                              state);
                                                      if (state.ok) {
                                                        // OneOrMoreLiteral
                                                        fastParseOneOrMoreLiteral(
                                                            state);
                                                        if (state.ok) {
                                                          $0 = $77;
                                                        }
                                                      }
                                                      if (!state.ok) {
                                                        state.backtrack($78);
                                                      }
                                                      if (!state.ok &&
                                                          state.isRecoverable) {
                                                        // (v:OrderedChoice2 OrderedChoice2)
                                                        // v:OrderedChoice2 OrderedChoice2
                                                        final $81 = state.pos;
                                                        int? $80;
                                                        // OrderedChoice2
                                                        $80 =
                                                            parseOrderedChoice2(
                                                                state);
                                                        if (state.ok) {
                                                          // OrderedChoice2
                                                          fastParseOrderedChoice2(
                                                              state);
                                                          if (state.ok) {
                                                            $0 = $80;
                                                          }
                                                        }
                                                        if (!state.ok) {
                                                          state.backtrack($81);
                                                        }
                                                        if (!state.ok &&
                                                            state
                                                                .isRecoverable) {
                                                          // (v:OrderedChoice3 OrderedChoice3)
                                                          // v:OrderedChoice3 OrderedChoice3
                                                          final $84 = state.pos;
                                                          int? $83;
                                                          // OrderedChoice3
                                                          $83 =
                                                              parseOrderedChoice3(
                                                                  state);
                                                          if (state.ok) {
                                                            // OrderedChoice3
                                                            fastParseOrderedChoice3(
                                                                state);
                                                            if (state.ok) {
                                                              $0 = $83;
                                                            }
                                                          }
                                                          if (!state.ok) {
                                                            state
                                                                .backtrack($84);
                                                          }
                                                          if (!state.ok &&
                                                              state
                                                                  .isRecoverable) {
                                                            // (v:Optional Optional)
                                                            // v:Optional Optional
                                                            final $87 =
                                                                state.pos;
                                                            List<Object?>? $86;
                                                            // Optional
                                                            $86 = parseOptional(
                                                                state);
                                                            if (state.ok) {
                                                              // Optional
                                                              fastParseOptional(
                                                                  state);
                                                              if (state.ok) {
                                                                $0 = $86;
                                                              }
                                                            }
                                                            if (!state.ok) {
                                                              state.backtrack(
                                                                  $87);
                                                            }
                                                            if (!state.ok &&
                                                                state
                                                                    .isRecoverable) {
                                                              // (v:RepetitionMax RepetitionMax)
                                                              // v:RepetitionMax RepetitionMax
                                                              final $90 =
                                                                  state.pos;
                                                              List<int>? $89;
                                                              // RepetitionMax
                                                              $89 =
                                                                  parseRepetitionMax(
                                                                      state);
                                                              if (state.ok) {
                                                                // RepetitionMax
                                                                fastParseRepetitionMax(
                                                                    state);
                                                                if (state.ok) {
                                                                  $0 = $89;
                                                                }
                                                              }
                                                              if (!state.ok) {
                                                                state.backtrack(
                                                                    $90);
                                                              }
                                                              if (!state.ok &&
                                                                  state
                                                                      .isRecoverable) {
                                                                // (v:RepetitionMin RepetitionMin)
                                                                // v:RepetitionMin RepetitionMin
                                                                final $93 =
                                                                    state.pos;
                                                                List<int>? $92;
                                                                // RepetitionMin
                                                                $92 =
                                                                    parseRepetitionMin(
                                                                        state);
                                                                if (state.ok) {
                                                                  // RepetitionMin
                                                                  fastParseRepetitionMin(
                                                                      state);
                                                                  if (state
                                                                      .ok) {
                                                                    $0 = $92;
                                                                  }
                                                                }
                                                                if (!state.ok) {
                                                                  state
                                                                      .backtrack(
                                                                          $93);
                                                                }
                                                                if (!state.ok &&
                                                                    state
                                                                        .isRecoverable) {
                                                                  // (v:RepetitionMinMax RepetitionMinMax)
                                                                  // v:RepetitionMinMax RepetitionMinMax
                                                                  final $96 =
                                                                      state.pos;
                                                                  List<int>?
                                                                      $95;
                                                                  // RepetitionMinMax
                                                                  $95 =
                                                                      parseRepetitionMinMax(
                                                                          state);
                                                                  if (state
                                                                      .ok) {
                                                                    // RepetitionMinMax
                                                                    fastParseRepetitionMinMax(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      $0 = $95;
                                                                    }
                                                                  }
                                                                  if (!state
                                                                      .ok) {
                                                                    state.backtrack(
                                                                        $96);
                                                                  }
                                                                  if (!state
                                                                          .ok &&
                                                                      state
                                                                          .isRecoverable) {
                                                                    // (v:RepetitionN RepetitionN)
                                                                    // v:RepetitionN RepetitionN
                                                                    final $99 =
                                                                        state
                                                                            .pos;
                                                                    List<int>?
                                                                        $98;
                                                                    // RepetitionN
                                                                    $98 = parseRepetitionN(
                                                                        state);
                                                                    if (state
                                                                        .ok) {
                                                                      // RepetitionN
                                                                      fastParseRepetitionN(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        $0 =
                                                                            $98;
                                                                      }
                                                                    }
                                                                    if (!state
                                                                        .ok) {
                                                                      state.backtrack(
                                                                          $99);
                                                                    }
                                                                    if (!state
                                                                            .ok &&
                                                                        state
                                                                            .isRecoverable) {
                                                                      // (v:Sequence1 Sequence1)
                                                                      // v:Sequence1 Sequence1
                                                                      final $102 =
                                                                          state
                                                                              .pos;
                                                                      int? $101;
                                                                      // Sequence1
                                                                      $101 = parseSequence1(
                                                                          state);
                                                                      if (state
                                                                          .ok) {
                                                                        // Sequence1
                                                                        fastParseSequence1(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          $0 =
                                                                              $101;
                                                                        }
                                                                      }
                                                                      if (!state
                                                                          .ok) {
                                                                        state.backtrack(
                                                                            $102);
                                                                      }
                                                                      if (!state
                                                                              .ok &&
                                                                          state
                                                                              .isRecoverable) {
                                                                        // (v:Sequence1WithAction Sequence1WithAction)
                                                                        // v:Sequence1WithAction Sequence1WithAction
                                                                        final $105 =
                                                                            state.pos;
                                                                        int?
                                                                            $104;
                                                                        // Sequence1WithAction
                                                                        $104 = parseSequence1WithAction(
                                                                            state);
                                                                        if (state
                                                                            .ok) {
                                                                          // Sequence1WithAction
                                                                          fastParseSequence1WithAction(
                                                                              state);
                                                                          if (state
                                                                              .ok) {
                                                                            $0 =
                                                                                $104;
                                                                          }
                                                                        }
                                                                        if (!state
                                                                            .ok) {
                                                                          state.backtrack(
                                                                              $105);
                                                                        }
                                                                        if (!state.ok &&
                                                                            state.isRecoverable) {
                                                                          // (v:Sequence1WithVariable Sequence1WithVariable)
                                                                          // v:Sequence1WithVariable Sequence1WithVariable
                                                                          final $108 =
                                                                              state.pos;
                                                                          int?
                                                                              $107;
                                                                          // Sequence1WithVariable
                                                                          $107 =
                                                                              parseSequence1WithVariable(state);
                                                                          if (state
                                                                              .ok) {
                                                                            // Sequence1WithVariable
                                                                            fastParseSequence1WithVariable(state);
                                                                            if (state.ok) {
                                                                              $0 = $107;
                                                                            }
                                                                          }
                                                                          if (!state
                                                                              .ok) {
                                                                            state.backtrack($108);
                                                                          }
                                                                          if (!state.ok &&
                                                                              state.isRecoverable) {
                                                                            // (v:Sequence1WithVariable Sequence1WithVariable)
                                                                            // v:Sequence1WithVariable Sequence1WithVariable
                                                                            final $111 =
                                                                                state.pos;
                                                                            int?
                                                                                $110;
                                                                            // Sequence1WithVariable
                                                                            $110 =
                                                                                parseSequence1WithVariable(state);
                                                                            if (state.ok) {
                                                                              // Sequence1WithVariable
                                                                              fastParseSequence1WithVariable(state);
                                                                              if (state.ok) {
                                                                                $0 = $110;
                                                                              }
                                                                            }
                                                                            if (!state.ok) {
                                                                              state.backtrack($111);
                                                                            }
                                                                            if (!state.ok &&
                                                                                state.isRecoverable) {
                                                                              // (v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction)
                                                                              // v:Sequence1WithVariableWithAction Sequence1WithVariableWithAction
                                                                              final $114 = state.pos;
                                                                              int? $113;
                                                                              // Sequence1WithVariableWithAction
                                                                              $113 = parseSequence1WithVariableWithAction(state);
                                                                              if (state.ok) {
                                                                                // Sequence1WithVariableWithAction
                                                                                fastParseSequence1WithVariableWithAction(state);
                                                                                if (state.ok) {
                                                                                  $0 = $113;
                                                                                }
                                                                              }
                                                                              if (!state.ok) {
                                                                                state.backtrack($114);
                                                                              }
                                                                              if (!state.ok && state.isRecoverable) {
                                                                                // (v:Sequence2 Sequence2)
                                                                                // v:Sequence2 Sequence2
                                                                                final $117 = state.pos;
                                                                                List<Object?>? $116;
                                                                                // Sequence2
                                                                                $116 = parseSequence2(state);
                                                                                if (state.ok) {
                                                                                  // Sequence2
                                                                                  fastParseSequence2(state);
                                                                                  if (state.ok) {
                                                                                    $0 = $116;
                                                                                  }
                                                                                }
                                                                                if (!state.ok) {
                                                                                  state.backtrack($117);
                                                                                }
                                                                                if (!state.ok && state.isRecoverable) {
                                                                                  // (v:Sequence2WithAction Sequence2WithAction)
                                                                                  // v:Sequence2WithAction Sequence2WithAction
                                                                                  final $120 = state.pos;
                                                                                  int? $119;
                                                                                  // Sequence2WithAction
                                                                                  $119 = parseSequence2WithAction(state);
                                                                                  if (state.ok) {
                                                                                    // Sequence2WithAction
                                                                                    fastParseSequence2WithAction(state);
                                                                                    if (state.ok) {
                                                                                      $0 = $119;
                                                                                    }
                                                                                  }
                                                                                  if (!state.ok) {
                                                                                    state.backtrack($120);
                                                                                  }
                                                                                  if (!state.ok && state.isRecoverable) {
                                                                                    // (v:Sequence2WithVariable Sequence2WithVariable)
                                                                                    // v:Sequence2WithVariable Sequence2WithVariable
                                                                                    final $123 = state.pos;
                                                                                    int? $122;
                                                                                    // Sequence2WithVariable
                                                                                    $122 = parseSequence2WithVariable(state);
                                                                                    if (state.ok) {
                                                                                      // Sequence2WithVariable
                                                                                      fastParseSequence2WithVariable(state);
                                                                                      if (state.ok) {
                                                                                        $0 = $122;
                                                                                      }
                                                                                    }
                                                                                    if (!state.ok) {
                                                                                      state.backtrack($123);
                                                                                    }
                                                                                    if (!state.ok && state.isRecoverable) {
                                                                                      // (v:Sequence2WithVariables Sequence2WithVariables)
                                                                                      // v:Sequence2WithVariables Sequence2WithVariables
                                                                                      final $126 = state.pos;
                                                                                      ({
                                                                                        int v1,
                                                                                        int v2
                                                                                      })? $125;
                                                                                      // Sequence2WithVariables
                                                                                      $125 = parseSequence2WithVariables(state);
                                                                                      if (state.ok) {
                                                                                        // Sequence2WithVariables
                                                                                        fastParseSequence2WithVariables(state);
                                                                                        if (state.ok) {
                                                                                          $0 = $125;
                                                                                        }
                                                                                      }
                                                                                      if (!state.ok) {
                                                                                        state.backtrack($126);
                                                                                      }
                                                                                      if (!state.ok && state.isRecoverable) {
                                                                                        // (v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction)
                                                                                        // v:Sequence2WithVariableWithAction Sequence2WithVariableWithAction
                                                                                        final $129 = state.pos;
                                                                                        int? $128;
                                                                                        // Sequence2WithVariableWithAction
                                                                                        $128 = parseSequence2WithVariableWithAction(state);
                                                                                        if (state.ok) {
                                                                                          // Sequence2WithVariableWithAction
                                                                                          fastParseSequence2WithVariableWithAction(state);
                                                                                          if (state.ok) {
                                                                                            $0 = $128;
                                                                                          }
                                                                                        }
                                                                                        if (!state.ok) {
                                                                                          state.backtrack($129);
                                                                                        }
                                                                                        if (!state.ok && state.isRecoverable) {
                                                                                          // (v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction)
                                                                                          // v:Sequence2WithVariablesWithAction Sequence2WithVariablesWithAction
                                                                                          final $132 = state.pos;
                                                                                          int? $131;
                                                                                          // Sequence2WithVariablesWithAction
                                                                                          $131 = parseSequence2WithVariablesWithAction(state);
                                                                                          if (state.ok) {
                                                                                            // Sequence2WithVariablesWithAction
                                                                                            fastParseSequence2WithVariablesWithAction(state);
                                                                                            if (state.ok) {
                                                                                              $0 = $131;
                                                                                            }
                                                                                          }
                                                                                          if (!state.ok) {
                                                                                            state.backtrack($132);
                                                                                          }
                                                                                          if (!state.ok && state.isRecoverable) {
                                                                                            // (v:Slice Slice)
                                                                                            // v:Slice Slice
                                                                                            final $135 = state.pos;
                                                                                            String? $134;
                                                                                            // Slice
                                                                                            $134 = parseSlice(state);
                                                                                            if (state.ok) {
                                                                                              // Slice
                                                                                              fastParseSlice(state);
                                                                                              if (state.ok) {
                                                                                                $0 = $134;
                                                                                              }
                                                                                            }
                                                                                            if (!state.ok) {
                                                                                              state.backtrack($135);
                                                                                            }
                                                                                            if (!state.ok && state.isRecoverable) {
                                                                                              // (v:StringChars StringChars)
                                                                                              // v:StringChars StringChars
                                                                                              final $138 = state.pos;
                                                                                              String? $137;
                                                                                              // StringChars
                                                                                              $137 = parseStringChars(state);
                                                                                              if (state.ok) {
                                                                                                // StringChars
                                                                                                fastParseStringChars(state);
                                                                                                if (state.ok) {
                                                                                                  $0 = $137;
                                                                                                }
                                                                                              }
                                                                                              if (!state.ok) {
                                                                                                state.backtrack($138);
                                                                                              }
                                                                                              if (!state.ok && state.isRecoverable) {
                                                                                                // (v:Tag Tag)
                                                                                                // v:Tag Tag
                                                                                                final $141 = state.pos;
                                                                                                String? $140;
                                                                                                // Tag
                                                                                                $140 = parseTag(state);
                                                                                                if (state.ok) {
                                                                                                  // Tag
                                                                                                  fastParseTag(state);
                                                                                                  if (state.ok) {
                                                                                                    $0 = $140;
                                                                                                  }
                                                                                                }
                                                                                                if (!state.ok) {
                                                                                                  state.backtrack($141);
                                                                                                }
                                                                                                if (!state.ok && state.isRecoverable) {
                                                                                                  // (v:Verify Verify)
                                                                                                  // v:Verify Verify
                                                                                                  final $144 = state.pos;
                                                                                                  Object? $143;
                                                                                                  // Verify
                                                                                                  $143 = parseVerify(state);
                                                                                                  if (state.ok) {
                                                                                                    // Verify
                                                                                                    fastParseVerify(state);
                                                                                                    if (state.ok) {
                                                                                                      $0 = $143;
                                                                                                    }
                                                                                                  }
                                                                                                  if (!state.ok) {
                                                                                                    state.backtrack($144);
                                                                                                  }
                                                                                                  if (!state.ok && state.isRecoverable) {
                                                                                                    // (v:ZeroOrMore ZeroOrMore)
                                                                                                    // v:ZeroOrMore ZeroOrMore
                                                                                                    final $147 = state.pos;
                                                                                                    List<int>? $146;
                                                                                                    // ZeroOrMore
                                                                                                    $146 = parseZeroOrMore(state);
                                                                                                    if (state.ok) {
                                                                                                      // ZeroOrMore
                                                                                                      fastParseZeroOrMore(state);
                                                                                                      if (state.ok) {
                                                                                                        $0 = $146;
                                                                                                      }
                                                                                                    }
                                                                                                    if (!state.ok) {
                                                                                                      state.backtrack($147);
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
  ///   / (v:Cut1 Cut1)
  ///   / (v:CutWithInner CutWithInner)
  ///   / (v:Eof Eof)
  ///   / (v:Expected Expected)
  ///   / (v:Indicate Indicate)
  ///   / (v:Literal0 Literal0)
  ///   / (v:Literal1 Literal1)
  ///   / (v:Literal2 Literal2)
  ///   / (v:Literal10 Literal10)
  ///   / (v:Literals Literals)
  ///   / (v:List List)
  ///   / (v:List1 List1)
  ///   / (v:MatchString MatchString)
  ///   / (v:Message Message)
  ///   / (v:NotPredicate NotPredicate)
  ///   / (v:NotPredicate2 NotPredicate2)
  ///   / (v:OneOrMore OneOrMore)
  ///   / (v:OneOrMoreLiteral OneOrMoreLiteral)
  ///   / (v:OrderedChoice2 OrderedChoice2)
  ///   / (v:OrderedChoice3 OrderedChoice3)
  ///   / (v:Optional Optional)
  ///   / (v:RepetitionMax RepetitionMax)
  ///   / (v:RepetitionMin RepetitionMin)
  ///   / (v:RepetitionMinMax RepetitionMinMax)
  ///   / (v:RepetitionN RepetitionN)
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
  ///   / (v:Tag Tag)
  ///   / (v:Verify Verify)
  ///   / (v:ZeroOrMore ZeroOrMore)
  ///   ;
  AsyncResult<Object?> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    var $3 = 0;
    late int $5;
    List<Object?>? $4;
    late AsyncResult<List<Object?>> $6;
    late AsyncResult<Object?> $8;
    late int $11;
    int? $10;
    late AsyncResult<int> $12;
    late AsyncResult<Object?> $14;
    late int $17;
    int? $16;
    late AsyncResult<int> $18;
    late AsyncResult<Object?> $20;
    late int $23;
    int? $22;
    late AsyncResult<int> $24;
    late AsyncResult<Object?> $26;
    late int $29;
    int? $28;
    late AsyncResult<int> $30;
    late AsyncResult<Object?> $32;
    late int $35;
    int? $34;
    late AsyncResult<int> $36;
    late AsyncResult<Object?> $38;
    late int $41;
    int? $40;
    late AsyncResult<int> $42;
    late AsyncResult<Object?> $44;
    late int $47;
    Object? $46;
    late AsyncResult<Object?> $48;
    late AsyncResult<Object?> $50;
    late int $53;
    Object? $52;
    late AsyncResult<Object?> $54;
    late AsyncResult<Object?> $56;
    late int $59;
    Object? $58;
    late AsyncResult<Object?> $60;
    late AsyncResult<Object?> $62;
    late int $65;
    List<Object?>? $64;
    late AsyncResult<List<Object?>> $66;
    late AsyncResult<Object?> $68;
    late int $71;
    List<int>? $70;
    late AsyncResult<List<int>> $72;
    late AsyncResult<Object?> $74;
    late int $77;
    List<Object?>? $76;
    late AsyncResult<List<Object?>> $78;
    late AsyncResult<Object?> $80;
    late int $83;
    String? $82;
    late AsyncResult<String> $84;
    late AsyncResult<Object?> $86;
    late int $89;
    String? $88;
    late AsyncResult<String> $90;
    late AsyncResult<Object?> $92;
    late int $95;
    String? $94;
    late AsyncResult<String> $96;
    late AsyncResult<Object?> $98;
    late int $101;
    String? $100;
    late AsyncResult<String> $102;
    late AsyncResult<Object?> $104;
    late int $107;
    String? $106;
    late AsyncResult<String> $108;
    late AsyncResult<Object?> $110;
    late int $113;
    List<int>? $112;
    late AsyncResult<List<int>> $114;
    late AsyncResult<Object?> $116;
    late int $119;
    List<int>? $118;
    late AsyncResult<List<int>> $120;
    late AsyncResult<Object?> $122;
    late int $125;
    String? $124;
    late AsyncResult<String> $126;
    late AsyncResult<Object?> $128;
    late int $131;
    List<Object?>? $130;
    late AsyncResult<List<Object?>> $132;
    late AsyncResult<Object?> $134;
    late int $137;
    List<Object?>? $136;
    late AsyncResult<List<Object?>> $138;
    late AsyncResult<Object?> $140;
    late int $143;
    List<Object?>? $142;
    late AsyncResult<List<Object?>> $144;
    late AsyncResult<Object?> $146;
    late int $149;
    List<int>? $148;
    late AsyncResult<List<int>> $150;
    late AsyncResult<Object?> $152;
    late int $155;
    List<String>? $154;
    late AsyncResult<List<String>> $156;
    late AsyncResult<Object?> $158;
    late int $161;
    int? $160;
    late AsyncResult<int> $162;
    late AsyncResult<Object?> $164;
    late int $167;
    int? $166;
    late AsyncResult<int> $168;
    late AsyncResult<Object?> $170;
    late int $173;
    List<Object?>? $172;
    late AsyncResult<List<Object?>> $174;
    late AsyncResult<Object?> $176;
    late int $179;
    List<int>? $178;
    late AsyncResult<List<int>> $180;
    late AsyncResult<Object?> $182;
    late int $185;
    List<int>? $184;
    late AsyncResult<List<int>> $186;
    late AsyncResult<Object?> $188;
    late int $191;
    List<int>? $190;
    late AsyncResult<List<int>> $192;
    late AsyncResult<Object?> $194;
    late int $197;
    List<int>? $196;
    late AsyncResult<List<int>> $198;
    late AsyncResult<Object?> $200;
    late int $203;
    int? $202;
    late AsyncResult<int> $204;
    late AsyncResult<Object?> $206;
    late int $209;
    int? $208;
    late AsyncResult<int> $210;
    late AsyncResult<Object?> $212;
    late int $215;
    int? $214;
    late AsyncResult<int> $216;
    late AsyncResult<Object?> $218;
    late int $221;
    int? $220;
    late AsyncResult<int> $222;
    late AsyncResult<Object?> $224;
    late int $227;
    int? $226;
    late AsyncResult<int> $228;
    late AsyncResult<Object?> $230;
    late int $233;
    List<Object?>? $232;
    late AsyncResult<List<Object?>> $234;
    late AsyncResult<Object?> $236;
    late int $239;
    int? $238;
    late AsyncResult<int> $240;
    late AsyncResult<Object?> $242;
    late int $245;
    int? $244;
    late AsyncResult<int> $246;
    late AsyncResult<Object?> $248;
    late int $251;
    ({int v1, int v2})? $250;
    late AsyncResult<({int v1, int v2})> $252;
    late AsyncResult<Object?> $254;
    late int $257;
    int? $256;
    late AsyncResult<int> $258;
    late AsyncResult<Object?> $260;
    late int $263;
    int? $262;
    late AsyncResult<int> $264;
    late AsyncResult<Object?> $266;
    late int $269;
    String? $268;
    late AsyncResult<String> $270;
    late AsyncResult<Object?> $272;
    late int $275;
    String? $274;
    late AsyncResult<String> $276;
    late AsyncResult<Object?> $278;
    late int $281;
    String? $280;
    late AsyncResult<String> $282;
    late AsyncResult<Object?> $284;
    late int $287;
    Object? $286;
    late AsyncResult<Object?> $288;
    late AsyncResult<Object?> $290;
    late int $293;
    List<int>? $292;
    late AsyncResult<List<int>> $294;
    late AsyncResult<Object?> $296;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $6 = parseAndPredicate$Async(state);
            if (!$6.isComplete) {
              $6.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $6.value;
            final $298 = state.ok;
            if (!$298) {
              $3 = 2;
              break;
            }
            $8 = fastParseAndPredicate$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            final $299 = !state.ok && state.isRecoverable;
            if (!$299) {
              $3 = 4;
              break;
            }
            $11 = state.pos;
            $12 = parseAnyCharacter$Async(state);
            if (!$12.isComplete) {
              $12.onComplete = $1;
              $3 = 5;
              return;
            }
            $3 = 5;
            break;
          case 3:
            if (state.ok) {
              $2 = $4;
            }
            $3 = 2;
            break;
          case 4:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 5:
            $10 = $12.value;
            final $300 = state.ok;
            if (!$300) {
              $3 = 6;
              break;
            }
            $14 = fastParseAnyCharacter$Async(state);
            if (!$14.isComplete) {
              $14.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($11);
            }
            final $301 = !state.ok && state.isRecoverable;
            if (!$301) {
              $3 = 8;
              break;
            }
            $17 = state.pos;
            $18 = parseCharacterClass$Async(state);
            if (!$18.isComplete) {
              $18.onComplete = $1;
              $3 = 9;
              return;
            }
            $3 = 9;
            break;
          case 7:
            if (state.ok) {
              $2 = $10;
            }
            $3 = 6;
            break;
          case 8:
            $3 = 4;
            break;
          case 9:
            $16 = $18.value;
            final $302 = state.ok;
            if (!$302) {
              $3 = 10;
              break;
            }
            $20 = fastParseCharacterClass$Async(state);
            if (!$20.isComplete) {
              $20.onComplete = $1;
              $3 = 11;
              return;
            }
            $3 = 11;
            break;
          case 10:
            if (!state.ok) {
              state.backtrack($17);
            }
            final $303 = !state.ok && state.isRecoverable;
            if (!$303) {
              $3 = 12;
              break;
            }
            $23 = state.pos;
            $24 = parseCharacterClassChar32$Async(state);
            if (!$24.isComplete) {
              $24.onComplete = $1;
              $3 = 13;
              return;
            }
            $3 = 13;
            break;
          case 11:
            if (state.ok) {
              $2 = $16;
            }
            $3 = 10;
            break;
          case 12:
            $3 = 8;
            break;
          case 13:
            $22 = $24.value;
            final $304 = state.ok;
            if (!$304) {
              $3 = 14;
              break;
            }
            $26 = fastParseCharacterClassChar32$Async(state);
            if (!$26.isComplete) {
              $26.onComplete = $1;
              $3 = 15;
              return;
            }
            $3 = 15;
            break;
          case 14:
            if (!state.ok) {
              state.backtrack($23);
            }
            final $305 = !state.ok && state.isRecoverable;
            if (!$305) {
              $3 = 16;
              break;
            }
            $29 = state.pos;
            $30 = parseCharacterClassCharNegate$Async(state);
            if (!$30.isComplete) {
              $30.onComplete = $1;
              $3 = 17;
              return;
            }
            $3 = 17;
            break;
          case 15:
            if (state.ok) {
              $2 = $22;
            }
            $3 = 14;
            break;
          case 16:
            $3 = 12;
            break;
          case 17:
            $28 = $30.value;
            final $306 = state.ok;
            if (!$306) {
              $3 = 18;
              break;
            }
            $32 = fastParseCharacterClassCharNegate$Async(state);
            if (!$32.isComplete) {
              $32.onComplete = $1;
              $3 = 19;
              return;
            }
            $3 = 19;
            break;
          case 18:
            if (!state.ok) {
              state.backtrack($29);
            }
            final $307 = !state.ok && state.isRecoverable;
            if (!$307) {
              $3 = 20;
              break;
            }
            $35 = state.pos;
            $36 = parseCharacterClassCharNegate32$Async(state);
            if (!$36.isComplete) {
              $36.onComplete = $1;
              $3 = 21;
              return;
            }
            $3 = 21;
            break;
          case 19:
            if (state.ok) {
              $2 = $28;
            }
            $3 = 18;
            break;
          case 20:
            $3 = 16;
            break;
          case 21:
            $34 = $36.value;
            final $308 = state.ok;
            if (!$308) {
              $3 = 22;
              break;
            }
            $38 = fastParseCharacterClassCharNegate32$Async(state);
            if (!$38.isComplete) {
              $38.onComplete = $1;
              $3 = 23;
              return;
            }
            $3 = 23;
            break;
          case 22:
            if (!state.ok) {
              state.backtrack($35);
            }
            final $309 = !state.ok && state.isRecoverable;
            if (!$309) {
              $3 = 24;
              break;
            }
            $41 = state.pos;
            $42 = parseCharacterClassRange32$Async(state);
            if (!$42.isComplete) {
              $42.onComplete = $1;
              $3 = 25;
              return;
            }
            $3 = 25;
            break;
          case 23:
            if (state.ok) {
              $2 = $34;
            }
            $3 = 22;
            break;
          case 24:
            $3 = 20;
            break;
          case 25:
            $40 = $42.value;
            final $310 = state.ok;
            if (!$310) {
              $3 = 26;
              break;
            }
            $44 = fastParseCharacterClassRange32$Async(state);
            if (!$44.isComplete) {
              $44.onComplete = $1;
              $3 = 27;
              return;
            }
            $3 = 27;
            break;
          case 26:
            if (!state.ok) {
              state.backtrack($41);
            }
            final $311 = !state.ok && state.isRecoverable;
            if (!$311) {
              $3 = 28;
              break;
            }
            state.input.beginBuffering();
            $47 = state.pos;
            $48 = parseCut$Async(state);
            if (!$48.isComplete) {
              $48.onComplete = $1;
              $3 = 29;
              return;
            }
            $3 = 29;
            break;
          case 27:
            if (state.ok) {
              $2 = $40;
            }
            $3 = 26;
            break;
          case 28:
            $3 = 24;
            break;
          case 29:
            $46 = $48.value;
            final $312 = state.ok;
            if (!$312) {
              $3 = 30;
              break;
            }
            $50 = fastParseCut$Async(state);
            if (!$50.isComplete) {
              $50.onComplete = $1;
              $3 = 31;
              return;
            }
            $3 = 31;
            break;
          case 30:
            if (!state.ok) {
              state.backtrack($47);
            }
            state.input.endBuffering();
            final $313 = !state.ok && state.isRecoverable;
            if (!$313) {
              $3 = 32;
              break;
            }
            state.input.beginBuffering();
            $53 = state.pos;
            $54 = parseCut1$Async(state);
            if (!$54.isComplete) {
              $54.onComplete = $1;
              $3 = 33;
              return;
            }
            $3 = 33;
            break;
          case 31:
            if (state.ok) {
              $2 = $46;
            }
            $3 = 30;
            break;
          case 32:
            $3 = 28;
            break;
          case 33:
            $52 = $54.value;
            final $314 = state.ok;
            if (!$314) {
              $3 = 34;
              break;
            }
            $56 = fastParseCut1$Async(state);
            if (!$56.isComplete) {
              $56.onComplete = $1;
              $3 = 35;
              return;
            }
            $3 = 35;
            break;
          case 34:
            if (!state.ok) {
              state.backtrack($53);
            }
            state.input.endBuffering();
            final $315 = !state.ok && state.isRecoverable;
            if (!$315) {
              $3 = 36;
              break;
            }
            state.input.beginBuffering();
            $59 = state.pos;
            $60 = parseCutWithInner$Async(state);
            if (!$60.isComplete) {
              $60.onComplete = $1;
              $3 = 37;
              return;
            }
            $3 = 37;
            break;
          case 35:
            if (state.ok) {
              $2 = $52;
            }
            $3 = 34;
            break;
          case 36:
            $3 = 32;
            break;
          case 37:
            $58 = $60.value;
            final $316 = state.ok;
            if (!$316) {
              $3 = 38;
              break;
            }
            $62 = fastParseCutWithInner$Async(state);
            if (!$62.isComplete) {
              $62.onComplete = $1;
              $3 = 39;
              return;
            }
            $3 = 39;
            break;
          case 38:
            if (!state.ok) {
              state.backtrack($59);
            }
            state.input.endBuffering();
            final $317 = !state.ok && state.isRecoverable;
            if (!$317) {
              $3 = 40;
              break;
            }
            $65 = state.pos;
            $66 = parseEof$Async(state);
            if (!$66.isComplete) {
              $66.onComplete = $1;
              $3 = 41;
              return;
            }
            $3 = 41;
            break;
          case 39:
            if (state.ok) {
              $2 = $58;
            }
            $3 = 38;
            break;
          case 40:
            $3 = 36;
            break;
          case 41:
            $64 = $66.value;
            final $318 = state.ok;
            if (!$318) {
              $3 = 42;
              break;
            }
            $68 = fastParseEof$Async(state);
            if (!$68.isComplete) {
              $68.onComplete = $1;
              $3 = 43;
              return;
            }
            $3 = 43;
            break;
          case 42:
            if (!state.ok) {
              state.backtrack($65);
            }
            final $319 = !state.ok && state.isRecoverable;
            if (!$319) {
              $3 = 44;
              break;
            }
            $71 = state.pos;
            $72 = parseExpected$Async(state);
            if (!$72.isComplete) {
              $72.onComplete = $1;
              $3 = 45;
              return;
            }
            $3 = 45;
            break;
          case 43:
            if (state.ok) {
              $2 = $64;
            }
            $3 = 42;
            break;
          case 44:
            $3 = 40;
            break;
          case 45:
            $70 = $72.value;
            final $320 = state.ok;
            if (!$320) {
              $3 = 46;
              break;
            }
            $74 = fastParseExpected$Async(state);
            if (!$74.isComplete) {
              $74.onComplete = $1;
              $3 = 47;
              return;
            }
            $3 = 47;
            break;
          case 46:
            if (!state.ok) {
              state.backtrack($71);
            }
            final $321 = !state.ok && state.isRecoverable;
            if (!$321) {
              $3 = 48;
              break;
            }
            $77 = state.pos;
            $78 = parseIndicate$Async(state);
            if (!$78.isComplete) {
              $78.onComplete = $1;
              $3 = 49;
              return;
            }
            $3 = 49;
            break;
          case 47:
            if (state.ok) {
              $2 = $70;
            }
            $3 = 46;
            break;
          case 48:
            $3 = 44;
            break;
          case 49:
            $76 = $78.value;
            final $322 = state.ok;
            if (!$322) {
              $3 = 50;
              break;
            }
            $80 = fastParseIndicate$Async(state);
            if (!$80.isComplete) {
              $80.onComplete = $1;
              $3 = 51;
              return;
            }
            $3 = 51;
            break;
          case 50:
            if (!state.ok) {
              state.backtrack($77);
            }
            final $323 = !state.ok && state.isRecoverable;
            if (!$323) {
              $3 = 52;
              break;
            }
            $83 = state.pos;
            $84 = parseLiteral0$Async(state);
            if (!$84.isComplete) {
              $84.onComplete = $1;
              $3 = 53;
              return;
            }
            $3 = 53;
            break;
          case 51:
            if (state.ok) {
              $2 = $76;
            }
            $3 = 50;
            break;
          case 52:
            $3 = 48;
            break;
          case 53:
            $82 = $84.value;
            final $324 = state.ok;
            if (!$324) {
              $3 = 54;
              break;
            }
            $86 = fastParseLiteral0$Async(state);
            if (!$86.isComplete) {
              $86.onComplete = $1;
              $3 = 55;
              return;
            }
            $3 = 55;
            break;
          case 54:
            if (!state.ok) {
              state.backtrack($83);
            }
            final $325 = !state.ok && state.isRecoverable;
            if (!$325) {
              $3 = 56;
              break;
            }
            $89 = state.pos;
            $90 = parseLiteral1$Async(state);
            if (!$90.isComplete) {
              $90.onComplete = $1;
              $3 = 57;
              return;
            }
            $3 = 57;
            break;
          case 55:
            if (state.ok) {
              $2 = $82;
            }
            $3 = 54;
            break;
          case 56:
            $3 = 52;
            break;
          case 57:
            $88 = $90.value;
            final $326 = state.ok;
            if (!$326) {
              $3 = 58;
              break;
            }
            $92 = fastParseLiteral1$Async(state);
            if (!$92.isComplete) {
              $92.onComplete = $1;
              $3 = 59;
              return;
            }
            $3 = 59;
            break;
          case 58:
            if (!state.ok) {
              state.backtrack($89);
            }
            final $327 = !state.ok && state.isRecoverable;
            if (!$327) {
              $3 = 60;
              break;
            }
            $95 = state.pos;
            $96 = parseLiteral2$Async(state);
            if (!$96.isComplete) {
              $96.onComplete = $1;
              $3 = 61;
              return;
            }
            $3 = 61;
            break;
          case 59:
            if (state.ok) {
              $2 = $88;
            }
            $3 = 58;
            break;
          case 60:
            $3 = 56;
            break;
          case 61:
            $94 = $96.value;
            final $328 = state.ok;
            if (!$328) {
              $3 = 62;
              break;
            }
            $98 = fastParseLiteral2$Async(state);
            if (!$98.isComplete) {
              $98.onComplete = $1;
              $3 = 63;
              return;
            }
            $3 = 63;
            break;
          case 62:
            if (!state.ok) {
              state.backtrack($95);
            }
            final $329 = !state.ok && state.isRecoverable;
            if (!$329) {
              $3 = 64;
              break;
            }
            $101 = state.pos;
            $102 = parseLiteral10$Async(state);
            if (!$102.isComplete) {
              $102.onComplete = $1;
              $3 = 65;
              return;
            }
            $3 = 65;
            break;
          case 63:
            if (state.ok) {
              $2 = $94;
            }
            $3 = 62;
            break;
          case 64:
            $3 = 60;
            break;
          case 65:
            $100 = $102.value;
            final $330 = state.ok;
            if (!$330) {
              $3 = 66;
              break;
            }
            $104 = fastParseLiteral10$Async(state);
            if (!$104.isComplete) {
              $104.onComplete = $1;
              $3 = 67;
              return;
            }
            $3 = 67;
            break;
          case 66:
            if (!state.ok) {
              state.backtrack($101);
            }
            final $331 = !state.ok && state.isRecoverable;
            if (!$331) {
              $3 = 68;
              break;
            }
            $107 = state.pos;
            $108 = parseLiterals$Async(state);
            if (!$108.isComplete) {
              $108.onComplete = $1;
              $3 = 69;
              return;
            }
            $3 = 69;
            break;
          case 67:
            if (state.ok) {
              $2 = $100;
            }
            $3 = 66;
            break;
          case 68:
            $3 = 64;
            break;
          case 69:
            $106 = $108.value;
            final $332 = state.ok;
            if (!$332) {
              $3 = 70;
              break;
            }
            $110 = fastParseLiterals$Async(state);
            if (!$110.isComplete) {
              $110.onComplete = $1;
              $3 = 71;
              return;
            }
            $3 = 71;
            break;
          case 70:
            if (!state.ok) {
              state.backtrack($107);
            }
            final $333 = !state.ok && state.isRecoverable;
            if (!$333) {
              $3 = 72;
              break;
            }
            $113 = state.pos;
            $114 = parseList$Async(state);
            if (!$114.isComplete) {
              $114.onComplete = $1;
              $3 = 73;
              return;
            }
            $3 = 73;
            break;
          case 71:
            if (state.ok) {
              $2 = $106;
            }
            $3 = 70;
            break;
          case 72:
            $3 = 68;
            break;
          case 73:
            $112 = $114.value;
            final $334 = state.ok;
            if (!$334) {
              $3 = 74;
              break;
            }
            $116 = fastParseList$Async(state);
            if (!$116.isComplete) {
              $116.onComplete = $1;
              $3 = 75;
              return;
            }
            $3 = 75;
            break;
          case 74:
            if (!state.ok) {
              state.backtrack($113);
            }
            final $335 = !state.ok && state.isRecoverable;
            if (!$335) {
              $3 = 76;
              break;
            }
            $119 = state.pos;
            $120 = parseList1$Async(state);
            if (!$120.isComplete) {
              $120.onComplete = $1;
              $3 = 77;
              return;
            }
            $3 = 77;
            break;
          case 75:
            if (state.ok) {
              $2 = $112;
            }
            $3 = 74;
            break;
          case 76:
            $3 = 72;
            break;
          case 77:
            $118 = $120.value;
            final $336 = state.ok;
            if (!$336) {
              $3 = 78;
              break;
            }
            $122 = fastParseList1$Async(state);
            if (!$122.isComplete) {
              $122.onComplete = $1;
              $3 = 79;
              return;
            }
            $3 = 79;
            break;
          case 78:
            if (!state.ok) {
              state.backtrack($119);
            }
            final $337 = !state.ok && state.isRecoverable;
            if (!$337) {
              $3 = 80;
              break;
            }
            $125 = state.pos;
            $126 = parseMatchString$Async(state);
            if (!$126.isComplete) {
              $126.onComplete = $1;
              $3 = 81;
              return;
            }
            $3 = 81;
            break;
          case 79:
            if (state.ok) {
              $2 = $118;
            }
            $3 = 78;
            break;
          case 80:
            $3 = 76;
            break;
          case 81:
            $124 = $126.value;
            final $338 = state.ok;
            if (!$338) {
              $3 = 82;
              break;
            }
            $128 = fastParseMatchString$Async(state);
            if (!$128.isComplete) {
              $128.onComplete = $1;
              $3 = 83;
              return;
            }
            $3 = 83;
            break;
          case 82:
            if (!state.ok) {
              state.backtrack($125);
            }
            final $339 = !state.ok && state.isRecoverable;
            if (!$339) {
              $3 = 84;
              break;
            }
            $131 = state.pos;
            $132 = parseMessage$Async(state);
            if (!$132.isComplete) {
              $132.onComplete = $1;
              $3 = 85;
              return;
            }
            $3 = 85;
            break;
          case 83:
            if (state.ok) {
              $2 = $124;
            }
            $3 = 82;
            break;
          case 84:
            $3 = 80;
            break;
          case 85:
            $130 = $132.value;
            final $340 = state.ok;
            if (!$340) {
              $3 = 86;
              break;
            }
            $134 = fastParseMessage$Async(state);
            if (!$134.isComplete) {
              $134.onComplete = $1;
              $3 = 87;
              return;
            }
            $3 = 87;
            break;
          case 86:
            if (!state.ok) {
              state.backtrack($131);
            }
            final $341 = !state.ok && state.isRecoverable;
            if (!$341) {
              $3 = 88;
              break;
            }
            $137 = state.pos;
            $138 = parseNotPredicate$Async(state);
            if (!$138.isComplete) {
              $138.onComplete = $1;
              $3 = 89;
              return;
            }
            $3 = 89;
            break;
          case 87:
            if (state.ok) {
              $2 = $130;
            }
            $3 = 86;
            break;
          case 88:
            $3 = 84;
            break;
          case 89:
            $136 = $138.value;
            final $342 = state.ok;
            if (!$342) {
              $3 = 90;
              break;
            }
            $140 = fastParseNotPredicate$Async(state);
            if (!$140.isComplete) {
              $140.onComplete = $1;
              $3 = 91;
              return;
            }
            $3 = 91;
            break;
          case 90:
            if (!state.ok) {
              state.backtrack($137);
            }
            final $343 = !state.ok && state.isRecoverable;
            if (!$343) {
              $3 = 92;
              break;
            }
            $143 = state.pos;
            $144 = parseNotPredicate2$Async(state);
            if (!$144.isComplete) {
              $144.onComplete = $1;
              $3 = 93;
              return;
            }
            $3 = 93;
            break;
          case 91:
            if (state.ok) {
              $2 = $136;
            }
            $3 = 90;
            break;
          case 92:
            $3 = 88;
            break;
          case 93:
            $142 = $144.value;
            final $344 = state.ok;
            if (!$344) {
              $3 = 94;
              break;
            }
            $146 = fastParseNotPredicate2$Async(state);
            if (!$146.isComplete) {
              $146.onComplete = $1;
              $3 = 95;
              return;
            }
            $3 = 95;
            break;
          case 94:
            if (!state.ok) {
              state.backtrack($143);
            }
            final $345 = !state.ok && state.isRecoverable;
            if (!$345) {
              $3 = 96;
              break;
            }
            $149 = state.pos;
            $150 = parseOneOrMore$Async(state);
            if (!$150.isComplete) {
              $150.onComplete = $1;
              $3 = 97;
              return;
            }
            $3 = 97;
            break;
          case 95:
            if (state.ok) {
              $2 = $142;
            }
            $3 = 94;
            break;
          case 96:
            $3 = 92;
            break;
          case 97:
            $148 = $150.value;
            final $346 = state.ok;
            if (!$346) {
              $3 = 98;
              break;
            }
            $152 = fastParseOneOrMore$Async(state);
            if (!$152.isComplete) {
              $152.onComplete = $1;
              $3 = 99;
              return;
            }
            $3 = 99;
            break;
          case 98:
            if (!state.ok) {
              state.backtrack($149);
            }
            final $347 = !state.ok && state.isRecoverable;
            if (!$347) {
              $3 = 100;
              break;
            }
            $155 = state.pos;
            $156 = parseOneOrMoreLiteral$Async(state);
            if (!$156.isComplete) {
              $156.onComplete = $1;
              $3 = 101;
              return;
            }
            $3 = 101;
            break;
          case 99:
            if (state.ok) {
              $2 = $148;
            }
            $3 = 98;
            break;
          case 100:
            $3 = 96;
            break;
          case 101:
            $154 = $156.value;
            final $348 = state.ok;
            if (!$348) {
              $3 = 102;
              break;
            }
            $158 = fastParseOneOrMoreLiteral$Async(state);
            if (!$158.isComplete) {
              $158.onComplete = $1;
              $3 = 103;
              return;
            }
            $3 = 103;
            break;
          case 102:
            if (!state.ok) {
              state.backtrack($155);
            }
            final $349 = !state.ok && state.isRecoverable;
            if (!$349) {
              $3 = 104;
              break;
            }
            $161 = state.pos;
            $162 = parseOrderedChoice2$Async(state);
            if (!$162.isComplete) {
              $162.onComplete = $1;
              $3 = 105;
              return;
            }
            $3 = 105;
            break;
          case 103:
            if (state.ok) {
              $2 = $154;
            }
            $3 = 102;
            break;
          case 104:
            $3 = 100;
            break;
          case 105:
            $160 = $162.value;
            final $350 = state.ok;
            if (!$350) {
              $3 = 106;
              break;
            }
            $164 = fastParseOrderedChoice2$Async(state);
            if (!$164.isComplete) {
              $164.onComplete = $1;
              $3 = 107;
              return;
            }
            $3 = 107;
            break;
          case 106:
            if (!state.ok) {
              state.backtrack($161);
            }
            final $351 = !state.ok && state.isRecoverable;
            if (!$351) {
              $3 = 108;
              break;
            }
            $167 = state.pos;
            $168 = parseOrderedChoice3$Async(state);
            if (!$168.isComplete) {
              $168.onComplete = $1;
              $3 = 109;
              return;
            }
            $3 = 109;
            break;
          case 107:
            if (state.ok) {
              $2 = $160;
            }
            $3 = 106;
            break;
          case 108:
            $3 = 104;
            break;
          case 109:
            $166 = $168.value;
            final $352 = state.ok;
            if (!$352) {
              $3 = 110;
              break;
            }
            $170 = fastParseOrderedChoice3$Async(state);
            if (!$170.isComplete) {
              $170.onComplete = $1;
              $3 = 111;
              return;
            }
            $3 = 111;
            break;
          case 110:
            if (!state.ok) {
              state.backtrack($167);
            }
            final $353 = !state.ok && state.isRecoverable;
            if (!$353) {
              $3 = 112;
              break;
            }
            $173 = state.pos;
            $174 = parseOptional$Async(state);
            if (!$174.isComplete) {
              $174.onComplete = $1;
              $3 = 113;
              return;
            }
            $3 = 113;
            break;
          case 111:
            if (state.ok) {
              $2 = $166;
            }
            $3 = 110;
            break;
          case 112:
            $3 = 108;
            break;
          case 113:
            $172 = $174.value;
            final $354 = state.ok;
            if (!$354) {
              $3 = 114;
              break;
            }
            $176 = fastParseOptional$Async(state);
            if (!$176.isComplete) {
              $176.onComplete = $1;
              $3 = 115;
              return;
            }
            $3 = 115;
            break;
          case 114:
            if (!state.ok) {
              state.backtrack($173);
            }
            final $355 = !state.ok && state.isRecoverable;
            if (!$355) {
              $3 = 116;
              break;
            }
            $179 = state.pos;
            $180 = parseRepetitionMax$Async(state);
            if (!$180.isComplete) {
              $180.onComplete = $1;
              $3 = 117;
              return;
            }
            $3 = 117;
            break;
          case 115:
            if (state.ok) {
              $2 = $172;
            }
            $3 = 114;
            break;
          case 116:
            $3 = 112;
            break;
          case 117:
            $178 = $180.value;
            final $356 = state.ok;
            if (!$356) {
              $3 = 118;
              break;
            }
            $182 = fastParseRepetitionMax$Async(state);
            if (!$182.isComplete) {
              $182.onComplete = $1;
              $3 = 119;
              return;
            }
            $3 = 119;
            break;
          case 118:
            if (!state.ok) {
              state.backtrack($179);
            }
            final $357 = !state.ok && state.isRecoverable;
            if (!$357) {
              $3 = 120;
              break;
            }
            $185 = state.pos;
            $186 = parseRepetitionMin$Async(state);
            if (!$186.isComplete) {
              $186.onComplete = $1;
              $3 = 121;
              return;
            }
            $3 = 121;
            break;
          case 119:
            if (state.ok) {
              $2 = $178;
            }
            $3 = 118;
            break;
          case 120:
            $3 = 116;
            break;
          case 121:
            $184 = $186.value;
            final $358 = state.ok;
            if (!$358) {
              $3 = 122;
              break;
            }
            $188 = fastParseRepetitionMin$Async(state);
            if (!$188.isComplete) {
              $188.onComplete = $1;
              $3 = 123;
              return;
            }
            $3 = 123;
            break;
          case 122:
            if (!state.ok) {
              state.backtrack($185);
            }
            final $359 = !state.ok && state.isRecoverable;
            if (!$359) {
              $3 = 124;
              break;
            }
            $191 = state.pos;
            $192 = parseRepetitionMinMax$Async(state);
            if (!$192.isComplete) {
              $192.onComplete = $1;
              $3 = 125;
              return;
            }
            $3 = 125;
            break;
          case 123:
            if (state.ok) {
              $2 = $184;
            }
            $3 = 122;
            break;
          case 124:
            $3 = 120;
            break;
          case 125:
            $190 = $192.value;
            final $360 = state.ok;
            if (!$360) {
              $3 = 126;
              break;
            }
            $194 = fastParseRepetitionMinMax$Async(state);
            if (!$194.isComplete) {
              $194.onComplete = $1;
              $3 = 127;
              return;
            }
            $3 = 127;
            break;
          case 126:
            if (!state.ok) {
              state.backtrack($191);
            }
            final $361 = !state.ok && state.isRecoverable;
            if (!$361) {
              $3 = 128;
              break;
            }
            $197 = state.pos;
            $198 = parseRepetitionN$Async(state);
            if (!$198.isComplete) {
              $198.onComplete = $1;
              $3 = 129;
              return;
            }
            $3 = 129;
            break;
          case 127:
            if (state.ok) {
              $2 = $190;
            }
            $3 = 126;
            break;
          case 128:
            $3 = 124;
            break;
          case 129:
            $196 = $198.value;
            final $362 = state.ok;
            if (!$362) {
              $3 = 130;
              break;
            }
            $200 = fastParseRepetitionN$Async(state);
            if (!$200.isComplete) {
              $200.onComplete = $1;
              $3 = 131;
              return;
            }
            $3 = 131;
            break;
          case 130:
            if (!state.ok) {
              state.backtrack($197);
            }
            final $363 = !state.ok && state.isRecoverable;
            if (!$363) {
              $3 = 132;
              break;
            }
            $203 = state.pos;
            $204 = parseSequence1$Async(state);
            if (!$204.isComplete) {
              $204.onComplete = $1;
              $3 = 133;
              return;
            }
            $3 = 133;
            break;
          case 131:
            if (state.ok) {
              $2 = $196;
            }
            $3 = 130;
            break;
          case 132:
            $3 = 128;
            break;
          case 133:
            $202 = $204.value;
            final $364 = state.ok;
            if (!$364) {
              $3 = 134;
              break;
            }
            $206 = fastParseSequence1$Async(state);
            if (!$206.isComplete) {
              $206.onComplete = $1;
              $3 = 135;
              return;
            }
            $3 = 135;
            break;
          case 134:
            if (!state.ok) {
              state.backtrack($203);
            }
            final $365 = !state.ok && state.isRecoverable;
            if (!$365) {
              $3 = 136;
              break;
            }
            $209 = state.pos;
            $210 = parseSequence1WithAction$Async(state);
            if (!$210.isComplete) {
              $210.onComplete = $1;
              $3 = 137;
              return;
            }
            $3 = 137;
            break;
          case 135:
            if (state.ok) {
              $2 = $202;
            }
            $3 = 134;
            break;
          case 136:
            $3 = 132;
            break;
          case 137:
            $208 = $210.value;
            final $366 = state.ok;
            if (!$366) {
              $3 = 138;
              break;
            }
            $212 = fastParseSequence1WithAction$Async(state);
            if (!$212.isComplete) {
              $212.onComplete = $1;
              $3 = 139;
              return;
            }
            $3 = 139;
            break;
          case 138:
            if (!state.ok) {
              state.backtrack($209);
            }
            final $367 = !state.ok && state.isRecoverable;
            if (!$367) {
              $3 = 140;
              break;
            }
            $215 = state.pos;
            $216 = parseSequence1WithVariable$Async(state);
            if (!$216.isComplete) {
              $216.onComplete = $1;
              $3 = 141;
              return;
            }
            $3 = 141;
            break;
          case 139:
            if (state.ok) {
              $2 = $208;
            }
            $3 = 138;
            break;
          case 140:
            $3 = 136;
            break;
          case 141:
            $214 = $216.value;
            final $368 = state.ok;
            if (!$368) {
              $3 = 142;
              break;
            }
            $218 = fastParseSequence1WithVariable$Async(state);
            if (!$218.isComplete) {
              $218.onComplete = $1;
              $3 = 143;
              return;
            }
            $3 = 143;
            break;
          case 142:
            if (!state.ok) {
              state.backtrack($215);
            }
            final $369 = !state.ok && state.isRecoverable;
            if (!$369) {
              $3 = 144;
              break;
            }
            $221 = state.pos;
            $222 = parseSequence1WithVariable$Async(state);
            if (!$222.isComplete) {
              $222.onComplete = $1;
              $3 = 145;
              return;
            }
            $3 = 145;
            break;
          case 143:
            if (state.ok) {
              $2 = $214;
            }
            $3 = 142;
            break;
          case 144:
            $3 = 140;
            break;
          case 145:
            $220 = $222.value;
            final $370 = state.ok;
            if (!$370) {
              $3 = 146;
              break;
            }
            $224 = fastParseSequence1WithVariable$Async(state);
            if (!$224.isComplete) {
              $224.onComplete = $1;
              $3 = 147;
              return;
            }
            $3 = 147;
            break;
          case 146:
            if (!state.ok) {
              state.backtrack($221);
            }
            final $371 = !state.ok && state.isRecoverable;
            if (!$371) {
              $3 = 148;
              break;
            }
            $227 = state.pos;
            $228 = parseSequence1WithVariableWithAction$Async(state);
            if (!$228.isComplete) {
              $228.onComplete = $1;
              $3 = 149;
              return;
            }
            $3 = 149;
            break;
          case 147:
            if (state.ok) {
              $2 = $220;
            }
            $3 = 146;
            break;
          case 148:
            $3 = 144;
            break;
          case 149:
            $226 = $228.value;
            final $372 = state.ok;
            if (!$372) {
              $3 = 150;
              break;
            }
            $230 = fastParseSequence1WithVariableWithAction$Async(state);
            if (!$230.isComplete) {
              $230.onComplete = $1;
              $3 = 151;
              return;
            }
            $3 = 151;
            break;
          case 150:
            if (!state.ok) {
              state.backtrack($227);
            }
            final $373 = !state.ok && state.isRecoverable;
            if (!$373) {
              $3 = 152;
              break;
            }
            $233 = state.pos;
            $234 = parseSequence2$Async(state);
            if (!$234.isComplete) {
              $234.onComplete = $1;
              $3 = 153;
              return;
            }
            $3 = 153;
            break;
          case 151:
            if (state.ok) {
              $2 = $226;
            }
            $3 = 150;
            break;
          case 152:
            $3 = 148;
            break;
          case 153:
            $232 = $234.value;
            final $374 = state.ok;
            if (!$374) {
              $3 = 154;
              break;
            }
            $236 = fastParseSequence2$Async(state);
            if (!$236.isComplete) {
              $236.onComplete = $1;
              $3 = 155;
              return;
            }
            $3 = 155;
            break;
          case 154:
            if (!state.ok) {
              state.backtrack($233);
            }
            final $375 = !state.ok && state.isRecoverable;
            if (!$375) {
              $3 = 156;
              break;
            }
            $239 = state.pos;
            $240 = parseSequence2WithAction$Async(state);
            if (!$240.isComplete) {
              $240.onComplete = $1;
              $3 = 157;
              return;
            }
            $3 = 157;
            break;
          case 155:
            if (state.ok) {
              $2 = $232;
            }
            $3 = 154;
            break;
          case 156:
            $3 = 152;
            break;
          case 157:
            $238 = $240.value;
            final $376 = state.ok;
            if (!$376) {
              $3 = 158;
              break;
            }
            $242 = fastParseSequence2WithAction$Async(state);
            if (!$242.isComplete) {
              $242.onComplete = $1;
              $3 = 159;
              return;
            }
            $3 = 159;
            break;
          case 158:
            if (!state.ok) {
              state.backtrack($239);
            }
            final $377 = !state.ok && state.isRecoverable;
            if (!$377) {
              $3 = 160;
              break;
            }
            $245 = state.pos;
            $246 = parseSequence2WithVariable$Async(state);
            if (!$246.isComplete) {
              $246.onComplete = $1;
              $3 = 161;
              return;
            }
            $3 = 161;
            break;
          case 159:
            if (state.ok) {
              $2 = $238;
            }
            $3 = 158;
            break;
          case 160:
            $3 = 156;
            break;
          case 161:
            $244 = $246.value;
            final $378 = state.ok;
            if (!$378) {
              $3 = 162;
              break;
            }
            $248 = fastParseSequence2WithVariable$Async(state);
            if (!$248.isComplete) {
              $248.onComplete = $1;
              $3 = 163;
              return;
            }
            $3 = 163;
            break;
          case 162:
            if (!state.ok) {
              state.backtrack($245);
            }
            final $379 = !state.ok && state.isRecoverable;
            if (!$379) {
              $3 = 164;
              break;
            }
            $251 = state.pos;
            $252 = parseSequence2WithVariables$Async(state);
            if (!$252.isComplete) {
              $252.onComplete = $1;
              $3 = 165;
              return;
            }
            $3 = 165;
            break;
          case 163:
            if (state.ok) {
              $2 = $244;
            }
            $3 = 162;
            break;
          case 164:
            $3 = 160;
            break;
          case 165:
            $250 = $252.value;
            final $380 = state.ok;
            if (!$380) {
              $3 = 166;
              break;
            }
            $254 = fastParseSequence2WithVariables$Async(state);
            if (!$254.isComplete) {
              $254.onComplete = $1;
              $3 = 167;
              return;
            }
            $3 = 167;
            break;
          case 166:
            if (!state.ok) {
              state.backtrack($251);
            }
            final $381 = !state.ok && state.isRecoverable;
            if (!$381) {
              $3 = 168;
              break;
            }
            $257 = state.pos;
            $258 = parseSequence2WithVariableWithAction$Async(state);
            if (!$258.isComplete) {
              $258.onComplete = $1;
              $3 = 169;
              return;
            }
            $3 = 169;
            break;
          case 167:
            if (state.ok) {
              $2 = $250;
            }
            $3 = 166;
            break;
          case 168:
            $3 = 164;
            break;
          case 169:
            $256 = $258.value;
            final $382 = state.ok;
            if (!$382) {
              $3 = 170;
              break;
            }
            $260 = fastParseSequence2WithVariableWithAction$Async(state);
            if (!$260.isComplete) {
              $260.onComplete = $1;
              $3 = 171;
              return;
            }
            $3 = 171;
            break;
          case 170:
            if (!state.ok) {
              state.backtrack($257);
            }
            final $383 = !state.ok && state.isRecoverable;
            if (!$383) {
              $3 = 172;
              break;
            }
            $263 = state.pos;
            $264 = parseSequence2WithVariablesWithAction$Async(state);
            if (!$264.isComplete) {
              $264.onComplete = $1;
              $3 = 173;
              return;
            }
            $3 = 173;
            break;
          case 171:
            if (state.ok) {
              $2 = $256;
            }
            $3 = 170;
            break;
          case 172:
            $3 = 168;
            break;
          case 173:
            $262 = $264.value;
            final $384 = state.ok;
            if (!$384) {
              $3 = 174;
              break;
            }
            $266 = fastParseSequence2WithVariablesWithAction$Async(state);
            if (!$266.isComplete) {
              $266.onComplete = $1;
              $3 = 175;
              return;
            }
            $3 = 175;
            break;
          case 174:
            if (!state.ok) {
              state.backtrack($263);
            }
            final $385 = !state.ok && state.isRecoverable;
            if (!$385) {
              $3 = 176;
              break;
            }
            $269 = state.pos;
            $270 = parseSlice$Async(state);
            if (!$270.isComplete) {
              $270.onComplete = $1;
              $3 = 177;
              return;
            }
            $3 = 177;
            break;
          case 175:
            if (state.ok) {
              $2 = $262;
            }
            $3 = 174;
            break;
          case 176:
            $3 = 172;
            break;
          case 177:
            $268 = $270.value;
            final $386 = state.ok;
            if (!$386) {
              $3 = 178;
              break;
            }
            $272 = fastParseSlice$Async(state);
            if (!$272.isComplete) {
              $272.onComplete = $1;
              $3 = 179;
              return;
            }
            $3 = 179;
            break;
          case 178:
            if (!state.ok) {
              state.backtrack($269);
            }
            final $387 = !state.ok && state.isRecoverable;
            if (!$387) {
              $3 = 180;
              break;
            }
            $275 = state.pos;
            $276 = parseStringChars$Async(state);
            if (!$276.isComplete) {
              $276.onComplete = $1;
              $3 = 181;
              return;
            }
            $3 = 181;
            break;
          case 179:
            if (state.ok) {
              $2 = $268;
            }
            $3 = 178;
            break;
          case 180:
            $3 = 176;
            break;
          case 181:
            $274 = $276.value;
            final $388 = state.ok;
            if (!$388) {
              $3 = 182;
              break;
            }
            $278 = fastParseStringChars$Async(state);
            if (!$278.isComplete) {
              $278.onComplete = $1;
              $3 = 183;
              return;
            }
            $3 = 183;
            break;
          case 182:
            if (!state.ok) {
              state.backtrack($275);
            }
            final $389 = !state.ok && state.isRecoverable;
            if (!$389) {
              $3 = 184;
              break;
            }
            $281 = state.pos;
            $282 = parseTag$Async(state);
            if (!$282.isComplete) {
              $282.onComplete = $1;
              $3 = 185;
              return;
            }
            $3 = 185;
            break;
          case 183:
            if (state.ok) {
              $2 = $274;
            }
            $3 = 182;
            break;
          case 184:
            $3 = 180;
            break;
          case 185:
            $280 = $282.value;
            final $390 = state.ok;
            if (!$390) {
              $3 = 186;
              break;
            }
            $284 = fastParseTag$Async(state);
            if (!$284.isComplete) {
              $284.onComplete = $1;
              $3 = 187;
              return;
            }
            $3 = 187;
            break;
          case 186:
            if (!state.ok) {
              state.backtrack($281);
            }
            final $391 = !state.ok && state.isRecoverable;
            if (!$391) {
              $3 = 188;
              break;
            }
            $287 = state.pos;
            $288 = parseVerify$Async(state);
            if (!$288.isComplete) {
              $288.onComplete = $1;
              $3 = 189;
              return;
            }
            $3 = 189;
            break;
          case 187:
            if (state.ok) {
              $2 = $280;
            }
            $3 = 186;
            break;
          case 188:
            $3 = 184;
            break;
          case 189:
            $286 = $288.value;
            final $392 = state.ok;
            if (!$392) {
              $3 = 190;
              break;
            }
            $290 = fastParseVerify$Async(state);
            if (!$290.isComplete) {
              $290.onComplete = $1;
              $3 = 191;
              return;
            }
            $3 = 191;
            break;
          case 190:
            if (!state.ok) {
              state.backtrack($287);
            }
            final $393 = !state.ok && state.isRecoverable;
            if (!$393) {
              $3 = 192;
              break;
            }
            $293 = state.pos;
            $294 = parseZeroOrMore$Async(state);
            if (!$294.isComplete) {
              $294.onComplete = $1;
              $3 = 193;
              return;
            }
            $3 = 193;
            break;
          case 191:
            if (state.ok) {
              $2 = $286;
            }
            $3 = 190;
            break;
          case 192:
            $3 = 188;
            break;
          case 193:
            $292 = $294.value;
            final $394 = state.ok;
            if (!$394) {
              $3 = 194;
              break;
            }
            $296 = fastParseZeroOrMore$Async(state);
            if (!$296.isComplete) {
              $296.onComplete = $1;
              $3 = 195;
              return;
            }
            $3 = 195;
            break;
          case 194:
            if (!state.ok) {
              state.backtrack($293);
            }
            $3 = 192;
            break;
          case 195:
            if (state.ok) {
              $2 = $292;
            }
            $3 = 194;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    List<String>? $9;
    String? $11;
    while (true) {
      String? $2;
      // $[0-9]+
      final $5 = state.pos;
      var $6 = false;
      for (var c = 0;
          state.pos < state.input.length &&
              (c = state.input.codeUnitAt(state.pos)) == c &&
              (c >= 48 && c <= 57);
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
        $2 = state.input.substring($5, state.pos);
      }
      if (state.ok) {
        final v = $2!;
        if ($11 == null) {
          $11 = v;
        } else if ($9 == null) {
          $9 = [$11, v];
        } else {
          $9.add(v);
        }
      }
      final $10 = state.pos;
      // [\\]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 92;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      String? $3;
      // [t] <String>{}
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 116;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        String? $$;
        $$ = '\t';
        $3 = $$;
      }
      if (!state.ok) {
        state.backtrack($10);
        break;
      }
      if ($11 == null) {
        $11 = $3!;
      } else {
        if ($9 == null) {
          $9 = [$11, $3!];
        } else {
          $9.add($3!);
        }
      }
    }
    state.setOk(true);
    if ($11 == null) {
      $0 = '';
    } else if ($9 == null) {
      $0 = $11;
    } else {
      $0 = $9.join();
    }
    return $0;
  }

  /// StringChars =
  ///   @stringChars($[0-9]+, [\\], [t] <String>{})
  ///   ;
  AsyncResult<String> parseStringChars$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    List<String>? $6;
    late int $7;
    String? $8;
    String? $4;
    late int $9;
    late int $14;
    String? $5;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = null;
            $8 = null;
            $3 = 2;
            break;
          case 1:
            state.setOk(true);
            if ($8 == null) {
              $2 = '';
            } else if ($6 == null) {
              $2 = $8;
            } else {
              $2 = $6!.join();
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            $9 = state.pos;
            state.input.beginBuffering();
            $14 = 0;
            $3 = 3;
            break;
          case 3:
            final $12 = state.input;
            var $15 = false;
            while (state.pos < $12.end) {
              final $10 = $12.data.codeUnitAt(state.pos - $12.start);
              final $11 = $10 >= 48 && $10 <= 57;
              if (!$11) {
                $15 = true;
                break;
              }
              state.pos++;
              $14++;
            }
            if (!$15 && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            if ($14 != 0) {
              state.setOk(true);
            } else {
              $12.isClosed
                  ? state.fail(const ErrorUnexpectedEndOfInput())
                  : state.fail(const ErrorUnexpectedCharacter());
            }
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $4 = input.data.substring($9 - start, state.pos - start);
            }
            if (state.ok) {
              final v = $4!;
              if ($8 == null) {
                $8 = v;
              } else if ($6 == null) {
                $6 = [$8!, v];
              } else {
                $6!.add(v);
              }
            }
            $7 = state.pos;
            $3 = 4;
            break;
          case 4:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 4;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 92;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $3 = 5;
            break;
          case 5:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $18.end) {
              final ok = $18.data.codeUnitAt(state.pos - $18.start) == 116;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              String? $$;
              $$ = '\t';
              $5 = $$;
            }
            if (!state.ok) {
              state.backtrack($7);
              $3 = 1;
              break;
            }
            if ($8 == null) {
              $8 = $5!;
            } else if ($6 == null) {
              $6 = [$8!, $5!];
            } else {
              $6!.add($5!);
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Tag =
  ///   @tag('FOR', $([Ff] [Oo] [Rr]))
  ///   ;
  String? parseTag(State<String> state) {
    String? $0;
    // @tag('FOR', $([Ff] [Oo] [Rr]))
    final $2 = state.pos;
    final $3 = state.ignoreErrors;
    state.ignoreErrors = true;
    // $([Ff] [Oo] [Rr])
    final $5 = state.pos;
    // [Ff] [Oo] [Rr]
    final $6 = state.pos;
    if (state.pos < state.input.length) {
      final $7 = state.input.codeUnitAt(state.pos);
      final $8 = $7 == 70 || $7 == 102;
      if ($8) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      if (state.pos < state.input.length) {
        final $9 = state.input.codeUnitAt(state.pos);
        final $10 = $9 == 79 || $9 == 111;
        if ($10) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        if (state.pos < state.input.length) {
          final $11 = state.input.codeUnitAt(state.pos);
          final $12 = $11 == 82 || $11 == 114;
          if ($12) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
      }
    }
    if (!state.ok) {
      state.backtrack($6);
    }
    if (state.ok) {
      $0 = state.input.substring($5, state.pos);
    }
    state.ignoreErrors = $3;
    if (!state.ok) {
      state.failAt($2, const ErrorExpectedTags(['FOR']));
    }
    return $0;
  }

  /// Tag =
  ///   @tag('FOR', $([Ff] [Oo] [Rr]))
  ///   ;
  AsyncResult<String> parseTag$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    late int $4;
    late bool $5;
    late int $6;
    late int $7;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = state.pos;
            $5 = state.ignoreErrors;
            state.ignoreErrors = true;
            $6 = state.pos;
            state.input.beginBuffering();
            $7 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $8.end) {
              final $9 = $8.data.codeUnitAt(state.pos - $8.start);
              final $10 = $9 == 70 || $9 == 102;
              if ($10) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $20 = state.ok;
            if (!$20) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($7);
            }
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $2 = input.data.substring($6 - start, state.pos - start);
            }
            state.ignoreErrors = $5;
            if (!state.ok) {
              state.failAt($4, const ErrorExpectedTags(['FOR']));
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $12.end) {
              final $13 = $12.data.codeUnitAt(state.pos - $12.start);
              final $14 = $13 == 79 || $13 == 111;
              if ($14) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $16.end) {
              final $17 = $16.data.codeUnitAt(state.pos - $16.start);
              final $18 = $17 == 82 || $17 == 114;
              if ($18) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            $3 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// Verify =
  ///     'abc'
  ///   / [5] [6] [7]
  ///   / Verify_
  ///   ;
  Object? parseVerify(State<String> state) {
    Object? $0;
    // 'abc'
    const $2 = 'abc';
    final $3 = state.pos + 2 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 97 &&
        state.input.codeUnitAt(state.pos + 1) == 98 &&
        state.input.codeUnitAt(state.pos + 2) == 99;
    if ($3) {
      state.pos += 3;
      state.setOk(true);
      $0 = $2;
    } else {
      state.fail(const ErrorExpectedTags([$2]));
    }
    if (!state.ok && state.isRecoverable) {
      // [5] [6] [7]
      final $7 = state.pos;
      int? $4;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 53;
        if (ok) {
          state.pos++;
          state.setOk(true);
          $4 = 53;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (state.ok) {
        int? $5;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 54;
          if (ok) {
            state.pos++;
            state.setOk(true);
            $5 = 54;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          int? $6;
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 55;
            if (ok) {
              state.pos++;
              state.setOk(true);
              $6 = 55;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $0 = [$4!, $5!, $6!];
          }
        }
      }
      if (!state.ok) {
        state.backtrack($7);
      }
      if (!state.ok && state.isRecoverable) {
        // Verify_
        // @inline Verify_ = @verify('error', [0-1]) ;
        // @verify('error', [0-1])
        final $11 = state.pos;
        // [0-1]
        if (state.pos < state.input.length) {
          final $13 = state.input.codeUnitAt(state.pos);
          final $14 = $13 >= 48 && $13 <= 49;
          if ($14) {
            state.pos++;
            state.setOk(true);
            $0 = $13;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          // ignore: unused_local_variable
          final $$ = $0!;
          final $10 = (() => $$ == 0x30)();
          if (!$10) {
            state.fail(ErrorMessage($11 - state.pos, 'error'));
            $0 = null;
            state.backtrack($11);
          }
        }
      }
    }
    return $0;
  }

  /// Verify =
  ///     'abc'
  ///   / [5] [6] [7]
  ///   / Verify_
  ///   ;
  AsyncResult<Object?> parseVerify$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    var $3 = 0;
    late int $11;
    int? $8;
    int? $9;
    int? $10;
    late int $18;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $4 = state.input;
            if (state.pos + 2 >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $3 = 0;
              return;
            }
            const $5 = 'abc';
            final $6 = state.pos + 2 < $4.end &&
                $4.data.codeUnitAt(state.pos - $4.start) == 97 &&
                $4.data.codeUnitAt(state.pos - $4.start + 1) == 98 &&
                $4.data.codeUnitAt(state.pos - $4.start + 2) == 99;
            if ($6) {
              state.pos += 3;
              state.setOk(true);
              $2 = $5;
            } else {
              state.fail(const ErrorExpectedTags([$5]));
            }
            final $24 = !state.ok && state.isRecoverable;
            if (!$24) {
              $3 = 1;
              break;
            }
            $11 = state.pos;
            $3 = 2;
            break;
          case 1:
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 2;
              return;
            }
            if (state.pos < $12.end) {
              final ok = $12.data.codeUnitAt(state.pos - $12.start) == 53;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $8 = 53;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 3;
              break;
            }
            $3 = 4;
            break;
          case 3:
            if (!state.ok) {
              state.backtrack($11);
            }
            final $27 = !state.ok && state.isRecoverable;
            if (!$27) {
              $3 = 7;
              break;
            }
            $18 = state.pos;
            state.input.beginBuffering();
            $3 = 8;
            break;
          case 4:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 4;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 54;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $9 = 54;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $26 = state.ok;
            if (!$26) {
              $3 = 5;
              break;
            }
            $3 = 6;
            break;
          case 5:
            $3 = 3;
            break;
          case 6:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 6;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 55;
              if (ok) {
                state.pos++;
                state.setOk(true);
                $10 = 55;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $2 = [$8!, $9!, $10!];
            }
            $3 = 5;
            break;
          case 7:
            $3 = 1;
            break;
          case 8:
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $20.end) {
              final $21 = $20.data.codeUnitAt(state.pos - $20.start);
              final $22 = $21 >= 48 && $21 <= 49;
              if ($22) {
                state.pos++;
                $2 = $21;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.input.endBuffering();
            if (state.ok) {
              // ignore: unused_local_variable
              final $$ = $2!;
              final $19 = (() => $$ == 0x30)();
              if (!$19) {
                state.fail(ErrorMessage($18 - state.pos, 'error'));
                $2 = null;
                state.backtrack($18);
              }
            }
            $3 = 7;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c == 48);
        state.pos++,
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        $2.add(c));
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
    var $3 = 0;
    late List<int> $8;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = <int>[];
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            var $9 = false;
            while (state.pos < $6.end) {
              final $4 = $6.data.codeUnitAt(state.pos - $6.start);
              final $5 = $4 == 48;
              if (!$5) {
                $9 = true;
                break;
              }
              state.pos++;
              $8.add($4);
            }
            if (!$9 && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            state.setOk(true);
            if (state.ok) {
              $2 = $8;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
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

  bool ignoreErrors = false;

  final T input;

  bool isRecoverable = true;

  int lastFailPos = -1;

  bool ok = false;

  int pos = 0;

  final List<ParseError?> _errors = List.filled(256, null, growable: false);

  State(this.input);

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
    if (!ignoreErrors || !isRecoverable) {
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
    if (!ignoreErrors || !isRecoverable) {
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

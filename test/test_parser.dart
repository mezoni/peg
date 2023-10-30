class TestParser {
  bool flag = false;

  String text = '';

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  void fastParseOrderedChoiceWithLiterals(State<String> state) {
    final $1 = state.pos;
    var $0 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 97:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 98 &&
              input.codeUnitAt(pos2 + 1) == 99;
          if (ok) {
            $0 = 3;
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
            if (ok) {
              $0 = 2;
            } else {
              $0 = 1;
            }
          }
          break;
        case 100:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 101 &&
              input.codeUnitAt(pos2 + 1) == 102;
          if (ok) {
            $0 = 3;
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 101;
            if (ok) {
              $0 = 2;
            } else {
              $0 = 1;
            }
          }
          break;
        case 103:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 104;
          if (ok) {
            $0 = 2;
          }
          break;
      }
    }
    if ($0 > 0) {
      state.pos += $0;
      state.setOk(true);
    } else {
      state.pos = $1;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
  }

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  AsyncResult<Object?> fastParseOrderedChoiceWithLiterals$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
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
            final $31 = !state.ok && state.isRecoverable;
            if (!$31) {
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
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $2 = 2;
              return;
            }
            const $8 = 'ab';
            final $9 = state.pos + 1 < $7.end &&
                $7.data.codeUnitAt(state.pos - $7.start) == 97 &&
                $7.data.codeUnitAt(state.pos - $7.start + 1) == 98;
            if ($9) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$8]));
            }
            final $32 = !state.ok && state.isRecoverable;
            if (!$32) {
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
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $2 = 4;
              return;
            }
            const $12 = 'a';
            final $13 = state.pos < $11.end &&
                $11.data.codeUnitAt(state.pos - $11.start) == 97;
            if ($13) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$12]));
            }
            final $33 = !state.ok && state.isRecoverable;
            if (!$33) {
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
            if (state.pos + 2 >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $2 = 6;
              return;
            }
            const $16 = 'def';
            final $17 = state.pos + 2 < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 100 &&
                $15.data.codeUnitAt(state.pos - $15.start + 1) == 101 &&
                $15.data.codeUnitAt(state.pos - $15.start + 2) == 102;
            if ($17) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$16]));
            }
            final $34 = !state.ok && state.isRecoverable;
            if (!$34) {
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
            if (state.pos + 1 >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $2 = 8;
              return;
            }
            const $20 = 'de';
            final $21 = state.pos + 1 < $19.end &&
                $19.data.codeUnitAt(state.pos - $19.start) == 100 &&
                $19.data.codeUnitAt(state.pos - $19.start + 1) == 101;
            if ($21) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$20]));
            }
            final $35 = !state.ok && state.isRecoverable;
            if (!$35) {
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
            const $24 = 'd';
            final $25 = state.pos < $23.end &&
                $23.data.codeUnitAt(state.pos - $23.start) == 100;
            if ($25) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$24]));
            }
            final $36 = !state.ok && state.isRecoverable;
            if (!$36) {
              $2 = 11;
              break;
            }
            $2 = 12;
            break;
          case 11:
            $2 = 9;
            break;
          case 12:
            final $27 = state.input;
            if (state.pos + 1 >= $27.end && !$27.isClosed) {
              $27.sleep = true;
              $27.handle = $1;
              $2 = 12;
              return;
            }
            const $28 = 'gh';
            final $29 = state.pos + 1 < $27.end &&
                $27.data.codeUnitAt(state.pos - $27.start) == 103 &&
                $27.data.codeUnitAt(state.pos - $27.start + 1) == 104;
            if ($29) {
              state.pos += 2;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$28]));
            }
            $2 = 11;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  void fastParseSkipTil(State<String> state) {
    // (![E] v:.)*
    const $3 = 'E';
    final $1 = state.input.indexOf($3, state.pos);
    final $2 = $1 != -1;
    if ($2) {
      state.pos = $1;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  AsyncResult<Object?> fastParseSkipTil$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
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
            $4 = state.pos;
            $5 = state.pos;
            state.input.beginBuffering();
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
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 69;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.input.endBuffering();
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
            final $11 = state.ok;
            if (!$11) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($4);
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
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
              final c = $8.data.runeAt(state.pos - $8.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  void fastParseSkipUntil(State<String> state) {
    // (!'END' v:.)*
    const $3 = 'END';
    final $1 = state.input.indexOf($3, state.pos);
    final $2 = $1 != -1;
    if ($2) {
      state.pos = $1;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$3]));
    }
  }

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  AsyncResult<Object?> fastParseSkipUntil$Async(
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
            $4 = state.pos;
            $5 = state.pos;
            state.input.beginBuffering();
            $2 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 2 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            const $7 = 'END';
            final $8 = state.pos + 2 < $6.end &&
                $6.data.codeUnitAt(state.pos - $6.start) == 69 &&
                $6.data.codeUnitAt(state.pos - $6.start + 1) == 78 &&
                $6.data.codeUnitAt(state.pos - $6.start + 2) == 68;
            if ($8) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$7]));
            }
            state.input.endBuffering();
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
            final $13 = state.ok;
            if (!$13) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($4);
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
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
              final c = $10.data.runeAt(state.pos - $10.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  void fastParseTakeTil(State<String> state) {
    // $(![E] v:.)*
    const $4 = 'E';
    final $2 = state.input.indexOf($4, state.pos);
    final $3 = $2 != -1;
    if ($3) {
      state.pos = $2;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  AsyncResult<Object?> fastParseTakeTil$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    late int $4;
    late int $5;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            state.input.beginBuffering();
            $3 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            state.setOk(true);
            state.input.endBuffering();
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            $4 = state.pos;
            $5 = state.pos;
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
              final ok = $6.data.codeUnitAt(state.pos - $6.start) == 69;
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
            final $11 = state.ok;
            if (!$11) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($4);
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
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
              final c = $8.data.runeAt(state.pos - $8.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  void fastParseTakeUntil(State<String> state) {
    // $(!'END' v:.)*
    const $4 = 'END';
    final $2 = state.input.indexOf($4, state.pos);
    final $3 = $2 != -1;
    if ($3) {
      state.pos = $2;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$4]));
    }
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  AsyncResult<Object?> fastParseTakeUntil$Async(
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
            state.input.beginBuffering();
            $3 = state.ignoreErrors;
            state.ignoreErrors = true;
            $2 = 2;
            break;
          case 1:
            state.ignoreErrors = $3;
            state.setOk(true);
            state.input.endBuffering();
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            $4 = state.pos;
            $5 = state.pos;
            $2 = 3;
            break;
          case 3:
            final $6 = state.input;
            if (state.pos + 2 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $2 = 3;
              return;
            }
            const $7 = 'END';
            final $8 = state.pos + 2 < $6.end &&
                $6.data.codeUnitAt(state.pos - $6.start) == 69 &&
                $6.data.codeUnitAt(state.pos - $6.start + 1) == 78 &&
                $6.data.codeUnitAt(state.pos - $6.start + 2) == 68;
            if ($8) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$7]));
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
            final $13 = state.ok;
            if (!$13) {
              $2 = 4;
              break;
            }
            $2 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($4);
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
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
              final c = $10.data.runeAt(state.pos - $10.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  String? parseOrderedChoiceWithLiterals(State<String> state) {
    String? $0;
    final $2 = state.pos;
    var $1 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 97:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 98 &&
              input.codeUnitAt(pos2 + 1) == 99;
          if (ok) {
            $1 = 3;
            $0 = 'abc';
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
            if (ok) {
              $1 = 2;
              $0 = 'ab';
            } else {
              $1 = 1;
              $0 = 'a';
            }
          }
          break;
        case 100:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 101 &&
              input.codeUnitAt(pos2 + 1) == 102;
          if (ok) {
            $1 = 3;
            $0 = 'def';
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 101;
            if (ok) {
              $1 = 2;
              $0 = 'de';
            } else {
              $1 = 1;
              $0 = 'd';
            }
          }
          break;
        case 103:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 104;
          if (ok) {
            $1 = 2;
            $0 = 'gh';
          }
          break;
      }
    }
    if ($1 > 0) {
      state.pos += $1;
      state.setOk(true);
    } else {
      state.pos = $2;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
    return $0;
  }

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  AsyncResult<String> parseOrderedChoiceWithLiterals$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
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
            final $32 = !state.ok && state.isRecoverable;
            if (!$32) {
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
            if (state.pos + 1 >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 2;
              return;
            }
            const $9 = 'ab';
            final $10 = state.pos + 1 < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 97 &&
                $8.data.codeUnitAt(state.pos - $8.start + 1) == 98;
            if ($10) {
              state.pos += 2;
              state.setOk(true);
              $2 = $9;
            } else {
              state.fail(const ErrorExpectedTags([$9]));
            }
            final $33 = !state.ok && state.isRecoverable;
            if (!$33) {
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
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 4;
              return;
            }
            const $13 = 'a';
            final $14 = state.pos < $12.end &&
                $12.data.codeUnitAt(state.pos - $12.start) == 97;
            if ($14) {
              state.pos++;
              state.setOk(true);
              $2 = $13;
            } else {
              state.fail(const ErrorExpectedTags([$13]));
            }
            final $34 = !state.ok && state.isRecoverable;
            if (!$34) {
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
            if (state.pos + 2 >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 6;
              return;
            }
            const $17 = 'def';
            final $18 = state.pos + 2 < $16.end &&
                $16.data.codeUnitAt(state.pos - $16.start) == 100 &&
                $16.data.codeUnitAt(state.pos - $16.start + 1) == 101 &&
                $16.data.codeUnitAt(state.pos - $16.start + 2) == 102;
            if ($18) {
              state.pos += 3;
              state.setOk(true);
              $2 = $17;
            } else {
              state.fail(const ErrorExpectedTags([$17]));
            }
            final $35 = !state.ok && state.isRecoverable;
            if (!$35) {
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
            if (state.pos + 1 >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $3 = 8;
              return;
            }
            const $21 = 'de';
            final $22 = state.pos + 1 < $20.end &&
                $20.data.codeUnitAt(state.pos - $20.start) == 100 &&
                $20.data.codeUnitAt(state.pos - $20.start + 1) == 101;
            if ($22) {
              state.pos += 2;
              state.setOk(true);
              $2 = $21;
            } else {
              state.fail(const ErrorExpectedTags([$21]));
            }
            final $36 = !state.ok && state.isRecoverable;
            if (!$36) {
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
            const $25 = 'd';
            final $26 = state.pos < $24.end &&
                $24.data.codeUnitAt(state.pos - $24.start) == 100;
            if ($26) {
              state.pos++;
              state.setOk(true);
              $2 = $25;
            } else {
              state.fail(const ErrorExpectedTags([$25]));
            }
            final $37 = !state.ok && state.isRecoverable;
            if (!$37) {
              $3 = 11;
              break;
            }
            $3 = 12;
            break;
          case 11:
            $3 = 9;
            break;
          case 12:
            final $28 = state.input;
            if (state.pos + 1 >= $28.end && !$28.isClosed) {
              $28.sleep = true;
              $28.handle = $1;
              $3 = 12;
              return;
            }
            const $29 = 'gh';
            final $30 = state.pos + 1 < $28.end &&
                $28.data.codeUnitAt(state.pos - $28.start) == 103 &&
                $28.data.codeUnitAt(state.pos - $28.start + 1) == 104;
            if ($30) {
              state.pos += 2;
              state.setOk(true);
              $2 = $29;
            } else {
              state.fail(const ErrorExpectedTags([$29]));
            }
            $3 = 11;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  List<int>? parseSkipTil(State<String> state) {
    List<int>? $0;
    // (![E] v:.)*
    final $3 = <int>[];
    final $2 = state.ignoreErrors;
    state.ignoreErrors = true;
    while (true) {
      int? $4;
      // ![E] v:.
      final $6 = state.pos;
      final $7 = state.pos;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 69;
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
        int? $5;
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.pos += c > 0xffff ? 2 : 1;
          state.setOk(true);
          $5 = c;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $4 = $5;
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ignoreErrors = $2;
    state.setOk(true);
    if (state.ok) {
      $0 = $3;
    }
    return $0;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  AsyncResult<List<int>> parseSkipTil$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late bool $5;
    late List<int> $6;
    int? $4;
    late int $8;
    late int $9;
    int? $7;
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
            $8 = state.pos;
            $9 = state.pos;
            state.input.beginBuffering();
            $3 = 3;
            break;
          case 3:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $10.end) {
              final ok = $10.data.codeUnitAt(state.pos - $10.start) == 69;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
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
            final $15 = state.ok;
            if (!$15) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($8);
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $6.add($4!);
            $3 = 2;
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
              final c = $12.data.runeAt(state.pos - $12.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
              $7 = c;
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $4 = $7;
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

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  List<int>? parseSkipUntil(State<String> state) {
    List<int>? $0;
    // (!'END' v:.)*
    final $3 = <int>[];
    final $2 = state.ignoreErrors;
    state.ignoreErrors = true;
    while (true) {
      int? $4;
      // !'END' v:.
      final $6 = state.pos;
      final $7 = state.pos;
      const $8 = 'END';
      final $9 = state.pos + 2 < state.input.length &&
          state.input.codeUnitAt(state.pos) == 69 &&
          state.input.codeUnitAt(state.pos + 1) == 78 &&
          state.input.codeUnitAt(state.pos + 2) == 68;
      if ($9) {
        state.pos += 3;
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
        int? $5;
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.pos += c > 0xffff ? 2 : 1;
          state.setOk(true);
          $5 = c;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $4 = $5;
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok) {
        break;
      }
      $3.add($4!);
    }
    state.ignoreErrors = $2;
    state.setOk(true);
    if (state.ok) {
      $0 = $3;
    }
    return $0;
  }

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  AsyncResult<List<int>> parseSkipUntil$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<int>>();
    List<int>? $2;
    var $3 = 0;
    late bool $5;
    late List<int> $6;
    int? $4;
    late int $8;
    late int $9;
    int? $7;
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
            $8 = state.pos;
            $9 = state.pos;
            state.input.beginBuffering();
            $3 = 3;
            break;
          case 3:
            final $10 = state.input;
            if (state.pos + 2 >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 3;
              return;
            }
            const $11 = 'END';
            final $12 = state.pos + 2 < $10.end &&
                $10.data.codeUnitAt(state.pos - $10.start) == 69 &&
                $10.data.codeUnitAt(state.pos - $10.start + 1) == 78 &&
                $10.data.codeUnitAt(state.pos - $10.start + 2) == 68;
            if ($12) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$11]));
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
            final $17 = state.ok;
            if (!$17) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($8);
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $6.add($4!);
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
              final c = $14.data.runeAt(state.pos - $14.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
              $7 = c;
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              $4 = $7;
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

  /// Start =
  ///     (v:SkipUntil SkipUntil)
  ///   / (v:SkipTil SkipTil)
  ///   / (v:TakeUntil TakeUntil)
  ///   / (v:TakeTil TakeTil)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   ;
  Object? parseStart(State<String> state) {
    Object? $0;
    // (v:SkipUntil SkipUntil)
    // v:SkipUntil SkipUntil
    final $3 = state.pos;
    List<int>? $2;
    // SkipUntil
    $2 = parseSkipUntil(state);
    if (state.ok) {
      // SkipUntil
      fastParseSkipUntil(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // (v:SkipTil SkipTil)
      // v:SkipTil SkipTil
      final $6 = state.pos;
      List<int>? $5;
      // SkipTil
      $5 = parseSkipTil(state);
      if (state.ok) {
        // SkipTil
        fastParseSkipTil(state);
        if (state.ok) {
          $0 = $5;
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok && state.isRecoverable) {
        // (v:TakeUntil TakeUntil)
        // v:TakeUntil TakeUntil
        final $9 = state.pos;
        String? $8;
        // TakeUntil
        $8 = parseTakeUntil(state);
        if (state.ok) {
          // TakeUntil
          fastParseTakeUntil(state);
          if (state.ok) {
            $0 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok && state.isRecoverable) {
          // (v:TakeTil TakeTil)
          // v:TakeTil TakeTil
          final $12 = state.pos;
          String? $11;
          // TakeTil
          $11 = parseTakeTil(state);
          if (state.ok) {
            // TakeTil
            fastParseTakeTil(state);
            if (state.ok) {
              $0 = $11;
            }
          }
          if (!state.ok) {
            state.backtrack($12);
          }
          if (!state.ok && state.isRecoverable) {
            // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
            // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
            final $15 = state.pos;
            String? $14;
            // OrderedChoiceWithLiterals
            $14 = parseOrderedChoiceWithLiterals(state);
            if (state.ok) {
              // OrderedChoiceWithLiterals
              fastParseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                $0 = $14;
              }
            }
            if (!state.ok) {
              state.backtrack($15);
            }
            if (!state.ok && state.isRecoverable) {
              // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
              // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
              final $18 = state.pos;
              String? $17;
              // OrderedChoiceWithLiterals
              $17 = parseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                // OrderedChoiceWithLiterals
                fastParseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  $0 = $17;
                }
              }
              if (!state.ok) {
                state.backtrack($18);
              }
            }
          }
        }
      }
    }
    return $0;
  }

  /// Start =
  ///     (v:SkipUntil SkipUntil)
  ///   / (v:SkipTil SkipTil)
  ///   / (v:TakeUntil TakeUntil)
  ///   / (v:TakeTil TakeTil)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   ;
  AsyncResult<Object?> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $2;
    var $3 = 0;
    late int $5;
    List<int>? $4;
    late AsyncResult<List<int>> $6;
    late AsyncResult<Object?> $8;
    late int $11;
    List<int>? $10;
    late AsyncResult<List<int>> $12;
    late AsyncResult<Object?> $14;
    late int $17;
    String? $16;
    late AsyncResult<String> $18;
    late AsyncResult<Object?> $20;
    late int $23;
    String? $22;
    late AsyncResult<String> $24;
    late AsyncResult<Object?> $26;
    late int $29;
    String? $28;
    late AsyncResult<String> $30;
    late AsyncResult<Object?> $32;
    late int $35;
    String? $34;
    late AsyncResult<String> $36;
    late AsyncResult<Object?> $38;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $6 = parseSkipUntil$Async(state);
            if (!$6.isComplete) {
              $6.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $6.value;
            final $40 = state.ok;
            if (!$40) {
              $3 = 2;
              break;
            }
            $8 = fastParseSkipUntil$Async(state);
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
            final $41 = !state.ok && state.isRecoverable;
            if (!$41) {
              $3 = 4;
              break;
            }
            $11 = state.pos;
            $12 = parseSkipTil$Async(state);
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
            final $42 = state.ok;
            if (!$42) {
              $3 = 6;
              break;
            }
            $14 = fastParseSkipTil$Async(state);
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
            final $43 = !state.ok && state.isRecoverable;
            if (!$43) {
              $3 = 8;
              break;
            }
            $17 = state.pos;
            $18 = parseTakeUntil$Async(state);
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
            final $44 = state.ok;
            if (!$44) {
              $3 = 10;
              break;
            }
            $20 = fastParseTakeUntil$Async(state);
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
            final $45 = !state.ok && state.isRecoverable;
            if (!$45) {
              $3 = 12;
              break;
            }
            $23 = state.pos;
            $24 = parseTakeTil$Async(state);
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
            final $46 = state.ok;
            if (!$46) {
              $3 = 14;
              break;
            }
            $26 = fastParseTakeTil$Async(state);
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
            final $47 = !state.ok && state.isRecoverable;
            if (!$47) {
              $3 = 16;
              break;
            }
            $29 = state.pos;
            $30 = parseOrderedChoiceWithLiterals$Async(state);
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
            final $48 = state.ok;
            if (!$48) {
              $3 = 18;
              break;
            }
            $32 = fastParseOrderedChoiceWithLiterals$Async(state);
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
            final $49 = !state.ok && state.isRecoverable;
            if (!$49) {
              $3 = 20;
              break;
            }
            $35 = state.pos;
            $36 = parseOrderedChoiceWithLiterals$Async(state);
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
            final $50 = state.ok;
            if (!$50) {
              $3 = 22;
              break;
            }
            $38 = fastParseOrderedChoiceWithLiterals$Async(state);
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
            $3 = 20;
            break;
          case 23:
            if (state.ok) {
              $2 = $34;
            }
            $3 = 22;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  String? parseTakeTil(State<String> state) {
    String? $0;
    // $(![E] v:.)*
    final $2 = state.pos;
    const $5 = 'E';
    final $3 = state.input.indexOf($5, state.pos);
    final $4 = $3 != -1;
    if ($4) {
      state.pos = $3;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  AsyncResult<String> parseTakeTil$Async(State<ChunkedParsingSink> state) {
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
            state.input.beginBuffering();
            $5 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            state.setOk(true);
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $2 = input.data.substring($4 - start, state.pos - start);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            $6 = state.pos;
            $7 = state.pos;
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
              final ok = $8.data.codeUnitAt(state.pos - $8.start) == 69;
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
            final $13 = state.ok;
            if (!$13) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($6);
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
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
              final c = $10.data.runeAt(state.pos - $10.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  String? parseTakeUntil(State<String> state) {
    String? $0;
    // $(!'END' v:.)*
    final $2 = state.pos;
    const $5 = 'END';
    final $3 = state.input.indexOf($5, state.pos);
    final $4 = $3 != -1;
    if ($4) {
      state.pos = $3;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  AsyncResult<String> parseTakeUntil$Async(State<ChunkedParsingSink> state) {
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
            state.input.beginBuffering();
            $5 = state.ignoreErrors;
            state.ignoreErrors = true;
            $3 = 2;
            break;
          case 1:
            state.ignoreErrors = $5;
            state.setOk(true);
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $2 = input.data.substring($4 - start, state.pos - start);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            $6 = state.pos;
            $7 = state.pos;
            $3 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 2 >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 3;
              return;
            }
            const $9 = 'END';
            final $10 = state.pos + 2 < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 69 &&
                $8.data.codeUnitAt(state.pos - $8.start + 1) == 78 &&
                $8.data.codeUnitAt(state.pos - $8.start + 2) == 68;
            if ($10) {
              state.pos += 3;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$9]));
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
            final $15 = state.ok;
            if (!$15) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($6);
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $3 = 2;
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
              final c = $12.data.runeAt(state.pos - $12.start);
              state.pos += c > 0xffff ? 2 : 1;
              state.setOk(true);
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

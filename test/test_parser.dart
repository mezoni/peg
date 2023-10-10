class TestParser {
  bool flag = false;

  String text = '';

  /// int
  /// Integer =
  ///   v:$[0-9]+ <int>{}
  ///   ;
  void fastParseInteger(State<String> state) {
    // v:$[0-9]+ <int>{}
    String? $1;
    final $2 = state.pos;
    final $5 = state.pos;
    final $4 = state.input;
    while (state.pos < $4.length) {
      final $3 = $4.codeUnitAt(state.pos);
      state.ok = $3 >= 48 && $3 <= 57;
      if (!state.ok) {
        break;
      }
      state.pos++;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = state.pos > $5;
    if (state.ok) {
      $1 = state.input.substring($2, state.pos);
    }
    if (state.ok) {
      // ignore: unused_local_variable
      int? $$;
      final v = $1!;
      $$ = int.parse(v);
    }
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
    final $9 = state.pos;
    state.ok = false;
    final $1 = state.input;
    if (state.pos < $1.length) {
      final $0 = $1.runeAt(state.pos);
      state.pos += $0 > 0xffff ? 2 : 1;
      switch ($0) {
        case 97:
          const $2 = 'abc';
          state.ok = $1.startsWith($2, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
          } else {
            state.ok = state.pos < $1.length && $1.runeAt(state.pos) == 98;
            if (state.ok) {
              state.pos += 1;
            } else {
              state.ok = true;
            }
          }
          break;
        case 100:
          const $5 = 'def';
          state.ok = $1.startsWith($5, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
          } else {
            state.ok = state.pos < $1.length && $1.runeAt(state.pos) == 101;
            if (state.ok) {
              state.pos += 1;
            } else {
              state.ok = true;
            }
          }
          break;
        case 103:
          state.ok = state.pos < $1.length && $1.runeAt(state.pos) == 104;
          if (state.ok) {
            state.pos += 1;
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $9;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
  }

  /// SepBy =
  ///   @sepBy(Integer, ',')
  ///   ;
  void fastParseSepBy(State<String> state) {
    // @sepBy(Integer, ',')
    var $1 = state.pos;
    while (true) {
      // Integer
      // Integer
      fastParseInteger(state);
      if (!state.ok) {
        state.pos = $1;
        break;
      }
      $1 = state.pos;
      // ','
      const $4 = ',';
      matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
      if (!state.ok) {
        break;
      }
    }
    state.ok = true;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  void fastParseSkipTil(State<String> state) {
    // (![E] v:.)*
    const $2 = 'E';
    final $1 = state.input.indexOf($2, state.pos);
    state.ok = $1 != -1;
    if (state.ok) {
      state.pos = $1;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
  }

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  void fastParseSkipUntil(State<String> state) {
    // (!'END' v:.)*
    const $2 = 'END';
    final $1 = state.input.indexOf($2, state.pos);
    state.ok = $1 != -1;
    if (state.ok) {
      state.pos = $1;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$2]));
    }
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  void fastParseTakeTil(State<String> state) {
    // $(![E] v:.)*
    const $3 = 'E';
    final $2 = state.input.indexOf($3, state.pos);
    state.ok = $2 != -1;
    if (state.ok) {
      state.pos = $2;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  void fastParseTakeUntil(State<String> state) {
    // $(!'END' v:.)*
    const $3 = 'END';
    final $2 = state.input.indexOf($3, state.pos);
    state.ok = $2 != -1;
    if (state.ok) {
      state.pos = $2;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$3]));
    }
  }

  /// Verify41 =
  ///   @verify(Integer)
  ///   ;
  void fastParseVerify41(State<String> state) {
    // @verify(Integer)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    int? $1;
    // Integer
    // Integer
    $1 = parseInteger(state);
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $1!;
      ParseError? error;
      if ($$ != 41) {
        error = ErrorMessage(state.pos - pos, 'error');
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

  /// VerifyFlag =
  ///   @verify('')
  ///   ;
  void fastParseVerifyFlag(State<String> state) {
    // @verify('')
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    String? $1;
    // ''
    state.ok = true;
    if (state.ok) {
      $1 = '';
    }
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $1!;
      ParseError? error;
      if (!flag) {
        error = ErrorMessage(state.pos - pos, 'error');
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

  /// ZeroOrMore16 =
  ///   [0]*
  ///   ;
  void fastParseZeroOrMore16(State<String> state) {
    // [0]*
    final $2 = state.input;
    while (state.pos < $2.length) {
      final $1 = $2.codeUnitAt(state.pos);
      state.ok = $1 == 48;
      if (!state.ok) {
        break;
      }
      state.pos++;
    }
    state.fail(const ErrorExpectedCharacter(48));
    state.ok = true;
  }

  /// ZeroOrMore1632 =
  ///   [ -\u{1f680}]*
  ///   ;
  void fastParseZeroOrMore1632(State<String> state) {
    // [ -\u{1f680}]*
    final $2 = state.input;
    while (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.ok = $1 >= 32 && $1 <= 128640;
      if (!state.ok) {
        break;
      }
      state.pos += $1 > 0xffff ? 2 : 1;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// ZeroOrMore32 =
  ///   [\u{1f680}]*
  ///   ;
  void fastParseZeroOrMore32(State<String> state) {
    // [\u{1f680}]*
    final $2 = state.input;
    while (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.ok = $1 == 128640;
      if (!state.ok) {
        break;
      }
      state.pos += 2;
    }
    state.fail(const ErrorExpectedCharacter(128640));
    state.ok = true;
  }

  /// ZeroOrMore3232 =
  ///   [\u{1f680}-\u{1f681}]*
  ///   ;
  void fastParseZeroOrMore3232(State<String> state) {
    // [\u{1f680}-\u{1f681}]*
    final $2 = state.input;
    while (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.ok = $1 >= 128640 && $1 <= 128641;
      if (!state.ok) {
        break;
      }
      state.pos += 2;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// int
  /// Integer =
  ///   v:$[0-9]+ <int>{}
  ///   ;
  int? parseInteger(State<String> state) {
    int? $0;
    // v:$[0-9]+ <int>{}
    String? $2;
    final $3 = state.pos;
    final $6 = state.pos;
    final $5 = state.input;
    while (state.pos < $5.length) {
      final $4 = $5.codeUnitAt(state.pos);
      state.ok = $4 >= 48 && $4 <= 57;
      if (!state.ok) {
        break;
      }
      state.pos++;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = state.pos > $6;
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
    final $10 = state.pos;
    state.ok = false;
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $1 = $2.runeAt(state.pos);
      state.pos += $1 > 0xffff ? 2 : 1;
      switch ($1) {
        case 97:
          const $3 = 'abc';
          state.ok = $2.startsWith($3, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
            $0 = $3;
          } else {
            state.ok = state.pos < $2.length && $2.runeAt(state.pos) == 98;
            if (state.ok) {
              state.pos += 1;
              $0 = 'ab';
            } else {
              state.ok = true;
              $0 = 'a';
            }
          }
          break;
        case 100:
          const $6 = 'def';
          state.ok = $2.startsWith($6, state.pos - 1);
          if (state.ok) {
            state.pos += 2;
            $0 = $6;
          } else {
            state.ok = state.pos < $2.length && $2.runeAt(state.pos) == 101;
            if (state.ok) {
              state.pos += 1;
              $0 = 'de';
            } else {
              state.ok = true;
              $0 = 'd';
            }
          }
          break;
        case 103:
          state.ok = state.pos < $2.length && $2.runeAt(state.pos) == 104;
          if (state.ok) {
            state.pos += 1;
            $0 = 'gh';
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $10;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
    return $0;
  }

  /// SepBy =
  ///   @sepBy(Integer, ',')
  ///   ;
  List<int>? parseSepBy(State<String> state) {
    List<int>? $0;
    // @sepBy(Integer, ',')
    final $2 = <int>[];
    var $4 = state.pos;
    while (true) {
      int? $3;
      // Integer
      // Integer
      $3 = parseInteger(state);
      if (!state.ok) {
        state.pos = $4;
        break;
      }
      $2.add($3!);
      $4 = state.pos;
      // ','
      const $7 = ',';
      matchLiteral1(state, $7, const ErrorExpectedTags([$7]));
      if (!state.ok) {
        break;
      }
    }
    state.ok = true;
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  List<int>? parseSkipTil(State<String> state) {
    List<int>? $0;
    // (![E] v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // ![E] v:.
      final $4 = state.pos;
      final $6 = state.pos;
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 69;
      if (state.ok) {
        state.pos++;
      } else {
        state.fail(const ErrorExpectedCharacter(69));
      }
      state.ok = !state.ok;
      if (!state.ok) {
        final length = $6 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          1 => const ErrorUnexpectedInput(1),
          2 => const ErrorUnexpectedInput(2),
          _ => ErrorUnexpectedInput(length)
        });
      }
      state.pos = $6;
      if (state.ok) {
        int? $5;
        final $9 = state.input;
        if (state.pos < $9.length) {
          final $8 = $9.runeAt(state.pos);
          state.pos += $8 > 0xffff ? 2 : 1;
          state.ok = true;
          $5 = $8;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $5;
        }
      }
      if (!state.ok) {
        state.pos = $4;
      }
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

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  List<int>? parseSkipUntil(State<String> state) {
    List<int>? $0;
    // (!'END' v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // !'END' v:.
      final $4 = state.pos;
      final $6 = state.pos;
      const $8 = 'END';
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 69 &&
          state.input.startsWith($8, state.pos);
      if (state.ok) {
        state.pos += 3;
      } else {
        state.fail(const ErrorExpectedTags([$8]));
      }
      state.ok = !state.ok;
      if (!state.ok) {
        final length = $6 - state.pos;
        state.fail(switch (length) {
          0 => const ErrorUnexpectedInput(0),
          1 => const ErrorUnexpectedInput(1),
          2 => const ErrorUnexpectedInput(2),
          _ => ErrorUnexpectedInput(length)
        });
      }
      state.pos = $6;
      if (state.ok) {
        int? $5;
        final $10 = state.input;
        if (state.pos < $10.length) {
          final $9 = $10.runeAt(state.pos);
          state.pos += $9 > 0xffff ? 2 : 1;
          state.ok = true;
          $5 = $9;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $5;
        }
      }
      if (!state.ok) {
        state.pos = $4;
      }
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

  /// Start =
  ///     (v:MatchString MatchString)
  ///   / (v:SkipUntil SkipUntil)
  ///   / (v:SkipTil SkipTil)
  ///   / (v:TakeUntil TakeUntil)
  ///   / (v:TakeTil TakeTil)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   / (v:SepBy SepBy)
  ///   / (v:Verify41 Verify41)
  ///   / (v:VerifyFlag VerifyFlag)
  ///   / (v:ZeroOrMore16 ZeroOrMore16)
  ///   / (v:ZeroOrMore1632 ZeroOrMore1632)
  ///   / (v:ZeroOrMore32 ZeroOrMore32)
  ///   / (v:ZeroOrMore3232 ZeroOrMore3232)
  ///   ;
  Object? parseStart(State<String> state) {
    Object? $0;
    // (v:MatchString MatchString)
    // v:MatchString MatchString
    final $2 = state.pos;
    String? $3;
    // MatchString
    $3 = parseMatchString(state);
    if (state.ok) {
      // MatchString
      fastParseMatchString(state);
      if (state.ok) {
        $0 = $3;
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (!state.ok) {
      // (v:SkipUntil SkipUntil)
      // v:SkipUntil SkipUntil
      final $5 = state.pos;
      List<int>? $6;
      // SkipUntil
      $6 = parseSkipUntil(state);
      if (state.ok) {
        // SkipUntil
        fastParseSkipUntil(state);
        if (state.ok) {
          $0 = $6;
        }
      }
      if (!state.ok) {
        state.pos = $5;
      }
      if (!state.ok) {
        // (v:SkipTil SkipTil)
        // v:SkipTil SkipTil
        final $8 = state.pos;
        List<int>? $9;
        // SkipTil
        $9 = parseSkipTil(state);
        if (state.ok) {
          // SkipTil
          fastParseSkipTil(state);
          if (state.ok) {
            $0 = $9;
          }
        }
        if (!state.ok) {
          state.pos = $8;
        }
        if (!state.ok) {
          // (v:TakeUntil TakeUntil)
          // v:TakeUntil TakeUntil
          final $11 = state.pos;
          String? $12;
          // TakeUntil
          $12 = parseTakeUntil(state);
          if (state.ok) {
            // TakeUntil
            fastParseTakeUntil(state);
            if (state.ok) {
              $0 = $12;
            }
          }
          if (!state.ok) {
            state.pos = $11;
          }
          if (!state.ok) {
            // (v:TakeTil TakeTil)
            // v:TakeTil TakeTil
            final $14 = state.pos;
            String? $15;
            // TakeTil
            $15 = parseTakeTil(state);
            if (state.ok) {
              // TakeTil
              fastParseTakeTil(state);
              if (state.ok) {
                $0 = $15;
              }
            }
            if (!state.ok) {
              state.pos = $14;
            }
            if (!state.ok) {
              // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
              // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
              final $17 = state.pos;
              String? $18;
              // OrderedChoiceWithLiterals
              $18 = parseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                // OrderedChoiceWithLiterals
                fastParseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  $0 = $18;
                }
              }
              if (!state.ok) {
                state.pos = $17;
              }
              if (!state.ok) {
                // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
                // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
                final $20 = state.pos;
                String? $21;
                // OrderedChoiceWithLiterals
                $21 = parseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  // OrderedChoiceWithLiterals
                  fastParseOrderedChoiceWithLiterals(state);
                  if (state.ok) {
                    $0 = $21;
                  }
                }
                if (!state.ok) {
                  state.pos = $20;
                }
                if (!state.ok) {
                  // (v:SepBy SepBy)
                  // v:SepBy SepBy
                  final $23 = state.pos;
                  List<int>? $24;
                  // SepBy
                  $24 = parseSepBy(state);
                  if (state.ok) {
                    // SepBy
                    fastParseSepBy(state);
                    if (state.ok) {
                      $0 = $24;
                    }
                  }
                  if (!state.ok) {
                    state.pos = $23;
                  }
                  if (!state.ok) {
                    // (v:Verify41 Verify41)
                    // v:Verify41 Verify41
                    final $26 = state.pos;
                    int? $27;
                    // Verify41
                    $27 = parseVerify41(state);
                    if (state.ok) {
                      // Verify41
                      fastParseVerify41(state);
                      if (state.ok) {
                        $0 = $27;
                      }
                    }
                    if (!state.ok) {
                      state.pos = $26;
                    }
                    if (!state.ok) {
                      // (v:VerifyFlag VerifyFlag)
                      // v:VerifyFlag VerifyFlag
                      final $29 = state.pos;
                      String? $30;
                      // VerifyFlag
                      $30 = parseVerifyFlag(state);
                      if (state.ok) {
                        // VerifyFlag
                        fastParseVerifyFlag(state);
                        if (state.ok) {
                          $0 = $30;
                        }
                      }
                      if (!state.ok) {
                        state.pos = $29;
                      }
                      if (!state.ok) {
                        // (v:ZeroOrMore16 ZeroOrMore16)
                        // v:ZeroOrMore16 ZeroOrMore16
                        final $32 = state.pos;
                        List<int>? $33;
                        // ZeroOrMore16
                        $33 = parseZeroOrMore16(state);
                        if (state.ok) {
                          // ZeroOrMore16
                          fastParseZeroOrMore16(state);
                          if (state.ok) {
                            $0 = $33;
                          }
                        }
                        if (!state.ok) {
                          state.pos = $32;
                        }
                        if (!state.ok) {
                          // (v:ZeroOrMore1632 ZeroOrMore1632)
                          // v:ZeroOrMore1632 ZeroOrMore1632
                          final $35 = state.pos;
                          List<int>? $36;
                          // ZeroOrMore1632
                          $36 = parseZeroOrMore1632(state);
                          if (state.ok) {
                            // ZeroOrMore1632
                            fastParseZeroOrMore1632(state);
                            if (state.ok) {
                              $0 = $36;
                            }
                          }
                          if (!state.ok) {
                            state.pos = $35;
                          }
                          if (!state.ok) {
                            // (v:ZeroOrMore32 ZeroOrMore32)
                            // v:ZeroOrMore32 ZeroOrMore32
                            final $38 = state.pos;
                            List<int>? $39;
                            // ZeroOrMore32
                            $39 = parseZeroOrMore32(state);
                            if (state.ok) {
                              // ZeroOrMore32
                              fastParseZeroOrMore32(state);
                              if (state.ok) {
                                $0 = $39;
                              }
                            }
                            if (!state.ok) {
                              state.pos = $38;
                            }
                            if (!state.ok) {
                              // (v:ZeroOrMore3232 ZeroOrMore3232)
                              // v:ZeroOrMore3232 ZeroOrMore3232
                              final $41 = state.pos;
                              List<int>? $42;
                              // ZeroOrMore3232
                              $42 = parseZeroOrMore3232(state);
                              if (state.ok) {
                                // ZeroOrMore3232
                                fastParseZeroOrMore3232(state);
                                if (state.ok) {
                                  $0 = $42;
                                }
                              }
                              if (!state.ok) {
                                state.pos = $41;
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

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  String? parseTakeTil(State<String> state) {
    String? $0;
    // $(![E] v:.)*
    final $2 = state.pos;
    const $4 = 'E';
    final $3 = state.input.indexOf($4, state.pos);
    state.ok = $3 != -1;
    if (state.ok) {
      state.pos = $3;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  String? parseTakeUntil(State<String> state) {
    String? $0;
    // $(!'END' v:.)*
    final $2 = state.pos;
    const $4 = 'END';
    final $3 = state.input.indexOf($4, state.pos);
    state.ok = $3 != -1;
    if (state.ok) {
      state.pos = $3;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// Verify41 =
  ///   @verify(Integer)
  ///   ;
  int? parseVerify41(State<String> state) {
    int? $0;
    // @verify(Integer)
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    // Integer
    // Integer
    $0 = parseInteger(state);
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $0!;
      ParseError? error;
      if ($$ != 41) {
        error = ErrorMessage(state.pos - pos, 'error');
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
    return $0;
  }

  /// VerifyFlag =
  ///   @verify('')
  ///   ;
  String? parseVerifyFlag(State<String> state) {
    String? $0;
    // @verify('')
    final $4 = state.pos;
    final $3 = state.failPos;
    final $2 = state.errorCount;
    // ''
    state.ok = true;
    if (state.ok) {
      $0 = '';
    }
    if (state.ok) {
      final pos = $4;
      // ignore: unused_local_variable
      final $$ = $0!;
      ParseError? error;
      if (!flag) {
        error = ErrorMessage(state.pos - pos, 'error');
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
    return $0;
  }

  /// ZeroOrMore16 =
  ///   [0]*
  ///   ;
  List<int>? parseZeroOrMore16(State<String> state) {
    List<int>? $0;
    // [0]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 48;
      if (state.ok) {
        state.pos++;
        $3 = 48;
      } else {
        state.fail(const ErrorExpectedCharacter(48));
      }
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

  /// ZeroOrMore1632 =
  ///   [ -\u{1f680}]*
  ///   ;
  List<int>? parseZeroOrMore1632(State<String> state) {
    List<int>? $0;
    // [ -\u{1f680}]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $4 = state.input.runeAt(state.pos);
        state.ok = $4 >= 32 && $4 <= 128640;
        if (state.ok) {
          state.pos += $4 > 0xffff ? 2 : 1;
          $3 = $4;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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

  /// ZeroOrMore32 =
  ///   [\u{1f680}]*
  ///   ;
  List<int>? parseZeroOrMore32(State<String> state) {
    List<int>? $0;
    // [\u{1f680}]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      state.ok = state.pos < state.input.length &&
          state.input.runeAt(state.pos) == 128640;
      if (state.ok) {
        state.pos += 2;
        $3 = 128640;
      } else {
        state.fail(const ErrorExpectedCharacter(128640));
      }
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

  /// ZeroOrMore3232 =
  ///   [\u{1f680}-\u{1f681}]*
  ///   ;
  List<int>? parseZeroOrMore3232(State<String> state) {
    List<int>? $0;
    // [\u{1f680}-\u{1f681}]*
    final $2 = <int>[];
    while (true) {
      int? $3;
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $4 = state.input.runeAt(state.pos);
        state.ok = $4 >= 128640 && $4 <= 128641;
        if (state.ok) {
          state.pos += 2;
          $3 = $4;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral(State<String> state, String string, ParseError error) {
    final input = state.input;
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
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
    final source = _StringWrapper(
      invalidChar: 32,
      leftPadding: 0,
      rightPadding: 0,
      source: input,
    );
    message = _errorMessage(source, offset, normalized);
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

    if (_lastPosition > start) {
      if (_lastPosition == end) {
        this.data = '';
      } else {
        this.data = this.data.substring(_lastPosition - start);
      }

      start = _lastPosition;
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
      if (input is String) {
        if (offset < input.length) {
          char = input.runeAt(offset);
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

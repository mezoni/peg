class TestParser {
  bool flag = false;

  String text = '';

  /// int
  /// Integer =
  ///   v:$[0-9]+ <int>{}
  ///   ;
  void fastParseInteger(State<StringReader> state) {
    // v:$[0-9]+ <int>{}
    String? $1;
    final $2 = state.pos;
    var $3 = false;
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $4 = state.input.readChar(state.pos);
        state.ok = $4 >= 48 && $4 <= 57;
        if (state.ok) {
          state.pos += state.input.count;
        }
      }
      if (!state.ok) {
        state.fail(const ErrorUnexpectedCharacter());
      }
      if (!state.ok) {
        break;
      }
      $3 = true;
    }
    state.ok = $3;
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
  void fastParseMatchString(State<StringReader> state) {
    // @matchString()
    final $1 = text;
    if ($1.isEmpty) {
      state.ok = true;
    } else {
      state.ok = state.input.startsWith($1, state.pos);
      if (state.ok) {
        state.pos += state.input.count;
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
  void fastParseOrderedChoiceWithLiterals(State<StringReader> state) {
    state.ok = false;
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $0 = $2.readChar(state.pos);
      // ignore: unused_local_variable
      final $1 = $2.count;
      switch ($0) {
        case 97:
          const $3 = 'abc';
          state.ok = $2.startsWith($3, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          } else {
            state.ok = $2.matchChar(98, state.pos + $1);
            if (state.ok) {
              state.pos += $1 + $2.count;
            } else {
              state.ok = true;
              state.pos += $1;
            }
          }
          break;
        case 100:
          const $6 = 'def';
          state.ok = $2.startsWith($6, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          } else {
            state.ok = $2.matchChar(101, state.pos + $1);
            if (state.ok) {
              state.pos += $1 + $2.count;
            } else {
              state.ok = true;
              state.pos += $1;
            }
          }
          break;
        case 103:
          state.ok = $2.matchChar(104, state.pos + $1);
          if (state.ok) {
            state.pos += $1 + $2.count;
          }
          break;
      }
    }
    if (!state.ok) {
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
  }

  /// SepBy =
  ///   @sepBy(Integer, ',')
  ///   ;
  void fastParseSepBy(State<StringReader> state) {
    // @sepBy(Integer, ',')
    // Integer
    // Integer
    fastParseInteger(state);
    if (state.ok) {
      while (true) {
        final $1 = state.pos;
        // ','
        const $4 = ',';
        matchLiteral1(state, 44, $4, const ErrorExpectedTags([$4]));
        if (!state.ok) {
          break;
        }
        // Integer
        // Integer
        fastParseInteger(state);
        if (!state.ok) {
          state.pos = $1;
          break;
        }
      }
    }
    state.ok = true;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  void fastParseSkipTil(State<StringReader> state) {
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
  void fastParseSkipUntil(State<StringReader> state) {
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
  void fastParseTakeTil(State<StringReader> state) {
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
  void fastParseTakeUntil(State<StringReader> state) {
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
  void fastParseVerify41(State<StringReader> state) {
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
  void fastParseVerifyFlag(State<StringReader> state) {
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

  /// int
  /// Integer =
  ///   v:$[0-9]+ <int>{}
  ///   ;
  int? parseInteger(State<StringReader> state) {
    int? $0;
    // v:$[0-9]+ <int>{}
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
        }
      }
      if (!state.ok) {
        state.fail(const ErrorUnexpectedCharacter());
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

  /// MatchString =
  ///   @matchString()
  ///   ;
  String? parseMatchString(State<StringReader> state) {
    String? $0;
    // @matchString()
    final $2 = text;
    if ($2.isEmpty) {
      state.ok = true;
      $0 = '';
    } else {
      state.ok = state.input.startsWith($2, state.pos);
      if (state.ok) {
        state.pos += state.input.count;
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
  String? parseOrderedChoiceWithLiterals(State<StringReader> state) {
    String? $0;
    state.ok = false;
    final $3 = state.input;
    if (state.pos < $3.length) {
      final $1 = $3.readChar(state.pos);
      // ignore: unused_local_variable
      final $2 = $3.count;
      switch ($1) {
        case 97:
          const $4 = 'abc';
          state.ok = $3.startsWith($4, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $4;
          } else {
            state.ok = $3.matchChar(98, state.pos + $2);
            if (state.ok) {
              state.pos += $2 + $3.count;
              $0 = 'ab';
            } else {
              state.ok = true;
              state.pos += $2;
              $0 = 'a';
            }
          }
          break;
        case 100:
          const $7 = 'def';
          state.ok = $3.startsWith($7, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $7;
          } else {
            state.ok = $3.matchChar(101, state.pos + $2);
            if (state.ok) {
              state.pos += $2 + $3.count;
              $0 = 'de';
            } else {
              state.ok = true;
              state.pos += $2;
              $0 = 'd';
            }
          }
          break;
        case 103:
          state.ok = $3.matchChar(104, state.pos + $2);
          if (state.ok) {
            state.pos += $2 + $3.count;
            $0 = 'gh';
          }
          break;
      }
    }
    if (!state.ok) {
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
    return $0;
  }

  /// SepBy =
  ///   @sepBy(Integer, ',')
  ///   ;
  List<int>? parseSepBy(State<StringReader> state) {
    List<int>? $0;
    // @sepBy(Integer, ',')
    final $3 = <int>[];
    int? $4;
    // Integer
    // Integer
    $4 = parseInteger(state);
    if (state.ok) {
      $3.add($4!);
      while (true) {
        final $2 = state.pos;
        // ','
        const $7 = ',';
        matchLiteral1(state, 44, $7, const ErrorExpectedTags([$7]));
        if (!state.ok) {
          $0 = $3;
          break;
        }
        // Integer
        // Integer
        $4 = parseInteger(state);
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

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  List<int>? parseSkipTil(State<StringReader> state) {
    List<int>? $0;
    // (![E] v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // ![E] v:.
      final $4 = state.pos;
      final $6 = state.pos;
      matchChar(state, 69, const ErrorUnexpectedCharacter(69));
      state.ok = !state.ok;
      if (!state.ok) {
        state.failAt($6, const ErrorUnexpectedInput());
      }
      state.pos = $6;
      if (state.ok) {
        int? $5;
        final $8 = state.input;
        if (state.pos < $8.length) {
          $5 = $8.readChar(state.pos);
          state.pos += $8.count;
          state.ok = true;
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
  List<int>? parseSkipUntil(State<StringReader> state) {
    List<int>? $0;
    // (!'END' v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // !'END' v:.
      final $4 = state.pos;
      final $6 = state.pos;
      const $8 = 'END';
      matchLiteral(state, $8, const ErrorExpectedTags([$8]));
      state.ok = !state.ok;
      if (!state.ok) {
        state.failAt($6, const ErrorUnexpectedInput());
      }
      state.pos = $6;
      if (state.ok) {
        int? $5;
        final $9 = state.input;
        if (state.pos < $9.length) {
          $5 = $9.readChar(state.pos);
          state.pos += $9.count;
          state.ok = true;
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
  ///   ;
  Object? parseStart(State<StringReader> state) {
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
  String? parseTakeTil(State<StringReader> state) {
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
  String? parseTakeUntil(State<StringReader> state) {
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
  int? parseVerify41(State<StringReader> state) {
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
      $0 = null;
      state.pos = $4;
    }
    return $0;
  }

  /// VerifyFlag =
  ///   @verify('')
  ///   ;
  String? parseVerifyFlag(State<StringReader> state) {
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
      $0 = null;
      state.pos = $4;
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
  int? matchCharAsync(State<ChunkedData> state, int char, ParseError error) {
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
      state.fail(const ErrorExpectedCharacter(48));
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
  String? matchLiteral1Async(
      State<ChunkedData> state, int char, String string, ParseError error) {
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
      State<ChunkedData> state, String string, ParseError error) {
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
  void Function(State<StringReader> state) fastParse,
  String source, {
  String Function(StringReader input, int offset, List<ErrorMessage> errors)?
      errorMessage,
}) {
  final input = StringReader(source);
  final result = tryFastParse(
    fastParse,
    input,
    errorMessage: errorMessage,
  );
  result.getResult();
}

void parseChunkedData<O>(
  AsyncResult<O> Function(State<ChunkedData> state) parse,
  ChunkedData input,
  void Function(ParseResult<ChunkedData, O> result) onComplete, {
  String Function(StringReader input, int offset, List<ErrorMessage> errors)?
      errorMessage,
}) {
  final state = State(input);
  final result = parse(state);
  void complete() {
    final parseResult = _createParseResult<ChunkedData, O>(state, result.value);
    onComplete(parseResult);
  }

  if (result.isComplete) {
    complete();
  } else {
    result.onComplete = complete;
  }
}

O parseInput<I, O>(
  O? Function(State<I> state) parse,
  I input, {
  String Function(I input, int offset, List<ErrorMessage> errors)? errorMessage,
}) {
  final result = tryParse(
    parse,
    input,
    errorMessage: errorMessage,
  );
  return result.getResult();
}

O parseString<O>(
  O? Function(State<StringReader> state) parse,
  String source, {
  String Function(StringReader input, int offset, List<ErrorMessage> errors)?
      errorMessage,
}) {
  final input = StringReader(source);
  final result = tryParse(
    parse,
    input,
    errorMessage: errorMessage,
  );
  return result.getResult();
}

ParseResult<I, void> tryFastParse<I>(
  void Function(State<I> state) fastParse,
  I input, {
  String Function(I input, int offset, List<ErrorMessage> errors)? errorMessage,
}) {
  final result = _parse<I, void>(
    fastParse,
    input,
    errorMessage: errorMessage,
  );
  return result;
}

ParseResult<I, O> tryParse<I, O>(
  O? Function(State<I> state) parse,
  I input, {
  String Function(I input, int offset, List<ErrorMessage> errors)? errorMessage,
}) {
  final result = _parse<I, O>(
    parse,
    input,
    errorMessage: errorMessage,
  );
  return result;
}

ParseResult<I, O> _createParseResult<I, O>(
  State<I> state,
  O? result, {
  String Function(I input, int offset, List<ErrorMessage> errors)? errorMessage,
}) {
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
  if (errorMessage != null) {
    message = errorMessage(input, offset, normalized);
  } else if (input is StringReader) {
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
  } else if (input is ChunkedData) {
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
  final result = errors.toList();
  if (input case final StringReader input) {
    if (offset >= input.length) {
      result.add(const ErrorUnexpectedEndOfInput());
      result.removeWhere((e) => e is ErrorUnexpectedCharacter);
    }
  } else if (input case final ChunkedData input) {
    if (input.isClosed && offset == input.start + input.data.length) {
      result.add(const ErrorUnexpectedEndOfInput());
      result.removeWhere((e) => e is ErrorUnexpectedCharacter);
    }
  }

  final expectedTags = result.whereType<ErrorExpectedTags>().toList();
  if (expectedTags.isNotEmpty) {
    result.removeWhere((e) => e is ErrorExpectedTags);
    final tags = <String>{};
    for (final error in expectedTags) {
      tags.addAll(error.tags);
    }

    final tagList = tags.toList();
    tagList.sort();
    final error = ErrorExpectedTags(tagList);
    result.add(error);
  }

  return result;
}

ParseResult<I, O> _parse<I, O>(
  O? Function(State<I> input) parse,
  I input, {
  String Function(I input, int offset, List<ErrorMessage> errors)? errorMessage,
}) {
  final state = State(input);
  final result = parse(state);
  return _createParseResult<I, O>(
    state,
    result,
    errorMessage: errorMessage,
  );
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

class ChunkedData implements Sink<String> {
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
    if (input is StringReader && input.hasSource) {
      if (offset case final int offset) {
        if (offset < input.length) {
          char = input.readChar(offset);
        } else {
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
    return const ErrorMessage(0, ErrorUnexpectedEndOfInput.message);
  }
}

class ErrorUnexpectedInput extends ParseError {
  static const message = 'Unexpected input';

  const ErrorUnexpectedInput();

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return const ErrorMessage(0, ErrorUnexpectedInput.message);
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
    } else if (input case final ChunkedData input) {
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

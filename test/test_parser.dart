// ignore_for_file: prefer_final_locals

class TestParser {
  /// **A**
  ///
  ///```code
  /// `Object?`
  /// A =
  ///    $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = Seq2 Seq2Void / $ = Seq3 Seq3Void / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
  ///```
  Object? parseA(State state) {
    Object? $0;
    // >> $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = Seq2 Seq2Void / $ = Seq3 Seq3Void / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
    final $pos = state.position;
    Object? $1;
    // >> $ = '' AndAbc
    // >> $ = ''
    state.isSuccess = true;
    final $2 = state.isSuccess ? '' : null;
    // << $ = ''
    if (state.isSuccess) {
      String $ = $2!;
      // >> AndAbc
      parseAndAbc(state);
      // << AndAbc
      $1 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = '' AndAbc
    if (!state.isSuccess) {
      // >> $ = AnyChar AnyCharVoid
      // >> $ = AnyChar
      final $3 = parseAnyChar(state);
      // << $ = AnyChar
      if (state.isSuccess) {
        Object? $ = $3;
        // >> AnyCharVoid
        parseAnyCharVoid(state);
        // << AnyCharVoid
        $1 = $;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      // << $ = AnyChar AnyCharVoid
      if (!state.isSuccess) {
        // >> $ = Char16 Char16Void
        // >> $ = Char16
        final $4 = parseChar16(state);
        // << $ = Char16
        if (state.isSuccess) {
          Object? $ = $4;
          // >> Char16Void
          parseChar16Void(state);
          // << Char16Void
          $1 = $;
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << $ = Char16 Char16Void
        if (!state.isSuccess) {
          // >> $ = Chars16 Chars16Void
          // >> $ = Chars16
          final $5 = parseChars16(state);
          // << $ = Chars16
          if (state.isSuccess) {
            Object? $ = $5;
            // >> Chars16Void
            parseChars16Void(state);
            // << Chars16Void
            $1 = $;
          }
          if (!state.isSuccess) {
            state.position = $pos;
          }
          // << $ = Chars16 Chars16Void
          if (!state.isSuccess) {
            // >> $ = Char32 Char32Void
            // >> $ = Char32
            final $6 = parseChar32(state);
            // << $ = Char32
            if (state.isSuccess) {
              Object? $ = $6;
              // >> Char32Void
              parseChar32Void(state);
              // << Char32Void
              $1 = $;
            }
            if (!state.isSuccess) {
              state.position = $pos;
            }
            // << $ = Char32 Char32Void
            if (!state.isSuccess) {
              // >> $ = Chars32 Chars32Void
              // >> $ = Chars32
              final $7 = parseChars32(state);
              // << $ = Chars32
              if (state.isSuccess) {
                Object? $ = $7;
                // >> Chars32Void
                parseChars32Void(state);
                // << Chars32Void
                $1 = $;
              }
              if (!state.isSuccess) {
                state.position = $pos;
              }
              // << $ = Chars32 Chars32Void
              if (!state.isSuccess) {
                // >> $ = Literal0 Literal0Void
                // >> $ = Literal0
                final $8 = parseLiteral0(state);
                // << $ = Literal0
                if (state.isSuccess) {
                  Object? $ = $8;
                  // >> Literal0Void
                  parseLiteral0Void(state);
                  // << Literal0Void
                  $1 = $;
                }
                if (!state.isSuccess) {
                  state.position = $pos;
                }
                // << $ = Literal0 Literal0Void
                if (!state.isSuccess) {
                  // >> $ = Literal1 Literal1Void
                  // >> $ = Literal1
                  final $9 = parseLiteral1(state);
                  // << $ = Literal1
                  if (state.isSuccess) {
                    Object? $ = $9;
                    // >> Literal1Void
                    parseLiteral1Void(state);
                    // << Literal1Void
                    $1 = $;
                  }
                  if (!state.isSuccess) {
                    state.position = $pos;
                  }
                  // << $ = Literal1 Literal1Void
                  if (!state.isSuccess) {
                    // >> $ = Literal2 Literal2Void
                    // >> $ = Literal2
                    final $10 = parseLiteral2(state);
                    // << $ = Literal2
                    if (state.isSuccess) {
                      Object? $ = $10;
                      // >> Literal2Void
                      parseLiteral2Void(state);
                      // << Literal2Void
                      $1 = $;
                    }
                    if (!state.isSuccess) {
                      state.position = $pos;
                    }
                    // << $ = Literal2 Literal2Void
                    if (!state.isSuccess) {
                      // >> $ = Match MatchVoid
                      // >> $ = Match
                      final $11 = parseMatch(state);
                      // << $ = Match
                      if (state.isSuccess) {
                        Object? $ = $11;
                        // >> MatchVoid
                        parseMatchVoid(state);
                        // << MatchVoid
                        $1 = $;
                      }
                      if (!state.isSuccess) {
                        state.position = $pos;
                      }
                      // << $ = Match MatchVoid
                      if (!state.isSuccess) {
                        // >> $ = NotDigits NotDigitsVoid
                        // >> $ = NotDigits
                        final $12 = parseNotDigits(state);
                        // << $ = NotDigits
                        if (state.isSuccess) {
                          Object? $ = $12;
                          // >> NotDigitsVoid
                          parseNotDigitsVoid(state);
                          // << NotDigitsVoid
                          $1 = $;
                        }
                        if (!state.isSuccess) {
                          state.position = $pos;
                        }
                        // << $ = NotDigits NotDigitsVoid
                        if (!state.isSuccess) {
                          // >> $ = '' NotAbc
                          // >> $ = ''
                          state.isSuccess = true;
                          final $13 = state.isSuccess ? '' : null;
                          // << $ = ''
                          if (state.isSuccess) {
                            String $ = $13!;
                            // >> NotAbc
                            parseNotAbc(state);
                            // << NotAbc
                            $1 = $;
                          }
                          if (!state.isSuccess) {
                            state.position = $pos;
                          }
                          // << $ = '' NotAbc
                          if (!state.isSuccess) {
                            // >> $ = OneOrMore OneOrMoreVoid
                            // >> $ = OneOrMore
                            final $14 = parseOneOrMore(state);
                            // << $ = OneOrMore
                            if (state.isSuccess) {
                              Object? $ = $14;
                              // >> OneOrMoreVoid
                              parseOneOrMoreVoid(state);
                              // << OneOrMoreVoid
                              $1 = $;
                            }
                            if (!state.isSuccess) {
                              state.position = $pos;
                            }
                            // << $ = OneOrMore OneOrMoreVoid
                            if (!state.isSuccess) {
                              // >> $ = Optional OptionalVoid
                              // >> $ = Optional
                              final $15 = parseOptional(state);
                              // << $ = Optional
                              if (state.isSuccess) {
                                Object? $ = $15;
                                // >> OptionalVoid
                                parseOptionalVoid(state);
                                // << OptionalVoid
                                $1 = $;
                              }
                              if (!state.isSuccess) {
                                state.position = $pos;
                              }
                              // << $ = Optional OptionalVoid
                              if (!state.isSuccess) {
                                // >> $ = OrderedChoice OrderedChoiceVoid
                                // >> $ = OrderedChoice
                                final $16 = parseOrderedChoice(state);
                                // << $ = OrderedChoice
                                if (state.isSuccess) {
                                  Object? $ = $16;
                                  // >> OrderedChoiceVoid
                                  parseOrderedChoiceVoid(state);
                                  // << OrderedChoiceVoid
                                  $1 = $;
                                }
                                if (!state.isSuccess) {
                                  state.position = $pos;
                                }
                                // << $ = OrderedChoice OrderedChoiceVoid
                                if (!state.isSuccess) {
                                  // >> $ = Ranges RangesVoid
                                  // >> $ = Ranges
                                  final $17 = parseRanges(state);
                                  // << $ = Ranges
                                  if (state.isSuccess) {
                                    Object? $ = $17;
                                    // >> RangesVoid
                                    parseRangesVoid(state);
                                    // << RangesVoid
                                    $1 = $;
                                  }
                                  if (!state.isSuccess) {
                                    state.position = $pos;
                                  }
                                  // << $ = Ranges RangesVoid
                                  if (!state.isSuccess) {
                                    // >> $ = Seq2 Seq2Void
                                    // >> $ = Seq2
                                    final $18 = parseSeq2(state);
                                    // << $ = Seq2
                                    if (state.isSuccess) {
                                      Object? $ = $18;
                                      // >> Seq2Void
                                      parseSeq2Void(state);
                                      // << Seq2Void
                                      $1 = $;
                                    }
                                    if (!state.isSuccess) {
                                      state.position = $pos;
                                    }
                                    // << $ = Seq2 Seq2Void
                                    if (!state.isSuccess) {
                                      // >> $ = Seq3 Seq3Void
                                      // >> $ = Seq3
                                      final $19 = parseSeq3(state);
                                      // << $ = Seq3
                                      if (state.isSuccess) {
                                        Object? $ = $19;
                                        // >> Seq3Void
                                        parseSeq3Void(state);
                                        // << Seq3Void
                                        $1 = $;
                                      }
                                      if (!state.isSuccess) {
                                        state.position = $pos;
                                      }
                                      // << $ = Seq3 Seq3Void
                                      if (!state.isSuccess) {
                                        // >> $ = TakeWhile TakeWhileVoid
                                        // >> $ = TakeWhile
                                        final $20 = parseTakeWhile(state);
                                        // << $ = TakeWhile
                                        if (state.isSuccess) {
                                          Object? $ = $20;
                                          // >> TakeWhileVoid
                                          parseTakeWhileVoid(state);
                                          // << TakeWhileVoid
                                          $1 = $;
                                        }
                                        if (!state.isSuccess) {
                                          state.position = $pos;
                                        }
                                        // << $ = TakeWhile TakeWhileVoid
                                        if (!state.isSuccess) {
                                          // >> $ = TakeWhile1 TakeWhile1Void
                                          // >> $ = TakeWhile1
                                          final $21 = parseTakeWhile1(state);
                                          // << $ = TakeWhile1
                                          if (state.isSuccess) {
                                            Object? $ = $21;
                                            // >> TakeWhile1Void
                                            parseTakeWhile1Void(state);
                                            // << TakeWhile1Void
                                            $1 = $;
                                          }
                                          if (!state.isSuccess) {
                                            state.position = $pos;
                                          }
                                          // << $ = TakeWhile1 TakeWhile1Void
                                          if (!state.isSuccess) {
                                            // >> $ = ZeroOrMore ZeroOrMoreVoid
                                            // >> $ = ZeroOrMore
                                            final $22 = parseZeroOrMore(state);
                                            // << $ = ZeroOrMore
                                            if (state.isSuccess) {
                                              Object? $ = $22;
                                              // >> ZeroOrMoreVoid
                                              parseZeroOrMoreVoid(state);
                                              // << ZeroOrMoreVoid
                                              $1 = $;
                                            }
                                            if (!state.isSuccess) {
                                              state.position = $pos;
                                            }
                                            // << $ = ZeroOrMore ZeroOrMoreVoid
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
    if (state.isSuccess) {
      Object? $ = $1;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = Seq2 Seq2Void / $ = Seq3 Seq3Void / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
    return $0;
  }

  /// **AndAbc**
  ///
  ///```code
  /// `void`
  /// AndAbc =
  ///    &'abc'
  ///```
  void parseAndAbc(State state) {
    final $input = state.input;
    // >> &'abc'
    final $pos1 = state.position;
    // >> 'abc'
    const $literal = 'abc';
    var $pos = $pos1;
    state.isSuccess = state.position + 3 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98 &&
        $input.codeUnitAt($pos++) == 99;
    state.isSuccess ? state.position += 3 : state.fail();
    state.expected($literal, $pos1);
    // << 'abc'
    state.position = $pos1;
    // << &'abc'
  }

  /// **AnyChar**
  ///
  ///```code
  /// `int`
  /// AnyChar =
  ///    $ = .
  ///```
  int? parseAnyChar(State state) {
    int? $0;
    // >> $ = .
    final $pos = state.position;
    int? $1;
    if (state.isSuccess = state.position < state.input.length) {
      $1 = state.input.readChar(state.position);
      state.position += $1 > 0xffff ? 2 : 1;
    } else {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = .
    return $0;
  }

  /// **AnyCharVoid**
  ///
  ///```code
  /// `int`
  /// AnyCharVoid =
  ///    $ = .
  ///```
  int? parseAnyCharVoid(State state) {
    int? $0;
    // >> $ = .
    final $pos = state.position;
    int? $1;
    if (state.isSuccess = state.position < state.input.length) {
      $1 = state.input.readChar(state.position);
      state.position += $1 > 0xffff ? 2 : 1;
    } else {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = .
    return $0;
  }

  /// **Char16**
  ///
  ///```code
  /// `int`
  /// Char16 =
  ///    $ = [a]
  ///```
  int? parseChar16(State state) {
    final $input = state.input;
    int? $0;
    // >> $ = [a]
    final $pos = state.position;
    int? $1;
    // a
    if (state.isSuccess = state.position < $input.length &&
        $input.codeUnitAt(state.position) == 97) {
      $1 = 97;
      state.position++;
    } else {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [a]
    return $0;
  }

  /// **Char16Void**
  ///
  ///```code
  /// `int`
  /// Char16Void =
  ///    [a]
  ///```
  int? parseChar16Void(State state) {
    final $input = state.input;
    int? $0;
    // >> [a]
    // a
    if (state.isSuccess = state.position < $input.length &&
        $input.codeUnitAt(state.position) == 97) {
      $0 = 97;
      state.position++;
    } else {
      state.fail();
    }
    // << [a]
    return $0;
  }

  /// **Char32**
  ///
  ///```code
  /// `int`
  /// Char32 =
  ///    $ = [{1f800}]
  ///```
  int? parseChar32(State state) {
    final $input = state.input;
    int? $0;
    // >> $ = [{1f800}]
    final $pos = state.position;
    int? $1;
    // 🠀
    if (state.isSuccess = state.position < $input.length &&
        $input.readChar(state.position) == 129024) {
      $1 = 129024;
      state.position += 2;
    } else {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [{1f800}]
    return $0;
  }

  /// **Char32Void**
  ///
  ///```code
  /// `int`
  /// Char32Void =
  ///    $ = [{1f800}]
  ///```
  int? parseChar32Void(State state) {
    final $input = state.input;
    int? $0;
    // >> $ = [{1f800}]
    final $pos = state.position;
    int? $1;
    // 🠀
    if (state.isSuccess = state.position < $input.length &&
        $input.readChar(state.position) == 129024) {
      $1 = 129024;
      state.position += 2;
    } else {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [{1f800}]
    return $0;
  }

  /// **Chars16**
  ///
  ///```code
  /// `int`
  /// Chars16 =
  ///    $ = [a-zA-Z]
  ///```
  int? parseChars16(State state) {
    int? $0;
    // >> $ = [a-zA-Z]
    final $pos = state.position;
    int? $1;
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c >= 65 && c <= 90 || c >= 97 && c <= 122;
      if (state.isSuccess) {
        $1 = c;
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [a-zA-Z]
    return $0;
  }

  /// **Chars16Void**
  ///
  ///```code
  /// `int`
  /// Chars16Void =
  ///    [a-zA-Z]
  ///```
  int? parseChars16Void(State state) {
    int? $0;
    // >> [a-zA-Z]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c >= 65 && c <= 90 || c >= 97 && c <= 122;
      if (state.isSuccess) {
        $0 = c;
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [a-zA-Z]
    return $0;
  }

  /// **Chars32**
  ///
  ///```code
  /// `int`
  /// Chars32 =
  ///    $ = [{1f800-1f803}]
  ///```
  int? parseChars32(State state) {
    int? $0;
    // >> $ = [{1f800-1f803}]
    final $pos = state.position;
    int? $1;
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.readChar(state.position);
      state.isSuccess = c >= 129024 && c <= 129027;
      if (state.isSuccess) {
        $1 = c;
        state.position += c > 0xffff ? 2 : 1;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [{1f800-1f803}]
    return $0;
  }

  /// **Chars32Void**
  ///
  ///```code
  /// `int`
  /// Chars32Void =
  ///    [{1f800-1f803}]
  ///```
  int? parseChars32Void(State state) {
    int? $0;
    // >> [{1f800-1f803}]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.readChar(state.position);
      state.isSuccess = c >= 129024 && c <= 129027;
      if (state.isSuccess) {
        $0 = c;
        state.position += c > 0xffff ? 2 : 1;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [{1f800-1f803}]
    return $0;
  }

  /// **Literal0**
  ///
  ///```code
  /// `String`
  /// Literal0 =
  ///    $ = ''
  ///```
  String? parseLiteral0(State state) {
    String? $0;
    // >> $ = ''
    final $pos = state.position;
    state.isSuccess = true;
    final $1 = state.isSuccess ? '' : null;
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = ''
    return $0;
  }

  /// **Literal0Void**
  ///
  ///```code
  /// `String`
  /// Literal0Void =
  ///    ''
  ///```
  String? parseLiteral0Void(State state) {
    String? $0;
    // >> ''
    state.isSuccess = true;
    $0 = state.isSuccess ? '' : null;
    // << ''
    return $0;
  }

  /// **Literal1**
  ///
  ///```code
  /// `String`
  /// Literal1 =
  ///    $ = 'a'
  ///```
  String? parseLiteral1(State state) {
    final $input = state.input;
    String? $0;
    // >> $ = 'a'
    final $pos = state.position;
    String? $1;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = 'a'
    return $0;
  }

  /// **Literal1Void**
  ///
  ///```code
  /// `String`
  /// Literal1Void =
  ///    'a'
  ///```
  String? parseLiteral1Void(State state) {
    final $input = state.input;
    String? $0;
    // >> 'a'
    final $pos = state.position;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $0 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    // << 'a'
    return $0;
  }

  /// **Literal2**
  ///
  ///```code
  /// `String`
  /// Literal2 =
  ///    $ = 'ab'
  ///```
  String? parseLiteral2(State state) {
    final $input = state.input;
    String? $0;
    // >> $ = 'ab'
    final $pos1 = state.position;
    String? $1;
    const $literal = 'ab';
    var $pos = $pos1;
    if (state.isSuccess = state.position + 2 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98) {
      state.position += 2;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos1);
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    // << $ = 'ab'
    return $0;
  }

  /// **Literal2Void**
  ///
  ///```code
  /// `String`
  /// Literal2Void =
  ///    'ab'
  ///```
  String? parseLiteral2Void(State state) {
    final $input = state.input;
    String? $0;
    // >> 'ab'
    final $pos1 = state.position;
    const $literal = 'ab';
    var $pos = $pos1;
    if (state.isSuccess = state.position + 2 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98) {
      state.position += 2;
      $0 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos1);
    // << 'ab'
    return $0;
  }

  /// **Match**
  ///
  ///```code
  /// `String`
  /// Match =
  ///    $ = <[a]+>
  ///```
  String? parseMatch(State state) {
    String? $0;
    // >> $ = <[a]+>
    final $pos = state.position;
    String? $1;
    // >> [a]+
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    if (!(state.isSuccess = $pos != state.position)) {
      state.fail();
    }
    // << [a]+
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = <[a]+>
    return $0;
  }

  /// **MatchVoid**
  ///
  ///```code
  /// `String`
  /// MatchVoid =
  ///    <[a]+>
  ///```
  String? parseMatchVoid(State state) {
    String? $0;
    // >> <[a]+>
    final $pos = state.position;
    // >> [a]+
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    if (!(state.isSuccess = $pos != state.position)) {
      state.fail();
    }
    // << [a]+
    $0 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << <[a]+>
    return $0;
  }

  /// **NotAbc**
  ///
  ///```code
  /// `void`
  /// NotAbc =
  ///    !'abc'
  ///```
  void parseNotAbc(State state) {
    final $input = state.input;
    // >> !'abc'
    final $pos1 = state.position;
    final $0 = state.notPredicate;
    state.notPredicate = true;
    // >> 'abc'
    const $literal = 'abc';
    var $pos = $pos1;
    state.isSuccess = state.position + 3 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98 &&
        $input.codeUnitAt($pos++) == 99;
    state.isSuccess ? state.position += 3 : state.fail();
    state.expected($literal, $pos1);
    // << 'abc'
    state.notPredicate = $0;
    if (!(state.isSuccess = !state.isSuccess)) {
      state.fail(state.position - $pos1);
      state.position = $pos1;
    }
    // << !'abc'
  }

  /// **NotDigits**
  ///
  ///```code
  /// `int`
  /// NotDigits =
  ///    $ = [0-9]
  ///```
  int? parseNotDigits(State state) {
    int? $0;
    // >> $ = [0-9]
    final $pos = state.position;
    int? $1;
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c < 48 || c > 57;
      if (state.isSuccess) {
        $1 = c;
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    if (state.isSuccess) {
      int $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = [0-9]
    return $0;
  }

  /// **NotDigitsVoid**
  ///
  ///```code
  /// `int`
  /// NotDigitsVoid =
  ///    [0-9]
  ///```
  int? parseNotDigitsVoid(State state) {
    int? $0;
    // >> [0-9]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c < 48 || c > 57;
      if (state.isSuccess) {
        $0 = c;
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [0-9]
    return $0;
  }

  /// **OneOrMore**
  ///
  ///```code
  /// `List<String>`
  /// OneOrMore =
  ///    $ = 'abc'+
  ///```
  List<String>? parseOneOrMore(State state) {
    final $input = state.input;
    List<String>? $0;
    // >> $ = 'abc'+
    final $pos2 = state.position;
    List<String>? $1;
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $pos1 = state.position;
      String? $2;
      const $literal = 'abc';
      var $pos = $pos1;
      if (state.isSuccess = state.position + 3 <= $input.length &&
          $input.codeUnitAt($pos++) == 97 &&
          $input.codeUnitAt($pos++) == 98 &&
          $input.codeUnitAt($pos++) == 99) {
        state.position += 3;
        $2 = $literal;
      } else {
        state.fail();
      }
      state.expected($literal, $pos1);
      // << 'abc'
      if (!state.isSuccess) {
        break;
      }
      $list.add($2!);
    }
    if (state.isSuccess = $list.isNotEmpty) {
      $1 = $list;
    }
    if (state.isSuccess) {
      List<String> $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos2;
    }
    // << $ = 'abc'+
    return $0;
  }

  /// **OneOrMoreVoid**
  ///
  ///```code
  /// `List<String>`
  /// OneOrMoreVoid =
  ///    'abc'+
  ///```
  List<String>? parseOneOrMoreVoid(State state) {
    final $input = state.input;
    List<String>? $0;
    // >> 'abc'+
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $pos1 = state.position;
      String? $1;
      const $literal = 'abc';
      var $pos = $pos1;
      if (state.isSuccess = state.position + 3 <= $input.length &&
          $input.codeUnitAt($pos++) == 97 &&
          $input.codeUnitAt($pos++) == 98 &&
          $input.codeUnitAt($pos++) == 99) {
        state.position += 3;
        $1 = $literal;
      } else {
        state.fail();
      }
      state.expected($literal, $pos1);
      // << 'abc'
      if (!state.isSuccess) {
        break;
      }
      $list.add($1!);
    }
    if (state.isSuccess = $list.isNotEmpty) {
      $0 = $list;
    }
    // << 'abc'+
    return $0;
  }

  /// **Optional**
  ///
  ///```code
  /// `String?`
  /// Optional =
  ///    $ = 'abc'?
  ///```
  String? parseOptional(State state) {
    final $input = state.input;
    String? $0;
    // >> $ = 'abc'?
    final $pos1 = state.position;
    String? $1;
    // >> 'abc'
    const $literal = 'abc';
    var $pos = $pos1;
    if (state.isSuccess = state.position + 3 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98 &&
        $input.codeUnitAt($pos++) == 99) {
      state.position += 3;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos1);
    // << 'abc'
    state.isSuccess = true;
    if (state.isSuccess) {
      String? $ = $1;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos1;
    }
    // << $ = 'abc'?
    return $0;
  }

  /// **OptionalVoid**
  ///
  ///```code
  /// `String?`
  /// OptionalVoid =
  ///    'abc'?
  ///```
  String? parseOptionalVoid(State state) {
    final $input = state.input;
    String? $0;
    // >> 'abc'?
    final $pos1 = state.position;
    // >> 'abc'
    const $literal = 'abc';
    var $pos = $pos1;
    if (state.isSuccess = state.position + 3 <= $input.length &&
        $input.codeUnitAt($pos++) == 97 &&
        $input.codeUnitAt($pos++) == 98 &&
        $input.codeUnitAt($pos++) == 99) {
      state.position += 3;
      $0 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos1);
    // << 'abc'
    state.isSuccess = true;
    // << 'abc'?
    return $0;
  }

  /// **OrderedChoice**
  ///
  ///```code
  /// `String`
  /// OrderedChoice =
  ///    $ = ($ = 'a' / $ = 'b' / $ = 'c')
  ///```
  String? parseOrderedChoice(State state) {
    final $input = state.input;
    String? $0;
    // >> $ = ($ = 'a' / $ = 'b' / $ = 'c')
    final $pos = state.position;
    String? $1;
    // >> $ = 'a'
    String? $2;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $2 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    if (state.isSuccess) {
      String $ = $2!;
      $1 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = 'a'
    if (!state.isSuccess) {
      // >> $ = 'b'
      String? $3;
      const $literal1 = 'b';
      if (state.isSuccess =
          $pos < $input.length && $input.codeUnitAt($pos) == 98) {
        state.position++;
        $3 = $literal1;
      } else {
        state.fail();
      }
      state.expected($literal1, $pos);
      if (state.isSuccess) {
        String $ = $3!;
        $1 = $;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      // << $ = 'b'
      if (!state.isSuccess) {
        // >> $ = 'c'
        String? $4;
        const $literal2 = 'c';
        if (state.isSuccess =
            $pos < $input.length && $input.codeUnitAt($pos) == 99) {
          state.position++;
          $4 = $literal2;
        } else {
          state.fail();
        }
        state.expected($literal2, $pos);
        if (state.isSuccess) {
          String $ = $4!;
          $1 = $;
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << $ = 'c'
      }
    }
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = ($ = 'a' / $ = 'b' / $ = 'c')
    return $0;
  }

  /// **OrderedChoiceVoid**
  ///
  ///```code
  /// `String`
  /// OrderedChoiceVoid =
  ///    ($ = 'a' / $ = 'b' / $ = 'c')
  ///```
  String? parseOrderedChoiceVoid(State state) {
    final $input = state.input;
    String? $0;
    // >> ($ = 'a' / $ = 'b' / $ = 'c')
    final $pos = state.position;
    // >> $ = 'a'
    String? $1;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = 'a'
    if (!state.isSuccess) {
      // >> $ = 'b'
      String? $2;
      const $literal1 = 'b';
      if (state.isSuccess =
          $pos < $input.length && $input.codeUnitAt($pos) == 98) {
        state.position++;
        $2 = $literal1;
      } else {
        state.fail();
      }
      state.expected($literal1, $pos);
      if (state.isSuccess) {
        String $ = $2!;
        $0 = $;
      }
      if (!state.isSuccess) {
        state.position = $pos;
      }
      // << $ = 'b'
      if (!state.isSuccess) {
        // >> $ = 'c'
        String? $3;
        const $literal2 = 'c';
        if (state.isSuccess =
            $pos < $input.length && $input.codeUnitAt($pos) == 99) {
          state.position++;
          $3 = $literal2;
        } else {
          state.fail();
        }
        state.expected($literal2, $pos);
        if (state.isSuccess) {
          String $ = $3!;
          $0 = $;
        }
        if (!state.isSuccess) {
          state.position = $pos;
        }
        // << $ = 'c'
      }
    }
    // << ($ = 'a' / $ = 'b' / $ = 'c')
    return $0;
  }

  /// **Ranges**
  ///
  ///```code
  /// `String`
  /// Ranges =
  ///    $ = <[0-9A-Za-z]>
  ///```
  String? parseRanges(State state) {
    String? $0;
    // >> $ = <[0-9A-Za-z]>
    final $pos = state.position;
    String? $1;
    // >> [0-9A-Za-z]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess =
          c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57;
      if (state.isSuccess) {
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [0-9A-Za-z]
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = <[0-9A-Za-z]>
    return $0;
  }

  /// **RangesVoid**
  ///
  ///```code
  /// `String`
  /// RangesVoid =
  ///    <[0-9A-Za-z]>
  ///```
  String? parseRangesVoid(State state) {
    String? $0;
    // >> <[0-9A-Za-z]>
    final $pos = state.position;
    // >> [0-9A-Za-z]
    state.isSuccess = state.position < state.input.length;
    if (state.isSuccess) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess =
          c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57;
      if (state.isSuccess) {
        state.position++;
      }
    }
    if (!state.isSuccess) {
      state.fail();
    }
    // << [0-9A-Za-z]
    $0 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << <[0-9A-Za-z]>
    return $0;
  }

  /// **Seq2**
  ///
  ///```code
  /// `String`
  /// Seq2 =
  ///    a = 'a' b = 'b' $ = { }
  ///```
  String? parseSeq2(State state) {
    final $input = state.input;
    String? $0;
    // >> a = 'a' b = 'b' $ = { }
    final $pos = state.position;
    // >> a = 'a'
    String? $1;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    // << a = 'a'
    if (state.isSuccess) {
      String a = $1!;
      // >> b = 'b'
      final $pos1 = state.position;
      String? $2;
      const $literal1 = 'b';
      if (state.isSuccess =
          $pos1 < $input.length && $input.codeUnitAt($pos1) == 98) {
        state.position++;
        $2 = $literal1;
      } else {
        state.fail();
      }
      state.expected($literal1, $pos1);
      // << b = 'b'
      if (state.isSuccess) {
        String b = $2!;
        late String $$;
        // >> $ = { }
        String? $3;
        state.isSuccess = true;
        $$ = a + b;
        // << $ = { }
        $3 = $$;
        if (state.isSuccess) {
          String $ = $3;
          $0 = $;
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << a = 'a' b = 'b' $ = { }
    return $0;
  }

  /// **Seq2Void**
  ///
  ///```code
  /// `void`
  /// Seq2Void =
  ///    'a' 'b'
  ///```
  void parseSeq2Void(State state) {
    final $input = state.input;
    // >> 'a' 'b'
    final $pos = state.position;
    // >> 'a'
    const $literal = 'a';
    state.isSuccess = $pos < $input.length && $input.codeUnitAt($pos) == 97;
    state.isSuccess ? state.position++ : state.fail();
    state.expected($literal, $pos);
    // << 'a'
    if (state.isSuccess) {
      // >> 'b'
      final $pos1 = state.position;
      const $literal1 = 'b';
      state.isSuccess = $pos1 < $input.length && $input.codeUnitAt($pos1) == 98;
      state.isSuccess ? state.position++ : state.fail();
      state.expected($literal1, $pos1);
      // << 'b'
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << 'a' 'b'
  }

  /// **Seq3**
  ///
  ///```code
  /// `String`
  /// Seq3 =
  ///    a = 'a' b = 'b' c = 'c' $ = { }
  ///```
  String? parseSeq3(State state) {
    final $input = state.input;
    String? $0;
    // >> a = 'a' b = 'b' c = 'c' $ = { }
    final $pos = state.position;
    // >> a = 'a'
    String? $1;
    const $literal = 'a';
    if (state.isSuccess =
        $pos < $input.length && $input.codeUnitAt($pos) == 97) {
      state.position++;
      $1 = $literal;
    } else {
      state.fail();
    }
    state.expected($literal, $pos);
    // << a = 'a'
    if (state.isSuccess) {
      String a = $1!;
      // >> b = 'b'
      final $pos1 = state.position;
      String? $2;
      const $literal1 = 'b';
      if (state.isSuccess =
          $pos1 < $input.length && $input.codeUnitAt($pos1) == 98) {
        state.position++;
        $2 = $literal1;
      } else {
        state.fail();
      }
      state.expected($literal1, $pos1);
      // << b = 'b'
      if (state.isSuccess) {
        String b = $2!;
        // >> c = 'c'
        final $pos2 = state.position;
        String? $3;
        const $literal2 = 'c';
        if (state.isSuccess =
            $pos2 < $input.length && $input.codeUnitAt($pos2) == 99) {
          state.position++;
          $3 = $literal2;
        } else {
          state.fail();
        }
        state.expected($literal2, $pos2);
        // << c = 'c'
        if (state.isSuccess) {
          String c = $3!;
          late String $$;
          // >> $ = { }
          String? $4;
          state.isSuccess = true;
          $$ = a + b + c;
          // << $ = { }
          $4 = $$;
          if (state.isSuccess) {
            String $ = $4;
            $0 = $;
          }
        }
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << a = 'a' b = 'b' c = 'c' $ = { }
    return $0;
  }

  /// **Seq3Void**
  ///
  ///```code
  /// `void`
  /// Seq3Void =
  ///    'a' 'b' 'c'
  ///```
  void parseSeq3Void(State state) {
    final $input = state.input;
    // >> 'a' 'b' 'c'
    final $pos = state.position;
    // >> 'a'
    const $literal = 'a';
    state.isSuccess = $pos < $input.length && $input.codeUnitAt($pos) == 97;
    state.isSuccess ? state.position++ : state.fail();
    state.expected($literal, $pos);
    // << 'a'
    if (state.isSuccess) {
      // >> 'b'
      final $pos1 = state.position;
      const $literal1 = 'b';
      state.isSuccess = $pos1 < $input.length && $input.codeUnitAt($pos1) == 98;
      state.isSuccess ? state.position++ : state.fail();
      state.expected($literal1, $pos1);
      // << 'b'
      if (state.isSuccess) {
        // >> 'c'
        final $pos2 = state.position;
        const $literal2 = 'c';
        state.isSuccess =
            $pos2 < $input.length && $input.codeUnitAt($pos2) == 99;
        state.isSuccess ? state.position++ : state.fail();
        state.expected($literal2, $pos2);
        // << 'c'
      }
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << 'a' 'b' 'c'
  }

  /// **TakeWhile**
  ///
  ///```code
  /// `String`
  /// TakeWhile =
  ///    $ = <[a]*>
  ///```
  String? parseTakeWhile(State state) {
    String? $0;
    // >> $ = <[a]*>
    final $pos = state.position;
    String? $1;
    // >> [a]*
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    state.isSuccess = true;
    // << [a]*
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = <[a]*>
    return $0;
  }

  /// **TakeWhile1**
  ///
  ///```code
  /// `String`
  /// TakeWhile1 =
  ///    $ = <[a]+>
  ///```
  String? parseTakeWhile1(State state) {
    String? $0;
    // >> $ = <[a]+>
    final $pos = state.position;
    String? $1;
    // >> [a]+
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    if (!(state.isSuccess = $pos != state.position)) {
      state.fail();
    }
    // << [a]+
    $1 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    if (state.isSuccess) {
      String $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos;
    }
    // << $ = <[a]+>
    return $0;
  }

  /// **TakeWhile1Void**
  ///
  ///```code
  /// `String`
  /// TakeWhile1Void =
  ///    <[a]+>
  ///```
  String? parseTakeWhile1Void(State state) {
    String? $0;
    // >> <[a]+>
    final $pos = state.position;
    // >> [a]+
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    if (!(state.isSuccess = $pos != state.position)) {
      state.fail();
    }
    // << [a]+
    $0 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << <[a]+>
    return $0;
  }

  /// **TakeWhileVoid**
  ///
  ///```code
  /// `String`
  /// TakeWhileVoid =
  ///    <[a]*>
  ///```
  String? parseTakeWhileVoid(State state) {
    String? $0;
    // >> <[a]*>
    final $pos = state.position;
    // >> [a]*
    while (state.position < state.input.length) {
      final c = state.input.codeUnitAt(state.position);
      state.isSuccess = c == 97;
      if (!state.isSuccess) {
        break;
      }
      state.position++;
    }
    state.isSuccess = true;
    // << [a]*
    $0 = state.isSuccess ? state.input.substring($pos, state.position) : null;
    // << <[a]*>
    return $0;
  }

  /// **ZeroOrMore**
  ///
  ///```code
  /// `List<String>`
  /// ZeroOrMore =
  ///    $ = 'abc'*
  ///```
  List<String>? parseZeroOrMore(State state) {
    final $input = state.input;
    List<String>? $0;
    // >> $ = 'abc'*
    final $pos2 = state.position;
    List<String>? $1;
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $pos1 = state.position;
      String? $2;
      const $literal = 'abc';
      var $pos = $pos1;
      if (state.isSuccess = state.position + 3 <= $input.length &&
          $input.codeUnitAt($pos++) == 97 &&
          $input.codeUnitAt($pos++) == 98 &&
          $input.codeUnitAt($pos++) == 99) {
        state.position += 3;
        $2 = $literal;
      } else {
        state.fail();
      }
      state.expected($literal, $pos1);
      // << 'abc'
      if (!state.isSuccess) {
        break;
      }
      $list.add($2!);
    }
    $1 = (state.isSuccess = true) ? $list : null;
    if (state.isSuccess) {
      List<String> $ = $1!;
      $0 = $;
    }
    if (!state.isSuccess) {
      state.position = $pos2;
    }
    // << $ = 'abc'*
    return $0;
  }

  /// **ZeroOrMoreVoid**
  ///
  ///```code
  /// `List<String>`
  /// ZeroOrMoreVoid =
  ///    'abc'*
  ///```
  List<String>? parseZeroOrMoreVoid(State state) {
    final $input = state.input;
    List<String>? $0;
    // >> 'abc'*
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $pos1 = state.position;
      String? $1;
      const $literal = 'abc';
      var $pos = $pos1;
      if (state.isSuccess = state.position + 3 <= $input.length &&
          $input.codeUnitAt($pos++) == 97 &&
          $input.codeUnitAt($pos++) == 98 &&
          $input.codeUnitAt($pos++) == 99) {
        state.position += 3;
        $1 = $literal;
      } else {
        state.fail();
      }
      state.expected($literal, $pos1);
      // << 'abc'
      if (!state.isSuccess) {
        break;
      }
      $list.add($1!);
    }
    $0 = (state.isSuccess = true) ? $list : null;
    // << 'abc'*
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// Input data for parsing.
  String input;

  /// Indicator of the success of the parsing.
  bool isSuccess = false;

  /// Indicates that parsing occurs within a `not' predicate`.
  ///
  /// When parsed within the `not predicate`, all `expected` errors are
  /// converted to `unexpected` errors.
  bool notPredicate = false;

  /// Current parsing position.
  int position = 0;

  int _errorIndex = 0;

  int _expectedIndex = 0;

  final List<String?> _expected = List.filled(128, null);

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  int _farthestUnexpected = 0;

  final List<bool?> _locations = List.filled(128, null);

  final List<String?> _messages = List.filled(128, null);

  final List<int?> _positions = List.filled(128, null);

  int _unexpectedIndex = 0;

  final List<String?> _unexpectedElements = List.filled(128, null);

  final List<int?> _unexpectedPositions = List.filled(128, null);

  State(this.input);

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int enter() {
    final failure = this.failure;
    this.failure = position;
    return failure;
  }

  /// Registers an error at the [failure] position.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void error(String message, {bool? location}) {
    if (_farthestError > failure) {
      return;
    }

    if (_farthestError < failure) {
      _farthestError = failure;
      _errorIndex = 0;
      _expectedIndex = 0;
    }

    if (_errorIndex < _messages.length) {
      _locations[_errorIndex] = location;
      _messages[_errorIndex] = message;
      _positions[_errorIndex] = position;
      _errorIndex++;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(String element, int start, [bool nested = true]) {
    if (_farthestError > position) {
      return;
    }

    if (isSuccess) {
      if (!notPredicate || _farthestUnexpected > position) {
        return;
      }

      if (_farthestUnexpected < position) {
        _farthestUnexpected = position;
        _unexpectedIndex = 0;
      }

      if (_unexpectedIndex < _unexpectedElements.length) {
        _unexpectedElements[_unexpectedIndex] = element;
        _unexpectedPositions[_unexpectedIndex] = start;
        _unexpectedIndex++;
      }
    } else {
      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (!nested) {
        _expectedIndex = 0;
      }

      if (_expectedIndex < _expected.length) {
        _expected[_expectedIndex++] = element;
      }
    }
  }

  /// Causes a parsing failure and updates the [failure] and [_farthestFailure]
  /// positions.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void fail([int length = 0]) {
    isSuccess = false;
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    _farthestFailureLength =
        _farthestFailureLength < length ? length : _farthestFailureLength;
  }

  /// Converts error messages to errors and returns them as an error list.
  List<({int end, String message, int start})> getErrors() {
    final errors = <({int end, String message, int start})>[];
    for (var i = 0; i < _errorIndex; i++) {
      final message = _messages[i];
      if (message == null) {
        continue;
      }

      var start = _positions[i]!;
      var end = _farthestError;
      final location = _locations[i];
      switch (location) {
        case true:
          start = end;
          break;
        case false:
          end = start;
          break;
        default:
      }

      errors.add((message: message, start: start, end: end));
    }

    if (_expectedIndex > 0) {
      final names = <String>[];
      for (var i = 0; i < _expectedIndex; i++) {
        final name = _expected[i]!;
        names.add(name);
      }

      names.sort();
      final message =
          'Expected: ${names.toSet().map((e) => '\'$e\'').join(', ')}';
      errors
          .add((message: message, start: _farthestError, end: _farthestError));
    }

    if (_farthestUnexpected >= _farthestError) {
      if (_unexpectedIndex > 0) {
        for (var i = 0; i < _unexpectedIndex; i++) {
          final element = _unexpectedElements[i]!;
          final position = _unexpectedPositions[i]!;
          final message = "Unexpected '$element'";
          errors.add(
              (message: message, start: position, end: _farthestUnexpected));
        }
      }
    }

    if (errors.isEmpty) {
      errors.add((
        message: 'Unexpected input data',
        start: _farthestFailure - _farthestFailureLength,
        end: _farthestFailure
      ));
    }

    return errors.toSet().toList();
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void leave(int failure) {
    if (this.failure < failure) {
      this.failure = failure;
    }
  }

  /// Registers an error if the [failure] position is further than starting
  /// [position], otherwise the error will be ignored.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void malformed(String message, {bool? location}) =>
      failure != position ? error(message, location: location) : null;

  @override
  String toString() {
    var rest = input.length - position;
    if (rest > 80) {
      rest = 80;
    }

    var line = input.substring(position, position + rest);
    line = line.replaceAll('\n', '\n');
    return '($position)$line';
  }
}

extension on String {
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  int readChar(int index) {
    final b1 = codeUnitAt(index++);
    if (b1 > 0xd7ff && b1 < 0xe000) {
      if (index < length) {
        final b2 = codeUnitAt(index);
        if ((b2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((b1 & 0x3ff) << 10) + (b2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return b1;
  }
}

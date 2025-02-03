// ignore_for_file: prefer_final_locals

import 'package:source_span/source_span.dart';

Object? parse(String source) {
  final state = State(source);
  final parser = TestParser();
  final result = parser.parseA(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }
  return result.$1;
}

class TestParser {
  /// **A**
  ///
  ///```code
  /// `Object?`
  /// A =
  ///    $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = Seq2 Seq2Void / $ = Seq3 Seq3Void / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
  ///```
  (Object?,)? parseA(State state) {
    // >> $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = Seq2 Seq2Void / $ = Seq3 Seq3Void / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
    final $pos = state.position;
    (Object?,)? $0;
    // >> $ = '' AndAbc
    // >> $ = ''
    final $1 = state.opt(('',));
    // << $ = ''
    if ($1 != null) {
      String $ = $1.$1;
      // >> AndAbc
      final $2 = parseAndAbc(state);
      // << AndAbc
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    // << $ = '' AndAbc
    if ($0 == null) {
      // >> $ = AnyChar AnyCharVoid
      // >> $ = AnyChar
      final $3 = parseAnyChar(state);
      // << $ = AnyChar
      if ($3 != null) {
        Object? $ = $3.$1;
        // >> AnyCharVoid
        final $4 = parseAnyCharVoid(state);
        // << AnyCharVoid
        if ($4 != null) {
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $pos;
      }
      // << $ = AnyChar AnyCharVoid
      if ($0 == null) {
        // >> $ = Char16 Char16Void
        // >> $ = Char16
        final $5 = parseChar16(state);
        // << $ = Char16
        if ($5 != null) {
          Object? $ = $5.$1;
          // >> Char16Void
          final $6 = parseChar16Void(state);
          // << Char16Void
          if ($6 != null) {
            $0 = ($,);
          }
        }
        if ($0 == null) {
          state.position = $pos;
        }
        // << $ = Char16 Char16Void
        if ($0 == null) {
          // >> $ = Chars16 Chars16Void
          // >> $ = Chars16
          final $7 = parseChars16(state);
          // << $ = Chars16
          if ($7 != null) {
            Object? $ = $7.$1;
            // >> Chars16Void
            final $8 = parseChars16Void(state);
            // << Chars16Void
            if ($8 != null) {
              $0 = ($,);
            }
          }
          if ($0 == null) {
            state.position = $pos;
          }
          // << $ = Chars16 Chars16Void
          if ($0 == null) {
            // >> $ = Char32 Char32Void
            // >> $ = Char32
            final $9 = parseChar32(state);
            // << $ = Char32
            if ($9 != null) {
              Object? $ = $9.$1;
              // >> Char32Void
              final $10 = parseChar32Void(state);
              // << Char32Void
              if ($10 != null) {
                $0 = ($,);
              }
            }
            if ($0 == null) {
              state.position = $pos;
            }
            // << $ = Char32 Char32Void
            if ($0 == null) {
              // >> $ = Chars32 Chars32Void
              // >> $ = Chars32
              final $11 = parseChars32(state);
              // << $ = Chars32
              if ($11 != null) {
                Object? $ = $11.$1;
                // >> Chars32Void
                final $12 = parseChars32Void(state);
                // << Chars32Void
                if ($12 != null) {
                  $0 = ($,);
                }
              }
              if ($0 == null) {
                state.position = $pos;
              }
              // << $ = Chars32 Chars32Void
              if ($0 == null) {
                // >> $ = Literal0 Literal0Void
                // >> $ = Literal0
                final $13 = parseLiteral0(state);
                // << $ = Literal0
                if ($13 != null) {
                  Object? $ = $13.$1;
                  // >> Literal0Void
                  final $14 = parseLiteral0Void(state);
                  // << Literal0Void
                  if ($14 != null) {
                    $0 = ($,);
                  }
                }
                if ($0 == null) {
                  state.position = $pos;
                }
                // << $ = Literal0 Literal0Void
                if ($0 == null) {
                  // >> $ = Literal1 Literal1Void
                  // >> $ = Literal1
                  final $15 = parseLiteral1(state);
                  // << $ = Literal1
                  if ($15 != null) {
                    Object? $ = $15.$1;
                    // >> Literal1Void
                    final $16 = parseLiteral1Void(state);
                    // << Literal1Void
                    if ($16 != null) {
                      $0 = ($,);
                    }
                  }
                  if ($0 == null) {
                    state.position = $pos;
                  }
                  // << $ = Literal1 Literal1Void
                  if ($0 == null) {
                    // >> $ = Literal2 Literal2Void
                    // >> $ = Literal2
                    final $17 = parseLiteral2(state);
                    // << $ = Literal2
                    if ($17 != null) {
                      Object? $ = $17.$1;
                      // >> Literal2Void
                      final $18 = parseLiteral2Void(state);
                      // << Literal2Void
                      if ($18 != null) {
                        $0 = ($,);
                      }
                    }
                    if ($0 == null) {
                      state.position = $pos;
                    }
                    // << $ = Literal2 Literal2Void
                    if ($0 == null) {
                      // >> $ = Match MatchVoid
                      // >> $ = Match
                      final $19 = parseMatch(state);
                      // << $ = Match
                      if ($19 != null) {
                        Object? $ = $19.$1;
                        // >> MatchVoid
                        final $20 = parseMatchVoid(state);
                        // << MatchVoid
                        if ($20 != null) {
                          $0 = ($,);
                        }
                      }
                      if ($0 == null) {
                        state.position = $pos;
                      }
                      // << $ = Match MatchVoid
                      if ($0 == null) {
                        // >> $ = NotDigits NotDigitsVoid
                        // >> $ = NotDigits
                        final $21 = parseNotDigits(state);
                        // << $ = NotDigits
                        if ($21 != null) {
                          Object? $ = $21.$1;
                          // >> NotDigitsVoid
                          final $22 = parseNotDigitsVoid(state);
                          // << NotDigitsVoid
                          if ($22 != null) {
                            $0 = ($,);
                          }
                        }
                        if ($0 == null) {
                          state.position = $pos;
                        }
                        // << $ = NotDigits NotDigitsVoid
                        if ($0 == null) {
                          // >> $ = '' NotAbc
                          // >> $ = ''
                          final $23 = state.opt(('',));
                          // << $ = ''
                          if ($23 != null) {
                            String $ = $23.$1;
                            // >> NotAbc
                            final $24 = parseNotAbc(state);
                            // << NotAbc
                            if ($24 != null) {
                              $0 = ($,);
                            }
                          }
                          if ($0 == null) {
                            state.position = $pos;
                          }
                          // << $ = '' NotAbc
                          if ($0 == null) {
                            // >> $ = OneOrMore OneOrMoreVoid
                            // >> $ = OneOrMore
                            final $25 = parseOneOrMore(state);
                            // << $ = OneOrMore
                            if ($25 != null) {
                              Object? $ = $25.$1;
                              // >> OneOrMoreVoid
                              final $26 = parseOneOrMoreVoid(state);
                              // << OneOrMoreVoid
                              if ($26 != null) {
                                $0 = ($,);
                              }
                            }
                            if ($0 == null) {
                              state.position = $pos;
                            }
                            // << $ = OneOrMore OneOrMoreVoid
                            if ($0 == null) {
                              // >> $ = Optional OptionalVoid
                              // >> $ = Optional
                              final $27 = parseOptional(state);
                              // << $ = Optional
                              if ($27 != null) {
                                Object? $ = $27.$1;
                                // >> OptionalVoid
                                final $28 = parseOptionalVoid(state);
                                // << OptionalVoid
                                if ($28 != null) {
                                  $0 = ($,);
                                }
                              }
                              if ($0 == null) {
                                state.position = $pos;
                              }
                              // << $ = Optional OptionalVoid
                              if ($0 == null) {
                                // >> $ = OrderedChoice OrderedChoiceVoid
                                // >> $ = OrderedChoice
                                final $29 = parseOrderedChoice(state);
                                // << $ = OrderedChoice
                                if ($29 != null) {
                                  Object? $ = $29.$1;
                                  // >> OrderedChoiceVoid
                                  final $30 = parseOrderedChoiceVoid(state);
                                  // << OrderedChoiceVoid
                                  if ($30 != null) {
                                    $0 = ($,);
                                  }
                                }
                                if ($0 == null) {
                                  state.position = $pos;
                                }
                                // << $ = OrderedChoice OrderedChoiceVoid
                                if ($0 == null) {
                                  // >> $ = Ranges RangesVoid
                                  // >> $ = Ranges
                                  final $31 = parseRanges(state);
                                  // << $ = Ranges
                                  if ($31 != null) {
                                    Object? $ = $31.$1;
                                    // >> RangesVoid
                                    final $32 = parseRangesVoid(state);
                                    // << RangesVoid
                                    if ($32 != null) {
                                      $0 = ($,);
                                    }
                                  }
                                  if ($0 == null) {
                                    state.position = $pos;
                                  }
                                  // << $ = Ranges RangesVoid
                                  if ($0 == null) {
                                    // >> $ = Seq2 Seq2Void
                                    // >> $ = Seq2
                                    final $33 = parseSeq2(state);
                                    // << $ = Seq2
                                    if ($33 != null) {
                                      Object? $ = $33.$1;
                                      // >> Seq2Void
                                      final $34 = parseSeq2Void(state);
                                      // << Seq2Void
                                      if ($34 != null) {
                                        $0 = ($,);
                                      }
                                    }
                                    if ($0 == null) {
                                      state.position = $pos;
                                    }
                                    // << $ = Seq2 Seq2Void
                                    if ($0 == null) {
                                      // >> $ = Seq3 Seq3Void
                                      // >> $ = Seq3
                                      final $35 = parseSeq3(state);
                                      // << $ = Seq3
                                      if ($35 != null) {
                                        Object? $ = $35.$1;
                                        // >> Seq3Void
                                        final $36 = parseSeq3Void(state);
                                        // << Seq3Void
                                        if ($36 != null) {
                                          $0 = ($,);
                                        }
                                      }
                                      if ($0 == null) {
                                        state.position = $pos;
                                      }
                                      // << $ = Seq3 Seq3Void
                                      if ($0 == null) {
                                        // >> $ = TakeWhile TakeWhileVoid
                                        // >> $ = TakeWhile
                                        final $37 = parseTakeWhile(state);
                                        // << $ = TakeWhile
                                        if ($37 != null) {
                                          Object? $ = $37.$1;
                                          // >> TakeWhileVoid
                                          final $38 = parseTakeWhileVoid(state);
                                          // << TakeWhileVoid
                                          if ($38 != null) {
                                            $0 = ($,);
                                          }
                                        }
                                        if ($0 == null) {
                                          state.position = $pos;
                                        }
                                        // << $ = TakeWhile TakeWhileVoid
                                        if ($0 == null) {
                                          // >> $ = TakeWhile1 TakeWhile1Void
                                          // >> $ = TakeWhile1
                                          final $39 = parseTakeWhile1(state);
                                          // << $ = TakeWhile1
                                          if ($39 != null) {
                                            Object? $ = $39.$1;
                                            // >> TakeWhile1Void
                                            final $40 =
                                                parseTakeWhile1Void(state);
                                            // << TakeWhile1Void
                                            if ($40 != null) {
                                              $0 = ($,);
                                            }
                                          }
                                          if ($0 == null) {
                                            state.position = $pos;
                                          }
                                          // << $ = TakeWhile1 TakeWhile1Void
                                          if ($0 == null) {
                                            // >> $ = ZeroOrMore ZeroOrMoreVoid
                                            // >> $ = ZeroOrMore
                                            final $41 = parseZeroOrMore(state);
                                            // << $ = ZeroOrMore
                                            if ($41 != null) {
                                              Object? $ = $41.$1;
                                              // >> ZeroOrMoreVoid
                                              final $42 =
                                                  parseZeroOrMoreVoid(state);
                                              // << ZeroOrMoreVoid
                                              if ($42 != null) {
                                                $0 = ($,);
                                              }
                                            }
                                            if ($0 == null) {
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
    if ($0 != null) {
      Object? $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (void,)? parseAndAbc(State state) {
    // >> &'abc'
    final $pos = state.position;
    // >> 'abc'
    final $1 = state.match('abc');
    // << 'abc'
    state.position = $pos;
    final $0 = $1 != null ? const (null,) : null;
    // << &'abc'
    return $0;
  }

  /// **AnyChar**
  ///
  ///```code
  /// `int`
  /// AnyChar =
  ///    $ = .
  ///```
  (int,)? parseAnyChar(State state) {
    // >> $ = .
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchAny();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseAnyCharVoid(State state) {
    // >> $ = .
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchAny();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChar16(State state) {
    // >> $ = [a]
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchChar16(97);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChar16Void(State state) {
    // >> [a]
    final $0 = state.matchChar16(97);
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
  (int,)? parseChar32(State state) {
    // >> $ = [{1f800}]
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchChar32(129024);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChar32Void(State state) {
    // >> $ = [{1f800}]
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchChar32(129024);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChars16(State state) {
    // >> $ = [a-zA-Z]
    final $pos = state.position;
    (int,)? $0;
    $0 = state
        .matchChars16((int c) => c >= 65 && c <= 90 || c >= 97 && c <= 122);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChars16Void(State state) {
    // >> [a-zA-Z]
    final $0 = state
        .matchChars16((int c) => c >= 65 && c <= 90 || c >= 97 && c <= 122);
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
  (int,)? parseChars32(State state) {
    // >> $ = [{1f800-1f803}]
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchChars32((int c) => c >= 129024 && c <= 129027);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseChars32Void(State state) {
    // >> [{1f800-1f803}]
    final $0 = state.matchChars32((int c) => c >= 129024 && c <= 129027);
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
  (String,)? parseLiteral0(State state) {
    // >> $ = ''
    final $pos = state.position;
    (String,)? $0;
    $0 = state.opt(('',));
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseLiteral0Void(State state) {
    // >> ''
    final $0 = state.opt(('',));
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
  (String,)? parseLiteral1(State state) {
    // >> $ = 'a'
    final $pos = state.position;
    (String,)? $0;
    $0 = state.match1('a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseLiteral1Void(State state) {
    // >> 'a'
    final $0 = state.match1('a', 97);
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
  (String,)? parseLiteral2(State state) {
    // >> $ = 'ab'
    final $pos = state.position;
    (String,)? $0;
    $0 = state.match2('ab', 97, 98);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
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
  (String,)? parseLiteral2Void(State state) {
    // >> 'ab'
    final $0 = state.match2('ab', 97, 98);
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
  (String,)? parseMatch(State state) {
    // >> $ = <[a]+>
    final $pos = state.position;
    (String,)? $0;
    // >> [a]+
    final $1 = state.skip16While1((int c) => c == 97);
    // << [a]+
    $0 = $1 != null ? (state.input.substring($pos, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseMatchVoid(State state) {
    // >> <[a]+>
    final $pos = state.position;
    // >> [a]+
    final $1 = state.skip16While1((int c) => c == 97);
    // << [a]+
    final $0 =
        $1 != null ? (state.input.substring($pos, state.position),) : null;
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
  (void,)? parseNotAbc(State state) {
    // >> !'abc'
    final $pos = state.position;
    final $2 = state.notPredicate;
    state.notPredicate = true;
    // >> 'abc'
    final $1 = state.match('abc');
    // << 'abc'
    state.notPredicate = $2;
    if ($1 != null) {
      state.fail(state.position - $pos);
      state.position = $pos;
    }
    final $0 = $1 == null ? const (null,) : null;
    // << !'abc'
    return $0;
  }

  /// **NotDigits**
  ///
  ///```code
  /// `int`
  /// NotDigits =
  ///    $ = [0-9]
  ///```
  (int,)? parseNotDigits(State state) {
    // >> $ = [0-9]
    final $pos = state.position;
    (int,)? $0;
    $0 = state.matchChars16((int c) => c < 48 || c > 57);
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (int,)? parseNotDigitsVoid(State state) {
    // >> [0-9]
    final $0 = state.matchChars16((int c) => c < 48 || c > 57);
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
  (List<String>,)? parseOneOrMore(State state) {
    // >> $ = 'abc'+
    final $pos = state.position;
    (List<String>,)? $0;
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $1 = state.match('abc');
      // << 'abc'
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    $0 = $list.isNotEmpty ? ($list,) : null;
    if ($0 != null) {
      List<String> $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
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
  (List<String>,)? parseOneOrMoreVoid(State state) {
    // >> 'abc'+
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $1 = state.match('abc');
      // << 'abc'
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = $list.isNotEmpty ? ($list,) : null;
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
  (String?,)? parseOptional(State state) {
    // >> $ = 'abc'?
    final $pos = state.position;
    (String?,)? $0;
    // >> 'abc'
    $0 = state.match('abc');
    // << 'abc'
    $0 ??= state.opt((null,));
    if ($0 != null) {
      String? $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
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
  (String?,)? parseOptionalVoid(State state) {
    // >> 'abc'?
    (String?,)? $0;
    // >> 'abc'
    $0 = state.match('abc');
    // << 'abc'
    $0 ??= state.opt((null,));
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
  (String,)? parseOrderedChoice(State state) {
    // >> $ = ($ = 'a' / $ = 'b' / $ = 'c')
    final $pos = state.position;
    (String,)? $0;
    // >> $ = 'a'
    $0 = state.match1('a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
    }
    // << $ = 'a'
    if ($0 == null) {
      // >> $ = 'b'
      $0 = state.match1('b', 98);
      if ($0 != null) {
        String $ = $0.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        state.position = $pos;
      }
      // << $ = 'b'
      if ($0 == null) {
        // >> $ = 'c'
        $0 = state.match1('c', 99);
        if ($0 != null) {
          String $ = $0.$1;
          $0 = ($,);
        }
        if ($0 == null) {
          state.position = $pos;
        }
        // << $ = 'c'
      }
    }
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseOrderedChoiceVoid(State state) {
    // >> ($ = 'a' / $ = 'b' / $ = 'c')
    final $pos = state.position;
    (String,)? $0;
    // >> $ = 'a'
    $0 = state.match1('a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
    }
    // << $ = 'a'
    if ($0 == null) {
      // >> $ = 'b'
      $0 = state.match1('b', 98);
      if ($0 != null) {
        String $ = $0.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        state.position = $pos;
      }
      // << $ = 'b'
      if ($0 == null) {
        // >> $ = 'c'
        $0 = state.match1('c', 99);
        if ($0 != null) {
          String $ = $0.$1;
          $0 = ($,);
        }
        if ($0 == null) {
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
  (String,)? parseRanges(State state) {
    // >> $ = <[0-9A-Za-z]>
    final $pos = state.position;
    (String,)? $0;
    // >> [0-9A-Za-z]
    final $1 = state.matchChars16((int c) =>
        c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57);
    // << [0-9A-Za-z]
    $0 = $1 != null ? (state.input.substring($pos, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseRangesVoid(State state) {
    // >> <[0-9A-Za-z]>
    final $pos = state.position;
    // >> [0-9A-Za-z]
    final $1 = state.matchChars16((int c) =>
        c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57);
    // << [0-9A-Za-z]
    final $0 =
        $1 != null ? (state.input.substring($pos, state.position),) : null;
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
  (String,)? parseSeq2(State state) {
    // >> a = 'a' b = 'b' $ = { }
    final $pos = state.position;
    (String,)? $0;
    // >> a = 'a'
    final $1 = state.match1('a', 97);
    // << a = 'a'
    if ($1 != null) {
      String a = $1.$1;
      // >> b = 'b'
      final $2 = state.match1('b', 98);
      // << b = 'b'
      if ($2 != null) {
        String b = $2.$1;
        // >> $ = { }
        late String $$;
        $$ = a + b;
        final $3 = state.opt(($$,));
        // << $ = { }
        if ($3 != null) {
          String $ = $3.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 == null) {
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
  (void,)? parseSeq2Void(State state) {
    // >> 'a' 'b'
    final $pos = state.position;
    (void,)? $0;
    // >> 'a'
    final $1 = state.match1('a', 97);
    // << 'a'
    if ($1 != null) {
      // >> 'b'
      final $2 = state.match1('b', 98);
      // << 'b'
      if ($2 != null) {
        $0 = const (null,);
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    // << 'a' 'b'
    return $0;
  }

  /// **Seq3**
  ///
  ///```code
  /// `String`
  /// Seq3 =
  ///    a = 'a' b = 'b' c = 'c' $ = { }
  ///```
  (String,)? parseSeq3(State state) {
    // >> a = 'a' b = 'b' c = 'c' $ = { }
    final $pos = state.position;
    (String,)? $0;
    // >> a = 'a'
    final $1 = state.match1('a', 97);
    // << a = 'a'
    if ($1 != null) {
      String a = $1.$1;
      // >> b = 'b'
      final $2 = state.match1('b', 98);
      // << b = 'b'
      if ($2 != null) {
        String b = $2.$1;
        // >> c = 'c'
        final $3 = state.match1('c', 99);
        // << c = 'c'
        if ($3 != null) {
          String c = $3.$1;
          // >> $ = { }
          late String $$;
          $$ = a + b + c;
          final $4 = state.opt(($$,));
          // << $ = { }
          if ($4 != null) {
            String $ = $4.$1;
            $0 = ($,);
          }
        }
      }
    }
    if ($0 == null) {
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
  (void,)? parseSeq3Void(State state) {
    // >> 'a' 'b' 'c'
    final $pos = state.position;
    (void,)? $0;
    // >> 'a'
    final $1 = state.match1('a', 97);
    // << 'a'
    if ($1 != null) {
      // >> 'b'
      final $2 = state.match1('b', 98);
      // << 'b'
      if ($2 != null) {
        // >> 'c'
        final $3 = state.match1('c', 99);
        // << 'c'
        if ($3 != null) {
          $0 = const (null,);
        }
      }
    }
    if ($0 == null) {
      state.position = $pos;
    }
    // << 'a' 'b' 'c'
    return $0;
  }

  /// **TakeWhile**
  ///
  ///```code
  /// `String`
  /// TakeWhile =
  ///    $ = <[a]*>
  ///```
  (String,)? parseTakeWhile(State state) {
    // >> $ = <[a]*>
    final $pos = state.position;
    (String,)? $0;
    // >> [a]*
    final $1 = state.skip16While((int c) => c == 97);
    // << [a]*
    $0 = $1 != null ? (state.input.substring($pos, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseTakeWhile1(State state) {
    // >> $ = <[a]+>
    final $pos = state.position;
    (String,)? $0;
    // >> [a]+
    final $1 = state.skip16While1((int c) => c == 97);
    // << [a]+
    $0 = $1 != null ? (state.input.substring($pos, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
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
  (String,)? parseTakeWhile1Void(State state) {
    // >> <[a]+>
    final $pos = state.position;
    // >> [a]+
    final $1 = state.skip16While1((int c) => c == 97);
    // << [a]+
    final $0 =
        $1 != null ? (state.input.substring($pos, state.position),) : null;
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
  (String,)? parseTakeWhileVoid(State state) {
    // >> <[a]*>
    final $pos = state.position;
    // >> [a]*
    final $1 = state.skip16While((int c) => c == 97);
    // << [a]*
    final $0 =
        $1 != null ? (state.input.substring($pos, state.position),) : null;
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
  (List<String>,)? parseZeroOrMore(State state) {
    // >> $ = 'abc'*
    final $pos = state.position;
    (List<String>,)? $0;
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $1 = state.match('abc');
      // << 'abc'
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    $0 = state.opt(($list,));
    if ($0 != null) {
      List<String> $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      state.position = $pos;
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
  (List<String>,)? parseZeroOrMoreVoid(State state) {
    // >> 'abc'*
    final $list = <String>[];
    while (true) {
      // >> 'abc'
      final $1 = state.match('abc');
      // << 'abc'
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = state.opt(($list,));
    // << 'abc'*
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// Input data for parsing.
  String input;

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

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(Object? result, String element, int start,
      [bool nested = true]) {
    if (_farthestError > position) {
      return;
    }

    if (result != null) {
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match(String string, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position < input.length &&
        input.codeUnitAt(position) == string.codeUnitAt(0)) {
      if (input.startsWith(string, position)) {
        position += string.length;
        result = (string,);
      }
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match1(String string, int char, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position < input.length && input.codeUnitAt(position) == char) {
      position++;
      result = (string,);
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match2(String string, int char, int char2, [bool silent = false]) {
    final start = position;
    (String,)? result;
    if (position + 1 < input.length &&
        input.codeUnitAt(position) == char &&
        input.codeUnitAt(position + 1) == char2) {
      position += 2;
      result = (string,);
    } else {
      fail();
    }

    silent ? null : expected(result, string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchAny() {
    int? c;
    if (position < input.length) {
      c = input.readChar(position);
    }

    c != null ? position += c > 0xffff ? 2 : 1 : fail();
    return c != null ? (c,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChar16(int char) {
    final ok = position < input.length && input.codeUnitAt(position) == char;
    ok ? position++ : fail();
    return ok ? (char,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChar32(int char) {
    final ok = position + 1 < input.length && input.readChar(position) == char;
    ok ? position += 2 : fail();
    return ok ? (char,) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChars16(bool Function(int c) f) {
    (int,)? result;
    if (position < input.length) {
      final c = input.codeUnitAt(position);
      result = f(c) ? (c,) : null;
    }

    result != null ? position++ : fail();
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchChars32(bool Function(int c) f) {
    (int,)? result;
    var c = 0;
    if (position < input.length) {
      c = input.readChar(position);
      result = f(c) ? (c,) : null;
    }

    result != null ? position += c > 0xffff ? 2 : 1 : fail();
    return result;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  T? opt<T>(T value) => value;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip16While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!f(c)) {
        break;
      }

      position++;
    }

    return (const [],);
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip16While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!f(c)) {
        break;
      }

      position++;
    }

    final ok = start != position;
    ok ? null : fail();
    return ok ? (const [],) : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip32While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.readChar(position);
      if (!f(c)) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    return (const [],);
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (List<int>,)? skip32While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.readChar(position);
      if (!f(c)) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    final ok = start != position;
    ok ? null : fail();
    return ok ? (const [],) : null;
  }

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

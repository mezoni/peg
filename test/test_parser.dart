// ignore_for_file: prefer_final_locals

class TestParser {
  /// **A**
  ///
  ///```code
  /// `Object?`
  /// A =
  ///    $ = ($ = '' AndAbc / $ = AnyChar AnyCharVoid / $ = Char16 Char16Void / $ = Chars16 Chars16Void / $ = Char32 Char32Void / $ = Chars32 Chars32Void / $ = Literal0 Literal0Void / $ = Literal1 Literal1Void / $ = Literal2 Literal2Void / $ = Match MatchVoid / $ = NotDigits NotDigitsVoid / $ = '' NotAbc / $ = OneOrMore OneOrMoreVoid / $ = Optional OptionalVoid / $ = OrderedChoice OrderedChoiceVoid / $ = Ranges RangesVoid / $ = TakeWhile TakeWhileVoid / $ = TakeWhile1 TakeWhile1Void / $ = ZeroOrMore ZeroOrMoreVoid)
  ///```
  (Object?,)? parseA(State state) {
    final $3 = state.position;
    (Object?,)? $0;
    (Object?,)? $1 = state.matchLiteral(('',), '');
    if ($1 != null) {
      Object? $ = $1.$1;
      final $2 = parseAndAbc(state);
      if ($2 != null) {
        $0 = ($,);
      }
    }
    if ($0 == null) {
      state.position = $3;
    }
    if ($0 == null) {
      (Object?,)? $4 = parseAnyChar(state);
      if ($4 != null) {
        Object? $ = $4.$1;
        final $5 = parseAnyCharVoid(state);
        if ($5 != null) {
          $0 = ($,);
        }
      }
      if ($0 == null) {
        state.position = $3;
      }
      if ($0 == null) {
        (Object?,)? $6 = parseChar16(state);
        if ($6 != null) {
          Object? $ = $6.$1;
          final $7 = parseChar16Void(state);
          if ($7 != null) {
            $0 = ($,);
          }
        }
        if ($0 == null) {
          state.position = $3;
        }
        if ($0 == null) {
          (Object?,)? $8 = parseChars16(state);
          if ($8 != null) {
            Object? $ = $8.$1;
            final $9 = parseChars16Void(state);
            if ($9 != null) {
              $0 = ($,);
            }
          }
          if ($0 == null) {
            state.position = $3;
          }
          if ($0 == null) {
            (Object?,)? $10 = parseChar32(state);
            if ($10 != null) {
              Object? $ = $10.$1;
              final $11 = parseChar32Void(state);
              if ($11 != null) {
                $0 = ($,);
              }
            }
            if ($0 == null) {
              state.position = $3;
            }
            if ($0 == null) {
              (Object?,)? $12 = parseChars32(state);
              if ($12 != null) {
                Object? $ = $12.$1;
                final $13 = parseChars32Void(state);
                if ($13 != null) {
                  $0 = ($,);
                }
              }
              if ($0 == null) {
                state.position = $3;
              }
              if ($0 == null) {
                (Object?,)? $14 = parseLiteral0(state);
                if ($14 != null) {
                  Object? $ = $14.$1;
                  parseLiteral0Void(state);
                  $0 = ($,);
                }
                if ($0 == null) {
                  (Object?,)? $15 = parseLiteral1(state);
                  if ($15 != null) {
                    Object? $ = $15.$1;
                    final $16 = parseLiteral1Void(state);
                    if ($16 != null) {
                      $0 = ($,);
                    }
                  }
                  if ($0 == null) {
                    state.position = $3;
                  }
                  if ($0 == null) {
                    (Object?,)? $17 = parseLiteral2(state);
                    if ($17 != null) {
                      Object? $ = $17.$1;
                      final $18 = parseLiteral2Void(state);
                      if ($18 != null) {
                        $0 = ($,);
                      }
                    }
                    if ($0 == null) {
                      state.position = $3;
                    }
                    if ($0 == null) {
                      (Object?,)? $19 = parseMatch(state);
                      if ($19 != null) {
                        Object? $ = $19.$1;
                        final $20 = parseMatchVoid(state);
                        if ($20 != null) {
                          $0 = ($,);
                        }
                      }
                      if ($0 == null) {
                        state.position = $3;
                      }
                      if ($0 == null) {
                        (Object?,)? $21 = parseNotDigits(state);
                        if ($21 != null) {
                          Object? $ = $21.$1;
                          final $22 = parseNotDigitsVoid(state);
                          if ($22 != null) {
                            $0 = ($,);
                          }
                        }
                        if ($0 == null) {
                          state.position = $3;
                        }
                        if ($0 == null) {
                          (Object?,)? $23 = state.matchLiteral(('',), '');
                          if ($23 != null) {
                            Object? $ = $23.$1;
                            final $24 = parseNotAbc(state);
                            if ($24 != null) {
                              $0 = ($,);
                            }
                          }
                          if ($0 == null) {
                            state.position = $3;
                          }
                          if ($0 == null) {
                            (Object?,)? $25 = parseOneOrMore(state);
                            if ($25 != null) {
                              Object? $ = $25.$1;
                              final $26 = parseOneOrMoreVoid(state);
                              if ($26 != null) {
                                $0 = ($,);
                              }
                            }
                            if ($0 == null) {
                              state.position = $3;
                            }
                            if ($0 == null) {
                              (Object?,)? $27 = parseOptional(state);
                              if ($27 != null) {
                                Object? $ = $27.$1;
                                parseOptionalVoid(state);
                                $0 = ($,);
                              }
                              if ($0 == null) {
                                (Object?,)? $28 = parseOrderedChoice(state);
                                if ($28 != null) {
                                  Object? $ = $28.$1;
                                  final $29 = parseOrderedChoiceVoid(state);
                                  if ($29 != null) {
                                    $0 = ($,);
                                  }
                                }
                                if ($0 == null) {
                                  state.position = $3;
                                }
                                if ($0 == null) {
                                  (Object?,)? $30 = parseRanges(state);
                                  if ($30 != null) {
                                    Object? $ = $30.$1;
                                    final $31 = parseRangesVoid(state);
                                    if ($31 != null) {
                                      $0 = ($,);
                                    }
                                  }
                                  if ($0 == null) {
                                    state.position = $3;
                                  }
                                  if ($0 == null) {
                                    (Object?,)? $32 = parseTakeWhile(state);
                                    if ($32 != null) {
                                      Object? $ = $32.$1;
                                      parseTakeWhileVoid(state);
                                      $0 = ($,);
                                    }
                                    if ($0 == null) {
                                      (Object?,)? $33 = parseTakeWhile1(state);
                                      if ($33 != null) {
                                        Object? $ = $33.$1;
                                        final $34 = parseTakeWhile1Void(state);
                                        if ($34 != null) {
                                          $0 = ($,);
                                        }
                                      }
                                      if ($0 == null) {
                                        state.position = $3;
                                      }
                                      if ($0 == null) {
                                        (Object?,)? $35 =
                                            parseZeroOrMore(state);
                                        if ($35 != null) {
                                          Object? $ = $35.$1;
                                          parseZeroOrMoreVoid(state);
                                          $0 = ($,);
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
    final $2 = state.position;
    final $1 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
    $1 != null ? null : state.fail<void>();
    state.position = $2;
    final $0 = $1 != null ? (null,) : null;
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
    (int,)? $0 = state.matchAny();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    (int,)? $0 = state.matchAny();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      $1 = c == 97 ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      $1 = c == 97 ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    final $0 = $1 ?? state.fail<int>();
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar32();
      $1 = c == 129024 ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar32();
      $1 = c == 129024 ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 97 ? c <= 122 : c >= 65 && c <= 90;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 97 ? c <= 122 : c >= 65 && c <= 90;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    final $0 = $1 ?? state.fail<int>();
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar32();
      final ok = c >= 129024 && c <= 129027;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar32();
      final ok = c >= 129024 && c <= 129027;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    final $0 = $1 ?? state.fail<int>();
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
    (String,)? $0 = state.matchLiteral(('',), '');
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $0 = state.matchLiteral(('',), '');
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
    (String,)? $0 = state.matchLiteral1(('a',), 'a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $0 = state.matchLiteral1(('a',), 'a', 97);
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
    (String,)? $0 = state.matchLiteral2(('ab',), 'ab', 97, 98);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $0 = state.matchLiteral2(('ab',), 'ab', 97, 98);
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
    final $2 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    state.fail<List<void>>();
    final $1 = state.position != $2 ? const (<int>[],) : null;
    (String,)? $0 = $1 != null ? (state.substring($2, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    state.fail<List<void>>();
    final $1 = state.position != $2 ? const (<int>[],) : null;
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
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
    final $1 = state.position;
    final $predicate = state.predicate;
    state.predicate = true;
    final $2 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
    state.predicate = $predicate;
    final $0 = $2 == null ? (null,) : state.failAndBacktrack<void>($1);
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c < 48 || c > 57;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    (int,)? $0 = $1 ?? state.fail<int>();
    if ($0 != null) {
      int $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    (int,)? $1;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c < 48 || c > 57;
      $1 = ok ? (c,) : null;
      $1 ?? (state.position = $2);
    }
    final $0 = $1 ?? state.fail<int>();
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
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    (List<String>,)? $0 = $list.isNotEmpty ? ($list,) : null;
    if ($0 != null) {
      List<String> $ = $0.$1;
      $0 = ($,);
    }
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
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = $list.isNotEmpty ? ($list,) : null;
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
    (String?,)? $0 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
    $0 ??= (null,);
    String? $ = $0.$1;
    $0 = ($,);
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
    (String?,)? $0 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
    $0 ??= (null,);
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
    (String,)? $0;
    $0 = state.matchLiteral1(('a',), 'a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      $0 = state.matchLiteral1(('b',), 'b', 98);
      if ($0 != null) {
        String $ = $0.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        $0 = state.matchLiteral1(('c',), 'c', 99);
        if ($0 != null) {
          String $ = $0.$1;
          $0 = ($,);
        }
      }
    }
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    (String,)? $0;
    $0 = state.matchLiteral1(('a',), 'a', 97);
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      $0 = state.matchLiteral1(('b',), 'b', 98);
      if ($0 != null) {
        String $ = $0.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        $0 = state.matchLiteral1(('c',), 'c', 99);
        if ($0 != null) {
          String $ = $0.$1;
          $0 = ($,);
        }
      }
    }
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
    final $3 = state.position;
    (int,)? $2;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57;
      $2 = ok ? (c,) : null;
      $2 ?? (state.position = $3);
    }
    final $1 = $2 ?? state.fail<int>();
    (String,)? $0 = $1 != null ? (state.substring($3, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $3 = state.position;
    (int,)? $2;
    if (state.position < state.length) {
      final c = state.nextChar16();
      final ok = c >= 65 ? c <= 90 || c >= 97 && c <= 122 : c >= 48 && c <= 57;
      $2 = ok ? (c,) : null;
      $2 ?? (state.position = $3);
    }
    final $1 = $2 ?? state.fail<int>();
    final $0 = $1 != null ? (state.substring($3, state.position),) : null;
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
    final $1 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    (String,)? $0 = (state.substring($1, state.position),);
    String $ = $0.$1;
    $0 = ($,);
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
    final $2 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    state.fail<List<void>>();
    final $1 = state.position != $2 ? const (<int>[],) : null;
    (String,)? $0 = $1 != null ? (state.substring($2, state.position),) : null;
    if ($0 != null) {
      String $ = $0.$1;
      $0 = ($,);
    }
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
    final $2 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    state.fail<List<void>>();
    final $1 = state.position != $2 ? const (<int>[],) : null;
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
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
    final $1 = state.position;
    while (state.position < state.length) {
      final position = state.position;
      final c = state.nextChar16();
      final ok = c == 97;
      if (!ok) {
        state.position = position;
        break;
      }
    }
    final $0 = (state.substring($1, state.position),);
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
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    (List<String>,)? $0 = ($list,);
    List<String> $ = $0.$1;
    $0 = ($,);
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
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral3(('abc',), 'abc', 97, 98, 99);
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = ($list,);
    return $0;
  }
}

class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// Indicates that parsing occurs within a `not' predicate`.
  ///
  /// When parsed within the `not predicate`, all `expected` errors are
  /// converted to `unexpected` errors.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  int _errorIndex = 0;

  int _expectedIndex = 0;

  final List<String?> _expected = List.filled(128, null);

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  int _farthestUnexpected = 0;

  final String _input;

  final List<bool?> _locations = List.filled(128, null);

  final List<String?> _messages = List.filled(128, null);

  final List<int?> _positions = List.filled(128, null);

  int _unexpectedIndex = 0;

  final List<String?> _unexpectedElements = List.filled(128, null);

  final List<int?> _unexpectedPositions = List.filled(128, null);

  State(String input)
      : _input = input,
        length = input.length;

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
      [bool literal = true]) {
    if (_farthestError > position) {
      return;
    }

    if (result != null) {
      if (!predicate || _farthestUnexpected > position) {
        return;
      }

      if (_farthestUnexpected < position) {
        _farthestUnexpected = position;
        _unexpectedIndex = 0;
      }

      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (_unexpectedIndex < _unexpectedElements.length) {
        _unexpectedElements[_unexpectedIndex] = element;
        _unexpectedPositions[_unexpectedIndex] = start;
        _unexpectedIndex++;
      }
    } else {
      if (!literal && failure != position) {
        return;
      }

      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (!literal) {
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
  (T,)? fail<T>([int length = 0]) {
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return null;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    _farthestFailureLength =
        _farthestFailureLength < length ? length : _farthestFailureLength;
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (T,)? failAndBacktrack<T>(int position) {
    fail<void>(this.position - position);
    this.position = position;
    return null;
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
  (R,)? match<R>((R,) result, String string) {
    final start = position;
    if (position + string.length <= length) {
      for (var i = 0; i < string.length; i++) {
        if (string.codeUnitAt(i) != nextChar16()) {
          position = start;
          return fail();
        }
      }
    }

    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match1<R>((R,) result, int c) {
    final start = position;
    if (position < length && c == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match2<R>((R,) result, int c1, int c2) {
    final start = position;
    if (position + 1 < length && c1 == nextChar16() && c2 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match3<R>((R,) result, int c1, int c2, int c3) {
    final start = position;
    if (position + 2 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match4<R>((R,) result, int c1, int c2, int c3, int c4) {
    final start = position;
    if (position + 3 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16() &&
        c4 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? match5<R>((R,) result, int c1, int c2, int c3, int c4, int c5) {
    final start = position;
    if (position + 4 < length &&
        c1 == nextChar16() &&
        c2 == nextChar16() &&
        c3 == nextChar16() &&
        c4 == nextChar16() &&
        c5 == nextChar16()) {
      return result;
    }

    position = start;
    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (int,)? matchAny() {
    if (position < length) {
      return (nextChar32(),);
    }

    return fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (void,)? matchEof() {
    return position >= length ? (null,) : fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral<R>((R,) result, String literal) {
    final start = position;
    final actual = match(result, literal);
    expected(actual, literal, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral1<R>((R,) result, String string, int c) {
    final start = position;
    final actual = match1(result, c);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral2<R>((R,) result, String string, int c1, int c2) {
    final start = position;
    final actual = match2(result, c1, c2);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral3<R>((R,) result, String string, int c1, int c2, int c3) {
    final start = position;
    final actual = match3(result, c1, c2, c3);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral4<R>(
      (R,) result, String string, int c1, int c2, int c3, int c4) {
    final start = position;
    final actual = match4(result, c1, c2, c3, c4);
    expected(actual, string, start, true);
    return actual;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (R,)? matchLiteral5<R>(
      (R,) result, String string, int c1, int c2, int c3, int c4, int c5) {
    final start = position;
    final actual = match5(result, c1, c2, c3, c4, c5);
    expected(actual, string, start, true);
    return actual;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int nextChar16() => _input.codeUnitAt(position++);

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int nextChar32() {
    final c = _input.readChar(position);
    position += c > 0xffff ? 2 : 1;
    return c;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String substring(int start, int end) => _input.substring(start, end);

  @override
  String toString() {
    if (position >= length) {
      return '';
    }

    var rest = length - position;
    if (rest > 80) {
      rest = 80;
    }

    // Need to create the equivalent of 'substring'
    var line = substring(position, position + rest);
    line = line.replaceAll('\n', '\n');
    return '|$position|$line';
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

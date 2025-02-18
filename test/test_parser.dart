//ignore_for_file: prefer_conditional_assignment, prefer_final_locals

class TestParser {
  /// **A**
  ///
  ///```text
  /// `Object?`
  /// A =>
  ///   $ = (
  ///     $ = ''
  ///     AndAbc
  ///     ----
  ///     $ = AnyChar
  ///     AnyCharVoid
  ///     ----
  ///     $ = Char16
  ///     Char16Void
  ///     ----
  ///     $ = Chars16
  ///     Chars16Void
  ///     ----
  ///     $ = Char32
  ///     Char32Void
  ///     ----
  ///     $ = Chars32
  ///     Chars32Void
  ///     ----
  ///     $ = Literal0
  ///     Literal0Void
  ///     ----
  ///     $ = Literal1
  ///     Literal1Void
  ///     ----
  ///     $ = Literal2
  ///     Literal2Void
  ///     ----
  ///     $ = Match
  ///     MatchVoid
  ///     ----
  ///     $ = NotDigits
  ///     NotDigitsVoid
  ///     ----
  ///     $ = ''
  ///     NotAbc
  ///     ----
  ///     $ = OneOrMore
  ///     OneOrMoreVoid
  ///     ----
  ///     $ = Optional
  ///     OptionalVoid
  ///     ----
  ///     $ = OrderedChoice
  ///     OrderedChoiceVoid
  ///     ----
  ///     $ = Ranges
  ///     RangesVoid
  ///     ----
  ///     $ = TakeWhile
  ///     TakeWhileVoid
  ///     ----
  ///     $ = TakeWhile1
  ///     TakeWhile1Void
  ///     ----
  ///     $ = ZeroOrMore
  ///     ZeroOrMoreVoid
  ///   )
  ///```
  (Object?,)? parseA(State state) {
    final $4 = state.position;
    (Object?,)? $0;
    (Object?,)? $1;
    final $2 = state.matchLiteral('');
    if ($2 != null) {
      Object? $ = $2.$1;
      final $3 = parseAndAbc(state);
      if ($3 != null) {
        $1 = ($,);
      }
    }
    if ($1 == null) {
      state.position = $4;
    }
    if ($1 == null) {
      final $5 = parseAnyChar(state);
      if ($5 != null) {
        Object? $ = $5.$1;
        final $6 = parseAnyCharVoid(state);
        if ($6 != null) {
          $1 = ($,);
        }
      }
      if ($1 == null) {
        state.position = $4;
      }
      if ($1 == null) {
        final $7 = parseChar16(state);
        if ($7 != null) {
          Object? $ = $7.$1;
          final $8 = parseChar16Void(state);
          if ($8 != null) {
            $1 = ($,);
          }
        }
        if ($1 == null) {
          state.position = $4;
        }
        if ($1 == null) {
          final $9 = parseChars16(state);
          if ($9 != null) {
            Object? $ = $9.$1;
            final $10 = parseChars16Void(state);
            if ($10 != null) {
              $1 = ($,);
            }
          }
          if ($1 == null) {
            state.position = $4;
          }
          if ($1 == null) {
            final $11 = parseChar32(state);
            if ($11 != null) {
              Object? $ = $11.$1;
              final $12 = parseChar32Void(state);
              if ($12 != null) {
                $1 = ($,);
              }
            }
            if ($1 == null) {
              state.position = $4;
            }
            if ($1 == null) {
              final $13 = parseChars32(state);
              if ($13 != null) {
                Object? $ = $13.$1;
                final $14 = parseChars32Void(state);
                if ($14 != null) {
                  $1 = ($,);
                }
              }
              if ($1 == null) {
                state.position = $4;
              }
              if ($1 == null) {
                final $15 = parseLiteral0(state);
                if ($15 != null) {
                  Object? $ = $15.$1;
                  parseLiteral0Void(state);
                  $1 = ($,);
                }
                if ($1 == null) {
                  final $16 = parseLiteral1(state);
                  if ($16 != null) {
                    Object? $ = $16.$1;
                    final $17 = parseLiteral1Void(state);
                    if ($17 != null) {
                      $1 = ($,);
                    }
                  }
                  if ($1 == null) {
                    state.position = $4;
                  }
                  if ($1 == null) {
                    final $18 = parseLiteral2(state);
                    if ($18 != null) {
                      Object? $ = $18.$1;
                      final $19 = parseLiteral2Void(state);
                      if ($19 != null) {
                        $1 = ($,);
                      }
                    }
                    if ($1 == null) {
                      state.position = $4;
                    }
                    if ($1 == null) {
                      final $20 = parseMatch(state);
                      if ($20 != null) {
                        Object? $ = $20.$1;
                        final $21 = parseMatchVoid(state);
                        if ($21 != null) {
                          $1 = ($,);
                        }
                      }
                      if ($1 == null) {
                        state.position = $4;
                      }
                      if ($1 == null) {
                        final $22 = parseNotDigits(state);
                        if ($22 != null) {
                          Object? $ = $22.$1;
                          final $23 = parseNotDigitsVoid(state);
                          if ($23 != null) {
                            $1 = ($,);
                          }
                        }
                        if ($1 == null) {
                          state.position = $4;
                        }
                        if ($1 == null) {
                          final $24 = state.matchLiteral('');
                          if ($24 != null) {
                            Object? $ = $24.$1;
                            final $25 = parseNotAbc(state);
                            if ($25 != null) {
                              $1 = ($,);
                            }
                          }
                          if ($1 == null) {
                            state.position = $4;
                          }
                          if ($1 == null) {
                            final $26 = parseOneOrMore(state);
                            if ($26 != null) {
                              Object? $ = $26.$1;
                              final $27 = parseOneOrMoreVoid(state);
                              if ($27 != null) {
                                $1 = ($,);
                              }
                            }
                            if ($1 == null) {
                              state.position = $4;
                            }
                            if ($1 == null) {
                              final $28 = parseOptional(state);
                              if ($28 != null) {
                                Object? $ = $28.$1;
                                parseOptionalVoid(state);
                                $1 = ($,);
                              }
                              if ($1 == null) {
                                final $29 = parseOrderedChoice(state);
                                if ($29 != null) {
                                  Object? $ = $29.$1;
                                  final $30 = parseOrderedChoiceVoid(state);
                                  if ($30 != null) {
                                    $1 = ($,);
                                  }
                                }
                                if ($1 == null) {
                                  state.position = $4;
                                }
                                if ($1 == null) {
                                  final $31 = parseRanges(state);
                                  if ($31 != null) {
                                    Object? $ = $31.$1;
                                    final $32 = parseRangesVoid(state);
                                    if ($32 != null) {
                                      $1 = ($,);
                                    }
                                  }
                                  if ($1 == null) {
                                    state.position = $4;
                                  }
                                  if ($1 == null) {
                                    final $33 = parseTakeWhile(state);
                                    if ($33 != null) {
                                      Object? $ = $33.$1;
                                      parseTakeWhileVoid(state);
                                      $1 = ($,);
                                    }
                                    if ($1 == null) {
                                      final $34 = parseTakeWhile1(state);
                                      if ($34 != null) {
                                        Object? $ = $34.$1;
                                        final $35 = parseTakeWhile1Void(state);
                                        if ($35 != null) {
                                          $1 = ($,);
                                        }
                                      }
                                      if ($1 == null) {
                                        state.position = $4;
                                      }
                                      if ($1 == null) {
                                        final $36 = parseZeroOrMore(state);
                                        if ($36 != null) {
                                          Object? $ = $36.$1;
                                          parseZeroOrMoreVoid(state);
                                          $1 = ($,);
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
    if ($1 != null) {
      Object? $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **AndAbc**
  ///
  ///```text
  /// `void`
  /// AndAbc =>
  ///   &'abc'
  ///```
  (void,)? parseAndAbc(State state) {
    final $2 = state.position;
    final $1 = state.matchLiteral('abc');
    $1 != null ? null : state.fail<void>();
    state.position = $2;
    final $0 = $1 != null ? (null,) : null;
    return $0;
  }

  /// **AnyChar**
  ///
  ///```text
  /// `int`
  /// AnyChar =>
  ///   $ = .
  ///```
  (int,)? parseAnyChar(State state) {
    (int,)? $0;
    final $1 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **AnyCharVoid**
  ///
  ///```text
  /// `int`
  /// AnyCharVoid =>
  ///   $ = .
  ///```
  (int,)? parseAnyCharVoid(State state) {
    (int,)? $0;
    final $1 = state.peek() != 0 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Char16**
  ///
  ///```text
  /// `int`
  /// Char16 =>
  ///   $ = [a]
  ///```
  (int,)? parseChar16(State state) {
    (int,)? $0;
    final $1 = state.peek() == 97 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Char16Void**
  ///
  ///```text
  /// `int`
  /// Char16Void =>
  ///   [a]
  ///```
  (int,)? parseChar16Void(State state) {
    final $0 = state.peek() == 97 ? (state.advance(),) : state.fail<int>();
    return $0;
  }

  /// **Char32**
  ///
  ///```text
  /// `int`
  /// Char32 =>
  ///   $ = [{1f800}]
  ///```
  (int,)? parseChar32(State state) {
    (int,)? $0;
    final $1 = state.peek() == 129024 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Char32Void**
  ///
  ///```text
  /// `int`
  /// Char32Void =>
  ///   $ = [{1f800}]
  ///```
  (int,)? parseChar32Void(State state) {
    (int,)? $0;
    final $1 = state.peek() == 129024 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Chars16**
  ///
  ///```text
  /// `int`
  /// Chars16 =>
  ///   $ = [a-zA-Z]
  ///```
  (int,)? parseChars16(State state) {
    (int,)? $0;
    final $2 = state.peek();
    final $1 = ($2 >= 97 ? $2 <= 122 : $2 >= 65 && $2 <= 90)
        ? (state.advance(),)
        : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Chars16Void**
  ///
  ///```text
  /// `int`
  /// Chars16Void =>
  ///   [a-zA-Z]
  ///```
  (int,)? parseChars16Void(State state) {
    final $1 = state.peek();
    final $0 = ($1 >= 97 ? $1 <= 122 : $1 >= 65 && $1 <= 90)
        ? (state.advance(),)
        : state.fail<int>();
    return $0;
  }

  /// **Chars32**
  ///
  ///```text
  /// `int`
  /// Chars32 =>
  ///   $ = [{1f800-1f803}]
  ///```
  (int,)? parseChars32(State state) {
    (int,)? $0;
    final $2 = state.peek();
    final $1 =
        $2 >= 129024 && $2 <= 129027 ? (state.advance(),) : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Chars32Void**
  ///
  ///```text
  /// `int`
  /// Chars32Void =>
  ///   [{1f800-1f803}]
  ///```
  (int,)? parseChars32Void(State state) {
    final $1 = state.peek();
    final $0 =
        $1 >= 129024 && $1 <= 129027 ? (state.advance(),) : state.fail<int>();
    return $0;
  }

  /// **Literal0**
  ///
  ///```text
  /// `String`
  /// Literal0 =>
  ///   $ = ''
  ///```
  (String,)? parseLiteral0(State state) {
    (String,)? $0;
    final $1 = state.matchLiteral('');
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Literal0Void**
  ///
  ///```text
  /// `String`
  /// Literal0Void =>
  ///   ''
  ///```
  (String,)? parseLiteral0Void(State state) {
    final $0 = state.matchLiteral('');
    return $0;
  }

  /// **Literal1**
  ///
  ///```text
  /// `String`
  /// Literal1 =>
  ///   $ = 'a'
  ///```
  (String,)? parseLiteral1(State state) {
    (String,)? $0;
    final $1 = state.matchLiteral1('a', 97);
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Literal1Void**
  ///
  ///```text
  /// `String`
  /// Literal1Void =>
  ///   'a'
  ///```
  (String,)? parseLiteral1Void(State state) {
    final $0 = state.matchLiteral1('a', 97);
    return $0;
  }

  /// **Literal2**
  ///
  ///```text
  /// `String`
  /// Literal2 =>
  ///   $ = 'ab'
  ///```
  (String,)? parseLiteral2(State state) {
    (String,)? $0;
    final $1 = state.matchLiteral('ab');
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **Literal2Void**
  ///
  ///```text
  /// `String`
  /// Literal2Void =>
  ///   'ab'
  ///```
  (String,)? parseLiteral2Void(State state) {
    final $0 = state.matchLiteral('ab');
    return $0;
  }

  /// **Match**
  ///
  ///```text
  /// `String`
  /// Match =>
  ///   $ = <[a]+>
  ///```
  (String,)? parseMatch(State state) {
    final $3 = state.position;
    (String,)? $0;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $2 = state.position != $3 ? (null,) : state.fail<List<int>>();
    final $1 = $2 != null ? (state.substring($3, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **MatchVoid**
  ///
  ///```text
  /// `String`
  /// MatchVoid =>
  ///   <[a]+>
  ///```
  (String,)? parseMatchVoid(State state) {
    final $2 = state.position;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $1 = state.position != $2 ? (null,) : state.fail<List<int>>();
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
    return $0;
  }

  /// **NotAbc**
  ///
  ///```text
  /// `void`
  /// NotAbc =>
  ///   !'abc'
  ///```
  (void,)? parseNotAbc(State state) {
    final $1 = state.position;
    final $predicate = state.predicate;
    state.predicate = true;
    final $2 = state.matchLiteral('abc');
    state.predicate = $predicate;
    final $0 = $2 == null ? (null,) : state.failAndBacktrack<void>($1);
    return $0;
  }

  /// **NotDigits**
  ///
  ///```text
  /// `int`
  /// NotDigits =>
  ///   $ = [^0-9]
  ///```
  (int,)? parseNotDigits(State state) {
    (int,)? $0;
    final $2 = state.peek();
    final $1 = !($2 == 0 || $2 >= 48 && $2 <= 57)
        ? (state.advance(),)
        : state.fail<int>();
    if ($1 != null) {
      int $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **NotDigitsVoid**
  ///
  ///```text
  /// `int`
  /// NotDigitsVoid =>
  ///   [^0-9]
  ///```
  (int,)? parseNotDigitsVoid(State state) {
    final $1 = state.peek();
    final $0 = !($1 == 0 || $1 >= 48 && $1 <= 57)
        ? (state.advance(),)
        : state.fail<int>();
    return $0;
  }

  /// **OneOrMore**
  ///
  ///```text
  /// `List<String>`
  /// OneOrMore =>
  ///   $ = 'abc'+
  ///```
  (List<String>,)? parseOneOrMore(State state) {
    (List<String>,)? $0;
    final $list = <String>[];
    while (true) {
      final $2 = state.matchLiteral('abc');
      if ($2 == null) {
        break;
      }
      $list.add($2.$1);
    }
    final $1 = $list.isNotEmpty ? ($list,) : state.fail<List<String>>();
    if ($1 != null) {
      List<String> $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **OneOrMoreVoid**
  ///
  ///```text
  /// `List<String>`
  /// OneOrMoreVoid =>
  ///   'abc'+
  ///```
  (List<String>,)? parseOneOrMoreVoid(State state) {
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral('abc');
      if ($1 == null) {
        break;
      }
      $list.add($1.$1);
    }
    final $0 = $list.isNotEmpty ? ($list,) : state.fail<List<String>>();
    return $0;
  }

  /// **Optional**
  ///
  ///```text
  /// `String?`
  /// Optional =>
  ///   $ = 'abc'?
  ///```
  (String?,)? parseOptional(State state) {
    (String?,)? $0;
    (String?,)? $1 = state.matchLiteral('abc');
    $1 ??= (null,);
    String? $ = $1.$1;
    $0 = ($,);
    return $0;
  }

  /// **OptionalVoid**
  ///
  ///```text
  /// `String?`
  /// OptionalVoid =>
  ///   'abc'?
  ///```
  (String?,)? parseOptionalVoid(State state) {
    (String?,)? $0 = state.matchLiteral('abc');
    $0 ??= (null,);
    return $0;
  }

  /// **OrderedChoice**
  ///
  ///```text
  /// `String`
  /// OrderedChoice =>
  ///   $ = (
  ///     $ = 'a'
  ///     ----
  ///     $ = 'b'
  ///     ----
  ///     $ = 'c'
  ///   )
  ///```
  (String,)? parseOrderedChoice(State state) {
    (String,)? $0;
    (String,)? $1;
    final $2 = state.matchLiteral1('a', 97);
    if ($2 != null) {
      String $ = $2.$1;
      $1 = ($,);
    }
    if ($1 == null) {
      final $3 = state.matchLiteral1('b', 98);
      if ($3 != null) {
        String $ = $3.$1;
        $1 = ($,);
      }
      if ($1 == null) {
        final $4 = state.matchLiteral1('c', 99);
        if ($4 != null) {
          String $ = $4.$1;
          $1 = ($,);
        }
      }
    }
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **OrderedChoiceVoid**
  ///
  ///```text
  /// `String`
  /// OrderedChoiceVoid =>
  ///   (
  ///     $ = 'a'
  ///     ----
  ///     $ = 'b'
  ///     ----
  ///     $ = 'c'
  ///   )
  ///```
  (String,)? parseOrderedChoiceVoid(State state) {
    (String,)? $0;
    final $1 = state.matchLiteral1('a', 97);
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    if ($0 == null) {
      final $2 = state.matchLiteral1('b', 98);
      if ($2 != null) {
        String $ = $2.$1;
        $0 = ($,);
      }
      if ($0 == null) {
        final $3 = state.matchLiteral1('c', 99);
        if ($3 != null) {
          String $ = $3.$1;
          $0 = ($,);
        }
      }
    }
    return $0;
  }

  /// **Ranges**
  ///
  ///```text
  /// `String`
  /// Ranges =>
  ///   $ = <[0-9A-Za-z]>
  ///```
  (String,)? parseRanges(State state) {
    final $3 = state.position;
    (String,)? $0;
    final $4 = state.peek();
    final $2 =
        ($4 >= 65 ? $4 <= 90 || $4 >= 97 && $4 <= 122 : $4 >= 48 && $4 <= 57)
            ? (state.advance(),)
            : state.fail<int>();
    final $1 = $2 != null ? (state.substring($3, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **RangesVoid**
  ///
  ///```text
  /// `String`
  /// RangesVoid =>
  ///   <[0-9A-Za-z]>
  ///```
  (String,)? parseRangesVoid(State state) {
    final $2 = state.position;
    final $3 = state.peek();
    final $1 =
        ($3 >= 65 ? $3 <= 90 || $3 >= 97 && $3 <= 122 : $3 >= 48 && $3 <= 57)
            ? (state.advance(),)
            : state.fail<int>();
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
    return $0;
  }

  /// **TakeWhile**
  ///
  ///```text
  /// `String`
  /// TakeWhile =>
  ///   $ = <[a]*>
  ///```
  (String,)? parseTakeWhile(State state) {
    final $2 = state.position;
    (String,)? $0;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $1 = (state.substring($2, state.position),);
    String $ = $1.$1;
    $0 = ($,);
    return $0;
  }

  /// **TakeWhile1**
  ///
  ///```text
  /// `String`
  /// TakeWhile1 =>
  ///   $ = <[a]+>
  ///```
  (String,)? parseTakeWhile1(State state) {
    final $3 = state.position;
    (String,)? $0;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $2 = state.position != $3 ? (null,) : state.fail<List<int>>();
    final $1 = $2 != null ? (state.substring($3, state.position),) : null;
    if ($1 != null) {
      String $ = $1.$1;
      $0 = ($,);
    }
    return $0;
  }

  /// **TakeWhile1Void**
  ///
  ///```text
  /// `String`
  /// TakeWhile1Void =>
  ///   <[a]+>
  ///```
  (String,)? parseTakeWhile1Void(State state) {
    final $2 = state.position;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $1 = state.position != $2 ? (null,) : state.fail<List<int>>();
    final $0 = $1 != null ? (state.substring($2, state.position),) : null;
    return $0;
  }

  /// **TakeWhileVoid**
  ///
  ///```text
  /// `String`
  /// TakeWhileVoid =>
  ///   <[a]*>
  ///```
  (String,)? parseTakeWhileVoid(State state) {
    final $1 = state.position;
    for (var c = state.peek(); c == 97;) {
      state.advance();
      c = state.peek();
    }
    final $0 = (state.substring($1, state.position),);
    return $0;
  }

  /// **ZeroOrMore**
  ///
  ///```text
  /// `List<String>`
  /// ZeroOrMore =>
  ///   $ = 'abc'*
  ///```
  (List<String>,)? parseZeroOrMore(State state) {
    (List<String>,)? $0;
    final $list = <String>[];
    while (true) {
      final $2 = state.matchLiteral('abc');
      if ($2 == null) {
        break;
      }
      $list.add($2.$1);
    }
    final $1 = ($list,);
    List<String> $ = $1.$1;
    $0 = ($,);
    return $0;
  }

  /// **ZeroOrMoreVoid**
  ///
  ///```text
  /// `List<String>`
  /// ZeroOrMoreVoid =>
  ///   'abc'*
  ///```
  (List<String>,)? parseZeroOrMoreVoid(State state) {
    final $list = <String>[];
    while (true) {
      final $1 = state.matchLiteral('abc');
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
  static const flagUseStart = 1;

  static const flagUseEnd = 2;

  static const flagExpected = 4;

  static const flagUnexpected = 8;

  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// This field is for internal use only.
  int nesting = -1;

  /// This field is for internal use only.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  int _ch = 0;

  int _errorIndex = 0;

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  final List<int?> _flags = List.filled(128, null);

  final String _input;

  final List<String?> _messages = List.filled(128, null);

  int _peekPosition = -1;

  final List<int?> _starts = List.filled(128, null);

  State(String input)
      : _input = input,
        length = input.length {
    peek();
  }

  /// Advances the current [position] to the next character position and
  /// returns the character from the current position.
  ///
  /// A call to this method must be preceded by a call to the [peek] method,
  /// otherwise the behavior of this method is undefined.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int advance() {
    position += _ch > 0xffff ? 2 : 1;
    return _ch;
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void error(String message, int start, int end, int flag) {
    if (_farthestError > end) {
      return;
    }

    if (_farthestError < end) {
      _farthestError = end;
      _errorIndex = 0;
    }

    if (_errorIndex < _messages.length) {
      _flags[_errorIndex] = flag;
      _messages[_errorIndex] = message;
      _starts[_errorIndex] = start;
      _errorIndex++;
    }
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(Object? result, String string, int start, int end) {
    if (result != null) {
      predicate ? error(string, start, end, flagUnexpected) : null;
    } else {
      predicate ? null : error(string, start, end, flagExpected);
    }
  }

  /// This method is for internal use only.
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

    if (length != 0) {
      _farthestFailureLength =
          _farthestFailureLength < length ? length : _farthestFailureLength;
    }

    return null;
  }

  /// This method is for internal use only.
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
    final expected = <String>{};
    final unexpected = <(int, int), Set<String>>{};
    for (var i = 0; i < _errorIndex; i++) {
      final message = _messages[i];
      if (message == null) {
        continue;
      }

      final flag = _flags[i]!;
      final startPosition = _starts[i]!;
      if (flag & (flagExpected | flagUnexpected) == 0) {
        var start = flag & flagUseStart == 0 ? startPosition : _farthestError;
        var end = flag & flagUseEnd == 0 ? _farthestError : startPosition;
        if (start > end) {
          start = startPosition;
          end = _farthestError;
        }

        errors.add((message: message, start: start, end: end));
      } else if (flag & flagExpected != 0) {
        expected.add(message);
      } else if (flag & flagUnexpected != 0) {
        (unexpected[(startPosition, _farthestError)] ??= {}).add(message);
      }
    }

    if (expected.isNotEmpty) {
      final list = expected.toList();
      list.sort();
      final message = 'Expected: ${list.map((e) => '\'$e\'').join(', ')}';
      errors
          .add((message: message, start: _farthestError, end: _farthestError));
    }

    if (unexpected.isNotEmpty) {
      for (final entry in unexpected.entries) {
        final key = entry.key;
        final value = entry.value;
        final list = value.toList();
        list.sort();
        final message = 'Unexpected: ${list.map((e) => '\'$e\'').join(', ')}';
        errors.add((message: message, start: key.$1, end: key.$2));
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

  /// Matches the input data at the current [position] with the string [string].
  ///
  /// If successful, advances the [position] by the length of the [string] (in
  /// input data units) and returns the specified [string], otherwise calls the
  /// [fails] method and returns `null`.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? match(String string) {
    if (startsWith(string, position)) {
      position += string.length;
      return (string,);
    }

    fail<void>();
    return null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? matchLiteral(String string) {
    final start = position;
    final result = match(string);
    if (nesting < position) {
      expected(result, string, start, position);
    }

    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  (String,)? matchLiteral1(String string, int char) {
    final start = position;
    final result = peek() == char ? (string,) : null;
    result != null ? advance() : fail<void>();
    if (nesting < position) {
      expected(result, string, start, position);
    }

    return result;
  }

  /// Reads and returns the character at the current [position].
  ///
  /// If the end of the input data is reached, the return value is `0`.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int peek() {
    if (_peekPosition == position) {
      return _ch;
    }

    _peekPosition = position;
    if (position < length) {
      if ((_ch = _input.codeUnitAt(position)) < 0xd800) {
        return _ch;
      }

      if (_ch < 0xe000) {
        final c = _input.codeUnitAt(position + 1);
        if ((c & 0xfc00) == 0xdc00) {
          return _ch = 0x10000 + ((_ch & 0x3ff) << 10) + (c & 0x3ff);
        }

        throw FormatException('Invalid UTF-16 character', this, position);
      }

      return _ch;
    } else {
      return _ch = 0;
    }
  }

  bool startsWith(String string, int position) =>
      _input.startsWith(string, position);

  /// Returns a substring of the input data, starting at position [start] and
  /// ending at position [end].
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

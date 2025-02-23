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
  ///     [0]
  ///     ----
  ///     $ = AnyChar
  ///     AnyCharVoid
  ///     [0]
  ///     ----
  ///     $ = Char16
  ///     Char16Void
  ///     [0]
  ///     ----
  ///     $ = Chars16
  ///     Chars16Void
  ///     [0]
  ///     ----
  ///     $ = Char32
  ///     Char32Void
  ///     [0]
  ///     ----
  ///     $ = Chars32
  ///     Chars32Void
  ///     [0]
  ///     ----
  ///     $ = Literal0
  ///     Literal0Void
  ///     [0]
  ///     ----
  ///     $ = Literal1
  ///     Literal1Void
  ///     [0]
  ///     ----
  ///     $ = Literal2
  ///     Literal2Void
  ///     [0]
  ///     ----
  ///     $ = Match
  ///     MatchVoid
  ///     [0]
  ///     ----
  ///     $ = NotDigits
  ///     NotDigitsVoid
  ///     [0]
  ///     ----
  ///     $ = ''
  ///     NotAbc
  ///     [0]
  ///     ----
  ///     $ = OneOrMore
  ///     OneOrMoreVoid
  ///     [0]
  ///     ----
  ///     $ = Optional
  ///     OptionalVoid
  ///     [0]
  ///     ----
  ///     $ = OrderedChoice
  ///     OrderedChoiceVoid
  ///     [0]
  ///     ----
  ///     $ = Ranges
  ///     RangesVoid
  ///     [0]
  ///     ----
  ///     $ = TakeWhile
  ///     TakeWhileVoid
  ///     [0]
  ///     ----
  ///     $ = TakeWhile1
  ///     TakeWhile1Void
  ///     [0]
  ///     ----
  ///     $ = ZeroOrMore
  ///     ZeroOrMoreVoid
  ///     [0]
  ///   )
  ///```
  (Object?,)? parseA(State state) {
    final $2 = state.position;
    (Object?,)? $0;
    (Object?,)? $1;
    Object? $ = '';
    final $3 = parseAndAbc(state);
    if ($3 != null) {
      if (state.peek() == 48) {
        state.position += state.charSize(48);
        $1 = ($,);
      } else {
        state.fail();
      }
    }
    if ($1 != null) {
      $0 = $1;
    } else {
      state.position = $2;
      (Object?,)? $4;
      final $5 = parseAnyChar(state);
      if ($5 != null) {
        Object? $ = $5.$1;
        final $6 = parseAnyCharVoid(state);
        if ($6 != null) {
          if (state.peek() == 48) {
            state.position += state.charSize(48);
            $4 = ($,);
          } else {
            state.fail();
          }
        }
      }
      if ($4 != null) {
        $0 = $4;
      } else {
        state.position = $2;
        (Object?,)? $7;
        final $8 = parseChar16(state);
        if ($8 != null) {
          Object? $ = $8.$1;
          final $9 = parseChar16Void(state);
          if ($9 != null) {
            if (state.peek() == 48) {
              state.position += state.charSize(48);
              $7 = ($,);
            } else {
              state.fail();
            }
          }
        }
        if ($7 != null) {
          $0 = $7;
        } else {
          state.position = $2;
          (Object?,)? $10;
          final $11 = parseChars16(state);
          if ($11 != null) {
            Object? $ = $11.$1;
            final $12 = parseChars16Void(state);
            if ($12 != null) {
              if (state.peek() == 48) {
                state.position += state.charSize(48);
                $10 = ($,);
              } else {
                state.fail();
              }
            }
          }
          if ($10 != null) {
            $0 = $10;
          } else {
            state.position = $2;
            (Object?,)? $13;
            final $14 = parseChar32(state);
            if ($14 != null) {
              Object? $ = $14.$1;
              final $15 = parseChar32Void(state);
              if ($15 != null) {
                if (state.peek() == 48) {
                  state.position += state.charSize(48);
                  $13 = ($,);
                } else {
                  state.fail();
                }
              }
            }
            if ($13 != null) {
              $0 = $13;
            } else {
              state.position = $2;
              (Object?,)? $16;
              final $17 = parseChars32(state);
              if ($17 != null) {
                Object? $ = $17.$1;
                final $18 = parseChars32Void(state);
                if ($18 != null) {
                  if (state.peek() == 48) {
                    state.position += state.charSize(48);
                    $16 = ($,);
                  } else {
                    state.fail();
                  }
                }
              }
              if ($16 != null) {
                $0 = $16;
              } else {
                state.position = $2;
                (Object?,)? $19;
                final $20 = parseLiteral0(state);
                Object? $ = $20;
                parseLiteral0Void(state);
                if (state.peek() == 48) {
                  state.position += state.charSize(48);
                  $19 = ($,);
                } else {
                  state.fail();
                }
                if ($19 != null) {
                  $0 = $19;
                } else {
                  state.position = $2;
                  (Object?,)? $21;
                  final $22 = parseLiteral1(state);
                  if ($22 != null) {
                    Object? $ = $22.$1;
                    final $23 = parseLiteral1Void(state);
                    if ($23 != null) {
                      if (state.peek() == 48) {
                        state.position += state.charSize(48);
                        $21 = ($,);
                      } else {
                        state.fail();
                      }
                    }
                  }
                  if ($21 != null) {
                    $0 = $21;
                  } else {
                    state.position = $2;
                    (Object?,)? $24;
                    final $25 = parseLiteral2(state);
                    if ($25 != null) {
                      Object? $ = $25.$1;
                      final $26 = parseLiteral2Void(state);
                      if ($26 != null) {
                        if (state.peek() == 48) {
                          state.position += state.charSize(48);
                          $24 = ($,);
                        } else {
                          state.fail();
                        }
                      }
                    }
                    if ($24 != null) {
                      $0 = $24;
                    } else {
                      state.position = $2;
                      (Object?,)? $27;
                      final $28 = parseMatch(state);
                      if ($28 != null) {
                        Object? $ = $28.$1;
                        final $29 = parseMatchVoid(state);
                        if ($29 != null) {
                          if (state.peek() == 48) {
                            state.position += state.charSize(48);
                            $27 = ($,);
                          } else {
                            state.fail();
                          }
                        }
                      }
                      if ($27 != null) {
                        $0 = $27;
                      } else {
                        state.position = $2;
                        (Object?,)? $30;
                        final $31 = parseNotDigits(state);
                        if ($31 != null) {
                          Object? $ = $31.$1;
                          final $32 = parseNotDigitsVoid(state);
                          if ($32 != null) {
                            if (state.peek() == 48) {
                              state.position += state.charSize(48);
                              $30 = ($,);
                            } else {
                              state.fail();
                            }
                          }
                        }
                        if ($30 != null) {
                          $0 = $30;
                        } else {
                          state.position = $2;
                          (Object?,)? $33;
                          Object? $ = '';
                          final $34 = parseNotAbc(state);
                          if ($34 != null) {
                            if (state.peek() == 48) {
                              state.position += state.charSize(48);
                              $33 = ($,);
                            } else {
                              state.fail();
                            }
                          }
                          if ($33 != null) {
                            $0 = $33;
                          } else {
                            state.position = $2;
                            (Object?,)? $35;
                            final $36 = parseOneOrMore(state);
                            if ($36 != null) {
                              Object? $ = $36.$1;
                              final $37 = parseOneOrMoreVoid(state);
                              if ($37 != null) {
                                if (state.peek() == 48) {
                                  state.position += state.charSize(48);
                                  $35 = ($,);
                                } else {
                                  state.fail();
                                }
                              }
                            }
                            if ($35 != null) {
                              $0 = $35;
                            } else {
                              state.position = $2;
                              (Object?,)? $38;
                              final $39 = parseOptional(state);
                              Object? $ = $39;
                              parseOptionalVoid(state);
                              if (state.peek() == 48) {
                                state.position += state.charSize(48);
                                $38 = ($,);
                              } else {
                                state.fail();
                              }
                              if ($38 != null) {
                                $0 = $38;
                              } else {
                                state.position = $2;
                                (Object?,)? $40;
                                final $41 = parseOrderedChoice(state);
                                if ($41 != null) {
                                  Object? $ = $41.$1;
                                  final $42 = parseOrderedChoiceVoid(state);
                                  if ($42 != null) {
                                    if (state.peek() == 48) {
                                      state.position += state.charSize(48);
                                      $40 = ($,);
                                    } else {
                                      state.fail();
                                    }
                                  }
                                }
                                if ($40 != null) {
                                  $0 = $40;
                                } else {
                                  state.position = $2;
                                  (Object?,)? $43;
                                  final $44 = parseRanges(state);
                                  if ($44 != null) {
                                    Object? $ = $44.$1;
                                    final $45 = parseRangesVoid(state);
                                    if ($45 != null) {
                                      if (state.peek() == 48) {
                                        state.position += state.charSize(48);
                                        $43 = ($,);
                                      } else {
                                        state.fail();
                                      }
                                    }
                                  }
                                  if ($43 != null) {
                                    $0 = $43;
                                  } else {
                                    state.position = $2;
                                    (Object?,)? $46;
                                    final $47 = parseTakeWhile(state);
                                    Object? $ = $47;
                                    parseTakeWhileVoid(state);
                                    if (state.peek() == 48) {
                                      state.position += state.charSize(48);
                                      $46 = ($,);
                                    } else {
                                      state.fail();
                                    }
                                    if ($46 != null) {
                                      $0 = $46;
                                    } else {
                                      state.position = $2;
                                      (Object?,)? $48;
                                      final $49 = parseTakeWhile1(state);
                                      if ($49 != null) {
                                        Object? $ = $49.$1;
                                        final $50 = parseTakeWhile1Void(state);
                                        if ($50 != null) {
                                          if (state.peek() == 48) {
                                            state.position +=
                                                state.charSize(48);
                                            $48 = ($,);
                                          } else {
                                            state.fail();
                                          }
                                        }
                                      }
                                      if ($48 != null) {
                                        $0 = $48;
                                      } else {
                                        state.position = $2;
                                        (Object?,)? $51;
                                        final $52 = parseZeroOrMore(state);
                                        Object? $ = $52;
                                        parseZeroOrMoreVoid(state);
                                        if (state.peek() == 48) {
                                          state.position += state.charSize(48);
                                          $51 = ($,);
                                        } else {
                                          state.fail();
                                        }
                                        if ($51 != null) {
                                          $0 = $51;
                                        } else {
                                          state.position = $2;
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
      return ($,);
    } else {
      return null;
    }
  }

  /// **AndAbc**
  ///
  ///```text
  /// `void`
  /// AndAbc =>
  ///   &'abc'
  ///```
  (void,)? parseAndAbc(State state) {
    final $0 = state.position;
    if (state.peek() == 97 && state.startsWith('abc', state.position)) {
      state.consume('abc', $0);
      state.position = $0;
      return const (null,);
    } else {
      state.expected('abc');
      return null;
    }
  }

  /// **AnyChar**
  ///
  ///```text
  /// `int`
  /// AnyChar =>
  ///   $ = .
  ///```
  (int,)? parseAnyChar(State state) {
    final $0 = state.peek();
    if ($0 != 0) {
      state.position += state.charSize($0);
      int $ = $0;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **AnyCharVoid**
  ///
  ///```text
  /// `int`
  /// AnyCharVoid =>
  ///   $ = .
  ///```
  (int,)? parseAnyCharVoid(State state) {
    final $0 = state.peek();
    if ($0 != 0) {
      state.position += state.charSize($0);
      int $ = $0;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Char16**
  ///
  ///```text
  /// `int`
  /// Char16 =>
  ///   $ = [a]
  ///```
  (int,)? parseChar16(State state) {
    if (state.peek() == 97) {
      state.position += state.charSize(97);
      int $ = 97;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Char16Void**
  ///
  ///```text
  /// `int`
  /// Char16Void =>
  ///   [a]
  ///```
  (int,)? parseChar16Void(State state) {
    if (state.peek() == 97) {
      state.position += state.charSize(97);
      return const (97,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Char32**
  ///
  ///```text
  /// `int`
  /// Char32 =>
  ///   $ = [{1f800}]
  ///```
  (int,)? parseChar32(State state) {
    if (state.peek() == 129024) {
      state.position += state.charSize(129024);
      int $ = 129024;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Char32Void**
  ///
  ///```text
  /// `int`
  /// Char32Void =>
  ///   $ = [{1f800}]
  ///```
  (int,)? parseChar32Void(State state) {
    if (state.peek() == 129024) {
      state.position += state.charSize(129024);
      int $ = 129024;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Chars16**
  ///
  ///```text
  /// `int`
  /// Chars16 =>
  ///   $ = [a-zA-Z]
  ///```
  (int,)? parseChars16(State state) {
    final $0 = state.peek();
    if ($0 >= 97 ? $0 <= 122 : $0 >= 65 && $0 <= 90) {
      state.position += state.charSize($0);
      int $ = $0;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Chars16Void**
  ///
  ///```text
  /// `int`
  /// Chars16Void =>
  ///   [a-zA-Z]
  ///```
  (int,)? parseChars16Void(State state) {
    final $0 = state.peek();
    if ($0 >= 97 ? $0 <= 122 : $0 >= 65 && $0 <= 90) {
      state.position += state.charSize($0);
      return ($0,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Chars32**
  ///
  ///```text
  /// `int`
  /// Chars32 =>
  ///   $ = [{1f800-1f803}]
  ///```
  (int,)? parseChars32(State state) {
    final $0 = state.peek();
    if ($0 >= 129024 && $0 <= 129027) {
      state.position += state.charSize($0);
      int $ = $0;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Chars32Void**
  ///
  ///```text
  /// `int`
  /// Chars32Void =>
  ///   [{1f800-1f803}]
  ///```
  (int,)? parseChars32Void(State state) {
    final $0 = state.peek();
    if ($0 >= 129024 && $0 <= 129027) {
      state.position += state.charSize($0);
      return ($0,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **Literal0**
  ///
  ///```text
  /// `String`
  /// Literal0 =>
  ///   $ = ''
  ///```
  String parseLiteral0(State state) {
    String $ = '';
    return $;
  }

  /// **Literal0Void**
  ///
  ///```text
  /// `String`
  /// Literal0Void =>
  ///   ''
  ///```
  String parseLiteral0Void(State state) {
    return '';
  }

  /// **Literal1**
  ///
  ///```text
  /// `String`
  /// Literal1 =>
  ///   $ = 'a'
  ///```
  (String,)? parseLiteral1(State state) {
    final $0 = state.position;
    if (state.peek() == 97) {
      state.consume('a', $0);
      String $ = 'a';
      return ($,);
    } else {
      state.expected('a');
      return null;
    }
  }

  /// **Literal1Void**
  ///
  ///```text
  /// `String`
  /// Literal1Void =>
  ///   'a'
  ///```
  (String,)? parseLiteral1Void(State state) {
    final $0 = state.position;
    if (state.peek() == 97) {
      state.consume('a', $0);
      return const ('a',);
    } else {
      state.expected('a');
      return null;
    }
  }

  /// **Literal2**
  ///
  ///```text
  /// `String`
  /// Literal2 =>
  ///   $ = 'ab'
  ///```
  (String,)? parseLiteral2(State state) {
    final $0 = state.position;
    if (state.peek() == 97 && state.startsWith('ab', state.position)) {
      state.consume('ab', $0);
      String $ = 'ab';
      return ($,);
    } else {
      state.expected('ab');
      return null;
    }
  }

  /// **Literal2Void**
  ///
  ///```text
  /// `String`
  /// Literal2Void =>
  ///   'ab'
  ///```
  (String,)? parseLiteral2Void(State state) {
    final $0 = state.position;
    if (state.peek() == 97 && state.startsWith('ab', state.position)) {
      state.consume('ab', $0);
      return const ('ab',);
    } else {
      state.expected('ab');
      return null;
    }
  }

  /// **Match**
  ///
  ///```text
  /// `String`
  /// Match =>
  ///   $ = <[a]+>
  ///```
  (String,)? parseMatch(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      $1 = state.substring($0, state.position);
      String $ = $1;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **MatchVoid**
  ///
  ///```text
  /// `String`
  /// MatchVoid =>
  ///   <[a]+>
  ///```
  (String,)? parseMatchVoid(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      $1 = state.substring($0, state.position);
      return ($1,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **NotAbc**
  ///
  ///```text
  /// `void`
  /// NotAbc =>
  ///   !'abc'
  ///```
  (void,)? parseNotAbc(State state) {
    final $0 = state.position;
    final $1 = state.predicate;
    state.predicate = true;
    var $2 = true;
    if (state.peek() == 97 && state.startsWith('abc', state.position)) {
      state.consume('abc', $0);
      state.failAndBacktrack($0);
      $2 = false;
    } else {
      state.expected('abc');
    }
    state.predicate = $1;
    if ($2) {
      return const (null,);
    } else {
      return null;
    }
  }

  /// **NotDigits**
  ///
  ///```text
  /// `int`
  /// NotDigits =>
  ///   $ = [^0-9]
  ///```
  (int,)? parseNotDigits(State state) {
    final $0 = state.peek();
    if (!($0 == 0 || $0 >= 48 && $0 <= 57)) {
      state.position += state.charSize($0);
      int $ = $0;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **NotDigitsVoid**
  ///
  ///```text
  /// `int`
  /// NotDigitsVoid =>
  ///   [^0-9]
  ///```
  (int,)? parseNotDigitsVoid(State state) {
    final $0 = state.peek();
    if (!($0 == 0 || $0 >= 48 && $0 <= 57)) {
      state.position += state.charSize($0);
      return ($0,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **OneOrMore**
  ///
  ///```text
  /// `List<String>`
  /// OneOrMore =>
  ///   $ = 'abc'+
  ///```
  (List<String>,)? parseOneOrMore(State state) {
    final $1 = <String>[];
    while (true) {
      final $0 = state.position;
      if (state.peek() == 97 && state.startsWith('abc', state.position)) {
        state.consume('abc', $0);
        $1.add('abc');
      } else {
        state.expected('abc');
        break;
      }
    }
    if ($1.isNotEmpty) {
      List<String> $ = $1;
      return ($,);
    } else {
      return null;
    }
  }

  /// **OneOrMoreVoid**
  ///
  ///```text
  /// `List<String>`
  /// OneOrMoreVoid =>
  ///   'abc'+
  ///```
  (List<String>,)? parseOneOrMoreVoid(State state) {
    final $1 = <String>[];
    while (true) {
      final $0 = state.position;
      if (state.peek() == 97 && state.startsWith('abc', state.position)) {
        state.consume('abc', $0);
        $1.add('abc');
      } else {
        state.expected('abc');
        break;
      }
    }
    if ($1.isNotEmpty) {
      return ($1,);
    } else {
      return null;
    }
  }

  /// **Optional**
  ///
  ///```text
  /// `String?`
  /// Optional =>
  ///   $ = 'abc'?
  ///```
  String? parseOptional(State state) {
    final $0 = state.position;
    String? $1;
    if (state.peek() == 97 && state.startsWith('abc', state.position)) {
      state.consume('abc', $0);
      $1 = 'abc';
    } else {
      state.expected('abc');
    }
    String? $ = $1;
    return $;
  }

  /// **OptionalVoid**
  ///
  ///```text
  /// `String?`
  /// OptionalVoid =>
  ///   'abc'?
  ///```
  String? parseOptionalVoid(State state) {
    final $0 = state.position;
    String? $1;
    if (state.peek() == 97 && state.startsWith('abc', state.position)) {
      state.consume('abc', $0);
      $1 = 'abc';
    } else {
      state.expected('abc');
    }
    return $1;
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
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 97) {
      state.consume('a', $1);
      String $ = 'a';
      $0 = ($,);
    } else {
      state.expected('a');
      if (state.peek() == 98) {
        state.consume('b', $1);
        String $ = 'b';
        $0 = ($,);
      } else {
        state.expected('b');
        if (state.peek() == 99) {
          state.consume('c', $1);
          String $ = 'c';
          $0 = ($,);
        } else {
          state.expected('c');
        }
      }
    }
    if ($0 != null) {
      String $ = $0.$1;
      return ($,);
    } else {
      return null;
    }
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
    final $1 = state.position;
    (String,)? $0;
    if (state.peek() == 97) {
      state.consume('a', $1);
      String $ = 'a';
      $0 = ($,);
    } else {
      state.expected('a');
      if (state.peek() == 98) {
        state.consume('b', $1);
        String $ = 'b';
        $0 = ($,);
      } else {
        state.expected('b');
        if (state.peek() == 99) {
          state.consume('c', $1);
          String $ = 'c';
          $0 = ($,);
        } else {
          state.expected('c');
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
    final $0 = state.position;
    String? $2;
    final $1 = state.peek();
    if ($1 >= 65 ? $1 <= 90 || $1 >= 97 && $1 <= 122 : $1 >= 48 && $1 <= 57) {
      state.position += state.charSize($1);
      $2 = state.substring($0, state.position);
      String $ = $2;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **RangesVoid**
  ///
  ///```text
  /// `String`
  /// RangesVoid =>
  ///   <[0-9A-Za-z]>
  ///```
  (String,)? parseRangesVoid(State state) {
    final $0 = state.position;
    String? $2;
    final $1 = state.peek();
    if ($1 >= 65 ? $1 <= 90 || $1 >= 97 && $1 <= 122 : $1 >= 48 && $1 <= 57) {
      state.position += state.charSize($1);
      $2 = state.substring($0, state.position);
      return ($2,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **TakeWhile**
  ///
  ///```text
  /// `String`
  /// TakeWhile =>
  ///   $ = <[a]*>
  ///```
  String parseTakeWhile(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    $1 = state.substring($0, state.position);
    String $ = $1;
    return $;
  }

  /// **TakeWhile1**
  ///
  ///```text
  /// `String`
  /// TakeWhile1 =>
  ///   $ = <[a]+>
  ///```
  (String,)? parseTakeWhile1(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      $1 = state.substring($0, state.position);
      String $ = $1;
      return ($,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **TakeWhile1Void**
  ///
  ///```text
  /// `String`
  /// TakeWhile1Void =>
  ///   <[a]+>
  ///```
  (String,)? parseTakeWhile1Void(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    if ($0 != state.position) {
      $1 = state.substring($0, state.position);
      return ($1,);
    } else {
      state.fail();
      return null;
    }
  }

  /// **TakeWhileVoid**
  ///
  ///```text
  /// `String`
  /// TakeWhileVoid =>
  ///   <[a]*>
  ///```
  String parseTakeWhileVoid(State state) {
    final $0 = state.position;
    String? $1;
    for (var c = state.peek(); c == 97;) {
      state.position += state.charSize(c);
      c = state.peek();
    }
    $1 = state.substring($0, state.position);
    return $1;
  }

  /// **ZeroOrMore**
  ///
  ///```text
  /// `List<String>`
  /// ZeroOrMore =>
  ///   $ = 'abc'*
  ///```
  List<String> parseZeroOrMore(State state) {
    final $1 = <String>[];
    while (true) {
      final $0 = state.position;
      if (state.peek() == 97 && state.startsWith('abc', state.position)) {
        state.consume('abc', $0);
        $1.add('abc');
      } else {
        state.expected('abc');
        break;
      }
    }
    List<String> $ = $1;
    return $;
  }

  /// **ZeroOrMoreVoid**
  ///
  ///```text
  /// `List<String>`
  /// ZeroOrMoreVoid =>
  ///   'abc'*
  ///```
  List<String> parseZeroOrMoreVoid(State state) {
    final $1 = <String>[];
    while (true) {
      final $0 = state.position;
      if (state.peek() == 97 && state.startsWith('abc', state.position)) {
        state.consume('abc', $0);
        $1.add('abc');
      } else {
        state.expected('abc');
        break;
      }
    }
    return $1;
  }
}

class State {
  /// Intended for internal use only.
  static const flagUseStart = 1;

  /// Intended for internal use only.
  static const flagUseEnd = 2;

  /// Intended for internal use only.
  static const flagExpected = 4;

  /// Intended for internal use only.
  static const flagUnexpected = 8;

  /// The position of the parsing failure.
  int failure = 0;

  /// The length of the input data.
  final int length;

  /// Intended for internal use only.
  int nesting = -1;

  /// Intended for internal use only.
  bool predicate = false;

  /// Current parsing position.
  int position = 0;

  /// Current parsing position.
  Object? unused;

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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int charSize(int char) => char > 0xffff ? 2 : 1;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void consume(String literal, int start) {
    position += strlen(literal);
    if (predicate && nesting < position) {
      error(literal, start, position, flagUnexpected);
    }
  }

  /// Intended for internal use only.
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
  void expected(String literal) {
    if (nesting < position && !predicate) {
      error(literal, position, position, flagExpected);
    }

    fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void fail([String? name]) {
    failure < position ? failure = position : null;
    if (_farthestFailure < position) {
      _farthestFailure = position;
      _farthestFailureLength = 0;
    }

    if (name != null && nesting < position) {
      error(name, position, position, flagExpected);
    }
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void failAndBacktrack(int position) {
    fail();
    final length = this.position - position;
    _farthestFailureLength < length ? _farthestFailureLength = length : null;
    this.position = position;
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void onFailure(String name, int start, int nesting, int failure) {
    if (failure == position && nesting < position && !predicate) {
      error(name, position, position, flagExpected);
    }

    this.nesting = nesting;
    this.failure < failure ? this.failure = failure : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void onSuccess(String name, int start, int nesting) {
    if (predicate && nesting < start) {
      error(name, start, position, flagUnexpected);
    }

    this.nesting = nesting;
  }

  /// Intended for internal use only.
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

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool startsWith(String string, int position) =>
      _input.startsWith(string, position);

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int strlen(String string) => string.length;

  /// Intended for internal use only.
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

    var line = substring(position, position + rest);
    line = line.replaceAll('\n', r'\n');
    return '|$position|$line';
  }
}

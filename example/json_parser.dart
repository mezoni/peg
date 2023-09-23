class JsonParser {
  String _escape(int charCode) {
    switch (charCode) {
      case 0x22:
        return '"';
      case 0x2f:
        return '/';
      case 0x5c:
        return '\\';
      case 0x62:
        return '\b';
      case 0x66:
        return '\f';
      case 0x6e:
        return '\n';
      case 0x72:
        return '\r';
      case 0x74:
        return '\t';
      default:
        throw StateError('Unable to escape charCode: $charCode');
    }
  }

  void beginEvent(JsonParserEvent event) {
    return;
  }

  R? endEvent<R>(JsonParserEvent event, R? result, bool ok) {
    return result;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  void fastParseSpaces(State<StringReader> state) {
    // [ \n\r\t]*
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $1 = state.input.readChar(state.pos);
        state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
        if (state.ok) {
          state.pos += state.input.count;
        }
      }
      if (!state.ok) {
        state.fail(const ErrorUnexpectedCharacter());
      }
      if (!state.ok) {
        state.ok = true;
        break;
      }
    }
  }

  /// @event
  /// List<Object?>
  /// Array =
  ///   OpenBracket v:Values CloseBracket
  ///   ;
  List<Object?>? parseArray(State<StringReader> state) {
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $0;
    // OpenBracket v:Values CloseBracket
    final $1 = state.pos;
    // v:'[' Spaces
    final $3 = state.pos;
    const $4 = '[';
    matchLiteral1(state, 91, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (state.ok) {
      List<Object?>? $2;
      $2 = parseValues(state);
      if (state.ok) {
        // v:']' Spaces
        final $5 = state.pos;
        const $6 = ']';
        matchLiteral1(state, 93, $6, const ErrorExpectedTags([$6]));
        if (state.ok) {
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $5;
        }
        if (state.ok) {
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    $0 = endEvent<List<Object?>>(JsonParserEvent.arrayEvent, $0, state.ok);
    return $0;
  }

  /// HexNumber =
  ///   @errorHandler(HexNumberRaw)
  ///   ;
  int? parseHexNumber(State<StringReader> state) {
    int? $0;
    // @errorHandler(HexNumberRaw)
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // HexNumberRaw
    // v:$([0-9A-Za-z]{4,4})
    String? $6;
    final $7 = state.pos;
    // [0-9A-Za-z]{4,4}
    final $10 = state.pos;
    var $11 = 0;
    while ($11 < 4) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $12 = state.input.readChar(state.pos);
        state.ok = $12 <= 90
            ? $12 >= 48 && $12 <= 57 || $12 >= 65
            : $12 >= 97 && $12 <= 122;
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
      $11++;
    }
    state.ok = $11 == 4;
    if (!state.ok) {
      state.pos = $10;
    }
    if (state.ok) {
      $6 = state.input.substring($7, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $6!;
      $$ = int.parse(v, radix: 16);
      $0 = $$;
    }
    if (state.ok) {
      $0 = $0;
    }
    if (!state.ok && state._canHandleError($2, $3)) {
      void replaceLastErrors(List<ParseError> errors) {
        state._replaceLastErrors($2, $3, errors);
      }

      final errors = [
        ErrorMessage(state.pos - state.failPos, 'Expected 4 digit hex number')
      ];
      replaceLastErrors(errors);
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  /// @event
  /// MapEntry<String, Object?>
  /// KeyValue =
  ///   k:Key Colon v:Value
  ///   ;
  MapEntry<String, Object?>? parseKeyValue(State<StringReader> state) {
    beginEvent(JsonParserEvent.keyValueEvent);
    MapEntry<String, Object?>? $0;
    // k:Key Colon v:Value
    final $1 = state.pos;
    String? $2;
    beginEvent(JsonParserEvent.keyEvent);
    // String
    $2 = parseString(state);
    if (state.ok) {
      $2 = $2;
    }
    $2 = endEvent<String>(JsonParserEvent.keyEvent, $2, state.ok);
    if (state.ok) {
      // v:':' Spaces
      final $5 = state.pos;
      const $6 = ':';
      matchLiteral1(state, 58, $6, const ErrorExpectedTags([$6]));
      if (state.ok) {
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.pos = $5;
      }
      if (state.ok) {
        Object? $3;
        $3 = parseValue(state);
        if (state.ok) {
          MapEntry<String, Object?>? $$;
          final k = $2!;
          final v = $3;
          $$ = MapEntry(k, v);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    $0 = endEvent<MapEntry<String, Object?>>(
        JsonParserEvent.keyValueEvent, $0, state.ok);
    return $0;
  }

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma)
  ///   ;
  List<MapEntry<String, Object?>>? parseKeyValues(State<StringReader> state) {
    List<MapEntry<String, Object?>>? $0;
    // @sepBy(KeyValue, Comma)
    MapEntry<String, Object?>? $4;
    // KeyValue
    $4 = parseKeyValue(state);
    if (state.ok) {
      $4 = $4;
    }
    if (!state.ok) {
      state.ok = true;
      $0 = const [];
    } else {
      final $3 = [$4!];
      while (true) {
        final $2 = state.pos;
        // Comma
        // v:',' Spaces
        final $7 = state.pos;
        const $8 = ',';
        matchLiteral1(state, 44, $8, const ErrorExpectedTags([$8]));
        if (state.ok) {
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $7;
        }
        if (!state.ok) {
          state.ok = true;
          $0 = $3;
          break;
        }
        // KeyValue
        $4 = parseKeyValue(state);
        if (state.ok) {
          $4 = $4;
        }
        if (!state.ok) {
          state.pos = $2;
          break;
        }
        $3.add($4!);
      }
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  /// num
  /// Number =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces
  ///   ;
  num? parseNumber(State<StringReader> state) {
    num? $0;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
    final $4 = state.pos;
    matchChar(state, 45, const ErrorUnexpectedCharacter(45));
    state.ok = true;
    if (state.ok) {
      // [0]
      matchChar(state, 48, const ErrorUnexpectedCharacter(48));
      if (!state.ok) {
        // [1-9] [0-9]*
        final $5 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $6 = state.input.readChar(state.pos);
          state.ok = $6 >= 49 && $6 <= 57;
          if (state.ok) {
            state.pos += state.input.count;
          }
        }
        if (!state.ok) {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (state.ok) {
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $7 = state.input.readChar(state.pos);
              state.ok = $7 >= 48 && $7 <= 57;
              if (state.ok) {
                state.pos += state.input.count;
              }
            }
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
            if (!state.ok) {
              state.ok = true;
              break;
            }
          }
        }
        if (!state.ok) {
          state.pos = $5;
        }
      }
      if (state.ok) {
        // [.] [0-9]+
        final $9 = state.pos;
        matchChar(state, 46, const ErrorUnexpectedCharacter(46));
        if (state.ok) {
          var $10 = false;
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $11 = state.input.readChar(state.pos);
              state.ok = $11 >= 48 && $11 <= 57;
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
            $10 = true;
          }
          state.ok = $10;
        }
        if (!state.ok) {
          state.pos = $9;
        }
        state.ok = true;
        if (state.ok) {
          // [eE] [-+]? [0-9]+
          final $12 = state.pos;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $13 = state.input.readChar(state.pos);
            state.ok = $13 == 69 || $13 == 101;
            if (state.ok) {
              state.pos += state.input.count;
            }
          }
          if (!state.ok) {
            state.fail(const ErrorUnexpectedCharacter());
          }
          if (state.ok) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $14 = state.input.readChar(state.pos);
              state.ok = $14 == 43 || $14 == 45;
              if (state.ok) {
                state.pos += state.input.count;
              }
            }
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
            state.ok = true;
            if (state.ok) {
              var $15 = false;
              while (true) {
                state.ok = state.pos < state.input.length;
                if (state.ok) {
                  final $16 = state.input.readChar(state.pos);
                  state.ok = $16 >= 48 && $16 <= 57;
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
                $15 = true;
              }
              state.ok = $15;
            }
          }
          if (!state.ok) {
            state.pos = $12;
          }
          state.ok = true;
        }
      }
    }
    if (!state.ok) {
      state.pos = $4;
    }
    if (state.ok) {
      $2 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      fastParseSpaces(state);
      if (state.ok) {
        num? $$;
        final v = $2!;
        $$ = num.parse(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// @event
  /// Map<String, Object?>
  /// Object =
  ///   OpenBrace kv:KeyValues CloseBrace
  ///   ;
  Map<String, Object?>? parseObject(State<StringReader> state) {
    beginEvent(JsonParserEvent.objectEvent);
    Map<String, Object?>? $0;
    // OpenBrace kv:KeyValues CloseBrace
    final $1 = state.pos;
    // v:'{' Spaces
    final $3 = state.pos;
    const $4 = '{';
    matchLiteral1(state, 123, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (state.ok) {
      List<MapEntry<String, Object?>>? $2;
      $2 = parseKeyValues(state);
      if (state.ok) {
        // v:'}' Spaces
        final $5 = state.pos;
        const $6 = '}';
        matchLiteral1(state, 125, $6, const ErrorExpectedTags([$6]));
        if (state.ok) {
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $5;
        }
        if (state.ok) {
          Map<String, Object?>? $$;
          final kv = $2!;
          $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    $0 = endEvent<Map<String, Object?>>(
        JsonParserEvent.objectEvent, $0, state.ok);
    return $0;
  }

  /// Start =
  ///   Spaces v:Value !.
  ///   ;
  Object? parseStart(State<StringReader> state) {
    Object? $0;
    // Spaces v:Value !.
    final $1 = state.pos;
    fastParseSpaces(state);
    if (state.ok) {
      Object? $2;
      $2 = parseValue(state);
      if (state.ok) {
        state.ok = state.pos >= state.input.length;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
        if (state.ok) {
          $0 = $2;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// String
  /// String =
  ///   '"' v:StringChars* Quote
  ///   ;
  String? parseString(State<StringReader> state) {
    String? $0;
    // '"' v:StringChars* Quote
    final $1 = state.pos;
    const $3 = '"';
    matchLiteral1(state, 34, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      List<String>? $2;
      final $4 = <String>[];
      while (true) {
        String? $5;
        // $[ -!#-[\]-\u{10ffff}]+
        final $18 = state.pos;
        var $19 = false;
        while (true) {
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $20 = state.input.readChar(state.pos);
            state.ok = $20 <= 91
                ? $20 >= 32 && $20 <= 33 || $20 >= 35
                : $20 >= 93 && $20 <= 1114111;
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
          $19 = true;
        }
        state.ok = $19;
        if (state.ok) {
          $5 = state.input.substring($18, state.pos);
        }
        if (state.ok) {
          $5 = $5;
        }
        if (!state.ok) {
          // '\\' v:(EscapeChar / EscapeHex)
          final $6 = state.pos;
          const $8 = '\\';
          matchLiteral1(state, 92, $8, const ErrorExpectedTags([$8]));
          if (state.ok) {
            String? $7;
            // EscapeChar
            // c:["/bfnrt\\]
            int? $15;
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $16 = state.input.readChar(state.pos);
              state.ok = $16 == 98 ||
                  ($16 < 98
                      ? $16 == 47 || $16 == 34 || $16 == 92
                      : $16 == 110 ||
                          ($16 < 110 ? $16 == 102 : $16 == 114 || $16 == 116));
              if (state.ok) {
                state.pos += state.input.count;
                $15 = $16;
              }
            }
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
            if (state.ok) {
              String? $$;
              final c = $15!;
              $$ = _escape(c);
              $7 = $$;
            }
            if (state.ok) {
              $7 = $7;
            }
            if (!state.ok) {
              // EscapeHex
              // 'u' v:HexNumber
              final $10 = state.pos;
              const $12 = 'u';
              matchLiteral1(state, 117, $12, const ErrorExpectedTags([$12]));
              if (state.ok) {
                int? $11;
                $11 = parseHexNumber(state);
                if (state.ok) {
                  String? $$;
                  final v = $11!;
                  $$ = String.fromCharCode(v);
                  $7 = $$;
                }
              }
              if (!state.ok) {
                state.pos = $10;
              }
              if (state.ok) {
                $7 = $7;
              }
            }
            if (state.ok) {
              $5 = $7;
            }
          }
          if (!state.ok) {
            state.pos = $6;
          }
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        // v:'"' Spaces
        final $21 = state.pos;
        const $22 = '"';
        matchLiteral1(state, 34, $22, const ErrorExpectedTags([$22]));
        if (state.ok) {
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $21;
        }
        if (state.ok) {
          String? $$;
          final v = $2!;
          $$ = v.join();
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// @event
  /// Value =
  ///     Array
  ///   / String
  ///   / Object
  ///   / Array
  ///   / Number
  ///   / True
  ///   / False
  ///   / Null
  ///   ;
  Object? parseValue(State<StringReader> state) {
    beginEvent(JsonParserEvent.valueEvent);
    Object? $0;
    // Array
    $0 = parseArray(state);
    if (state.ok) {
      $0 = $0;
    }
    if (!state.ok) {
      // String
      $0 = parseString(state);
      if (state.ok) {
        $0 = $0;
      }
      if (!state.ok) {
        // Object
        $0 = parseObject(state);
        if (state.ok) {
          $0 = $0;
        }
        if (!state.ok) {
          // Array
          $0 = parseArray(state);
          if (state.ok) {
            $0 = $0;
          }
          if (!state.ok) {
            // Number
            $0 = parseNumber(state);
            if (state.ok) {
              $0 = $0;
            }
            if (!state.ok) {
              // True
              // 'true' Spaces
              final $8 = state.pos;
              const $9 = 'true';
              matchLiteral(state, $9, const ErrorExpectedTags([$9]));
              if (state.ok) {
                fastParseSpaces(state);
                if (state.ok) {
                  bool? $$;
                  $$ = true;
                  $0 = $$;
                }
              }
              if (!state.ok) {
                state.pos = $8;
              }
              if (state.ok) {
                $0 = $0;
              }
              if (!state.ok) {
                // False
                // 'false' Spaces
                final $5 = state.pos;
                const $6 = 'false';
                matchLiteral(state, $6, const ErrorExpectedTags([$6]));
                if (state.ok) {
                  fastParseSpaces(state);
                  if (state.ok) {
                    bool? $$;
                    $$ = false;
                    $0 = $$;
                  }
                }
                if (!state.ok) {
                  state.pos = $5;
                }
                if (state.ok) {
                  $0 = $0;
                }
                if (!state.ok) {
                  // Null
                  // 'null' Spaces
                  final $2 = state.pos;
                  const $3 = 'null';
                  matchLiteral(state, $3, const ErrorExpectedTags([$3]));
                  if (state.ok) {
                    fastParseSpaces(state);
                    if (state.ok) {
                      Object? $$;
                      $$ = null;
                      $0 = $$;
                    }
                  }
                  if (!state.ok) {
                    state.pos = $2;
                  }
                  if (state.ok) {
                    $0 = $0;
                  }
                }
              }
            }
          }
        }
      }
    }
    $0 = endEvent<Object?>(JsonParserEvent.valueEvent, $0, state.ok);
    return $0;
  }

  /// Values =
  ///   @sepBy(Value, Comma)
  ///   ;
  List<Object?>? parseValues(State<StringReader> state) {
    List<Object?>? $0;
    // @sepBy(Value, Comma)
    Object? $4;
    // Value
    $4 = parseValue(state);
    if (state.ok) {
      $4 = $4;
    }
    if (!state.ok) {
      state.ok = true;
      $0 = const [];
    } else {
      final $3 = [$4];
      while (true) {
        final $2 = state.pos;
        // Comma
        // v:',' Spaces
        final $7 = state.pos;
        const $8 = ',';
        matchLiteral1(state, 44, $8, const ErrorExpectedTags([$8]));
        if (state.ok) {
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $7;
        }
        if (!state.ok) {
          state.ok = true;
          $0 = $3;
          break;
        }
        // Value
        $4 = parseValue(state);
        if (state.ok) {
          $4 = $4;
        }
        if (!state.ok) {
          state.pos = $2;
          break;
        }
        $3.add($4);
      }
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  @pragma('vm:prefer-inline')
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
}

enum JsonParserEvent {
  arrayEvent,
  keyEvent,
  keyValueEvent,
  objectEvent,
  valueEvent
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

  if (result.ok) {
    return;
  }

  errorMessage ??= errorMessage;
  final message = result.errorMessage;
  throw FormatException(message);
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
      message = _errorMessage(input.source, offset, normalized);
    } else {
      message = _errorMessageWithoutSource(input, offset, normalized);
    }
  } else if (input is String) {
    message = _errorMessage(input, offset, normalized);
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

String _errorMessage(String source, int offset, List<ErrorMessage> errors) {
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
    var row = 1;
    var lineStart = 0, next = 0, pos = 0;
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
    sb.writeln('line $row, column $column: $message');
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
  } else if (input case final ChunkedData<StringReader> input) {
    if (input.isClosed && offset == input.start + input.data.length) {
      result.add(const ErrorUnexpectedEndOfInput());
      result.removeWhere((e) => e is ErrorUnexpectedCharacter);
    }
  }

  final foundTags =
      result.whereType<ErrorExpectedTag>().map((e) => e.tag).toList();
  if (foundTags.isNotEmpty) {
    result.removeWhere((e) => e is ErrorExpectedTag);
    result.add(ErrorExpectedTags(foundTags));
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

abstract interface class ByteReader {
  int get length;

  int readByte(int offset);
}

abstract class ChunkedData<T> implements Sink<T> {
  void Function()? handler;

  bool _isClosed = false;

  int buffering = 0;

  T data;

  int end = 0;

  bool sleep = false;

  int start = 0;

  final T _empty;

  ChunkedData(T empty)
      : data = empty,
        _empty = empty;

  bool get isClosed => _isClosed;

  @override
  void add(T data) {
    if (_isClosed) {
      throw StateError('Chunked data sink already closed');
    }

    if (buffering != 0) {
      this.data = join(this.data, data);
    } else {
      start = end;
      this.data = data;
    }

    end = start + getLength(this.data);
    sleep = false;
    while (!sleep) {
      final h = handler;
      handler = null;
      if (h == null) {
        break;
      }

      h();
    }

    if (buffering == 0) {
      //
    }
  }

  @override
  void close() {
    if (_isClosed) {
      return;
    }

    _isClosed = true;
    sleep = false;
    while (!sleep) {
      final h = handler;
      handler = null;
      if (h == null) {
        break;
      }

      h();
    }

    if (buffering != 0) {
      throw StateError('On closing, an incomplete buffering was detected');
    }

    final length = getLength(data);
    if (length != 0) {
      data = _empty;
    }
  }

  int getLength(T data);

  T join(T data1, T data2);
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

class ErrorExpectedEndOfInput extends ParseError {
  static const message = 'Expected an end of input';

  const ErrorExpectedEndOfInput();

  @override
  ErrorMessage getErrorMessage(Object? input, offset) {
    return const ErrorMessage(0, ErrorExpectedEndOfInput.message);
  }
}

class ErrorExpectedIntegerValue extends ParseError {
  static const message = 'Expected an integer value {0}';

  final int size;

  final int value;

  const ErrorExpectedIntegerValue(this.size, this.value);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    var argument = value.toRadixString(16);
    if (const [8, 16, 24, 32, 40, 48, 56, 64].contains(size)) {
      argument = argument.padLeft(size >> 2, '0');
    }

    argument = '0x$argument';
    if (value >= 0 && value <= 0x10ffff) {
      argument = '$argument (${ParseError.escape(value)})';
    }

    return ErrorMessage(0, ErrorExpectedIntegerValue.message, [argument]);
  }
}

class ErrorExpectedTag extends ParseError {
  static const message = 'Expected: {0}';

  final String tag;

  const ErrorExpectedTag(this.tag);

  @override
  ErrorMessage getErrorMessage(Object? input, int? offset) {
    return const ErrorMessage(0, ErrorExpectedTag.message);
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
    }

    return super.toString();
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  bool _canHandleError(int failPos, int errorCount) {
    return failPos == this.failPos
        ? errorCount < this.errorCount
        : failPos < this.failPos;
  }

  @pragma('vm:prefer-inline')
  // ignore: unused_element
  void _replaceLastErrors(
      int failPos, int errorCount, List<ParseError> errors) {
    if (this.failPos == failPos) {
      this.errorCount = errorCount;
    } else if (this.failPos > failPos) {
      this.errorCount = 0;
    }
    final length = errors.length;
    if (length == 0) {
      failAt(this.failPos, const ErrorUnknownError());
    } else if (length == 1) {
      failAt(this.failPos, errors[0]);
    } else {
      failAllAt(this.failPos, errors);
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

class StringReaderChunkedData extends ChunkedData<StringReader> {
  StringReaderChunkedData() : super(StringReader(''));

  @override
  int getLength(StringReader data) => data.length;

  @override
  StringReader join(StringReader data1, StringReader data2) => data1.length != 0
      ? StringReader('${data1.source}${data2.source}')
      : data2;
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
  int readChar(int offset) {
    final result = source.runeAt(offset);
    count = result > 0xffff ? 2 : 1;
    return result;
  }

  @override
  @pragma('vm:prefer-inline')
  bool startsWith(String string, [int index = 0]) {
    if (source.startsWith(string, index)) {
      count = string.length;
      return true;
    }

    return false;
  }

  @override
  @pragma('vm:prefer-inline')
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

extension StringExt on String {
  @pragma('vm:prefer-inline')
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

void main(List<String> args) {
  const source = '""';
  final parser = JsonParser();
  final result = parseString(parser.parseStart, source);
  print(result);
}

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
    while (state.pos < state.input.length) {
      final $1 = state.input.readChar(state.pos);
      state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
      if (!state.ok) {
        break;
      }
      state.pos += state.input.count;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // [ \n\r\t]*
            //  // [ \n\r\t]*
            state.input.beginBuffering();
            //  // [ \n\r\t]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $3 = state.input;
            if (state.pos + 1 >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $2;
              return;
            }

            state.ok = state.pos < $3.end;
            if (state.pos >= $3.start) {
              if (state.ok) {
                final c = $3.data.runeAt(state.pos - $3.start);
                state.ok = c == 13 || c >= 9 && c <= 10 || c == 32;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $3.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 2;
              break;
            }
            $1 = 0;
            break;
          case 2:
            state.ok = true;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// @event
  /// Array =
  ///   OpenBracket v:Values CloseBracket
  ///   ;
  List<Object?>? parseArray(State<StringReader> state) {
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $0;
    // OpenBracket v:Values CloseBracket
    final $1 = state.pos;
    // @inline OpenBracket = v:'[' Spaces ;
    // v:'[' Spaces
    final $3 = state.pos;
    const $4 = '[';
    matchLiteral1(state, 91, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (state.ok) {
      List<Object?>? $2;
      // Values
      $2 = parseValues(state);
      if (state.ok) {
        // @inline CloseBracket = v:']' Spaces ;
        // v:']' Spaces
        final $5 = state.pos;
        const $6 = ']';
        matchLiteral1(state, 93, $6, const ErrorExpectedTags([$6]));
        if (state.ok) {
          // Spaces
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

  /// @event
  /// Array =
  ///   OpenBracket v:Values CloseBracket
  ///   ;
  AsyncResult<List<Object?>> parseArray$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $3;
    int? $5;
    int? $6;
    AsyncResult<Object?>? $8;
    List<Object?>? $4;
    AsyncResult<List<Object?>>? $10;
    int? $12;
    AsyncResult<Object?>? $14;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // OpenBracket v:Values CloseBracket
            $5 = state.pos;
            //  // OpenBracket
            //  // v:'[' Spaces
            //  // v:'[' Spaces
            $6 = state.pos;
            //  // '['
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            matchLiteral1Async(state, 91, '[', const ErrorExpectedTags(['[']));
            $7.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // Spaces
            $1 = -1;
            $8 = fastParseSpaces$Async(state);
            $1 = 4;
            final $9 = $8!;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 4:
            $8 = null;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Values
            $1 = -1;
            $10 = parseValues$Async(state);
            final $11 = $10!;
            $1 = 5;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 5:
            $4 = $10!.value;
            $10 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            //  // CloseBracket
            //  // v:']' Spaces
            //  // v:']' Spaces
            $12 = state.pos;
            //  // ']'
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $13 = state.input;
            if (state.pos + 1 >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $2;
              return;
            }
            matchLiteral1Async(state, 93, ']', const ErrorExpectedTags([']']));
            $13.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // Spaces
            $1 = -1;
            $14 = fastParseSpaces$Async(state);
            $1 = 8;
            final $15 = $14!;
            if ($15.isComplete) {
              break;
            }
            $15.onComplete = $2;
            return;
          case 8:
            $14 = null;
            if (!state.ok) {
              state.pos = $12!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $3 = endEvent<List<Object?>>(
                JsonParserEvent.arrayEvent, $3, state.ok);
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// String
  /// EscapeChar =
  ///   c:["/bfnrt\\] {}
  ///   ;
  String? parseEscapeChar(State<StringReader> state) {
    String? $0;
    // c:["/bfnrt\\] {}
    int? $2;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $3 = state.input.readChar(state.pos);
      state.ok = $3 == 98 ||
          ($3 < 98
              ? $3 == 47 || $3 == 34 || $3 == 92
              : $3 == 110 || ($3 < 110 ? $3 == 102 : $3 == 114 || $3 == 116));
      if (state.ok) {
        state.pos += state.input.count;
        $2 = $3;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    if (state.ok) {
      String? $$;
      final c = $2!;
      $$ = _escape(c);
      $0 = $$;
    }
    return $0;
  }

  /// String
  /// EscapeChar =
  ///   c:["/bfnrt\\] {}
  ///   ;
  AsyncResult<String> parseEscapeChar$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    int? $4;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // c:["/bfnrt\\] {}
            //  // ["/bfnrt\\]
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            final $5 = state.input;
            if (state.pos + 1 >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $2;
              return;
            }
            $4 = null;
            state.ok = state.pos < $5.end;
            if (state.pos >= $5.start) {
              if (state.ok) {
                final c = $5.data.runeAt(state.pos - $5.start);
                state.ok = c == 98 ||
                    (c < 98
                        ? c == 47 || c == 34 || c == 92
                        : c == 110 ||
                            (c < 110 ? c == 102 : c == 114 || c == 116));
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                  $4 = c;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $5.endBuffering(state.pos);
            if (state.ok) {
              String? $$;
              final c = $4!;
              $$ = _escape(c);
              $3 = $$;
            }
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// String
  /// EscapeHex =
  ///   'u' v:HexNumber {}
  ///   ;
  String? parseEscapeHex(State<StringReader> state) {
    String? $0;
    // 'u' v:HexNumber {}
    final $1 = state.pos;
    const $3 = 'u';
    matchLiteral1(state, 117, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      int? $2;
      // HexNumber
      $2 = parseHexNumber(state);
      if (state.ok) {
        String? $$;
        final v = $2!;
        $$ = String.fromCharCode(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// String
  /// EscapeHex =
  ///   'u' v:HexNumber {}
  ///   ;
  AsyncResult<String> parseEscapeHex$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    int? $5;
    int? $4;
    AsyncResult<int>? $7;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // 'u' v:HexNumber {}
            $5 = state.pos;
            //  // 'u'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            matchLiteral1Async(state, 117, 'u', const ErrorExpectedTags(['u']));
            $6.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // HexNumber
            $1 = -1;
            $7 = parseHexNumber$Async(state);
            final $8 = $7!;
            $1 = 3;
            if ($8.isComplete) {
              break;
            }
            $8.onComplete = $2;
            return;
          case 3:
            $4 = $7!.value;
            $7 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            String? $$;
            final v = $4!;
            $$ = String.fromCharCode(v);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
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
    // int @inline HexNumberRaw = v:$[0-9A-Fa-f]{4,4} {} ;
    // v:$[0-9A-Fa-f]{4,4} {}
    String? $6;
    final $7 = state.pos;
    final $8 = state.pos;
    var $9 = 0;
    while ($9 < 4) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $10 = state.input.readChar(state.pos);
        state.ok = $10 <= 70
            ? $10 >= 48 && $10 <= 57 || $10 >= 65
            : $10 >= 97 && $10 <= 102;
        if (state.ok) {
          state.pos += state.input.count;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $9++;
    }
    state.ok = $9 == 4;
    if (!state.ok) {
      state.pos = $8;
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
    if (!state.ok && state._canHandleError($2, $3)) {
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error = ErrorMessage(
          state.pos - state.failPos, 'Expected 4 digit hex number');
      if (rollbackErrors == true) {
        state._rollbackErrors($2, $3);
        // ignore: unnecessary_null_comparison, prefer_conditional_assignment
        if (error == null) {
          error = const ErrorUnknownError();
        }
      }
      // ignore: unnecessary_null_comparison
      if (error != null) {
        state.failAt(state.failPos, error);
      }
    }
    return $0;
  }

  /// HexNumber =
  ///   @errorHandler(HexNumberRaw)
  ///   ;
  AsyncResult<int> parseHexNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $3;
    int? $4;
    int? $5;
    String? $6;
    int? $7;
    int? $8;
    int? $9;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @errorHandler(HexNumberRaw)
            //  // @errorHandler(HexNumberRaw)
            $4 = state.failPos;
            $5 = state.errorCount;
            //  // HexNumberRaw
            //  // HexNumberRaw
            //  // HexNumberRaw
            //  // v:$[0-9A-Fa-f]{4,4} {}
            //  // v:$[0-9A-Fa-f]{4,4} {}
            //  // $[0-9A-Fa-f]{4,4}
            $7 = state.pos;
            state.input.beginBuffering();
            //  // [0-9A-Fa-f]{4,4}
            $8 = 0;
            $9 = 0;
            state.input.beginBuffering();
            $1 = 1;
            break;
          case 1:
            //  // [0-9A-Fa-f]
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }

            state.ok = state.pos < $11.end;
            if (state.pos >= $11.start) {
              if (state.ok) {
                final c = $11.data.runeAt(state.pos - $11.start);
                state.ok = c <= 70
                    ? c >= 48 && c <= 57 || c >= 65
                    : c >= 97 && c <= 102;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $11.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            var $10 = $9!;
            $10++;
            $9 = $10;
            $1 = $10 < 4 ? 1 : 3;
            break;
          case 3:
            state.ok = $9! == 4;
            if (!state.ok) {
              state.pos = $8!;
            }
            state.input.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $6 = input.data.substring($7! - start, state.pos - start);
            }
            if (state.ok) {
              int? $$;
              final v = $6!;
              $$ = int.parse(v, radix: 16);
              $3 = $$;
            }
            if (!state.ok && state._canHandleError($4!, $5!)) {
              ParseError? error;
              // ignore: prefer_final_locals
              var rollbackErrors = false;
              rollbackErrors = true;
              error = ErrorMessage(
                  state.pos - state.failPos, 'Expected 4 digit hex number');
              if (rollbackErrors == true) {
                state._rollbackErrors($4!, $5!);
                // ignore: unnecessary_null_comparison, prefer_conditional_assignment
                if (error == null) {
                  error = const ErrorUnknownError();
                }
              }
              // ignore: unnecessary_null_comparison
              if (error != null) {
                state.failAt(state.failPos, error);
              }
            }
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// @event
  /// MapEntry<String, Object?>
  /// KeyValue =
  ///   k:Key Colon v:Value {}
  ///   ;
  MapEntry<String, Object?>? parseKeyValue(State<StringReader> state) {
    beginEvent(JsonParserEvent.keyValueEvent);
    MapEntry<String, Object?>? $0;
    // k:Key Colon v:Value {}
    final $1 = state.pos;
    String? $2;
    beginEvent(JsonParserEvent.keyEvent);
    // @inline @event Key = String ;
    // String
    // String
    $2 = parseString(state);
    $2 = endEvent<String>(JsonParserEvent.keyEvent, $2, state.ok);
    if (state.ok) {
      // @inline Colon = v:':' Spaces ;
      // v:':' Spaces
      final $5 = state.pos;
      const $6 = ':';
      matchLiteral1(state, 58, $6, const ErrorExpectedTags([$6]));
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.pos = $5;
      }
      if (state.ok) {
        Object? $3;
        // Value
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

  /// @event
  /// MapEntry<String, Object?>
  /// KeyValue =
  ///   k:Key Colon v:Value {}
  ///   ;
  AsyncResult<MapEntry<String, Object?>> parseKeyValue$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<MapEntry<String, Object?>>();
    beginEvent(JsonParserEvent.keyValueEvent);
    MapEntry<String, Object?>? $3;
    int? $6;
    String? $4;
    AsyncResult<String>? $7;
    int? $9;
    AsyncResult<Object?>? $11;
    Object? $5;
    AsyncResult<Object?>? $13;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // k:Key Colon v:Value {}
            $6 = state.pos;
            //  // Key
            beginEvent(JsonParserEvent.keyEvent);
            //  // String
            //  // String
            //  // String
            $1 = -1;
            $7 = parseString$Async(state);
            final $8 = $7!;
            $1 = 2;
            if ($8.isComplete) {
              break;
            }
            $8.onComplete = $2;
            return;
          case 2:
            $4 = $7!.value;
            $7 = null;
            $4 = endEvent<String>(JsonParserEvent.keyEvent, $4, state.ok);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Colon
            //  // v:':' Spaces
            //  // v:':' Spaces
            $9 = state.pos;
            //  // ':'
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $10 = state.input;
            if (state.pos + 1 >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $2;
              return;
            }
            matchLiteral1Async(state, 58, ':', const ErrorExpectedTags([':']));
            $10.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 3;
              break;
            }
            //  // Spaces
            $1 = -1;
            $11 = fastParseSpaces$Async(state);
            $1 = 5;
            final $12 = $11!;
            if ($12.isComplete) {
              break;
            }
            $12.onComplete = $2;
            return;
          case 5:
            $11 = null;
            if (!state.ok) {
              state.pos = $9!;
              $1 = 3;
              break;
            }
            $1 = 3;
            break;
          case 3:
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            //  // Value
            $1 = -1;
            $13 = parseValue$Async(state);
            final $14 = $13!;
            $1 = 6;
            if ($14.isComplete) {
              break;
            }
            $14.onComplete = $2;
            return;
          case 6:
            $5 = $13!.value;
            $13 = null;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 1;
              break;
            }
            MapEntry<String, Object?>? $$;
            final k = $4!;
            final v = $5;
            $$ = MapEntry(k, v);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $3 = endEvent<MapEntry<String, Object?>>(
                JsonParserEvent.keyValueEvent, $3, state.ok);
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma)
  ///   ;
  List<MapEntry<String, Object?>>? parseKeyValues(State<StringReader> state) {
    List<MapEntry<String, Object?>>? $0;
    // @sepBy(KeyValue, Comma)
    final $3 = <MapEntry<String, Object?>>[];
    MapEntry<String, Object?>? $4;
    // KeyValue
    // KeyValue
    $4 = parseKeyValue(state);
    if (state.ok) {
      $3.add($4!);
      while (true) {
        final $2 = state.pos;
        // Comma
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $7 = state.pos;
        const $8 = ',';
        matchLiteral1(state, 44, $8, const ErrorExpectedTags([$8]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $7;
        }
        if (!state.ok) {
          $0 = $3;
          break;
        }
        // KeyValue
        // KeyValue
        $4 = parseKeyValue(state);
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

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma)
  ///   ;
  AsyncResult<List<MapEntry<String, Object?>>> parseKeyValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<MapEntry<String, Object?>>>();
    List<MapEntry<String, Object?>>? $3;
    MapEntry<String, Object?>? $4;
    AsyncResult<MapEntry<String, Object?>>? $5;
    int? $7;
    int? $8;
    AsyncResult<Object?>? $10;
    AsyncResult<MapEntry<String, Object?>>? $12;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @sepBy(KeyValue, Comma)
            //  // @sepBy(KeyValue, Comma)
            state.input.beginBuffering();
            //  // KeyValue
            //  // KeyValue
            //  // KeyValue
            $1 = -1;
            $5 = parseKeyValue$Async(state);
            final $6 = $5!;
            $1 = 2;
            if ($6.isComplete) {
              break;
            }
            $6.onComplete = $2;
            return;
          case 2:
            $4 = $5!.value;
            $5 = null;
            state.input.endBuffering(state.pos);
            $3 = [];
            if (!state.ok) {
              $1 = 1;
              break;
            }
            $3!.add($4!);
            $1 = 3;
            break;
          case 3:
            $7 = state.pos;
            state.input.beginBuffering();
            //  // Comma
            //  // Comma
            //  // Comma
            //  // v:',' Spaces
            //  // v:',' Spaces
            $8 = state.pos;
            //  // ','
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            matchLiteral1Async(state, 44, ',', const ErrorExpectedTags([',']));
            $9.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 4;
              break;
            }
            //  // Spaces
            $1 = -1;
            $10 = fastParseSpaces$Async(state);
            $1 = 6;
            final $11 = $10!;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 6:
            $10 = null;
            if (!state.ok) {
              state.pos = $8!;
              $1 = 4;
              break;
            }
            $1 = 4;
            break;
          case 4:
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            //  // KeyValue
            //  // KeyValue
            //  // KeyValue
            $1 = -1;
            $12 = parseKeyValue$Async(state);
            final $13 = $12!;
            $1 = 7;
            if ($13.isComplete) {
              break;
            }
            $13.onComplete = $2;
            return;
          case 7:
            $4 = $12!.value;
            $12 = null;
            if (!state.ok) {
              state.pos = $7!;
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            state.input.endBuffering(state.pos);
            $3!.add($4!);
            $1 = 3;
            break;
          case 1:
            state.ok = true;
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// num
  /// Number =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  num? parseNumber(State<StringReader> state) {
    num? $0;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
    final $4 = state.pos;
    matchChar(state, 45, const ErrorExpectedCharacter(45));
    state.ok = true;
    if (state.ok) {
      // [0]
      matchChar(state, 48, const ErrorExpectedCharacter(48));
      if (!state.ok) {
        // [1-9] [0-9]*
        final $6 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $7 = state.input.readChar(state.pos);
          state.ok = $7 >= 49 && $7 <= 57;
          if (state.ok) {
            state.pos += state.input.count;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          while (state.pos < state.input.length) {
            final $8 = state.input.readChar(state.pos);
            state.ok = $8 >= 48 && $8 <= 57;
            if (!state.ok) {
              break;
            }
            state.pos += state.input.count;
          }
          state.fail(const ErrorUnexpectedCharacter());
          state.ok = true;
        }
        if (!state.ok) {
          state.pos = $6;
        }
      }
      if (state.ok) {
        // [.] [0-9]+
        final $9 = state.pos;
        matchChar(state, 46, const ErrorExpectedCharacter(46));
        if (state.ok) {
          var $10 = false;
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $11 = state.input.readChar(state.pos);
              state.ok = $11 >= 48 && $11 <= 57;
              if (state.ok) {
                state.pos += state.input.count;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
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
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $14 = state.input.readChar(state.pos);
              state.ok = $14 == 43 || $14 == 45;
              if (state.ok) {
                state.pos += state.input.count;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
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
                  } else {
                    state.fail(const ErrorUnexpectedCharacter());
                  }
                } else {
                  state.fail(const ErrorUnexpectedEndOfInput());
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
      // Spaces
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

  /// num
  /// Number =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  AsyncResult<num> parseNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $3;
    int? $5;
    String? $4;
    int? $6;
    int? $7;
    int? $10;
    int? $13;
    bool? $15;
    int? $17;
    bool? $20;
    AsyncResult<Object?>? $22;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
            $5 = state.pos;
            //  // $([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
            $6 = state.pos;
            state.input.beginBuffering();
            //  // ([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
            //  // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
            //  // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
            $7 = state.pos;
            //  // [-]?
            state.input.beginBuffering();
            //  // [-]
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $8 = state.input;
            if (state.pos + 1 >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $2;
              return;
            }
            matchCharAsync(state, 45, const ErrorExpectedCharacter(45));
            state.input.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // ([0] / [1-9] [0-9]*)
            //  // [0] / [1-9] [0-9]*
            //  // [0]
            //  // [0]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            matchCharAsync(state, 48, const ErrorExpectedCharacter(48));
            state.input.endBuffering(state.pos);
            if (state.ok) {
              $1 = 4;
              break;
            }
            //  // [1-9] [0-9]*
            $10 = state.pos;
            //  // [1-9]
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }

            state.ok = state.pos < $11.end;
            if (state.pos >= $11.start) {
              if (state.ok) {
                final c = $11.data.runeAt(state.pos - $11.start);
                state.ok = c >= 49 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $11.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // [0-9]*
            $1 = 8;
            break;
          case 8:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 9;
            break;
          case 9:
            final $12 = state.input;
            if (state.pos + 1 >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $2;
              return;
            }

            state.ok = state.pos < $12.end;
            if (state.pos >= $12.start) {
              if (state.ok) {
                final c = $12.data.runeAt(state.pos - $12.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $12.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 10;
              break;
            }
            $1 = 8;
            break;
          case 10:
            state.ok = true;
            if (!state.ok) {
              state.pos = $10!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            $1 = 4;
            break;
          case 4:
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            //  // ([.] [0-9]+)?
            state.input.beginBuffering();
            //  // ([.] [0-9]+)
            //  // [.] [0-9]+
            //  // [.] [0-9]+
            $13 = state.pos;
            //  // [.]
            state.input.beginBuffering();
            $1 = 12;
            break;
          case 12:
            final $14 = state.input;
            if (state.pos + 1 >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $2;
              return;
            }
            matchCharAsync(state, 46, const ErrorExpectedCharacter(46));
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 11;
              break;
            }
            //  // [0-9]+
            $15 = false;
            $1 = 13;
            break;
          case 13:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 14;
            break;
          case 14:
            final $16 = state.input;
            if (state.pos + 1 >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $2;
              return;
            }

            state.ok = state.pos < $16.end;
            if (state.pos >= $16.start) {
              if (state.ok) {
                final c = $16.data.runeAt(state.pos - $16.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $16.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 15;
              break;
            }
            $15 = true;
            $1 = 13;
            break;
          case 15:
            state.ok = $15!;
            if (!state.ok) {
              state.pos = $13!;
              $1 = 11;
              break;
            }
            $1 = 11;
            break;
          case 11:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            //  // ([eE] [-+]? [0-9]+)?
            state.input.beginBuffering();
            //  // ([eE] [-+]? [0-9]+)
            //  // [eE] [-+]? [0-9]+
            //  // [eE] [-+]? [0-9]+
            $17 = state.pos;
            //  // [eE]
            state.input.beginBuffering();
            $1 = 17;
            break;
          case 17:
            final $18 = state.input;
            if (state.pos + 1 >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $2;
              return;
            }

            state.ok = state.pos < $18.end;
            if (state.pos >= $18.start) {
              if (state.ok) {
                final c = $18.data.runeAt(state.pos - $18.start);
                state.ok = c == 69 || c == 101;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $18.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 16;
              break;
            }
            //  // [-+]?
            state.input.beginBuffering();
            //  // [-+]
            state.input.beginBuffering();
            $1 = 18;
            break;
          case 18:
            final $19 = state.input;
            if (state.pos + 1 >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $2;
              return;
            }

            state.ok = state.pos < $19.end;
            if (state.pos >= $19.start) {
              if (state.ok) {
                final c = $19.data.runeAt(state.pos - $19.start);
                state.ok = c == 43 || c == 45;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $19.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $17!;
              $1 = 16;
              break;
            }
            //  // [0-9]+
            $20 = false;
            $1 = 19;
            break;
          case 19:
            state.input.beginBuffering();
            //  // [0-9]
            state.input.beginBuffering();
            $1 = 20;
            break;
          case 20:
            final $21 = state.input;
            if (state.pos + 1 >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $2;
              return;
            }

            state.ok = state.pos < $21.end;
            if (state.pos >= $21.start) {
              if (state.ok) {
                final c = $21.data.runeAt(state.pos - $21.start);
                state.ok = c >= 48 && c <= 57;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $21.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 21;
              break;
            }
            $20 = true;
            $1 = 19;
            break;
          case 21:
            state.ok = $20!;
            if (!state.ok) {
              state.pos = $17!;
              $1 = 16;
              break;
            }
            $1 = 16;
            break;
          case 16:
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.ok = true;
            }
            if (!state.ok) {
              state.pos = $7!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $4 = input.data.substring($6! - start, state.pos - start);
            }
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Spaces
            $1 = -1;
            $22 = fastParseSpaces$Async(state);
            $1 = 22;
            final $23 = $22!;
            if ($23.isComplete) {
              break;
            }
            $23.onComplete = $2;
            return;
          case 22:
            $22 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            num? $$;
            final v = $4!;
            $$ = num.parse(v);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// @event
  /// Map<String, Object?>
  /// Object =
  ///   OpenBrace kv:KeyValues CloseBrace {}
  ///   ;
  Map<String, Object?>? parseObject(State<StringReader> state) {
    beginEvent(JsonParserEvent.objectEvent);
    Map<String, Object?>? $0;
    // OpenBrace kv:KeyValues CloseBrace {}
    final $1 = state.pos;
    // @inline OpenBrace = v:'{' Spaces ;
    // v:'{' Spaces
    final $3 = state.pos;
    const $4 = '{';
    matchLiteral1(state, 123, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $3;
    }
    if (state.ok) {
      List<MapEntry<String, Object?>>? $2;
      // KeyValues
      $2 = parseKeyValues(state);
      if (state.ok) {
        // @inline CloseBrace = v:'}' Spaces ;
        // v:'}' Spaces
        final $5 = state.pos;
        const $6 = '}';
        matchLiteral1(state, 125, $6, const ErrorExpectedTags([$6]));
        if (state.ok) {
          // Spaces
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

  /// @event
  /// Map<String, Object?>
  /// Object =
  ///   OpenBrace kv:KeyValues CloseBrace {}
  ///   ;
  AsyncResult<Map<String, Object?>> parseObject$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Map<String, Object?>>();
    beginEvent(JsonParserEvent.objectEvent);
    Map<String, Object?>? $3;
    int? $5;
    int? $6;
    AsyncResult<Object?>? $8;
    List<MapEntry<String, Object?>>? $4;
    AsyncResult<List<MapEntry<String, Object?>>>? $10;
    int? $12;
    AsyncResult<Object?>? $14;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // OpenBrace kv:KeyValues CloseBrace {}
            $5 = state.pos;
            //  // OpenBrace
            //  // v:'{' Spaces
            //  // v:'{' Spaces
            $6 = state.pos;
            //  // '{'
            state.input.beginBuffering();
            $1 = 3;
            break;
          case 3:
            final $7 = state.input;
            if (state.pos + 1 >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $2;
              return;
            }
            matchLiteral1Async(state, 123, '{', const ErrorExpectedTags(['{']));
            $7.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 2;
              break;
            }
            //  // Spaces
            $1 = -1;
            $8 = fastParseSpaces$Async(state);
            $1 = 4;
            final $9 = $8!;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 4:
            $8 = null;
            if (!state.ok) {
              state.pos = $6!;
              $1 = 2;
              break;
            }
            $1 = 2;
            break;
          case 2:
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // KeyValues
            $1 = -1;
            $10 = parseKeyValues$Async(state);
            final $11 = $10!;
            $1 = 5;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 5:
            $4 = $10!.value;
            $10 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            //  // CloseBrace
            //  // v:'}' Spaces
            //  // v:'}' Spaces
            $12 = state.pos;
            //  // '}'
            state.input.beginBuffering();
            $1 = 7;
            break;
          case 7:
            final $13 = state.input;
            if (state.pos + 1 >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $2;
              return;
            }
            matchLiteral1Async(state, 125, '}', const ErrorExpectedTags(['}']));
            $13.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 6;
              break;
            }
            //  // Spaces
            $1 = -1;
            $14 = fastParseSpaces$Async(state);
            $1 = 8;
            final $15 = $14!;
            if ($15.isComplete) {
              break;
            }
            $15.onComplete = $2;
            return;
          case 8:
            $14 = null;
            if (!state.ok) {
              state.pos = $12!;
              $1 = 6;
              break;
            }
            $1 = 6;
            break;
          case 6:
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            Map<String, Object?>? $$;
            final kv = $4!;
            $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
            $3 = $$;
            $1 = 1;
            break;
          case 1:
            $3 = endEvent<Map<String, Object?>>(
                JsonParserEvent.objectEvent, $3, state.ok);
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Start =
  ///   Spaces v:Value !.
  ///   ;
  Object? parseStart(State<StringReader> state) {
    Object? $0;
    // Spaces v:Value !.
    final $1 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      Object? $2;
      // Value
      $2 = parseValue(state);
      if (state.ok) {
        final $3 = state.pos;
        final $5 = state.input;
        if (state.pos < $5.length) {
          $5.readChar(state.pos);
          state.pos += $5.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $3 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $3;
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

  /// Start =
  ///   Spaces v:Value !.
  ///   ;
  AsyncResult<Object?> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $3;
    int? $5;
    AsyncResult<Object?>? $6;
    Object? $4;
    AsyncResult<Object?>? $8;
    int? $10;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // Spaces v:Value !.
            $5 = state.pos;
            //  // Spaces
            $1 = -1;
            $6 = fastParseSpaces$Async(state);
            $1 = 2;
            final $7 = $6!;
            if ($7.isComplete) {
              break;
            }
            $7.onComplete = $2;
            return;
          case 2:
            $6 = null;
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // Value
            $1 = -1;
            $8 = parseValue$Async(state);
            final $9 = $8!;
            $1 = 3;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 3:
            $4 = $8!.value;
            $8 = null;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            //  // !.
            $10 = state.pos;
            state.input.beginBuffering();
            //  // .
            state.input.beginBuffering();
            $1 = 4;
            break;
          case 4:
            final $11 = state.input;
            if (state.pos + 1 >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $2;
              return;
            }

            if (state.pos >= $11.start) {
              state.ok = state.pos < $11.end;
              if (state.ok) {
                final c = $11.data.runeAt(state.pos - $11.start);
                state.pos += c > 0xffff ? 2 : 1;
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $11.endBuffering(state.pos);
            state.input.endBuffering($10!);
            state.ok = !state.ok;
            if (!state.ok) {
              final length = $10! - state.pos;
              state.fail(switch (length) {
                0 => const ErrorUnexpectedInput(0),
                1 => const ErrorUnexpectedInput(1),
                2 => const ErrorUnexpectedInput(2),
                _ => ErrorUnexpectedInput(length)
              });
            }
            state.pos = $10!;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// String
  /// String =
  ///   '"' v:StringChars Quote
  ///   ;
  String? parseString(State<StringReader> state) {
    String? $0;
    // '"' v:StringChars Quote
    final $1 = state.pos;
    const $3 = '"';
    matchLiteral1(state, 34, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      // @inline StringChars = @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex)) ;
      // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
      final $15 = state.input;
      List<String>? $16;
      String? $17;
      while (state.pos < $15.length) {
        String? $5;
        // $[ -!#-[\]-\u{10ffff}]+
        final $8 = state.pos;
        var $9 = false;
        while (true) {
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $10 = state.input.readChar(state.pos);
            state.ok = $10 <= 91
                ? $10 >= 32 && $10 <= 33 || $10 >= 35
                : $10 >= 93 && $10 <= 1114111;
            if (state.ok) {
              state.pos += state.input.count;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (!state.ok) {
            break;
          }
          $9 = true;
        }
        state.ok = $9;
        if (state.ok) {
          $5 = state.input.substring($8, state.pos);
        }
        if (state.ok) {
          final v = $5!;
          if ($17 == null) {
            $17 = v;
          } else if ($16 == null) {
            $16 = [$17, v];
          } else {
            $16.add(v);
          }
        }
        final pos = state.pos;
        // [\\]
        matchChar(state, 92, const ErrorExpectedCharacter(92));
        if (!state.ok) {
          break;
        }
        String? $6;
        // (EscapeChar / EscapeHex)
        // EscapeChar
        // EscapeChar
        $6 = parseEscapeChar(state);
        if (!state.ok) {
          // EscapeHex
          // EscapeHex
          $6 = parseEscapeHex(state);
        }
        if (!state.ok) {
          state.pos = pos;
          break;
        }
        if ($17 == null) {
          $17 = $6!;
        } else {
          if ($16 == null) {
            $16 = [$17, $6!];
          } else {
            $16.add($6!);
          }
        }
      }
      state.ok = true;
      if ($17 == null) {
        $2 = '';
      } else if ($16 == null) {
        $2 = $17;
      } else {
        $2 = $16.join();
      }
      if (state.ok) {
        // @inline Quote = v:'"' Spaces ;
        // v:'"' Spaces
        final $18 = state.pos;
        const $19 = '"';
        matchLiteral1(state, 34, $19, const ErrorExpectedTags([$19]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $18;
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
  ///   '"' v:StringChars Quote
  ///   ;
  AsyncResult<String> parseString$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $3;
    int? $5;
    String? $4;
    List<String>? $7;
    bool? $8;
    String? $9;
    int? $11;
    bool? $12;
    int? $14;
    String? $10;
    AsyncResult<String>? $16;
    AsyncResult<String>? $18;
    int? $20;
    AsyncResult<Object?>? $22;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // '"' v:StringChars Quote
            $5 = state.pos;
            //  // '"'
            state.input.beginBuffering();
            $1 = 2;
            break;
          case 2:
            final $6 = state.input;
            if (state.pos + 1 >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $2;
              return;
            }
            matchLiteral1Async(state, 34, '"', const ErrorExpectedTags(['"']));
            $6.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 1;
              break;
            }
            //  // StringChars
            //  // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
            //  // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
            //  // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
            $7 = [];
            $1 = 3;
            break;
          case 3:
            state.input.beginBuffering();
            //  // $[ -!#-[\]-\u{10ffff}]+
            //  // $[ -!#-[\]-\u{10ffff}]+
            //  // $[ -!#-[\]-\u{10ffff}]+
            $11 = state.pos;
            state.input.beginBuffering();
            //  // [ -!#-[\]-\u{10ffff}]+
            $12 = false;
            $1 = 4;
            break;
          case 4:
            state.input.beginBuffering();
            //  // [ -!#-[\]-\u{10ffff}]
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $13 = state.input;
            if (state.pos + 1 >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $2;
              return;
            }

            state.ok = state.pos < $13.end;
            if (state.pos >= $13.start) {
              if (state.ok) {
                final c = $13.data.runeAt(state.pos - $13.start);
                state.ok = c <= 91
                    ? c >= 32 && c <= 33 || c >= 35
                    : c >= 93 && c <= 1114111;
                if (state.ok) {
                  state.pos += c > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
            } else {
              state.fail(ErrorBacktracking(state.pos));
            }
            $13.endBuffering(state.pos);
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 6;
              break;
            }
            $12 = true;
            $1 = 4;
            break;
          case 6:
            state.ok = $12!;
            state.input.endBuffering(state.pos);
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $9 = input.data.substring($11! - start, state.pos - start);
            }
            state.input.endBuffering(state.pos);
            $8 = state.ok;
            if (state.ok) {
              $7!.add($9!);
            }
            $1 = 7;
            break;
          case 7:
            $14 = state.pos;
            state.input.beginBuffering();
            //  // [\\]
            //  // [\\]
            //  // [\\]
            state.input.beginBuffering();
            $1 = 9;
            break;
          case 9:
            final $15 = state.input;
            if (state.pos + 1 >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $2;
              return;
            }
            matchCharAsync(state, 92, const ErrorExpectedCharacter(92));
            state.input.endBuffering(state.pos);
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = $8 == true ? 3 : 8;
              break;
            }
            //  // (EscapeChar / EscapeHex)
            //  // (EscapeChar / EscapeHex)
            //  // (EscapeChar / EscapeHex)
            //  // EscapeChar / EscapeHex
            //  // EscapeChar
            //  // EscapeChar
            $1 = -1;
            $16 = parseEscapeChar$Async(state);
            final $17 = $16!;
            $1 = 11;
            if ($17.isComplete) {
              break;
            }
            $17.onComplete = $2;
            return;
          case 11:
            $10 = $16!.value;
            $16 = null;
            if (state.ok) {
              $1 = 10;
              break;
            }
            //  // EscapeHex
            //  // EscapeHex
            $1 = -1;
            $18 = parseEscapeHex$Async(state);
            final $19 = $18!;
            $1 = 12;
            if ($19.isComplete) {
              break;
            }
            $19.onComplete = $2;
            return;
          case 12:
            $10 = $18!.value;
            $18 = null;
            $1 = 10;
            break;
          case 10:
            if (!state.ok) {
              state.pos = $14!;
              state.input.endBuffering(state.pos);
              $1 = 8;
              break;
            }
            state.input.endBuffering(state.pos);
            $7!.add($10!);
            $1 = 3;
            break;
          case 8:
            $4 = ($7)!.join();
            $7 = null;
            state.ok = true;
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            //  // Quote
            //  // v:'"' Spaces
            //  // v:'"' Spaces
            $20 = state.pos;
            //  // '"'
            state.input.beginBuffering();
            $1 = 14;
            break;
          case 14:
            final $21 = state.input;
            if (state.pos + 1 >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $2;
              return;
            }
            matchLiteral1Async(state, 34, '"', const ErrorExpectedTags(['"']));
            $21.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 13;
              break;
            }
            //  // Spaces
            $1 = -1;
            $22 = fastParseSpaces$Async(state);
            $1 = 15;
            final $23 = $22!;
            if ($23.isComplete) {
              break;
            }
            $23.onComplete = $2;
            return;
          case 15:
            $22 = null;
            if (!state.ok) {
              state.pos = $20!;
              $1 = 13;
              break;
            }
            $1 = 13;
            break;
          case 13:
            if (!state.ok) {
              state.pos = $5!;
              $1 = 1;
              break;
            }
            $3 = $4;
            $1 = 1;
            break;
          case 1:
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
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
    // Array
    $0 = parseArray(state);
    if (!state.ok) {
      // String
      // String
      $0 = parseString(state);
      if (!state.ok) {
        // Object
        // Object
        $0 = parseObject(state);
        if (!state.ok) {
          // Array
          // Array
          $0 = parseArray(state);
          if (!state.ok) {
            // Number
            // Number
            $0 = parseNumber(state);
            if (!state.ok) {
              // True
              // bool @inline True = 'true' Spaces {} ;
              // 'true' Spaces {}
              final $7 = state.pos;
              const $8 = 'true';
              matchLiteral(state, $8, const ErrorExpectedTags([$8]));
              if (state.ok) {
                // Spaces
                fastParseSpaces(state);
                if (state.ok) {
                  bool? $$;
                  $$ = true;
                  $0 = $$;
                }
              }
              if (!state.ok) {
                state.pos = $7;
              }
              if (!state.ok) {
                // False
                // bool @inline False = 'false' Spaces {} ;
                // 'false' Spaces {}
                final $10 = state.pos;
                const $11 = 'false';
                matchLiteral(state, $11, const ErrorExpectedTags([$11]));
                if (state.ok) {
                  // Spaces
                  fastParseSpaces(state);
                  if (state.ok) {
                    bool? $$;
                    $$ = false;
                    $0 = $$;
                  }
                }
                if (!state.ok) {
                  state.pos = $10;
                }
                if (!state.ok) {
                  // Null
                  // Object? @inline Null = 'null' Spaces {} ;
                  // 'null' Spaces {}
                  final $13 = state.pos;
                  const $14 = 'null';
                  matchLiteral(state, $14, const ErrorExpectedTags([$14]));
                  if (state.ok) {
                    // Spaces
                    fastParseSpaces(state);
                    if (state.ok) {
                      Object? $$;
                      $$ = null;
                      $0 = $$;
                    }
                  }
                  if (!state.ok) {
                    state.pos = $13;
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
  AsyncResult<Object?> parseValue$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    beginEvent(JsonParserEvent.valueEvent);
    Object? $3;
    AsyncResult<List<Object?>>? $4;
    AsyncResult<String>? $6;
    AsyncResult<Map<String, Object?>>? $8;
    AsyncResult<List<Object?>>? $10;
    AsyncResult<num>? $12;
    int? $14;
    AsyncResult<Object?>? $16;
    int? $18;
    AsyncResult<Object?>? $20;
    int? $22;
    AsyncResult<Object?>? $24;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // Array
            //  // Array
            $1 = -1;
            $4 = parseArray$Async(state);
            final $5 = $4!;
            $1 = 2;
            if ($5.isComplete) {
              break;
            }
            $5.onComplete = $2;
            return;
          case 2:
            $3 = $4!.value;
            $4 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // String
            //  // String
            $1 = -1;
            $6 = parseString$Async(state);
            final $7 = $6!;
            $1 = 3;
            if ($7.isComplete) {
              break;
            }
            $7.onComplete = $2;
            return;
          case 3:
            $3 = $6!.value;
            $6 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // Object
            //  // Object
            $1 = -1;
            $8 = parseObject$Async(state);
            final $9 = $8!;
            $1 = 4;
            if ($9.isComplete) {
              break;
            }
            $9.onComplete = $2;
            return;
          case 4:
            $3 = $8!.value;
            $8 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // Array
            //  // Array
            $1 = -1;
            $10 = parseArray$Async(state);
            final $11 = $10!;
            $1 = 5;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 5:
            $3 = $10!.value;
            $10 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // Number
            //  // Number
            $1 = -1;
            $12 = parseNumber$Async(state);
            final $13 = $12!;
            $1 = 6;
            if ($13.isComplete) {
              break;
            }
            $13.onComplete = $2;
            return;
          case 6:
            $3 = $12!.value;
            $12 = null;
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // True
            //  // True
            //  // 'true' Spaces {}
            //  // 'true' Spaces {}
            $14 = state.pos;
            //  // 'true'
            state.input.beginBuffering();
            $1 = 8;
            break;
          case 8:
            final $15 = state.input;
            if (state.pos + 3 >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $2;
              return;
            }
            const string = 'true';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
            $15.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 7;
              break;
            }
            //  // Spaces
            $1 = -1;
            $16 = fastParseSpaces$Async(state);
            $1 = 9;
            final $17 = $16!;
            if ($17.isComplete) {
              break;
            }
            $17.onComplete = $2;
            return;
          case 9:
            $16 = null;
            if (!state.ok) {
              state.pos = $14!;
              $1 = 7;
              break;
            }
            bool? $$;
            $$ = true;
            $3 = $$;
            $1 = 7;
            break;
          case 7:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // False
            //  // False
            //  // 'false' Spaces {}
            //  // 'false' Spaces {}
            $18 = state.pos;
            //  // 'false'
            state.input.beginBuffering();
            $1 = 11;
            break;
          case 11:
            final $19 = state.input;
            if (state.pos + 4 >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $2;
              return;
            }
            const string = 'false';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
            $19.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 10;
              break;
            }
            //  // Spaces
            $1 = -1;
            $20 = fastParseSpaces$Async(state);
            $1 = 12;
            final $21 = $20!;
            if ($21.isComplete) {
              break;
            }
            $21.onComplete = $2;
            return;
          case 12:
            $20 = null;
            if (!state.ok) {
              state.pos = $18!;
              $1 = 10;
              break;
            }
            bool? $$;
            $$ = false;
            $3 = $$;
            $1 = 10;
            break;
          case 10:
            if (state.ok) {
              $1 = 1;
              break;
            }
            //  // Null
            //  // Null
            //  // 'null' Spaces {}
            //  // 'null' Spaces {}
            $22 = state.pos;
            //  // 'null'
            state.input.beginBuffering();
            $1 = 14;
            break;
          case 14:
            final $23 = state.input;
            if (state.pos + 3 >= $23.end && !$23.isClosed) {
              $23.sleep = true;
              $23.handle = $2;
              return;
            }
            const string = 'null';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
            $23.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 13;
              break;
            }
            //  // Spaces
            $1 = -1;
            $24 = fastParseSpaces$Async(state);
            $1 = 15;
            final $25 = $24!;
            if ($25.isComplete) {
              break;
            }
            $25.onComplete = $2;
            return;
          case 15:
            $24 = null;
            if (!state.ok) {
              state.pos = $22!;
              $1 = 13;
              break;
            }
            Object? $$;
            $$ = null;
            $3 = $$;
            $1 = 13;
            break;
          case 13:
            $1 = 1;
            break;
          case 1:
            $3 = endEvent<Object?>(JsonParserEvent.valueEvent, $3, state.ok);
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
    return $0;
  }

  /// Values =
  ///   @sepBy(Value, Comma)
  ///   ;
  List<Object?>? parseValues(State<StringReader> state) {
    List<Object?>? $0;
    // @sepBy(Value, Comma)
    final $3 = <Object?>[];
    Object? $4;
    // Value
    // Value
    $4 = parseValue(state);
    if (state.ok) {
      $3.add($4);
      while (true) {
        final $2 = state.pos;
        // Comma
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $7 = state.pos;
        const $8 = ',';
        matchLiteral1(state, 44, $8, const ErrorExpectedTags([$8]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $7;
        }
        if (!state.ok) {
          $0 = $3;
          break;
        }
        // Value
        // Value
        $4 = parseValue(state);
        if (!state.ok) {
          state.pos = $2;
          break;
        }
        $3.add($4);
      }
    }
    state.ok = true;
    if (state.ok) {
      $0 = $3;
    }
    return $0;
  }

  /// Values =
  ///   @sepBy(Value, Comma)
  ///   ;
  AsyncResult<List<Object?>> parseValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $3;
    Object? $4;
    AsyncResult<Object?>? $5;
    int? $7;
    int? $8;
    AsyncResult<Object?>? $10;
    AsyncResult<Object?>? $12;
    var $1 = 0;
    void $2() {
      while (true) {
        switch ($1) {
          case 0:
            //  // @sepBy(Value, Comma)
            //  // @sepBy(Value, Comma)
            state.input.beginBuffering();
            //  // Value
            //  // Value
            //  // Value
            $1 = -1;
            $5 = parseValue$Async(state);
            final $6 = $5!;
            $1 = 2;
            if ($6.isComplete) {
              break;
            }
            $6.onComplete = $2;
            return;
          case 2:
            $4 = $5!.value;
            $5 = null;
            state.input.endBuffering(state.pos);
            $3 = [];
            if (!state.ok) {
              $1 = 1;
              break;
            }
            $3!.add($4);
            $1 = 3;
            break;
          case 3:
            $7 = state.pos;
            state.input.beginBuffering();
            //  // Comma
            //  // Comma
            //  // Comma
            //  // v:',' Spaces
            //  // v:',' Spaces
            $8 = state.pos;
            //  // ','
            state.input.beginBuffering();
            $1 = 5;
            break;
          case 5:
            final $9 = state.input;
            if (state.pos + 1 >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $2;
              return;
            }
            matchLiteral1Async(state, 44, ',', const ErrorExpectedTags([',']));
            $9.endBuffering(state.pos);
            if (!state.ok) {
              $1 = 4;
              break;
            }
            //  // Spaces
            $1 = -1;
            $10 = fastParseSpaces$Async(state);
            $1 = 6;
            final $11 = $10!;
            if ($11.isComplete) {
              break;
            }
            $11.onComplete = $2;
            return;
          case 6:
            $10 = null;
            if (!state.ok) {
              state.pos = $8!;
              $1 = 4;
              break;
            }
            $1 = 4;
            break;
          case 4:
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            //  // Value
            //  // Value
            //  // Value
            $1 = -1;
            $12 = parseValue$Async(state);
            final $13 = $12!;
            $1 = 7;
            if ($13.isComplete) {
              break;
            }
            $13.onComplete = $2;
            return;
          case 7:
            $4 = $12!.value;
            $12 = null;
            if (!state.ok) {
              state.pos = $7!;
              state.input.endBuffering(state.pos);
              $1 = 1;
              break;
            }
            state.input.endBuffering(state.pos);
            $3!.add($4);
            $1 = 3;
            break;
          case 1:
            state.ok = true;
            $0.value = $3;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $1 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$1}');
        }
      }
    }

    $2();
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
  int? matchCharAsync(
      State<ChunkedParsingSink> state, int char, ParseError error) {
    final input = state.input;
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(state.pos));
      return null;
    }
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
      state.fail(error);
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
  String? matchLiteral1Async(State<ChunkedParsingSink> state, int char,
      String string, ParseError error) {
    final input = state.input;
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(state.pos));
      return null;
    }
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
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    if (state.pos < input.start) {
      state.fail(ErrorBacktracking(state.pos));
      return null;
    }
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

enum JsonParserEvent {
  arrayEvent,
  keyEvent,
  keyValueEvent,
  objectEvent,
  valueEvent
}

void fastParseString(
    void Function(State<StringReader> state) fastParse, String source) {
  final input = StringReader(source);
  final result = tryParse(fastParse, input);
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

O parseString<O>(O? Function(State<StringReader> state) parse, String source) {
  final input = StringReader(source);
  final result = tryParse(parse, input);
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
  if (input is StringReader) {
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
      key = (ErrorBacktracking, error.position);
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

abstract interface class ByteReader {
  int get length;

  int readByte(int offset);
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
    if (bufferLoad < this.data.length) {
      bufferLoad = this.data.length;
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

    if (_buffering == 0) {
      if (_lastPosition > start) {
        if (_lastPosition == end) {
          this.data = '';
        } else {
          this.data = this.data.substring(_lastPosition - start);
        }

        start = _lastPosition;
      }
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
      if (input is StringReader && input.hasSource) {
        if (offset < input.length) {
          char = input.readChar(offset);
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

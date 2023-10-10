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
  void fastParseSpaces(State<String> state) {
    // [ \n\r\t]*
    final $2 = state.input;
    while (state.pos < $2.length) {
      final $1 = $2.codeUnitAt(state.pos);
      state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
      if (!state.ok) {
        break;
      }
      state.pos++;
    }
    state.fail(const ErrorUnexpectedCharacter());
    state.ok = true;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    Object? $4;
    void $1() {
      // [ \n\r\t]*
      // [ \n\r\t]*
      while (true) {
        $4 ??= state.input.beginBuffering();
        // [ \n\r\t]
        final $3 = state.input;
        if (state.pos >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        final $2 = readChar16Async(state);
        if ($2 >= 0) {
          state.ok = $2 == 13 || $2 >= 9 && $2 <= 10 || $2 == 32;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        }
        state.input.endBuffering(state.pos);
        $4 = null;
        if (!state.ok) {
          break;
        }
      }
      state.ok = true;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// @event
  /// Array =
  ///   OpenBracket v:Values CloseBracket
  ///   ;
  List<Object?>? parseArray(State<String> state) {
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $0;
    // OpenBracket v:Values CloseBracket
    final $1 = state.pos;
    // @inline OpenBracket = v:'[' Spaces ;
    // v:'[' Spaces
    final $3 = state.pos;
    const $4 = '[';
    matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
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
        matchLiteral1(state, $6, const ErrorExpectedTags([$6]));
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
    List<Object?>? $2;
    int? $4;
    int? $5;
    int? $6;
    int? $7;
    Object? $10;
    AsyncResult<Object?>? $11;
    int $13 = 0;
    List<Object?>? $3;
    AsyncResult<List<Object?>>? $14;
    int? $16;
    int? $17;
    Object? $20;
    AsyncResult<Object?>? $21;
    void $1() {
      // OpenBracket v:Values CloseBracket
      if ($13 & 0x20 == 0) {
        $13 |= 0x20;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // OpenBracket
        // v:'[' Spaces
        // v:'[' Spaces
        if ($13 & 0x2 == 0) {
          $13 |= 0x2;
          $6 = 0;
          $7 = state.pos;
        }
        if ($6 == 0) {
          // '['
          $10 ??= state.input.beginBuffering();
          const $9 = '[';
          final $8 = state.input;
          if (state.pos < $8.end || $8.isClosed) {
            matchLiteral1Async(state, $9, const ErrorExpectedTags([$9]));
          } else {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $10 = null;
          $6 = state.ok ? 1 : -1;
        }
        if ($6 == 1) {
          // Spaces
          if ($13 & 0x1 == 0) {
            $13 |= 0x1;
            $11 = fastParseSpaces$Async(state);
            final $12 = $11!;
            if (!$12.isComplete) {
              $12.onComplete = $1;
              return;
            }
          }
          $13 &= ~0x1 & 0xffff;
          $6 = -1;
        }
        if (!state.ok) {
          state.pos = $7!;
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // Values
        if ($13 & 0x4 == 0) {
          $13 |= 0x4;
          $14 = parseValues$Async(state);
          final $15 = $14!;
          if (!$15.isComplete) {
            $15.onComplete = $1;
            return;
          }
        }
        $3 = $14!.value;
        $13 &= ~0x4 & 0xffff;
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
        // CloseBracket
        // v:']' Spaces
        // v:']' Spaces
        if ($13 & 0x10 == 0) {
          $13 |= 0x10;
          $16 = 0;
          $17 = state.pos;
        }
        if ($16 == 0) {
          // ']'
          $20 ??= state.input.beginBuffering();
          const $19 = ']';
          final $18 = state.input;
          if (state.pos < $18.end || $18.isClosed) {
            matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          } else {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $20 = null;
          $16 = state.ok ? 1 : -1;
        }
        if ($16 == 1) {
          // Spaces
          if ($13 & 0x8 == 0) {
            $13 |= 0x8;
            $21 = fastParseSpaces$Async(state);
            final $22 = $21!;
            if (!$22.isComplete) {
              $22.onComplete = $1;
              return;
            }
          }
          $13 &= ~0x8 & 0xffff;
          $16 = -1;
        }
        if (!state.ok) {
          state.pos = $17!;
        }
        $13 &= ~0x10 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.pos = $5!;
      }
      $13 &= ~0x20 & 0xffff;
      $2 = endEvent<List<Object?>>(JsonParserEvent.arrayEvent, $2, state.ok);
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// String
  /// EscapeChar =
  ///   c:["/bfnrt\\] {}
  ///   ;
  String? parseEscapeChar(State<String> state) {
    String? $0;
    // c:["/bfnrt\\] {}
    int? $2;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $3 = state.input.codeUnitAt(state.pos);
      state.ok = $3 == 98 ||
          ($3 < 98
              ? $3 == 47 || $3 == 34 || $3 == 92
              : $3 == 110 || ($3 < 110 ? $3 == 102 : $3 == 114 || $3 == 116));
      if (state.ok) {
        state.pos++;
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
    String? $2;
    int? $3;
    Object? $6;
    void $1() {
      // c:["/bfnrt\\] {}
      // ["/bfnrt\\]
      $6 ??= state.input.beginBuffering();
      final $5 = state.input;
      if (state.pos >= $5.end && !$5.isClosed) {
        $5.sleep = true;
        $5.handle = $1;
        return;
      }
      final $4 = readChar16Async(state);
      if ($4 >= 0) {
        state.ok = $4 == 98 ||
            ($4 < 98
                ? $4 == 47 || $4 == 34 || $4 == 92
                : $4 == 110 || ($4 < 110 ? $4 == 102 : $4 == 114 || $4 == 116));
        if (state.ok) {
          state.pos++;
          $3 = $4;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      }
      state.input.endBuffering(state.pos);
      $6 = null;
      if (state.ok) {
        String? $$;
        final c = $3!;
        $$ = _escape(c);
        $2 = $$;
      }
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// String
  /// EscapeHex =
  ///   'u' v:HexNumber {}
  ///   ;
  String? parseEscapeHex(State<String> state) {
    String? $0;
    // 'u' v:HexNumber {}
    final $1 = state.pos;
    const $3 = 'u';
    matchLiteral1(state, $3, const ErrorExpectedTags([$3]));
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
    String? $2;
    int? $4;
    int? $5;
    Object? $8;
    int? $3;
    AsyncResult<int>? $9;
    int $11 = 0;
    void $1() {
      // 'u' v:HexNumber {}
      if ($11 & 0x2 == 0) {
        $11 |= 0x2;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // 'u'
        $8 ??= state.input.beginBuffering();
        const $7 = 'u';
        final $6 = state.input;
        if (state.pos < $6.end || $6.isClosed) {
          matchLiteral1Async(state, $7, const ErrorExpectedTags([$7]));
        } else {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        state.input.endBuffering(state.pos);
        $8 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // HexNumber
        if ($11 & 0x1 == 0) {
          $11 |= 0x1;
          $9 = parseHexNumber$Async(state);
          final $10 = $9!;
          if (!$10.isComplete) {
            $10.onComplete = $1;
            return;
          }
        }
        $3 = $9!.value;
        $11 &= ~0x1 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        String? $$;
        final v = $3!;
        $$ = String.fromCharCode(v);
        $2 = $$;
      } else {
        state.pos = $5!;
      }
      $11 &= ~0x2 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// HexNumber =
  ///   @errorHandler(HexNumberRaw)
  ///   ;
  int? parseHexNumber(State<String> state) {
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
        final $10 = state.input.codeUnitAt(state.pos);
        state.ok = $10 <= 70
            ? $10 >= 48 && $10 <= 57 || $10 >= 65
            : $10 >= 97 && $10 <= 102;
        if (state.ok) {
          state.pos++;
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
    int? $2;
    int? $3;
    int? $4;
    String? $5;
    int? $6;
    int? $7;
    int? $9;
    int $12 = 0;
    void $1() {
      // @errorHandler(HexNumberRaw)
      // @errorHandler(HexNumberRaw)
      if ($12 & 0x2 == 0) {
        $12 |= 0x2;
        $4 = state.failPos;
        $3 = state.errorCount;
      }
      // HexNumberRaw
      // HexNumberRaw
      // HexNumberRaw
      // v:$[0-9A-Fa-f]{4,4} {}
      // v:$[0-9A-Fa-f]{4,4} {}
      // $[0-9A-Fa-f]{4,4}
      if ($12 & 0x1 == 0) {
        $12 |= 0x1;
        state.input.beginBuffering();
        $6 = state.pos;
      }
      // [0-9A-Fa-f]{4,4}
      if ($7 == null) {
        $7 = 0;
        $9 = state.pos;
      }
      while (true) {
        // [0-9A-Fa-f]
        final $11 = state.input;
        if (state.pos >= $11.end && !$11.isClosed) {
          $11.sleep = true;
          $11.handle = $1;
          return;
        }
        final $10 = readChar16Async(state);
        if ($10 >= 0) {
          state.ok = $10 <= 70
              ? $10 >= 48 && $10 <= 57 || $10 >= 65
              : $10 >= 97 && $10 <= 102;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        }
        if (!state.ok) {
          break;
        }
        final $8 = $7! + 1;
        $7 = $8;
        if ($8 == 4) {
          break;
        }
      }
      state.ok = $7! == 4;
      if (!state.ok) {
        state.pos = $9!;
      }
      $7 = null;
      if (state.ok) {
        final input = state.input;
        final start = input.start;
        $5 = input.data.substring($6! - start, state.pos - start);
      }
      state.input.endBuffering(state.pos);
      $12 &= ~0x1 & 0xffff;
      if (state.ok) {
        int? $$;
        final v = $5!;
        $$ = int.parse(v, radix: 16);
        $2 = $$;
      }
      if (!state.ok && state._canHandleError($4!, $3!)) {
        ParseError? error;
        // ignore: prefer_final_locals
        var rollbackErrors = false;
        rollbackErrors = true;
        error = ErrorMessage(
            state.pos - state.failPos, 'Expected 4 digit hex number');
        if (rollbackErrors == true) {
          state._rollbackErrors($4!, $3!);
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
      $12 &= ~0x2 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// @event
  /// MapEntry<String, Object?>
  /// KeyValue =
  ///   k:Key Colon v:Value {}
  ///   ;
  MapEntry<String, Object?>? parseKeyValue(State<String> state) {
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
      matchLiteral1(state, $6, const ErrorExpectedTags([$6]));
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
    MapEntry<String, Object?>? $2;
    int? $5;
    int? $6;
    String? $3;
    AsyncResult<String>? $7;
    int $9 = 0;
    int? $10;
    int? $11;
    Object? $14;
    AsyncResult<Object?>? $15;
    Object? $4;
    AsyncResult<Object?>? $17;
    void $1() {
      // k:Key Colon v:Value {}
      if ($9 & 0x20 == 0) {
        $9 |= 0x20;
        $5 = 0;
        $6 = state.pos;
      }
      if ($5 == 0) {
        // Key
        if ($9 & 0x2 == 0) {
          $9 |= 0x2;
          beginEvent(JsonParserEvent.keyEvent);
        }
        // String
        // String
        // String
        if ($9 & 0x1 == 0) {
          $9 |= 0x1;
          $7 = parseString$Async(state);
          final $8 = $7!;
          if (!$8.isComplete) {
            $8.onComplete = $1;
            return;
          }
        }
        $3 = $7!.value;
        $9 &= ~0x1 & 0xffff;
        $3 = endEvent<String>(JsonParserEvent.keyEvent, $3, state.ok);
        $9 &= ~0x2 & 0xffff;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // Colon
        // v:':' Spaces
        // v:':' Spaces
        if ($9 & 0x8 == 0) {
          $9 |= 0x8;
          $10 = 0;
          $11 = state.pos;
        }
        if ($10 == 0) {
          // ':'
          $14 ??= state.input.beginBuffering();
          const $13 = ':';
          final $12 = state.input;
          if (state.pos < $12.end || $12.isClosed) {
            matchLiteral1Async(state, $13, const ErrorExpectedTags([$13]));
          } else {
            $12.sleep = true;
            $12.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $14 = null;
          $10 = state.ok ? 1 : -1;
        }
        if ($10 == 1) {
          // Spaces
          if ($9 & 0x4 == 0) {
            $9 |= 0x4;
            $15 = fastParseSpaces$Async(state);
            final $16 = $15!;
            if (!$16.isComplete) {
              $16.onComplete = $1;
              return;
            }
          }
          $9 &= ~0x4 & 0xffff;
          $10 = -1;
        }
        if (!state.ok) {
          state.pos = $11!;
        }
        $9 &= ~0x8 & 0xffff;
        $5 = state.ok ? 2 : -1;
      }
      if ($5 == 2) {
        // Value
        if ($9 & 0x10 == 0) {
          $9 |= 0x10;
          $17 = parseValue$Async(state);
          final $18 = $17!;
          if (!$18.isComplete) {
            $18.onComplete = $1;
            return;
          }
        }
        $4 = $17!.value;
        $9 &= ~0x10 & 0xffff;
        $5 = -1;
      }
      if (state.ok) {
        MapEntry<String, Object?>? $$;
        final k = $3!;
        final v = $4;
        $$ = MapEntry(k, v);
        $2 = $$;
      } else {
        state.pos = $6!;
      }
      $9 &= ~0x20 & 0xffff;
      $2 = endEvent<MapEntry<String, Object?>>(
          JsonParserEvent.keyValueEvent, $2, state.ok);
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma)
  ///   ;
  List<MapEntry<String, Object?>>? parseKeyValues(State<String> state) {
    List<MapEntry<String, Object?>>? $0;
    // @sepBy(KeyValue, Comma)
    final $2 = <MapEntry<String, Object?>>[];
    var $4 = state.pos;
    while (true) {
      MapEntry<String, Object?>? $3;
      // KeyValue
      // KeyValue
      $3 = parseKeyValue(state);
      if (!state.ok) {
        state.pos = $4;
        break;
      }
      $2.add($3!);
      $4 = state.pos;
      // Comma
      // @inline Comma = v:',' Spaces ;
      // v:',' Spaces
      final $7 = state.pos;
      const $8 = ',';
      matchLiteral1(state, $8, const ErrorExpectedTags([$8]));
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.pos = $7;
      }
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

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma)
  ///   ;
  AsyncResult<List<MapEntry<String, Object?>>> parseKeyValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<MapEntry<String, Object?>>>();
    List<MapEntry<String, Object?>>? $2;
    Object? $3;
    Object? $4;
    int? $5;
    List<MapEntry<String, Object?>>? $6;
    int? $8;
    AsyncResult<MapEntry<String, Object?>>? $9;
    int $11 = 0;
    int? $12;
    int? $13;
    Object? $16;
    AsyncResult<Object?>? $17;
    void $1() {
      // @sepBy(KeyValue, Comma)
      // @sepBy(KeyValue, Comma)
      if ($3 == null) {
        $3 = true;
        state.input.beginBuffering();
        $6 = [];
        $8 = state.pos;
        $5 = 0;
      }
      while (true) {
        if ($5 == 0) {
          MapEntry<String, Object?>? $7;
          // KeyValue
          // KeyValue
          if ($11 & 0x1 == 0) {
            $11 |= 0x1;
            $9 = parseKeyValue$Async(state);
            final $10 = $9!;
            if (!$10.isComplete) {
              $10.onComplete = $1;
              return;
            }
          }
          $7 = $9!.value;
          $11 &= ~0x1 & 0xffff;
          if (!state.ok) {
            state.pos = $8!;
            state.input.endBuffering(state.pos);
            $7 = null;
            break;
          }
          $6!.add($7!);
          $7 = null;
          state.input.endBuffering(state.pos);
          $5 = 1;
        }
        if ($5 == 1) {
          if ($4 == null) {
            $4 = true;
            state.input.beginBuffering();
            $8 = state.pos;
          }
          // Comma
          // Comma
          // v:',' Spaces
          // v:',' Spaces
          if ($11 & 0x4 == 0) {
            $11 |= 0x4;
            $12 = 0;
            $13 = state.pos;
          }
          if ($12 == 0) {
            // ','
            $16 ??= state.input.beginBuffering();
            const $15 = ',';
            final $14 = state.input;
            if (state.pos < $14.end || $14.isClosed) {
              matchLiteral1Async(state, $15, const ErrorExpectedTags([$15]));
            } else {
              $14.sleep = true;
              $14.handle = $1;
              return;
            }
            state.input.endBuffering(state.pos);
            $16 = null;
            $12 = state.ok ? 1 : -1;
          }
          if ($12 == 1) {
            // Spaces
            if ($11 & 0x2 == 0) {
              $11 |= 0x2;
              $17 = fastParseSpaces$Async(state);
              final $18 = $17!;
              if (!$18.isComplete) {
                $18.onComplete = $1;
                return;
              }
            }
            $11 &= ~0x2 & 0xffff;
            $12 = -1;
          }
          if (!state.ok) {
            state.pos = $13!;
          }
          $11 &= ~0x4 & 0xffff;
          $4 = null;
          if (!state.ok) {
            state.input.endBuffering(state.pos);
            break;
          }
          $5 = 0;
        }
      }
      state.ok = true;
      if (state.ok) {
        $2 = $6;
        $6 = null;
      }
      $4 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// num
  /// Number =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
    final $1 = state.pos;
    String? $2;
    final $3 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
    final $4 = state.pos;
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos++;
    } else {
      state.fail(const ErrorExpectedCharacter(45));
    }
    state.ok = true;
    if (state.ok) {
      // [0]
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 48;
      if (state.ok) {
        state.pos++;
      } else {
        state.fail(const ErrorExpectedCharacter(48));
      }
      if (!state.ok) {
        // [1-9] [0-9]*
        final $6 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $7 = state.input.codeUnitAt(state.pos);
          state.ok = $7 >= 49 && $7 <= 57;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          final $9 = state.input;
          while (state.pos < $9.length) {
            final $8 = $9.codeUnitAt(state.pos);
            state.ok = $8 >= 48 && $8 <= 57;
            if (!state.ok) {
              break;
            }
            state.pos++;
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
        final $10 = state.pos;
        state.ok = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 46;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorExpectedCharacter(46));
        }
        if (state.ok) {
          final $13 = state.pos;
          final $12 = state.input;
          while (state.pos < $12.length) {
            final $11 = $12.codeUnitAt(state.pos);
            state.ok = $11 >= 48 && $11 <= 57;
            if (!state.ok) {
              break;
            }
            state.pos++;
          }
          state.fail(const ErrorUnexpectedCharacter());
          state.ok = state.pos > $13;
        }
        if (!state.ok) {
          state.pos = $10;
        }
        state.ok = true;
        if (state.ok) {
          // [eE] [-+]? [0-9]+
          final $14 = state.pos;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $15 = state.input.codeUnitAt(state.pos);
            state.ok = $15 == 69 || $15 == 101;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $16 = state.input.codeUnitAt(state.pos);
              state.ok = $16 == 43 || $16 == 45;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.ok = true;
            if (state.ok) {
              final $19 = state.pos;
              final $18 = state.input;
              while (state.pos < $18.length) {
                final $17 = $18.codeUnitAt(state.pos);
                state.ok = $17 >= 48 && $17 <= 57;
                if (!state.ok) {
                  break;
                }
                state.pos++;
              }
              state.fail(const ErrorUnexpectedCharacter());
              state.ok = state.pos > $19;
            }
          }
          if (!state.ok) {
            state.pos = $14;
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
    num? $2;
    int? $4;
    int? $5;
    String? $3;
    int? $6;
    int? $7;
    int? $8;
    int? $10;
    int? $12;
    int? $13;
    int $18 = 0;
    int? $19;
    int? $20;
    bool? $22;
    int? $25;
    int? $26;
    bool? $31;
    AsyncResult<Object?>? $34;
    void $1() {
      // v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
      if ($18 & 0x80 == 0) {
        $18 |= 0x80;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // $([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
        if ($18 & 0x20 == 0) {
          $18 |= 0x20;
          state.input.beginBuffering();
          $6 = state.pos;
        }
        // ([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?)
        // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
        // [-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?
        if ($18 & 0x10 == 0) {
          $18 |= 0x10;
          $7 = 0;
          $8 = state.pos;
        }
        if ($7 == 0) {
          // [-]?
          // [-]
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          matchChar16Async(state, 45, const ErrorExpectedCharacter(45));
          if (!state.ok) {
            state.ok = true;
          }
          $7 = state.ok ? 1 : -1;
        }
        if ($7 == 1) {
          // ([0] / [1-9] [0-9]*)
          // [0] / [1-9] [0-9]*
          if ($18 & 0x2 == 0) {
            $18 |= 0x2;
            $10 = 0;
          }
          if ($10 == 0) {
            // [0]
            // [0]
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              return;
            }
            matchChar16Async(state, 48, const ErrorExpectedCharacter(48));
            $10 = state.ok ? -1 : 1;
          }
          if ($10 == 1) {
            // [1-9] [0-9]*
            if ($18 & 0x1 == 0) {
              $18 |= 0x1;
              $12 = 0;
              $13 = state.pos;
            }
            if ($12 == 0) {
              // [1-9]
              final $15 = state.input;
              if (state.pos >= $15.end && !$15.isClosed) {
                $15.sleep = true;
                $15.handle = $1;
                return;
              }
              final $14 = readChar16Async(state);
              if ($14 >= 0) {
                state.ok = $14 >= 49 && $14 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              $12 = state.ok ? 1 : -1;
            }
            if ($12 == 1) {
              // [0-9]*
              while (true) {
                // [0-9]
                final $17 = state.input;
                if (state.pos >= $17.end && !$17.isClosed) {
                  $17.sleep = true;
                  $17.handle = $1;
                  return;
                }
                final $16 = readChar16Async(state);
                if ($16 >= 0) {
                  state.ok = $16 >= 48 && $16 <= 57;
                  if (state.ok) {
                    state.pos++;
                  } else {
                    state.fail(const ErrorUnexpectedCharacter());
                  }
                }
                if (!state.ok) {
                  break;
                }
              }
              state.ok = true;
              $12 = -1;
            }
            if (!state.ok) {
              state.pos = $13!;
            }
            $18 &= ~0x1 & 0xffff;
            $10 = -1;
          }
          $18 &= ~0x2 & 0xffff;
          $7 = state.ok ? 2 : -1;
        }
        if ($7 == 2) {
          // ([.] [0-9]+)?
          // ([.] [0-9]+)
          // [.] [0-9]+
          // [.] [0-9]+
          if ($18 & 0x4 == 0) {
            $18 |= 0x4;
            $19 = 0;
            $20 = state.pos;
          }
          if ($19 == 0) {
            // [.]
            final $21 = state.input;
            if (state.pos >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $1;
              return;
            }
            matchChar16Async(state, 46, const ErrorExpectedCharacter(46));
            $19 = state.ok ? 1 : -1;
          }
          if ($19 == 1) {
            // [0-9]+
            $22 ??= false;
            while (true) {
              // [0-9]
              final $24 = state.input;
              if (state.pos >= $24.end && !$24.isClosed) {
                $24.sleep = true;
                $24.handle = $1;
                return;
              }
              final $23 = readChar16Async(state);
              if ($23 >= 0) {
                state.ok = $23 >= 48 && $23 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $22 = true;
            }
            state.ok = $22!;
            $22 = null;
            $19 = -1;
          }
          if (!state.ok) {
            state.pos = $20!;
          }
          $18 &= ~0x4 & 0xffff;
          if (!state.ok) {
            state.ok = true;
          }
          $7 = state.ok ? 3 : -1;
        }
        if ($7 == 3) {
          // ([eE] [-+]? [0-9]+)?
          // ([eE] [-+]? [0-9]+)
          // [eE] [-+]? [0-9]+
          // [eE] [-+]? [0-9]+
          if ($18 & 0x8 == 0) {
            $18 |= 0x8;
            $25 = 0;
            $26 = state.pos;
          }
          if ($25 == 0) {
            // [eE]
            final $28 = state.input;
            if (state.pos >= $28.end && !$28.isClosed) {
              $28.sleep = true;
              $28.handle = $1;
              return;
            }
            final $27 = readChar16Async(state);
            if ($27 >= 0) {
              state.ok = $27 == 69 || $27 == 101;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            $25 = state.ok ? 1 : -1;
          }
          if ($25 == 1) {
            // [-+]?
            // [-+]
            final $30 = state.input;
            if (state.pos >= $30.end && !$30.isClosed) {
              $30.sleep = true;
              $30.handle = $1;
              return;
            }
            final $29 = readChar16Async(state);
            if ($29 >= 0) {
              state.ok = $29 == 43 || $29 == 45;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            if (!state.ok) {
              state.ok = true;
            }
            $25 = state.ok ? 2 : -1;
          }
          if ($25 == 2) {
            // [0-9]+
            $31 ??= false;
            while (true) {
              // [0-9]
              final $33 = state.input;
              if (state.pos >= $33.end && !$33.isClosed) {
                $33.sleep = true;
                $33.handle = $1;
                return;
              }
              final $32 = readChar16Async(state);
              if ($32 >= 0) {
                state.ok = $32 >= 48 && $32 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $31 = true;
            }
            state.ok = $31!;
            $31 = null;
            $25 = -1;
          }
          if (!state.ok) {
            state.pos = $26!;
          }
          $18 &= ~0x8 & 0xffff;
          if (!state.ok) {
            state.ok = true;
          }
          $7 = -1;
        }
        if (!state.ok) {
          state.pos = $8!;
        }
        $18 &= ~0x10 & 0xffff;
        if (state.ok) {
          final input = state.input;
          final start = input.start;
          $3 = input.data.substring($6! - start, state.pos - start);
        }
        state.input.endBuffering(state.pos);
        $18 &= ~0x20 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // Spaces
        if ($18 & 0x40 == 0) {
          $18 |= 0x40;
          $34 = fastParseSpaces$Async(state);
          final $35 = $34!;
          if (!$35.isComplete) {
            $35.onComplete = $1;
            return;
          }
        }
        $18 &= ~0x40 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        num? $$;
        final v = $3!;
        $$ = num.parse(v);
        $2 = $$;
      } else {
        state.pos = $5!;
      }
      $18 &= ~0x80 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// @event
  /// Map<String, Object?>
  /// Object =
  ///   OpenBrace kv:KeyValues CloseBrace {}
  ///   ;
  Map<String, Object?>? parseObject(State<String> state) {
    beginEvent(JsonParserEvent.objectEvent);
    Map<String, Object?>? $0;
    // OpenBrace kv:KeyValues CloseBrace {}
    final $1 = state.pos;
    // @inline OpenBrace = v:'{' Spaces ;
    // v:'{' Spaces
    final $3 = state.pos;
    const $4 = '{';
    matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
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
        matchLiteral1(state, $6, const ErrorExpectedTags([$6]));
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
    Map<String, Object?>? $2;
    int? $4;
    int? $5;
    int? $6;
    int? $7;
    Object? $10;
    AsyncResult<Object?>? $11;
    int $13 = 0;
    List<MapEntry<String, Object?>>? $3;
    AsyncResult<List<MapEntry<String, Object?>>>? $14;
    int? $16;
    int? $17;
    Object? $20;
    AsyncResult<Object?>? $21;
    void $1() {
      // OpenBrace kv:KeyValues CloseBrace {}
      if ($13 & 0x20 == 0) {
        $13 |= 0x20;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // OpenBrace
        // v:'{' Spaces
        // v:'{' Spaces
        if ($13 & 0x2 == 0) {
          $13 |= 0x2;
          $6 = 0;
          $7 = state.pos;
        }
        if ($6 == 0) {
          // '{'
          $10 ??= state.input.beginBuffering();
          const $9 = '{';
          final $8 = state.input;
          if (state.pos < $8.end || $8.isClosed) {
            matchLiteral1Async(state, $9, const ErrorExpectedTags([$9]));
          } else {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $10 = null;
          $6 = state.ok ? 1 : -1;
        }
        if ($6 == 1) {
          // Spaces
          if ($13 & 0x1 == 0) {
            $13 |= 0x1;
            $11 = fastParseSpaces$Async(state);
            final $12 = $11!;
            if (!$12.isComplete) {
              $12.onComplete = $1;
              return;
            }
          }
          $13 &= ~0x1 & 0xffff;
          $6 = -1;
        }
        if (!state.ok) {
          state.pos = $7!;
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // KeyValues
        if ($13 & 0x4 == 0) {
          $13 |= 0x4;
          $14 = parseKeyValues$Async(state);
          final $15 = $14!;
          if (!$15.isComplete) {
            $15.onComplete = $1;
            return;
          }
        }
        $3 = $14!.value;
        $13 &= ~0x4 & 0xffff;
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
        // CloseBrace
        // v:'}' Spaces
        // v:'}' Spaces
        if ($13 & 0x10 == 0) {
          $13 |= 0x10;
          $16 = 0;
          $17 = state.pos;
        }
        if ($16 == 0) {
          // '}'
          $20 ??= state.input.beginBuffering();
          const $19 = '}';
          final $18 = state.input;
          if (state.pos < $18.end || $18.isClosed) {
            matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          } else {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $20 = null;
          $16 = state.ok ? 1 : -1;
        }
        if ($16 == 1) {
          // Spaces
          if ($13 & 0x8 == 0) {
            $13 |= 0x8;
            $21 = fastParseSpaces$Async(state);
            final $22 = $21!;
            if (!$22.isComplete) {
              $22.onComplete = $1;
              return;
            }
          }
          $13 &= ~0x8 & 0xffff;
          $16 = -1;
        }
        if (!state.ok) {
          state.pos = $17!;
        }
        $13 &= ~0x10 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        Map<String, Object?>? $$;
        final kv = $3!;
        $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
        $2 = $$;
      } else {
        state.pos = $5!;
      }
      $13 &= ~0x20 & 0xffff;
      $2 = endEvent<Map<String, Object?>>(
          JsonParserEvent.objectEvent, $2, state.ok);
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// @event
  /// Start =
  ///   Spaces v:Value !.
  ///   ;
  Object? parseStart(State<String> state) {
    beginEvent(JsonParserEvent.startEvent);
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
        final $6 = state.input;
        if (state.pos < $6.length) {
          final $5 = $6.runeAt(state.pos);
          state.pos += $5 > 0xffff ? 2 : 1;
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
    $0 = endEvent<Object?>(JsonParserEvent.startEvent, $0, state.ok);
    return $0;
  }

  /// @event
  /// Start =
  ///   Spaces v:Value !.
  ///   ;
  AsyncResult<Object?> parseStart$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    beginEvent(JsonParserEvent.startEvent);
    Object? $2;
    int? $4;
    int? $5;
    AsyncResult<Object?>? $6;
    int $8 = 0;
    Object? $3;
    AsyncResult<Object?>? $9;
    int? $11;
    void $1() {
      // Spaces v:Value !.
      if ($8 & 0x8 == 0) {
        $8 |= 0x8;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // Spaces
        if ($8 & 0x1 == 0) {
          $8 |= 0x1;
          $6 = fastParseSpaces$Async(state);
          final $7 = $6!;
          if (!$7.isComplete) {
            $7.onComplete = $1;
            return;
          }
        }
        $8 &= ~0x1 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // Value
        if ($8 & 0x2 == 0) {
          $8 |= 0x2;
          $9 = parseValue$Async(state);
          final $10 = $9!;
          if (!$10.isComplete) {
            $10.onComplete = $1;
            return;
          }
        }
        $3 = $9!.value;
        $8 &= ~0x2 & 0xffff;
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
        // !.
        if ($8 & 0x4 == 0) {
          $8 |= 0x4;
          state.input.beginBuffering();
          $11 = state.pos;
        }
        // .
        final $13 = state.input;
        if (state.pos >= $13.end && !$13.isClosed) {
          $13.sleep = true;
          $13.handle = $1;
          return;
        }
        final $12 = readChar32Async(state);
        state.ok = $12 >= 0;
        if (state.ok) {
          state.pos += $12 > 0xffff ? 2 : 1;
        }
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $11! - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $11!;
        state.input.endBuffering(state.pos);
        $8 &= ~0x4 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.pos = $5!;
      }
      $8 &= ~0x8 & 0xffff;
      $2 = endEvent<Object?>(JsonParserEvent.startEvent, $2, state.ok);
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// String
  /// String =
  ///   '"' v:StringChars Quote
  ///   ;
  String? parseString(State<String> state) {
    String? $0;
    // '"' v:StringChars Quote
    final $1 = state.pos;
    const $3 = '"';
    matchLiteral1(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      String? $2;
      // @inline StringChars = @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex)) ;
      // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
      final $16 = state.input;
      List<String>? $17;
      String? $18;
      while (state.pos < $16.length) {
        String? $5;
        // $[ -!#-[\]-\u{10ffff}]+
        final $8 = state.pos;
        final $11 = state.pos;
        final $10 = state.input;
        while (state.pos < $10.length) {
          final $9 = $10.runeAt(state.pos);
          state.ok = $9 <= 91
              ? $9 >= 32 && $9 <= 33 || $9 >= 35
              : $9 >= 93 && $9 <= 1114111;
          if (!state.ok) {
            break;
          }
          state.pos += $9 > 0xffff ? 2 : 1;
        }
        state.fail(const ErrorUnexpectedCharacter());
        state.ok = state.pos > $11;
        if (state.ok) {
          $5 = state.input.substring($8, state.pos);
        }
        if (state.ok) {
          final v = $5!;
          if ($18 == null) {
            $18 = v;
          } else if ($17 == null) {
            $17 = [$18, v];
          } else {
            $17.add(v);
          }
        }
        final pos = state.pos;
        // [\\]
        state.ok = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 92;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorExpectedCharacter(92));
        }
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
        if ($18 == null) {
          $18 = $6!;
        } else {
          if ($17 == null) {
            $17 = [$18, $6!];
          } else {
            $17.add($6!);
          }
        }
      }
      state.ok = true;
      if ($18 == null) {
        $2 = '';
      } else if ($17 == null) {
        $2 = $18;
      } else {
        $2 = $17.join();
      }
      if (state.ok) {
        // @inline Quote = v:'"' Spaces ;
        // v:'"' Spaces
        final $19 = state.pos;
        const $20 = '"';
        matchLiteral1(state, $20, const ErrorExpectedTags([$20]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.pos = $19;
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
    String? $2;
    int? $4;
    int? $5;
    Object? $8;
    String? $3;
    int? $9;
    int? $10;
    Object? $11;
    Object? $12;
    List<String>? $15;
    String? $16;
    String? $13;
    int? $17;
    bool? $18;
    int $21 = 0;
    String? $14;
    int? $23;
    AsyncResult<String>? $24;
    AsyncResult<String>? $26;
    int? $28;
    int? $29;
    Object? $32;
    AsyncResult<Object?>? $33;
    void $1() {
      // '"' v:StringChars Quote
      if ($21 & 0x80 == 0) {
        $21 |= 0x80;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // '"'
        $8 ??= state.input.beginBuffering();
        const $7 = '"';
        final $6 = state.input;
        if (state.pos < $6.end || $6.isClosed) {
          matchLiteral1Async(state, $7, const ErrorExpectedTags([$7]));
        } else {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        state.input.endBuffering(state.pos);
        $8 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // StringChars
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        if ($21 & 0x10 == 0) {
          $21 |= 0x10;
          state.input.beginBuffering();
          $15 = null;
          $16 = null;
          $9 = 0;
        }
        while (true) {
          if ($9 == 0) {
            $11 ??= state.input.beginBuffering();
            // $[ -!#-[\]-\u{10ffff}]+
            // $[ -!#-[\]-\u{10ffff}]+
            // $[ -!#-[\]-\u{10ffff}]+
            if ($21 & 0x1 == 0) {
              $21 |= 0x1;
              $17 = state.pos;
            }
            // [ -!#-[\]-\u{10ffff}]+
            $18 ??= false;
            while (true) {
              // [ -!#-[\]-\u{10ffff}]
              final $20 = state.input;
              if (state.pos >= $20.end && !$20.isClosed) {
                $20.sleep = true;
                $20.handle = $1;
                return;
              }
              final $19 = readChar32Async(state);
              if ($19 >= 0) {
                state.ok = $19 <= 91
                    ? $19 >= 32 && $19 <= 33 || $19 >= 35
                    : $19 >= 93 && $19 <= 1114111;
                if (state.ok) {
                  state.pos += $19 > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $18 = true;
            }
            state.ok = $18!;
            $18 = null;
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $13 = input.data.substring($17! - start, state.pos - start);
            }
            $21 &= ~0x1 & 0xffff;
            state.input.endBuffering(state.pos);
            $11 = null;
            if (state.ok) {
              final v = $13!;
              if ($16 == null) {
                $16 = v;
              } else if ($15 == null) {
                $15 = [$16!, v];
              } else {
                $15!.add(v);
              }
            }
            $10 = state.pos;
            $9 = 1;
          }
          if ($9 == 1) {
            $12 ??= state.input.beginBuffering();
            // [\\]
            // [\\]
            // [\\]
            final $22 = state.input;
            if (state.pos >= $22.end && !$22.isClosed) {
              $22.sleep = true;
              $22.handle = $1;
              return;
            }
            matchChar16Async(state, 92, const ErrorExpectedCharacter(92));
            if (!state.ok) {
              state.input.endBuffering(state.pos);
              $12 = null;
              break;
            }
            $9 = 2;
          }
          if ($9 == 2) {
            // (EscapeChar / EscapeHex)
            // (EscapeChar / EscapeHex)
            // (EscapeChar / EscapeHex)
            // EscapeChar / EscapeHex
            if ($21 & 0x8 == 0) {
              $21 |= 0x8;
              $23 = 0;
            }
            if ($23 == 0) {
              // EscapeChar
              // EscapeChar
              if ($21 & 0x2 == 0) {
                $21 |= 0x2;
                $24 = parseEscapeChar$Async(state);
                final $25 = $24!;
                if (!$25.isComplete) {
                  $25.onComplete = $1;
                  return;
                }
              }
              $14 = $24!.value;
              $21 &= ~0x2 & 0xffff;
              $23 = state.ok ? -1 : 1;
            }
            if ($23 == 1) {
              // EscapeHex
              // EscapeHex
              if ($21 & 0x4 == 0) {
                $21 |= 0x4;
                $26 = parseEscapeHex$Async(state);
                final $27 = $26!;
                if (!$27.isComplete) {
                  $27.onComplete = $1;
                  return;
                }
              }
              $14 = $26!.value;
              $21 &= ~0x4 & 0xffff;
              $23 = -1;
            }
            $21 &= ~0x8 & 0xffff;
            state.input.endBuffering(state.pos);
            $12 = null;
            if (!state.ok) {
              state.pos = $10!;
              break;
            }
            if ($16 == null) {
              $16 = $14!;
            } else {
              if ($15 == null) {
                $15 = [$16!, $14!];
              } else {
                $15!.add($14!);
              }
            }
            $9 = 0;
          }
        }
        state.ok = true;
        if ($16 == null) {
          $3 = '';
        } else if ($15 == null) {
          $3 = $16!;
        } else {
          $3 = $15!.join();
        }
        state.input.endBuffering(state.pos);
        $21 &= ~0x10 & 0xffff;
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
        // Quote
        // v:'"' Spaces
        // v:'"' Spaces
        if ($21 & 0x40 == 0) {
          $21 |= 0x40;
          $28 = 0;
          $29 = state.pos;
        }
        if ($28 == 0) {
          // '"'
          $32 ??= state.input.beginBuffering();
          const $31 = '"';
          final $30 = state.input;
          if (state.pos < $30.end || $30.isClosed) {
            matchLiteral1Async(state, $31, const ErrorExpectedTags([$31]));
          } else {
            $30.sleep = true;
            $30.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $32 = null;
          $28 = state.ok ? 1 : -1;
        }
        if ($28 == 1) {
          // Spaces
          if ($21 & 0x20 == 0) {
            $21 |= 0x20;
            $33 = fastParseSpaces$Async(state);
            final $34 = $33!;
            if (!$34.isComplete) {
              $34.onComplete = $1;
              return;
            }
          }
          $21 &= ~0x20 & 0xffff;
          $28 = -1;
        }
        if (!state.ok) {
          state.pos = $29!;
        }
        $21 &= ~0x40 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.pos = $5!;
      }
      $21 &= ~0x80 & 0xffff;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
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
  Object? parseValue(State<String> state) {
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
              state.ok = state.pos < state.input.length &&
                  state.input.codeUnitAt(state.pos) == 116 &&
                  state.input.startsWith($8, state.pos);
              if (state.ok) {
                state.pos += 4;
              } else {
                state.fail(const ErrorExpectedTags([$8]));
              }
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
                state.ok = state.pos < state.input.length &&
                    state.input.codeUnitAt(state.pos) == 102 &&
                    state.input.startsWith($11, state.pos);
                if (state.ok) {
                  state.pos += 5;
                } else {
                  state.fail(const ErrorExpectedTags([$11]));
                }
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
                  state.ok = state.pos < state.input.length &&
                      state.input.codeUnitAt(state.pos) == 110 &&
                      state.input.startsWith($14, state.pos);
                  if (state.ok) {
                    state.pos += 4;
                  } else {
                    state.fail(const ErrorExpectedTags([$14]));
                  }
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
    Object? $2;
    int? $3;
    AsyncResult<List<Object?>>? $4;
    int $6 = 0;
    AsyncResult<String>? $7;
    AsyncResult<Map<String, Object?>>? $9;
    AsyncResult<List<Object?>>? $11;
    AsyncResult<num>? $13;
    int? $15;
    int? $16;
    Object? $18;
    AsyncResult<Object?>? $19;
    int? $21;
    int? $22;
    Object? $24;
    AsyncResult<Object?>? $25;
    int? $27;
    int? $28;
    Object? $30;
    AsyncResult<Object?>? $31;
    void $1() {
      if ($6 & 0x800 == 0) {
        $6 |= 0x800;
        $3 = 0;
      }
      if ($3 == 0) {
        // Array
        // Array
        if ($6 & 0x1 == 0) {
          $6 |= 0x1;
          $4 = parseArray$Async(state);
          final $5 = $4!;
          if (!$5.isComplete) {
            $5.onComplete = $1;
            return;
          }
        }
        $2 = $4!.value;
        $6 &= ~0x1 & 0xffff;
        $3 = state.ok ? -1 : 1;
      }
      if ($3 == 1) {
        // String
        // String
        if ($6 & 0x2 == 0) {
          $6 |= 0x2;
          $7 = parseString$Async(state);
          final $8 = $7!;
          if (!$8.isComplete) {
            $8.onComplete = $1;
            return;
          }
        }
        $2 = $7!.value;
        $6 &= ~0x2 & 0xffff;
        $3 = state.ok ? -1 : 2;
      }
      if ($3 == 2) {
        // Object
        // Object
        if ($6 & 0x4 == 0) {
          $6 |= 0x4;
          $9 = parseObject$Async(state);
          final $10 = $9!;
          if (!$10.isComplete) {
            $10.onComplete = $1;
            return;
          }
        }
        $2 = $9!.value;
        $6 &= ~0x4 & 0xffff;
        $3 = state.ok ? -1 : 3;
      }
      if ($3 == 3) {
        // Array
        // Array
        if ($6 & 0x8 == 0) {
          $6 |= 0x8;
          $11 = parseArray$Async(state);
          final $12 = $11!;
          if (!$12.isComplete) {
            $12.onComplete = $1;
            return;
          }
        }
        $2 = $11!.value;
        $6 &= ~0x8 & 0xffff;
        $3 = state.ok ? -1 : 4;
      }
      if ($3 == 4) {
        // Number
        // Number
        if ($6 & 0x10 == 0) {
          $6 |= 0x10;
          $13 = parseNumber$Async(state);
          final $14 = $13!;
          if (!$14.isComplete) {
            $14.onComplete = $1;
            return;
          }
        }
        $2 = $13!.value;
        $6 &= ~0x10 & 0xffff;
        $3 = state.ok ? -1 : 5;
      }
      if ($3 == 5) {
        // True
        // True
        // 'true' Spaces {}
        // 'true' Spaces {}
        if ($6 & 0x40 == 0) {
          $6 |= 0x40;
          $15 = 0;
          $16 = state.pos;
        }
        if ($15 == 0) {
          // 'true'
          $18 ??= state.input.beginBuffering();
          final $17 = state.input;
          if (state.pos + 3 < $17.end || $17.isClosed) {
            const string = 'true';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          } else {
            $17.sleep = true;
            $17.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $18 = null;
          $15 = state.ok ? 1 : -1;
        }
        if ($15 == 1) {
          // Spaces
          if ($6 & 0x20 == 0) {
            $6 |= 0x20;
            $19 = fastParseSpaces$Async(state);
            final $20 = $19!;
            if (!$20.isComplete) {
              $20.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x20 & 0xffff;
          $15 = -1;
        }
        if (state.ok) {
          bool? $$;
          $$ = true;
          $2 = $$;
        } else {
          state.pos = $16!;
        }
        $6 &= ~0x40 & 0xffff;
        $3 = state.ok ? -1 : 6;
      }
      if ($3 == 6) {
        // False
        // False
        // 'false' Spaces {}
        // 'false' Spaces {}
        if ($6 & 0x100 == 0) {
          $6 |= 0x100;
          $21 = 0;
          $22 = state.pos;
        }
        if ($21 == 0) {
          // 'false'
          $24 ??= state.input.beginBuffering();
          final $23 = state.input;
          if (state.pos + 4 < $23.end || $23.isClosed) {
            const string = 'false';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          } else {
            $23.sleep = true;
            $23.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $24 = null;
          $21 = state.ok ? 1 : -1;
        }
        if ($21 == 1) {
          // Spaces
          if ($6 & 0x80 == 0) {
            $6 |= 0x80;
            $25 = fastParseSpaces$Async(state);
            final $26 = $25!;
            if (!$26.isComplete) {
              $26.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x80 & 0xffff;
          $21 = -1;
        }
        if (state.ok) {
          bool? $$;
          $$ = false;
          $2 = $$;
        } else {
          state.pos = $22!;
        }
        $6 &= ~0x100 & 0xffff;
        $3 = state.ok ? -1 : 7;
      }
      if ($3 == 7) {
        // Null
        // Null
        // 'null' Spaces {}
        // 'null' Spaces {}
        if ($6 & 0x400 == 0) {
          $6 |= 0x400;
          $27 = 0;
          $28 = state.pos;
        }
        if ($27 == 0) {
          // 'null'
          $30 ??= state.input.beginBuffering();
          final $29 = state.input;
          if (state.pos + 3 < $29.end || $29.isClosed) {
            const string = 'null';
            matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          } else {
            $29.sleep = true;
            $29.handle = $1;
            return;
          }
          state.input.endBuffering(state.pos);
          $30 = null;
          $27 = state.ok ? 1 : -1;
        }
        if ($27 == 1) {
          // Spaces
          if ($6 & 0x200 == 0) {
            $6 |= 0x200;
            $31 = fastParseSpaces$Async(state);
            final $32 = $31!;
            if (!$32.isComplete) {
              $32.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x200 & 0xffff;
          $27 = -1;
        }
        if (state.ok) {
          Object? $$;
          $$ = null;
          $2 = $$;
        } else {
          state.pos = $28!;
        }
        $6 &= ~0x400 & 0xffff;
        $3 = -1;
      }
      $6 &= ~0x800 & 0xffff;
      $2 = endEvent<Object?>(JsonParserEvent.valueEvent, $2, state.ok);
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  /// Values =
  ///   @sepBy(Value, Comma)
  ///   ;
  List<Object?>? parseValues(State<String> state) {
    List<Object?>? $0;
    // @sepBy(Value, Comma)
    final $2 = <Object?>[];
    var $4 = state.pos;
    while (true) {
      Object? $3;
      // Value
      // Value
      $3 = parseValue(state);
      if (!state.ok) {
        state.pos = $4;
        break;
      }
      $2.add($3);
      $4 = state.pos;
      // Comma
      // @inline Comma = v:',' Spaces ;
      // v:',' Spaces
      final $7 = state.pos;
      const $8 = ',';
      matchLiteral1(state, $8, const ErrorExpectedTags([$8]));
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.pos = $7;
      }
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

  /// Values =
  ///   @sepBy(Value, Comma)
  ///   ;
  AsyncResult<List<Object?>> parseValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    Object? $3;
    Object? $4;
    int? $5;
    List<Object?>? $6;
    int? $8;
    AsyncResult<Object?>? $9;
    int $11 = 0;
    int? $12;
    int? $13;
    Object? $16;
    AsyncResult<Object?>? $17;
    void $1() {
      // @sepBy(Value, Comma)
      // @sepBy(Value, Comma)
      if ($3 == null) {
        $3 = true;
        state.input.beginBuffering();
        $6 = [];
        $8 = state.pos;
        $5 = 0;
      }
      while (true) {
        if ($5 == 0) {
          Object? $7;
          // Value
          // Value
          if ($11 & 0x1 == 0) {
            $11 |= 0x1;
            $9 = parseValue$Async(state);
            final $10 = $9!;
            if (!$10.isComplete) {
              $10.onComplete = $1;
              return;
            }
          }
          $7 = $9!.value;
          $11 &= ~0x1 & 0xffff;
          if (!state.ok) {
            state.pos = $8!;
            state.input.endBuffering(state.pos);
            $7 = null;
            break;
          }
          $6!.add($7);
          $7 = null;
          state.input.endBuffering(state.pos);
          $5 = 1;
        }
        if ($5 == 1) {
          if ($4 == null) {
            $4 = true;
            state.input.beginBuffering();
            $8 = state.pos;
          }
          // Comma
          // Comma
          // v:',' Spaces
          // v:',' Spaces
          if ($11 & 0x4 == 0) {
            $11 |= 0x4;
            $12 = 0;
            $13 = state.pos;
          }
          if ($12 == 0) {
            // ','
            $16 ??= state.input.beginBuffering();
            const $15 = ',';
            final $14 = state.input;
            if (state.pos < $14.end || $14.isClosed) {
              matchLiteral1Async(state, $15, const ErrorExpectedTags([$15]));
            } else {
              $14.sleep = true;
              $14.handle = $1;
              return;
            }
            state.input.endBuffering(state.pos);
            $16 = null;
            $12 = state.ok ? 1 : -1;
          }
          if ($12 == 1) {
            // Spaces
            if ($11 & 0x2 == 0) {
              $11 |= 0x2;
              $17 = fastParseSpaces$Async(state);
              final $18 = $17!;
              if (!$18.isComplete) {
                $18.onComplete = $1;
                return;
              }
            }
            $11 &= ~0x2 & 0xffff;
            $12 = -1;
          }
          if (!state.ok) {
            state.pos = $13!;
          }
          $11 &= ~0x4 & 0xffff;
          $4 = null;
          if (!state.ok) {
            state.input.endBuffering(state.pos);
            break;
          }
          $5 = 0;
        }
      }
      state.ok = true;
      if (state.ok) {
        $2 = $6;
        $6 = null;
      }
      $4 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16(State<String> state, int char, ParseError error) {
    final input = state.input;
    final pos = state.pos;
    state.ok = pos < input.length && input.codeUnitAt(pos) == char;
    if (state.ok) {
      state.pos++;
      return char;
    } else {
      state.fail(error);
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16Async(
      State<ChunkedParsingSink> state, int char, ParseError error) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < start) {
      state.fail(ErrorBacktracking(pos));
      return null;
    }
    state.ok = pos < input.end;
    if (state.ok) {
      final c = input.data.codeUnitAt(pos - start);
      state.ok = c == char;
      if (state.ok) {
        state.pos++;
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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral1Async(
      State<ChunkedParsingSink> state, String string, ParseError error) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < start) {
      state.fail(ErrorBacktracking(pos));
      return null;
    }
    state.ok = pos < input.end &&
        input.data.codeUnitAt(pos - start) == string.codeUnitAt(0);
    if (state.ok) {
      state.pos++;
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
    final start = input.start;
    final pos = state.pos;
    if (pos < start) {
      state.fail(ErrorBacktracking(pos));
      return null;
    }
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final data = input.data;
    state.ok = pos <= input.end &&
        data.codeUnitAt(pos) == string.codeUnitAt(0) &&
        data.startsWith(string, pos - start);
    if (state.ok) {
      state.pos += string.length;
      return string;
    }
    state.fail(error);
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar16Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final pos = state.pos;
    final start = input.start;
    if (pos >= start) {
      if (pos < input.end) {
        return input.data.codeUnitAt(pos - start);
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    } else {
      state.fail(ErrorBacktracking(pos));
    }
    return -1;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar32Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final pos = state.pos;
    final start = input.start;
    if (pos >= start) {
      if (pos < input.end) {
        return input.data.runeAt(pos - start);
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
    } else {
      state.fail(ErrorBacktracking(pos));
    }
    return -1;
  }
}

enum JsonParserEvent {
  startEvent,
  arrayEvent,
  keyEvent,
  keyValueEvent,
  objectEvent,
  valueEvent
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

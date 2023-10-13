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
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $1 = state.input.codeUnitAt(state.pos);
        state.ok = $1 == 13 || $1 >= 9 && $1 <= 10 || $1 == 32;
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
    }
    state.setOk(true);
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
        // [ \n\r\t]
        $4 ??= state.input.beginBuffering();
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
        state.input.endBuffering();
        $4 = null;
        if (!state.ok) {
          break;
        }
      }
      state.setOk(true);
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16(State<String> state, int char) {
    final input = state.input;
    final pos = state.pos;
    if (pos < input.length) {
      state.ok = input.codeUnitAt(pos) == char;
      if (state.ok) {
        state.pos++;
        return char;
      }
      state.fail(const ErrorUnexpectedCharacter());
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16Async(State<ChunkedParsingSink> state, int char) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      state.ok = input.data.codeUnitAt(pos - start) == char;
      if (state.ok) {
        state.pos++;
        return char;
      }
      state.fail(const ErrorUnexpectedCharacter());
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return null;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? matchLiteral(State<String> state, String string, ParseError error) {
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
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
    if (string.isEmpty) {
      state.ok = true;
      return '';
    }
    final input = state.input;
    final start = input.start;
    final data = input.data;
    final pos = state.pos;
    final index = pos - start;
    state.ok = pos <= input.end &&
        data.codeUnitAt(index) == string.codeUnitAt(0) &&
        data.startsWith(string, index);
    if (state.ok) {
      state.pos += string.length;
      return string;
    }
    state.fail(error);
    return null;
  }

  /// @event
  /// Array =
  ///   OpenBracket ↑ v:Values CloseBracket
  ///   ;
  List<Object?>? parseArray(State<String> state) {
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $0;
    // OpenBracket ↑ v:Values CloseBracket
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
      state.backtrack($3);
    }
    if (state.ok) {
      state.cut(state.pos);
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
            state.backtrack($5);
          }
          if (state.ok) {
            $0 = $2;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    $0 = endEvent<List<Object?>>(JsonParserEvent.arrayEvent, $0, state.ok);
    return $0;
  }

  /// @event
  /// Array =
  ///   OpenBracket ↑ v:Values CloseBracket
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
      // OpenBracket ↑ v:Values CloseBracket
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
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          const $9 = '[';
          matchLiteral1Async(state, $9, const ErrorExpectedTags([$9]));
          state.input.endBuffering();
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
          state.backtrack($7!);
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // ↑
        state.cut(state.pos);
        state.input.cut(state.pos);
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
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
        $4 = state.ok ? 3 : -1;
      }
      if ($4 == 3) {
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
          final $18 = state.input;
          if (state.pos >= $18.end && !$18.isClosed) {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          const $19 = ']';
          matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          state.input.endBuffering();
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
          state.backtrack($17!);
        }
        $13 &= ~0x10 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
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
      state.input.endBuffering();
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
      state.backtrack($1);
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
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        const $7 = 'u';
        matchLiteral1Async(state, $7, const ErrorExpectedTags([$7]));
        state.input.endBuffering();
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
        state.backtrack($5!);
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
  ///   @errorHandler(HexNumber_)
  ///   ;
  int? parseHexNumber(State<String> state) {
    int? $0;
    // @errorHandler(HexNumber_)
    final $2 = state.pos;
    final $3 = state.failPos;
    final $4 = state.errorCount;
    // HexNumber_
    // int @inline HexNumber_ = v:$[0-9A-Fa-f]{4,4} {} ;
    // v:$[0-9A-Fa-f]{4,4} {}
    String? $7;
    final $8 = state.pos;
    final $9 = state.pos;
    var $10 = 0;
    while ($10 < 4) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $11 = state.input.codeUnitAt(state.pos);
        state.ok = $11 <= 70
            ? $11 >= 48 && $11 <= 57 || $11 >= 65
            : $11 >= 97 && $11 <= 102;
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
      $10++;
    }
    state.setOk($10 == 4);
    if (!state.ok) {
      state.backtrack($9);
    }
    if (state.ok) {
      $7 = state.input.substring($8, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $7!;
      $$ = int.parse(v, radix: 16);
      $0 = $$;
    }
    if (!state.ok && state.canHandleError($3, $4)) {
      // ignore: unused_local_variable
      final start = $2;
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error =
          ErrorMessage(start - state.failPos, 'Expected 4 digit hex number');
      if (rollbackErrors == true) {
        state.rollbackErrors($3, $4);
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
  ///   @errorHandler(HexNumber_)
  ///   ;
  AsyncResult<int> parseHexNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    int? $3;
    int? $4;
    int? $5;
    String? $6;
    int? $7;
    int? $8;
    int? $10;
    int $13 = 0;
    void $1() {
      // @errorHandler(HexNumber_)
      // @errorHandler(HexNumber_)
      if ($13 & 0x2 == 0) {
        $13 |= 0x2;
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
      }
      // HexNumber_
      // HexNumber_
      // HexNumber_
      // v:$[0-9A-Fa-f]{4,4} {}
      // v:$[0-9A-Fa-f]{4,4} {}
      // $[0-9A-Fa-f]{4,4}
      if ($13 & 0x1 == 0) {
        $13 |= 0x1;
        state.input.beginBuffering();
        $7 = state.pos;
      }
      // [0-9A-Fa-f]{4,4}
      if ($8 == null) {
        $8 = 0;
        $10 = state.pos;
      }
      while (true) {
        // [0-9A-Fa-f]
        final $12 = state.input;
        if (state.pos >= $12.end && !$12.isClosed) {
          $12.sleep = true;
          $12.handle = $1;
          return;
        }
        final $11 = readChar16Async(state);
        if ($11 >= 0) {
          state.ok = $11 <= 70
              ? $11 >= 48 && $11 <= 57 || $11 >= 65
              : $11 >= 97 && $11 <= 102;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        }
        if (!state.ok) {
          break;
        }
        final $9 = $8! + 1;
        $8 = $9;
        if ($9 == 4) {
          break;
        }
      }
      state.setOk($8! == 4);
      if (!state.ok) {
        state.backtrack($10!);
      }
      $8 = null;
      if (state.ok) {
        final input = state.input;
        final start = input.start;
        final pos = $7!;
        $6 = input.data.substring(pos - start, state.pos - start);
      }
      state.input.endBuffering();
      $13 &= ~0x1 & 0xffff;
      if (state.ok) {
        int? $$;
        final v = $6!;
        $$ = int.parse(v, radix: 16);
        $2 = $$;
      }
      if (!state.ok && state.canHandleError($4!, $5!)) {
        // ignore: unused_local_variable
        final start = $3!;
        ParseError? error;
        // ignore: prefer_final_locals
        var rollbackErrors = false;
        rollbackErrors = true;
        error =
            ErrorMessage(start - state.failPos, 'Expected 4 digit hex number');
        if (rollbackErrors == true) {
          state.rollbackErrors($4!, $5!);
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
      $13 &= ~0x2 & 0xffff;
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
  ///   k:Key Colon ↑ v:Value {}
  ///   ;
  MapEntry<String, Object?>? parseKeyValue(State<String> state) {
    beginEvent(JsonParserEvent.keyValueEvent);
    MapEntry<String, Object?>? $0;
    // k:Key Colon ↑ v:Value {}
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
        state.backtrack($5);
      }
      if (state.ok) {
        state.cut(state.pos);
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
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    $0 = endEvent<MapEntry<String, Object?>>(
        JsonParserEvent.keyValueEvent, $0, state.ok);
    return $0;
  }

  /// @event
  /// MapEntry<String, Object?>
  /// KeyValue =
  ///   k:Key Colon ↑ v:Value {}
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
      // k:Key Colon ↑ v:Value {}
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
          final $12 = state.input;
          if (state.pos >= $12.end && !$12.isClosed) {
            $12.sleep = true;
            $12.handle = $1;
            return;
          }
          const $13 = ':';
          matchLiteral1Async(state, $13, const ErrorExpectedTags([$13]));
          state.input.endBuffering();
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
          state.backtrack($11!);
        }
        $9 &= ~0x8 & 0xffff;
        $5 = state.ok ? 2 : -1;
      }
      if ($5 == 2) {
        // ↑
        state.cut(state.pos);
        state.input.cut(state.pos);
        $5 = state.ok ? 3 : -1;
      }
      if ($5 == 3) {
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
        state.backtrack($6!);
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
  ///   @sepBy(KeyValue, Comma ↑)
  ///   ;
  List<MapEntry<String, Object?>>? parseKeyValues(State<String> state) {
    List<MapEntry<String, Object?>>? $0;
    // @sepBy(KeyValue, Comma ↑)
    final $2 = <MapEntry<String, Object?>>[];
    var $4 = state.pos;
    while (true) {
      MapEntry<String, Object?>? $3;
      // KeyValue
      // KeyValue
      $3 = parseKeyValue(state);
      if (!state.ok) {
        state.backtrack($4);
        break;
      }
      $2.add($3!);
      $4 = state.pos;
      // Comma ↑
      final $6 = state.pos;
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
        state.backtrack($7);
      }
      if (state.ok) {
        state.cut(state.pos);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// KeyValues =
  ///   @sepBy(KeyValue, Comma ↑)
  ///   ;
  AsyncResult<List<MapEntry<String, Object?>>> parseKeyValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<MapEntry<String, Object?>>>();
    List<MapEntry<String, Object?>>? $2;
    int? $3;
    List<MapEntry<String, Object?>>? $4;
    int? $6;
    AsyncResult<MapEntry<String, Object?>>? $7;
    int $9 = 0;
    int? $10;
    int? $11;
    int? $12;
    int? $13;
    Object? $16;
    AsyncResult<Object?>? $17;
    void $1() {
      // @sepBy(KeyValue, Comma ↑)
      // @sepBy(KeyValue, Comma ↑)
      if ($9 & 0x10 == 0) {
        $9 |= 0x10;
        $4 = [];
        $6 = state.pos;
        $3 = 0;
      }
      while (true) {
        if ($3 == 0) {
          MapEntry<String, Object?>? $5;
          // KeyValue
          // KeyValue
          if ($9 & 0x1 == 0) {
            $9 |= 0x1;
            $7 = parseKeyValue$Async(state);
            final $8 = $7!;
            if (!$8.isComplete) {
              $8.onComplete = $1;
              return;
            }
          }
          $5 = $7!.value;
          $9 &= ~0x1 & 0xffff;
          if (!state.ok) {
            state.backtrack($6!);
            $5 = null;
            break;
          }
          $4!.add($5!);
          $5 = null;
          $6 = state.pos;
          $3 = 1;
        }
        if ($3 == 1) {
          // Comma ↑
          if ($9 & 0x8 == 0) {
            $9 |= 0x8;
            $10 = 0;
            $11 = state.pos;
          }
          if ($10 == 0) {
            // Comma
            // v:',' Spaces
            // v:',' Spaces
            if ($9 & 0x4 == 0) {
              $9 |= 0x4;
              $12 = 0;
              $13 = state.pos;
            }
            if ($12 == 0) {
              // ','
              $16 ??= state.input.beginBuffering();
              final $14 = state.input;
              if (state.pos >= $14.end && !$14.isClosed) {
                $14.sleep = true;
                $14.handle = $1;
                return;
              }
              const $15 = ',';
              matchLiteral1Async(state, $15, const ErrorExpectedTags([$15]));
              state.input.endBuffering();
              $16 = null;
              $12 = state.ok ? 1 : -1;
            }
            if ($12 == 1) {
              // Spaces
              if ($9 & 0x2 == 0) {
                $9 |= 0x2;
                $17 = fastParseSpaces$Async(state);
                final $18 = $17!;
                if (!$18.isComplete) {
                  $18.onComplete = $1;
                  return;
                }
              }
              $9 &= ~0x2 & 0xffff;
              $12 = -1;
            }
            if (!state.ok) {
              state.backtrack($13!);
            }
            $9 &= ~0x4 & 0xffff;
            $10 = state.ok ? 1 : -1;
          }
          if ($10 == 1) {
            // ↑
            state.cut(state.pos);
            state.input.cut(state.pos);
            $10 = -1;
          }
          if (!state.ok) {
            state.backtrack($11!);
          }
          $9 &= ~0x8 & 0xffff;
          if (!state.ok) {
            break;
          }
          $3 = 0;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
        $4 = null;
      }
      $9 &= ~0x10 & 0xffff;
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
  ///   v:@expected('number' ,Number_) Spaces
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // v:@expected('number' ,Number_) Spaces
    final $1 = state.pos;
    num? $2;
    final $3 = state.pos;
    final $4 = state.failPos;
    final $5 = state.errorCount;
    // Number_
    // num @inline Number_ = v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {} ;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
    String? $8;
    final $9 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $10 = state.pos;
    matchChar16(state, 45);
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      // [0]
      matchChar16(state, 48);
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $12 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $13 = state.input.codeUnitAt(state.pos);
          state.ok = $13 >= 49 && $13 <= 57;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          while (true) {
            state.ok = state.pos < state.input.length;
            if (state.ok) {
              final $14 = state.input.codeUnitAt(state.pos);
              state.ok = $14 >= 48 && $14 <= 57;
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
          }
          state.setOk(true);
        }
        if (!state.ok) {
          state.backtrack($12);
        }
      }
      if (state.ok) {
        // [.] ↑ [0-9]+
        final $15 = state.pos;
        matchChar16(state, 46);
        if (state.ok) {
          state.cut(state.pos);
          if (state.ok) {
            var $16 = false;
            while (true) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $17 = state.input.codeUnitAt(state.pos);
                state.ok = $17 >= 48 && $17 <= 57;
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
              $16 = true;
            }
            state.setOk($16);
          }
        }
        if (!state.ok) {
          state.backtrack($15);
        }
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          // [eE] ↑ [-+]? [0-9]+
          final $18 = state.pos;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $19 = state.input.codeUnitAt(state.pos);
            state.ok = $19 == 69 || $19 == 101;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            state.cut(state.pos);
            if (state.ok) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $20 = state.input.codeUnitAt(state.pos);
                state.ok = $20 == 43 || $20 == 45;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
              if (!state.ok) {
                state.setOk(true);
              }
              if (state.ok) {
                var $21 = false;
                while (true) {
                  state.ok = state.pos < state.input.length;
                  if (state.ok) {
                    final $22 = state.input.codeUnitAt(state.pos);
                    state.ok = $22 >= 48 && $22 <= 57;
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
                  $21 = true;
                }
                state.setOk($21);
              }
            }
          }
          if (!state.ok) {
            state.backtrack($18);
          }
          if (!state.ok) {
            state.setOk(true);
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($10);
    }
    if (state.ok) {
      $8 = state.input.substring($9, state.pos);
    }
    if (state.ok) {
      num? $$;
      final v = $8!;
      $$ = num.parse(v);
      $2 = $$;
    }
    if (!state.ok && state.canHandleError($4, $5)) {
      if (state.failPos == $3) {
        state.rollbackErrors($4, $5);
        state.fail(const ErrorExpectedTags(['number']));
      }
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// num
  /// Number =
  ///   v:@expected('number' ,Number_) Spaces
  ///   ;
  AsyncResult<num> parseNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $2;
    int? $4;
    int? $5;
    num? $3;
    int? $6;
    int? $7;
    int? $8;
    String? $9;
    int? $10;
    int? $11;
    int? $12;
    int? $14;
    int? $16;
    int? $17;
    int $22 = 0;
    int? $23;
    int? $24;
    bool? $26;
    int? $29;
    int? $30;
    bool? $35;
    AsyncResult<Object?>? $38;
    void $1() {
      // v:@expected('number' ,Number_) Spaces
      if ($22 & 0x100 == 0) {
        $22 |= 0x100;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // @expected('number' ,Number_)
        if ($22 & 0x40 == 0) {
          $22 |= 0x40;
          $6 = state.pos;
          $7 = state.failPos;
          $8 = state.errorCount;
        }
        // Number_
        // Number_
        // Number_
        // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
        // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
        // $([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?)
        if ($22 & 0x20 == 0) {
          $22 |= 0x20;
          state.input.beginBuffering();
          $10 = state.pos;
        }
        // ([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?)
        // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
        // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
        if ($22 & 0x10 == 0) {
          $22 |= 0x10;
          $11 = 0;
          $12 = state.pos;
        }
        if ($11 == 0) {
          // [-]?
          // [-]
          final $13 = state.input;
          if (state.pos >= $13.end && !$13.isClosed) {
            $13.sleep = true;
            $13.handle = $1;
            return;
          }
          matchChar16Async(state, 45);
          if (!state.ok) {
            state.setOk(true);
          }
          $11 = state.ok ? 1 : -1;
        }
        if ($11 == 1) {
          // ([0] / [1-9] [0-9]*)
          // [0] / [1-9] [0-9]*
          if ($22 & 0x2 == 0) {
            $22 |= 0x2;
            $14 = 0;
          }
          if ($14 == 0) {
            // [0]
            // [0]
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              return;
            }
            matchChar16Async(state, 48);
            $14 = state.ok
                ? -1
                : state.isRecoverable
                    ? 1
                    : -1;
          }
          if ($14 == 1) {
            // [1-9] [0-9]*
            if ($22 & 0x1 == 0) {
              $22 |= 0x1;
              $16 = 0;
              $17 = state.pos;
            }
            if ($16 == 0) {
              // [1-9]
              final $19 = state.input;
              if (state.pos >= $19.end && !$19.isClosed) {
                $19.sleep = true;
                $19.handle = $1;
                return;
              }
              final $18 = readChar16Async(state);
              if ($18 >= 0) {
                state.ok = $18 >= 49 && $18 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              $16 = state.ok ? 1 : -1;
            }
            if ($16 == 1) {
              // [0-9]*
              while (true) {
                // [0-9]
                final $21 = state.input;
                if (state.pos >= $21.end && !$21.isClosed) {
                  $21.sleep = true;
                  $21.handle = $1;
                  return;
                }
                final $20 = readChar16Async(state);
                if ($20 >= 0) {
                  state.ok = $20 >= 48 && $20 <= 57;
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
              state.setOk(true);
              $16 = -1;
            }
            if (!state.ok) {
              state.backtrack($17!);
            }
            $22 &= ~0x1 & 0xffff;
            $14 = -1;
          }
          $22 &= ~0x2 & 0xffff;
          $11 = state.ok ? 2 : -1;
        }
        if ($11 == 2) {
          // ([.] ↑ [0-9]+)?
          // ([.] ↑ [0-9]+)
          // [.] ↑ [0-9]+
          // [.] ↑ [0-9]+
          if ($22 & 0x4 == 0) {
            $22 |= 0x4;
            $23 = 0;
            $24 = state.pos;
          }
          if ($23 == 0) {
            // [.]
            final $25 = state.input;
            if (state.pos >= $25.end && !$25.isClosed) {
              $25.sleep = true;
              $25.handle = $1;
              return;
            }
            matchChar16Async(state, 46);
            $23 = state.ok ? 1 : -1;
          }
          if ($23 == 1) {
            // ↑
            state.cut(state.pos);
            state.input.cut(state.pos);
            $23 = state.ok ? 2 : -1;
          }
          if ($23 == 2) {
            // [0-9]+
            $26 ??= false;
            while (true) {
              // [0-9]
              final $28 = state.input;
              if (state.pos >= $28.end && !$28.isClosed) {
                $28.sleep = true;
                $28.handle = $1;
                return;
              }
              final $27 = readChar16Async(state);
              if ($27 >= 0) {
                state.ok = $27 >= 48 && $27 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $26 = true;
            }
            state.setOk($26!);
            $26 = null;
            $23 = -1;
          }
          if (!state.ok) {
            state.backtrack($24!);
          }
          $22 &= ~0x4 & 0xffff;
          if (!state.ok) {
            state.setOk(true);
          }
          $11 = state.ok ? 3 : -1;
        }
        if ($11 == 3) {
          // ([eE] ↑ [-+]? [0-9]+)?
          // ([eE] ↑ [-+]? [0-9]+)
          // [eE] ↑ [-+]? [0-9]+
          // [eE] ↑ [-+]? [0-9]+
          if ($22 & 0x8 == 0) {
            $22 |= 0x8;
            $29 = 0;
            $30 = state.pos;
          }
          if ($29 == 0) {
            // [eE]
            final $32 = state.input;
            if (state.pos >= $32.end && !$32.isClosed) {
              $32.sleep = true;
              $32.handle = $1;
              return;
            }
            final $31 = readChar16Async(state);
            if ($31 >= 0) {
              state.ok = $31 == 69 || $31 == 101;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            $29 = state.ok ? 1 : -1;
          }
          if ($29 == 1) {
            // ↑
            state.cut(state.pos);
            state.input.cut(state.pos);
            $29 = state.ok ? 2 : -1;
          }
          if ($29 == 2) {
            // [-+]?
            // [-+]
            final $34 = state.input;
            if (state.pos >= $34.end && !$34.isClosed) {
              $34.sleep = true;
              $34.handle = $1;
              return;
            }
            final $33 = readChar16Async(state);
            if ($33 >= 0) {
              state.ok = $33 == 43 || $33 == 45;
              if (state.ok) {
                state.pos++;
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            }
            if (!state.ok) {
              state.setOk(true);
            }
            $29 = state.ok ? 3 : -1;
          }
          if ($29 == 3) {
            // [0-9]+
            $35 ??= false;
            while (true) {
              // [0-9]
              final $37 = state.input;
              if (state.pos >= $37.end && !$37.isClosed) {
                $37.sleep = true;
                $37.handle = $1;
                return;
              }
              final $36 = readChar16Async(state);
              if ($36 >= 0) {
                state.ok = $36 >= 48 && $36 <= 57;
                if (state.ok) {
                  state.pos++;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $35 = true;
            }
            state.setOk($35!);
            $35 = null;
            $29 = -1;
          }
          if (!state.ok) {
            state.backtrack($30!);
          }
          $22 &= ~0x8 & 0xffff;
          if (!state.ok) {
            state.setOk(true);
          }
          $11 = -1;
        }
        if (!state.ok) {
          state.backtrack($12!);
        }
        $22 &= ~0x10 & 0xffff;
        if (state.ok) {
          final input = state.input;
          final start = input.start;
          final pos = $10!;
          $9 = input.data.substring(pos - start, state.pos - start);
        }
        state.input.endBuffering();
        $22 &= ~0x20 & 0xffff;
        if (state.ok) {
          num? $$;
          final v = $9!;
          $$ = num.parse(v);
          $3 = $$;
        }
        if (!state.ok && state.canHandleError($7!, $8!)) {
          if (state.failPos == $6!) {
            state.rollbackErrors($7!, $8!);
            state.fail(const ErrorExpectedTags(['number']));
          }
        }
        $22 &= ~0x40 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // Spaces
        if ($22 & 0x80 == 0) {
          $22 |= 0x80;
          $38 = fastParseSpaces$Async(state);
          final $39 = $38!;
          if (!$39.isComplete) {
            $39.onComplete = $1;
            return;
          }
        }
        $22 &= ~0x80 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
      }
      $22 &= ~0x100 & 0xffff;
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
  ///   OpenBrace ↑ kv:KeyValues CloseBrace {}
  ///   ;
  Map<String, Object?>? parseObject(State<String> state) {
    beginEvent(JsonParserEvent.objectEvent);
    Map<String, Object?>? $0;
    // OpenBrace ↑ kv:KeyValues CloseBrace {}
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
      state.backtrack($3);
    }
    if (state.ok) {
      state.cut(state.pos);
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
            state.backtrack($5);
          }
          if (state.ok) {
            Map<String, Object?>? $$;
            final kv = $2!;
            $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    $0 = endEvent<Map<String, Object?>>(
        JsonParserEvent.objectEvent, $0, state.ok);
    return $0;
  }

  /// @event
  /// Map<String, Object?>
  /// Object =
  ///   OpenBrace ↑ kv:KeyValues CloseBrace {}
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
      // OpenBrace ↑ kv:KeyValues CloseBrace {}
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
          final $8 = state.input;
          if (state.pos >= $8.end && !$8.isClosed) {
            $8.sleep = true;
            $8.handle = $1;
            return;
          }
          const $9 = '{';
          matchLiteral1Async(state, $9, const ErrorExpectedTags([$9]));
          state.input.endBuffering();
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
          state.backtrack($7!);
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // ↑
        state.cut(state.pos);
        state.input.cut(state.pos);
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
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
        $4 = state.ok ? 3 : -1;
      }
      if ($4 == 3) {
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
          final $18 = state.input;
          if (state.pos >= $18.end && !$18.isClosed) {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          const $19 = '}';
          matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          state.input.endBuffering();
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
          state.backtrack($17!);
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
        state.backtrack($5!);
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
  ///   Spaces v:Value @eof()
  ///   ;
  Object? parseStart(State<String> state) {
    beginEvent(JsonParserEvent.startEvent);
    Object? $0;
    // Spaces v:Value @eof()
    final $1 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      Object? $2;
      // Value
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
      state.backtrack($1);
    }
    $0 = endEvent<Object?>(JsonParserEvent.startEvent, $0, state.ok);
    return $0;
  }

  /// @event
  /// Start =
  ///   Spaces v:Value @eof()
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
    void $1() {
      // Spaces v:Value @eof()
      if ($8 & 0x4 == 0) {
        $8 |= 0x4;
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
        // @eof()
        final $11 = state.input;
        if (state.pos >= $11.end && !$11.isClosed) {
          $11.sleep = true;
          $11.handle = $1;
          return;
        }
        state.ok = state.pos >= $11.end;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
      }
      $8 &= ~0x4 & 0xffff;
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
  ///   '"' ↑ v:StringChars Quote
  ///   ;
  String? parseString(State<String> state) {
    String? $0;
    // '"' ↑ v:StringChars Quote
    final $1 = state.pos;
    const $3 = '"';
    matchLiteral1(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      state.cut(state.pos);
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
              final $10 = state.input.runeAt(state.pos);
              state.ok = $10 <= 91
                  ? $10 >= 32 && $10 <= 33 || $10 >= 35
                  : $10 >= 93 && $10 <= 1114111;
              if (state.ok) {
                state.pos += $10 > 0xffff ? 2 : 1;
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
          state.setOk($9);
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
          matchChar16(state, 92);
          if (!state.ok) {
            break;
          }
          String? $6;
          // (EscapeChar / EscapeHex)
          // EscapeChar
          // EscapeChar
          $6 = parseEscapeChar(state);
          if (!state.ok && state.isRecoverable) {
            // EscapeHex
            // EscapeHex
            $6 = parseEscapeHex(state);
          }
          if (!state.ok) {
            state.backtrack(pos);
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
          matchLiteral1(state, $19, const ErrorExpectedTags([$19]));
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($18);
          }
          if (state.ok) {
            $0 = $2;
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    return $0;
  }

  /// String
  /// String =
  ///   '"' ↑ v:StringChars Quote
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
    List<String>? $13;
    String? $14;
    String? $11;
    int? $15;
    bool? $16;
    int $19 = 0;
    Object? $21;
    String? $12;
    int? $22;
    AsyncResult<String>? $23;
    AsyncResult<String>? $25;
    int? $27;
    int? $28;
    Object? $31;
    AsyncResult<Object?>? $32;
    void $1() {
      // '"' ↑ v:StringChars Quote
      if ($19 & 0x80 == 0) {
        $19 |= 0x80;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // '"'
        $8 ??= state.input.beginBuffering();
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        const $7 = '"';
        matchLiteral1Async(state, $7, const ErrorExpectedTags([$7]));
        state.input.endBuffering();
        $8 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // ↑
        state.cut(state.pos);
        state.input.cut(state.pos);
        $4 = state.ok ? 2 : -1;
      }
      if ($4 == 2) {
        // StringChars
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        if ($19 & 0x10 == 0) {
          $19 |= 0x10;
          $13 = null;
          $14 = null;
          $9 = 0;
        }
        while (true) {
          if ($9 == 0) {
            // $[ -!#-[\]-\u{10ffff}]+
            // $[ -!#-[\]-\u{10ffff}]+
            // $[ -!#-[\]-\u{10ffff}]+
            if ($19 & 0x1 == 0) {
              $19 |= 0x1;
              state.input.beginBuffering();
              $15 = state.pos;
            }
            // [ -!#-[\]-\u{10ffff}]+
            $16 ??= false;
            while (true) {
              // [ -!#-[\]-\u{10ffff}]
              final $18 = state.input;
              if (state.pos >= $18.end && !$18.isClosed) {
                $18.sleep = true;
                $18.handle = $1;
                return;
              }
              final $17 = readChar32Async(state);
              if ($17 >= 0) {
                state.ok = $17 <= 91
                    ? $17 >= 32 && $17 <= 33 || $17 >= 35
                    : $17 >= 93 && $17 <= 1114111;
                if (state.ok) {
                  state.pos += $17 > 0xffff ? 2 : 1;
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
              if (!state.ok) {
                break;
              }
              $16 = true;
            }
            state.setOk($16!);
            $16 = null;
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              final pos = $15!;
              $11 = input.data.substring(pos - start, state.pos - start);
            }
            state.input.endBuffering();
            $19 &= ~0x1 & 0xffff;
            if (state.ok) {
              final v = $11!;
              if ($14 == null) {
                $14 = v;
              } else if ($13 == null) {
                $13 = [$14!, v];
              } else {
                $13!.add(v);
              }
            }
            $10 = state.pos;
            $9 = 1;
          }
          if ($9 == 1) {
            // [\\]
            // [\\]
            // [\\]
            $21 ??= state.input.beginBuffering();
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              return;
            }
            matchChar16Async(state, 92);
            state.input.endBuffering();
            $21 = null;
            if (!state.ok) {
              break;
            }
            $9 = 2;
          }
          if ($9 == 2) {
            // (EscapeChar / EscapeHex)
            // (EscapeChar / EscapeHex)
            // (EscapeChar / EscapeHex)
            // EscapeChar / EscapeHex
            if ($19 & 0x8 == 0) {
              $19 |= 0x8;
              $22 = 0;
            }
            if ($22 == 0) {
              // EscapeChar
              // EscapeChar
              if ($19 & 0x2 == 0) {
                $19 |= 0x2;
                $23 = parseEscapeChar$Async(state);
                final $24 = $23!;
                if (!$24.isComplete) {
                  $24.onComplete = $1;
                  return;
                }
              }
              $12 = $23!.value;
              $19 &= ~0x2 & 0xffff;
              $22 = state.ok
                  ? -1
                  : state.isRecoverable
                      ? 1
                      : -1;
            }
            if ($22 == 1) {
              // EscapeHex
              // EscapeHex
              if ($19 & 0x4 == 0) {
                $19 |= 0x4;
                $25 = parseEscapeHex$Async(state);
                final $26 = $25!;
                if (!$26.isComplete) {
                  $26.onComplete = $1;
                  return;
                }
              }
              $12 = $25!.value;
              $19 &= ~0x4 & 0xffff;
              $22 = -1;
            }
            $19 &= ~0x8 & 0xffff;
            if (!state.ok) {
              state.backtrack($10!);
              break;
            }
            if ($14 == null) {
              $14 = $12!;
            } else {
              if ($13 == null) {
                $13 = [$14!, $12!];
              } else {
                $13!.add($12!);
              }
            }
            $9 = 0;
          }
        }
        state.ok = true;
        if ($14 == null) {
          $3 = '';
        } else if ($13 == null) {
          $3 = $14!;
        } else {
          $3 = $13!.join();
        }
        $19 &= ~0x10 & 0xffff;
        $4 = state.ok ? 3 : -1;
      }
      if ($4 == 3) {
        // Quote
        // v:'"' Spaces
        // v:'"' Spaces
        if ($19 & 0x40 == 0) {
          $19 |= 0x40;
          $27 = 0;
          $28 = state.pos;
        }
        if ($27 == 0) {
          // '"'
          $31 ??= state.input.beginBuffering();
          final $29 = state.input;
          if (state.pos >= $29.end && !$29.isClosed) {
            $29.sleep = true;
            $29.handle = $1;
            return;
          }
          const $30 = '"';
          matchLiteral1Async(state, $30, const ErrorExpectedTags([$30]));
          state.input.endBuffering();
          $31 = null;
          $27 = state.ok ? 1 : -1;
        }
        if ($27 == 1) {
          // Spaces
          if ($19 & 0x20 == 0) {
            $19 |= 0x20;
            $32 = fastParseSpaces$Async(state);
            final $33 = $32!;
            if (!$33.isComplete) {
              $33.onComplete = $1;
              return;
            }
          }
          $19 &= ~0x20 & 0xffff;
          $27 = -1;
        }
        if (!state.ok) {
          state.backtrack($28!);
        }
        $19 &= ~0x40 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
      }
      $19 &= ~0x80 & 0xffff;
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
    if (!state.ok && state.isRecoverable) {
      // String
      // String
      $0 = parseString(state);
      if (!state.ok && state.isRecoverable) {
        // Object
        // Object
        $0 = parseObject(state);
        if (!state.ok && state.isRecoverable) {
          // Array
          // Array
          $0 = parseArray(state);
          if (!state.ok && state.isRecoverable) {
            // Number
            // Number
            $0 = parseNumber(state);
            if (!state.ok && state.isRecoverable) {
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
                state.backtrack($7);
              }
              if (!state.ok && state.isRecoverable) {
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
                  state.backtrack($10);
                }
                if (!state.ok && state.isRecoverable) {
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
                    state.backtrack($13);
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
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 1
                : -1;
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
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 2
                : -1;
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
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 3
                : -1;
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
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 4
                : -1;
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
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 5
                : -1;
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
          if (state.pos + 3 >= $17.end && !$17.isClosed) {
            $17.sleep = true;
            $17.handle = $1;
            return;
          }
          const string = 'true';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          state.input.endBuffering();
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
          state.backtrack($16!);
        }
        $6 &= ~0x40 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 6
                : -1;
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
          if (state.pos + 4 >= $23.end && !$23.isClosed) {
            $23.sleep = true;
            $23.handle = $1;
            return;
          }
          const string = 'false';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          state.input.endBuffering();
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
          state.backtrack($22!);
        }
        $6 &= ~0x100 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 7
                : -1;
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
          if (state.pos + 3 >= $29.end && !$29.isClosed) {
            $29.sleep = true;
            $29.handle = $1;
            return;
          }
          const string = 'null';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          state.input.endBuffering();
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
          state.backtrack($28!);
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
  ///   @sepBy(Value, Comma ↑)
  ///   ;
  List<Object?>? parseValues(State<String> state) {
    List<Object?>? $0;
    // @sepBy(Value, Comma ↑)
    final $2 = <Object?>[];
    var $4 = state.pos;
    while (true) {
      Object? $3;
      // Value
      // Value
      $3 = parseValue(state);
      if (!state.ok) {
        state.backtrack($4);
        break;
      }
      $2.add($3);
      $4 = state.pos;
      // Comma ↑
      final $6 = state.pos;
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
        state.backtrack($7);
      }
      if (state.ok) {
        state.cut(state.pos);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok) {
        break;
      }
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// Values =
  ///   @sepBy(Value, Comma ↑)
  ///   ;
  AsyncResult<List<Object?>> parseValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $3;
    List<Object?>? $4;
    int? $6;
    AsyncResult<Object?>? $7;
    int $9 = 0;
    int? $10;
    int? $11;
    int? $12;
    int? $13;
    Object? $16;
    AsyncResult<Object?>? $17;
    void $1() {
      // @sepBy(Value, Comma ↑)
      // @sepBy(Value, Comma ↑)
      if ($9 & 0x10 == 0) {
        $9 |= 0x10;
        $4 = [];
        $6 = state.pos;
        $3 = 0;
      }
      while (true) {
        if ($3 == 0) {
          Object? $5;
          // Value
          // Value
          if ($9 & 0x1 == 0) {
            $9 |= 0x1;
            $7 = parseValue$Async(state);
            final $8 = $7!;
            if (!$8.isComplete) {
              $8.onComplete = $1;
              return;
            }
          }
          $5 = $7!.value;
          $9 &= ~0x1 & 0xffff;
          if (!state.ok) {
            state.backtrack($6!);
            $5 = null;
            break;
          }
          $4!.add($5);
          $5 = null;
          $6 = state.pos;
          $3 = 1;
        }
        if ($3 == 1) {
          // Comma ↑
          if ($9 & 0x8 == 0) {
            $9 |= 0x8;
            $10 = 0;
            $11 = state.pos;
          }
          if ($10 == 0) {
            // Comma
            // v:',' Spaces
            // v:',' Spaces
            if ($9 & 0x4 == 0) {
              $9 |= 0x4;
              $12 = 0;
              $13 = state.pos;
            }
            if ($12 == 0) {
              // ','
              $16 ??= state.input.beginBuffering();
              final $14 = state.input;
              if (state.pos >= $14.end && !$14.isClosed) {
                $14.sleep = true;
                $14.handle = $1;
                return;
              }
              const $15 = ',';
              matchLiteral1Async(state, $15, const ErrorExpectedTags([$15]));
              state.input.endBuffering();
              $16 = null;
              $12 = state.ok ? 1 : -1;
            }
            if ($12 == 1) {
              // Spaces
              if ($9 & 0x2 == 0) {
                $9 |= 0x2;
                $17 = fastParseSpaces$Async(state);
                final $18 = $17!;
                if (!$18.isComplete) {
                  $18.onComplete = $1;
                  return;
                }
              }
              $9 &= ~0x2 & 0xffff;
              $12 = -1;
            }
            if (!state.ok) {
              state.backtrack($13!);
            }
            $9 &= ~0x4 & 0xffff;
            $10 = state.ok ? 1 : -1;
          }
          if ($10 == 1) {
            // ↑
            state.cut(state.pos);
            state.input.cut(state.pos);
            $10 = -1;
          }
          if (!state.ok) {
            state.backtrack($11!);
          }
          $9 &= ~0x8 & 0xffff;
          if (!state.ok) {
            break;
          }
          $3 = 0;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
        $4 = null;
      }
      $9 &= ~0x10 & 0xffff;
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
  int readChar16Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      return input.data.codeUnitAt(pos - start);
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    return -1;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int readChar32Async(State<ChunkedParsingSink> state) {
    final input = state.input;
    final start = input.start;
    final pos = state.pos;
    if (pos < input.end) {
      return input.data.runeAt(pos - start);
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
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
    message = _errorMessage(input, 0, offset, normalized);
  } else if (input is ChunkedParsingSink) {
    message = _errorMessage(input.data, input.start, offset, normalized);
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
    String source, int inputStart, int offset, List<ErrorMessage> errors) {
  final sb = StringBuffer();
  final errorInfoList = errors
      .map((e) => (length: e.length, message: e.toString()))
      .toSet()
      .toList();
  final offsets =
      errors.map((e) => e.length < 0 ? offset - e.length : offset).toSet();
  final offsetMap = <int, ({int line, int column})>{};
  if (inputStart == 0) {
    var line = 1;
    var lineStart = 0, next = 0, pos = 0;
    while (pos < source.length) {
      final found = offsets.any((e) => pos == e);
      if (found) {
        final column = pos - lineStart + 1;
        offsetMap[pos] = (line: line, column: column);
        offsets.remove(pos);
        if (offsets.isEmpty) {
          break;
        }
      }

      final c = source.codeUnitAt(pos++);
      if (c == 0xa || c == 0xd) {
        next = c == 0xa ? 0xd : 0xa;
        if (pos < source.length && source.codeUnitAt(pos) == next) {
          pos++;
        }

        line++;
        lineStart = pos;
      }
    }
  }

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
    final inputLen = source.length;
    final lineLimit = min(80, inputLen);
    final start2 = start;
    final end2 = min(start2 + lineLimit, end);
    final errorLen = end2 - start;
    final extraLen = lineLimit - errorLen;
    final rightLen =
        min(inputStart + inputLen - end2, extraLen - (extraLen >> 1));
    final leftLen =
        min(start - inputStart, max(0, lineLimit - errorLen - rightLen));
    var index = start2 - 1 - inputStart;
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

    final left = String.fromCharCodes(list.reversed);
    final end3 = min(inputLen, start2 + (lineLimit - leftLen));
    final indicatorLen = max(1, errorLen);
    final right = source.substring(start - inputStart, end3);
    var text = left + right;
    text = text.replaceAll('\n', ' ');
    text = text.replaceAll('\r', ' ');
    text = text.replaceAll('\t', ' ');
    final location = offsetMap[start];
    if (location != null) {
      final line = location.line;
      final column = location.column;
      sb.writeln('line $line, column $column (offset $start): $message');
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
    if (error is ErrorUnexpectedInput) {
      key = (ErrorUnexpectedInput, error.length);
    } else if (error is ErrorUnknownError) {
      key = ErrorUnknownError;
    } else if (error is ErrorUnexpectedCharacter) {
      key = (ErrorUnexpectedCharacter, error.char);
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

  int _cuttingPosition = 0;

  String data = '';

  int end = 0;

  void Function()? handle;

  bool sleep = false;

  int start = 0;

  int _buffering = 0;

  bool _isClosed = false;

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

    if (_cuttingPosition > start) {
      if (_cuttingPosition == end) {
        this.data = '';
      } else {
        this.data = this.data.substring(_cuttingPosition - start);
      }

      start = _cuttingPosition;
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

  void cut(int position) {
    if (position < start || position > end) {
      throw RangeError.range(position, start, end, 'position');
    }

    if (_buffering == 0) {
      _cuttingPosition = position;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void endBuffering() {
    if (--_buffering < 0) {
      throw StateError('Inconsistent buffering completion detected.');
    }
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
    if (offset != null && offset >= 0) {
      if (input is String) {
        if (offset < input.length) {
          char = input.runeAt(offset);
        } else {
          argument = '<EOF>';
        }
      } else if (input is ChunkedParsingSink) {
        if (offset >= input.start && offset <= input.end) {
          final index = offset - input.start;
          char = input.data.runeAt(index);
        } else if (input.isClosed && offset >= input.end) {
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

  int cuttingPos = 0;

  final List<ParseError?> errors = List.filled(64, null, growable: false);

  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool isRecoverable = true;

  bool ok = false;

  int pos = 0;

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void backtrack(int pos) {
    if (pos >= cuttingPos) {
      this.pos = pos;
      return;
    }
    isRecoverable = false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  bool canHandleError(int failPos, int errorCount) {
    return failPos == this.failPos
        ? errorCount < this.errorCount
        : failPos < this.failPos;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void cut(int pos) {
    if (cuttingPos < pos) {
      cuttingPos = pos;
    }
  }

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

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  void rollbackErrors(int failPos, int errorCount) {
    if (this.failPos == failPos) {
      this.errorCount = errorCount;
    } else if (this.failPos > failPos) {
      this.errorCount = 0;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void setOk(bool ok) {
    this.ok = !ok ? false : isRecoverable;
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
}

extension ParseStringExt on String {
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

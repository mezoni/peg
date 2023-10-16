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
    for (var c = 0;
        state.pos < state.input.length &&
            (c = state.input.codeUnitAt(state.pos)) == c &&
            (c == 13 || c >= 9 && c <= 10 || c == 32);
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        state.pos++);
    state.ok = true;
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    void $1() {
      // [ \n\r\t]*
      // [ \n\r\t]*
      while (true) {
        // [ \n\r\t]
        final $3 = state.input;
        if (state.pos >= $3.end && !$3.isClosed) {
          $3.sleep = true;
          $3.handle = $1;
          return;
        }
        state.ok = state.pos < $3.end;
        if (state.ok) {
          final $2 = $3.data.codeUnitAt(state.pos - $3.start);
          state.ok = $2 == 13 || $2 >= 9 && $2 <= 10 || $2 == 32;
          if (state.ok) {
            state.pos++;
          }
        }
        if (!state.ok) {
          state.fail(const ErrorUnexpectedCharacter());
        }
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
    state.ok = pos < input.end &&
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
    final $3 = state.pos;
    var $2 = true;
    // @inline OpenBracket = v:'[' Spaces ;
    // v:'[' Spaces
    final $4 = state.pos;
    const $5 = '[';
    matchLiteral1(state, $5, const ErrorExpectedTags([$5]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $2 = false;
      state.ok = true;
      if (state.ok) {
        List<Object?>? $1;
        // Values
        $1 = parseValues(state);
        if (state.ok) {
          // @inline CloseBracket = v:']' Spaces ;
          // v:']' Spaces
          final $6 = state.pos;
          const $7 = ']';
          matchLiteral1(state, $7, const ErrorExpectedTags([$7]));
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($6);
          }
          if (state.ok) {
            $0 = $1;
          }
        }
      }
    }
    if (!state.ok) {
      if (!$2) {
        state.isRecoverable = false;
      }
      state.backtrack($3);
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
    bool? $6;
    int? $7;
    int? $8;
    AsyncResult<Object?>? $11;
    int $13 = 0;
    List<Object?>? $3;
    AsyncResult<List<Object?>>? $14;
    int? $16;
    int? $17;
    AsyncResult<Object?>? $20;
    void $1() {
      // OpenBracket ↑ v:Values CloseBracket
      if ($13 & 0x20 == 0) {
        $13 |= 0x20;
        $4 = 0;
        $5 = state.pos;
        $6 = true;
      }
      if ($4 == 0) {
        // OpenBracket
        // v:'[' Spaces
        // v:'[' Spaces
        if ($13 & 0x2 == 0) {
          $13 |= 0x2;
          $7 = 0;
          $8 = state.pos;
        }
        if ($7 == 0) {
          // '['
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          const $10 = '[';
          matchLiteral1Async(state, $10, const ErrorExpectedTags([$10]));
          $7 = state.ok ? 1 : -1;
        }
        if ($7 == 1) {
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
          $7 = -1;
        }
        if (!state.ok) {
          state.backtrack($8!);
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        $6 = false;
        // ↑
        state.ok = true;
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
          final $18 = state.input;
          if (state.pos >= $18.end && !$18.isClosed) {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          const $19 = ']';
          matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          $16 = state.ok ? 1 : -1;
        }
        if ($16 == 1) {
          // Spaces
          if ($13 & 0x8 == 0) {
            $13 |= 0x8;
            $20 = fastParseSpaces$Async(state);
            final $21 = $20!;
            if (!$21.isComplete) {
              $21.onComplete = $1;
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
        if (!$6!) {
          state.isRecoverable = false;
        }
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
    int? $1;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $3 = state.input.codeUnitAt(state.pos);
      state.ok = $3 == 98 ||
          ($3 < 98
              ? $3 == 47 || $3 == 34 || $3 == 92
              : $3 == 110 || ($3 < 110 ? $3 == 102 : $3 == 114 || $3 == 116));
      if (state.ok) {
        state.pos++;
        $1 = $3;
      }
    }
    if (!state.ok) {
      state.fail(const ErrorUnexpectedCharacter());
    }
    if (state.ok) {
      String? $$;
      final c = $1!;
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
    void $1() {
      // c:["/bfnrt\\] {}
      // ["/bfnrt\\]
      final $5 = state.input;
      if (state.pos >= $5.end && !$5.isClosed) {
        $5.sleep = true;
        $5.handle = $1;
        return;
      }
      $3 = null;
      state.ok = state.pos < $5.end;
      if (state.ok) {
        final $4 = $5.data.codeUnitAt(state.pos - $5.start);
        state.ok = $4 == 98 ||
            ($4 < 98
                ? $4 == 47 || $4 == 34 || $4 == 92
                : $4 == 110 || ($4 < 110 ? $4 == 102 : $4 == 114 || $4 == 116));
        if (state.ok) {
          state.pos++;
          $3 = $4;
        }
      }
      if (!state.ok) {
        state.fail(const ErrorUnexpectedCharacter());
      }
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
    final $2 = state.pos;
    const $3 = 'u';
    matchLiteral1(state, $3, const ErrorExpectedTags([$3]));
    if (state.ok) {
      int? $1;
      // HexNumber
      $1 = parseHexNumber(state);
      if (state.ok) {
        String? $$;
        final v = $1!;
        $$ = String.fromCharCode(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
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
    int? $3;
    AsyncResult<int>? $8;
    int $10 = 0;
    void $1() {
      // 'u' v:HexNumber {}
      if ($10 & 0x2 == 0) {
        $10 |= 0x2;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // 'u'
        final $6 = state.input;
        if (state.pos >= $6.end && !$6.isClosed) {
          $6.sleep = true;
          $6.handle = $1;
          return;
        }
        const $7 = 'u';
        matchLiteral1Async(state, $7, const ErrorExpectedTags([$7]));
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // HexNumber
        if ($10 & 0x1 == 0) {
          $10 |= 0x1;
          $8 = parseHexNumber$Async(state);
          final $9 = $8!;
          if (!$9.isComplete) {
            $9.onComplete = $1;
            return;
          }
        }
        $3 = $8!.value;
        $10 &= ~0x1 & 0xffff;
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
      $10 &= ~0x2 & 0xffff;
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
    final $5 = state.lastFailPos;
    state.lastFailPos = -1;
    // HexNumber_
    // int @inline HexNumber_ = v:$[0-9A-Fa-f]{4,4} {} ;
    // v:$[0-9A-Fa-f]{4,4} {}
    String? $7;
    final $9 = state.pos;
    final $10 = state.pos;
    var $11 = 0;
    while ($11 < 4) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $12 = state.input.codeUnitAt(state.pos);
        state.ok = $12 <= 70
            ? $12 >= 48 && $12 <= 57 || $12 >= 65
            : $12 >= 97 && $12 <= 102;
        if (state.ok) {
          state.pos++;
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
    state.setOk($11 == 4);
    if (!state.ok) {
      state.backtrack($10);
    }
    if (state.ok) {
      $7 = state.input.substring($9, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $7!;
      $$ = int.parse(v, radix: 16);
      $0 = $$;
    }
    if (!state.ok && state.lastFailPos >= state.failPos) {
      // ignore: unused_local_variable
      final start = $2;
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      rollbackErrors = true;
      error =
          ErrorMessage(start - state.failPos, 'Expected 4 digit hex number');
      if (rollbackErrors == true) {
        state.errorCount = state.lastFailPos > $3 ? 0 : $4;
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
    if (state.lastFailPos < $5) {
      state.lastFailPos = $5;
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
    int? $6;
    String? $7;
    int? $8;
    int? $9;
    int? $11;
    int $14 = 0;
    void $1() {
      // @errorHandler(HexNumber_)
      // @errorHandler(HexNumber_)
      if ($3 == null) {
        $3 = state.pos;
        $4 = state.failPos;
        $5 = state.errorCount;
        $6 = state.lastFailPos;
        state.lastFailPos = -1;
      }
      // HexNumber_
      // HexNumber_
      // HexNumber_
      // v:$[0-9A-Fa-f]{4,4} {}
      // v:$[0-9A-Fa-f]{4,4} {}
      // $[0-9A-Fa-f]{4,4}
      if ($14 & 0x1 == 0) {
        $14 |= 0x1;
        state.input.beginBuffering();
        $8 = state.pos;
      }
      // [0-9A-Fa-f]{4,4}
      if ($9 == null) {
        $9 = 0;
        $11 = state.pos;
      }
      while (true) {
        // [0-9A-Fa-f]
        final $13 = state.input;
        if (state.pos >= $13.end && !$13.isClosed) {
          $13.sleep = true;
          $13.handle = $1;
          return;
        }
        state.ok = state.pos < $13.end;
        if (state.ok) {
          final $12 = $13.data.codeUnitAt(state.pos - $13.start);
          state.ok = $12 <= 70
              ? $12 >= 48 && $12 <= 57 || $12 >= 65
              : $12 >= 97 && $12 <= 102;
          if (state.ok) {
            state.pos++;
          }
        }
        if (!state.ok) {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (!state.ok) {
          break;
        }
        final $10 = $9! + 1;
        $9 = $10;
        if ($10 == 4) {
          break;
        }
      }
      state.setOk($9! == 4);
      if (!state.ok) {
        state.backtrack($11!);
      }
      $9 = null;
      if (state.ok) {
        final input = state.input;
        final start = input.start;
        final pos = $8!;
        $7 = input.data.substring(pos - start, state.pos - start);
      }
      state.input.endBuffering();
      $14 &= ~0x1 & 0xffff;
      if (state.ok) {
        int? $$;
        final v = $7!;
        $$ = int.parse(v, radix: 16);
        $2 = $$;
      }
      if (!state.ok && state.lastFailPos >= state.failPos) {
        // ignore: unused_local_variable
        final start = $3!;
        ParseError? error;
        // ignore: prefer_final_locals
        var rollbackErrors = false;
        rollbackErrors = true;
        error =
            ErrorMessage(start - state.failPos, 'Expected 4 digit hex number');
        if (rollbackErrors == true) {
          state.errorCount = state.lastFailPos > $4! ? 0 : $5!;
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
      if (state.lastFailPos < $6!) {
        state.lastFailPos = $6!;
      }
      $3 = null;
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
    final $4 = state.pos;
    var $3 = true;
    String? $1;
    beginEvent(JsonParserEvent.keyEvent);
    // @inline @event Key = String ;
    // String
    // String
    $1 = parseString(state);
    $1 = endEvent<String>(JsonParserEvent.keyEvent, $1, state.ok);
    if (state.ok) {
      // @inline Colon = v:':' Spaces ;
      // v:':' Spaces
      final $6 = state.pos;
      const $7 = ':';
      matchLiteral1(state, $7, const ErrorExpectedTags([$7]));
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (state.ok) {
        $3 = false;
        state.ok = true;
        if (state.ok) {
          Object? $2;
          // Value
          $2 = parseValue(state);
          if (state.ok) {
            MapEntry<String, Object?>? $$;
            final k = $1!;
            final v = $2;
            $$ = MapEntry(k, v);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      if (!$3) {
        state.isRecoverable = false;
      }
      state.backtrack($4);
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
    bool? $7;
    String? $3;
    AsyncResult<String>? $8;
    int $10 = 0;
    int? $11;
    int? $12;
    AsyncResult<Object?>? $15;
    Object? $4;
    AsyncResult<Object?>? $17;
    void $1() {
      // k:Key Colon ↑ v:Value {}
      if ($10 & 0x20 == 0) {
        $10 |= 0x20;
        $5 = 0;
        $6 = state.pos;
        $7 = true;
      }
      if ($5 == 0) {
        // Key
        if ($10 & 0x2 == 0) {
          $10 |= 0x2;
          beginEvent(JsonParserEvent.keyEvent);
        }
        // String
        // String
        // String
        if ($10 & 0x1 == 0) {
          $10 |= 0x1;
          $8 = parseString$Async(state);
          final $9 = $8!;
          if (!$9.isComplete) {
            $9.onComplete = $1;
            return;
          }
        }
        $3 = $8!.value;
        $10 &= ~0x1 & 0xffff;
        $3 = endEvent<String>(JsonParserEvent.keyEvent, $3, state.ok);
        $10 &= ~0x2 & 0xffff;
        $5 = state.ok ? 1 : -1;
      }
      if ($5 == 1) {
        // Colon
        // v:':' Spaces
        // v:':' Spaces
        if ($10 & 0x8 == 0) {
          $10 |= 0x8;
          $11 = 0;
          $12 = state.pos;
        }
        if ($11 == 0) {
          // ':'
          final $13 = state.input;
          if (state.pos >= $13.end && !$13.isClosed) {
            $13.sleep = true;
            $13.handle = $1;
            return;
          }
          const $14 = ':';
          matchLiteral1Async(state, $14, const ErrorExpectedTags([$14]));
          $11 = state.ok ? 1 : -1;
        }
        if ($11 == 1) {
          // Spaces
          if ($10 & 0x4 == 0) {
            $10 |= 0x4;
            $15 = fastParseSpaces$Async(state);
            final $16 = $15!;
            if (!$16.isComplete) {
              $16.onComplete = $1;
              return;
            }
          }
          $10 &= ~0x4 & 0xffff;
          $11 = -1;
        }
        if (!state.ok) {
          state.backtrack($12!);
        }
        $10 &= ~0x8 & 0xffff;
        $5 = state.ok ? 2 : -1;
      }
      if ($5 == 2) {
        $7 = false;
        // ↑
        state.ok = true;
        state.input.cut(state.pos);
        $5 = state.ok ? 3 : -1;
      }
      if ($5 == 3) {
        // Value
        if ($10 & 0x10 == 0) {
          $10 |= 0x10;
          $17 = parseValue$Async(state);
          final $18 = $17!;
          if (!$18.isComplete) {
            $18.onComplete = $1;
            return;
          }
        }
        $4 = $17!.value;
        $10 &= ~0x10 & 0xffff;
        $5 = -1;
      }
      if (state.ok) {
        MapEntry<String, Object?>? $$;
        final k = $3!;
        final v = $4;
        $$ = MapEntry(k, v);
        $2 = $$;
      } else {
        if (!$7!) {
          state.isRecoverable = false;
        }
        state.backtrack($6!);
      }
      $10 &= ~0x20 & 0xffff;
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
  ///   @list(KeyValue, Comma ↑ v:KeyValue)
  ///   ;
  List<MapEntry<String, Object?>>? parseKeyValues(State<String> state) {
    List<MapEntry<String, Object?>>? $0;
    // @list(KeyValue, Comma ↑ v:KeyValue)
    final $2 = <MapEntry<String, Object?>>[];
    MapEntry<String, Object?>? $3;
    // KeyValue
    // KeyValue
    $3 = parseKeyValue(state);
    if (state.ok) {
      $2.add($3!);
      while (true) {
        MapEntry<String, Object?>? $4;
        // Comma ↑ v:KeyValue
        final $9 = state.pos;
        var $8 = true;
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $10 = state.pos;
        const $11 = ',';
        matchLiteral1(state, $11, const ErrorExpectedTags([$11]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($10);
        }
        if (state.ok) {
          $8 = false;
          state.ok = true;
          if (state.ok) {
            MapEntry<String, Object?>? $7;
            // KeyValue
            $7 = parseKeyValue(state);
            if (state.ok) {
              $4 = $7;
            }
          }
        }
        if (!state.ok) {
          if (!$8) {
            state.isRecoverable = false;
          }
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $2.add($4!);
      }
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// KeyValues =
  ///   @list(KeyValue, Comma ↑ v:KeyValue)
  ///   ;
  AsyncResult<List<MapEntry<String, Object?>>> parseKeyValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<MapEntry<String, Object?>>>();
    List<MapEntry<String, Object?>>? $2;
    int? $3;
    int? $4;
    List<MapEntry<String, Object?>>? $5;
    AsyncResult<MapEntry<String, Object?>>? $8;
    int $10 = 0;
    int? $12;
    int? $13;
    bool? $14;
    int? $15;
    int? $16;
    AsyncResult<Object?>? $19;
    MapEntry<String, Object?>? $11;
    AsyncResult<MapEntry<String, Object?>>? $21;
    void $1() {
      // @list(KeyValue, Comma ↑ v:KeyValue)
      // @list(KeyValue, Comma ↑ v:KeyValue)
      if ($3 == null) {
        $3 = state.pos;
        $4 = 0;
        $5 = [];
      }
      while (true) {
        if ($4 == 0) {
          MapEntry<String, Object?>? $6;
          // KeyValue
          // KeyValue
          if ($10 & 0x1 == 0) {
            $10 |= 0x1;
            $8 = parseKeyValue$Async(state);
            final $9 = $8!;
            if (!$9.isComplete) {
              $9.onComplete = $1;
              return;
            }
          }
          $6 = $8!.value;
          $10 &= ~0x1 & 0xffff;
          if (!state.ok) {
            break;
          }
          $5!.add($6!);
          $6 = null;
          $4 = 1;
        }
        if ($4 == 1) {
          MapEntry<String, Object?>? $7;
          // Comma ↑ v:KeyValue
          if ($10 & 0x10 == 0) {
            $10 |= 0x10;
            $12 = 0;
            $13 = state.pos;
            $14 = true;
          }
          if ($12 == 0) {
            // Comma
            // v:',' Spaces
            // v:',' Spaces
            if ($10 & 0x4 == 0) {
              $10 |= 0x4;
              $15 = 0;
              $16 = state.pos;
            }
            if ($15 == 0) {
              // ','
              final $17 = state.input;
              if (state.pos >= $17.end && !$17.isClosed) {
                $17.sleep = true;
                $17.handle = $1;
                return;
              }
              const $18 = ',';
              matchLiteral1Async(state, $18, const ErrorExpectedTags([$18]));
              $15 = state.ok ? 1 : -1;
            }
            if ($15 == 1) {
              // Spaces
              if ($10 & 0x2 == 0) {
                $10 |= 0x2;
                $19 = fastParseSpaces$Async(state);
                final $20 = $19!;
                if (!$20.isComplete) {
                  $20.onComplete = $1;
                  return;
                }
              }
              $10 &= ~0x2 & 0xffff;
              $15 = -1;
            }
            if (!state.ok) {
              state.backtrack($16!);
            }
            $10 &= ~0x4 & 0xffff;
            $12 = state.ok ? 1 : -1;
          }
          if ($12 == 1) {
            $14 = false;
            // ↑
            state.ok = true;
            state.input.cut(state.pos);
            $12 = state.ok ? 2 : -1;
          }
          if ($12 == 2) {
            // KeyValue
            if ($10 & 0x8 == 0) {
              $10 |= 0x8;
              $21 = parseKeyValue$Async(state);
              final $22 = $21!;
              if (!$22.isComplete) {
                $22.onComplete = $1;
                return;
              }
            }
            $11 = $21!.value;
            $10 &= ~0x8 & 0xffff;
            $12 = -1;
          }
          if (state.ok) {
            $7 = $11;
          } else {
            if (!$14!) {
              state.isRecoverable = false;
            }
            state.backtrack($13!);
          }
          $10 &= ~0x10 & 0xffff;
          if (!state.ok) {
            $4 = -1;
            break;
          }
          $5!.add($7!);
          $7 = null;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
        $5 = null;
      }
      $3 = null;
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
    final $2 = state.pos;
    num? $1;
    final $3 = state.pos;
    final $22 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // Number_
    // num @inline Number_ = v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {} ;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
    String? $7;
    final $9 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $10 = state.pos;
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 45;
    if (state.ok) {
      state.pos++;
    } else {
      state.fail(const ErrorUnexpectedCharacter());
    }
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      // [0]
      state.ok = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 48;
      if (state.ok) {
        state.pos++;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $12 = state.pos;
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $13 = state.input.codeUnitAt(state.pos);
          state.ok = $13 >= 49 && $13 <= 57;
          if (state.ok) {
            state.pos++;
          }
        }
        if (!state.ok) {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (state.ok) {
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.codeUnitAt(state.pos)) == c &&
                  (c >= 48 && c <= 57);
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              state.pos++);
          state.ok = true;
        }
        if (!state.ok) {
          state.backtrack($12);
        }
      }
      if (state.ok) {
        // [.] ↑ [0-9]+
        final $15 = state.pos;
        var $14 = true;
        state.ok = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 46;
        if (state.ok) {
          state.pos++;
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
        if (state.ok) {
          $14 = false;
          state.ok = true;
          if (state.ok) {
            var $16 = false;
            for (var c = 0;
                state.pos < state.input.length &&
                    (c = state.input.codeUnitAt(state.pos)) == c &&
                    (c >= 48 && c <= 57);
                state.pos++,
                // ignore: curly_braces_in_flow_control_structures, empty_statements
                $16 = true);
            state.ok = $16;
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
          }
        }
        if (!state.ok) {
          if (!$14) {
            state.isRecoverable = false;
          }
          state.backtrack($15);
        }
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          // [eE] ↑ [-+]? [0-9]+
          final $18 = state.pos;
          var $17 = true;
          state.ok = state.pos < state.input.length;
          if (state.ok) {
            final $19 = state.input.codeUnitAt(state.pos);
            state.ok = $19 == 69 || $19 == 101;
            if (state.ok) {
              state.pos++;
            }
          }
          if (!state.ok) {
            state.fail(const ErrorUnexpectedCharacter());
          }
          if (state.ok) {
            $17 = false;
            state.ok = true;
            if (state.ok) {
              state.ok = state.pos < state.input.length;
              if (state.ok) {
                final $20 = state.input.codeUnitAt(state.pos);
                state.ok = $20 == 43 || $20 == 45;
                if (state.ok) {
                  state.pos++;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
              }
              if (!state.ok) {
                state.setOk(true);
              }
              if (state.ok) {
                var $21 = false;
                for (var c = 0;
                    state.pos < state.input.length &&
                        (c = state.input.codeUnitAt(state.pos)) == c &&
                        (c >= 48 && c <= 57);
                    state.pos++,
                    // ignore: curly_braces_in_flow_control_structures, empty_statements
                    $21 = true);
                state.ok = $21;
                if (!state.ok) {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              }
            }
          }
          if (!state.ok) {
            if (!$17) {
              state.isRecoverable = false;
            }
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
      $7 = state.input.substring($9, state.pos);
    }
    if (state.ok) {
      num? $$;
      final v = $7!;
      $$ = num.parse(v);
      $1 = $$;
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['number']));
    }
    if (state.lastFailPos < $22) {
      state.lastFailPos = $22;
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $1;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
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
    bool? $25;
    bool? $27;
    int? $30;
    int? $31;
    bool? $32;
    bool? $37;
    AsyncResult<Object?>? $40;
    void $1() {
      // v:@expected('number' ,Number_) Spaces
      if ($22 & 0x80 == 0) {
        $22 |= 0x80;
        $4 = 0;
        $5 = state.pos;
      }
      if ($4 == 0) {
        // @expected('number' ,Number_)
        if ($6 == null) {
          $6 = state.pos;
          $7 = state.lastFailPos;
          $8 = state.errorCount;
          state.lastFailPos = -1;
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
          state.ok = state.pos < $13.end &&
              $13.data.codeUnitAt(state.pos - $13.start) == 45;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
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
            state.ok = state.pos < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 48;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
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
              state.ok = state.pos < $19.end;
              if (state.ok) {
                final $18 = $19.data.codeUnitAt(state.pos - $19.start);
                state.ok = $18 >= 49 && $18 <= 57;
                if (state.ok) {
                  state.pos++;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
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
                state.ok = state.pos < $21.end;
                if (state.ok) {
                  final $20 = $21.data.codeUnitAt(state.pos - $21.start);
                  state.ok = $20 >= 48 && $20 <= 57;
                  if (state.ok) {
                    state.pos++;
                  }
                }
                if (!state.ok) {
                  state.fail(const ErrorUnexpectedCharacter());
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
            $25 = true;
          }
          if ($23 == 0) {
            // [.]
            final $26 = state.input;
            if (state.pos >= $26.end && !$26.isClosed) {
              $26.sleep = true;
              $26.handle = $1;
              return;
            }
            state.ok = state.pos < $26.end &&
                $26.data.codeUnitAt(state.pos - $26.start) == 46;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
            $23 = state.ok ? 1 : -1;
          }
          if ($23 == 1) {
            $25 = false;
            // ↑
            state.ok = true;
            state.input.cut(state.pos);
            $23 = state.ok ? 2 : -1;
          }
          if ($23 == 2) {
            // [0-9]+
            $27 ??= false;
            while (true) {
              // [0-9]
              final $29 = state.input;
              if (state.pos >= $29.end && !$29.isClosed) {
                $29.sleep = true;
                $29.handle = $1;
                return;
              }
              state.ok = state.pos < $29.end;
              if (state.ok) {
                final $28 = $29.data.codeUnitAt(state.pos - $29.start);
                state.ok = $28 >= 48 && $28 <= 57;
                if (state.ok) {
                  state.pos++;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
              }
              if (!state.ok) {
                break;
              }
              $27 = true;
            }
            state.setOk($27!);
            $27 = null;
            $23 = -1;
          }
          if (!state.ok) {
            if (!$25!) {
              state.isRecoverable = false;
            }
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
            $30 = 0;
            $31 = state.pos;
            $32 = true;
          }
          if ($30 == 0) {
            // [eE]
            final $34 = state.input;
            if (state.pos >= $34.end && !$34.isClosed) {
              $34.sleep = true;
              $34.handle = $1;
              return;
            }
            state.ok = state.pos < $34.end;
            if (state.ok) {
              final $33 = $34.data.codeUnitAt(state.pos - $34.start);
              state.ok = $33 == 69 || $33 == 101;
              if (state.ok) {
                state.pos++;
              }
            }
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
            $30 = state.ok ? 1 : -1;
          }
          if ($30 == 1) {
            $32 = false;
            // ↑
            state.ok = true;
            state.input.cut(state.pos);
            $30 = state.ok ? 2 : -1;
          }
          if ($30 == 2) {
            // [-+]?
            // [-+]
            final $36 = state.input;
            if (state.pos >= $36.end && !$36.isClosed) {
              $36.sleep = true;
              $36.handle = $1;
              return;
            }
            state.ok = state.pos < $36.end;
            if (state.ok) {
              final $35 = $36.data.codeUnitAt(state.pos - $36.start);
              state.ok = $35 == 43 || $35 == 45;
              if (state.ok) {
                state.pos++;
              }
            }
            if (!state.ok) {
              state.fail(const ErrorUnexpectedCharacter());
            }
            if (!state.ok) {
              state.setOk(true);
            }
            $30 = state.ok ? 3 : -1;
          }
          if ($30 == 3) {
            // [0-9]+
            $37 ??= false;
            while (true) {
              // [0-9]
              final $39 = state.input;
              if (state.pos >= $39.end && !$39.isClosed) {
                $39.sleep = true;
                $39.handle = $1;
                return;
              }
              state.ok = state.pos < $39.end;
              if (state.ok) {
                final $38 = $39.data.codeUnitAt(state.pos - $39.start);
                state.ok = $38 >= 48 && $38 <= 57;
                if (state.ok) {
                  state.pos++;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
              }
              if (!state.ok) {
                break;
              }
              $37 = true;
            }
            state.setOk($37!);
            $37 = null;
            $30 = -1;
          }
          if (!state.ok) {
            if (!$32!) {
              state.isRecoverable = false;
            }
            state.backtrack($31!);
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
        if (!state.ok &&
            state.lastFailPos >= state.failPos &&
            state.lastFailPos == $6!) {
          state.errorCount = $8!;
          state.fail(const ErrorExpectedTags(['number']));
        }
        if (state.lastFailPos < $7!) {
          state.lastFailPos = $7!;
        }
        $6 = null;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        // Spaces
        if ($22 & 0x40 == 0) {
          $22 |= 0x40;
          $40 = fastParseSpaces$Async(state);
          final $41 = $40!;
          if (!$41.isComplete) {
            $41.onComplete = $1;
            return;
          }
        }
        $22 &= ~0x40 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        state.backtrack($5!);
      }
      $22 &= ~0x80 & 0xffff;
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
    final $3 = state.pos;
    var $2 = true;
    // @inline OpenBrace = v:'{' Spaces ;
    // v:'{' Spaces
    final $4 = state.pos;
    const $5 = '{';
    matchLiteral1(state, $5, const ErrorExpectedTags([$5]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $2 = false;
      state.ok = true;
      if (state.ok) {
        List<MapEntry<String, Object?>>? $1;
        // KeyValues
        $1 = parseKeyValues(state);
        if (state.ok) {
          // @inline CloseBrace = v:'}' Spaces ;
          // v:'}' Spaces
          final $6 = state.pos;
          const $7 = '}';
          matchLiteral1(state, $7, const ErrorExpectedTags([$7]));
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($6);
          }
          if (state.ok) {
            Map<String, Object?>? $$;
            final kv = $1!;
            $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
            $0 = $$;
          }
        }
      }
    }
    if (!state.ok) {
      if (!$2) {
        state.isRecoverable = false;
      }
      state.backtrack($3);
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
    bool? $6;
    int? $7;
    int? $8;
    AsyncResult<Object?>? $11;
    int $13 = 0;
    List<MapEntry<String, Object?>>? $3;
    AsyncResult<List<MapEntry<String, Object?>>>? $14;
    int? $16;
    int? $17;
    AsyncResult<Object?>? $20;
    void $1() {
      // OpenBrace ↑ kv:KeyValues CloseBrace {}
      if ($13 & 0x20 == 0) {
        $13 |= 0x20;
        $4 = 0;
        $5 = state.pos;
        $6 = true;
      }
      if ($4 == 0) {
        // OpenBrace
        // v:'{' Spaces
        // v:'{' Spaces
        if ($13 & 0x2 == 0) {
          $13 |= 0x2;
          $7 = 0;
          $8 = state.pos;
        }
        if ($7 == 0) {
          // '{'
          final $9 = state.input;
          if (state.pos >= $9.end && !$9.isClosed) {
            $9.sleep = true;
            $9.handle = $1;
            return;
          }
          const $10 = '{';
          matchLiteral1Async(state, $10, const ErrorExpectedTags([$10]));
          $7 = state.ok ? 1 : -1;
        }
        if ($7 == 1) {
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
          $7 = -1;
        }
        if (!state.ok) {
          state.backtrack($8!);
        }
        $13 &= ~0x2 & 0xffff;
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        $6 = false;
        // ↑
        state.ok = true;
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
          final $18 = state.input;
          if (state.pos >= $18.end && !$18.isClosed) {
            $18.sleep = true;
            $18.handle = $1;
            return;
          }
          const $19 = '}';
          matchLiteral1Async(state, $19, const ErrorExpectedTags([$19]));
          $16 = state.ok ? 1 : -1;
        }
        if ($16 == 1) {
          // Spaces
          if ($13 & 0x8 == 0) {
            $13 |= 0x8;
            $20 = fastParseSpaces$Async(state);
            final $21 = $20!;
            if (!$21.isComplete) {
              $21.onComplete = $1;
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
        if (!$6!) {
          state.isRecoverable = false;
        }
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
    final $2 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      Object? $1;
      // Value
      $1 = parseValue(state);
      if (state.ok) {
        state.ok = state.pos >= state.input.length;
        if (!state.ok) {
          state.fail(const ErrorExpectedEndOfInput());
        }
        if (state.ok) {
          $0 = $1;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
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
    final $3 = state.pos;
    var $2 = true;
    const $4 = '"';
    matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
    if (state.ok) {
      $2 = false;
      state.ok = true;
      if (state.ok) {
        String? $1;
        // @inline StringChars = @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex)) ;
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        final $15 = state.input;
        List<String>? $16;
        String? $17;
        while (state.pos < $15.length) {
          String? $6;
          // $[ -!#-[\]-\u{10ffff}]+
          final $9 = state.pos;
          var $10 = false;
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.runeAt(state.pos)) == c &&
                  (c <= 91
                      ? c >= 32 && c <= 33 || c >= 35
                      : c >= 93 && c <= 1114111);
              state.pos += c > 0xffff ? 2 : 1,
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              $10 = true);
          state.ok = $10;
          if (!state.ok) {
            state.fail(const ErrorUnexpectedCharacter());
          }
          if (state.ok) {
            $6 = state.input.substring($9, state.pos);
          }
          if (state.ok) {
            final v = $6!;
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
          state.ok = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 92;
          if (state.ok) {
            state.pos++;
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
          if (!state.ok) {
            break;
          }
          String? $7;
          // (EscapeChar / EscapeHex)
          // EscapeChar
          // EscapeChar
          $7 = parseEscapeChar(state);
          if (!state.ok && state.isRecoverable) {
            // EscapeHex
            // EscapeHex
            $7 = parseEscapeHex(state);
          }
          if (!state.ok) {
            state.backtrack(pos);
            break;
          }
          if ($17 == null) {
            $17 = $7!;
          } else {
            if ($16 == null) {
              $16 = [$17, $7!];
            } else {
              $16.add($7!);
            }
          }
        }
        state.ok = true;
        if ($17 == null) {
          $1 = '';
        } else if ($16 == null) {
          $1 = $17;
        } else {
          $1 = $16.join();
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
            $0 = $1;
          }
        }
      }
    }
    if (!state.ok) {
      if (!$2) {
        state.isRecoverable = false;
      }
      state.backtrack($3);
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
    bool? $6;
    String? $3;
    int? $9;
    int? $10;
    List<String>? $13;
    String? $14;
    String? $11;
    int? $15;
    bool? $16;
    int $19 = 0;
    String? $12;
    int? $21;
    AsyncResult<String>? $22;
    AsyncResult<String>? $24;
    int? $26;
    int? $27;
    AsyncResult<Object?>? $30;
    void $1() {
      // '"' ↑ v:StringChars Quote
      if ($19 & 0x80 == 0) {
        $19 |= 0x80;
        $4 = 0;
        $5 = state.pos;
        $6 = true;
      }
      if ($4 == 0) {
        // '"'
        final $7 = state.input;
        if (state.pos >= $7.end && !$7.isClosed) {
          $7.sleep = true;
          $7.handle = $1;
          return;
        }
        const $8 = '"';
        matchLiteral1Async(state, $8, const ErrorExpectedTags([$8]));
        $4 = state.ok ? 1 : -1;
      }
      if ($4 == 1) {
        $6 = false;
        // ↑
        state.ok = true;
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
              state.ok = state.pos < $18.end;
              if (state.ok) {
                final $17 = $18.data.runeAt(state.pos - $18.start);
                state.ok = $17 <= 91
                    ? $17 >= 32 && $17 <= 33 || $17 >= 35
                    : $17 >= 93 && $17 <= 1114111;
                if (state.ok) {
                  state.pos += $17 > 0xffff ? 2 : 1;
                }
              }
              if (!state.ok) {
                state.fail(const ErrorUnexpectedCharacter());
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
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              return;
            }
            state.ok = state.pos < $20.end &&
                $20.data.codeUnitAt(state.pos - $20.start) == 92;
            if (state.ok) {
              state.pos++;
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
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
              $21 = 0;
            }
            if ($21 == 0) {
              // EscapeChar
              // EscapeChar
              if ($19 & 0x2 == 0) {
                $19 |= 0x2;
                $22 = parseEscapeChar$Async(state);
                final $23 = $22!;
                if (!$23.isComplete) {
                  $23.onComplete = $1;
                  return;
                }
              }
              $12 = $22!.value;
              $19 &= ~0x2 & 0xffff;
              $21 = state.ok
                  ? -1
                  : state.isRecoverable
                      ? 1
                      : -1;
            }
            if ($21 == 1) {
              // EscapeHex
              // EscapeHex
              if ($19 & 0x4 == 0) {
                $19 |= 0x4;
                $24 = parseEscapeHex$Async(state);
                final $25 = $24!;
                if (!$25.isComplete) {
                  $25.onComplete = $1;
                  return;
                }
              }
              $12 = $24!.value;
              $19 &= ~0x4 & 0xffff;
              $21 = -1;
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
          $26 = 0;
          $27 = state.pos;
        }
        if ($26 == 0) {
          // '"'
          final $28 = state.input;
          if (state.pos >= $28.end && !$28.isClosed) {
            $28.sleep = true;
            $28.handle = $1;
            return;
          }
          const $29 = '"';
          matchLiteral1Async(state, $29, const ErrorExpectedTags([$29]));
          $26 = state.ok ? 1 : -1;
        }
        if ($26 == 1) {
          // Spaces
          if ($19 & 0x20 == 0) {
            $19 |= 0x20;
            $30 = fastParseSpaces$Async(state);
            final $31 = $30!;
            if (!$31.isComplete) {
              $31.onComplete = $1;
              return;
            }
          }
          $19 &= ~0x20 & 0xffff;
          $26 = -1;
        }
        if (!state.ok) {
          state.backtrack($27!);
        }
        $19 &= ~0x40 & 0xffff;
        $4 = -1;
      }
      if (state.ok) {
        $2 = $3;
      } else {
        if (!$6!) {
          state.isRecoverable = false;
        }
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
  ///     String
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
            final $6 = state.pos;
            const $7 = 'true';
            state.ok = state.pos < state.input.length &&
                state.input.codeUnitAt(state.pos) == 116 &&
                state.input.startsWith($7, state.pos);
            if (state.ok) {
              state.pos += 4;
            } else {
              state.fail(const ErrorExpectedTags([$7]));
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
              state.backtrack($6);
            }
            if (!state.ok && state.isRecoverable) {
              // False
              // bool @inline False = 'false' Spaces {} ;
              // 'false' Spaces {}
              final $9 = state.pos;
              const $10 = 'false';
              state.ok = state.pos < state.input.length &&
                  state.input.codeUnitAt(state.pos) == 102 &&
                  state.input.startsWith($10, state.pos);
              if (state.ok) {
                state.pos += 5;
              } else {
                state.fail(const ErrorExpectedTags([$10]));
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
                state.backtrack($9);
              }
              if (!state.ok && state.isRecoverable) {
                // Null
                // Object? @inline Null = 'null' Spaces {} ;
                // 'null' Spaces {}
                final $12 = state.pos;
                const $13 = 'null';
                state.ok = state.pos < state.input.length &&
                    state.input.codeUnitAt(state.pos) == 110 &&
                    state.input.startsWith($13, state.pos);
                if (state.ok) {
                  state.pos += 4;
                } else {
                  state.fail(const ErrorExpectedTags([$13]));
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
                  state.backtrack($12);
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
  ///     String
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
    AsyncResult<String>? $4;
    int $6 = 0;
    AsyncResult<Map<String, Object?>>? $7;
    AsyncResult<List<Object?>>? $9;
    AsyncResult<num>? $11;
    int? $13;
    int? $14;
    AsyncResult<Object?>? $16;
    int? $18;
    int? $19;
    AsyncResult<Object?>? $21;
    int? $23;
    int? $24;
    AsyncResult<Object?>? $26;
    void $1() {
      if ($6 & 0x400 == 0) {
        $6 |= 0x400;
        $3 = 0;
      }
      if ($3 == 0) {
        // String
        // String
        if ($6 & 0x1 == 0) {
          $6 |= 0x1;
          $4 = parseString$Async(state);
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
        // Object
        // Object
        if ($6 & 0x2 == 0) {
          $6 |= 0x2;
          $7 = parseObject$Async(state);
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
        // Array
        // Array
        if ($6 & 0x4 == 0) {
          $6 |= 0x4;
          $9 = parseArray$Async(state);
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
        // Number
        // Number
        if ($6 & 0x8 == 0) {
          $6 |= 0x8;
          $11 = parseNumber$Async(state);
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
        // True
        // True
        // 'true' Spaces {}
        // 'true' Spaces {}
        if ($6 & 0x20 == 0) {
          $6 |= 0x20;
          $13 = 0;
          $14 = state.pos;
        }
        if ($13 == 0) {
          // 'true'
          final $15 = state.input;
          if (state.pos + 3 >= $15.end && !$15.isClosed) {
            $15.sleep = true;
            $15.handle = $1;
            return;
          }
          const string = 'true';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          $13 = state.ok ? 1 : -1;
        }
        if ($13 == 1) {
          // Spaces
          if ($6 & 0x10 == 0) {
            $6 |= 0x10;
            $16 = fastParseSpaces$Async(state);
            final $17 = $16!;
            if (!$17.isComplete) {
              $17.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x10 & 0xffff;
          $13 = -1;
        }
        if (state.ok) {
          bool? $$;
          $$ = true;
          $2 = $$;
        } else {
          state.backtrack($14!);
        }
        $6 &= ~0x20 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 5
                : -1;
      }
      if ($3 == 5) {
        // False
        // False
        // 'false' Spaces {}
        // 'false' Spaces {}
        if ($6 & 0x80 == 0) {
          $6 |= 0x80;
          $18 = 0;
          $19 = state.pos;
        }
        if ($18 == 0) {
          // 'false'
          final $20 = state.input;
          if (state.pos + 4 >= $20.end && !$20.isClosed) {
            $20.sleep = true;
            $20.handle = $1;
            return;
          }
          const string = 'false';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          $18 = state.ok ? 1 : -1;
        }
        if ($18 == 1) {
          // Spaces
          if ($6 & 0x40 == 0) {
            $6 |= 0x40;
            $21 = fastParseSpaces$Async(state);
            final $22 = $21!;
            if (!$22.isComplete) {
              $22.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x40 & 0xffff;
          $18 = -1;
        }
        if (state.ok) {
          bool? $$;
          $$ = false;
          $2 = $$;
        } else {
          state.backtrack($19!);
        }
        $6 &= ~0x80 & 0xffff;
        $3 = state.ok
            ? -1
            : state.isRecoverable
                ? 6
                : -1;
      }
      if ($3 == 6) {
        // Null
        // Null
        // 'null' Spaces {}
        // 'null' Spaces {}
        if ($6 & 0x200 == 0) {
          $6 |= 0x200;
          $23 = 0;
          $24 = state.pos;
        }
        if ($23 == 0) {
          // 'null'
          final $25 = state.input;
          if (state.pos + 3 >= $25.end && !$25.isClosed) {
            $25.sleep = true;
            $25.handle = $1;
            return;
          }
          const string = 'null';
          matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
          $23 = state.ok ? 1 : -1;
        }
        if ($23 == 1) {
          // Spaces
          if ($6 & 0x100 == 0) {
            $6 |= 0x100;
            $26 = fastParseSpaces$Async(state);
            final $27 = $26!;
            if (!$27.isComplete) {
              $27.onComplete = $1;
              return;
            }
          }
          $6 &= ~0x100 & 0xffff;
          $23 = -1;
        }
        if (state.ok) {
          Object? $$;
          $$ = null;
          $2 = $$;
        } else {
          state.backtrack($24!);
        }
        $6 &= ~0x200 & 0xffff;
        $3 = -1;
      }
      $6 &= ~0x400 & 0xffff;
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
  ///   @list(Value, Comma ↑ v:Value)
  ///   ;
  List<Object?>? parseValues(State<String> state) {
    List<Object?>? $0;
    // @list(Value, Comma ↑ v:Value)
    final $2 = <Object?>[];
    Object? $3;
    // Value
    // Value
    $3 = parseValue(state);
    if (state.ok) {
      $2.add($3);
      while (true) {
        Object? $4;
        // Comma ↑ v:Value
        final $9 = state.pos;
        var $8 = true;
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $10 = state.pos;
        const $11 = ',';
        matchLiteral1(state, $11, const ErrorExpectedTags([$11]));
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($10);
        }
        if (state.ok) {
          $8 = false;
          state.ok = true;
          if (state.ok) {
            Object? $7;
            // Value
            $7 = parseValue(state);
            if (state.ok) {
              $4 = $7;
            }
          }
        }
        if (!state.ok) {
          if (!$8) {
            state.isRecoverable = false;
          }
          state.backtrack($9);
        }
        if (!state.ok) {
          break;
        }
        $2.add($4);
      }
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// Values =
  ///   @list(Value, Comma ↑ v:Value)
  ///   ;
  AsyncResult<List<Object?>> parseValues$Async(
      State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<List<Object?>>();
    List<Object?>? $2;
    int? $3;
    int? $4;
    List<Object?>? $5;
    AsyncResult<Object?>? $8;
    int $10 = 0;
    int? $12;
    int? $13;
    bool? $14;
    int? $15;
    int? $16;
    AsyncResult<Object?>? $19;
    Object? $11;
    AsyncResult<Object?>? $21;
    void $1() {
      // @list(Value, Comma ↑ v:Value)
      // @list(Value, Comma ↑ v:Value)
      if ($3 == null) {
        $3 = state.pos;
        $4 = 0;
        $5 = [];
      }
      while (true) {
        if ($4 == 0) {
          Object? $6;
          // Value
          // Value
          if ($10 & 0x1 == 0) {
            $10 |= 0x1;
            $8 = parseValue$Async(state);
            final $9 = $8!;
            if (!$9.isComplete) {
              $9.onComplete = $1;
              return;
            }
          }
          $6 = $8!.value;
          $10 &= ~0x1 & 0xffff;
          if (!state.ok) {
            break;
          }
          $5!.add($6);
          $6 = null;
          $4 = 1;
        }
        if ($4 == 1) {
          Object? $7;
          // Comma ↑ v:Value
          if ($10 & 0x10 == 0) {
            $10 |= 0x10;
            $12 = 0;
            $13 = state.pos;
            $14 = true;
          }
          if ($12 == 0) {
            // Comma
            // v:',' Spaces
            // v:',' Spaces
            if ($10 & 0x4 == 0) {
              $10 |= 0x4;
              $15 = 0;
              $16 = state.pos;
            }
            if ($15 == 0) {
              // ','
              final $17 = state.input;
              if (state.pos >= $17.end && !$17.isClosed) {
                $17.sleep = true;
                $17.handle = $1;
                return;
              }
              const $18 = ',';
              matchLiteral1Async(state, $18, const ErrorExpectedTags([$18]));
              $15 = state.ok ? 1 : -1;
            }
            if ($15 == 1) {
              // Spaces
              if ($10 & 0x2 == 0) {
                $10 |= 0x2;
                $19 = fastParseSpaces$Async(state);
                final $20 = $19!;
                if (!$20.isComplete) {
                  $20.onComplete = $1;
                  return;
                }
              }
              $10 &= ~0x2 & 0xffff;
              $15 = -1;
            }
            if (!state.ok) {
              state.backtrack($16!);
            }
            $10 &= ~0x4 & 0xffff;
            $12 = state.ok ? 1 : -1;
          }
          if ($12 == 1) {
            $14 = false;
            // ↑
            state.ok = true;
            state.input.cut(state.pos);
            $12 = state.ok ? 2 : -1;
          }
          if ($12 == 2) {
            // Value
            if ($10 & 0x8 == 0) {
              $10 |= 0x8;
              $21 = parseValue$Async(state);
              final $22 = $21!;
              if (!$22.isComplete) {
                $22.onComplete = $1;
                return;
              }
            }
            $11 = $21!.value;
            $10 &= ~0x8 & 0xffff;
            $12 = -1;
          }
          if (state.ok) {
            $7 = $11;
          } else {
            if (!$14!) {
              state.isRecoverable = false;
            }
            state.backtrack($13!);
          }
          $10 &= ~0x10 & 0xffff;
          if (!state.ok) {
            $4 = -1;
            break;
          }
          $5!.add($7);
          $7 = null;
        }
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $5;
        $5 = null;
      }
      $3 = null;
      $0.value = $2;
      $0.isComplete = true;
      state.input.handle = $0.onComplete;
      return;
    }

    $1();
    return $0;
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
  final state = State(source);
  fastParse(state);
  if (state.ok) {
    return;
  }

  final parseResult = _createParseResult<String, Object?>(state, null);
  parseResult.getResult();
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
  final state = State(source);
  final result = parse(state);
  if (state.ok) {
    return result as O;
  }

  final parseResult = _createParseResult<String, O>(state, result);
  return parseResult.getResult();
}

ParseResult<I, O> tryParse<I, O>(O? Function(State<I> state) parse, I input) {
  final state = State(input);
  final result = parse(state);
  final parseResult = _createParseResult<I, O>(state, result);
  return parseResult;
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
  var isEof = false;
  if (input is String) {
    if (offset >= input.length) {
      isEof = true;
    }
  } else if (input is ChunkedParsingSink) {
    if (input.isClosed && offset >= input.end) {
      isEof = true;
    }
  }

  if (isEof) {
    errorList.add(const ErrorUnexpectedEndOfInput());
    errorList.removeWhere((e) => e is ErrorUnexpectedCharacter);
  } else if (errorList.isEmpty) {
    errorList.add(const ErrorUnexpectedCharacter());
  }

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
        if (offset >= input.start && offset < input.end) {
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
  final List<ParseError?> errors = List.filled(64, null, growable: false);

  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool isRecoverable = true;

  int lastFailPos = -1;

  bool ok = false;

  int pos = 0;

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void backtrack(int pos) {
    if (isRecoverable) {
      this.pos = pos;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool fail(ParseError error) {
    ok = false;
    if (lastFailPos < pos) {
      lastFailPos = pos;
    }

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
    if (lastFailPos < pos) {
      lastFailPos = pos;
    }

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
    if (lastFailPos < pos) {
      lastFailPos = pos;
    }

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
    if (lastFailPos < pos) {
      lastFailPos = pos;
    }

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

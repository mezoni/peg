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
            (c < 13 ? c >= 9 && c <= 10 : c <= 13 || c == 32);
        // ignore: curly_braces_in_flow_control_structures, empty_statements
        state.pos++);
    state.setOk(true);
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    late bool $3;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            $3 = state.isOptional;
            state.isOptional = true;
            $2 = 2;
            break;
          case 1:
            state.isOptional = $3;
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
          case 2:
            final $4 = state.input;
            if (state.pos >= $4.end && !$4.isClosed) {
              $4.sleep = true;
              $4.handle = $1;
              $2 = 2;
              return;
            }
            if (state.pos < $4.end) {
              final c = $4.data.codeUnitAt(state.pos - $4.start);
              final $5 = c < 13 ? c >= 9 && c <= 10 : c <= 13 || c == 32;
              if ($5) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $2 = 1;
              break;
            }
            $2 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$2}');
        }
      }
    }

    $1();
    return $0;
  }

  /// @event
  /// Array =
  ///   OpenBracket ↑ v:Values CloseBracket
  ///   ;
  List<Object?>? parseArray(State<String> state) {
    beginEvent(JsonParserEvent.arrayEvent);
    List<Object?>? $0;
    // OpenBracket ↑ v:Values CloseBracket
    final $4 = state.pos;
    var $2 = true;
    final $3 = state.isOptional;
    // @inline OpenBracket = v:'[' Spaces ;
    // v:'[' Spaces
    final $5 = state.pos;
    const $6 = '[';
    final $7 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 91;
    if ($7) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$6]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    if (state.ok) {
      $2 = false;
      state.isOptional = false;
      state.setOk(true);
      if (state.ok) {
        List<Object?>? $1;
        // Values
        $1 = parseValues(state);
        if (state.ok) {
          // @inline CloseBracket = v:']' Spaces ;
          // v:']' Spaces
          final $8 = state.pos;
          const $9 = ']';
          final $10 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 93;
          if ($10) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$9]));
          }
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($8);
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
      state.backtrack($4);
    }
    state.isOptional = $3;
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
    var $3 = 0;
    late bool $5;
    late bool $6;
    late int $7;
    late int $8;
    late AsyncResult<Object?> $13;
    List<Object?>? $4;
    late AsyncResult<List<Object?>> $15;
    late int $17;
    late AsyncResult<Object?> $22;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $6 = true;
            $5 = state.isOptional;
            $8 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 1;
              return;
            }
            const $10 = '[';
            final $11 = state.pos < $9.end &&
                $9.data.codeUnitAt(state.pos - $9.start) == 91;
            if ($11) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$10]));
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 2;
              break;
            }
            $13 = fastParseSpaces$Async(state);
            if (!$13.isComplete) {
              $13.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($8);
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 4;
              break;
            }
            $6 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $26 = state.ok;
            if (!$26) {
              $3 = 5;
              break;
            }
            $15 = parseValues$Async(state);
            if (!$15.isComplete) {
              $15.onComplete = $1;
              $3 = 6;
              return;
            }
            $3 = 6;
            break;
          case 3:
            $3 = 2;
            break;
          case 4:
            if (!state.ok) {
              if (!$6) {
                state.isRecoverable = false;
              }
              state.backtrack($7);
            }
            state.isOptional = $5;
            endEvent<List<Object?>>(JsonParserEvent.arrayEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 5:
            $3 = 4;
            break;
          case 6:
            $4 = $15.value;
            final $27 = state.ok;
            if (!$27) {
              $3 = 7;
              break;
            }
            $17 = state.pos;
            $3 = 8;
            break;
          case 7:
            $3 = 5;
            break;
          case 8:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 8;
              return;
            }
            const $19 = ']';
            final $20 = state.pos < $18.end &&
                $18.data.codeUnitAt(state.pos - $18.start) == 93;
            if ($20) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$19]));
            }
            final $28 = state.ok;
            if (!$28) {
              $3 = 9;
              break;
            }
            $22 = fastParseSpaces$Async(state);
            if (!$22.isComplete) {
              $22.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 9:
            if (!state.ok) {
              state.backtrack($17);
            }
            if (state.ok) {
              $2 = $4;
            }
            $3 = 7;
            break;
          case 10:
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    if (state.pos < state.input.length) {
      final $3 = state.input.codeUnitAt(state.pos);
      final $4 = $3 < 98
          ? $3 < 47
              ? $3 == 34
              : $3 <= 47 || $3 == 92
          : $3 <= 98 ||
              ($3 < 110 ? $3 == 102 : $3 <= 110 || $3 == 114 || $3 == 116);
      if ($4) {
        state.pos++;
        state.setOk(true);
        $1 = $3;
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
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
    var $3 = 0;
    int? $4;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            final $5 = state.input;
            if (state.pos >= $5.end && !$5.isClosed) {
              $5.sleep = true;
              $5.handle = $1;
              $3 = 0;
              return;
            }
            if (state.pos < $5.end) {
              final c = $5.data.codeUnitAt(state.pos - $5.start);
              final $6 = c < 98
                  ? c < 47
                      ? c == 34
                      : c <= 47 || c == 92
                  : c <= 98 ||
                      (c < 110 ? c == 102 : c <= 110 || c == 114 || c == 116);
              if ($6) {
                state.pos++;
                $4 = c;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (state.ok) {
              String? $$;
              final c = $4!;
              $$ = _escape(c);
              $2 = $$;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 117;
    if ($4) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$3]));
    }
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
    var $3 = 0;
    late int $5;
    int? $4;
    late AsyncResult<int> $10;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $6 = state.input;
            if (state.pos >= $6.end && !$6.isClosed) {
              $6.sleep = true;
              $6.handle = $1;
              $3 = 1;
              return;
            }
            const $7 = 'u';
            final $8 = state.pos < $6.end &&
                $6.data.codeUnitAt(state.pos - $6.start) == 117;
            if ($8) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$7]));
            }
            final $12 = state.ok;
            if (!$12) {
              $3 = 2;
              break;
            }
            $10 = parseHexNumber$Async(state);
            if (!$10.isComplete) {
              $10.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $4 = $10.value;
            if (state.ok) {
              String? $$;
              final v = $4!;
              $$ = String.fromCharCode(v);
              $2 = $$;
            }
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// HexNumber =
  ///   @indicate('Expected 4 digit hex number', HexNumber_)
  ///   ;
  int? parseHexNumber(State<String> state) {
    int? $0;
    // @indicate('Expected 4 digit hex number', HexNumber_)
    final $5 = state.pos;
    final $2 = state.errorCount;
    final $3 = state.failPos;
    final $4 = state.lastFailPos;
    state.lastFailPos = -1;
    // HexNumber_
    // int @inline HexNumber_ = v:$[0-9A-Fa-f]{4,4} {} ;
    // v:$[0-9A-Fa-f]{4,4} {}
    String? $7;
    final $9 = state.pos;
    final $10 = state.pos;
    var $11 = 0;
    while ($11 < 4) {
      if (state.pos < state.input.length) {
        final $12 = state.input.codeUnitAt(state.pos);
        final $13 = $12 < 65
            ? $12 >= 48 && $12 <= 57
            : $12 <= 70 || $12 >= 97 && $12 <= 102;
        if ($13) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok) {
        break;
      }
      $11++;
    }
    if ($11 == 4) {
      state.setOk(true);
    } else {
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
    if (!state.ok) {
      if (state.lastFailPos == $3) {
        state.errorCount = $2;
      } else if (state.lastFailPos > $3) {
        state.errorCount = 0;
      }
      final length = $5 - state.lastFailPos;
      state.failAt(state.lastFailPos,
          ErrorMessage(length, 'Expected 4 digit hex number'));
    }
    if (state.lastFailPos < $4) {
      state.lastFailPos = $4;
    }
    return $0;
  }

  /// HexNumber =
  ///   @indicate('Expected 4 digit hex number', HexNumber_)
  ///   ;
  AsyncResult<int> parseHexNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<int>();
    int? $2;
    var $3 = 0;
    late int $4;
    late int $5;
    late int $6;
    late int $7;
    String? $8;
    late int $9;
    late int $10;
    late int $11;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $4 = state.errorCount;
            $5 = state.failPos;
            $6 = state.lastFailPos;
            state.lastFailPos = -1;
            state.input.beginBuffering();
            $9 = state.pos;
            $10 = state.pos;
            $11 = 0;
            $3 = 2;
            break;
          case 1:
            if ($11 == 4) {
              state.setOk(true);
            } else {
              state.backtrack($10);
            }
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $8 = input.data.substring($9 - start, state.pos - start);
            }
            if (state.ok) {
              int? $$;
              final v = $8!;
              $$ = int.parse(v, radix: 16);
              $2 = $$;
            }
            state.input.endBuffering();
            if (!state.ok) {
              if (state.lastFailPos == $5) {
                state.errorCount = $4;
              } else if (state.lastFailPos > $5) {
                state.errorCount = 0;
              }
              final length = $7 - state.lastFailPos;
              state.failAt(state.lastFailPos,
                  ErrorMessage(length, 'Expected 4 digit hex number'));
            }
            if (state.lastFailPos < $6) {
              state.lastFailPos = $6;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 2:
            final $15 = $11 < 4;
            if (!$15) {
              $3 = 1;
              break;
            }
            $3 = 3;
            break;
          case 3:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $12.end) {
              final c = $12.data.codeUnitAt(state.pos - $12.start);
              final $13 =
                  c < 65 ? c >= 48 && c <= 57 : c <= 70 || c >= 97 && c <= 102;
              if ($13) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 1;
              break;
            }
            $11++;
            $3 = 2;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $5 = state.pos;
    var $3 = true;
    final $4 = state.isOptional;
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
      final $7 = state.pos;
      const $8 = ':';
      final $9 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 58;
      if ($9) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$8]));
      }
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.backtrack($7);
      }
      if (state.ok) {
        $3 = false;
        state.isOptional = false;
        state.setOk(true);
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
      state.backtrack($5);
    }
    state.isOptional = $4;
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
    var $3 = 0;
    late bool $6;
    late bool $7;
    late int $8;
    String? $4;
    late AsyncResult<String> $9;
    late int $11;
    late AsyncResult<Object?> $16;
    Object? $5;
    late AsyncResult<Object?> $18;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $8 = state.pos;
            $7 = true;
            $6 = state.isOptional;
            beginEvent(JsonParserEvent.keyEvent);
            $9 = parseString$Async(state);
            if (!$9.isComplete) {
              $9.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $9.value;
            $4 = endEvent<String>(JsonParserEvent.keyEvent, $4, state.ok);
            final $20 = state.ok;
            if (!$20) {
              $3 = 2;
              break;
            }
            $11 = state.pos;
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              if (!$7) {
                state.isRecoverable = false;
              }
              state.backtrack($8);
            }
            state.isOptional = $6;
            endEvent<MapEntry<String, Object?>>(
                JsonParserEvent.keyValueEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $12 = state.input;
            if (state.pos >= $12.end && !$12.isClosed) {
              $12.sleep = true;
              $12.handle = $1;
              $3 = 3;
              return;
            }
            const $13 = ':';
            final $14 = state.pos < $12.end &&
                $12.data.codeUnitAt(state.pos - $12.start) == 58;
            if ($14) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$13]));
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 4;
              break;
            }
            $16 = fastParseSpaces$Async(state);
            if (!$16.isComplete) {
              $16.onComplete = $1;
              $3 = 5;
              return;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($11);
            }
            final $22 = state.ok;
            if (!$22) {
              $3 = 6;
              break;
            }
            $7 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $23 = state.ok;
            if (!$23) {
              $3 = 7;
              break;
            }
            $18 = parseValue$Async(state);
            if (!$18.isComplete) {
              $18.onComplete = $1;
              $3 = 8;
              return;
            }
            $3 = 8;
            break;
          case 5:
            $3 = 4;
            break;
          case 6:
            $3 = 2;
            break;
          case 7:
            $3 = 6;
            break;
          case 8:
            $5 = $18.value;
            if (state.ok) {
              MapEntry<String, Object?>? $$;
              final k = $4!;
              final v = $5;
              $$ = MapEntry(k, v);
              $2 = $$;
            }
            $3 = 7;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $5 = state.isOptional;
    state.isOptional = true;
    MapEntry<String, Object?>? $3;
    // KeyValue
    // KeyValue
    $3 = parseKeyValue(state);
    if (state.ok) {
      $2.add($3!);
      while (true) {
        MapEntry<String, Object?>? $4;
        // Comma ↑ v:KeyValue
        final $11 = state.pos;
        var $9 = true;
        final $10 = state.isOptional;
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $12 = state.pos;
        const $13 = ',';
        final $14 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 44;
        if ($14) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$13]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($12);
        }
        if (state.ok) {
          $9 = false;
          state.isOptional = false;
          state.setOk(true);
          if (state.ok) {
            MapEntry<String, Object?>? $8;
            // KeyValue
            $8 = parseKeyValue(state);
            if (state.ok) {
              $4 = $8;
            }
          }
        }
        if (!state.ok) {
          if (!$9) {
            state.isRecoverable = false;
          }
          state.backtrack($11);
        }
        state.isOptional = $10;
        if (!state.ok) {
          break;
        }
        $2.add($4!);
      }
    }
    state.isOptional = $5;
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
    var $3 = 0;
    late bool $6;
    late List<MapEntry<String, Object?>> $7;
    MapEntry<String, Object?>? $4;
    late AsyncResult<MapEntry<String, Object?>> $8;
    MapEntry<String, Object?>? $5;
    late bool $11;
    late bool $12;
    late int $13;
    late int $14;
    late AsyncResult<Object?> $19;
    MapEntry<String, Object?>? $10;
    late AsyncResult<MapEntry<String, Object?>> $21;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = [];
            $6 = state.isOptional;
            state.isOptional = true;
            $8 = parseKeyValue$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $8.value;
            final $23 = state.ok;
            if (!$23) {
              $3 = 2;
              break;
            }
            $7.add($4!);
            $3 = 4;
            break;
          case 2:
            state.isOptional = $6;
            state.setOk(true);
            if (state.ok) {
              $2 = $7;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $3 = 2;
            break;
          case 4:
            $13 = state.pos;
            $12 = true;
            $11 = state.isOptional;
            $14 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 5;
              return;
            }
            const $16 = ',';
            final $17 = state.pos < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 44;
            if ($17) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$16]));
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 6;
              break;
            }
            $19 = fastParseSpaces$Async(state);
            if (!$19.isComplete) {
              $19.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($14);
            }
            final $26 = state.ok;
            if (!$26) {
              $3 = 8;
              break;
            }
            $12 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $27 = state.ok;
            if (!$27) {
              $3 = 9;
              break;
            }
            $21 = parseKeyValue$Async(state);
            if (!$21.isComplete) {
              $21.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 7:
            $3 = 6;
            break;
          case 8:
            if (!state.ok) {
              if (!$12) {
                state.isRecoverable = false;
              }
              state.backtrack($13);
            }
            state.isOptional = $11;
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $7.add($5!);
            $3 = 4;
            break;
          case 9:
            $3 = 8;
            break;
          case 10:
            $10 = $21.value;
            if (state.ok) {
              $5 = $10;
            }
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
    }

    $1();
    return $0;
  }

  /// num
  /// Number =
  ///   v:@expected('number', Number_) Spaces
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // v:@expected('number', Number_) Spaces
    final $2 = state.pos;
    num? $1;
    final $3 = state.pos;
    final $4 = state.errorCount;
    final $5 = state.failPos;
    final $6 = state.lastFailPos;
    state.lastFailPos = -1;
    // Number_
    // num @inline Number_ = v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {} ;
    // v:$([-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?) {}
    String? $8;
    final $10 = state.pos;
    // [-]? ([0] / [1-9] [0-9]*) ([.] ↑ [0-9]+)? ([eE] ↑ [-+]? [0-9]+)?
    final $11 = state.pos;
    final $12 = state.isOptional;
    state.isOptional = true;
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 45;
      if (ok) {
        state.pos++;
        state.setOk(true);
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
    state.isOptional = $12;
    if (!state.ok) {
      state.setOk(true);
    }
    if (state.ok) {
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $14 = state.pos;
        if (state.pos < state.input.length) {
          final $15 = state.input.codeUnitAt(state.pos);
          final $16 = $15 >= 49 && $15 <= 57;
          if ($16) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.codeUnitAt(state.pos)) == c &&
                  (c >= 48 && c <= 57);
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              state.pos++);
          state.setOk(true);
        }
        if (!state.ok) {
          state.backtrack($14);
        }
      }
      if (state.ok) {
        final $17 = state.isOptional;
        state.isOptional = true;
        // [.] ↑ [0-9]+
        final $20 = state.pos;
        var $18 = true;
        final $19 = state.isOptional;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 46;
          if (ok) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $18 = false;
          state.isOptional = false;
          state.setOk(true);
          if (state.ok) {
            var $21 = false;
            for (var c = 0;
                state.pos < state.input.length &&
                    (c = state.input.codeUnitAt(state.pos)) == c &&
                    (c >= 48 && c <= 57);
                state.pos++,
                // ignore: curly_braces_in_flow_control_structures, empty_statements
                $21 = true);
            if ($21) {
              state.setOk($21);
            } else {
              state.pos < state.input.length
                  ? state.fail(const ErrorUnexpectedCharacter())
                  : state.fail(const ErrorUnexpectedEndOfInput());
            }
          }
        }
        if (!state.ok) {
          if (!$18) {
            state.isRecoverable = false;
          }
          state.backtrack($20);
        }
        state.isOptional = $19;
        state.isOptional = $17;
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          final $22 = state.isOptional;
          state.isOptional = true;
          // [eE] ↑ [-+]? [0-9]+
          final $25 = state.pos;
          var $23 = true;
          final $24 = state.isOptional;
          if (state.pos < state.input.length) {
            final $26 = state.input.codeUnitAt(state.pos);
            final $27 = $26 == 69 || $26 == 101;
            if ($27) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $23 = false;
            state.isOptional = false;
            state.setOk(true);
            if (state.ok) {
              final $28 = state.isOptional;
              state.isOptional = true;
              if (state.pos < state.input.length) {
                final $29 = state.input.codeUnitAt(state.pos);
                final $30 = $29 == 43 || $29 == 45;
                if ($30) {
                  state.pos++;
                  state.setOk(true);
                } else {
                  state.fail(const ErrorUnexpectedCharacter());
                }
              } else {
                state.fail(const ErrorUnexpectedEndOfInput());
              }
              state.isOptional = $28;
              if (!state.ok) {
                state.setOk(true);
              }
              if (state.ok) {
                var $31 = false;
                for (var c = 0;
                    state.pos < state.input.length &&
                        (c = state.input.codeUnitAt(state.pos)) == c &&
                        (c >= 48 && c <= 57);
                    state.pos++,
                    // ignore: curly_braces_in_flow_control_structures, empty_statements
                    $31 = true);
                if ($31) {
                  state.setOk($31);
                } else {
                  state.pos < state.input.length
                      ? state.fail(const ErrorUnexpectedCharacter())
                      : state.fail(const ErrorUnexpectedEndOfInput());
                }
              }
            }
          }
          if (!state.ok) {
            if (!$23) {
              state.isRecoverable = false;
            }
            state.backtrack($25);
          }
          state.isOptional = $24;
          state.isOptional = $22;
          if (!state.ok) {
            state.setOk(true);
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($11);
    }
    if (state.ok) {
      $8 = state.input.substring($10, state.pos);
    }
    if (state.ok) {
      num? $$;
      final v = $8!;
      $$ = num.parse(v);
      $1 = $$;
    }
    if (!state.ok && state.lastFailPos == $3) {
      if (state.lastFailPos == $5) {
        state.errorCount = $4;
      } else if (state.lastFailPos > $5) {
        state.errorCount = 0;
      }
      state.fail(const ErrorExpectedTags(['number']));
    }
    if (state.lastFailPos < $6) {
      state.lastFailPos = $6;
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
  ///   v:@expected('number', Number_) Spaces
  ///   ;
  AsyncResult<num> parseNumber$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<num>();
    num? $2;
    var $3 = 0;
    late int $5;
    num? $4;
    late int $6;
    late int $7;
    late int $8;
    late int $9;
    String? $10;
    late int $11;
    late int $12;
    late bool $13;
    late int $18;
    late bool $22;
    late bool $26;
    late bool $27;
    late bool $28;
    late int $29;
    late bool $32;
    late bool $33;
    late bool $37;
    late bool $38;
    late bool $39;
    late int $40;
    late bool $44;
    late bool $48;
    late bool $49;
    late AsyncResult<Object?> $53;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $6 = state.pos;
            $7 = state.errorCount;
            $8 = state.failPos;
            $9 = state.lastFailPos;
            state.lastFailPos = -1;
            $11 = state.pos;
            state.input.beginBuffering();
            $12 = state.pos;
            $13 = state.isOptional;
            state.isOptional = true;
            $3 = 1;
            break;
          case 1:
            final $14 = state.input;
            if (state.pos >= $14.end && !$14.isClosed) {
              $14.sleep = true;
              $14.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $14.end) {
              final ok = $14.data.codeUnitAt(state.pos - $14.start) == 45;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.isOptional = $13;
            if (!state.ok) {
              state.setOk(true);
            }
            final $55 = state.ok;
            if (!$55) {
              $3 = 2;
              break;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($12);
            }
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $10 = input.data.substring($11 - start, state.pos - start);
            }
            if (state.ok) {
              num? $$;
              final v = $10!;
              $$ = num.parse(v);
              $4 = $$;
            }
            if (!state.ok && state.lastFailPos == $6) {
              if (state.lastFailPos == $8) {
                state.errorCount = $7;
              } else if (state.lastFailPos > $8) {
                state.errorCount = 0;
              }
              state.fail(const ErrorExpectedTags(['number']));
            }
            if (state.lastFailPos < $9) {
              state.lastFailPos = $9;
            }
            final $68 = state.ok;
            if (!$68) {
              $3 = 25;
              break;
            }
            $53 = fastParseSpaces$Async(state);
            if (!$53.isComplete) {
              $53.onComplete = $1;
              $3 = 26;
              return;
            }
            $3 = 26;
            break;
          case 3:
            final $16 = state.input;
            if (state.pos >= $16.end && !$16.isClosed) {
              $16.sleep = true;
              $16.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $16.end) {
              final ok = $16.data.codeUnitAt(state.pos - $16.start) == 48;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $56 = !state.ok && state.isRecoverable;
            if (!$56) {
              $3 = 4;
              break;
            }
            $18 = state.pos;
            $3 = 5;
            break;
          case 4:
            final $59 = state.ok;
            if (!$59) {
              $3 = 9;
              break;
            }
            $26 = state.isOptional;
            state.isOptional = true;
            $29 = state.pos;
            $28 = true;
            $27 = state.isOptional;
            $3 = 10;
            break;
          case 5:
            final $19 = state.input;
            if (state.pos >= $19.end && !$19.isClosed) {
              $19.sleep = true;
              $19.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $19.end) {
              final c = $19.data.codeUnitAt(state.pos - $19.start);
              final $20 = c >= 49 && c <= 57;
              if ($20) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $57 = state.ok;
            if (!$57) {
              $3 = 6;
              break;
            }
            $22 = state.isOptional;
            state.isOptional = true;
            $3 = 8;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($18);
            }
            $3 = 4;
            break;
          case 7:
            state.isOptional = $22;
            state.setOk(true);
            $3 = 6;
            break;
          case 8:
            final $23 = state.input;
            if (state.pos >= $23.end && !$23.isClosed) {
              $23.sleep = true;
              $23.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $23.end) {
              final c = $23.data.codeUnitAt(state.pos - $23.start);
              final $24 = c >= 48 && c <= 57;
              if ($24) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 7;
              break;
            }
            $3 = 8;
            break;
          case 9:
            $3 = 2;
            break;
          case 10:
            final $30 = state.input;
            if (state.pos >= $30.end && !$30.isClosed) {
              $30.sleep = true;
              $30.handle = $1;
              $3 = 10;
              return;
            }
            if (state.pos < $30.end) {
              final ok = $30.data.codeUnitAt(state.pos - $30.start) == 46;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $60 = state.ok;
            if (!$60) {
              $3 = 11;
              break;
            }
            $28 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $61 = state.ok;
            if (!$61) {
              $3 = 12;
              break;
            }
            $33 = false;
            $32 = state.isOptional;
            $3 = 14;
            break;
          case 11:
            if (!state.ok) {
              if (!$28) {
                state.isRecoverable = false;
              }
              state.backtrack($29);
            }
            state.isOptional = $27;
            state.isOptional = $26;
            if (!state.ok) {
              state.setOk(true);
            }
            final $63 = state.ok;
            if (!$63) {
              $3 = 16;
              break;
            }
            $37 = state.isOptional;
            state.isOptional = true;
            $40 = state.pos;
            $39 = true;
            $38 = state.isOptional;
            $3 = 17;
            break;
          case 12:
            $3 = 11;
            break;
          case 13:
            state.isOptional = $32;
            state.setOk($33);
            $3 = 12;
            break;
          case 14:
            state.isOptional = $33;
            $3 = 15;
            break;
          case 15:
            final $34 = state.input;
            if (state.pos >= $34.end && !$34.isClosed) {
              $34.sleep = true;
              $34.handle = $1;
              $3 = 15;
              return;
            }
            if (state.pos < $34.end) {
              final c = $34.data.codeUnitAt(state.pos - $34.start);
              final $35 = c >= 48 && c <= 57;
              if ($35) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 13;
              break;
            }
            $33 = true;
            $3 = 14;
            break;
          case 16:
            $3 = 9;
            break;
          case 17:
            final $41 = state.input;
            if (state.pos >= $41.end && !$41.isClosed) {
              $41.sleep = true;
              $41.handle = $1;
              $3 = 17;
              return;
            }
            if (state.pos < $41.end) {
              final c = $41.data.codeUnitAt(state.pos - $41.start);
              final $42 = c == 69 || c == 101;
              if ($42) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $64 = state.ok;
            if (!$64) {
              $3 = 18;
              break;
            }
            $39 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $65 = state.ok;
            if (!$65) {
              $3 = 19;
              break;
            }
            $44 = state.isOptional;
            state.isOptional = true;
            $3 = 20;
            break;
          case 18:
            if (!state.ok) {
              if (!$39) {
                state.isRecoverable = false;
              }
              state.backtrack($40);
            }
            state.isOptional = $38;
            state.isOptional = $37;
            if (!state.ok) {
              state.setOk(true);
            }
            $3 = 16;
            break;
          case 19:
            $3 = 18;
            break;
          case 20:
            final $45 = state.input;
            if (state.pos >= $45.end && !$45.isClosed) {
              $45.sleep = true;
              $45.handle = $1;
              $3 = 20;
              return;
            }
            if (state.pos < $45.end) {
              final c = $45.data.codeUnitAt(state.pos - $45.start);
              final $46 = c == 43 || c == 45;
              if ($46) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            state.isOptional = $44;
            if (!state.ok) {
              state.setOk(true);
            }
            final $66 = state.ok;
            if (!$66) {
              $3 = 21;
              break;
            }
            $49 = false;
            $48 = state.isOptional;
            $3 = 23;
            break;
          case 21:
            $3 = 19;
            break;
          case 22:
            state.isOptional = $48;
            state.setOk($49);
            $3 = 21;
            break;
          case 23:
            state.isOptional = $49;
            $3 = 24;
            break;
          case 24:
            final $50 = state.input;
            if (state.pos >= $50.end && !$50.isClosed) {
              $50.sleep = true;
              $50.handle = $1;
              $3 = 24;
              return;
            }
            if (state.pos < $50.end) {
              final c = $50.data.codeUnitAt(state.pos - $50.start);
              final $51 = c >= 48 && c <= 57;
              if ($51) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 22;
              break;
            }
            $49 = true;
            $3 = 23;
            break;
          case 25:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 26:
            if (state.ok) {
              $2 = $4;
            }
            $3 = 25;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos;
    var $2 = true;
    final $3 = state.isOptional;
    // @inline OpenBrace = v:'{' Spaces ;
    // v:'{' Spaces
    final $5 = state.pos;
    const $6 = '{';
    final $7 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 123;
    if ($7) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$6]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($5);
    }
    if (state.ok) {
      $2 = false;
      state.isOptional = false;
      state.setOk(true);
      if (state.ok) {
        List<MapEntry<String, Object?>>? $1;
        // KeyValues
        $1 = parseKeyValues(state);
        if (state.ok) {
          // @inline CloseBrace = v:'}' Spaces ;
          // v:'}' Spaces
          final $8 = state.pos;
          const $9 = '}';
          final $10 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 125;
          if ($10) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$9]));
          }
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($8);
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
      state.backtrack($4);
    }
    state.isOptional = $3;
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
    var $3 = 0;
    late bool $5;
    late bool $6;
    late int $7;
    late int $8;
    late AsyncResult<Object?> $13;
    List<MapEntry<String, Object?>>? $4;
    late AsyncResult<List<MapEntry<String, Object?>>> $15;
    late int $17;
    late AsyncResult<Object?> $22;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $6 = true;
            $5 = state.isOptional;
            $8 = state.pos;
            $3 = 1;
            break;
          case 1:
            final $9 = state.input;
            if (state.pos >= $9.end && !$9.isClosed) {
              $9.sleep = true;
              $9.handle = $1;
              $3 = 1;
              return;
            }
            const $10 = '{';
            final $11 = state.pos < $9.end &&
                $9.data.codeUnitAt(state.pos - $9.start) == 123;
            if ($11) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$10]));
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 2;
              break;
            }
            $13 = fastParseSpaces$Async(state);
            if (!$13.isComplete) {
              $13.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($8);
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 4;
              break;
            }
            $6 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $26 = state.ok;
            if (!$26) {
              $3 = 5;
              break;
            }
            $15 = parseKeyValues$Async(state);
            if (!$15.isComplete) {
              $15.onComplete = $1;
              $3 = 6;
              return;
            }
            $3 = 6;
            break;
          case 3:
            $3 = 2;
            break;
          case 4:
            if (!state.ok) {
              if (!$6) {
                state.isRecoverable = false;
              }
              state.backtrack($7);
            }
            state.isOptional = $5;
            endEvent<Map<String, Object?>>(
                JsonParserEvent.objectEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 5:
            $3 = 4;
            break;
          case 6:
            $4 = $15.value;
            final $27 = state.ok;
            if (!$27) {
              $3 = 7;
              break;
            }
            $17 = state.pos;
            $3 = 8;
            break;
          case 7:
            $3 = 5;
            break;
          case 8:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 8;
              return;
            }
            const $19 = '}';
            final $20 = state.pos < $18.end &&
                $18.data.codeUnitAt(state.pos - $18.start) == 125;
            if ($20) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$19]));
            }
            final $28 = state.ok;
            if (!$28) {
              $3 = 9;
              break;
            }
            $22 = fastParseSpaces$Async(state);
            if (!$22.isComplete) {
              $22.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 9:
            if (!state.ok) {
              state.backtrack($17);
            }
            if (state.ok) {
              Map<String, Object?>? $$;
              final kv = $4!;
              $$ = kv.isEmpty ? const {} : Map.fromEntries(kv);
              $2 = $$;
            }
            $3 = 7;
            break;
          case 10:
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
        if (state.pos >= state.input.length) {
          state.setOk(true);
        } else {
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
    var $3 = 0;
    late int $5;
    late AsyncResult<Object?> $6;
    Object? $4;
    late AsyncResult<Object?> $8;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $5 = state.pos;
            $6 = fastParseSpaces$Async(state);
            if (!$6.isComplete) {
              $6.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            final $12 = state.ok;
            if (!$12) {
              $3 = 2;
              break;
            }
            $8 = parseValue$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($5);
            }
            endEvent<Object?>(JsonParserEvent.startEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $4 = $8.value;
            final $13 = state.ok;
            if (!$13) {
              $3 = 4;
              break;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            final $10 = state.input;
            if (state.pos >= $10.end && !$10.isClosed) {
              $10.sleep = true;
              $10.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos >= $10.end) {
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedEndOfInput());
            }
            if (state.ok) {
              $2 = $4;
            }
            $3 = 4;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $4 = state.pos;
    var $2 = true;
    final $3 = state.isOptional;
    const $5 = '"';
    final $6 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 34;
    if ($6) {
      state.pos++;
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      $2 = false;
      state.isOptional = false;
      state.setOk(true);
      if (state.ok) {
        String? $1;
        // @inline StringChars = @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex)) ;
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        List<String>? $17;
        String? $19;
        while (true) {
          String? $8;
          // $[ -!#-[\]-\u{10ffff}]+
          final $11 = state.pos;
          var $12 = false;
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.runeAt(state.pos)) == c &&
                  (c < 35
                      ? c >= 32 && c <= 33
                      : c <= 91 || c >= 93 && c <= 1114111);
              state.pos += c > 0xffff ? 2 : 1,
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              $12 = true);
          if ($12) {
            state.setOk($12);
          } else {
            state.pos < state.input.length
                ? state.fail(const ErrorUnexpectedCharacter())
                : state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $8 = state.input.substring($11, state.pos);
          }
          if (state.ok) {
            final v = $8!;
            if ($19 == null) {
              $19 = v;
            } else if ($17 == null) {
              $17 = [$19, v];
            } else {
              $17.add(v);
            }
          }
          final $18 = state.pos;
          // [\\]
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 92;
            if (ok) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (!state.ok) {
            break;
          }
          String? $9;
          // (EscapeChar / EscapeHex)
          // EscapeChar
          // EscapeChar
          $9 = parseEscapeChar(state);
          if (!state.ok && state.isRecoverable) {
            // EscapeHex
            // EscapeHex
            $9 = parseEscapeHex(state);
          }
          if (!state.ok) {
            state.backtrack($18);
            break;
          }
          if ($19 == null) {
            $19 = $9!;
          } else {
            if ($17 == null) {
              $17 = [$19, $9!];
            } else {
              $17.add($9!);
            }
          }
        }
        state.setOk(true);
        if ($19 == null) {
          $1 = '';
        } else if ($17 == null) {
          $1 = $19;
        } else {
          $1 = $17.join();
        }
        if (state.ok) {
          // @inline Quote = v:'"' Spaces ;
          // v:'"' Spaces
          final $20 = state.pos;
          const $21 = '"';
          final $22 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 34;
          if ($22) {
            state.pos++;
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$21]));
          }
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($20);
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
      state.backtrack($4);
    }
    state.isOptional = $3;
    return $0;
  }

  /// String
  /// String =
  ///   '"' ↑ v:StringChars Quote
  ///   ;
  AsyncResult<String> parseString$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<String>();
    String? $2;
    var $3 = 0;
    late bool $5;
    late bool $6;
    late int $7;
    String? $4;
    List<String>? $14;
    late int $15;
    String? $16;
    String? $12;
    late int $17;
    late bool $18;
    late bool $19;
    String? $13;
    late AsyncResult<String> $25;
    late AsyncResult<String> $27;
    late int $29;
    late AsyncResult<Object?> $34;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $6 = true;
            $5 = state.isOptional;
            $3 = 1;
            break;
          case 1:
            final $8 = state.input;
            if (state.pos >= $8.end && !$8.isClosed) {
              $8.sleep = true;
              $8.handle = $1;
              $3 = 1;
              return;
            }
            const $9 = '"';
            final $10 = state.pos < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 34;
            if ($10) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$9]));
            }
            final $36 = state.ok;
            if (!$36) {
              $3 = 2;
              break;
            }
            $6 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $37 = state.ok;
            if (!$37) {
              $3 = 3;
              break;
            }
            $14 = null;
            $16 = null;
            $3 = 5;
            break;
          case 2:
            if (!state.ok) {
              if (!$6) {
                state.isRecoverable = false;
              }
              state.backtrack($7);
            }
            state.isOptional = $5;
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $3 = 2;
            break;
          case 4:
            state.setOk(true);
            if ($16 == null) {
              $4 = '';
            } else if ($14 == null) {
              $4 = $16;
            } else {
              $4 = $14!.join();
            }
            final $41 = state.ok;
            if (!$41) {
              $3 = 13;
              break;
            }
            $29 = state.pos;
            $3 = 14;
            break;
          case 5:
            $17 = state.pos;
            state.input.beginBuffering();
            $19 = false;
            $18 = state.isOptional;
            $3 = 7;
            break;
          case 6:
            state.isOptional = $18;
            state.setOk($19);
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $12 = input.data.substring($17 - start, state.pos - start);
            }
            if (state.ok) {
              final v = $12!;
              if ($16 == null) {
                $16 = v;
              } else if ($14 == null) {
                $14 = [$16!, v];
              } else {
                $14!.add(v);
              }
            }
            $15 = state.pos;
            $3 = 9;
            break;
          case 7:
            state.isOptional = $19;
            $3 = 8;
            break;
          case 8:
            final $20 = state.input;
            if (state.pos >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $20.end) {
              final c = $20.data.runeAt(state.pos - $20.start);
              final $21 = c < 35
                  ? c >= 32 && c <= 33
                  : c <= 91 || c >= 93 && c <= 1114111;
              if ($21) {
                state.pos += c > 0xffff ? 2 : 1;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 6;
              break;
            }
            $19 = true;
            $3 = 7;
            break;
          case 9:
            final $23 = state.input;
            if (state.pos >= $23.end && !$23.isClosed) {
              $23.sleep = true;
              $23.handle = $1;
              $3 = 9;
              return;
            }
            if (state.pos < $23.end) {
              final ok = $23.data.codeUnitAt(state.pos - $23.start) == 92;
              if (ok) {
                state.pos++;
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 4;
              break;
            }
            $25 = parseEscapeChar$Async(state);
            if (!$25.isComplete) {
              $25.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 10:
            $13 = $25.value;
            final $40 = !state.ok && state.isRecoverable;
            if (!$40) {
              $3 = 11;
              break;
            }
            $27 = parseEscapeHex$Async(state);
            if (!$27.isComplete) {
              $27.onComplete = $1;
              $3 = 12;
              return;
            }
            $3 = 12;
            break;
          case 11:
            if (!state.ok) {
              state.backtrack($15);
              $3 = 4;
              break;
            }
            if ($16 == null) {
              $16 = $13!;
            } else if ($14 == null) {
              $14 = [$16!, $13!];
            } else {
              $14!.add($13!);
            }
            $3 = 5;
            break;
          case 12:
            $13 = $27.value;
            $3 = 11;
            break;
          case 13:
            $3 = 3;
            break;
          case 14:
            final $30 = state.input;
            if (state.pos >= $30.end && !$30.isClosed) {
              $30.sleep = true;
              $30.handle = $1;
              $3 = 14;
              return;
            }
            const $31 = '"';
            final $32 = state.pos < $30.end &&
                $30.data.codeUnitAt(state.pos - $30.start) == 34;
            if ($32) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$31]));
            }
            final $42 = state.ok;
            if (!$42) {
              $3 = 15;
              break;
            }
            $34 = fastParseSpaces$Async(state);
            if (!$34.isComplete) {
              $34.onComplete = $1;
              $3 = 16;
              return;
            }
            $3 = 16;
            break;
          case 15:
            if (!state.ok) {
              state.backtrack($29);
            }
            if (state.ok) {
              $2 = $4;
            }
            $3 = 13;
            break;
          case 16:
            $3 = 15;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
            final $8 = state.pos + 3 < state.input.length &&
                state.input.codeUnitAt(state.pos) == 116 &&
                state.input.codeUnitAt(state.pos + 1) == 114 &&
                state.input.codeUnitAt(state.pos + 2) == 117 &&
                state.input.codeUnitAt(state.pos + 3) == 101;
            if ($8) {
              state.pos += 4;
              state.setOk(true);
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
              final $10 = state.pos;
              const $11 = 'false';
              final $12 = state.pos + 4 < state.input.length &&
                  state.input.codeUnitAt(state.pos) == 102 &&
                  state.input.codeUnitAt(state.pos + 1) == 97 &&
                  state.input.codeUnitAt(state.pos + 2) == 108 &&
                  state.input.codeUnitAt(state.pos + 3) == 115 &&
                  state.input.codeUnitAt(state.pos + 4) == 101;
              if ($12) {
                state.pos += 5;
                state.setOk(true);
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
                final $14 = state.pos;
                const $15 = 'null';
                final $16 = state.pos + 3 < state.input.length &&
                    state.input.codeUnitAt(state.pos) == 110 &&
                    state.input.codeUnitAt(state.pos + 1) == 117 &&
                    state.input.codeUnitAt(state.pos + 2) == 108 &&
                    state.input.codeUnitAt(state.pos + 3) == 108;
                if ($16) {
                  state.pos += 4;
                  state.setOk(true);
                } else {
                  state.fail(const ErrorExpectedTags([$15]));
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
                  state.backtrack($14);
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
    var $3 = 0;
    late AsyncResult<String> $4;
    late AsyncResult<Map<String, Object?>> $6;
    late AsyncResult<List<Object?>> $8;
    late AsyncResult<num> $10;
    late int $12;
    late AsyncResult<Object?> $17;
    late int $19;
    late AsyncResult<Object?> $24;
    late int $26;
    late AsyncResult<Object?> $31;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $4 = parseString$Async(state);
            if (!$4.isComplete) {
              $4.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $2 = $4.value;
            final $33 = !state.ok && state.isRecoverable;
            if (!$33) {
              $3 = 2;
              break;
            }
            $6 = parseObject$Async(state);
            if (!$6.isComplete) {
              $6.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            endEvent<Object?>(JsonParserEvent.valueEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $2 = $6.value;
            final $34 = !state.ok && state.isRecoverable;
            if (!$34) {
              $3 = 4;
              break;
            }
            $8 = parseArray$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 5;
              return;
            }
            $3 = 5;
            break;
          case 4:
            $3 = 2;
            break;
          case 5:
            $2 = $8.value;
            final $35 = !state.ok && state.isRecoverable;
            if (!$35) {
              $3 = 6;
              break;
            }
            $10 = parseNumber$Async(state);
            if (!$10.isComplete) {
              $10.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            $3 = 4;
            break;
          case 7:
            $2 = $10.value;
            final $36 = !state.ok && state.isRecoverable;
            if (!$36) {
              $3 = 8;
              break;
            }
            $12 = state.pos;
            $3 = 9;
            break;
          case 8:
            $3 = 6;
            break;
          case 9:
            final $13 = state.input;
            if (state.pos + 3 >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 9;
              return;
            }
            const $14 = 'true';
            final $15 = state.pos + 3 < $13.end &&
                $13.data.codeUnitAt(state.pos - $13.start) == 116 &&
                $13.data.codeUnitAt(state.pos - $13.start + 1) == 114 &&
                $13.data.codeUnitAt(state.pos - $13.start + 2) == 117 &&
                $13.data.codeUnitAt(state.pos - $13.start + 3) == 101;
            if ($15) {
              state.pos += 4;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$14]));
            }
            final $37 = state.ok;
            if (!$37) {
              $3 = 10;
              break;
            }
            $17 = fastParseSpaces$Async(state);
            if (!$17.isComplete) {
              $17.onComplete = $1;
              $3 = 11;
              return;
            }
            $3 = 11;
            break;
          case 10:
            if (!state.ok) {
              state.backtrack($12);
            }
            final $38 = !state.ok && state.isRecoverable;
            if (!$38) {
              $3 = 12;
              break;
            }
            $19 = state.pos;
            $3 = 13;
            break;
          case 11:
            if (state.ok) {
              bool? $$;
              $$ = true;
              $2 = $$;
            }
            $3 = 10;
            break;
          case 12:
            $3 = 8;
            break;
          case 13:
            final $20 = state.input;
            if (state.pos + 4 >= $20.end && !$20.isClosed) {
              $20.sleep = true;
              $20.handle = $1;
              $3 = 13;
              return;
            }
            const $21 = 'false';
            final $22 = state.pos + 4 < $20.end &&
                $20.data.codeUnitAt(state.pos - $20.start) == 102 &&
                $20.data.codeUnitAt(state.pos - $20.start + 1) == 97 &&
                $20.data.codeUnitAt(state.pos - $20.start + 2) == 108 &&
                $20.data.codeUnitAt(state.pos - $20.start + 3) == 115 &&
                $20.data.codeUnitAt(state.pos - $20.start + 4) == 101;
            if ($22) {
              state.pos += 5;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$21]));
            }
            final $39 = state.ok;
            if (!$39) {
              $3 = 14;
              break;
            }
            $24 = fastParseSpaces$Async(state);
            if (!$24.isComplete) {
              $24.onComplete = $1;
              $3 = 15;
              return;
            }
            $3 = 15;
            break;
          case 14:
            if (!state.ok) {
              state.backtrack($19);
            }
            final $40 = !state.ok && state.isRecoverable;
            if (!$40) {
              $3 = 16;
              break;
            }
            $26 = state.pos;
            $3 = 17;
            break;
          case 15:
            if (state.ok) {
              bool? $$;
              $$ = false;
              $2 = $$;
            }
            $3 = 14;
            break;
          case 16:
            $3 = 12;
            break;
          case 17:
            final $27 = state.input;
            if (state.pos + 3 >= $27.end && !$27.isClosed) {
              $27.sleep = true;
              $27.handle = $1;
              $3 = 17;
              return;
            }
            const $28 = 'null';
            final $29 = state.pos + 3 < $27.end &&
                $27.data.codeUnitAt(state.pos - $27.start) == 110 &&
                $27.data.codeUnitAt(state.pos - $27.start + 1) == 117 &&
                $27.data.codeUnitAt(state.pos - $27.start + 2) == 108 &&
                $27.data.codeUnitAt(state.pos - $27.start + 3) == 108;
            if ($29) {
              state.pos += 4;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$28]));
            }
            final $41 = state.ok;
            if (!$41) {
              $3 = 18;
              break;
            }
            $31 = fastParseSpaces$Async(state);
            if (!$31.isComplete) {
              $31.onComplete = $1;
              $3 = 19;
              return;
            }
            $3 = 19;
            break;
          case 18:
            if (!state.ok) {
              state.backtrack($26);
            }
            $3 = 16;
            break;
          case 19:
            if (state.ok) {
              Object? $$;
              $$ = null;
              $2 = $$;
            }
            $3 = 18;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
    final $5 = state.isOptional;
    state.isOptional = true;
    Object? $3;
    // Value
    // Value
    $3 = parseValue(state);
    if (state.ok) {
      $2.add($3);
      while (true) {
        Object? $4;
        // Comma ↑ v:Value
        final $11 = state.pos;
        var $9 = true;
        final $10 = state.isOptional;
        // @inline Comma = v:',' Spaces ;
        // v:',' Spaces
        final $12 = state.pos;
        const $13 = ',';
        final $14 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 44;
        if ($14) {
          state.pos++;
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$13]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($12);
        }
        if (state.ok) {
          $9 = false;
          state.isOptional = false;
          state.setOk(true);
          if (state.ok) {
            Object? $8;
            // Value
            $8 = parseValue(state);
            if (state.ok) {
              $4 = $8;
            }
          }
        }
        if (!state.ok) {
          if (!$9) {
            state.isRecoverable = false;
          }
          state.backtrack($11);
        }
        state.isOptional = $10;
        if (!state.ok) {
          break;
        }
        $2.add($4);
      }
    }
    state.isOptional = $5;
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
    var $3 = 0;
    late bool $6;
    late List<Object?> $7;
    Object? $4;
    late AsyncResult<Object?> $8;
    Object? $5;
    late bool $11;
    late bool $12;
    late int $13;
    late int $14;
    late AsyncResult<Object?> $19;
    Object? $10;
    late AsyncResult<Object?> $21;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = [];
            $6 = state.isOptional;
            state.isOptional = true;
            $8 = parseValue$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $8.value;
            final $23 = state.ok;
            if (!$23) {
              $3 = 2;
              break;
            }
            $7.add($4);
            $3 = 4;
            break;
          case 2:
            state.isOptional = $6;
            state.setOk(true);
            if (state.ok) {
              $2 = $7;
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            $3 = 2;
            break;
          case 4:
            $13 = state.pos;
            $12 = true;
            $11 = state.isOptional;
            $14 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 5;
              return;
            }
            const $16 = ',';
            final $17 = state.pos < $15.end &&
                $15.data.codeUnitAt(state.pos - $15.start) == 44;
            if ($17) {
              state.pos++;
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$16]));
            }
            final $25 = state.ok;
            if (!$25) {
              $3 = 6;
              break;
            }
            $19 = fastParseSpaces$Async(state);
            if (!$19.isComplete) {
              $19.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($14);
            }
            final $26 = state.ok;
            if (!$26) {
              $3 = 8;
              break;
            }
            $12 = false;
            state.isOptional = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $27 = state.ok;
            if (!$27) {
              $3 = 9;
              break;
            }
            $21 = parseValue$Async(state);
            if (!$21.isComplete) {
              $21.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 7:
            $3 = 6;
            break;
          case 8:
            if (!state.ok) {
              if (!$12) {
                state.isRecoverable = false;
              }
              state.backtrack($13);
            }
            state.isOptional = $11;
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $7.add($5);
            $3 = 4;
            break;
          case 9:
            $3 = 8;
            break;
          case 10:
            $10 = $21.value;
            if (state.ok) {
              $5 = $10;
            }
            $3 = 9;
            break;
          default:
            throw StateError('Invalid state: ${$3}');
        }
      }
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
      errors.map((e) => e.length < 0 ? offset + e.length : offset).toSet();
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
  if (errorList.isEmpty) {
    errorList.add(const ErrorUnknownError());
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

    this.data = this.data.isNotEmpty ? '${this.data}$data' : data;
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
      this.data = _cuttingPosition != end
          ? this.data.substring(_cuttingPosition - start)
          : '';
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
  int errorCount = 0;

  int failPos = 0;

  final T input;

  bool isOptional = false;

  bool isRecoverable = true;

  int lastFailPos = -1;

  bool ok = false;

  int pos = 0;

  final List<ParseError?> _errors = List.filled(256, null, growable: false);

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void advance(int offset) {
    pos += offset;
  }

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
    return failAt(pos, error);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAll(List<ParseError> errors) {
    return failAllAt(pos, errors);
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAllAt(int offset, List<ParseError> errors) {
    ok = false;
    if (!isOptional || !isRecoverable) {
      if (offset >= failPos) {
        if (failPos < offset) {
          failPos = offset;
          errorCount = 0;
        }

        for (var i = 0; i < errors.length; i++) {
          if (errorCount < errors.length) {
            _errors[errorCount++] = errors[i];
          }
        }

        if (lastFailPos < offset) {
          lastFailPos = offset;
        }
      }
    }

    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  bool failAt(int offset, ParseError error) {
    ok = false;
    if (!isOptional || !isRecoverable) {
      if (offset >= failPos) {
        if (failPos < offset) {
          failPos = offset;
          errorCount = 0;
        }

        if (errorCount < _errors.length) {
          _errors[errorCount++] = error;
        }
      }
    }

    if (lastFailPos < offset) {
      lastFailPos = offset;
    }

    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  List<ParseError> getErrors() {
    return List.generate(errorCount, (i) => _errors[i]!);
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
        return '$ok $pos:';
      }

      var length = input.length - pos;
      length = length > 40 ? 40 : length;
      final string = input.substring(pos, pos + length);
      return '$ok $pos:$string';
    } else if (input case final ChunkedParsingSink input) {
      final source = input.data;
      final pos = this.pos - input.start;
      if (pos < 0 || pos >= source.length) {
        return '$ok $pos:';
      }

      var length = source.length - pos;
      length = length > 40 ? 40 : length;
      final string = source.substring(pos, pos + length);
      return '$ok $pos:$string';
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

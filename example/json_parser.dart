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
        state.advance(1));
    state.setOk(true);
  }

  /// Spaces =
  ///   [ \n\r\t]*
  ///   ;
  AsyncResult<Object?> fastParseSpaces$Async(State<ChunkedParsingSink> state) {
    final $0 = AsyncResult<Object?>();
    var $2 = 0;
    void $1() {
      while (true) {
        switch ($2) {
          case 0:
            final $3 = state.input;
            if (state.pos >= $3.end && !$3.isClosed) {
              $3.sleep = true;
              $3.handle = $1;
              $2 = 0;
              return;
            }
            if (state.pos < $3.end) {
              final c = $3.data.codeUnitAt(state.pos - $3.start);
              final $4 = c < 13 ? c >= 9 && c <= 10 : c <= 13 || c == 32;
              if ($4) {
                state.advance(1);
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
            $2 = 0;
            break;
          case 1:
            state.setOk(true);
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $2 = -1;
            return;
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
    final $3 = state.pos;
    var $2 = true;
    // @inline OpenBracket = v:'[' Spaces ;
    // v:'[' Spaces
    final $4 = state.pos;
    const $5 = '[';
    final $6 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 91;
    if ($6) {
      state.advance(1);
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $2 = false;
      state.setOk(true);
      if (state.ok) {
        List<Object?>? $1;
        // Values
        $1 = parseValues(state);
        if (state.ok) {
          // @inline CloseBracket = v:']' Spaces ;
          // v:']' Spaces
          final $7 = state.pos;
          const $8 = ']';
          final $9 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 93;
          if ($9) {
            state.advance(1);
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
    var $3 = 0;
    late bool $5;
    late int $6;
    late int $7;
    late AsyncResult<Object?> $12;
    List<Object?>? $4;
    late AsyncResult<List<Object?>> $14;
    late int $16;
    late AsyncResult<Object?> $21;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $5 = true;
            $7 = state.pos;
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
            const $9 = '[';
            final $10 = state.pos < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 91;
            if ($10) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$9]));
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 2;
              break;
            }
            $12 = fastParseSpaces$Async(state);
            if (!$12.isComplete) {
              $12.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($7);
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 4;
              break;
            }
            $5 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $25 = state.ok;
            if (!$25) {
              $3 = 5;
              break;
            }
            $14 = parseValues$Async(state);
            if (!$14.isComplete) {
              $14.onComplete = $1;
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
              if (!$5) {
                state.isRecoverable = false;
              }
              state.backtrack($6);
            }
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
            $4 = $14.value;
            final $26 = state.ok;
            if (!$26) {
              $3 = 7;
              break;
            }
            $16 = state.pos;
            $3 = 8;
            break;
          case 7:
            $3 = 5;
            break;
          case 8:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $3 = 8;
              return;
            }
            const $18 = ']';
            final $19 = state.pos < $17.end &&
                $17.data.codeUnitAt(state.pos - $17.start) == 93;
            if ($19) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$18]));
            }
            final $27 = state.ok;
            if (!$27) {
              $3 = 9;
              break;
            }
            $21 = fastParseSpaces$Async(state);
            if (!$21.isComplete) {
              $21.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 9:
            if (!state.ok) {
              state.backtrack($16);
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
        state.advance(1);
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
                state.advance(1);
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
      state.advance(1);
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
              state.advance(1);
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
          state.advance(1);
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
                state.advance(1);
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
      final $8 = state.pos < state.input.length &&
          state.input.codeUnitAt(state.pos) == 58;
      if ($8) {
        state.advance(1);
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$7]));
      }
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (state.ok) {
        $3 = false;
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
    var $3 = 0;
    late bool $6;
    late int $7;
    String? $4;
    late AsyncResult<String> $8;
    late int $10;
    late AsyncResult<Object?> $15;
    Object? $5;
    late AsyncResult<Object?> $17;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $7 = state.pos;
            $6 = true;
            beginEvent(JsonParserEvent.keyEvent);
            $8 = parseString$Async(state);
            if (!$8.isComplete) {
              $8.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $8.value;
            $4 = endEvent<String>(JsonParserEvent.keyEvent, $4, state.ok);
            final $19 = state.ok;
            if (!$19) {
              $3 = 2;
              break;
            }
            $10 = state.pos;
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              if (!$6) {
                state.isRecoverable = false;
              }
              state.backtrack($7);
            }
            endEvent<MapEntry<String, Object?>>(
                JsonParserEvent.keyValueEvent, $2, state.ok);
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 3:
            final $11 = state.input;
            if (state.pos >= $11.end && !$11.isClosed) {
              $11.sleep = true;
              $11.handle = $1;
              $3 = 3;
              return;
            }
            const $12 = ':';
            final $13 = state.pos < $11.end &&
                $11.data.codeUnitAt(state.pos - $11.start) == 58;
            if ($13) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$12]));
            }
            final $20 = state.ok;
            if (!$20) {
              $3 = 4;
              break;
            }
            $15 = fastParseSpaces$Async(state);
            if (!$15.isComplete) {
              $15.onComplete = $1;
              $3 = 5;
              return;
            }
            $3 = 5;
            break;
          case 4:
            if (!state.ok) {
              state.backtrack($10);
            }
            final $21 = state.ok;
            if (!$21) {
              $3 = 6;
              break;
            }
            $6 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $22 = state.ok;
            if (!$22) {
              $3 = 7;
              break;
            }
            $17 = parseValue$Async(state);
            if (!$17.isComplete) {
              $17.onComplete = $1;
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
            $5 = $17.value;
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
        final $12 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 44;
        if ($12) {
          state.advance(1);
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$11]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($10);
        }
        if (state.ok) {
          $8 = false;
          state.setOk(true);
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
    var $3 = 0;
    late List<MapEntry<String, Object?>> $6;
    MapEntry<String, Object?>? $4;
    late AsyncResult<MapEntry<String, Object?>> $7;
    MapEntry<String, Object?>? $5;
    late bool $10;
    late int $11;
    late int $12;
    late AsyncResult<Object?> $17;
    MapEntry<String, Object?>? $9;
    late AsyncResult<MapEntry<String, Object?>> $19;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = [];
            $7 = parseKeyValue$Async(state);
            if (!$7.isComplete) {
              $7.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $7.value;
            final $21 = state.ok;
            if (!$21) {
              $3 = 2;
              break;
            }
            $6.add($4!);
            $3 = 4;
            break;
          case 2:
            state.setOk(true);
            if (state.ok) {
              $2 = $6;
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
            $11 = state.pos;
            $10 = true;
            $12 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 5;
              return;
            }
            const $14 = ',';
            final $15 = state.pos < $13.end &&
                $13.data.codeUnitAt(state.pos - $13.start) == 44;
            if ($15) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$14]));
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 6;
              break;
            }
            $17 = fastParseSpaces$Async(state);
            if (!$17.isComplete) {
              $17.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($12);
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 8;
              break;
            }
            $10 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $25 = state.ok;
            if (!$25) {
              $3 = 9;
              break;
            }
            $19 = parseKeyValue$Async(state);
            if (!$19.isComplete) {
              $19.onComplete = $1;
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
              if (!$10) {
                state.isRecoverable = false;
              }
              state.backtrack($11);
            }
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $6.add($5!);
            $3 = 4;
            break;
          case 9:
            $3 = 8;
            break;
          case 10:
            $9 = $19.value;
            if (state.ok) {
              $5 = $9;
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
    if (state.pos < state.input.length) {
      final ok = state.input.codeUnitAt(state.pos) == 45;
      if (ok) {
        state.advance(1);
        state.setOk(true);
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
      // [0]
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 48;
        if (ok) {
          state.advance(1);
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      if (!state.ok && state.isRecoverable) {
        // [1-9] [0-9]*
        final $13 = state.pos;
        if (state.pos < state.input.length) {
          final $14 = state.input.codeUnitAt(state.pos);
          final $15 = $14 >= 49 && $14 <= 57;
          if ($15) {
            state.advance(1);
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
              state.advance(1));
          state.setOk(true);
        }
        if (!state.ok) {
          state.backtrack($13);
        }
      }
      if (state.ok) {
        // [.] ↑ [0-9]+
        final $17 = state.pos;
        var $16 = true;
        if (state.pos < state.input.length) {
          final ok = state.input.codeUnitAt(state.pos) == 46;
          if (ok) {
            state.advance(1);
            state.setOk(true);
          } else {
            state.fail(const ErrorUnexpectedCharacter());
          }
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $16 = false;
          state.setOk(true);
          if (state.ok) {
            var $18 = false;
            for (var c = 0;
                state.pos < state.input.length &&
                    (c = state.input.codeUnitAt(state.pos)) == c &&
                    (c >= 48 && c <= 57);
                state.advance(1),
                // ignore: curly_braces_in_flow_control_structures, empty_statements
                $18 = true);
            if ($18) {
              state.setOk($18);
            } else {
              state.pos < state.input.length
                  ? state.fail(const ErrorUnexpectedCharacter())
                  : state.fail(const ErrorUnexpectedEndOfInput());
            }
          }
        }
        if (!state.ok) {
          if (!$16) {
            state.isRecoverable = false;
          }
          state.backtrack($17);
        }
        if (!state.ok) {
          state.setOk(true);
        }
        if (state.ok) {
          // [eE] ↑ [-+]? [0-9]+
          final $20 = state.pos;
          var $19 = true;
          if (state.pos < state.input.length) {
            final $21 = state.input.codeUnitAt(state.pos);
            final $22 = $21 == 69 || $21 == 101;
            if ($22) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorUnexpectedCharacter());
            }
          } else {
            state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $19 = false;
            state.setOk(true);
            if (state.ok) {
              if (state.pos < state.input.length) {
                final $23 = state.input.codeUnitAt(state.pos);
                final $24 = $23 == 43 || $23 == 45;
                if ($24) {
                  state.advance(1);
                  state.setOk(true);
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
                var $25 = false;
                for (var c = 0;
                    state.pos < state.input.length &&
                        (c = state.input.codeUnitAt(state.pos)) == c &&
                        (c >= 48 && c <= 57);
                    state.advance(1),
                    // ignore: curly_braces_in_flow_control_structures, empty_statements
                    $25 = true);
                if ($25) {
                  state.setOk($25);
                } else {
                  state.pos < state.input.length
                      ? state.fail(const ErrorUnexpectedCharacter())
                      : state.fail(const ErrorUnexpectedEndOfInput());
                }
              }
            }
          }
          if (!state.ok) {
            if (!$19) {
              state.isRecoverable = false;
            }
            state.backtrack($20);
          }
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
    late int $17;
    late bool $24;
    late int $25;
    late bool $28;
    late bool $32;
    late int $33;
    late bool $40;
    late AsyncResult<Object?> $44;
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
            $3 = 1;
            break;
          case 1:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 1;
              return;
            }
            if (state.pos < $13.end) {
              final ok = $13.data.codeUnitAt(state.pos - $13.start) == 45;
              if (ok) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              state.setOk(true);
            }
            final $46 = state.ok;
            if (!$46) {
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
            final $59 = state.ok;
            if (!$59) {
              $3 = 23;
              break;
            }
            $44 = fastParseSpaces$Async(state);
            if (!$44.isComplete) {
              $44.onComplete = $1;
              $3 = 24;
              return;
            }
            $3 = 24;
            break;
          case 3:
            final $15 = state.input;
            if (state.pos >= $15.end && !$15.isClosed) {
              $15.sleep = true;
              $15.handle = $1;
              $3 = 3;
              return;
            }
            if (state.pos < $15.end) {
              final ok = $15.data.codeUnitAt(state.pos - $15.start) == 48;
              if (ok) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $47 = !state.ok && state.isRecoverable;
            if (!$47) {
              $3 = 4;
              break;
            }
            $17 = state.pos;
            $3 = 5;
            break;
          case 4:
            final $50 = state.ok;
            if (!$50) {
              $3 = 9;
              break;
            }
            $25 = state.pos;
            $24 = true;
            $3 = 10;
            break;
          case 5:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 5;
              return;
            }
            if (state.pos < $18.end) {
              final c = $18.data.codeUnitAt(state.pos - $18.start);
              final $19 = c >= 49 && c <= 57;
              if ($19) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $48 = state.ok;
            if (!$48) {
              $3 = 6;
              break;
            }
            $3 = 8;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($17);
            }
            $3 = 4;
            break;
          case 7:
            state.setOk(true);
            $3 = 6;
            break;
          case 8:
            final $21 = state.input;
            if (state.pos >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $21.end) {
              final c = $21.data.codeUnitAt(state.pos - $21.start);
              final $22 = c >= 48 && c <= 57;
              if ($22) {
                state.advance(1);
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
            final $26 = state.input;
            if (state.pos >= $26.end && !$26.isClosed) {
              $26.sleep = true;
              $26.handle = $1;
              $3 = 10;
              return;
            }
            if (state.pos < $26.end) {
              final ok = $26.data.codeUnitAt(state.pos - $26.start) == 46;
              if (ok) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $51 = state.ok;
            if (!$51) {
              $3 = 11;
              break;
            }
            $24 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $52 = state.ok;
            if (!$52) {
              $3 = 12;
              break;
            }
            $28 = false;
            $3 = 14;
            break;
          case 11:
            if (!state.ok) {
              if (!$24) {
                state.isRecoverable = false;
              }
              state.backtrack($25);
            }
            if (!state.ok) {
              state.setOk(true);
            }
            final $54 = state.ok;
            if (!$54) {
              $3 = 15;
              break;
            }
            $33 = state.pos;
            $32 = true;
            $3 = 16;
            break;
          case 12:
            $3 = 11;
            break;
          case 13:
            state.setOk($28);
            $3 = 12;
            break;
          case 14:
            final $29 = state.input;
            if (state.pos >= $29.end && !$29.isClosed) {
              $29.sleep = true;
              $29.handle = $1;
              $3 = 14;
              return;
            }
            if (state.pos < $29.end) {
              final c = $29.data.codeUnitAt(state.pos - $29.start);
              final $30 = c >= 48 && c <= 57;
              if ($30) {
                state.advance(1);
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
            $28 = true;
            $3 = 14;
            break;
          case 15:
            $3 = 9;
            break;
          case 16:
            final $34 = state.input;
            if (state.pos >= $34.end && !$34.isClosed) {
              $34.sleep = true;
              $34.handle = $1;
              $3 = 16;
              return;
            }
            if (state.pos < $34.end) {
              final c = $34.data.codeUnitAt(state.pos - $34.start);
              final $35 = c == 69 || c == 101;
              if ($35) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            final $55 = state.ok;
            if (!$55) {
              $3 = 17;
              break;
            }
            $32 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $56 = state.ok;
            if (!$56) {
              $3 = 18;
              break;
            }
            $3 = 19;
            break;
          case 17:
            if (!state.ok) {
              if (!$32) {
                state.isRecoverable = false;
              }
              state.backtrack($33);
            }
            if (!state.ok) {
              state.setOk(true);
            }
            $3 = 15;
            break;
          case 18:
            $3 = 17;
            break;
          case 19:
            final $37 = state.input;
            if (state.pos >= $37.end && !$37.isClosed) {
              $37.sleep = true;
              $37.handle = $1;
              $3 = 19;
              return;
            }
            if (state.pos < $37.end) {
              final c = $37.data.codeUnitAt(state.pos - $37.start);
              final $38 = c == 43 || c == 45;
              if ($38) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              state.setOk(true);
            }
            final $57 = state.ok;
            if (!$57) {
              $3 = 20;
              break;
            }
            $40 = false;
            $3 = 22;
            break;
          case 20:
            $3 = 18;
            break;
          case 21:
            state.setOk($40);
            $3 = 20;
            break;
          case 22:
            final $41 = state.input;
            if (state.pos >= $41.end && !$41.isClosed) {
              $41.sleep = true;
              $41.handle = $1;
              $3 = 22;
              return;
            }
            if (state.pos < $41.end) {
              final c = $41.data.codeUnitAt(state.pos - $41.start);
              final $42 = c >= 48 && c <= 57;
              if ($42) {
                state.advance(1);
                state.setOk(true);
              } else {
                state.fail(const ErrorUnexpectedCharacter());
              }
            } else {
              state.fail(const ErrorUnexpectedEndOfInput());
            }
            if (!state.ok) {
              $3 = 21;
              break;
            }
            $40 = true;
            $3 = 22;
            break;
          case 23:
            if (!state.ok) {
              state.backtrack($5);
            }
            $0.value = $2;
            $0.isComplete = true;
            state.input.handle = $0.onComplete;
            $3 = -1;
            return;
          case 24:
            if (state.ok) {
              $2 = $4;
            }
            $3 = 23;
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
    final $3 = state.pos;
    var $2 = true;
    // @inline OpenBrace = v:'{' Spaces ;
    // v:'{' Spaces
    final $4 = state.pos;
    const $5 = '{';
    final $6 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 123;
    if ($6) {
      state.advance(1);
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (state.ok) {
      $2 = false;
      state.setOk(true);
      if (state.ok) {
        List<MapEntry<String, Object?>>? $1;
        // KeyValues
        $1 = parseKeyValues(state);
        if (state.ok) {
          // @inline CloseBrace = v:'}' Spaces ;
          // v:'}' Spaces
          final $7 = state.pos;
          const $8 = '}';
          final $9 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 125;
          if ($9) {
            state.advance(1);
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
    var $3 = 0;
    late bool $5;
    late int $6;
    late int $7;
    late AsyncResult<Object?> $12;
    List<MapEntry<String, Object?>>? $4;
    late AsyncResult<List<MapEntry<String, Object?>>> $14;
    late int $16;
    late AsyncResult<Object?> $21;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $5 = true;
            $7 = state.pos;
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
            const $9 = '{';
            final $10 = state.pos < $8.end &&
                $8.data.codeUnitAt(state.pos - $8.start) == 123;
            if ($10) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$9]));
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 2;
              break;
            }
            $12 = fastParseSpaces$Async(state);
            if (!$12.isComplete) {
              $12.onComplete = $1;
              $3 = 3;
              return;
            }
            $3 = 3;
            break;
          case 2:
            if (!state.ok) {
              state.backtrack($7);
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 4;
              break;
            }
            $5 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $25 = state.ok;
            if (!$25) {
              $3 = 5;
              break;
            }
            $14 = parseKeyValues$Async(state);
            if (!$14.isComplete) {
              $14.onComplete = $1;
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
              if (!$5) {
                state.isRecoverable = false;
              }
              state.backtrack($6);
            }
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
            $4 = $14.value;
            final $26 = state.ok;
            if (!$26) {
              $3 = 7;
              break;
            }
            $16 = state.pos;
            $3 = 8;
            break;
          case 7:
            $3 = 5;
            break;
          case 8:
            final $17 = state.input;
            if (state.pos >= $17.end && !$17.isClosed) {
              $17.sleep = true;
              $17.handle = $1;
              $3 = 8;
              return;
            }
            const $18 = '}';
            final $19 = state.pos < $17.end &&
                $17.data.codeUnitAt(state.pos - $17.start) == 125;
            if ($19) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$18]));
            }
            final $27 = state.ok;
            if (!$27) {
              $3 = 9;
              break;
            }
            $21 = fastParseSpaces$Async(state);
            if (!$21.isComplete) {
              $21.onComplete = $1;
              $3 = 10;
              return;
            }
            $3 = 10;
            break;
          case 9:
            if (!state.ok) {
              state.backtrack($16);
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
    final $3 = state.pos;
    var $2 = true;
    const $4 = '"';
    final $5 = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 34;
    if ($5) {
      state.advance(1);
      state.setOk(true);
    } else {
      state.fail(const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      $2 = false;
      state.setOk(true);
      if (state.ok) {
        String? $1;
        // @inline StringChars = @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex)) ;
        // @stringChars($[ -!#-[\]-\u{10ffff}]+, [\\], (EscapeChar / EscapeHex))
        List<String>? $16;
        String? $18;
        while (true) {
          String? $7;
          // $[ -!#-[\]-\u{10ffff}]+
          final $10 = state.pos;
          var $11 = false;
          for (var c = 0;
              state.pos < state.input.length &&
                  (c = state.input.runeAt(state.pos)) == c &&
                  (c < 35
                      ? c >= 32 && c <= 33
                      : c <= 91 || c >= 93 && c <= 1114111);
              state.advance(c > 0xffff ? 2 : 1),
              // ignore: curly_braces_in_flow_control_structures, empty_statements
              $11 = true);
          if ($11) {
            state.setOk($11);
          } else {
            state.pos < state.input.length
                ? state.fail(const ErrorUnexpectedCharacter())
                : state.fail(const ErrorUnexpectedEndOfInput());
          }
          if (state.ok) {
            $7 = state.input.substring($10, state.pos);
          }
          if (state.ok) {
            final v = $7!;
            if ($18 == null) {
              $18 = v;
            } else if ($16 == null) {
              $16 = [$18, v];
            } else {
              $16.add(v);
            }
          }
          final $17 = state.pos;
          // [\\]
          if (state.pos < state.input.length) {
            final ok = state.input.codeUnitAt(state.pos) == 92;
            if (ok) {
              state.advance(1);
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
          String? $8;
          // (EscapeChar / EscapeHex)
          // EscapeChar
          // EscapeChar
          $8 = parseEscapeChar(state);
          if (!state.ok && state.isRecoverable) {
            // EscapeHex
            // EscapeHex
            $8 = parseEscapeHex(state);
          }
          if (!state.ok) {
            state.backtrack($17);
            break;
          }
          if ($18 == null) {
            $18 = $8!;
          } else {
            if ($16 == null) {
              $16 = [$18, $8!];
            } else {
              $16.add($8!);
            }
          }
        }
        state.setOk(true);
        if ($18 == null) {
          $1 = '';
        } else if ($16 == null) {
          $1 = $18;
        } else {
          $1 = $16.join();
        }
        if (state.ok) {
          // @inline Quote = v:'"' Spaces ;
          // v:'"' Spaces
          final $19 = state.pos;
          const $20 = '"';
          final $21 = state.pos < state.input.length &&
              state.input.codeUnitAt(state.pos) == 34;
          if ($21) {
            state.advance(1);
            state.setOk(true);
          } else {
            state.fail(const ErrorExpectedTags([$20]));
          }
          if (state.ok) {
            // Spaces
            fastParseSpaces(state);
          }
          if (!state.ok) {
            state.backtrack($19);
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
    var $3 = 0;
    late bool $5;
    late int $6;
    String? $4;
    List<String>? $13;
    late int $14;
    String? $15;
    String? $11;
    late int $16;
    late bool $17;
    String? $12;
    late AsyncResult<String> $23;
    late AsyncResult<String> $25;
    late int $27;
    late AsyncResult<Object?> $32;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = state.pos;
            $5 = true;
            $3 = 1;
            break;
          case 1:
            final $7 = state.input;
            if (state.pos >= $7.end && !$7.isClosed) {
              $7.sleep = true;
              $7.handle = $1;
              $3 = 1;
              return;
            }
            const $8 = '"';
            final $9 = state.pos < $7.end &&
                $7.data.codeUnitAt(state.pos - $7.start) == 34;
            if ($9) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$8]));
            }
            final $34 = state.ok;
            if (!$34) {
              $3 = 2;
              break;
            }
            $5 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $35 = state.ok;
            if (!$35) {
              $3 = 3;
              break;
            }
            $13 = null;
            $15 = null;
            $3 = 5;
            break;
          case 2:
            if (!state.ok) {
              if (!$5) {
                state.isRecoverable = false;
              }
              state.backtrack($6);
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
            state.setOk(true);
            if ($15 == null) {
              $4 = '';
            } else if ($13 == null) {
              $4 = $15;
            } else {
              $4 = $13!.join();
            }
            final $39 = state.ok;
            if (!$39) {
              $3 = 12;
              break;
            }
            $27 = state.pos;
            $3 = 13;
            break;
          case 5:
            $16 = state.pos;
            state.input.beginBuffering();
            $17 = false;
            $3 = 7;
            break;
          case 6:
            state.setOk($17);
            state.input.endBuffering();
            if (state.ok) {
              final input = state.input;
              final start = input.start;
              $11 = input.data.substring($16 - start, state.pos - start);
            }
            if (state.ok) {
              final v = $11!;
              if ($15 == null) {
                $15 = v;
              } else if ($13 == null) {
                $13 = [$15!, v];
              } else {
                $13!.add(v);
              }
            }
            $14 = state.pos;
            $3 = 8;
            break;
          case 7:
            final $18 = state.input;
            if (state.pos >= $18.end && !$18.isClosed) {
              $18.sleep = true;
              $18.handle = $1;
              $3 = 7;
              return;
            }
            if (state.pos < $18.end) {
              final c = $18.data.runeAt(state.pos - $18.start);
              final $19 = c < 35
                  ? c >= 32 && c <= 33
                  : c <= 91 || c >= 93 && c <= 1114111;
              if ($19) {
                state.advance(c > 0xffff ? 2 : 1);
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
            $17 = true;
            $3 = 7;
            break;
          case 8:
            final $21 = state.input;
            if (state.pos >= $21.end && !$21.isClosed) {
              $21.sleep = true;
              $21.handle = $1;
              $3 = 8;
              return;
            }
            if (state.pos < $21.end) {
              final ok = $21.data.codeUnitAt(state.pos - $21.start) == 92;
              if (ok) {
                state.advance(1);
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
            $23 = parseEscapeChar$Async(state);
            if (!$23.isComplete) {
              $23.onComplete = $1;
              $3 = 9;
              return;
            }
            $3 = 9;
            break;
          case 9:
            $12 = $23.value;
            final $38 = !state.ok && state.isRecoverable;
            if (!$38) {
              $3 = 10;
              break;
            }
            $25 = parseEscapeHex$Async(state);
            if (!$25.isComplete) {
              $25.onComplete = $1;
              $3 = 11;
              return;
            }
            $3 = 11;
            break;
          case 10:
            if (!state.ok) {
              state.backtrack($14);
              $3 = 4;
              break;
            }
            if ($15 == null) {
              $15 = $12!;
            } else if ($13 == null) {
              $13 = [$15!, $12!];
            } else {
              $13!.add($12!);
            }
            $3 = 5;
            break;
          case 11:
            $12 = $25.value;
            $3 = 10;
            break;
          case 12:
            $3 = 3;
            break;
          case 13:
            final $28 = state.input;
            if (state.pos >= $28.end && !$28.isClosed) {
              $28.sleep = true;
              $28.handle = $1;
              $3 = 13;
              return;
            }
            const $29 = '"';
            final $30 = state.pos < $28.end &&
                $28.data.codeUnitAt(state.pos - $28.start) == 34;
            if ($30) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$29]));
            }
            final $40 = state.ok;
            if (!$40) {
              $3 = 14;
              break;
            }
            $32 = fastParseSpaces$Async(state);
            if (!$32.isComplete) {
              $32.onComplete = $1;
              $3 = 15;
              return;
            }
            $3 = 15;
            break;
          case 14:
            if (!state.ok) {
              state.backtrack($27);
            }
            if (state.ok) {
              $2 = $4;
            }
            $3 = 12;
            break;
          case 15:
            $3 = 14;
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
              state.advance(4);
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
                state.advance(5);
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
                  state.advance(4);
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
              state.advance(4);
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
              state.advance(5);
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
              state.advance(4);
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
        final $12 = state.pos < state.input.length &&
            state.input.codeUnitAt(state.pos) == 44;
        if ($12) {
          state.advance(1);
          state.setOk(true);
        } else {
          state.fail(const ErrorExpectedTags([$11]));
        }
        if (state.ok) {
          // Spaces
          fastParseSpaces(state);
        }
        if (!state.ok) {
          state.backtrack($10);
        }
        if (state.ok) {
          $8 = false;
          state.setOk(true);
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
    var $3 = 0;
    late List<Object?> $6;
    Object? $4;
    late AsyncResult<Object?> $7;
    Object? $5;
    late bool $10;
    late int $11;
    late int $12;
    late AsyncResult<Object?> $17;
    Object? $9;
    late AsyncResult<Object?> $19;
    void $1() {
      while (true) {
        switch ($3) {
          case 0:
            $6 = [];
            $7 = parseValue$Async(state);
            if (!$7.isComplete) {
              $7.onComplete = $1;
              $3 = 1;
              return;
            }
            $3 = 1;
            break;
          case 1:
            $4 = $7.value;
            final $21 = state.ok;
            if (!$21) {
              $3 = 2;
              break;
            }
            $6.add($4);
            $3 = 4;
            break;
          case 2:
            state.setOk(true);
            if (state.ok) {
              $2 = $6;
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
            $11 = state.pos;
            $10 = true;
            $12 = state.pos;
            $3 = 5;
            break;
          case 5:
            final $13 = state.input;
            if (state.pos >= $13.end && !$13.isClosed) {
              $13.sleep = true;
              $13.handle = $1;
              $3 = 5;
              return;
            }
            const $14 = ',';
            final $15 = state.pos < $13.end &&
                $13.data.codeUnitAt(state.pos - $13.start) == 44;
            if ($15) {
              state.advance(1);
              state.setOk(true);
            } else {
              state.fail(const ErrorExpectedTags([$14]));
            }
            final $23 = state.ok;
            if (!$23) {
              $3 = 6;
              break;
            }
            $17 = fastParseSpaces$Async(state);
            if (!$17.isComplete) {
              $17.onComplete = $1;
              $3 = 7;
              return;
            }
            $3 = 7;
            break;
          case 6:
            if (!state.ok) {
              state.backtrack($12);
            }
            final $24 = state.ok;
            if (!$24) {
              $3 = 8;
              break;
            }
            $10 = false;
            state.setOk(true);
            state.input.cut(state.pos);
            final $25 = state.ok;
            if (!$25) {
              $3 = 9;
              break;
            }
            $19 = parseValue$Async(state);
            if (!$19.isComplete) {
              $19.onComplete = $1;
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
              if (!$10) {
                state.isRecoverable = false;
              }
              state.backtrack($11);
            }
            if (!state.ok) {
              $3 = 3;
              break;
            }
            $6.add($5);
            $3 = 4;
            break;
          case 9:
            $3 = 8;
            break;
          case 10:
            $9 = $19.value;
            if (state.ok) {
              $5 = $9;
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

  bool isRecoverable = true;

  int lastFailPos = -1;

  int mute = 0;

  bool ok = false;

  int pos = 0;

  final List<ParseError?> _errors = List.filled(256, null, growable: false);

  State(this.input);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void advance(int offset) {
    if (mute == 0 && isRecoverable) {
      if (failPos <= pos) {
        failPos = 0;
        errorCount = 0;
      }
    }

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
    if (mute == 0 || !isRecoverable) {
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
    if (mute == 0 || !isRecoverable) {
      if (offset >= failPos) {
        if (failPos < offset) {
          failPos = offset;
          errorCount = 0;
        }

        if (errorCount < _errors.length) {
          _errors[errorCount++] = error;
        }
      }

      if (lastFailPos < offset) {
        lastFailPos = offset;
      }
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

void main(List<String> args) {
  const source = '1 + 2 * 3';
  const parser = CalcParser();
  final result = parseString(parser.parseStart, source);
  print(result);
}

class CalcParser {
  const CalcParser();

  num _calcBinary(num? left, ({String op, num expr}) next) {
    final op = next.op;
    final right = next.expr;
    left = left!;
    switch (op) {
      case '+':
        return left += right;
      case '-':
        return left -= right;
      case '/':
        return left /= right;
      case '*':
        return left *= right;
      default:
        throw StateError('Unknown operator: $op');
    }
  }

  num _prefix(String? operator, num operand) {
    if (operator == null) {
      return operand;
    }

    switch (operator) {
      case '+':
        return -operand;
      default:
        throw StateError('Unknown operator: $operator');
    }
  }

  /// CloseParenthesis =
  ///   ')' Spaces
  ///   ;
  void fastParseCloseParenthesis(State<String> state) {
    // ')' Spaces
    final $0 = state.pos;
    const $1 = ')';
    matchLiteral1(state, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
  }

  /// OpenParenthesis =
  ///   '(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<String> state) {
    // '(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    matchLiteral1(state, $1, const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.pos = $0;
    }
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

  /// num
  /// Add =
  ///   h:Mul t:(op:AddOp expr:Mul)* {}
  ///   ;
  num? parseAdd(State<String> state) {
    num? $0;
    // h:Mul t:(op:AddOp expr:Mul)* {}
    final $1 = state.pos;
    num? $2;
    // Mul
    $2 = parseMul(state);
    if (state.ok) {
      List<({String op, num expr})>? $3;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:AddOp expr:Mul
        final $6 = state.pos;
        String? $7;
        // AddOp
        $7 = parseAddOp(state);
        if (state.ok) {
          num? $8;
          // Mul
          $8 = parseMul(state);
          if (state.ok) {
            $5 = (op: $7!, expr: $8!);
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        num? $$;
        final h = $2!;
        final t = $3!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// AddOp =
  ///   v:('-' / '+') Spaces
  ///   ;
  String? parseAddOp(State<String> state) {
    String? $0;
    // v:('-' / '+') Spaces
    final $1 = state.pos;
    String? $2;
    final $7 = state.pos;
    state.ok = false;
    final $4 = state.input;
    if (state.pos < $4.length) {
      final $3 = $4.runeAt(state.pos);
      state.pos += $3 > 0xffff ? 2 : 1;
      switch ($3) {
        case 45:
          state.ok = true;
          $2 = '-';
          break;
        case 43:
          state.ok = true;
          $2 = '+';
          break;
      }
    }
    if (!state.ok) {
      state.pos = $7;
      state.fail(const ErrorExpectedTags(['-', '+']));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Expression =
  ///   Add
  ///   ;
  num? parseExpression(State<String> state) {
    num? $0;
    // Add
    // Add
    $0 = parseAdd(state);
    return $0;
  }

  /// num
  /// Mul =
  ///   h:Prefix t:(op:MulOp expr:Prefix)* {}
  ///   ;
  num? parseMul(State<String> state) {
    num? $0;
    // h:Prefix t:(op:MulOp expr:Prefix)* {}
    final $1 = state.pos;
    num? $2;
    // Prefix
    $2 = parsePrefix(state);
    if (state.ok) {
      List<({String op, num expr})>? $3;
      final $4 = <({String op, num expr})>[];
      while (true) {
        ({String op, num expr})? $5;
        // op:MulOp expr:Prefix
        final $6 = state.pos;
        String? $7;
        // MulOp
        $7 = parseMulOp(state);
        if (state.ok) {
          num? $8;
          // Prefix
          $8 = parsePrefix(state);
          if (state.ok) {
            $5 = (op: $7!, expr: $8!);
          }
        }
        if (!state.ok) {
          state.pos = $6;
        }
        if (!state.ok) {
          state.ok = true;
          break;
        }
        $4.add($5!);
      }
      if (state.ok) {
        $3 = $4;
      }
      if (state.ok) {
        num? $$;
        final h = $2!;
        final t = $3!;
        $$ = t.isEmpty ? h : t.fold(h, _calcBinary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// MulOp =
  ///   v:('/' / '*') Spaces
  ///   ;
  String? parseMulOp(State<String> state) {
    String? $0;
    // v:('/' / '*') Spaces
    final $1 = state.pos;
    String? $2;
    final $7 = state.pos;
    state.ok = false;
    final $4 = state.input;
    if (state.pos < $4.length) {
      final $3 = $4.runeAt(state.pos);
      state.pos += $3 > 0xffff ? 2 : 1;
      switch ($3) {
        case 47:
          state.ok = true;
          $2 = '/';
          break;
        case 42:
          state.ok = true;
          $2 = '*';
          break;
      }
    }
    if (!state.ok) {
      state.pos = $7;
      state.fail(const ErrorExpectedTags(['/', '*']));
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Number =
  ///   @errorHandler(NumberRaw)
  ///   ;
  num? parseNumber(State<String> state) {
    num? $0;
    // @errorHandler(NumberRaw)
    final $2 = state.failPos;
    final $3 = state.errorCount;
    // NumberRaw
    // NumberRaw
    $0 = parseNumberRaw(state);
    if (!state.ok && state._canHandleError($2, $3)) {
      ParseError? error;
      // ignore: prefer_final_locals
      var rollbackErrors = false;
      if (state.failPos != state.pos) {
        error = ErrorMessage(state.pos - state.failPos, 'Malformed number');
      } else {
        rollbackErrors = true;
        error = ErrorExpectedTags(['number']);
      }
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

  /// num
  /// NumberRaw =
  ///   v:$([-]? ([0] / [1-9] [0-9]*) ([.] [0-9]+)? ([eE] [-+]? [0-9]+)?) Spaces {}
  ///   ;
  num? parseNumberRaw(State<String> state) {
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
  /// Prefix =
  ///   o:'-'? e:Primary {}
  ///   ;
  num? parsePrefix(State<String> state) {
    num? $0;
    // o:'-'? e:Primary {}
    final $1 = state.pos;
    String? $2;
    const $4 = '-';
    $2 = matchLiteral1(state, $4, const ErrorExpectedTags([$4]));
    state.ok = true;
    if (state.ok) {
      num? $3;
      // Primary
      $3 = parsePrimary(state);
      if (state.ok) {
        num? $$;
        final o = $2;
        final e = $3!;
        $$ = _prefix(o, e);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.pos = $1;
    }
    return $0;
  }

  /// Primary =
  ///     Number
  ///   / OpenParenthesis v:Number CloseParenthesis
  ///   ;
  num? parsePrimary(State<String> state) {
    num? $0;
    // Number
    // Number
    $0 = parseNumber(state);
    if (!state.ok) {
      // OpenParenthesis v:Number CloseParenthesis
      final $2 = state.pos;
      // OpenParenthesis
      fastParseOpenParenthesis(state);
      if (state.ok) {
        num? $3;
        // Number
        $3 = parseNumber(state);
        if (state.ok) {
          // CloseParenthesis
          fastParseCloseParenthesis(state);
          if (state.ok) {
            $0 = $3;
          }
        }
      }
      if (!state.ok) {
        state.pos = $2;
      }
    }
    return $0;
  }

  /// Start =
  ///   Spaces v:Expression Eof
  ///   ;
  num? parseStart(State<String> state) {
    num? $0;
    // Spaces v:Expression Eof
    final $1 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      num? $2;
      // Expression
      $2 = parseExpression(state);
      if (state.ok) {
        // @inline Eof = !. ;
        // !.
        final $4 = state.pos;
        final $7 = state.input;
        if (state.pos < $7.length) {
          final $6 = $7.runeAt(state.pos);
          state.pos += $6 > 0xffff ? 2 : 1;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        state.ok = !state.ok;
        if (!state.ok) {
          final length = $4 - state.pos;
          state.fail(switch (length) {
            0 => const ErrorUnexpectedInput(0),
            1 => const ErrorUnexpectedInput(1),
            2 => const ErrorUnexpectedInput(2),
            _ => ErrorUnexpectedInput(length)
          });
        }
        state.pos = $4;
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

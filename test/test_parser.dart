class TestParser {
  bool flag = false;

  String text = '';

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  void fastParseOrderedChoiceWithLiterals(State<String> state) {
    final $1 = state.pos;
    var $0 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 97:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 98 &&
              input.codeUnitAt(pos2 + 1) == 99;
          if (ok) {
            $0 = 3;
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
            if (ok) {
              $0 = 2;
            } else {
              $0 = 1;
            }
          }
          break;
        case 100:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 101 &&
              input.codeUnitAt(pos2 + 1) == 102;
          if (ok) {
            $0 = 3;
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 101;
            if (ok) {
              $0 = 2;
            } else {
              $0 = 1;
            }
          }
          break;
        case 103:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 104;
          if (ok) {
            $0 = 2;
          }
          break;
      }
    }
    if ($0 > 0) {
      state.advance($0);
      state.setOk(true);
    } else {
      state.pos = $1;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  void fastParseSkipTil(State<String> state) {
    // (![E] v:.)*
    const $3 = 'E';
    final $1 = state.input.indexOf($3, state.pos);
    final $2 = $1 != -1;
    if ($2) {
      state.pos = $1;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
  }

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  void fastParseSkipUntil(State<String> state) {
    // (!'END' v:.)*
    const $3 = 'END';
    final $1 = state.input.indexOf($3, state.pos);
    final $2 = $1 != -1;
    if ($2) {
      state.pos = $1;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$3]));
    }
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  void fastParseTakeTil(State<String> state) {
    // $(![E] v:.)*
    const $4 = 'E';
    final $2 = state.input.indexOf($4, state.pos);
    final $3 = $2 != -1;
    if ($3) {
      state.pos = $2;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  void fastParseTakeUntil(State<String> state) {
    // $(!'END' v:.)*
    const $4 = 'END';
    final $2 = state.input.indexOf($4, state.pos);
    final $3 = $2 != -1;
    if ($3) {
      state.pos = $2;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$4]));
    }
  }

  /// OrderedChoiceWithLiterals =
  ///     'abc'
  ///   / 'ab'
  ///   / 'a'
  ///   / 'def'
  ///   / 'de'
  ///   / 'd'
  ///   / 'gh'
  ///   ;
  String? parseOrderedChoiceWithLiterals(State<String> state) {
    String? $0;
    final $2 = state.pos;
    var $1 = 0;
    if (state.pos < state.input.length) {
      final input = state.input;
      final c = input.codeUnitAt(state.pos);
      // ignore: unused_local_variable
      final pos2 = state.pos + 1;
      switch (c) {
        case 97:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 98 &&
              input.codeUnitAt(pos2 + 1) == 99;
          if (ok) {
            $1 = 3;
            $0 = 'abc';
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 98;
            if (ok) {
              $1 = 2;
              $0 = 'ab';
            } else {
              $1 = 1;
              $0 = 'a';
            }
          }
          break;
        case 100:
          final ok = pos2 + 1 < input.length &&
              input.codeUnitAt(pos2) == 101 &&
              input.codeUnitAt(pos2 + 1) == 102;
          if (ok) {
            $1 = 3;
            $0 = 'def';
          } else {
            final ok = pos2 < input.length && input.codeUnitAt(pos2) == 101;
            if (ok) {
              $1 = 2;
              $0 = 'de';
            } else {
              $1 = 1;
              $0 = 'd';
            }
          }
          break;
        case 103:
          final ok = pos2 < input.length && input.codeUnitAt(pos2) == 104;
          if (ok) {
            $1 = 2;
            $0 = 'gh';
          }
          break;
      }
    }
    if ($1 > 0) {
      state.advance($1);
      state.setOk(true);
    } else {
      state.pos = $2;
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
    return $0;
  }

  /// SkipTil =
  ///   (![E] v:.)*
  ///   ;
  List<int>? parseSkipTil(State<String> state) {
    List<int>? $0;
    // (![E] v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // ![E] v:.
      final $5 = state.pos;
      final $6 = state.pos;
      state.mute++;
      if (state.pos < state.input.length) {
        final ok = state.input.codeUnitAt(state.pos) == 69;
        if (ok) {
          state.advance(1);
          state.setOk(true);
        } else {
          state.fail(const ErrorUnexpectedCharacter());
        }
      } else {
        state.fail(const ErrorUnexpectedEndOfInput());
      }
      state.mute--;
      if (state.ok) {
        final length = state.pos - $6;
        state.failAt(
            $6,
            switch (length) {
              0 => const ErrorUnexpectedInput(0),
              1 => const ErrorUnexpectedInput(1),
              2 => const ErrorUnexpectedInput(2),
              _ => ErrorUnexpectedInput(length)
            });
        state.backtrack($6);
      } else {
        state.advance(0);
        state.setOk(true);
      }
      if (state.ok) {
        int? $4;
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.advance(c > 0xffff ? 2 : 1);
          state.setOk(true);
          $4 = c;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $4;
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// SkipUntil =
  ///   (!'END' v:.)*
  ///   ;
  List<int>? parseSkipUntil(State<String> state) {
    List<int>? $0;
    // (!'END' v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // !'END' v:.
      final $5 = state.pos;
      final $6 = state.pos;
      state.mute++;
      const $7 = 'END';
      final $8 = state.pos + 2 < state.input.length &&
          state.input.codeUnitAt(state.pos) == 69 &&
          state.input.codeUnitAt(state.pos + 1) == 78 &&
          state.input.codeUnitAt(state.pos + 2) == 68;
      if ($8) {
        state.advance(3);
        state.setOk(true);
      } else {
        state.fail(const ErrorExpectedTags([$7]));
      }
      state.mute--;
      if (state.ok) {
        final length = state.pos - $6;
        state.failAt(
            $6,
            switch (length) {
              0 => const ErrorUnexpectedInput(0),
              1 => const ErrorUnexpectedInput(1),
              2 => const ErrorUnexpectedInput(2),
              _ => ErrorUnexpectedInput(length)
            });
        state.backtrack($6);
      } else {
        state.advance(0);
        state.setOk(true);
      }
      if (state.ok) {
        int? $4;
        if (state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.advance(c > 0xffff ? 2 : 1);
          state.setOk(true);
          $4 = c;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $4;
        }
      }
      if (!state.ok) {
        state.backtrack($5);
      }
      if (!state.ok) {
        break;
      }
      $2.add($3!);
    }
    state.setOk(true);
    if (state.ok) {
      $0 = $2;
    }
    return $0;
  }

  /// Start =
  ///     (v:SkipUntil SkipUntil)
  ///   / (v:SkipTil SkipTil)
  ///   / (v:TakeUntil TakeUntil)
  ///   / (v:TakeTil TakeTil)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   / (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
  ///   ;
  Object? parseStart(State<String> state) {
    Object? $0;
    // (v:SkipUntil SkipUntil)
    // v:SkipUntil SkipUntil
    final $3 = state.pos;
    List<int>? $2;
    // SkipUntil
    $2 = parseSkipUntil(state);
    if (state.ok) {
      // SkipUntil
      fastParseSkipUntil(state);
      if (state.ok) {
        $0 = $2;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (!state.ok && state.isRecoverable) {
      // (v:SkipTil SkipTil)
      // v:SkipTil SkipTil
      final $6 = state.pos;
      List<int>? $5;
      // SkipTil
      $5 = parseSkipTil(state);
      if (state.ok) {
        // SkipTil
        fastParseSkipTil(state);
        if (state.ok) {
          $0 = $5;
        }
      }
      if (!state.ok) {
        state.backtrack($6);
      }
      if (!state.ok && state.isRecoverable) {
        // (v:TakeUntil TakeUntil)
        // v:TakeUntil TakeUntil
        final $9 = state.pos;
        String? $8;
        // TakeUntil
        $8 = parseTakeUntil(state);
        if (state.ok) {
          // TakeUntil
          fastParseTakeUntil(state);
          if (state.ok) {
            $0 = $8;
          }
        }
        if (!state.ok) {
          state.backtrack($9);
        }
        if (!state.ok && state.isRecoverable) {
          // (v:TakeTil TakeTil)
          // v:TakeTil TakeTil
          final $12 = state.pos;
          String? $11;
          // TakeTil
          $11 = parseTakeTil(state);
          if (state.ok) {
            // TakeTil
            fastParseTakeTil(state);
            if (state.ok) {
              $0 = $11;
            }
          }
          if (!state.ok) {
            state.backtrack($12);
          }
          if (!state.ok && state.isRecoverable) {
            // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
            // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
            final $15 = state.pos;
            String? $14;
            // OrderedChoiceWithLiterals
            $14 = parseOrderedChoiceWithLiterals(state);
            if (state.ok) {
              // OrderedChoiceWithLiterals
              fastParseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                $0 = $14;
              }
            }
            if (!state.ok) {
              state.backtrack($15);
            }
            if (!state.ok && state.isRecoverable) {
              // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
              // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
              final $18 = state.pos;
              String? $17;
              // OrderedChoiceWithLiterals
              $17 = parseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                // OrderedChoiceWithLiterals
                fastParseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  $0 = $17;
                }
              }
              if (!state.ok) {
                state.backtrack($18);
              }
            }
          }
        }
      }
    }
    return $0;
  }

  /// TakeTil =
  ///   $(![E] v:.)*
  ///   ;
  String? parseTakeTil(State<String> state) {
    String? $0;
    // $(![E] v:.)*
    final $2 = state.pos;
    const $5 = 'E';
    final $3 = state.input.indexOf($5, state.pos);
    final $4 = $3 != -1;
    if ($4) {
      state.pos = $3;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorUnexpectedCharacter());
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// TakeUntil =
  ///   $(!'END' v:.)*
  ///   ;
  String? parseTakeUntil(State<String> state) {
    String? $0;
    // $(!'END' v:.)*
    final $2 = state.pos;
    const $5 = 'END';
    final $3 = state.input.indexOf($5, state.pos);
    final $4 = $3 != -1;
    if ($4) {
      state.pos = $3;
      state.setOk(true);
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$5]));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }
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

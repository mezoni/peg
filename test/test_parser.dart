class TestParser {
  bool flag = false;

  String text = '';

  Object? parseStart(State<StringReader> state) {
    Object? $0;
    // (v:MatchString MatchString)
    // v:MatchString MatchString
    final $26 = state.pos;
    String? $27;
    $27 = parseMatchString(state);
    if (state.ok) {
      fastParseMatchString(state);
      if (state.ok) {
        $0 = $27;
      }
    }
    if (!state.ok) {
      state.pos = $26;
    }
    if (state.ok) {
      $0 = $0;
    }
    if (!state.ok) {
      // (v:SkipUntil SkipUntil)
      // v:SkipUntil SkipUntil
      final $23 = state.pos;
      List<int>? $24;
      $24 = parseSkipUntil(state);
      if (state.ok) {
        fastParseSkipUntil(state);
        if (state.ok) {
          $0 = $24;
        }
      }
      if (!state.ok) {
        state.pos = $23;
      }
      if (state.ok) {
        $0 = $0;
      }
      if (!state.ok) {
        // (v:SkipTil SkipTil)
        // v:SkipTil SkipTil
        final $20 = state.pos;
        List<int>? $21;
        $21 = parseSkipTil(state);
        if (state.ok) {
          fastParseSkipTil(state);
          if (state.ok) {
            $0 = $21;
          }
        }
        if (!state.ok) {
          state.pos = $20;
        }
        if (state.ok) {
          $0 = $0;
        }
        if (!state.ok) {
          // (v:TakeUntil TakeUntil)
          // v:TakeUntil TakeUntil
          final $17 = state.pos;
          String? $18;
          $18 = parseTakeUntil(state);
          if (state.ok) {
            fastParseTakeUntil(state);
            if (state.ok) {
              $0 = $18;
            }
          }
          if (!state.ok) {
            state.pos = $17;
          }
          if (state.ok) {
            $0 = $0;
          }
          if (!state.ok) {
            // (v:TakeTil TakeTil)
            // v:TakeTil TakeTil
            final $14 = state.pos;
            String? $15;
            $15 = parseTakeTil(state);
            if (state.ok) {
              fastParseTakeTil(state);
              if (state.ok) {
                $0 = $15;
              }
            }
            if (!state.ok) {
              state.pos = $14;
            }
            if (state.ok) {
              $0 = $0;
            }
            if (!state.ok) {
              // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
              // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
              final $11 = state.pos;
              String? $12;
              $12 = parseOrderedChoiceWithLiterals(state);
              if (state.ok) {
                fastParseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  $0 = $12;
                }
              }
              if (!state.ok) {
                state.pos = $11;
              }
              if (state.ok) {
                $0 = $0;
              }
              if (!state.ok) {
                // (v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals)
                // v:OrderedChoiceWithLiterals OrderedChoiceWithLiterals
                final $8 = state.pos;
                String? $9;
                $9 = parseOrderedChoiceWithLiterals(state);
                if (state.ok) {
                  fastParseOrderedChoiceWithLiterals(state);
                  if (state.ok) {
                    $0 = $9;
                  }
                }
                if (!state.ok) {
                  state.pos = $8;
                }
                if (state.ok) {
                  $0 = $0;
                }
                if (!state.ok) {
                  // (v:Verify41 Verify41)
                  // v:Verify41 Verify41
                  final $5 = state.pos;
                  int? $6;
                  $6 = parseVerify41(state);
                  if (state.ok) {
                    fastParseVerify41(state);
                    if (state.ok) {
                      $0 = $6;
                    }
                  }
                  if (!state.ok) {
                    state.pos = $5;
                  }
                  if (state.ok) {
                    $0 = $0;
                  }
                  if (!state.ok) {
                    // (v:VerifyFlag VerifyFlag)
                    // v:VerifyFlag VerifyFlag
                    final $2 = state.pos;
                    String? $3;
                    $3 = parseVerifyFlag(state);
                    if (state.ok) {
                      fastParseVerifyFlag(state);
                      if (state.ok) {
                        $0 = $3;
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
    }
    return $0;
  }

  String? parseVerifyFlag(State<StringReader> state) {
    String? $0;
    // @verify'')
    final $2 = state.pos;
    // ''
    state.ok = true;
    if (state.ok) {
      $0 = '';
    }
    if (state.ok) {
      $0 = $0;
    }
    if (state.ok) {
      // ignore: unused_local_variable
      final pos = $2;
      // ignore: unused_local_variable
      final $$ = $0;
      if (!flag) {
        state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'error'));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseVerifyFlag(State<StringReader> state) {
    // @verify'')
    final $2 = state.pos;
    String? $1;
    // ''
    state.ok = true;
    if (state.ok) {
      $1 = '';
    }
    if (state.ok) {
      $1 = $1;
    }
    if (state.ok) {
      // ignore: unused_local_variable
      final pos = $2;
      // ignore: unused_local_variable
      final $$ = $1;
      if (!flag) {
        state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'error'));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
  }

  int? parseVerify41(State<StringReader> state) {
    int? $0;
    // @verifyInteger)
    final $2 = state.pos;
    // Integer
    $0 = parseInteger(state);
    if (state.ok) {
      $0 = $0;
    }
    if (state.ok) {
      // ignore: unused_local_variable
      final pos = $2;
      // ignore: unused_local_variable
      final $$ = $0;
      if ($$ != 41) {
        state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'error'));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  int? parseInteger(State<StringReader> state) {
    int? $0;
    // v:$[0-9]+
    String? $2;
    final $3 = state.pos;
    var $4 = false;
    while (true) {
      state.ok = state.pos < state.input.length;
      if (state.ok) {
        final $5 = state.input.readChar(state.pos);
        state.ok = $5 >= 48 && $5 <= 57;
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
      $4 = true;
    }
    state.ok = $4;
    if (state.ok) {
      $2 = state.input.substring($3, state.pos);
    }
    if (state.ok) {
      int? $$;
      final v = $2!;
      $$ = int.parse(v);
      $0 = $$;
    }
    return $0;
  }

  void fastParseVerify41(State<StringReader> state) {
    // @verifyInteger)
    final $2 = state.pos;
    int? $1;
    // Integer
    $1 = parseInteger(state);
    if (state.ok) {
      $1 = $1;
    }
    if (state.ok) {
      // ignore: unused_local_variable
      final pos = $2;
      // ignore: unused_local_variable
      final $$ = $1;
      if ($$ != 41) {
        state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'error'));
      }
    }
    if (!state.ok) {
      state.pos = $2;
    }
  }

  String? parseOrderedChoiceWithLiterals(State<StringReader> state) {
    String? $0;
    state.ok = false;
    final $3 = state.input;
    if (state.pos < $3.length) {
      final $1 = $3.readChar(state.pos);
      final $2 = $3.count;
      switch ($1) {
        case 97:
          const $4 = 'abc';
          state.ok = $3.startsWith($4, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $4;
          } else {
            const $5 = 'ab';
            state.ok = $3.startsWith($5, state.pos);
            if (state.ok) {
              state.pos += $3.count;
              $0 = $5;
            } else {
              state.ok = true;
              state.pos += $2;
              $0 = 'a';
            }
          }
          break;
        case 100:
          const $7 = 'def';
          state.ok = $3.startsWith($7, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $7;
          } else {
            const $8 = 'de';
            state.ok = $3.startsWith($8, state.pos);
            if (state.ok) {
              state.pos += $3.count;
              $0 = $8;
            } else {
              state.ok = true;
              state.pos += $2;
              $0 = 'd';
            }
          }
          break;
        case 103:
          const $10 = 'gh';
          state.ok = $3.startsWith($10, state.pos);
          if (state.ok) {
            state.pos += $3.count;
            $0 = $10;
          }
          break;
      }
    }
    if (!state.ok) {
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
    return $0;
  }

  void fastParseOrderedChoiceWithLiterals(State<StringReader> state) {
    state.ok = false;
    final $2 = state.input;
    if (state.pos < $2.length) {
      final $0 = $2.readChar(state.pos);
      final $1 = $2.count;
      switch ($0) {
        case 97:
          const $3 = 'abc';
          state.ok = $2.startsWith($3, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          } else {
            const $4 = 'ab';
            state.ok = $2.startsWith($4, state.pos);
            if (state.ok) {
              state.pos += $2.count;
            } else {
              state.ok = true;
              state.pos += $1;
            }
          }
          break;
        case 100:
          const $6 = 'def';
          state.ok = $2.startsWith($6, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          } else {
            const $7 = 'de';
            state.ok = $2.startsWith($7, state.pos);
            if (state.ok) {
              state.pos += $2.count;
            } else {
              state.ok = true;
              state.pos += $1;
            }
          }
          break;
        case 103:
          const $9 = 'gh';
          state.ok = $2.startsWith($9, state.pos);
          if (state.ok) {
            state.pos += $2.count;
          }
          break;
      }
    }
    if (!state.ok) {
      state.fail(
          const ErrorExpectedTags(['abc', 'ab', 'a', 'def', 'de', 'd', 'gh']));
    }
  }

  String? parseTakeTil(State<StringReader> state) {
    String? $0;
    // $(![E] v:.)*
    final $2 = state.pos;
    const $4 = 'E';
    final $3 = state.input.indexOf($4, state.pos);
    state.ok = $3 != -1;
    if (state.ok) {
      state.pos = $3;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseTakeTil(State<StringReader> state) {
    // $(![E] v:.)*
    const $3 = 'E';
    final $2 = state.input.indexOf($3, state.pos);
    state.ok = $2 != -1;
    if (state.ok) {
      state.pos = $2;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
  }

  String? parseTakeUntil(State<StringReader> state) {
    String? $0;
    // $(!'END' v:.)*
    final $2 = state.pos;
    const $4 = 'END';
    final $3 = state.input.indexOf($4, state.pos);
    state.ok = $3 != -1;
    if (state.ok) {
      state.pos = $3;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$4]));
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseTakeUntil(State<StringReader> state) {
    // $(!'END' v:.)*
    const $3 = 'END';
    final $2 = state.input.indexOf($3, state.pos);
    state.ok = $2 != -1;
    if (state.ok) {
      state.pos = $2;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$3]));
    }
  }

  List<int>? parseSkipTil(State<StringReader> state) {
    List<int>? $0;
    // (![E] v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // ![E] v:.
      final $4 = state.pos;
      final $6 = state.pos;
      state.ok = state.input.matchChar(69, state.pos);
      if (state.ok) {
        state.pos += state.input.count;
      } else {
        state.fail(const ErrorExpectedCharacter(69));
      }
      state.ok = !state.ok;
      if (!state.ok) {
        state.pos = $6;
      }
      if (state.ok) {
        int? $5;
        if (state.pos < state.input.length) {
          $5 = state.input.readChar(state.pos);
          state.pos += state.input.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $5;
        }
      }
      if (!state.ok) {
        state.pos = $4;
      }
      if (!state.ok) {
        state.ok = true;
        break;
      }
      $2.add($3!);
    }
    if (state.ok) {
      $0 = $2;
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseSkipTil(State<StringReader> state) {
    // (![E] v:.)*
    const $2 = 'E';
    final $1 = state.input.indexOf($2, state.pos);
    state.ok = $1 != -1;
    if (state.ok) {
      state.pos = $1;
    } else {
      state.failAt(state.input.length, const ErrorExpectedCharacter(69));
    }
  }

  List<int>? parseSkipUntil(State<StringReader> state) {
    List<int>? $0;
    // (!'END' v:.)*
    final $2 = <int>[];
    while (true) {
      int? $3;
      // !'END' v:.
      final $4 = state.pos;
      final $6 = state.pos;
      const $7 = 'END';
      matchLiteral(state, $7, const ErrorExpectedTags([$7]));
      state.ok = !state.ok;
      if (!state.ok) {
        state.pos = $6;
      }
      if (state.ok) {
        int? $5;
        if (state.pos < state.input.length) {
          $5 = state.input.readChar(state.pos);
          state.pos += state.input.count;
          state.ok = true;
        } else {
          state.fail(const ErrorUnexpectedEndOfInput());
        }
        if (state.ok) {
          $3 = $5;
        }
      }
      if (!state.ok) {
        state.pos = $4;
      }
      if (!state.ok) {
        state.ok = true;
        break;
      }
      $2.add($3!);
    }
    if (state.ok) {
      $0 = $2;
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseSkipUntil(State<StringReader> state) {
    // (!'END' v:.)*
    const $2 = 'END';
    final $1 = state.input.indexOf($2, state.pos);
    state.ok = $1 != -1;
    if (state.ok) {
      state.pos = $1;
    } else {
      state.failAt(state.input.length, const ErrorExpectedTags([$2]));
    }
  }

  String? parseMatchString(State<StringReader> state) {
    String? $0;
    // @matchString()
    final $2 = text;
    if ($2.isEmpty) {
      state.ok = true;
      $0 = '';
    } else {
      state.ok = state.input.startsWith($2, state.pos);
      if (state.ok) {
        state.pos += state.input.count;
        $0 = $2;
      } else {
        state.fail(ErrorExpectedTags([$2]));
      }
    }
    if (state.ok) {
      $0 = $0;
    }
    return $0;
  }

  void fastParseMatchString(State<StringReader> state) {
    // @matchString()
    final $1 = text;
    if ($1.isEmpty) {
      state.ok = true;
    } else {
      state.ok = state.input.startsWith($1, state.pos);
      if (state.ok) {
        state.pos += state.input.count;
      } else {
        state.fail(ErrorExpectedTags([$1]));
      }
    }
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

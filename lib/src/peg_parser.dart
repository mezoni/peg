// ignore_for_file: prefer_relative_imports

import 'expressions/expressions.dart';
import 'grammar/grammar.dart';

Grammar parse(String input) {
  final state = State(input);
  final result = parser(state);
  if (!state.ok) {
    final message =
        ParseError.errorMessage(input, state.failPos, state.getErrors());
    throw message;
  }
  return result!;
}

String? _ws(State<String> state) {
  String? $0;
  final input$0 = state.input;
  while (state.pos < input$0.length) {
    final c = input$0.codeUnitAt(state.pos);
    final v = c >= 9 && c <= 10 || c == 13 || c == 32;
    if (!v) {
      break;
    }
    state.pos += 1;
  }
  state.ok = true;
  if (state.ok) {
    $0 = '';
  }
  return $0;
}

String? _globals(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  const tag$0 = '%{';
  if (state.ok = state.pos + 2 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 37 &&
      state.input.codeUnitAt(state.pos + 1) == 123) {
    state.pos += 2;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    String? $1;
    final pos$1 = state.pos;
    while (true) {
      // => _globalsBody
      final pos$2 = state.pos;
      final pos$3 = state.pos;
      const tag$1 = '}%';
      if (state.ok = state.pos + 2 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 125 &&
          state.input.codeUnitAt(state.pos + 1) == 37) {
        state.pos += 2;
      } else {
        state.fail(const ErrorExpectedTags([tag$1]));
      }
      state.ok = !state.ok;
      if (!state.ok) {
        final length = state.pos - pos$3;
        state.pos = pos$3;
        state.fail(ErrorUnexpectedInput(length));
      }
      if (state.ok) {
        if (state.ok = state.pos < state.input.length) {
          final c = state.input.runeAt(state.pos);
          state.pos += c <= 0xffff ? 1 : 2;
        } else {
          state.fail(const ErrorUnexpectedEof());
        }
        if (!state.ok) {
          state.pos = pos$2;
        }
      }
      // <= _globalsBody
      if (!state.ok) {
        break;
      }
    }
    state.ok = true;
    if (state.ok) {
      $1 = state.pos != pos$1 ? state.input.substring(pos$1, state.pos) : '';
    }
    if (state.ok) {
      final pos$4 = state.pos;
      const tag$2 = '}%';
      if (state.ok = state.pos + 2 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 125 &&
          state.input.codeUnitAt(state.pos + 1) == 37) {
        state.pos += 2;
      } else {
        state.fail(const ErrorExpectedTags([tag$2]));
      }
      if (state.ok) {
        _ws(state);
        if (!state.ok) {
          state.pos = pos$4;
        }
      }
      if (state.ok) {
        $0 = $1;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

String? _closeBrace(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '}';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 125) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _block(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  const tag$0 = '{';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 123) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    String? $1;
    final pos$1 = state.pos;
    while (true) {
      _blockBody(state);
      if (!state.ok) {
        break;
      }
    }
    state.ok = true;
    if (state.ok) {
      $1 = state.pos != pos$1 ? state.input.substring(pos$1, state.pos) : '';
    }
    if (state.ok) {
      _closeBrace(state);
      if (state.ok) {
        $0 = $1;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

String? _members(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  $1 = _block(state);
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _metadataIdentifier(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  final pos$1 = state.pos;
  final pos$2 = state.pos;
  const tag$0 = '@';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 64) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    final input$0 = state.input;
    while (state.pos < input$0.length) {
      final c = input$0.codeUnitAt(state.pos);
      final v = c >= 48 && c <= 57 || c >= 65 && c <= 90 || c >= 97 && c <= 122;
      if (!v) {
        break;
      }
      state.pos += 1;
    }
    state.ok = true;
    if (!state.ok) {
      state.pos = pos$2;
    }
  }
  if (state.ok) {
    $1 = state.pos != pos$1 ? state.input.substring(pos$1, state.pos) : '';
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

List<String>? _metadata(State<String> state) {
  List<String>? $0;
  final list$0 = <String>[];
  while (true) {
    String? $1;
    $1 = _metadataIdentifier(state);
    if (!state.ok) {
      break;
    }
    list$0.add($1!);
  }
  if (state.ok = list$0.isNotEmpty) {
    $0 = list$0;
  }
  return $0;
}

String? _identifier(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  final pos$1 = state.pos;
  final pos$2 = state.pos;
  final input$0 = state.input;
  final pos$3 = state.pos;
  while (state.pos < input$0.length) {
    final c = input$0.codeUnitAt(state.pos);
    final v = c >= 65 && c <= 90 || c >= 97 && c <= 122;
    if (!v) {
      break;
    }
    state.pos += 1;
  }
  if (!(state.ok = state.pos != pos$3)) {
    final failPos = state.pos;
    state.pos = pos$3;
    state.failAt(failPos, const ErrorUnexpectedChar());
  }
  if (state.ok) {
    final input$1 = state.input;
    while (state.pos < input$1.length) {
      final c = input$1.codeUnitAt(state.pos);
      final v = c >= 48 && c <= 57 ||
          c >= 65 && c <= 90 ||
          c == 95 ||
          c >= 97 && c <= 122;
      if (!v) {
        break;
      }
      state.pos += 1;
    }
    state.ok = true;
    if (!state.ok) {
      state.pos = pos$2;
    }
  }
  if (state.ok) {
    $1 = state.pos != pos$1 ? state.input.substring(pos$1, state.pos) : '';
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _eq(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '=';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 61) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _semicolon(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = ';';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 59) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

ProductionRule? productionRule(State<String> state) {
  ProductionRule? $0;
  ProductionRule? $1;
  (
    ResultType,
    List<String>?,
    String,
    String,
    OrderedChoiceExpression,
    String
  )? $2;
  final pos$0 = state.pos;
  ResultType? $3;
  $3 = _type(state);
  if (state.ok) {
    List<String>? $4;
    List<String>? $5;
    $5 = _metadata(state);
    if (state.ok) {
      $4 = $5;
    } else {
      state.ok = true;
    }
    if (state.ok) {
      String? $11;
      $11 = _identifier(state);
      if (state.ok) {
        String? $15;
        $15 = _eq(state);
        if (state.ok) {
          OrderedChoiceExpression? $19;
          $19 = _expression(state);
          if (state.ok) {
            String? $20;
            $20 = _semicolon(state);
            if (state.ok) {
              $2 = ($3!, $4, $11!, $15!, $19!, $20!);
            }
          }
        }
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $2!;
    $1 = ProductionRule(
        resultType: v.$1, metadata: v.$2, name: v.$3, expression: v.$5);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    ProductionRule? $24;
    (List<String>?, String, String, OrderedChoiceExpression, String)? $25;
    final pos$10 = state.pos;
    List<String>? $26;
    List<String>? $27;
    $27 = _metadata(state);
    if (state.ok) {
      $26 = $27;
    } else {
      state.ok = true;
    }
    if (state.ok) {
      String? $33;
      $33 = _identifier(state);
      if (state.ok) {
        String? $37;
        $37 = _eq(state);
        if (state.ok) {
          OrderedChoiceExpression? $41;
          $41 = _expression(state);
          if (state.ok) {
            String? $42;
            $42 = _semicolon(state);
            if (state.ok) {
              $25 = ($26, $33!, $37!, $41!, $42!);
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = pos$10;
    }
    if (state.ok) {
      final v = $25!;
      $24 = ProductionRule(metadata: v.$1, name: v.$2, expression: v.$4);
    }
    if (state.ok) {
      $0 = $24;
    }
  }
  return $0;
}

Grammar? _grammar(State<String> state) {
  Grammar? $0;
  (String?, String?, List<ProductionRule>, Object?)? $1;
  final pos$0 = state.pos;
  String? $2;
  String? $3;
  $3 = _globals(state);
  if (state.ok) {
    $2 = $3;
  } else {
    state.ok = true;
  }
  if (state.ok) {
    String? $7;
    String? $8;
    $8 = _members(state);
    if (state.ok) {
      $7 = $8;
    } else {
      state.ok = true;
    }
    if (state.ok) {
      List<ProductionRule>? $17;
      final list$0 = <ProductionRule>[];
      while (true) {
        ProductionRule? $18;
        $18 = productionRule(state);
        if (!state.ok) {
          break;
        }
        list$0.add($18!);
      }
      if (state.ok = true) {
        $17 = list$0;
      }
      if (state.ok) {
        Object? $65;
        if (!(state.ok = state.pos >= state.input.length)) {
          state.fail(const ErrorExpectedEof());
        }
        if (state.ok) {
          $1 = ($2, $7, $17!, $65);
        }
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = Grammar(globals: v.$1, members: v.$2, rules: v.$3);
  }
  return $0;
}

Grammar? parser(State<String> state) {
  Grammar? $0;
  final pos$0 = state.pos;
  _ws(state);
  if (state.ok) {
    Grammar? $2;
    $2 = _grammar(state);
    if (state.ok) {
      if (!(state.ok = state.pos >= state.input.length)) {
        state.fail(const ErrorExpectedEof());
      }
      if (state.ok) {
        $0 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

Object? _blockBody(State<String> state) {
  Object? $0;
  Object? $1;
  final pos$0 = state.pos;
  const tag$0 = '{';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 123) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    List<Object?>? $2;
    final list$0 = <Object?>[];
    while (true) {
      Object? $3;
      $3 = _blockBody(state);
      if (!state.ok) {
        break;
      }
      list$0.add($3);
    }
    if (state.ok = true) {
      $2 = list$0;
    }
    if (state.ok) {
      const tag$1 = '}';
      if (state.ok = state.pos + 1 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 125) {
        state.pos += 1;
      } else {
        state.fail(const ErrorExpectedTags([tag$1]));
      }
      if (state.ok) {
        $1 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    $0 = $1;
  } else {
    Object? $4;
    final pos$1 = state.pos;
    final pos$2 = state.pos;
    const tag$2 = '}';
    if (state.ok = state.pos + 1 <= state.input.length &&
        state.input.codeUnitAt(state.pos) == 125) {
      state.pos += 1;
    } else {
      state.fail(const ErrorExpectedTags([tag$2]));
    }
    state.ok = !state.ok;
    if (!state.ok) {
      final length = state.pos - pos$2;
      state.pos = pos$2;
      state.fail(ErrorUnexpectedInput(length));
    }
    if (state.ok) {
      if (state.ok = state.pos < state.input.length) {
        final c = state.input.runeAt(state.pos);
        state.pos += c <= 0xffff ? 1 : 2;
      } else {
        state.fail(const ErrorUnexpectedEof());
      }
      if (!state.ok) {
        state.pos = pos$1;
      }
    }
    if (state.ok) {
      $0 = $4;
    }
  }
  return $0;
}

String? _colon(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = ':';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 58) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _dollar(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '\$';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 36) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

SymbolExpression? _symbol(State<String> state) {
  SymbolExpression? $0;
  String? $1;
  $1 = _identifier(state);
  if (state.ok) {
    final v = $1!;
    $0 = SymbolExpression(name: v);
  }
  return $0;
}

String? _escapedChar(State<String> state) {
  String? $0;
  String? $1;
  const tag$0 = 'n';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 110) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    $1 = '\n';
  }
  if (state.ok) {
    $0 = $1;
  } else {
    String? $2;
    const tag$1 = 'r';
    if (state.ok = state.pos + 1 <= state.input.length &&
        state.input.codeUnitAt(state.pos) == 114) {
      state.pos += 1;
    } else {
      state.fail(const ErrorExpectedTags([tag$1]));
    }
    if (state.ok) {
      $2 = '\r';
    }
    if (state.ok) {
      $0 = $2;
    } else {
      String? $3;
      const tag$2 = 't';
      if (state.ok = state.pos + 1 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 116) {
        state.pos += 1;
      } else {
        state.fail(const ErrorExpectedTags([tag$2]));
      }
      if (state.ok) {
        $3 = '\t';
      }
      if (state.ok) {
        $0 = $3;
      } else {
        String? $4;
        const tag$3 = '"';
        if (state.ok = state.pos + 1 <= state.input.length &&
            state.input.codeUnitAt(state.pos) == 34) {
          state.pos += 1;
        } else {
          state.fail(const ErrorExpectedTags([tag$3]));
        }
        if (state.ok) {
          $4 = '"';
        }
        if (state.ok) {
          $0 = $4;
        } else {
          String? $5;
          const tag$4 = '\'';
          if (state.ok = state.pos + 1 <= state.input.length &&
              state.input.codeUnitAt(state.pos) == 39) {
            state.pos += 1;
          } else {
            state.fail(const ErrorExpectedTags([tag$4]));
          }
          if (state.ok) {
            $5 = "'";
          }
          if (state.ok) {
            $0 = $5;
          } else {
            String? $6;
            const tag$5 = ']';
            if (state.ok = state.pos + 1 <= state.input.length &&
                state.input.codeUnitAt(state.pos) == 93) {
              state.pos += 1;
            } else {
              state.fail(const ErrorExpectedTags([tag$5]));
            }
            if (state.ok) {
              $6 = ']';
            }
            if (state.ok) {
              $0 = $6;
            } else {
              String? $7;
              const tag$6 = '\\';
              if (state.ok = state.pos + 1 <= state.input.length &&
                  state.input.codeUnitAt(state.pos) == 92) {
                state.pos += 1;
              } else {
                state.fail(const ErrorExpectedTags([tag$6]));
              }
              if (state.ok) {
                $7 = '\\';
              }
              if (state.ok) {
                $0 = $7;
              }
            }
          }
        }
      }
    }
  }
  return $0;
}

String? _literalChars(State<String> state) {
  String? $0;
  final input$0 = state.input;
  List<String>? list$0;
  String? str$0;
  while (state.pos < input$0.length) {
    var pos = state.pos;
    var c = -1;
    while (state.pos < input$0.length) {
      c = input$0.runeAt(state.pos);
      final ok = c >= 0x20 && c <= 0x10FFFF && c != 0x27 && c != 0x5C;
      if (!ok) {
        break;
      }
      state.pos += c > 0xffff ? 2 : 1;
    }
    if (state.pos != pos) {
      final v = input$0.substring(pos, state.pos);
      if (str$0 == null) {
        str$0 = v;
      } else if (list$0 == null) {
        list$0 = [str$0, v];
      } else {
        list$0.add(v);
      }
    }
    if (c != 92) {
      break;
    }
    pos = state.pos;
    state.pos += 1;
    String? $1;
    $1 = _escapedChar(state);
    if (!state.ok) {
      state.pos = pos;
      break;
    }
    if (str$0 == null) {
      str$0 = $1!;
    } else {
      if (list$0 == null) {
        list$0 = [str$0, $1!];
      } else {
        list$0.add($1!);
      }
    }
  }
  state.ok = true;
  if (str$0 == null) {
    $0 = '';
  } else if (list$0 == null) {
    $0 = str$0;
  } else {
    $0 = list$0.join();
  }
  return $0;
}

String? _singleQuote(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '\'';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 39) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

LiteralExpression? _literal(State<String> state) {
  LiteralExpression? $0;
  String? $1;
  final pos$0 = state.pos;
  const tag$0 = '\'';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 39) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    String? $2;
    $2 = _literalChars(state);
    if (state.ok) {
      _singleQuote(state);
      if (state.ok) {
        $1 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = LiteralExpression(string: v);
  }
  return $0;
}

String? _hexValue(State<String> state) {
  String? $0;
  (String, String, String)? $1;
  final pos$0 = state.pos;
  String? $2;
  const tag$0 = 'u{';
  if (state.ok = state.pos + 2 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 117 &&
      state.input.codeUnitAt(state.pos + 1) == 123) {
    state.pos += 2;
    $2 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    String? $3;
    final input$0 = state.input;
    final pos$1 = state.pos;
    while (state.pos < input$0.length) {
      final c = input$0.codeUnitAt(state.pos);
      final v = c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102;
      if (!v) {
        break;
      }
      state.pos += 1;
    }
    if (state.ok = state.pos != pos$1) {
      $3 = input$0.substring(pos$1, state.pos);
    } else {
      final failPos = state.pos;
      state.pos = pos$1;
      state.failAt(failPos, const ErrorUnexpectedChar());
    }
    if (state.ok) {
      String? $4;
      const tag$1 = '}';
      if (state.ok = state.pos + 1 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 125) {
        state.pos += 1;
        $4 = tag$1;
      } else {
        state.fail(const ErrorExpectedTags([tag$1]));
      }
      if (state.ok) {
        $1 = ($2!, $3!, $4!);
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = String.fromCharCode(int.parse(v.$2, radix: 16));
  }
  return $0;
}

int? _rangeChar(State<String> state) {
  int? $0;
  int? $1;
  final pos$0 = state.pos;
  const tag$0 = '\\';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 92) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    int? $2;
    int? $3;
    String? $4;
    $4 = _escapedChar(state);
    if (state.ok) {
      final v = $4!;
      $3 = v.codeUnitAt(0);
    }
    if (state.ok) {
      $2 = $3;
    } else {
      int? $13;
      String? $14;
      $14 = _hexValue(state);
      if (state.ok) {
        final v = $14!;
        $13 = v.codeUnitAt(0);
      }
      if (state.ok) {
        $2 = $13;
      }
    }
    if (state.ok) {
      $1 = $2;
    } else {
      state.pos = pos$0;
    }
  }
  if (state.ok) {
    $0 = $1;
  } else {
    int? $20;
    final pos$3 = state.pos;
    final pos$4 = state.pos;
    const tag$10 = '\\';
    if (state.ok = state.pos + 1 <= state.input.length &&
        state.input.codeUnitAt(state.pos) == 92) {
      state.pos += 1;
    } else {
      state.fail(const ErrorExpectedTags([tag$10]));
    }
    state.ok = !state.ok;
    if (!state.ok) {
      final length = state.pos - pos$4;
      state.pos = pos$4;
      state.fail(ErrorUnexpectedInput(length));
    }
    if (state.ok) {
      int? $21;
      if (state.ok = state.pos < state.input.length) {
        final c = state.input.runeAt(state.pos);
        state.pos += c <= 0xffff ? 1 : 2;
        $21 = c;
      } else {
        state.fail(const ErrorUnexpectedEof());
      }
      if (state.ok) {
        $20 = $21;
      } else {
        state.pos = pos$3;
      }
    }
    if (state.ok) {
      $0 = $20;
    }
  }
  return $0;
}

(int, int)? _range(State<String> state) {
  (int, int)? $0;
  (int, int)? $1;
  (int, int)? $2;
  final pos$0 = state.pos;
  int? $3;
  $3 = _rangeChar(state);
  if (state.ok) {
    const tag$11 = '-';
    if (state.ok = state.pos + 1 <= state.input.length &&
        state.input.codeUnitAt(state.pos) == 45) {
      state.pos += 1;
    } else {
      state.fail(const ErrorExpectedTags([tag$11]));
    }
    if (state.ok) {
      int? $26;
      $26 = _rangeChar(state);
      if (state.ok) {
        $2 = ($3!, $26!);
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $2!;
    $1 = (v.$1, v.$2);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    (int, int)? $49;
    int? $50;
    $50 = _rangeChar(state);
    if (state.ok) {
      final v = $50!;
      $49 = (v, v);
    }
    if (state.ok) {
      $0 = $49;
    }
  }
  return $0;
}

String? _closeBracket(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = ']';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 93) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

CharacterClassExpression? _characterClass(State<String> state) {
  CharacterClassExpression? $0;
  List<(int, int)>? $1;
  final pos$0 = state.pos;
  const tag$0 = '[';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 91) {
    state.pos += 1;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    List<(int, int)>? $2;
    final list$0 = <(int, int)>[];
    while (true) {
      (int, int)? $3;
      final pos$1 = state.pos;
      final pos$2 = state.pos;
      const tag$1 = ']';
      if (state.ok = state.pos + 1 <= state.input.length &&
          state.input.codeUnitAt(state.pos) == 93) {
        state.pos += 1;
      } else {
        state.fail(const ErrorExpectedTags([tag$1]));
      }
      state.ok = !state.ok;
      if (!state.ok) {
        final length = state.pos - pos$2;
        state.pos = pos$2;
        state.fail(ErrorUnexpectedInput(length));
      }
      if (state.ok) {
        (int, int)? $4;
        $4 = _range(state);
        if (state.ok) {
          $3 = $4;
        } else {
          state.pos = pos$1;
        }
      }
      if (!state.ok) {
        break;
      }
      list$0.add($3!);
    }
    if (state.ok = list$0.isNotEmpty) {
      $2 = list$0;
    }
    if (state.ok) {
      _closeBracket(state);
      if (state.ok) {
        $1 = $2;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = CharacterClassExpression(ranges: v);
  }
  return $0;
}

String? _openParenthesis(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '(';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 40) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _closeParenthesis(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = ')';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 41) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

GroupExpression? group(State<String> state) {
  GroupExpression? $0;
  OrderedChoiceExpression? $1;
  final pos$0 = state.pos;
  _openParenthesis(state);
  if (state.ok) {
    OrderedChoiceExpression? $5;
    $5 = _expression(state);
    if (state.ok) {
      _closeParenthesis(state);
      if (state.ok) {
        $1 = $5;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = GroupExpression(expression: v);
  }
  return $0;
}

String? _dot(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '.';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 46) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

AnyCharacterExpression? _anyCharacter(State<String> state) {
  AnyCharacterExpression? $0;
  String? $1;
  $1 = _dot(state);
  if (state.ok) {
    final v = $1!;
    $0 = AnyCharacterExpression();
  }
  return $0;
}

ErrorHandlerExpression? _errorHandler(State<String> state) {
  ErrorHandlerExpression? $0;
  (String, String, OrderedChoiceExpression, String, String)? $1;
  final pos$0 = state.pos;
  String? $2;
  final pos$1 = state.pos;
  String? $3;
  const tag$0 = '@errorHandler';
  final input$0 = state.input;
  if (state.ok = state.pos < input$0.length &&
      input$0.codeUnitAt(state.pos) == 64 &&
      input$0.startsWith(tag$0, state.pos)) {
    state.pos += 13;
    $3 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $2 = $3;
    } else {
      state.pos = pos$1;
    }
  }
  if (state.ok) {
    String? $5;
    $5 = _openParenthesis(state);
    if (state.ok) {
      OrderedChoiceExpression? $9;
      $9 = _expression(state);
      if (state.ok) {
        String? $10;
        $10 = _closeParenthesis(state);
        if (state.ok) {
          String? $14;
          $14 = _block(state);
          if (state.ok) {
            $1 = ($2!, $5!, $9!, $10!, $14!);
          }
        }
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = ErrorHandlerExpression(expression: v.$3, handler: v.$5);
  }
  return $0;
}

Expression? _primary(State<String> state) {
  Expression? $0;
  SymbolExpression? $1;
  $1 = _symbol(state);
  if (state.ok) {
    $0 = $1;
  } else {
    LiteralExpression? $7;
    $7 = _literal(state);
    if (state.ok) {
      $0 = $7;
    } else {
      CharacterClassExpression? $24;
      $24 = _characterClass(state);
      if (state.ok) {
        $0 = $24;
      } else {
        GroupExpression? $106;
        $106 = group(state);
        if (state.ok) {
          $0 = $106;
        } else {
          AnyCharacterExpression? $116;
          $116 = _anyCharacter(state);
          if (state.ok) {
            $0 = $116;
          } else {
            ErrorHandlerExpression? $122;
            $122 = _errorHandler(state);
            if (state.ok) {
              $0 = $122;
            }
          }
        }
      }
    }
  }
  return $0;
}

String? _star(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '*';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 42) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _plus(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '+';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 43) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _openBrace(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '{';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 123) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

int? _integer(State<String> state) {
  int? $0;
  String? $1;
  final input$0 = state.input;
  final pos$0 = state.pos;
  while (state.pos < input$0.length) {
    final c = input$0.codeUnitAt(state.pos);
    final v = c >= 48 && c <= 57;
    if (!v) {
      break;
    }
    state.pos += 1;
  }
  if (state.ok = state.pos != pos$0) {
    $1 = input$0.substring(pos$0, state.pos);
  } else {
    final failPos = state.pos;
    state.pos = pos$0;
    state.failAt(failPos, const ErrorUnexpectedChar());
  }
  if (state.ok) {
    final v = $1!;
    $0 = int.parse(v);
  }
  return $0;
}

String? _comma(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = ',';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 44) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

(int?, int?)? _minMax(State<String> state) {
  (int?, int?)? $0;
  final pos$0 = state.pos;
  _openBrace(state);
  if (state.ok) {
    (int?, int?)? $4;
    (int?, int?)? $5;
    (int, int)? $6;
    final pos$2 = state.pos;
    int? $7;
    $7 = _integer(state);
    if (state.ok) {
      _comma(state);
      if (state.ok) {
        int? $13;
        $13 = _integer(state);
        if (state.ok) {
          $6 = ($7!, $13!);
        }
      }
    }
    if (!state.ok) {
      state.pos = pos$2;
    }
    if (state.ok) {
      final v = $6!;
      $5 = (v.$1, v.$2);
    }
    if (state.ok) {
      $4 = $5;
    } else {
      (int?, int?)? $16;
      int? $17;
      final pos$6 = state.pos;
      _comma(state);
      if (state.ok) {
        int? $21;
        $21 = _integer(state);
        if (state.ok) {
          $17 = $21;
        } else {
          state.pos = pos$6;
        }
      }
      if (state.ok) {
        final v = $17!;
        $16 = (null, v);
      }
      if (state.ok) {
        $4 = $16;
      } else {
        (int?, int?)? $24;
        int? $25;
        final pos$9 = state.pos;
        int? $26;
        $26 = _integer(state);
        if (state.ok) {
          _comma(state);
          if (state.ok) {
            $25 = $26;
          } else {
            state.pos = pos$9;
          }
        }
        if (state.ok) {
          final v = $25!;
          $24 = (null, v);
        }
        if (state.ok) {
          $4 = $24;
        } else {
          (int?, int?)? $32;
          int? $33;
          $33 = _integer(state);
          if (state.ok) {
            final v = $33!;
            $32 = (v, v);
          }
          if (state.ok) {
            $4 = $32;
          }
        }
      }
    }
    if (state.ok) {
      _closeBrace(state);
      if (state.ok) {
        $0 = $4;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

String? _question(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '?';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 63) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

Expression? _suffix(State<String> state) {
  Expression? $0;
  Expression? $1;
  Expression? $2;
  final pos$0 = state.pos;
  Expression? $3;
  $3 = _primary(state);
  if (state.ok) {
    _star(state);
    if (state.ok) {
      $2 = $3;
    } else {
      state.pos = pos$0;
    }
  }
  if (state.ok) {
    final v = $2!;
    $1 = ZeroOrMoreExpression(expression: v);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    Expression? $150;
    Expression? $151;
    final pos$39 = state.pos;
    Expression? $152;
    $152 = _primary(state);
    if (state.ok) {
      _plus(state);
      if (state.ok) {
        $151 = $152;
      } else {
        state.pos = pos$39;
      }
    }
    if (state.ok) {
      final v = $151!;
      $150 = OneOrMoreExpression(expression: v);
    }
    if (state.ok) {
      $0 = $150;
    } else {
      Expression? $299;
      (Expression, (int?, int?))? $300;
      final pos$78 = state.pos;
      Expression? $301;
      $301 = _primary(state);
      if (state.ok) {
        (int?, int?)? $445;
        $445 = _minMax(state);
        if (state.ok) {
          $300 = ($301!, $445!);
        } else {
          state.pos = pos$78;
        }
      }
      if (state.ok) {
        final v = $300!;
        $299 =
            RepetitionExpression(expression: v.$1, min: v.$2.$1, max: v.$2.$2);
      }
      if (state.ok) {
        $0 = $299;
      } else {
        Expression? $485;
        Expression? $486;
        final pos$130 = state.pos;
        Expression? $487;
        $487 = _primary(state);
        if (state.ok) {
          _question(state);
          if (state.ok) {
            $486 = $487;
          } else {
            state.pos = pos$130;
          }
        }
        if (state.ok) {
          final v = $486!;
          $485 = OptionalExpression(expression: v);
        }
        if (state.ok) {
          $0 = $485;
        } else {
          Expression? $634;
          $634 = _primary(state);
          if (state.ok) {
            $0 = $634;
          }
        }
      }
    }
  }
  return $0;
}

String? _not(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '!';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 33) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _and(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '&';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 38) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

Expression? _prefix(State<String> state) {
  Expression? $0;
  Expression? $1;
  Expression? $2;
  final pos$0 = state.pos;
  _dollar(state);
  if (state.ok) {
    Expression? $6;
    $6 = _suffix(state);
    if (state.ok) {
      $2 = $6;
    } else {
      state.pos = pos$0;
    }
  }
  if (state.ok) {
    final v = $2!;
    $1 = SliceExpression(expression: v);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    Expression? $785;
    Expression? $786;
    final pos$208 = state.pos;
    _not(state);
    if (state.ok) {
      Expression? $790;
      $790 = _suffix(state);
      if (state.ok) {
        $786 = $790;
      } else {
        state.pos = pos$208;
      }
    }
    if (state.ok) {
      final v = $786!;
      $785 = NotPredicateExpression(expression: v);
    }
    if (state.ok) {
      $0 = $785;
    } else {
      Expression? $1569;
      Expression? $1570;
      final pos$416 = state.pos;
      _and(state);
      if (state.ok) {
        Expression? $1574;
        $1574 = _suffix(state);
        if (state.ok) {
          $1570 = $1574;
        } else {
          state.pos = pos$416;
        }
      }
      if (state.ok) {
        final v = $1570!;
        $1569 = AndPredicateExpression(expression: v);
      }
      if (state.ok) {
        $0 = $1569;
      } else {
        Expression? $2353;
        $2353 = _suffix(state);
        if (state.ok) {
          $0 = $2353;
        }
      }
    }
  }
  return $0;
}

Expression? _sequenceElement(State<String> state) {
  Expression? $0;
  Expression? $1;
  (String, Expression)? $2;
  final pos$0 = state.pos;
  String? $3;
  $3 = _identifier(state);
  if (state.ok) {
    _colon(state);
    if (state.ok) {
      Expression? $10;
      $10 = _prefix(state);
      if (state.ok) {
        $2 = ($3!, $10!);
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  if (state.ok) {
    final v = $2!;
    $1 = v.$2..semanticVariable = v.$1;
  }
  if (state.ok) {
    $0 = $1;
  } else {
    Expression? $3143;
    $3143 = _prefix(state);
    if (state.ok) {
      $0 = $3143;
    }
  }
  return $0;
}

String? _lt(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '<';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 60) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

String? _gt(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '>';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 62) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

SemanticAction? _action(State<String> state) {
  SemanticAction? $0;
  SemanticAction? $1;
  String? $2;
  $2 = _block(state);
  if (state.ok) {
    final v = $2!;
    $1 = SemanticAction(source: v);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    SemanticAction? $8;
    (String, ResultType, String, String)? $9;
    final pos$3 = state.pos;
    String? $10;
    $10 = _lt(state);
    if (state.ok) {
      ResultType? $14;
      $14 = _type(state);
      if (state.ok) {
        String? $15;
        $15 = _gt(state);
        if (state.ok) {
          String? $19;
          $19 = _block(state);
          if (state.ok) {
            $9 = ($10!, $14!, $15!, $19!);
          }
        }
      }
    }
    if (!state.ok) {
      state.pos = pos$3;
    }
    if (state.ok) {
      final v = $9!;
      $8 = SemanticAction(resultType: v.$2, source: v.$4);
    }
    if (state.ok) {
      $0 = $8;
    }
  }
  return $0;
}

SequenceExpression? _sequence(State<String> state) {
  SequenceExpression? $0;
  (List<Expression>, SemanticAction?)? $1;
  final pos$0 = state.pos;
  List<Expression>? $2;
  var pos$1 = state.pos;
  final list$0 = <Expression>[];
  while (true) {
    Expression? $3;
    $3 = _sequenceElement(state);
    if (!state.ok) {
      state.pos = pos$1;
      break;
    }
    list$0.add($3!);
    pos$1 = state.pos;
    _ws(state);
    if (!state.ok) {
      break;
    }
  }
  if (state.ok = list$0.isNotEmpty) {
    $2 = list$0;
  }
  if (state.ok) {
    SemanticAction? $6281;
    SemanticAction? $6282;
    $6282 = _action(state);
    if (state.ok) {
      $6281 = $6282;
    } else {
      state.ok = true;
    }
    if (state.ok) {
      $1 = ($2!, $6281);
    } else {
      state.pos = pos$0;
    }
  }
  if (state.ok) {
    final v = $1!;
    $0 = SequenceExpression(expressions: v.$1, action: v.$2);
  }
  return $0;
}

String? _backslash(State<String> state) {
  String? $0;
  final pos$0 = state.pos;
  String? $1;
  const tag$0 = '/';
  if (state.ok = state.pos + 1 <= state.input.length &&
      state.input.codeUnitAt(state.pos) == 47) {
    state.pos += 1;
    $1 = tag$0;
  } else {
    state.fail(const ErrorExpectedTags([tag$0]));
  }
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

OrderedChoiceExpression? _orderedChoice(State<String> state) {
  OrderedChoiceExpression? $0;
  List<SequenceExpression>? $1;
  var pos$0 = state.pos;
  final list$0 = <SequenceExpression>[];
  while (true) {
    SequenceExpression? $2;
    $2 = _sequence(state);
    if (!state.ok) {
      state.pos = pos$0;
      break;
    }
    list$0.add($2!);
    pos$0 = state.pos;
    _backslash(state);
    if (!state.ok) {
      break;
    }
  }
  if (state.ok = list$0.isNotEmpty) {
    $1 = list$0;
  }
  if (state.ok) {
    final v = $1!;
    $0 = OrderedChoiceExpression(expressions: v);
  }
  return $0;
}

OrderedChoiceExpression? _expression(State<String> state) {
  OrderedChoiceExpression? $0;
  final pos$0 = state.pos;
  OrderedChoiceExpression? $1;
  $1 = _orderedChoice(state);
  if (state.ok) {
    _ws(state);
    if (state.ok) {
      $0 = $1;
    } else {
      state.pos = pos$0;
    }
  }
  return $0;
}

List<ResultType>? _typeArguments(State<String> state) {
  List<ResultType>? $0;
  final pos$0 = state.pos;
  _lt(state);
  if (state.ok) {
    List<ResultType>? $4;
    var pos$2 = state.pos;
    final list$0 = <ResultType>[];
    while (true) {
      ResultType? $5;
      $5 = _type(state);
      if (!state.ok) {
        state.pos = pos$2;
        break;
      }
      list$0.add($5!);
      pos$2 = state.pos;
      _comma(state);
      if (!state.ok) {
        break;
      }
    }
    if (state.ok = list$0.isNotEmpty) {
      $4 = list$0;
    }
    if (state.ok) {
      _gt(state);
      if (state.ok) {
        $0 = $4;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

ResultType? _genericType(State<String> state) {
  ResultType? $0;
  ResultType? $1;
  (String, List<ResultType>)? $2;
  final pos$0 = state.pos;
  String? $3;
  $3 = _identifier(state);
  if (state.ok) {
    List<ResultType>? $7;
    $7 = _typeArguments(state);
    if (state.ok) {
      $2 = ($3!, $7!);
    } else {
      state.pos = pos$0;
    }
  }
  if (state.ok) {
    final v = $2!;
    $1 = GenericType(name: v.$1, arguments: v.$2);
  }
  if (state.ok) {
    $0 = $1;
  } else {
    ResultType? $20;
    String? $21;
    $21 = _identifier(state);
    if (state.ok) {
      final v = $21!;
      $20 = GenericType(name: v);
    }
    if (state.ok) {
      $0 = $20;
    }
  }
  return $0;
}

List<(ResultType, String)>? _namedFields(State<String> state) {
  List<(ResultType, String)>? $0;
  final pos$0 = state.pos;
  _openBrace(state);
  if (state.ok) {
    List<(ResultType, String)>? $4;
    final pos$2 = state.pos;
    List<(ResultType, String)>? $5;
    var pos$3 = state.pos;
    final list$0 = <(ResultType, String)>[];
    while (true) {
      (ResultType, String)? $6;
      final pos$4 = state.pos;
      ResultType? $7;
      $7 = _type(state);
      if (state.ok) {
        String? $8;
        $8 = _identifier(state);
        if (state.ok) {
          $6 = ($7!, $8!);
        } else {
          state.pos = pos$4;
        }
      }
      if (!state.ok) {
        state.pos = pos$3;
        break;
      }
      list$0.add($6!);
      pos$3 = state.pos;
      _comma(state);
      if (!state.ok) {
        break;
      }
    }
    if (state.ok = list$0.isNotEmpty) {
      $5 = list$0;
    }
    if (state.ok) {
      _comma(state);
      if (!state.ok) {
        state.ok = true;
      }
      if (state.ok) {
        $4 = $5;
      } else {
        state.pos = pos$2;
      }
    }
    if (state.ok) {
      _closeBrace(state);
      if (state.ok) {
        $0 = $4;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

List<ResultType>? _positionalFields(State<String> state) {
  List<ResultType>? $0;
  var pos$0 = state.pos;
  final list$0 = <ResultType>[];
  while (true) {
    ResultType? $1;
    $1 = _type(state);
    if (!state.ok) {
      state.pos = pos$0;
      break;
    }
    list$0.add($1!);
    pos$0 = state.pos;
    _comma(state);
    if (!state.ok) {
      break;
    }
  }
  if (state.ok = list$0.isNotEmpty) {
    $0 = list$0;
  }
  return $0;
}

ResultType? _recordType(State<String> state) {
  ResultType? $0;
  final pos$0 = state.pos;
  _openParenthesis(state);
  if (state.ok) {
    ResultType? $4;
    ResultType? $5;
    List<(ResultType, String)>? $6;
    $6 = _namedFields(state);
    if (state.ok) {
      final v = $6!;
      $5 = RecordType(named: v);
    }
    if (state.ok) {
      $4 = $5;
    } else {
      ResultType? $28;
      (List<ResultType>, String, List<(ResultType, String)>)? $29;
      final pos$14 = state.pos;
      List<ResultType>? $30;
      $30 = _positionalFields(state);
      if (state.ok) {
        String? $36;
        $36 = _comma(state);
        if (state.ok) {
          List<(ResultType, String)>? $40;
          $40 = _namedFields(state);
          if (state.ok) {
            $29 = ($30!, $36!, $40!);
          }
        }
      }
      if (!state.ok) {
        state.pos = pos$14;
      }
      if (state.ok) {
        final v = $29!;
        $28 = RecordType(positional: v.$1, named: v.$3);
      }
      if (state.ok) {
        $4 = $28;
      } else {
        ResultType? $62;
        (ResultType, String, List<ResultType>, String?)? $63;
        final pos$30 = state.pos;
        ResultType? $64;
        $64 = _type(state);
        if (state.ok) {
          String? $65;
          $65 = _comma(state);
          if (state.ok) {
            List<ResultType>? $69;
            $69 = _positionalFields(state);
            if (state.ok) {
              String? $75;
              String? $76;
              $76 = _comma(state);
              if (state.ok) {
                $75 = $76;
              } else {
                state.ok = true;
              }
              if (state.ok) {
                $63 = ($64!, $65!, $69!, $75);
              }
            }
          }
        }
        if (!state.ok) {
          state.pos = pos$30;
        }
        if (state.ok) {
          final v = $63!;
          $62 = RecordType(positional: [v.$1, ...v.$3]);
        }
        if (state.ok) {
          $4 = $62;
        } else {
          ResultType? $80;
          (ResultType, String)? $81;
          final pos$35 = state.pos;
          ResultType? $82;
          $82 = _type(state);
          if (state.ok) {
            String? $83;
            $83 = _comma(state);
            if (state.ok) {
              $81 = ($82!, $83!);
            } else {
              state.pos = pos$35;
            }
          }
          if (state.ok) {
            final v = $81!;
            $80 = RecordType(positional: [v.$1]);
          }
          if (state.ok) {
            $4 = $80;
          }
        }
      }
    }
    if (state.ok) {
      _closeParenthesis(state);
      if (state.ok) {
        $0 = $4;
      }
    }
  }
  if (!state.ok) {
    state.pos = pos$0;
  }
  return $0;
}

ResultType? _type(State<String> state) {
  ResultType? $0;
  ResultType? $1;
  $1 = _genericType(state);
  if (state.ok) {
    $0 = $1;
  } else {
    ResultType? $27;
    $27 = _recordType(state);
    if (state.ok) {
      $0 = $27;
    }
  }
  return $0;
}

class ErrorExpectedChar extends ParseError {
  final int char;

  const ErrorExpectedChar(this.char);

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    final hexValue = char.toRadixString(16);
    final value = ParseError.escape(char);
    return 'Unexpected character $value (0x$hexValue)';
  }
}

class ErrorExpectedEof extends ParseError {
  const ErrorExpectedEof();

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    return 'Expected end of file';
  }
}

class ErrorExpectedInt extends ParseError {
  final int size;

  final int value;

  const ErrorExpectedInt(this.size, this.value);

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    var string = value.toRadixString(16);
    if (const [8, 16, 24, 32, 40, 48, 56, 64].contains(size)) {
      string = string.padLeft(size >> 2, '0');
    }
    if (value >= 0 && value <= 0x10ffff) {
      string = '$string (${ParseError.escape(value)})';
    }
    return 'Expected 0x$string';
  }
}

class ErrorExpectedTags extends ParseError {
  final List<String> tags;

  const ErrorExpectedTags(this.tags);

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    final value = tags.map(ParseError.escape).join(', ');
    return 'Expected $value';
  }
}

class ErrorMessage extends ParseError {
  @override
  final int length;

  final String message;

  const ErrorMessage(this.length, this.message);

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    return message;
  }
}

class ErrorUnexpectedChar extends ParseError {
  const ErrorUnexpectedChar();

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    if (input is String) {
      if (offset < input.length) {
        final char = input.runeAt(offset);
        final hexValue = char.toRadixString(16);
        final value = ParseError.escape(char);
        return 'Unexpected character $value (0x$hexValue)';
      }
    }
    return 'Unexpected character';
  }
}

class ErrorUnexpectedEof extends ParseError {
  const ErrorUnexpectedEof();

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    return 'Unexpected end of file';
  }
}

class ErrorUnexpectedInput extends ParseError {
  @override
  final int length;

  const ErrorUnexpectedInput(this.length);

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    return 'Unexpected input';
  }
}

class ErrorUnknown extends ParseError {
  const ErrorUnknown();

  @override
  String getMessage({
    required Object? input,
    required int offset,
  }) {
    return 'Unknown error';
  }
}

abstract class ParseError {
  const ParseError();

  int get length => 0;

  String getMessage({
    required Object? input,
    required int offset,
  });

  static String errorMessage(
      String input, int offset, List<ParseError> errors) {
    int max(int x, int y) => x > y ? x : y;
    int min(int x, int y) => x < y ? x : y;
    final sb = StringBuffer();
    final errorList = errors.toList();
    if (offset >= input.length) {
      errorList.add(const ErrorUnexpectedEof());
      errorList.removeWhere((e) => e is ErrorUnexpectedChar);
    }
    final expectedTags = errorList.whereType<ErrorExpectedTags>().toList();
    if (expectedTags.isNotEmpty) {
      errorList.removeWhere((e) => e is ErrorExpectedTags);
      final tags = <String>{};
      for (final error in expectedTags) {
        tags.addAll(error.tags);
      }
      final error = ErrorExpectedTags(tags.toList());
      errorList.add(error);
    }
    final errorInfoList = errorList
        .map((e) {
          final offset2 = offset + e.length;
          final start = min(offset2, offset);
          final end = max(offset2, offset);
          return (
            start: start,
            end: end,
            message: e.getMessage(offset: start, input: input),
          );
        })
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
      final start = errorInfo.start;
      final end = errorInfo.end;
      final message = errorInfo.message;
      var row = 1;
      var lineStart = 0, next = 0, pos = 0;
      while (pos < input.length) {
        final c = input.codeUnitAt(pos++);
        if (c == 0xa || c == 0xd) {
          next = c == 0xa ? 0xd : 0xa;
          if (pos < input.length && input.codeUnitAt(pos) == next) {
            pos++;
          }
          if (pos - 1 >= start) {
            break;
          }
          row++;
          lineStart = pos;
        }
      }
      final inputLen = input.length;
      final lineLimit = min(80, inputLen);
      final start2 = start;
      final end2 = min(start2 + lineLimit, end);
      final errorLen = end2 - start;
      final extraLen = lineLimit - errorLen;
      final rightLen = min(inputLen - end2, extraLen - (extraLen >> 1));
      final leftLen = min(start, max(0, lineLimit - errorLen - rightLen));
      final list = <int>[];
      final iterator = RuneIterator.at(input, start2);
      for (var i = 0; i < leftLen; i++) {
        if (!iterator.movePrevious()) {
          break;
        }
        list.add(iterator.current);
      }
      final column = start - lineStart + 1;
      final left = String.fromCharCodes(list.reversed);
      final end3 = min(inputLen, start2 + (lineLimit - leftLen));
      final indicatorLen = max(1, errorLen);
      final right = input.substring(start2, end3);
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

class Result<T> {
  final T value;

  const Result(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(other) => other is Result<T> && value == other.value;

  @override
  String toString() {
    return '$value';
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

  final List<
      ({
        int last,
        int index,
        List<({int start, int end, bool ok, Object? result})?> list
      })?> _cache = List.filled(64, null, growable: false);

  State(this.input);

  @pragma('vm:prefer-inline')
  bool canHandleError(int failPos, int errorCount) => failPos == this.failPos
      ? errorCount < this.errorCount
      : failPos < this.failPos;

  void clearErrors(int failPos, int errorCount) {
    if (this.failPos == failPos) {
      this.errorCount = errorCount;
    } else if (this.failPos > failPos) {
      this.errorCount = 0;
    }
  }

  @pragma('vm:prefer-inline')
  void fail(ParseError error) {
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
  }

  @pragma('vm:prefer-inline')
  void failAll(List<ParseError> errors) {
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
  }

  @pragma('vm:prefer-inline')
  void failAllAt(int offset, List<ParseError> errors) {
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
  }

  @pragma('vm:prefer-inline')
  void failAt(int offset, ParseError error) {
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
  }

  List<ParseError> getErrors() {
    return List.generate(errorCount, (i) => errors[i]!);
  }

  @pragma('vm:prefer-inline')
  void memoize(int id, int start, int end, bool ok, Object? result) {
    if (id >= _cache.length) {
      return;
    }

    var index = -1;
    var record = _cache[id];
    if (record == null) {
      record =
          (last: start, index: 0, list: List.filled(4, null, growable: false));
      _cache[id] = record;
    } else {
      index = record.index;
    }

    if (record.last <= pos) {
      final list = record.list;
      index = index < list.length - 1 ? index + 1 : 0;
      list[index] = (start: start, end: end, ok: ok, result: result);
      _cache[id] = (last: pos, index: index, list: list);
    }
  }

  @pragma('vm:prefer-inline')
  ({int start, int end, bool ok, Object? result})? memoized(int id, int pos) {
    if (id >= _cache.length) {
      return null;
    }

    final record = _cache[id];
    if (record == null) {
      return null;
    }

    final list = record.list;
    var count = 0;
    while (count < list.length) {
      final value = list[count];
      if (value == null) {
        return null;
      }

      if (value.start == pos) {
        return value;
      }

      count++;
    }

    return null;
  }

  @override
  String toString() {
    if (input is String) {
      final s = input as String;
      if (pos >= s.length) {
        return '$pos:';
      }
      var length = s.length - pos;
      length = length > 40 ? 40 : length;
      final string = s.substring(pos, pos + length);
      return '$pos:$string';
    } else {
      return super.toString();
    }
  }
}

extension on String {
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

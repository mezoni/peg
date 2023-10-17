abstract class AstNode {
  AstNode? parent;

  T accept<T>(AstNodeVisitor<T> visitor);

  void visitChildren<T>(AstNodeVisitor<T> visitor) {
    return;
  }
}

abstract class AstNodeVisitor<T> {
  T visitBinary(BinaryNode node);

  T visitBoolean(BooleanNode node);

  T visitGroup(GroupNode node);

  T visitIdentifier(IdentifierNode node);

  T visitNumeric(NumericNode node);

  T visitTernary(TernaryNode node);
}

class BinaryNode extends AstNode {
  final AstNode left;

  final String operator;

  final AstNode right;

  BinaryNode(this.left, this.operator, this.right) {
    left.parent = this;
    right.parent = this;
  }

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitBinary(this);
  }

  @override
  String toString() {
    return '$left $operator $right';
  }

  @override
  void visitChildren<T>(AstNodeVisitor<T> visitor) {
    left.accept(visitor);
    right.accept(visitor);
  }
}

class BooleanNode extends AstNode {
  final bool value;

  BooleanNode(this.value);

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitBoolean(this);
  }

  @override
  String toString() {
    return '$value';
  }
}

class GroupNode extends AstNode {
  final AstNode node;

  GroupNode(this.node) {
    node.parent = this;
  }

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitGroup(this);
  }

  @override
  String toString() {
    return '($node)';
  }

  @override
  void visitChildren<T>(AstNodeVisitor<T> visitor) {
    node.accept(visitor);
  }
}

class IdentifierNode extends AstNode {
  final String name;

  IdentifierNode(this.name);

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitIdentifier(this);
  }

  @override
  String toString() {
    return name;
  }
}

class NumericNode extends AstNode {
  final num value;

  NumericNode(this.value);

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitNumeric(this);
  }

  @override
  String toString() {
    return '$value';
  }
}

class TernaryNode extends AstNode {
  final AstNode condition;

  final AstNode left;

  final AstNode right;

  TernaryNode(this.condition, this.left, this.right) {
    condition.parent = this;
    left.parent = this;
    right.parent = this;
  }

  @override
  T accept<T>(AstNodeVisitor<T> visitor) {
    return visitor.visitTernary(this);
  }

  @override
  String toString() {
    return '$condition ? $left : $right';
  }

  @override
  void visitChildren<T>(AstNodeVisitor<T> visitor) {
    condition.accept(visitor);
    left.accept(visitor);
    right.accept(visitor);
  }
}

class BinaryParser {
  AstNode _binary(AstNode? left, ({String op, AstNode expr}) next) {
    return BinaryNode(left!, next.op, next.expr);
  }

  /// CloseParenthesis =
  ///   v:')' Spaces
  ///   ;
  void fastParseCloseParenthesis(State<String> state) {
    // v:')' Spaces
    final $0 = state.pos;
    const $1 = ')';
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 41;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Colon =
  ///   v:':' Spaces
  ///   ;
  void fastParseColon(State<String> state) {
    // v:':' Spaces
    final $0 = state.pos;
    const $1 = ':';
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 58;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// OpenParenthesis =
  ///   v:'(' Spaces
  ///   ;
  void fastParseOpenParenthesis(State<String> state) {
    // v:'(' Spaces
    final $0 = state.pos;
    const $1 = '(';
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 40;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
  }

  /// Question =
  ///   v:'?' Spaces
  ///   ;
  void fastParseQuestion(State<String> state) {
    // v:'?' Spaces
    final $0 = state.pos;
    const $1 = '?';
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 63;
    state.ok ? state.pos++ : state.fail(const ErrorExpectedTags([$1]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
    }
    if (!state.ok) {
      state.backtrack($0);
    }
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
    state.ok = true;
  }

  /// AstNode
  /// Boolean =
  ///     'true' Spaces {}
  ///   / 'false' Spaces {}
  ///   ;
  AstNode? parseBoolean(State<String> state) {
    AstNode? $0;
    // 'true' Spaces {}
    final $1 = state.pos;
    const $2 = 'true';
    state.ok = state.pos + 3 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 116 &&
        state.input.codeUnitAt(state.pos + 1) == 114 &&
        state.input.codeUnitAt(state.pos + 2) == 117 &&
        state.input.codeUnitAt(state.pos + 3) == 101;
    state.ok ? state.pos += 4 : state.fail(const ErrorExpectedTags([$2]));
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        AstNode? $$;
        $$ = BooleanNode(true);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($1);
    }
    if (!state.ok && state.isRecoverable) {
      // 'false' Spaces {}
      final $3 = state.pos;
      const $4 = 'false';
      state.ok = state.pos + 4 < state.input.length &&
          state.input.codeUnitAt(state.pos) == 102 &&
          state.input.codeUnitAt(state.pos + 1) == 97 &&
          state.input.codeUnitAt(state.pos + 2) == 108 &&
          state.input.codeUnitAt(state.pos + 3) == 115 &&
          state.input.codeUnitAt(state.pos + 4) == 101;
      state.ok ? state.pos += 5 : state.fail(const ErrorExpectedTags([$4]));
      if (state.ok) {
        // Spaces
        fastParseSpaces(state);
        if (state.ok) {
          AstNode? $$;
          $$ = BooleanNode(false);
          $0 = $$;
        }
      }
      if (!state.ok) {
        state.backtrack($3);
      }
    }
    return $0;
  }

  /// AstNode
  /// Conditional =
  ///     e1:LogicalOr Question e2:Expression Colon e3:Expression {}
  ///   / LogicalOr
  ///   ;
  AstNode? parseConditional(State<String> state) {
    AstNode? $0;
    // e1:LogicalOr Question e2:Expression Colon e3:Expression {}
    final $4 = state.pos;
    AstNode? $1;
    // LogicalOr
    $1 = parseLogicalOr(state);
    if (state.ok) {
      // Question
      fastParseQuestion(state);
      if (state.ok) {
        AstNode? $2;
        // Expression
        $2 = parseExpression(state);
        if (state.ok) {
          // Colon
          fastParseColon(state);
          if (state.ok) {
            AstNode? $3;
            // Expression
            $3 = parseExpression(state);
            if (state.ok) {
              AstNode? $$;
              final e1 = $1!;
              final e2 = $2!;
              final e3 = $3!;
              $$ = TernaryNode(e1, e2, e3);
              $0 = $$;
            }
          }
        }
      }
    }
    if (!state.ok) {
      state.backtrack($4);
    }
    if (!state.ok && state.isRecoverable) {
      // LogicalOr
      // LogicalOr
      $0 = parseLogicalOr(state);
    }
    return $0;
  }

  /// AstNode
  /// Equality =
  ///   h:Relational t:(op:EqualityOp expr:Relational)* {}
  ///   ;
  AstNode? parseEquality(State<String> state) {
    AstNode? $0;
    // h:Relational t:(op:EqualityOp expr:Relational)* {}
    final $3 = state.pos;
    AstNode? $1;
    // Relational
    $1 = parseRelational(state);
    if (state.ok) {
      List<({String op, AstNode expr})>? $2;
      final $4 = <({String op, AstNode expr})>[];
      while (true) {
        ({String op, AstNode expr})? $5;
        // op:EqualityOp expr:Relational
        final $8 = state.pos;
        String? $6;
        // EqualityOp
        $6 = parseEqualityOp(state);
        if (state.ok) {
          AstNode? $7;
          // Relational
          $7 = parseRelational(state);
          if (state.ok) {
            $5 = (op: $6!, expr: $7!);
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        AstNode? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _binary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// EqualityOp =
  ///   v:@expected('operator' ,'==' / '!=') Spaces
  ///   ;
  String? parseEqualityOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'==' / '!=') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $11 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    final $10 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.codeUnitAt(state.pos);
      state.pos++;
      switch ($6) {
        case 61:
          state.ok = state.pos < $7.length && $7.codeUnitAt(state.pos) == 61;
          if (state.ok) {
            state.pos++;
            $1 = '==';
          }
          break;
        case 33:
          state.ok = state.pos < $7.length && $7.codeUnitAt(state.pos) == 61;
          if (state.ok) {
            state.pos++;
            $1 = '!=';
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $10;
      state.fail(const ErrorExpectedTags(['==', '!=']));
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $11) {
      state.lastFailPos = $11;
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

  /// Expression =
  ///   Conditional
  ///   ;
  AstNode? parseExpression(State<String> state) {
    AstNode? $0;
    // Conditional
    // Conditional
    $0 = parseConditional(state);
    return $0;
  }

  /// AstNode
  /// Group =
  ///   OpenParenthesis v:Expression CloseParenthesis {}
  ///   ;
  AstNode? parseGroup(State<String> state) {
    AstNode? $0;
    // OpenParenthesis v:Expression CloseParenthesis {}
    final $2 = state.pos;
    // OpenParenthesis
    fastParseOpenParenthesis(state);
    if (state.ok) {
      AstNode? $1;
      // Expression
      $1 = parseExpression(state);
      if (state.ok) {
        // CloseParenthesis
        fastParseCloseParenthesis(state);
        if (state.ok) {
          AstNode? $$;
          final v = $1!;
          $$ = GroupNode(v);
          $0 = $$;
        }
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// AstNode
  /// Identifier =
  ///   v:@expected('identifier' ,Identifier_) Spaces {}
  ///   ;
  AstNode? parseIdentifier(State<String> state) {
    AstNode? $0;
    // v:@expected('identifier' ,Identifier_) Spaces {}
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $7 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // Identifier_
    // Identifier_
    $1 = parseIdentifier_(state);
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['identifier']));
    }
    if (state.lastFailPos < $7) {
      state.lastFailPos = $7;
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        AstNode? $$;
        final v = $1!;
        $$ = IdentifierNode(v);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Identifier_ =
  ///   $([_a-zA-Z$] [_a-zA-Z$0-9]*)
  ///   ;
  String? parseIdentifier_(State<String> state) {
    String? $0;
    // $([_a-zA-Z$] [_a-zA-Z$0-9]*)
    final $2 = state.pos;
    // [_a-zA-Z$] [_a-zA-Z$0-9]*
    final $3 = state.pos;
    state.ok = state.pos < state.input.length;
    if (state.ok) {
      final $4 = state.input.codeUnitAt(state.pos);
      state.ok =
          $4 < 65 ? $4 == 36 : $4 <= 90 || $4 == 95 || $4 >= 97 && $4 <= 122;
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
              (c < 65
                  ? c == 36 || c >= 48 && c <= 57
                  : c <= 90 || c == 95 || c >= 97 && c <= 122);
          // ignore: curly_braces_in_flow_control_structures, empty_statements
          state.pos++);
      state.ok = true;
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// AstNode
  /// LogicalAnd =
  ///   h:Equality t:(op:LogicalAndOp expr:Equality)* {}
  ///   ;
  AstNode? parseLogicalAnd(State<String> state) {
    AstNode? $0;
    // h:Equality t:(op:LogicalAndOp expr:Equality)* {}
    final $3 = state.pos;
    AstNode? $1;
    // Equality
    $1 = parseEquality(state);
    if (state.ok) {
      List<({String op, AstNode expr})>? $2;
      final $4 = <({String op, AstNode expr})>[];
      while (true) {
        ({String op, AstNode expr})? $5;
        // op:LogicalAndOp expr:Equality
        final $8 = state.pos;
        String? $6;
        // LogicalAndOp
        $6 = parseLogicalAndOp(state);
        if (state.ok) {
          AstNode? $7;
          // Equality
          $7 = parseEquality(state);
          if (state.ok) {
            $5 = (op: $6!, expr: $7!);
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        AstNode? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _binary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// LogicalAndOp =
  ///   v:@expected('operator' ,'&&') Spaces
  ///   ;
  String? parseLogicalAndOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'&&') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $8 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // '&&'
    const $7 = '&&';
    state.ok = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 38 &&
        state.input.codeUnitAt(state.pos + 1) == 38;
    if (state.ok) {
      $1 = $7;
      state.pos += 2;
    } else {
      state.fail(const ErrorExpectedTags([$7]));
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $8) {
      state.lastFailPos = $8;
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

  /// AstNode
  /// LogicalOr =
  ///   h:LogicalAnd t:(op:LogicalOrOp expr:LogicalAnd)* {}
  ///   ;
  AstNode? parseLogicalOr(State<String> state) {
    AstNode? $0;
    // h:LogicalAnd t:(op:LogicalOrOp expr:LogicalAnd)* {}
    final $3 = state.pos;
    AstNode? $1;
    // LogicalAnd
    $1 = parseLogicalAnd(state);
    if (state.ok) {
      List<({String op, AstNode expr})>? $2;
      final $4 = <({String op, AstNode expr})>[];
      while (true) {
        ({String op, AstNode expr})? $5;
        // op:LogicalOrOp expr:LogicalAnd
        final $8 = state.pos;
        String? $6;
        // LogicalOrOp
        $6 = parseLogicalOrOp(state);
        if (state.ok) {
          AstNode? $7;
          // LogicalAnd
          $7 = parseLogicalAnd(state);
          if (state.ok) {
            $5 = (op: $6!, expr: $7!);
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        AstNode? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _binary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// LogicalOrOp =
  ///   v:@expected('operator' ,'||') Spaces
  ///   ;
  String? parseLogicalOrOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'||') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $8 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // '||'
    const $7 = '||';
    state.ok = state.pos + 1 < state.input.length &&
        state.input.codeUnitAt(state.pos) == 124 &&
        state.input.codeUnitAt(state.pos + 1) == 124;
    if (state.ok) {
      $1 = $7;
      state.pos += 2;
    } else {
      state.fail(const ErrorExpectedTags([$7]));
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $8) {
      state.lastFailPos = $8;
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

  /// AstNode
  /// Number =
  ///   v:@expected('number' ,Number_) Spaces {}
  ///   ;
  AstNode? parseNumber(State<String> state) {
    AstNode? $0;
    // v:@expected('number' ,Number_) Spaces {}
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $7 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    // Number_
    // Number_
    $1 = parseNumber_(state);
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['number']));
    }
    if (state.lastFailPos < $7) {
      state.lastFailPos = $7;
    }
    if (state.ok) {
      // Spaces
      fastParseSpaces(state);
      if (state.ok) {
        AstNode? $$;
        final v = $1!;
        $$ = NumericNode(int.parse(v));
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($2);
    }
    return $0;
  }

  /// Number_ =
  ///   $([0] / ([-])? [1-9] [0-9]*)
  ///   ;
  String? parseNumber_(State<String> state) {
    String? $0;
    // $([0] / ([-])? [1-9] [0-9]*)
    final $2 = state.pos;
    // [0]
    state.ok = state.pos < state.input.length &&
        state.input.codeUnitAt(state.pos) == 48;
    if (state.ok) {
      state.pos++;
    } else {
      state.fail(const ErrorUnexpectedCharacter());
    }
    if (!state.ok && state.isRecoverable) {
      // ([-])? [1-9] [0-9]*
      final $4 = state.pos;
      // [-]
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
        state.ok = state.pos < state.input.length;
        if (state.ok) {
          final $6 = state.input.codeUnitAt(state.pos);
          state.ok = $6 >= 49 && $6 <= 57;
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
      }
      if (!state.ok) {
        state.backtrack($4);
      }
    }
    if (state.ok) {
      $0 = state.input.substring($2, state.pos);
    }
    return $0;
  }

  /// Primary =
  ///     Number
  ///   / Boolean
  ///   / Identifier
  ///   / Group
  ///   ;
  AstNode? parsePrimary(State<String> state) {
    AstNode? $0;
    // Number
    // Number
    $0 = parseNumber(state);
    if (!state.ok && state.isRecoverable) {
      // Boolean
      // Boolean
      $0 = parseBoolean(state);
      if (!state.ok && state.isRecoverable) {
        // Identifier
        // Identifier
        $0 = parseIdentifier(state);
        if (!state.ok && state.isRecoverable) {
          // Group
          // Group
          $0 = parseGroup(state);
        }
      }
    }
    return $0;
  }

  /// AstNode
  /// Relational =
  ///   h:Primary t:(op:RelationalOp expr:Primary)* {}
  ///   ;
  AstNode? parseRelational(State<String> state) {
    AstNode? $0;
    // h:Primary t:(op:RelationalOp expr:Primary)* {}
    final $3 = state.pos;
    AstNode? $1;
    // Primary
    $1 = parsePrimary(state);
    if (state.ok) {
      List<({String op, AstNode expr})>? $2;
      final $4 = <({String op, AstNode expr})>[];
      while (true) {
        ({String op, AstNode expr})? $5;
        // op:RelationalOp expr:Primary
        final $8 = state.pos;
        String? $6;
        // RelationalOp
        $6 = parseRelationalOp(state);
        if (state.ok) {
          AstNode? $7;
          // Primary
          $7 = parsePrimary(state);
          if (state.ok) {
            $5 = (op: $6!, expr: $7!);
          }
        }
        if (!state.ok) {
          state.backtrack($8);
        }
        if (!state.ok) {
          break;
        }
        $4.add($5!);
      }
      state.setOk(true);
      if (state.ok) {
        $2 = $4;
      }
      if (state.ok) {
        AstNode? $$;
        final h = $1!;
        final t = $2!;
        $$ = t.isEmpty ? h : t.fold(h, _binary);
        $0 = $$;
      }
    }
    if (!state.ok) {
      state.backtrack($3);
    }
    return $0;
  }

  /// RelationalOp =
  ///   v:@expected('operator' ,'>=' / '>' / '<=' / '<') Spaces
  ///   ;
  String? parseRelationalOp(State<String> state) {
    String? $0;
    // v:@expected('operator' ,'>=' / '>' / '<=' / '<') Spaces
    final $2 = state.pos;
    String? $1;
    final $3 = state.pos;
    final $13 = state.lastFailPos;
    final $5 = state.errorCount;
    state.lastFailPos = -1;
    final $12 = state.pos;
    state.ok = false;
    final $7 = state.input;
    if (state.pos < $7.length) {
      final $6 = $7.codeUnitAt(state.pos);
      state.pos++;
      switch ($6) {
        case 62:
          state.ok = state.pos < $7.length && $7.codeUnitAt(state.pos) == 61;
          if (state.ok) {
            state.pos++;
            $1 = '>=';
          } else {
            state.ok = true;
            $1 = '>';
          }
          break;
        case 60:
          state.ok = state.pos < $7.length && $7.codeUnitAt(state.pos) == 61;
          if (state.ok) {
            state.pos++;
            $1 = '<=';
          } else {
            state.ok = true;
            $1 = '<';
          }
          break;
      }
    }
    if (!state.ok) {
      state.pos = $12;
      state.fail(const ErrorExpectedTags(['>=', '>', '<=', '<']));
    }
    if (!state.ok &&
        state.lastFailPos >= state.failPos &&
        state.lastFailPos == $3) {
      state.errorCount = $5;
      state.fail(const ErrorExpectedTags(['operator']));
    }
    if (state.lastFailPos < $13) {
      state.lastFailPos = $13;
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

  /// Start =
  ///   Spaces v:Expression @eof()
  ///   ;
  AstNode? parseStart(State<String> state) {
    AstNode? $0;
    // Spaces v:Expression @eof()
    final $2 = state.pos;
    // Spaces
    fastParseSpaces(state);
    if (state.ok) {
      AstNode? $1;
      // Expression
      $1 = parseExpression(state);
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

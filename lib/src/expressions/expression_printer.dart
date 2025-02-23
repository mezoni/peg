import '../helper.dart';
import 'expressions.dart';

class ExpressionPrinter implements ExpressionVisitor<void> {
  final _buffer = StringBuffer();

  String print(Expression expression) {
    expression.accept(this);
    return '$_buffer';
  }

  @override
  void visitAction(ActionExpression node) {
    _buffer.write('{ }');
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _buffer.write('&');
    node.visitChildren(this);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _buffer.write('.');
  }

  @override
  void visitCatch(CatchExpression node) {
    node.visitChildren(this);
    final parameters = node.parameters.map((e) {
      final name = e.$1;
      final value = e.$2;
      switch (name) {
        case 'message':
          final escaped = escapeString(value);
          return '$name = $escaped';
        case 'origin':
          return '$name $value';
        default:
          return '$name = $value';
      }
    }).join(' ');
    _buffer.write(' ~ { $parameters }');
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    final negate = node.negate;
    negate ? _buffer.write('[^') : _buffer.write('[');
    final ranges = node.ranges;
    String escape(int char) {
      return switch (char) {
        0x07 => r'\a',
        0x08 => r'\b',
        0x1B => r'\e',
        0x0C => r'\f',
        0x0A => r'\n',
        0x0D => r'\r',
        0x09 => r'\t',
        0x0B => r'\v',
        0x2D => r'\-',
        0x5B => r'\[',
        0x5C => r'\\',
        0x5D => r'\]',
        0x5E => r'\^',
        0x7B => r'\{',
        0x7D => r'\}',
        _ => String.fromCharCode(char),
      };
    }

    String hex(int char) {
      return char.toRadixString(16);
    }

    for (var i = 0; i < ranges.length; i++) {
      final range = ranges[i];
      final start = range.$1;
      final end = range.$2;
      if (start >= 32 && end < 127) {
        if (start == end) {
          _buffer.write(escape(start));
        } else {
          _buffer.write('${escape(start)}-${escape(end)}');
        }
      } else {
        if (start == end) {
          _buffer.write('{${hex(start)}}');
        } else {
          _buffer.write('{${hex(start)}-${hex(end)}}');
        }
      }
    }

    _buffer.write(']');
  }

  @override
  void visitExpected(ExpectedExpression node) {
    final name = node.name;
    final escapedName = escapeString(name, "'");
    _buffer.write('@expected($escapedName) { ');
    node.visitChildren(this);
    _buffer.write(' }');
  }

  @override
  void visitGroup(GroupExpression node) {
    _buffer.write('(');
    node.visitChildren(this);
    _buffer.write(')');
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final literal = node.literal;
    final silent = node.silent;
    final quote = silent ? '"' : '\'';
    final escaped = escapeString(literal, quote);
    _buffer.write(escaped);
  }

  @override
  void visitMatch(MatchExpression node) {
    _buffer.write('<');
    node.visitChildren(this);
    _buffer.write('>');
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    final name = node.name;
    _buffer.write(name);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _buffer.write('!');
    node.visitChildren(this);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    _buffer.write('+');
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    _buffer.write('?');
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final expressions = node.expressions;
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(this);
      if (i < expressions.length - 1) {
        _buffer.write(' / ');
      }
    }
  }

  @override
  void visitPredicate(PredicateExpression node) {
    final negate = node.negate;
    _buffer.write(negate ? '!' : '&');
    _buffer.write('{ }');
    node.visitChildren(this);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final expressions = node.expressions;
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(this);
      if (i < expressions.length - 1) {
        _buffer.write(' ');
      }
    }
  }

  @override
  void visitTyping(TypingExpression node) {
    final type = node.type;
    _buffer.write('`$type` ');
    node.visitChildren(this);
  }

  @override
  void visitVariable(VariableExpression node) {
    final name = node.name;
    _buffer.write('$name = ');
    node.visitChildren(this);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    _buffer.write('*');
  }
}

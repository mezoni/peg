import '../helper.dart' as helper;
import 'expressions.dart';

class ExpressionPrinter implements ExpressionVisitor<void> {
  final _buffer = StringBuffer();

  String print(Expression expression) {
    expression.accept(this);
    return '$_buffer';
  }

  @override
  void visitAction(ActionExpression node) {
    _beforeNode(node);
    _buffer.write('{ }');
    _afterNode(node);
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _beforeNode(node);
    _buffer.write('&');
    node.visitChildren(this);
    _afterNode(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _beforeNode(node);
    _buffer.write('.');
    _afterNode(node);
  }

  @override
  void visitCatch(CatchExpression node) {
    _beforeNode(node);
    node.visitChildren(this);
    _buffer.write(' ~ { }');
    _afterNode(node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _beforeNode(node);
    _buffer.write('[');
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
      if (end > 127) {
        if (start == end) {
          _buffer.write('{${hex(start)}}');
        } else {
          _buffer.write('{${hex(start)}-${hex(end)}}');
        }
      } else {
        if (start == end) {
          _buffer.write(escape(start));
        } else {
          _buffer.write('${escape(start)}-${escape(end)}');
        }
      }
    }

    _buffer.write(']');
    _afterNode(node);
  }

  @override
  void visitGroup(GroupExpression node) {
    _beforeNode(node);
    _buffer.write('(');
    node.visitChildren(this);
    _buffer.write(')');
    _afterNode(node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final literal = node.literal;
    final silent = node.silent;
    final quote = silent ? '"' : '\'';
    final escaped = helper.escapeString(literal, quote);
    _beforeNode(node);
    _buffer.write(escaped);
    _afterNode(node);
  }

  @override
  void visitMatch(MatchExpression node) {
    _beforeNode(node);
    _buffer.write('<');
    node.visitChildren(this);
    _buffer.write('>');
    _afterNode(node);
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    final name = node.name;
    _beforeNode(node);
    _buffer.write(name);
    _afterNode(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _beforeNode(node);
    _buffer.write('!');
    node.visitChildren(this);
    _afterNode(node);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _beforeNode(node);
    node.visitChildren(this);
    _buffer.write('+');
    _afterNode(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    _beforeNode(node);
    node.visitChildren(this);
    _buffer.write('?');
    _afterNode(node);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final expressions = node.expressions;
    _beforeNode(node);
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(this);
      if (i < expressions.length - 1) {
        _buffer.write(' / ');
      }
    }

    _afterNode(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final expressions = node.expressions;
    final errorHandler = node.errorHandler;
    _beforeNode(node);
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(this);
      if (i < expressions.length - 1) {
        _buffer.write(' ');
      }
    }
    if (errorHandler != null) {
      _buffer.write('~{ }');
    }

    _afterNode(node);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _beforeNode(node);
    node.visitChildren(this);
    _buffer.write('*');
    _afterNode(node);
  }

  void _afterNode(Expression node) {
    if (node.isGrouped) {
      _buffer.write(')');
    }
  }

  void _beforeNode(Expression node) {
    final variable = node.semanticVariable;
    if (variable != null) {
      // TODO
      _buffer.write('$variable = ');
      final type = node.semanticVariableType;
      if (type.isNotEmpty) {
        _buffer.write('`$type`');
      }
    }

    if (node.isGrouped) {
      _buffer.write('(');
    }
  }
}

import '../helper.dart';
import 'expressions.dart';

class ExpressionPrinter2 implements ExpressionVisitor<void> {
  final _buffer = StringBuffer();

  String _indent = '';

  final Map<Expression, bool> _multiline = {};

  final Map<Expression, int> _widths = {};

  String print(Expression expression) {
    final dimensionCollector = _DimensionCollector();
    final dimensions = dimensionCollector.collect(expression);
    _multiline.clear();
    _widths.clear();
    _multiline.addAll(dimensions.multiline);
    _widths.addAll(dimensions.widths);
    _indent = '';
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
  void visitGroup(GroupExpression node) {
    _surround(node, '(', ')');
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
    _surround(node, '<', '>');
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
    final child = node.expression;
    if (child is GroupExpression) {
      _buffer.write('@while (+) ');
      node.visitChildren(this);
    } else {
      node.visitChildren(this);
      _buffer.write('+');
    }
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    _buffer.write('?');
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final expressions = node.expressions;
    if (expressions.length == 1) {
      node.visitChildren(this);
    } else {
      for (var i = 0; i < expressions.length; i++) {
        final expression = expressions[i];
        expression.accept(this);
        if (i != expressions.length - 1) {
          _buffer.writeln();
          _buffer.write(_indent);
          _buffer.writeln('----');
        }
      }
    }
  }

  @override
  void visitPredicate(PredicateExpression node) {
    final negate = node.negate;
    final code = node.code;
    _buffer.write(negate ? '!' : '&');
    _buffer.write('{ ');
    _buffer.write(code);
    _buffer.write(' }');
    node.visitChildren(this);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    if (children.length == 1) {
      _buffer.write(_indent);
      node.visitChildren(this);
    } else {
      for (var i = 0; i < children.length; i++) {
        final expression = children[i];
        _buffer.write(_indent);
        expression.accept(this);
        if (i != children.length - 1) {
          _buffer.writeln();
        }
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
    final child = node.expression;
    if (child is GroupExpression) {
      _buffer.write('@while (*) ');
      node.visitChildren(this);
    } else {
      node.visitChildren(this);
      _buffer.write('*');
    }
  }

  void _surround(SingleExpression node, String open, String close) {
    final multiline = _multiline[node]!;
    if (!multiline) {
      _buffer.write(open);
      node.visitChildren(this);
      _buffer.write(close);
    } else {
      final indent = _indent;
      _buffer.writeln(open);
      _indent += '  ';
      node.visitChildren(this);
      _buffer.writeln();
      _indent = indent;
      _buffer.write(_indent);
      _buffer.write(close);
    }
  }
}

class _DimensionCollector extends ExpressionVisitor<void> {
  final Map<Expression, bool> _multiline = {};

  final Map<Expression, int> _widths = {};

  ({Map<Expression, bool> multiline, Map<Expression, int> widths}) collect(
      Expression expression) {
    _multiline.clear();
    _widths.clear();
    expression.accept(this);
    return (multiline: Map.of(_multiline), widths: Map.of(_widths));
  }

  @override
  void visitAction(ActionExpression node) {
    _init(node);
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _visitChild(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _init(node);
  }

  @override
  void visitCatch(CatchExpression node) {
    _visitChild(node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _init(node);
  }

  @override
  void visitGroup(GroupExpression node) {
    _visitChild(node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _init(node);
  }

  @override
  void visitMatch(MatchExpression node) {
    _visitChild(node);
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    _init(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _visitChild(node);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _visitChild(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    _visitChild(node);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    var multiline = false;
    var width = 0;
    final children = node.expressions;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      child.accept(this);
      width += _widths[child]!;
      if (_multiline[child]!) {
        multiline = true;
      }
    }

    if (!multiline) {
      multiline = children.length > 2;
    }

    _multiline[node] = multiline;
    _widths[node] = width;
  }

  @override
  void visitPredicate(PredicateExpression node) {
    _init(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    var multiline = false;
    var width = 0;
    final children = node.expressions;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      child.accept(this);
      width += _widths[child]!;
      if (_multiline[child]!) {
        multiline = true;
      }
    }

    if (!multiline) {
      multiline = children.length > 1;
    }

    _multiline[node] = multiline;
    _widths[node] = width;
  }

  @override
  void visitTyping(TypingExpression node) {
    _visitChild(node);
  }

  @override
  void visitVariable(VariableExpression node) {
    _visitChild(node);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _visitChild(node);
  }

  void _init(Expression node) {
    _multiline[node] = false;
    _widths[node] = 1;
  }

  void _visitChild(SingleExpression node) {
    final child = node.expression;
    child.accept(this);
    _multiline[node] = _multiline[child]!;
    _widths[node] = _widths[child]!;
  }
}

import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';

class StartingExpressionsResolver extends ExpressionVisitor<void> {
  bool _hasModifications = false;

  void resolve(List<ProductionRule> rules) {
    _hasModifications = true;
    while (_hasModifications) {
      _hasModifications = false;
      for (var rule in rules) {
        rule.expression.accept(this);
      }
    }
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitCut(CutExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitEof(EofExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitExpected(ExpectedExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitGroup(GroupExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitIndicate(IndicateExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitList(ListExpression node) {
    node.visitChildren(this);
    final first = node.first;
    final next = node.next;
    _processSequence(node, [first, next]);
  }

  @override
  void visitList1(List1Expression node) {
    node.visitChildren(this);
    final first = node.first;
    final next = node.next;
    _processSequence(node, [first, next]);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitMessage(MessageExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    node.visitChildren(this);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      _addChild(node, child);
    }
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    node.visitChildren(this);
    _processSequence(node, children);
  }

  @override
  void visitSlice(SliceExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    node.visitChildren(this);
    final normalCharacters = node.normalCharacters;
    final escapeCharacter = node.escapeCharacter;
    final escape = node.escape;
    _addChild(node, normalCharacters);
    _addChild(node, escapeCharacter);
    _processSequence(node, [escapeCharacter, escape]);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    _addChild(node, child);
  }

  @override
  void visitTag(TagExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitVerify(VerifyExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _addChild(node, child);
  }

  void _addChild(Expression node, Expression child) {
    _addStartingExpressions(node, [child, ...child.startingExpressions]);
  }

  void _addStartingExpressions(
      Expression node, Iterable<Expression> expressions) {
    final startingExpressions = node.startingExpressions;
    for (final element in expressions) {
      if (startingExpressions.add(element)) {
        _hasModifications = true;
      }
    }
  }

  void _processSequence(Expression node, List<Expression> children) {
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      _addChild(node, child);
      if (!child.mayNotConsumeInput) {
        break;
      }
    }
  }
}

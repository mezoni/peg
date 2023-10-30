import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';

class OptionalExpressionsResolver extends ExpressionVisitor<void> {
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
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, false);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, false);
  }

  @override
  void visitCut(CutExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitEof(EofExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitExpected(ExpectedExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitGroup(GroupExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitIndicate(IndicateExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitList(ListExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitList1(List1Expression node) {
    node.visitChildren(this);
    final first = node.first;
    _setIgnoreErrors(node, first.ignoreErrors);
    _setMayNotConsumeInput(node, first.mayNotConsumeInput);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final string = node.string;
    final isEmpty = string.isEmpty;
    node.visitChildren(this);
    _setIgnoreErrors(node, isEmpty);
    _setMayNotConsumeInput(node, isEmpty);
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitMessage(MessageExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    node.visitChildren(this);
    final ignoreErrors = children.any((e) => e.ignoreErrors);
    final mayNotConsumeInput = children.any((e) => e.mayNotConsumeInput);
    _setIgnoreErrors(node, ignoreErrors);
    _setMayNotConsumeInput(node, mayNotConsumeInput);
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    final ignoreErrors = node.min == 0 || node.max == 0 || child.ignoreErrors;
    _setIgnoreErrors(node, ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput || ignoreErrors);
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
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitTag(TagExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitVerify(VerifyExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIgnoreErrors(node, child.ignoreErrors);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    _setIgnoreErrors(node, true);
    _setMayNotConsumeInput(node, true);
  }

  void _processSequence(Expression node, List<Expression> children) {
    final length = children.length;
    final ignoreErrors = children.where((e) => e.ignoreErrors).length == length;
    final mayNotConsumeInput =
        children.where((e) => e.mayNotConsumeInput).length == length;
    _setIgnoreErrors(node, ignoreErrors);
    _setMayNotConsumeInput(node, mayNotConsumeInput);
  }

  void _setIgnoreErrors(Expression node, bool ignoreErrors) {
    if (ignoreErrors) {
      if (node.ignoreErrors != ignoreErrors) {
        _hasModifications = true;
        node.ignoreErrors = ignoreErrors;
      }
    }
  }

  void _setMayNotConsumeInput(Expression node, bool mayNotConsumeInput) {
    if (mayNotConsumeInput) {
      if (node.mayNotConsumeInput != mayNotConsumeInput) {
        _hasModifications = true;
        node.mayNotConsumeInput = mayNotConsumeInput;
      }
    }
  }
}

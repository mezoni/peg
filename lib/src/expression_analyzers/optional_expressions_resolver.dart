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
    _setIsOptional(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, false);
    _setMayNotConsumeInput(node, false);
  }

  @override
  void visitBuffer(BufferExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, false);
    _setMayNotConsumeInput(node, false);
  }

  @override
  void visitCut(CutExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitGroup(GroupExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final string = node.string;
    final isEmpty = string.isEmpty;
    node.visitChildren(this);
    _setIsOptional(node, isEmpty);
    _setMayNotConsumeInput(node, isEmpty);
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, false);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    node.visitChildren(this);
    final isOptional = children.any((e) => e.isOptional);
    final mayNotConsumeInput = children.any((e) => e.mayNotConsumeInput);
    _setIsOptional(node, isOptional);
    _setMayNotConsumeInput(node, mayNotConsumeInput);
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    final isOptional = node.min == 0 || node.max == 0 || child.isOptional;
    _setIsOptional(node, isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput || isOptional);
  }

  @override
  void visitSepBy(SepByExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitSepBy1(SepBy1Expression node) {
    node.visitChildren(this);
    final expression = node.expression;
    _setIsOptional(node, expression.isOptional);
    _setMayNotConsumeInput(node, expression.mayNotConsumeInput);
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
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
    _setMayNotConsumeInput(node, true);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitVerify(VerifyExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
    _setMayNotConsumeInput(node, child.mayNotConsumeInput);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
    _setMayNotConsumeInput(node, true);
  }

  void _processSequence(Expression node, List<Expression> children) {
    final length = children.length;
    final isOptional = children.where((e) => e.isOptional).length == length;
    final mayNotConsumeInput =
        children.where((e) => e.mayNotConsumeInput).length == length;
    _setIsOptional(node, isOptional);
    _setMayNotConsumeInput(node, mayNotConsumeInput);
  }

  void _setIsOptional(Expression node, bool isOptional) {
    if (isOptional) {
      if (node.isOptional != isOptional) {
        _hasModifications = true;
        node.isOptional = isOptional;
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

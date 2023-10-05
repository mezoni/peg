import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';

class OptionalExpressionResolver extends ExpressionVisitor<void> {
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
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitBuffer(BufferExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitGroup(GroupExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, false);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    node.visitChildren(this);
    final isOptional = children.where((e) => e.isOptional).isNotEmpty;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    final isOptional = node.min == 0 || node.max == 0 || child.isOptional;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitSepBy(SepByExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    final length = children.length;
    node.visitChildren(this);
    final isOptional = children.where((e) => e.isOptional).length == length;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitSlice(SliceExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitVerify(VerifyExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    _setIsOptional(node, true);
  }

  void _setIsOptional(Expression node, bool isOptional) {
    if (isOptional) {
      if (node.isOptional != isOptional) {
        _hasModifications = true;
        node.isOptional = isOptional;
      }
    }
  }
}

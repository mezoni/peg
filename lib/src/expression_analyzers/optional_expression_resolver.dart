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
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, false);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitGroup(GroupExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _setIsOptional(node, false);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, false);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitOptional(OptionalExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, true);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
    }

    final isOptional = expressions.where((e) => e.isOptional).isNotEmpty;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    final child = node.expression;
    child.accept(this);
    final isOptional = node.min == 0 || node.max == 0 || child.isOptional;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final expressions = node.expressions;
    final length = expressions.length;
    for (var i = 0; i < length; i++) {
      final child = expressions[i];
      child.accept(this);
    }

    final isOptional = expressions.where((e) => e.isOptional).length == length;
    _setIsOptional(node, isOptional);
  }

  @override
  void visitSlice(SliceExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitVerify(VerifyExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsOptional(node, child.isOptional);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    final child = node.expression;
    child.accept(this);
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

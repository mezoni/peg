import '../expressions/expressions.dart';

export '../expressions/expressions.dart';

abstract class ExpressionVisitor<T> {
  T visitAction(ActionExpression node);

  T visitAndPredicate(AndPredicateExpression node);

  T visitAnyCharacter(AnyCharacterExpression node);

  T visitCatch(CatchExpression node);

  T visitCharacterClass(CharacterClassExpression node);

  T visitGroup(GroupExpression node);

  T visitLiteral(LiteralExpression node);

  T visitMatch(MatchExpression node);

  T visitNonterminal(NonterminalExpression node);

  T visitNotPredicate(NotPredicateExpression node);

  T visitOneOrMore(OneOrMoreExpression node);

  T visitOptional(OptionalExpression node);

  T visitOrderedChoice(OrderedChoiceExpression node);

  T visitPredicate(PredicateExpression node);

  T visitSequence(SequenceExpression node);

  T visitTyping(TypingExpression node);

  T visitVariable(VariableExpression node);

  T visitZeroOrMore(ZeroOrMoreExpression node);
}

mixin ExpressionVisitorMixin<T> implements ExpressionVisitor<T> {
  @override
  T visitAction(ActionExpression node) {
    return visitNode(node);
  }

  @override
  T visitAndPredicate(AndPredicateExpression node) {
    return visitNode(node);
  }

  @override
  T visitAnyCharacter(AnyCharacterExpression node) {
    return visitNode(node);
  }

  @override
  T visitCatch(CatchExpression node) {
    return visitNode(node);
  }

  @override
  T visitCharacterClass(CharacterClassExpression node) {
    return visitNode(node);
  }

  @override
  T visitGroup(GroupExpression node) {
    return visitNode(node);
  }

  @override
  T visitLiteral(LiteralExpression node) {
    return visitNode(node);
  }

  @override
  T visitMatch(MatchExpression node) {
    return visitNode(node);
  }

  T visitNode(Expression node);

  @override
  T visitNonterminal(NonterminalExpression node) {
    return visitNode(node);
  }

  @override
  T visitNotPredicate(NotPredicateExpression node) {
    return visitNode(node);
  }

  @override
  T visitOneOrMore(OneOrMoreExpression node) {
    return visitNode(node);
  }

  @override
  T visitOptional(OptionalExpression node) {
    return visitNode(node);
  }

  @override
  T visitOrderedChoice(OrderedChoiceExpression node) {
    return visitNode(node);
  }

  @override
  T visitPredicate(PredicateExpression node) {
    return visitNode(node);
  }

  @override
  T visitSequence(SequenceExpression node) {
    return visitNode(node);
  }

  @override
  T visitTyping(TypingExpression node) {
    return visitNode(node);
  }

  @override
  T visitVariable(VariableExpression node) {
    return visitNode(node);
  }

  @override
  T visitZeroOrMore(ZeroOrMoreExpression node) {
    return visitNode(node);
  }
}

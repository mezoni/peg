import '../expressions/expressions.dart';

export '../expressions/expressions.dart';

abstract class ExpressionVisitor<T> {
  T visitAndPredicate(AndPredicateExpression node);

  T visitAnyCharacter(AnyCharacterExpression node);

  T visitCharacterClass(CharacterClassExpression node);

  T visitErrorHandler(ErrorHandlerExpression node);

  T visitGroup(GroupExpression node);

  T visitLiteral(LiteralExpression node);

  T visitMatchString(MatchStringExpression node);

  T visitNotPredicate(NotPredicateExpression node);

  T visitOneOrMore(OneOrMoreExpression node);

  T visitOptional(OptionalExpression node);

  T visitOrderedChoice(OrderedChoiceExpression node);

  T visitRepetition(RepetitionExpression node);

  T visitSepBy(SepByExpression node);

  T visitSequence(SequenceExpression node);

  T visitSlice(SliceExpression node);

  T visitStringChars(StringCharsExpression node);

  T visitSymbol(SymbolExpression node);

  T visitVerify(VerifyExpression node);

  T visitZeroOrMore(ZeroOrMoreExpression node);
}

mixin ExpressionVisitorMixin<T> implements ExpressionVisitor<T> {
  @override
  T visitAndPredicate(AndPredicateExpression node) {
    return visitNode(node);
  }

  @override
  T visitAnyCharacter(AnyCharacterExpression node) {
    return visitNode(node);
  }

  @override
  T visitCharacterClass(CharacterClassExpression node) {
    return visitNode(node);
  }

  @override
  T visitErrorHandler(ErrorHandlerExpression node) {
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
  T visitMatchString(MatchStringExpression node) {
    return visitNode(node);
  }

  T visitNode(Expression node);

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
  T visitRepetition(RepetitionExpression node) {
    return visitNode(node);
  }

  @override
  T visitSepBy(SepByExpression node) {
    return visitNode(node);
  }

  @override
  T visitSequence(SequenceExpression node) {
    return visitNode(node);
  }

  @override
  T visitSlice(SliceExpression node) {
    return visitNode(node);
  }

  @override
  T visitStringChars(StringCharsExpression node) {
    return visitNode(node);
  }

  @override
  T visitSymbol(SymbolExpression node) {
    return visitNode(node);
  }

  @override
  T visitVerify(VerifyExpression node) {
    return visitNode(node);
  }

  @override
  T visitZeroOrMore(ZeroOrMoreExpression node) {
    return visitNode(node);
  }
}

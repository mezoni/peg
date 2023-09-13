import '../expressions/expressions.dart';
import '../grammar/grammar.dart';

class ExpressionOptimizer extends ExpressionVisitor<Expression> {
  void optimize(List<ProductionRule> rules) {
    for (var i = 0; i < rules.length; i++) {
      final rule = rules[i];
      final expression = rule.expression;
      expression.accept(this);
      //final newExpression = expression.accept(this);
      //rule.expression = newExpression as OrderedChoiceExpression;
    }
  }

  @override
  Expression visitAndPredicate(AndPredicateExpression node) {
    final child = _visitChild(node);
    final result = AndPredicateExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitAnyCharacter(AnyCharacterExpression node) {
    final result = AnyCharacterExpression();
    return _initialize(node, result);
  }

  @override
  Expression visitCharacterClass(CharacterClassExpression node) {
    final negate = node.negate;
    final ranges = node.ranges;
    final result = CharacterClassExpression(
      negate: negate,
      ranges: ranges,
    );
    return _initialize(node, result);
  }

  @override
  Expression visitErrorHandler(ErrorHandlerExpression node) {
    final handler = node.handler;
    final child = _visitChild(node);
    final result = ErrorHandlerExpression(
      expression: child,
      handler: handler,
    );
    return _initialize(node, result);
  }

  @override
  Expression visitGroup(GroupExpression node) {
    final child = _visitChild(node);
    final result = GroupExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitLiteral(LiteralExpression node) {
    final caseSensitive = node.caseSensitive;
    final string = node.string;
    final result =
        LiteralExpression(caseSensitive: caseSensitive, string: string);
    return _initialize(node, result);
  }

  @override
  Expression visitNotPredicate(NotPredicateExpression node) {
    final child = _visitChild(node);
    if (child is AnyCharacterExpression) {
      // Eof
    }

    final result = NotPredicateExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitOneOrMore(OneOrMoreExpression node) {
    final child = _visitChild(node);
    if (child is CharacterClassExpression) {
      // Skip1While or Take1While
    }

    final result = OneOrMoreExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitOptional(OptionalExpression node) {
    final child = _visitChild(node);
    final result = OptionalExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitOrderedChoice(OrderedChoiceExpression node) {
    final children = <Expression>[];
    for (final expression in node.expressions) {
      final child = expression.accept(this);
      children.add(child);
    }

    final result = OrderedChoiceExpression(expressions: children);
    return _initialize(node, result);
  }

  @override
  Expression visitRepetition(RepetitionExpression node) {
    final child = _visitChild(node);
    final max = node.max;
    final min = node.min;
    final result = RepetitionExpression(expression: child, max: max, min: min);
    return _initialize(node, result);
  }

  @override
  Expression visitSequence(SequenceExpression node) {
    final children = <Expression>[];
    for (final expression in node.expressions) {
      final child = expression.accept(this);
      children.add(child);
    }

    final action = node.action;
    final result = SequenceExpression(
      action: action,
      expressions: children,
    );
    return _initialize(node, result);
  }

  @override
  Expression visitSlice(SliceExpression node) {
    final child = _visitChild(node);
    final result = SliceExpression(expression: child);
    return _initialize(node, result);
  }

  @override
  Expression visitSymbol(SymbolExpression node) {
    final name = node.name;
    final reference = node.reference;
    final result = SymbolExpression(
      name: name,
      reference: reference,
    );
    return _initialize(node, result);
  }

  @override
  Expression visitZeroOrMore(ZeroOrMoreExpression node) {
    final child = _visitChild(node);
    if (child is CharacterClassExpression) {
      // SkipWhile or TakeWhile
    }

    final result = ZeroOrMoreExpression(expression: child);
    return _initialize(node, result);
  }

  Expression _initialize(Expression oldNode, Expression newNode) {
    newNode.semanticVariable = oldNode.semanticVariable;
    return newNode;
  }

  Expression _visitChild(SingleExpression parent) {
    final child = parent.expression;
    child.accept(this);
    return child;
  }
}

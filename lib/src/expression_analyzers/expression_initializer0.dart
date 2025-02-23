import '../grammar/grammar.dart';
import '../grammar/production_rule.dart';
import '../parser_generator_diagnostics.dart';

class ExpressionInitializer0 extends ExpressionVisitor<void> {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  Expression? _current;

  int _id = 0;

  int _level = 0;

  late ProductionRule _rule;

  final Map<String, ProductionRule> _rules = {};

  ExpressionInitializer0({
    required this.grammar,
    required this.diagnostics,
  });

  void initialize() {
    _rules.clear();
    final rules = grammar.rules;
    for (var rule in rules) {
      _rules[rule.name] = rule;
    }

    _id = 0;
    for (var rule in rules) {
      _level = 0;
      _current = null;
      _rule = rule;
      final expression = rule.expression;
      expression.isLast = true;
      expression.accept(this);
    }
  }

  @override
  void visitAction(ActionExpression node) {
    _initializeNode(node);
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _initializeNode(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _initializeNode(node);
  }

  @override
  void visitCatch(CatchExpression node) {
    _initializeNode(node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _initializeNode(node);
  }

  @override
  void visitExpected(ExpectedExpression node) {
    _initializeNode(node);
  }

  @override
  void visitGroup(GroupExpression node) {
    _initializeNode(node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _initializeNode(node);
  }

  @override
  void visitMatch(MatchExpression node) {
    _initializeNode(node);
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    final name = node.name;
    final rule = _rules[name];
    node.reference = rule;
    _initializeNonterminal(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _initializeNode(node);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _initializeNode(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    _initializeNode(node);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    _initializeNode(node);
  }

  @override
  void visitPredicate(PredicateExpression node) {
    _initializeNode(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    _initializeNode(node);
  }

  @override
  void visitTyping(TypingExpression node) {
    _initializeNode(node);
  }

  @override
  void visitVariable(VariableExpression node) {
    _initializeNode(node);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _initializeNode(node);
  }

  void _assignId(Expression node) {
    node.id ??= _id++;
  }

  void _initializeNode(Expression node) {
    final current = _current;
    _assignId(node);
    node.parent = current;
    _current = node;
    if (node case final SingleExpression node) {
      final child = node.expression;
      child.isLast = true;
    } else if (node case final MultiExpression node) {
      final last = node.expressions.last;
      last.isLast = true;
    }

    node.index ??= 0;
    node.rule = _rule;
    node.level = _level;
    final level = _level;
    _level++;
    node.visitChildren(this);
    _level = level;
    _current = current;
    node.resultType = node.resultType.trim();
  }

  void _initializeNonterminal(NonterminalExpression node) {
    _initializeNode(node);
    final name = node.name;
    final reference = _rules[name];
    if (reference == null) {
      final rule = node.rule!;
      final error = diagnostics.error(
          "The expression 'Nonterminal' refers to an undefined production rule");
      error.description('Referenced rule name', name);
      error.description('Production rule name', rule.name);
      return;
    }

    node.reference = reference;
  }
}

import '../expressions/expressions.dart';
import '../grammar/grammar.dart';

class ExpressionInitializer0 extends ExpressionVisitor<void> {
  final List<String> errors = [];

  Expression? _current;

  int _id = 0;

  int _level = 0;

  late ProductionRule _rule;

  final Map<String, ProductionRule> _rules = {};

  void initialize(Grammar grammar) {
    errors.clear();
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
  void visitAndPredicate(AndPredicateExpression node) {
    _initializeNode(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _initializeNode(node);
  }

  @override
  void visitBuffer(BufferExpression node) {
    _initializeNode(node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _initializeNode(node);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
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
  void visitMatchString(MatchStringExpression node) {
    _initializeNode(node);
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
  void visitRepetition(RepetitionExpression node) {
    _initializeNode(node);
  }

  @override
  void visitSepBy(SepByExpression node) {
    _initializeNode(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    _initializeNode(node);
  }

  @override
  void visitSlice(SliceExpression node) {
    _initializeNode(node);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    _initializeNode(node);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    _initializeSymbol(node);
  }

  @override
  void visitVerify(VerifyExpression node) {
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
    } else if (node case final MultipleExpression node) {
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
  }

  void _initializeSymbol(SymbolExpression node) {
    _initializeNode(node);
    final rule = _rules[node.name];
    if (rule == null) {
      errors.add('Production rule not found: ${node.name}\n$_rule');
      return;
    }

    node.reference = rule;
  }
}

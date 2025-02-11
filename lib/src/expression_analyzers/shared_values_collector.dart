import '../expressions/build_context.dart';
import '../expressions/expression.dart';
import '../grammar/grammar.dart';

class SharedValuesCollector with ExpressionVisitorMixin<void> {
  static const _position = 'state.position';

  final Grammar grammar;

  final Map<String, SharedValue> _sharedValues = {};

  SharedValuesCollector({
    required this.grammar,
  });

  void collect() {
    final rules = grammar.rules;
    for (var i = 0; i < rules.length; i++) {
      final rule = rules[i];
      final expression = rule.expression;
      expression.accept(this);
    }
  }

  @override
  void visitNode(Expression node) {
    _addValues(node);
    node.visitChildren(this);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _addValues(node);
    _sharedValues.remove(_position);
    node.visitChildren(this);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final sharedValue = SharedValue(declarator: node, value: _position);
    final children = node.expressions;
    _addValue(node, _position, () => sharedValue);
    _addValues(node);
    node.sharedValues.addAll(_sharedValues);
    final copy = Map.of(_sharedValues);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      _sharedValues.clear();
      _sharedValues.addAll(copy);
      child.accept(this);
    }

    _sharedValues.remove(_position);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final sharedValue = SharedValue(declarator: node, value: _position);
    final children = node.expressions;
    _addValue(node, _position, () => sharedValue);
    _addValues(node);
    node.sharedValues.addAll(_sharedValues);
    final copy = Map.of(_sharedValues);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (i == 0) {
        _sharedValues.clear();
        _sharedValues.addAll(copy);
      }

      child.accept(this);
      if (i == 0) {
        _sharedValues.remove(_position);
      }
    }
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _addValues(node);
    _sharedValues.remove(_position);
    node.visitChildren(this);
  }

  void _addValue(Expression node, String key, SharedValue Function() ifAbsent) {
    _sharedValues.putIfAbsent(key, ifAbsent);
  }

  void _addValues(Expression node) {
    node.sharedValues.addAll(_sharedValues);
  }
}

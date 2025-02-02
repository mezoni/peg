import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;

class ResultTypesResolver extends ExpressionVisitor<void> {
  bool _hasChanges = false;

  void resolve(List<ProductionRule> rules) {
    final predefinedResultTypesResolver = _PredefinedResultTypesResolver();
    predefinedResultTypesResolver.resolve(rules);
    while (true) {
      _hasChanges = false;
      for (var i = 0; i < rules.length; i++) {
        final rule = rules[i];
        final expression = rule.expression;
        if (rule.resultType.isNotEmpty) {
          if (expression.resultType.isEmpty) {
            _setResultType(expression, rule.resultType);
          }
        }

        expression.accept(this);
        if (rule.resultType.isEmpty) {
          if (expression.resultType.isNotEmpty) {
            rule.resultType = expression.resultType;
          }
        }
      }

      if (!_hasChanges) {
        break;
      }
    }

    final resultTypeErrorCollector = _DefaultResultTypeAssigner();
    resultTypeErrorCollector.assign(rules);
  }

  @override
  void visitAction(ActionExpression node) {
    node.visitChildren(this);
    final semanticVariable = node.semanticVariable;
    if (semanticVariable != null) {
      final type = node.semanticVariableType;
      _setResultType(node, type);
    } else {
      _setResultType(node, 'void');
    }

    _postprocess(node);
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'void');
    _postprocess(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'int');
    _postprocess(node);
  }

  @override
  void visitCatch(CatchExpression node) {
    final child = node.expression;
    _setResultType(child, node.resultType);
    node.visitChildren(this);
    _setResultType(node, child.resultType);
    _postprocess(node);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'int');
    _postprocess(node);
  }

  @override
  void visitGroup(GroupExpression node) {
    final child = node.expression;
    _setResultType(child, node.resultType);
    node.visitChildren(this);
    _setResultType(node, child.resultType);
    _postprocess(node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'String');
    _postprocess(node);
  }

  @override
  void visitMatch(MatchExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'String');
    _postprocess(node);
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    final reference = node.reference!;
    _setResultType(node, reference.resultType);
    _postprocess(node);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    _setResultType(node, 'void');
    _postprocess(node);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    final elementType = _getListElementType(node.resultType);
    final child = node.expression;
    _setResultType(child, elementType);
    final childType = child.resultType;
    node.visitChildren(this);
    if (childType.isNotEmpty) {
      _setResultType(node, 'List<${child.resultType}>');
    }

    _postprocess(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    final child = node.expression;
    node.visitChildren(this);
    final childType = child.resultType;
    if (childType.isNotEmpty) {
      _setResultType(node, child.getNullableType());
    }

    _postprocess(node);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    final resultType = node.resultType;
    final childTypes = <String>{};
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      _setResultType(child, resultType);
      child.accept(this);
      childTypes.add(child.resultType);
    }

    if (resultType.isEmpty) {
      if (childTypes.length == 1) {
        _setResultType(node, childTypes.first);
      }
    }

    _postprocess(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    final resultIndex = node.findResultIndex();
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (i == resultIndex) {
        _setResultType(child, node.resultType);
      }

      child.accept(this);
      if (i == resultIndex) {
        _setResultType(node, child.resultType);
      }
    }

    _postprocess(node);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    final elementType = _getListElementType(node.resultType);
    final child = node.expression;
    _setResultType(child, elementType);
    final childType = child.resultType;
    node.visitChildren(this);
    if (childType.isNotEmpty) {
      _setResultType(node, 'List<${child.resultType}>');
    }

    _postprocess(node);
  }

  String _getListElementType(String type) {
    final temp = type.trim();
    if (temp.startsWith('List<') && temp.endsWith('>')) {
      final start = temp.indexOf('<');
      final end = temp.lastIndexOf('>');
      return type.substring(start + 1, end);
    }

    return '';
  }

  void _postprocess(Expression node) {
    final semanticVariable = node.semanticVariable;
    if (semanticVariable != null) {
      final type = node.semanticVariableType;
      _setResultType(node, type);
    }
  }

  void _setResultType(Expression node, String resultType) {
    if (resultType.isEmpty) {
      return;
    }

    if (node.resultType.isNotEmpty) {
      return;
    }

    if (node.resultType != resultType) {
      _hasChanges = true;
    }

    node.resultType = resultType;
  }
}

class _DefaultResultTypeAssigner with ExpressionVisitorMixin<void> {
  static const unresolvedType = 'Object';

  void assign(List<ProductionRule> rules) {
    for (var i = 0; i < rules.length; i++) {
      final rule = rules[i];
      if (rule.resultType.isEmpty) {
        rule.resultType = unresolvedType;
      }

      final expression = rule.expression;
      expression.accept(this);
    }
  }

  @override
  void visitNode(Expression node) {
    if (node.resultType.isEmpty) {
      node.resultType = unresolvedType;
    }

    node.visitChildren(this);
  }
}

class _PredefinedResultTypesResolver extends ExpressionVisitor<void> {
  bool _hasChanges = false;

  void resolve(List<ProductionRule> rules) {
    while (true) {
      _hasChanges = false;
      for (var i = 0; i < rules.length; i++) {
        final rule = rules[i];
        final expression = rule.expression;
        expression.accept(this);
      }

      if (!_hasChanges) {
        break;
      }
    }
  }

  @override
  void visitAction(ActionExpression node) {
    _visitChildren(node);
    final semanticVariable = node.semanticVariable;
    if (semanticVariable != null) {
      final type = node.semanticVariableType;
      _setResultType(node, type);
    } else {
      _setResultType(node, 'void');
    }
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    _visitChildren(node);
    _setResultType(node, 'void');
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _visitChildren(node);
    _setResultType(node, 'int');
  }

  @override
  void visitCatch(CatchExpression node) {
    _visitChildren(node);
    final child = node.expression;
    _setResultType(node, child.resultType);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _visitChildren(node);
    _setResultType(node, 'int');
  }

  @override
  void visitGroup(GroupExpression node) {
    _visitChildren(node);
    final child = node.expression;
    _setResultType(node, child.resultType);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    _visitChildren(node);
    _setResultType(node, 'String');
  }

  @override
  void visitMatch(MatchExpression node) {
    _visitChildren(node);
    _setResultType(node, 'String');
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    _visitChildren(node);
    final rule = node.reference!;
    _setResultType(node, rule.resultType);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _visitChildren(node);
    _setResultType(node, 'void');
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _visitChildren(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    _visitChildren(node);
    final child = node.expression;
    final childType = child.resultType;
    if (childType.isNotEmpty) {
      final resultType = helper.getNullableType(childType);
      _setResultType(node, resultType);
    }
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    _visitChildren(node);
    final childTypes = node.expressions.map((e) => e.resultType).toSet();
    if (childTypes.length == 1) {
      final childType = childTypes.first;
      _setResultType(node, childType);
    }
  }

  @override
  void visitSequence(SequenceExpression node) {
    _visitChildren(node);
    final resultIndex = node.findResultIndex();
    if (resultIndex != -1) {
      final child = node.expressions[resultIndex];
      _setResultType(node, child.resultType);
    } else {
      _setResultType(node, 'void');
    }

    final children = node.expressions;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final semanticVariable = child.semanticVariable;
      if (semanticVariable == null && i != resultIndex) {
        _setResultType(child, 'void');
      }
    }
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _visitChildren(node);
  }

  void _setResultType(Expression node, String resultType) {
    if (resultType.isEmpty) {
      return;
    }

    if (node.resultType.isNotEmpty) {
      return;
    }

    if (node.resultType != resultType) {
      _hasChanges = true;
    }

    node.resultType = resultType;
  }

  void _visitChildren(Expression node) {
    node.visitChildren(this);
  }
}

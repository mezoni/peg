import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';

class ResultTypesResolver extends ExpressionVisitor<void> {
  static final ResultType _dynamicListType =
      GenericType(name: 'List', arguments: [_nullableObjectType]);

  static final ResultType _nullableObjectType =
      GenericType(name: 'Object', isNullableType: true);

  bool _hasModifications = false;

  void resolve(List<ProductionRule> rules) {
    _hasModifications = true;
    while (_hasModifications) {
      _hasModifications = false;
      for (var rule in rules) {
        final expression = rule.expression;
        final resultType = rule.resultType;
        if (resultType != null) {
          _setResultType(expression, resultType);
        }

        expression.accept(this);
      }
    }
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getResultType(child));
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    node.visitChildren(this);
    _setResultType(node, GenericType(name: 'int'));
  }

  @override
  void visitBuffer(BufferExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getResultType(child));
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    node.visitChildren(this);
    _setResultType(node, GenericType(name: 'int'));
  }

  @override
  void visitCut(CutExpression node) {
    node.visitChildren(this);
    _setResultType(node, _nullableObjectType);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getResultType(child));
  }

  @override
  void visitGroup(GroupExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getResultType(child));
  }

  @override
  void visitLiteral(LiteralExpression node) {
    node.visitChildren(this);
    _setResultType(node, GenericType(name: 'String'));
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    node.visitChildren(this);
    _setResultType(node, GenericType(name: 'String'));
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    node.visitChildren(this);
    _setResultType(node, _nullableObjectType);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getListResultType(_getResultType(child)));
  }

  @override
  void visitOptional(OptionalExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    final resultType = _getResultType(child).getNullableType();
    _setResultType(node, resultType);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    _setResultType(node, _nullableObjectType);
    final resultType = node.resultType!;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      _setResultType(child, resultType);
    }

    node.visitChildren(this);
    final resultTypes = <ResultType>{};
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      resultTypes.add(_getResultType(child));
    }

    final resultTypeSet = resultTypes.toSet();
    if (resultTypeSet.length == 1) {
      _setResultType(node, resultTypeSet.first);
    } else {
      _setResultType(node, _nullableObjectType);
    }
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getListResultType(_getResultType(child)));
  }

  @override
  void visitSepBy(SepByExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getListResultType(_getResultType(child)));
  }

  @override
  void visitSepBy1(SepBy1Expression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getListResultType(_getResultType(child)));
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    final count = children.length;
    node.visitChildren(this);
    final childrenWithVariables =
        children.where((e) => e.semanticVariable != null).toList();
    if (node.action case final action?) {
      if (action.resultType case final resultType?) {
        _setResultType(node, resultType);
      }
    } else {
      if (count == 1) {
        final first = children.first;
        _setResultType(node, _getResultType(first));
      } else {
        if (childrenWithVariables.isEmpty) {
          _setResultType(node, _dynamicListType);
        } else if (childrenWithVariables.length == 1) {
          final expression = childrenWithVariables.first;
          _setResultType(node, _getResultType(expression));
        } else {
          final fields = childrenWithVariables
              .map((e) => (type: _getResultType(e), name: e.semanticVariable!))
              .toList();
          final resultType = RecordType(named: fields);
          _setResultType(node, resultType);
        }
      }
    }
  }

  @override
  void visitSlice(SliceExpression node) {
    node.visitChildren(this);
    _setResultType(node, GenericType(name: 'String'));
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    node.visitChildren(this);
    final stringType = GenericType(name: 'String');
    _setResultType(node, stringType);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    node.visitChildren(this);
    final reference = node.reference!;
    final resultType = reference.resultType;
    if (resultType == null) {
      final child = reference.expression;
      _setResultType(node, _getResultType(child));
    } else {
      _setResultType(node, resultType);
    }
  }

  @override
  void visitVerify(VerifyExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getResultType(child));
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    node.visitChildren(this);
    final child = node.expression;
    _setResultType(node, _getListResultType(_getResultType(child)));
  }

  ResultType _getListResultType(ResultType resultType) {
    return GenericType(name: 'List', arguments: [resultType]);
  }

  ResultType _getResultType(Expression node) {
    return node.resultType ?? _nullableObjectType;
  }

  void _setResultType(Expression node, ResultType resultType) {
    int priority(ResultType type) {
      if (type == _nullableObjectType) {
        return 0;
      }

      if (type == _dynamicListType) {
        return 1;
      }

      if (type is GenericType) {
        var result = 2;
        final arguments = type.arguments;
        for (var i = 0; i < arguments.length; i++) {
          final argument = arguments[i];
          result += priority(argument);
        }

        return result;
      }

      if (type is RecordType) {
        var result = 2;
        final positional = type.positional;
        for (var i = 0; i < positional.length; i++) {
          final fieldType = positional[i];
          result += priority(fieldType.type);
        }

        final named = type.named;
        for (var i = 0; i < named.length; i++) {
          final field = named[i];
          final fieldType = field.type;
          result += priority(fieldType);
        }

        return result;
      }

      return 2;
    }

    final oldResultType = node.resultType;
    if (oldResultType == null) {
      node.resultType = resultType;
      _hasModifications = true;
      return;
    }

    final oldPriority = priority(oldResultType);
    final newPriority = priority(resultType);
    if (oldPriority >= newPriority) {
      return;
    }

    if (oldResultType != resultType) {
      node.resultType = resultType;
      _hasModifications = true;
    }
  }
}

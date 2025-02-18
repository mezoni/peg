import '../expressions/expression.dart';
import '../grammar/grammar.dart';
import '../parser_generator_diagnostics.dart';
import 'result_type_resolver.dart';

class ExpressionInitializer1 {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  ExpressionInitializer1({
    required this.diagnostics,
    required this.grammar,
  });

  void initialize() {
    final expressionInitializer1 = _ExpressionInitializer1(
      diagnostics: diagnostics,
      grammar: grammar,
    );
    expressionInitializer1.initialize();
    if (diagnostics.hasErrors) {
      return;
    }

    final resultTypesResolver = ResultTypesResolver();
    resultTypesResolver.resolve(grammar.rules);
  }
}

class _ExpressionInitializer1 extends ExpressionVisitor<void> {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  bool _hasChanges = false;

  _ExpressionInitializer1({
    required this.diagnostics,
    required this.grammar,
  });

  void initialize() {
    final rules = grammar.rules;
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
    _setIsNulled(node, false);
    _setIsAlwaysSuccessful(node, true);
    _setMayNotConsume(node, true);
  }

  @override
  void visitAndPredicate(AndPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, true);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, false);
    _setMayNotConsume(node, false);
  }

  @override
  void visitCatch(CatchExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, child.isNulled);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
    if (child.isAlwaysSuccessful) {
      final rule = node.rule!;
      final warning = diagnostics
          .warning("Child expression of the 'Catch' expression is optional");
      warning.description(
          'Consequence', 'The error handler will never be executed');
      warning.description('Expression', '$node');
      warning.description('Child expression', '$child');
      warning.description('Child expression kind', '${child.runtimeType}');
      warning.description('Production rule name', rule.name);
    }
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, false);
    _setMayNotConsume(node, false);
  }

  @override
  void visitGroup(GroupExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, child.isNulled);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final literal = node.literal;
    final silent = node.silent;
    if (literal.isEmpty) {
      _setIsNulled(node, !silent);
      _setIsAlwaysSuccessful(node, true);
      _setMayNotConsume(node, true);
    } else {
      _setIsNulled(node, true);
      _setIsAlwaysSuccessful(node, false);
      _setMayNotConsume(node, false);
    }
  }

  @override
  void visitMatch(MatchExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, !child.isAlwaysSuccessful);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
  }

  @override
  void visitNonterminal(NonterminalExpression node) {
    final reference = node.reference!;
    final expression = reference.expression;
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, expression.isAlwaysSuccessful);
    _setMayNotConsume(node, expression.mayNotConsume);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, false);
    _setMayNotConsume(node, true);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
    if (child.isAlwaysSuccessful) {
      final rule = node.rule!;
      final warning = diagnostics.warning(
          "Child expression of the 'One or more' expression is optional");
      warning.description('Consequence', 'Infinite loop');
      warning.description('Expression', '$node');
      warning.description('Child expression', '$child');
      warning.description('Child expression kind:', '${child.runtimeType}');
      warning.description('Production rule name:', rule.name);
    }
  }

  @override
  void visitOptional(OptionalExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, false);
    _setIsAlwaysSuccessful(node, true);
    _setMayNotConsume(node, true);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    final children = node.expressions;
    if (children.length == 1) {
      final child = children[0];
      child.accept(this);
      _setIsNulled(node, child.isNulled);
      _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
      _setMayNotConsume(node, child.mayNotConsume);
    } else {
      var isAlwaysSuccessful = false;
      var isNulled = false;
      var mayNotConsume = false;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        child.accept(this);
        if (child.isAlwaysSuccessful) {
          isAlwaysSuccessful = true;
        }

        if (child.isNulled) {
          isNulled = true;
        }

        if (child.mayNotConsume) {
          mayNotConsume = true;
        }

        if (child.isAlwaysSuccessful) {
          if (i != children.length - 1) {
            final rule = node.rule!;
            final warning = diagnostics.warning(
                "Not the last alternative of the 'Ordered choice' expression is optional");
            warning.description(
                'Consequence', 'Subsequent alternative will never be parsed.');
            warning.description('Expression', '$node');
            warning.description('Alternative expression', '$child');
            warning.description(
                'Alternative expression kind:', '${child.runtimeType}');
            warning.description('Production rule name:', rule.name);
          }
        }
      }

      _setIsNulled(node, isNulled);
      _setIsAlwaysSuccessful(node, isAlwaysSuccessful);
      _setMayNotConsume(node, mayNotConsume);
    }
  }

  @override
  void visitPredicate(PredicateExpression node) {
    final negate = node.negate;
    final code = node.code.trim();
    var isAlwaysSuccessful = false;
    if (negate) {
      isAlwaysSuccessful = code == 'false';
    } else {
      isAlwaysSuccessful = code == 'true';
    }

    _setIsNulled(node, true);
    _setIsAlwaysSuccessful(node, isAlwaysSuccessful);
    _setMayNotConsume(node, true);
  }

  @override
  void visitSequence(SequenceExpression node) {
    final children = node.expressions;
    final variables = <String>{};
    if (children.length == 1) {
      final child = children[0];
      child.accept(this);
      _setIsNulled(node, child.isNulled);
      _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
      _setMayNotConsume(node, child.mayNotConsume);
    } else {
      var isNotNulled = false;
      var isAlwaysSuccessful = false;
      var mayNotConsume = false;
      var checkIsNotNulled = true;
      var checkIsAlwaysSuccessful = true;
      var checkMayNotConsume = true;
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        child.accept(this);
        if (!child.isNulled) {
          if (checkIsNotNulled) {
            isNotNulled = true;
          }
        } else {
          isNotNulled = false;
          checkIsNotNulled = false;
        }

        if (child.isAlwaysSuccessful) {
          if (checkIsAlwaysSuccessful) {
            isAlwaysSuccessful = true;
          }
        } else {
          isAlwaysSuccessful = false;
          checkIsAlwaysSuccessful = false;
        }

        if (child.mayNotConsume) {
          if (checkMayNotConsume) {
            mayNotConsume = true;
          }
        } else {
          mayNotConsume = false;
          checkMayNotConsume = false;
        }

        if (child is VariableExpression) {
          final name = child.name;
          if (!variables.add(name)) {
            final rule = child.rule!;
            final error = diagnostics.error(
                "Several expressions 'Variable' with the same names were found");
            error.description('Expression', '$node');
            error.description('Duplicate name', name);
            error.description('Variable expressions',
                '\n${children.whereType<VariableExpression>().where((e) => e.name == name).map((e) => '- $e').join('\n')}');
            error.description('Production rule name', rule.name);
          }
        }
      }

      _setIsNulled(node, !isNotNulled);
      _setIsAlwaysSuccessful(node, isAlwaysSuccessful);
      _setMayNotConsume(node, mayNotConsume);
    }
  }

  @override
  void visitTyping(TypingExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, child.isNulled);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
  }

  @override
  void visitVariable(VariableExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, child.isNulled);
    _setIsAlwaysSuccessful(node, child.isAlwaysSuccessful);
    _setMayNotConsume(node, child.mayNotConsume);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    final child = node.expression;
    child.accept(this);
    _setIsNulled(node, false);
    _setIsAlwaysSuccessful(node, true);
    _setMayNotConsume(node, true);
    if (child.isAlwaysSuccessful) {
      final rule = node.rule!;
      final warning = diagnostics.warning(
          "Child expression of the 'Zero or more' expression is optional");
      warning.description('Consequence', 'Infinite loop');
      warning.description('Expression', '$node');
      warning.description('Child expression', '$child');
      warning.description('Child expression kind:', '${child.runtimeType}');
      warning.description('Production rule name:', rule.name);
    }
  }

  void _setIsAlwaysSuccessful(Expression node, bool isAlwaysSuccessful) {
    if (isAlwaysSuccessful != node.isAlwaysSuccessful) {
      _hasChanges = true;
      node.isAlwaysSuccessful = isAlwaysSuccessful;
      if (!isAlwaysSuccessful) {
        _setMayNotConsume(node, true);
      }
    }
  }

  void _setIsNulled(Expression node, bool isNulled) {
    if (isNulled != node.isNulled) {
      _hasChanges = true;
      node.isNulled = isNulled;
    }
  }

  void _setMayNotConsume(Expression node, bool mayNotConsume) {
    if (mayNotConsume != node.mayNotConsume) {
      _hasChanges = true;
      node.mayNotConsume = mayNotConsume;
    }
  }
}

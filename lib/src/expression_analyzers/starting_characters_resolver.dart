import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;

class StartingCharactersResolver extends ExpressionVisitor<void> {
  static const _unicodeCharacters = [(0, 0x10ffff)];

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
    _addNode(node);
  }

  @override
  void visitAnyCharacter(AnyCharacterExpression node) {
    _addStartingCharacters(node, _unicodeCharacters);
  }

  @override
  void visitCharacterClass(CharacterClassExpression node) {
    final ranges = node.ranges;
    final negate = node.negate;
    if (!negate) {
      _addStartingCharacters(node, ranges);
    } else {
      if (ranges.length == 1 && ranges[0].$1 == ranges[0].$2) {
        final char = ranges[0].$1;
        final min = _unicodeCharacters[0].$1;
        final max = _unicodeCharacters[0].$2;
        if (char == min) {
          _addStartingCharacters(node, [(min + 1, max)]);
        } else if (char == max) {
          _addStartingCharacters(node, [(min, max - 1)]);
        } else {
          _addStartingCharacters(node, [
            (min, char - 1),
            (char + 1, max),
          ]);
        }
      } else {
        _addStartingCharacters(node, _unicodeCharacters);
      }
    }
  }

  @override
  void visitCut(CutExpression node) {
    _addNode(node);
  }

  @override
  void visitEof(EofExpression node) {
    _addStartingCharacters(node, _unicodeCharacters);
  }

  @override
  void visitErrorHandler(ErrorHandlerExpression node) {
    _addNode(node);
  }

  @override
  void visitExpected(ExpectedExpression node) {
    _addNode(node);
  }

  @override
  void visitGroup(GroupExpression node) {
    _addNode(node);
  }

  @override
  void visitLiteral(LiteralExpression node) {
    final string = node.string;
    if (string.isEmpty) {
      _addStartingCharacters(node, _unicodeCharacters);
    } else {
      final char = string.runes.first;
      _addStartingCharacters(node, [(char, char)]);
    }
  }

  @override
  void visitMatchString(MatchStringExpression node) {
    _addStartingCharacters(node, _unicodeCharacters);
  }

  @override
  void visitNotPredicate(NotPredicateExpression node) {
    _addNode(node);
  }

  @override
  void visitOneOrMore(OneOrMoreExpression node) {
    _addNode(node);
  }

  @override
  void visitOptional(OptionalExpression node) {
    _addNode(node);
  }

  @override
  void visitOrderedChoice(OrderedChoiceExpression node) {
    _addNode(node);
  }

  @override
  void visitRepetition(RepetitionExpression node) {
    _addNode(node);
  }

  @override
  void visitSepBy(SepByExpression node) {
    _addNode(node);
  }

  @override
  void visitSepBy1(SepBy1Expression node) {
    _addNode(node);
  }

  @override
  void visitSequence(SequenceExpression node) {
    _addNode(node);
  }

  @override
  void visitSlice(SliceExpression node) {
    _addNode(node);
  }

  @override
  void visitStringChars(StringCharsExpression node) {
    _addNode(node);
  }

  @override
  void visitSymbol(SymbolExpression node) {
    final child = node.reference!.expression;
    final startingCharacters = child.startingCharacters;
    _addStartingCharacters(node, startingCharacters);
  }

  @override
  void visitVerify(VerifyExpression node) {
    _addNode(node);
  }

  @override
  void visitZeroOrMore(ZeroOrMoreExpression node) {
    _addNode(node);
  }

  void _addNode(Expression node) {
    final ranges = <(int, int)>[];
    final startingExpressions = node.startingExpressions;
    node.visitChildren(this);
    for (final element in startingExpressions) {
      final startingCharacters = element.startingCharacters;
      ranges.addAll(startingCharacters);
    }

    _addStartingCharacters(node, ranges);
  }

  void _addStartingCharacters(
      Expression node, List<(int, int)> startingCharacters) {
    if (startingCharacters.isEmpty) {
      return;
    }

    final oldRanges = node.startingCharacters;
    if (oldRanges.isEmpty) {
      var newRanges = startingCharacters.toList();
      if (startingCharacters.length > 1) {
        newRanges = helper.normalizeRanges(startingCharacters);
      }

      node.startingCharacters = newRanges;
      _hasModifications = true;
      return;
    }

    final newRanges =
        helper.normalizeRanges([...oldRanges, ...startingCharacters]);
    var hasChanges = oldRanges.length != newRanges.length;
    if (!hasChanges) {
      for (var i = 0; i < oldRanges.length; i++) {
        if (oldRanges[i] != newRanges[i]) {
          hasChanges = true;
          break;
        }
      }
    }

    if (hasChanges) {
      node.startingCharacters = newRanges;
      _hasModifications = true;
    }
  }
}

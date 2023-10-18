import 'binary_converter.dart';

AstNode _parse(String source) => BinaryConverter().convert(source);

class BinarySearch {
  String generatePredicate(String name, List<(int, int)> ranges, bool negate) {
    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }

    if (negate) {
      if (ranges.length == 1) {
        final range = ranges[0];
        if (range.$1 == range.$2) {
          final char = range.$1;
          return '$name != $char';
        }
      }
    }

    ranges = normalizeRanges(ranges);
    var node = _buildTransitions(name, ranges);
    node = _convertToPredicate(node);
    node = _optimizePredicate(node);
    if (negate) {
      return '!($node)';
    }

    return '$node';
  }

  String generateTransitions(String name, List<(int, int)> ranges) {
    ranges = normalizeRanges(ranges);
    final node = _buildTransitions(name, ranges);
    return '$node';
  }

  List<(int, int)> normalizeRanges(List<(int, int)> ranges) {
    final result = <(int, int)>[];
    final temp = ranges.toList();
    temp.sort(
      (a, b) {
        if (a.$1 > b.$1) {
          return 1;
        } else if (a.$1 < b.$1) {
          return -1;
        } else {
          return a.$2 - b.$2;
        }
      },
    );
    for (var i = 0; i < temp.length; i++) {
      var range = temp[i];
      result.add(range);
      _checkRange(range);
      var k = i + 1;
      for (; k < temp.length; k++) {
        final next = temp[k];
        _checkRange(next);
        if (next.$1 <= range.$2 + 1) {
          range = (range.$1, range.$2 > next.$2 ? range.$2 : next.$2);
          result.last = range;
        } else {
          k--;
          break;
        }
      }

      i = k;
    }

    return result;
  }

  AstNode _buildTransitions(String name, List<(int, int)> ranges) {
    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }

    var node = _plunge(name, ranges, 0, ranges.length - 1);
    node = _optimizeTransitions(node);
    return node;
  }

  void _checkRange((int, int) range) {
    if (range.$1 > range.$2) {
      throw RangeError.range(range.$2, range.$1, null);
    }
  }

  AstNode _convertToPredicate(AstNode node) {
    final converter = _TransitionToPredicateConverter();
    node = node.accept(converter);
    return node;
  }

  AstNode _optimizePredicate(AstNode node) {
    final optimizer = _PredicateOptimizer();
    final result = node.accept(optimizer);
    return result;
  }

  AstNode _optimizeTransitions(AstNode node) {
    final optimizer = _TransitionOptimizer();
    final result = node.accept(optimizer);
    return result;
  }

  AstNode _plunge(String name, List<(int, int)> ranges, int lo, int hi) {
    final size = hi - lo;
    if (size == 0) {
      final range = ranges[lo];
      final start = range.$1;
      final end = range.$2;
      final source = '$name >= $start && $name <= $end ? $lo : -1';
      final result = _parse(source);
      return result;
    }

    if (size == 1) {
      final range = ranges[lo];
      final start = range.$1;
      final end = range.$2;
      final right = _plunge(name, ranges, hi, hi);
      final source = '$name <= $end ? $name >= $start ? $lo : -1 : $right';
      final result = _parse(source);
      return result;
    }

    if (size == 2) {
      final mid = lo + 1;
      final range = ranges[mid];
      final start = range.$1;
      final end = range.$2;
      final left = _plunge(name, ranges, lo, lo);
      final right = _plunge(name, ranges, hi, hi);
      final source = '$name < $start ? $left : $name <= $end  ? $mid : $right ';
      final result = _parse(source);
      return result;
    }

    final mid = (lo + hi) >> 1;
    final range = ranges[mid];
    final start = range.$1;
    final end = range.$2;
    final left = _plunge(name, ranges, lo, mid - 1);
    final right = _plunge(name, ranges, mid + 1, hi);
    final source = '$name < $start ? $left : $name <= $end  ? $mid : $right ';
    final result = _parse(source);
    return result;
  }
}

mixin _AstNodeChecker {
  ({String name, num value})? checkComparison(AstNode node, String operator) {
    if (node is! BinaryNode) {
      return null;
    }

    if (node.operator != operator) {
      return null;
    }

    final identifier = node.left;
    if (identifier is! IdentifierNode) {
      return null;
    }

    final value = node.right;
    if (value is! NumericNode) {
      return null;
    }

    return (name: identifier.name, value: value.value);
  }

  bool isComparison(AstNode node) {
    if (node is! BinaryNode) {
      return false;
    }

    switch (node.operator) {
      case '<':
      case '<=':
      case '>':
      case '>=':
      case '==':
      case '!=':
        return true;
    }

    return false;
  }
}

class _AstNodeCloner extends AstNodeVisitor<AstNode> {
  @override
  AstNode visitBinary(BinaryNode node) {
    final left = node.left.accept(this);
    final right = node.right.accept(this);
    final result = BinaryNode(left, node.operator, right);
    return result;
  }

  @override
  AstNode visitBoolean(BooleanNode node) {
    final result = BooleanNode(node.value);
    return result;
  }

  @override
  AstNode visitGroup(GroupNode node) {
    final child = node.node.accept(this);
    final result = GroupNode(child);
    return result;
  }

  @override
  AstNode visitIdentifier(IdentifierNode node) {
    final result = IdentifierNode(node.name);
    return result;
  }

  @override
  AstNode visitNumeric(NumericNode node) {
    final result = NumericNode(node.value);
    return result;
  }

  @override
  AstNode visitTernary(TernaryNode node) {
    final condition = node.condition.accept(this);
    final left = node.left.accept(this);
    final right = node.right.accept(this);
    final result = TernaryNode(condition, left, right);
    return result;
  }
}

class _PredicateOptimizer extends _AstNodeCloner with _AstNodeChecker {
  bool _hasModifications = false;

  AstNode optimize(AstNode node) {
    _hasModifications = false;
    while (_hasModifications) {
      _hasModifications = false;
      node = node.accept(this);
    }

    return node;
  }

  @override
  AstNode visitBinary(BinaryNode node) {
    final left = node.left.accept(this);
    final right = node.right.accept(this);
    final value1 = left is BooleanNode ? left.value : left;
    final value2 = right is BooleanNode ? right.value : right;
    AstNode? optimize() {
      if (node.operator != '||') {
        return null;
      }

      final result = switch ((value1, value2)) {
        (false, false) => BooleanNode(false),
        (false, true) => BooleanNode(true),
        (true, false) => BooleanNode(true),
        (true, true) => BooleanNode(true),
        (true, _) => right,
        (_, true) => left,
        (false, _) => right,
        (_, false) => left,
        (_, _) => null,
      };

      if (result != null) {
        _hasModifications = true;
      }

      return result;
    }

    final node2 = optimize();
    if (node2 != null) {
      return node2;
    }

    return BinaryNode(left, node.operator, right);
  }

  @override
  AstNode visitTernary(TernaryNode node) {
    final condition = node.condition.accept(this);
    final left = node.left.accept(this);
    final right = node.right.accept(this);

    AstNode? optimize(TernaryNode node) {
      final left1 = checkComparison(condition, '<=');
      if (left1 == null) {
        return null;
      }

      final right1 = checkComparison(left, '>=');
      if (right1 == null) {
        return null;
      }

      final name = left1.name;
      final value = left1.value;
      if (name != right1.name || value != right1.value) {
        return null;
      }

      final result = _logicalOr(_parse('$name == $value'), right);
      return result.accept(this);
    }

    final node2 = optimize(node);
    if (node2 != null) {
      return node2;
    }

    final value1 = left is BooleanNode ? left.value : left;
    final value2 = right is BooleanNode ? right.value : right;
    final result = switch ((value1, value2)) {
      (true, false) => _modify(condition),
      (true, _) => _modify(_logicalOr(condition, right).accept(this)),
      (_, _) => super.visitTernary(node),
    };

    return result;
  }

  AstNode _logicalOr(AstNode left, AstNode right) {
    if (left is TernaryNode) {
      left = _parse('($left)');
    }

    if (right is TernaryNode) {
      right = _parse('($right)');
    }

    return _parse('$left || $right');
  }

  AstNode _modify(AstNode node) {
    _hasModifications = true;
    return node;
  }
}

class _TransitionOptimizer extends _AstNodeCloner with _AstNodeChecker {
  bool _hasModifications = false;

  AstNode optimize(AstNode node) {
    _hasModifications = false;
    while (_hasModifications) {
      _hasModifications = false;
      node = node.accept(this);
    }

    return node;
  }

  @override
  AstNode visitBinary(BinaryNode node) {
    AstNode? optimize(BinaryNode node) {
      if (node.operator != '&&') {
        return null;
      }

      final left = checkComparison(node.left, '>=');
      if (left == null) {
        return null;
      }

      final right = checkComparison(node.right, '<=');
      if (right == null) {
        return null;
      }

      final name = left.name;
      final value = left.value;
      if (name != right.name || value != right.value) {
        return null;
      }

      _hasModifications = true;
      final result = _parse('$name == $value');
      return result.accept(this);
    }

    final node2 = optimize(node);
    if (node2 != null) {
      return node2;
    }

    final left = node.left.accept(this);
    final right = node.right.accept(this);
    return BinaryNode(left, node.operator, right);
  }
}

class _TransitionToPredicateConverter extends _AstNodeCloner
    with _AstNodeChecker {
  @override
  AstNode visitNumeric(NumericNode node) {
    if (isComparison(node.parent!)) {
      return super.visitNumeric(node);
    }

    final value = node.value >= 0;
    final result = BooleanNode(value);
    return result;
  }
}

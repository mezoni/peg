import 'package:simple_sparse_list/ranges_helper.dart';

class MatcherGenerator {
  const MatcherGenerator();

  String generate(String name, List<(int, int)> ranges, {bool negate = false}) {
    if (name.isEmpty) {
      throw ArgumentError('Must not be empty', 'name');
    }

    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }

    ranges = normalizeRanges(ranges);
    if (negate && ranges.length == 1) {
      final range = ranges.first;
      final start = range.$1;
      final end = range.$2;
      if (start == end) {
        return '$name != $start';
      }
    }

    if (negate) {
      ranges.add((0, 0));
      ranges = normalizeRanges(ranges);
    }

    final code = _generate(name, 0, ranges.length - 1, ranges);
    if (!negate) {
      return code;
    }

    return '!($code)';
  }

  String _compareRange(String name, (int, int) range) {
    final start = range.$1;
    final end = range.$2;
    if (start == end) {
      return '$name == $start';
    }

    return '$name >= $start && $name <= $end';
  }

  bool _isSimple((int, int) range) => range.$1 == range.$2;

  String _compareRanges(String name, (int, int) prev, (int, int) next,
      [bool quote = false]) {
    final expr1 = _compareRange(name, prev);
    if (_isSimple(prev) || _isSimple(next)) {
      final expr2 = _compareRange(name, next);
      if (prev.$1 == prev.$2) {
        return '$expr1 || $expr2';
      }
    }

    final expr = '$name >= ${next.$1} ? $name <= ${next.$2} : $expr1';
    return quote ? '($expr)' : expr;
  }

  String _generate(String name, int from, int to, List<(int, int)> ranges,
      [bool quote = false]) {
    final length = to - from + 1;
    final first = ranges[from];
    final last = ranges[to];
    if (length > 3) {
      final i = (to + from) >> 1;
      final left = _generate(name, from, i - 1, ranges);
      final right = _generate(name, i + 1, to, ranges, true);
      final curr = ranges[i];
      final start = curr.$1;
      final end = curr.$2;
      return '$name >= $start ? $name <= $end || $right : $left';
    } else if (length == 3) {
      final curr = ranges[from + 1];
      final start = curr.$1;
      final end = curr.$2;
      final left = _compareRange(name, first);
      final right = _compareRange(name, last);
      return '$name >= $start ? $name <= $end || $right : $left';
    } else if (length == 2) {
      return _compareRanges(name, first, last, quote);
    } else {
      return _compareRange(name, first);
    }
  }
}

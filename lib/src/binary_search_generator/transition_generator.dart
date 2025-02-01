import 'package:simple_sparse_list/ranges_helper.dart';

class TransitionGenerator {
  const TransitionGenerator();

  String generate(String name, List<(int, int)> ranges,
      String Function((int, int) range) map) {
    if (name.isEmpty) {
      throw ArgumentError('Must not be empty', 'name');
    }

    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }

    final sorted = sortRanges(ranges);
    var prevEnd = sorted.first.$2;
    for (var i = 1; i < sorted.length; i++) {
      final range = sorted[i];
      final start = range.$1;
      final end = range.$2;
      if (start <= prevEnd) {
        final prevIndex = i - 1;
        final prev = sorted[prevIndex];
        throw ArgumentError(
            'Ranges must not contain overlapping values: $prev, $range');
      }

      if (start > end) {
        throw ArgumentError('Invalid range: $range');
      }

      prevEnd = end;
    }

    final code = _generate(name, 0, sorted.length - 1, sorted, map);
    return code;
  }

  String _compareRange(
      String name, String value, (int, int) range, String other) {
    final start = range.$1;
    final end = range.$2;
    if (start == end) {
      return '$name == $start ? $value : $other';
    }

    return '$name >= $start && $name <= $end ? $value : $other';
  }

  String _generate(String name, int from, int to, List<(int, int)> ranges,
      String Function((int, int) range) map) {
    final length = to - from + 1;
    final first = ranges[from];
    final last = ranges[to];
    if (length > 3) {
      final i = (to + from) >> 1;
      final left = _generate(name, from, i - 1, ranges, map);
      final right = _generate(name, i + 1, to, ranges, map);
      final curr = ranges[i];
      final currValue = map(curr);
      final start = curr.$1;
      final end = curr.$2;
      return '$name >= $start ? $name <= $end ? $currValue : $right : $left';
    } else if (length == 3) {
      final currIndex = from + 1;
      final curr = ranges[currIndex];
      final currValue = map(curr);
      final start = curr.$1;
      final end = curr.$2;
      final firstValue = map(first);
      final lastValue = map(last);
      final left = _compareRange(name, firstValue, first, 'null');
      final right = _compareRange(name, lastValue, last, 'null');
      return '$name >= $start ? $name <= $end ? $currValue : $right : $left';
    } else if (length == 2) {
      final firstValue = map(first);
      final lastValue = map(last);
      final expr = _compareRange(name, lastValue, last, 'null');
      return _compareRange(name, firstValue, first, expr);
    } else {
      final value = map(first);
      return _compareRange(name, value, first, 'null');
    }
  }
}

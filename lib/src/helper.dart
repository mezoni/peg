import 'dart:convert';

String assignStatePos(String variable, List<(int, int)> ranges, bool negate) {
  if (ranges.isEmpty) {
    throw ArgumentError('Must not be empty', 'ranges');
  }

  if (negate) {
    return 'state.pos += $variable > 0xffff ? 2 : 1';
  }

  final has16Bit = ranges.any((e) => e.$1 <= 0xffff || e.$2 <= 0xffff);
  final has32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
  return switch ((has16Bit, has32Bit)) {
    (false, false) => 'state.pos += $variable > 0xffff ? 2 : 1',
    (false, true) => 'state.pos += 2',
    (true, false) => 'state.pos++',
    (true, true) => 'state.pos += $variable > 0xffff ? 2 : 1',
  };
}

String charAt(List<(int, int)> ranges, bool negate) {
  if (is32BitRanges(ranges, negate)) {
    return 'runeAt';
  }

  return 'codeUnitAt';
}

void checkRange((int, int) range) {
  if (range.$1 > range.$2) {
    throw RangeError.range(range.$2, range.$1, null);
  }
}

String escapeString(String text, [bool quote = true]) {
  text = text.replaceAll('\\', r'\\');
  text = text.replaceAll('\b', r'\b');
  text = text.replaceAll('\f', r'\f');
  text = text.replaceAll('\n', r'\n');
  text = text.replaceAll('\r', r'\r');
  text = text.replaceAll('\t', r'\t');
  text = text.replaceAll('\v', r'\v');
  text = text.replaceAll('\'', '\\\'');
  text = text.replaceAll('\$', r'\$');
  if (!quote) {
    return text;
  }

  return '\'$text\'';
}

({String name, String size}) getCharReader(bool is16Bit, String name) {
  if (is16Bit) {
    return (name: 'codeUnitAt', size: '1');
  }

  return (name: 'runeAt', size: '$name > 0xffff ? 2 : 1');
}

(int, int) getUnicodeRange() {
  return const (0, 0x10ffff);
}

bool is32BitRanges(List<(int, int)> ranges, bool negate) {
  if (ranges.isEmpty) {
    throw ArgumentError('Must not be empty', 'ranges');
  }

  if (negate) {
    return true;
  }

  return ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
}

bool isTypeNullable(String? type) {
  if (type == null) {
    return true;
  }

  type = type.trim();
  return type.endsWith('?') || type == 'dynamic';
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
    checkRange(range);
    var k = i + 1;
    for (; k < temp.length; k++) {
      final next = temp[k];
      checkRange(next);
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

String rangesToPredicate(String name, List<(int, int)> ranges, bool negate) {
  if (ranges.isEmpty) {
    throw ArgumentError.value(ranges, 'ranges', 'Must not be empty');
  }

  // TODO:
  // ignore: unused_element
  _Expression and(_Expression left, _Expression right) {
    return _Code('$left && $right');
  }

  _Expression or(_Expression left, _Expression right) {
    if ('$left' == 'false' && '$right' == ' false') {
      return const _Code('false');
    }

    if ('$left' == 'false') {
      return right;
    }

    if ('$right' == 'false') {
      return left;
    }

    _Expression group(_Expression expression) {
      if (expression is! _Triple) {
        return expression;
      }

      return _Group(expression);
    }

    left = group(left);
    right = group(right);
    return _Code('$left || $right');
  }

  _Expression triple(
      _Expression condition, _Expression left, _Expression right) {
    if ('$right' == 'false') {
      //return and(condition, left);
    }

    return _Triple('$condition ? $left : $right');
  }

  _Expression process(String name, List<(int, int)> ranges, int lo, int hi,
      Set<int> processed) {
    if (lo == hi) {
      final range = ranges[lo];
      final start = range.$1;
      final end = range.$2;
      final isStartProcessed = processed.contains(start);
      final isEndProcessed = processed.contains(end);
      if (isStartProcessed && isEndProcessed) {
        return const _Code('false');
      }

      if (!isStartProcessed && !isEndProcessed) {
        processed.add(start);
        processed.add(end);
        if (start == end) {
          return _Code('$name == $start');
        }

        return _Code('$name >= $start && $name <= $end');
      }

      if (isStartProcessed) {
        processed.add(end);
        return _Code('$name <= $end');
      }

      processed.add(start);
      return _Code('$name >= $start');
    }

    final mid = (lo + hi) >> 1;
    if (mid == 0 || mid == ranges.length - 1) {
      final left = process(name, ranges, lo, mid, processed);
      final right = process(name, ranges, mid + 1, hi, processed);
      return or(left, right);
    }

    final range = ranges[mid];
    final start = range.$1;
    final end = range.$2;
    if (start != end) {
      processed.add(end);
      final left = process(name, ranges, lo, mid, processed);
      final right = process(name, ranges, mid + 1, hi, processed);
      return triple(_Code('$name <= $end'), left, right);
    }

    processed.add(end);
    final left = process(name, ranges, lo, mid, processed);
    final right = process(name, ranges, mid + 1, hi, processed);
    if ('$left' == 'false') {
      return or(_Code('$name == $end'), right);
    }

    if ('$right' == 'false') {
      return or(_Code('$name == $end'), left);
    }

    if (mid == 1) {
      return or(_Code('$name == $end'), or(left, right));
    }

    return or(
        _Code('$name == $end'), triple(_Code('$name < $end'), left, right));
  }

  if (ranges.length < 4) {
    final allEqual = !ranges.any((e) => e.$1 != e.$2);
    if (allEqual) {
      if (!negate) {
        return ranges.map((e) => '$name == ${e.$1}').join(' || ');
      } else {
        return ranges.map((e) => '$name != ${e.$1}').join(' && ');
      }
    }
  }

  final result = process(name, ranges, 0, ranges.length - 1, {});
  if (!negate) {
    return '$result';
  }

  if (result is _Group) {
    return '!$result';
  }

  return '!($result)';
}

String render(String template, Map<String, String> values,
    {bool removeEmptyLines = true}) {
  for (final entry in values.entries) {
    final key = entry.key;
    final value = entry.value;
    template = template.replaceAll('{{$key}}', value);
  }

  final buffer = StringBuffer();
  final lines = const LineSplitter().convert(template);
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty && removeEmptyLines) {
      continue;
    }

    if (i < lines.length - 1) {
      buffer.writeln(line);
    } else {
      buffer.write(line);
    }
  }

  return buffer.toString();
}

String testLiteral({
  required List<int> codeUnits,
  required String end,
  required String input,
  String? start,
}) {
  if (codeUnits.isEmpty) {
    throw ArgumentError('Must not be empty', 'string');
  }

  final buffer = StringBuffer();
  buffer.write('state.pos');
  if (codeUnits.length - 1 > 0) {
    buffer.write(' + ${codeUnits.length - 1}');
  }

  buffer.write(' < $end &&');
  for (var i = 0; i < codeUnits.length; i++) {
    final char = codeUnits[i];
    var statePos = start == null ? 'state.pos' : 'state.pos - $start';
    if (i > 0) {
      statePos = '$statePos + $i';
    }

    buffer.write('$input.codeUnitAt($statePos) == $char');
    if (i < codeUnits.length - 1) {
      buffer.writeln(' &&');
    }
  }

  return buffer.toString();
}

class _Code extends _Expression {
  final String code;

  const _Code(this.code);

  @override
  String toString() {
    return code;
  }
}

abstract class _Expression {
  const _Expression();
}

class _Group extends _Expression {
  final _Expression expression;

  _Group(this.expression);

  @override
  String toString() {
    return '($expression)';
  }
}

class _Triple extends _Code {
  _Triple(super.code);
}

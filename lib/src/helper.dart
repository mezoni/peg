import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'binary_search/binary_search.dart';

String adjustStatePos(String variable, List<(int, int)> ranges, bool negate) {
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

List<((int, int), Set<T>)> makeTransitions<T>(Map<T, List<(int, int)>> map) {
  if (map.isEmpty) {
    return [];
  }

  if (map.values.any((e) => e.isEmpty)) {
    throw ArgumentError.value(
        map, 'map', 'Must not contain empty list of ranges');
  }

  _Transition<T> createTransition(int start, int end, Set<T> list) {
    return _ListEntry(((start, end), list));
  }

  bool intersect((int, int) r1, (int, int) r2) {
    return (r1.$1 <= r2.$1 && r1.$2 >= r2.$1) ||
        (r2.$1 <= r1.$1 && r2.$2 >= r1.$1);
  }

  final linkedList = LinkedList<_Transition<T>>();
  (_Transition<T>?, List<_Transition<T>>, _Transition<T>?) findTransitions(
      (int, int) range) {
    final list = <_Transition<T>>[];
    _Transition<T>? previous;
    _Transition<T>? next;
    for (final element in linkedList) {
      final r2 = element.value.$1;
      if (intersect(range, r2)) {
        list.add(element);
      } else if (r2.$1 > range.$2) {
        next = element;
        break;
      } else {
        previous = element;
      }
    }

    if (list.isNotEmpty) {
      previous = list.first.previous;
      next = list.last.next;
    }

    return (previous, list, next);
  }

  map = map.map((key, value) => MapEntry(key, normalizeRanges(value)));
  for (final key in map.keys) {
    final ranges = map[key]!;
    for (final range in ranges) {
      final found = findTransitions(range);
      final transitions = found.$2;
      final newTransitions = <_Transition<T>>[];
      var last = range.$1;
      for (final element in transitions) {
        final elementValue = element.value;
        final elementRange = elementValue.$1;
        final elementSet = elementValue.$2;
        if (last > elementRange.$1) {
          final end = min(range.$2, last - 1);
          final t = createTransition(elementRange.$1, end, {...elementSet});
          newTransitions.add(t);
          last = end + 1;
        } else if (last < elementRange.$1) {
          final end = min(range.$2, elementRange.$1 - 1);
          final t = createTransition(last, end, {key});
          newTransitions.add(t);
          last = end + 1;
        }

        final end = min(range.$2, elementRange.$2);
        final t = createTransition(last, end, {...elementSet, key});
        newTransitions.add(t);
        last = end + 1;
        if (last < elementRange.$2) {
          final t = createTransition(last, elementRange.$2, {...elementSet});
          newTransitions.add(t);
          last = elementRange.$2 + 1;
        }
      }

      if (last <= range.$2) {
        final t = createTransition(last, range.$2, {key});
        newTransitions.add(t);
      }

      final previous = found.$1;
      final next = found.$3;
      if (previous != null) {
        for (var i = newTransitions.length - 1; i >= 0; i--) {
          final t = newTransitions[i];
          previous.insertAfter(t);
        }
      } else {
        if (linkedList.isEmpty) {
          linkedList.addAll(newTransitions);
        } else if (next != null) {
          for (var i = newTransitions.length - 1; i >= 0; i--) {
            final t = newTransitions[i];
            next.insertBefore(t);
          }
        } else {
          linkedList.addAll(newTransitions);
        }
      }

      for (final element in transitions) {
        element.unlink();
      }
    }
  }

  return linkedList
      .map((e) => (
            e.value.$1,
            e.value.$2,
          ))
      .toList();
}

List<(int, int)> normalizeRanges(List<(int, int)> ranges) {
  final binarySearch = BinarySearch();
  final result = binarySearch.normalizeRanges(ranges);
  return result;
}

String rangesToPredicate(String name, List<(int, int)> ranges, bool negate) {
  final binarySearch = BinarySearch();
  final result = binarySearch.generatePredicate(name, ranges, negate);
  return result;
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
  required String current,
  required String index,
  required String input,
  required String length,
}) {
  if (codeUnits.isEmpty) {
    throw ArgumentError('Must not be empty', 'string');
  }

  final buffer = StringBuffer();
  buffer.write(current);
  if (codeUnits.length - 1 > 0) {
    buffer.write(' + ${codeUnits.length - 1}');
  }

  buffer.write(' < $length &&');
  for (var i = 0; i < codeUnits.length; i++) {
    final char = codeUnits[i];
    var offset = index;
    if (i > 0) {
      offset = '$offset + $i';
    }

    buffer.write('$input.codeUnitAt($offset) == $char');
    if (i < codeUnits.length - 1) {
      buffer.writeln(' &&');
    }
  }

  return buffer.toString();
}

typedef _Transition<T> = _ListEntry<((int, int), Set<T>)>;

final class _ListEntry<T> extends LinkedListEntry<_ListEntry<T>> {
  final T value;

  _ListEntry(this.value);
}

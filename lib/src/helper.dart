import 'dart:convert';

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

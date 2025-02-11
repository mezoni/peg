import 'dart:convert';

int calculateBitDepth(List<(int, int)> ranges) =>
    ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff) ? 32 : 16;

String conditional(String condition, String ifTrue, String ifFalse) {
  if (condition == 'true') {
    return ifTrue;
  }

  if (condition == 'false') {
    return ifFalse;
  }

  return '$condition ? $ifTrue : $ifFalse';
}

String escapeString(String text, [String? quote = '\'']) {
  if (quote != null && !((quote != '\'') || quote != '"')) {
    throw ArgumentError.value(quote, 'quote', 'Unknown quote');
  }

  text = text.replaceAll('\\', r'\\');
  text = text.replaceAll('\b', r'\b');
  text = text.replaceAll('\f', r'\f');
  text = text.replaceAll('\n', r'\n');
  text = text.replaceAll('\r', r'\r');
  text = text.replaceAll('\t', r'\t');
  text = text.replaceAll('\v', r'\v');
  text = text.replaceAll('\$', r'\$');
  if (quote == '\'') {
    text = text.replaceAll('\'', '\\\'');
  } else {
    text = text.replaceAll('"', "\\\"");
  }

  if (quote == null) {
    return text;
  }

  return '$quote$text$quote';
}

String getNullableType(String type) {
  if (isTypeNullable(type)) {
    return type;
  }

  return '$type?';
}

bool isTypeNullable(String type) {
  type = type.trim();
  return type.endsWith('?') ||
      type == 'dynamic' ||
      type == 'void' ||
      type == 'Null';
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

extension StringSinkExt on StringSink {
  void statement(String code) {
    writeln('$code;');
  }

  void ifStatement(String condition, void Function(StringBuffer block) f) {
    condition = condition.trim();
    if (condition.isEmpty) {
      throw ArgumentError('Must not be empty', 'condition');
    }

    if (condition == 'false') {
      return;
    }

    final buffer = StringBuffer();
    if (condition != 'true') {
      buffer.writeln('if ($condition) {');
    }

    f(buffer);
    if (condition != 'true') {
      buffer.writeln('}');
    }

    writeln(buffer);
  }
}

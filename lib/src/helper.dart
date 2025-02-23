import 'dart:convert';

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

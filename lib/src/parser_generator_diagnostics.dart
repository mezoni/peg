class ParserGeneratorDiagnostics {
  final List<ParserGeneratorMessage> errors = [];

  final List<ParserGeneratorMessage> warnings = [];

  bool get hasErrors => errors.isNotEmpty;

  ParserGeneratorMessage error(String text) {
    final message = ParserGeneratorMessage(text);
    errors.add(message);
    return message;
  }

  ParserGeneratorMessage warning(String text) {
    final message = ParserGeneratorMessage(text);
    warnings.add(message);
    return message;
  }
}

class ParserGeneratorMessage {
  final String text;

  final List<({String text, String details})> descriptions = [];

  ParserGeneratorMessage(this.text);

  void description(String text, String details) {
    descriptions.add((text: text, details: details));
  }

  @override
  String toString() {
    return '''
$text
${descriptions.map((e) => '${e.text}: ${e.details}').join('\n')}''';
  }
}

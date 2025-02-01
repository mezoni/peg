import 'package:source_span/source_span.dart';

import 'example.dart';

void main(List<String> args) {
  final strings = ['', '1`', '1+', '(1+', '(1'];

  for (final element in strings) {
    print('Input: \'$element\'');
    print('-' * 40);
    try {
      parse(element);
    } catch (e) {
      print(e);
      print('=' * 40);
    }
  }
}

int parse(String source) {
  final parser = CalcParser(const {});
  final state = State(source);
  final result = parser.parseStart(state);
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result as int;
}

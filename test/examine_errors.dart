import 'package:peg/src/grammar/grammar.dart';
import 'package:source_span/source_span.dart';

import '../bin/peg_parser.dart';

void main(List<String> args) {
  for (final element in _strings) {
    print('Input:$element');
    print('-' * 40);
    try {
      parse(element);
    } catch (e) {
      print(e);
      print('=' * 40);
    }
  }
}

Grammar parse(String source) {
  final parser = PegParser();
  final state = State(source);
  final result = parser.parseStart(state);
  if (!state.isSuccess) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result as Grammar;
}

final _strings = [
  '',
  '''

%{
''',
  '''

%{
}
''',
  '''

%%
''',
  '''
%%
%
''',
  '''

`int A =>
''',
  '''

A => B as
''',
  '''

A => <
''',
  '''

A => < B =>
''',
  '''

A => < B
''',
  '''

A => < B

C => D
''',
  '''

A => [
''',
  '''

A => []
''',
];

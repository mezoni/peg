import 'package:peg/src/peg_parser/peg_parser.dart' as peg_parser;

void main(List<String> args) {
  for (final element in _strings) {
    print('Input:$element');
    print('-' * 40);
    try {
      peg_parser.parse(element);
    } catch (e) {
      print(e);
      print('=' * 40);
    }
  }
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

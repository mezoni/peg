import 'package:peg/src/helper.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  test('makeTransitions', () {
    {
      final input = [
        ('a', (45, 45)),
        ('a', (48, 57)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (45, 45),
        ['a'],
        (48, 57),
        ['a'],
      ]);
    }

    {
      final input = [
        ('a', (0, 0)),
        ('b', (1, 1)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 0),
        ['a'],
        (1, 1),
        ['b'],
      ]);
    }

    {
      final input = [
        ('b', (1, 1)),
        ('a', (0, 0)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 0),
        ['a'],
        (1, 1),
        ['b'],
      ]);
    }

    {
      final input = [
        ('b', (10, 10)),
        ('a', (0, 0)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 0),
        ['a'],
        (10, 10),
        ['b'],
      ]);
    }

    {
      final input = [
        ('a', (50, 100)),
        ('b', (10, 15)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (10, 15),
        ['b'],
        (50, 100),
        ['a'],
      ]);
    }

    {
      final input = [
        ('a', (1, 100)),
        ('b', (0, 1)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 0),
        ['b'],
        (1, 1),
        ['a', 'b'],
        (2, 100),
        ['a'],
      ]);
    }

    {
      final input = [
        ('a', (0, 100)),
        ('b', (75, 85)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 74),
        ['a'],
        (75, 85),
        ['a', 'b'],
        (86, 100),
        ['a'],
      ]);
    }

    {
      final input = [
        ('a', (0, 100)),
        ('b', (75, 150)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 74),
        ['a'],
        (75, 100),
        ['a', 'b'],
        (101, 150),
        ['b'],
      ]);
    }
    {
      final input = [
        ('a', (0, 100)),
        ('b', (75, 150)),
        ('c', (125, 175)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 74),
        ['a'],
        (75, 100),
        ['a', 'b'],
        (101, 124),
        ['b'],
        (125, 150),
        ['b', 'c'],
        (151, 175),
        ['c']
      ]);
    }

    {
      final input = [
        ('a', (0, 100)),
        ('b', (75, 150)),
        ('b', (151, 152)),
        ('c', (125, 175)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (0, 74),
        ['a'],
        (75, 100),
        ['a', 'b'],
        (101, 124),
        ['b'],
        (125, 152),
        ['b', 'c'],
        (153, 175),
        ['c']
      ]);
    }

    {
      final input = [
        ('a', (76, 100)),
        ('b', (75, 150)),
        ('b', (151, 152)),
        ('c', (125, 175)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (75, 75),
        ['b'],
        (76, 100),
        ['a', 'b'],
        (101, 124),
        ['b'],
        (125, 152),
        ['b', 'c'],
        (153, 175),
        ['c']
      ]);
    }

    {
      final input = [
        ('d', (115, 116)),
        ('a', (76, 100)),
        ('b', (75, 150)),
        ('b', (151, 152)),
        ('c', (125, 175)),
      ];
      final result = _makeTransitions(input);
      expect(_flatten(result), [
        (75, 75),
        ['b'],
        (76, 100),
        ['a', 'b'],
        (101, 114),
        ['b'],
        (115, 116),
        ['d', 'b'],
        (117, 124),
        ['b'],
        (125, 152),
        ['b', 'c'],
        (153, 175),
        ['c']
      ]);
    }
  });
}

List<Object?> _flatten(List<((int, int), Set<Object>)> list) {
  Iterable<Object> g() sync* {
    for (final element in list) {
      yield element.$1;
      yield element.$2;
    }
  }

  return g().toList();
}

List<((int, int), Set<T>)> _makeTransitions<T>(List<(T, (int, int))> list) {
  final map = <T, List<(int, int)>>{};
  for (final element in list) {
    final key = element.$1;
    final value = element.$2;
    (map[key] ??= []).add(value);
  }

  return makeTransitions(map);
}

import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class OrderedChoiceGenerator
    extends ExpressionGenerator<OrderedChoiceExpression> {
  OrderedChoiceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final optimized = _OrderedChoiceOfLiterals.optimize(this);
    if (optimized != null) {
      return optimized;
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      for (final child in children) {
        ruleGenerator.setExpressionVariable(child, variable);
      }
    }

    final childSource = <String>[];
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final source = generateExpression(child, false);
      childSource.add(source);
    }

    var source = '';
    for (var i = children.length - 1; i >= 0; i--) {
      if (i < children.length - 1) {
        final values = <String, String>{};
        values['next'] = source;
        values['p'] = childSource[i];
        const template = '''
{{p}}
if (!state.ok && state.isRecoverable) {
  {{next}}
}''';
        source = render(template, values);
      } else {
        source = childSource[i];
      }
    }

    return source;
  }

  @override
  void generateAsync(BlockNode block) {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    void plunge(BlockNode block, int i) {
      final child = children[i];
      if (variable != null) {
        ruleGenerator.setExpressionVariable(child, variable);
      }

      generateAsyncExpression(block, child, false);
      if (i < children.length - 1) {
        block.if_('!state.ok && state.isRecoverable', (block) {
          plunge(block, i + 1);
        });
      }
    }

    plunge(block, 0);
  }
}

class _OrderedChoiceOfLiterals
    extends ExpressionGenerator<OrderedChoiceExpression> {
  final List<String> strings;

  _OrderedChoiceOfLiterals({
    required super.expression,
    required super.ruleGenerator,
    required this.strings,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final map = <int, List<String>>{};
    for (var i = 0; i < strings.length; i++) {
      final string = strings[i];
      final codeUnit = string.codeUnitAt(0);
      (map[codeUnit] ??= []).add(string);
    }

    final offset = allocateName();
    final pos = allocateName();
    final cases = <String>[];
    for (final entry in map.entries) {
      final key = entry.key;
      final strings = entry.value;
      String plunge(int i) {
        final values = <String, String>{};
        final value = strings[i];
        final string = allocateName();
        final text = helper.escapeString(value);
        values['length'] = value.length.toString();
        values['offset'] = offset;
        values['string'] = string;
        values['text'] = text;
        if (i < strings.length - 1) {
          values['next'] = plunge(i + 1);
          var template = '';
          if (variable != null) {
            values['r'] = variable;
            if (value.length == 1) {
              template = '''
{{offset}} = {{length}};
{{r}} = {{text}};''';
            } else if (value.length < 5) {
              values['test'] = helper.testLiteral(
                  codeUnits: value.codeUnits.sublist(1),
                  current: 'pos2',
                  index: 'pos2',
                  input: 'input',
                  length: 'input.length');
              template = '''
final ok = {{test}};
if (ok) {
  {{offset}} = {{length}};
  {{r}} = {{text}};
} else {
  {{next}}
}''';
            } else {
              template = '''
const {{string}} = {{text}};
final ok = input.startsWith({{string}}, state.pos);
if (ok) {
  {{offset}} = {{length}};
  {{r}} = {{string}};
} else {
  {{next}}
}''';
            }
          } else {
            if (value.length == 1) {
              template = '''
{{offset}} = {{length}};''';
            } else if (value.length < 5) {
              values['test'] = helper.testLiteral(
                  codeUnits: value.codeUnits.sublist(1),
                  current: 'pos2',
                  index: 'pos2',
                  input: 'input',
                  length: 'input.length');
              template = '''
final ok = {{test}};
if (ok) {
  {{offset}} = {{length}};
} else {
  {{next}}
}''';
            } else {
              template = '''
const {{string}} = {{text}};
final ok = input.startsWith({{string}}, state.pos);
if (ok) {
  {{offset}} = {{length}};
} else {
  {{next}}
}''';
            }
          }

          return render(template, values);
        }

        var template = '';
        if (variable != null) {
          values['r'] = variable;
          if (value.length == 1) {
            template = '''
{{offset}} = {{length}};
{{r}} = {{text}};''';
          } else if (value.length < 5) {
            values['test'] = helper.testLiteral(
              codeUnits: value.codeUnits.sublist(1),
              current: 'pos2',
              index: 'pos2',
              input: 'input',
              length: 'input.length',
            );
            template = '''
final ok = {{test}};
if (ok) {
  {{offset}} = {{length}};
  {{r}} = {{text}};
}''';
          } else {
            template = '''
const {{string}} = {{text}};
final ok = input.startsWith({{string}}, state.pos);
if (ok) {
  {{offset}} = {{length}};
  {{r}} = {{string}};
}''';
          }
        } else {
          if (value.length == 1) {
            template = '''
{{offset}} = {{length}};''';
          } else if (value.length < 5) {
            values['test'] = helper.testLiteral(
              codeUnits: value.codeUnits.sublist(1),
              current: 'pos2',
              index: 'pos2',
              input: 'input',
              length: 'input.length',
            );
            template = '''
final ok = {{test}};
if (ok) {
  {{offset}} = {{length}};
}''';
          } else {
            template = '''
const {{string}} = {{text}};
final ok = input.startsWith({{string}}, state.pos);
if (ok) {
  {{offset}} = {{length}};
}''';
          }
        }

        return render(template, values);
      }

      final values = <String, String>{};
      values['body'] = plunge(0);
      values['charCode'] = '$key';
      const template = '''
case {{charCode}}:
{{body}}
break;''';
      final code = render(template, values);
      cases.add(code);
    }

    values['pos'] = pos;
    values['offset'] = offset;
    values['cases'] = cases.join('\n');
    values['strings'] = strings.map(helper.escapeString).join(', ');
    const template = '''
final {{pos}} = state.pos;
var {{offset}} = 0;
if (state.pos < state.input.length) {
  final input = state.input;
  final c = input.codeUnitAt(state.pos);
  // ignore: unused_local_variable
  final pos2 = state.pos + 1;
  switch (c) {
    {{cases}}
  }
}
if ({{offset}} > 0) {
  state.pos += {{offset}};
  state.setOk(true);
} else {
  state.pos = {{pos}};
  state.fail(const ErrorExpectedTags([{{strings}}]));
}''';
    return render(template, values);
  }

  static String? optimize(OrderedChoiceGenerator generator) {
    final expression = generator.expression;
    final children = expression.expressions;
    final strings = <String>[];
    for (var i = 0; i < children.length; i++) {
      final sequence = children[i];
      if (sequence is! SequenceExpression) {
        return null;
      }

      if (sequence.action != null) {
        return null;
      }

      final elements = sequence.expressions;
      if (elements.length != 1) {
        return null;
      }

      final literal = elements[0];
      if (literal is! LiteralExpression) {
        return null;
      }

      if (!literal.caseSensitive) {
        return null;
      }

      final string = literal.string;
      if (string.isEmpty) {
        return null;
      }

      strings.add(string);
    }

    if (strings.length < 2) {
      return null;
    }

    final stringSet = strings.toSet();
    if (stringSet.length != strings.length) {
      stringSet.clear();
      final duplicates = <String>[];
      for (var i = 0; i < strings.length; i++) {
        final string = strings[i];
        if (!stringSet.add(string)) {
          duplicates.add(string);
        }
      }

      final rule = expression.rule;
      final text = <String>[];
      text.add('Duplicate literals in ordered choice.');
      text.add('Production rule: ${rule!.name}');
      text.add('Ordered choice: $expression');
      text.add('Duplicate literals:');
      text.add(duplicates.map(helper.escapeString).join(' '));
      print(text.join('\n'));
      return null;
    }

    final map = <int, List<String>>{};
    for (var i = 0; i < strings.length; i++) {
      final string = strings[i];
      final codeUnit = string.codeUnitAt(0);
      (map[codeUnit] ??= []).add(string);
    }

    var found = false;
    var invalid = <String>[];
    for (final list in map.values) {
      invalid = list;
      for (var i = 0; i < list.length; i++) {
        final first = list[i];
        for (var j = i + 1; j < list.length; j++) {
          final next = list[j];
          if (next.startsWith(first)) {
            found = true;
          }
        }
      }

      if (found) {
        final rule = expression.rule;
        final text = <String>[];
        text.add('Invalid order of literals in ordered choice.');
        text.add('Production rule: ${rule!.name}');
        text.add('Ordered choice: $expression');
        text.add('Invalid ordered literals:');
        text.add(invalid.map(helper.escapeString).join(' '));
        text.add('Expected order of literals:');
        text.add(invalid.reversed.map(helper.escapeString).join(' '));
        print(text.join('\n'));
        return null;
      }
    }

    final generator2 = _OrderedChoiceOfLiterals(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
      strings: strings,
    );
    return generator2.generate();
  }
}

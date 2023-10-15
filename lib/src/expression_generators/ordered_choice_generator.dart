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
  String generateAsync() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (children.length == 1) {
      final child = children[0];
      if (variable != null) {
        ruleGenerator.setExpressionVariable(child, variable);
      }

      return generateAsyncExpression(child, false);
    } else {
      final state = asyncGenerator.allocateVariable(GenericType(name: 'int'));
      final init = '$state = 0;';
      final buffer = StringBuffer();
      for (var i = 0; i < children.length; i++) {
        final values = <String, String>{};
        values['index'] = '$i';
        values['next_index'] = '${i + 1}';
        values['state'] = state;
        final child = children[i];
        if (variable != null) {
          ruleGenerator.setExpressionVariable(child, variable);
        }

        values['p'] = generateAsyncExpression(child, false);
        var template = '';
        if (i < children.length - 1) {
          template = '''
if ({{state}} == {{index}}) {
  {{p}}
  {{state}} = state.ok ? -1 : state.isRecoverable ? {{next_index}} : -1;
}''';
        } else {
          template = '''
if ({{state}} == {{index}}) {
  {{p}}
  {{state}} = -1;
}''';
        }

        final source = render(template, values);
        buffer.writeln(source);
      }

      return asyncGenerator.renderAction(
        buffer.toString(),
        buffering: false,
        init: init,
      );
    }
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

    final c = allocateName();
    final input = allocateName();
    final cases = <String>[];
    for (final entry in map.entries) {
      final key = entry.key;
      final strings = entry.value;
      String plunge(int i) {
        final values = <String, String>{};
        final value = strings[i];
        final string = allocateName();
        final text = helper.escapeString(value);
        values['string'] = string;
        values['input'] = input;
        values['text'] = text;
        if (i < strings.length - 1) {
          values['next'] = plunge(i + 1);
          var template = '';
          if (variable != null) {
            values['r'] = variable;
            if (value.length == 1) {
              template = '''
state.ok = true;
{{r}} = {{text}};''';
            } else if (value.length < 5) {
              final tests = <String>[];
              for (var i = 1; i < value.length; i++) {
                final char = value.codeUnitAt(i);
                final offset = i == 1 ? '' : '+ ${i - 1}';
                tests.add('$input.codeUnitAt(state.pos$offset) == $char');
              }

              values['adjust_state_pos'] = value.length == 2
                  ? 'state.pos++;'
                  : 'state.pos += ${value.length - 1};';
              values['offset'] =
                  value.length == 2 ? '' : ' + ${value.length - 2}';
              values['tests'] = tests.join('  &&\n');
              template = '''
state.ok = state.pos{{offset}} < {{input}}.length && {{tests}};
if (state.ok) {
  {{adjust_state_pos}}
  {{r}} = {{text}};
} else {
  {{next}}
}''';
            } else {
              values['size'] = (value.length - 1).toString();
              template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - 1);
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{string}};
} else {
  {{next}}
}''';
            }
          } else {
            if (value.length == 1) {
              template = '''
state.ok = true;''';
            } else if (value.length < 5) {
              final tests = <String>[];
              for (var i = 1; i < value.length; i++) {
                final char = value.codeUnitAt(i);
                final offset = i == 1 ? '' : '+ ${i - 1}';
                tests.add('$input.codeUnitAt(state.pos$offset) == $char');
              }

              values['adjust_state_pos'] = value.length == 2
                  ? 'state.pos++;'
                  : 'state.pos += ${value.length - 1};';
              values['offset'] =
                  value.length == 2 ? '' : ' + ${value.length - 2}';
              values['tests'] = tests.join('  &&\n');
              template = '''
state.ok = state.pos{{offset}} < {{input}}.length && {{tests}};
if (state.ok) {
  {{adjust_state_pos}}
} else {
  {{next}}
}''';
            } else {
              values['size'] = (value.length - 1).toString();
              template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - 1;
if (state.ok) {
  state.pos += {{size}};
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
state.ok = true;
{{r}} = {{text}};''';
          } else if (value.length < 5) {
            final tests = <String>[];
            for (var i = 1; i < value.length; i++) {
              final char = value.codeUnitAt(i);
              final offset = i == 1 ? '' : '+ ${i - 1}';
              tests.add('$input.codeUnitAt(state.pos$offset) == $char');
            }

            values['adjust_state_pos'] = value.length == 2
                ? 'state.pos++;'
                : 'state.pos += ${value.length - 1};';
            values['offset'] =
                value.length == 2 ? '' : ' + ${value.length - 2}';
            values['tests'] = tests.join('  &&\n');
            template = '''
state.ok = state.pos{{offset}} < {{input}}.length && {{tests}};
if (state.ok) {
  {{adjust_state_pos}}
  {{r}} = {{text}};
}''';
          } else {
            values['size'] = (value.length - 1).toString();
            template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - 1});
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{string}};
}''';
          }
        } else {
          if (value.length == 1) {
            template = '''
state.ok = true;''';
          } else if (value.length < 5) {
            final tests = <String>[];
            for (var i = 1; i < value.length; i++) {
              final char = value.codeUnitAt(i);
              final offset = i == 1 ? '' : '+ ${i - 1}';
              tests.add('$input.codeUnitAt(state.pos$offset) == $char');
            }

            values['adjust_state_pos'] = value.length == 2
                ? 'state.pos++;'
                : 'state.pos += ${value.length - 1};';
            values['offset'] =
                value.length == 2 ? '' : ' + ${value.length - 2}';
            values['tests'] = tests.join('  &&\n');
            template = '''
state.ok = state.pos{{offset}} < {{input}}.length && {{tests}};
if (state.ok) {
  {{adjust_state_pos}}
}''';
          } else {
            values['size'] = (value.length - 1).toString();
            template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - 1);
if (state.ok) {
  state.pos += {{size}};
}''';
          }
        }

        return render(template, values);
      }

      final values = <String, String>{};
      values['body'] = plunge(0);
      values['charCode'] = '$key';
      values['input'] = input;
      const template = '''
case {{charCode}}:
{{body}}
break;''';
      final code = render(template, values);
      cases.add(code);
    }

    values['c'] = c;
    values['cases'] = cases.join('\n');
    values['input'] = input;
    values['pos'] = allocateName();
    values['strings'] = strings.map(helper.escapeString).join(', ');
    const template = '''
final {{pos}} = state.pos;
state.ok = false;
final {{input}} = state.input;
if (state.pos < {{input}}.length) {
  final {{c}} = {{input}}.codeUnitAt(state.pos);
  state.pos++;
  switch ({{c}}) {
    {{cases}}
  }
}
if (!state.ok) {
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
    var orderedList = strings.toList();
    orderedList.sort();
    orderedList = orderedList.reversed.toList();
    for (var i = 0; i < orderedList.length; i++) {
      final string = orderedList[i];
      final codeUnit = string.codeUnitAt(0);
      (map[codeUnit] ??= []).add(string);
    }

    for (final entry in map.entries) {
      final codeUnit = entry.key;
      final list1 = entry.value;
      final list2 = strings.where((e) => e.codeUnitAt(0) == codeUnit).toList();
      for (var i = 0; i < list1.length; i++) {
        if (list1[i] != list2[i]) {
          final rule = expression.rule;
          final text = <String>[];
          text.add('Invalid order of literals in ordered choice.');
          text.add('Production rule: ${rule!.name}');
          text.add('Ordered choice: $expression');
          text.add('Invalid ordered literals:');
          text.add(list2.map(helper.escapeString).join(' '));
          text.add('Expected order of literals:');
          text.add(list1.map(helper.escapeString).join(' '));
          print(text.join('\n'));
          return null;
        }
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

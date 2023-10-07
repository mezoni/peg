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

    final optimized = _OrderedChoiceGenerator2.optimize(this);
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
if (!state.ok) {
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
  void generateAsync() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    if (children.length == 1) {
      final child = children[0];
      if (variable != null) {
        ruleGenerator.setExpressionVariable(child, variable);
      }

      generateAsyncExpression(child, false);
    } else {
      final endState = asyncGenerator.allocateState();
      for (var i = 0; i < children.length; i++) {
        final values = <String, String>{};
        final child = children[i];
        if (variable != null) {
          ruleGenerator.setExpressionVariable(child, variable);
        }

        generateAsyncExpression(child, false);
        values['end'] = endState;
        values['state'] = stateVariable;
        var template = '';
        if (i < children.length - 1) {
          template = '''
if (state.ok) {
  {{state}} = {{end}};
  break;
}''';
        } else {
          template = '''
{{state}} = {{end}};
break;''';
        }

        asyncGenerator.render(template, values);
      }

      asyncGenerator.beginState(endState);
    }
  }
}

class _OrderedChoiceGenerator2
    extends ExpressionGenerator<OrderedChoiceExpression> {
  final List<String> strings;

  _OrderedChoiceGenerator2({
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
      final runes = string.runes.toList();
      final charCode = runes[0];
      (map[charCode] ??= []).add(string);
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
        final runes = value.runes.toList();
        final string = allocateName();
        final text = helper.escapeString(value);
        final firstRuneSize = value.isEmpty
            ? 0
            : runes[0] > 0xffff
                ? 2
                : 1;
        values['string'] = string;
        values['input'] = input;
        values['text'] = text;
        if (i < strings.length - 1) {
          values['next'] = plunge(i + 1);
          var template = '';
          if (variable != null) {
            values['r'] = variable;
            if (runes.length == 1) {
              template = '''
state.ok = true;
{{r}} = {{text}};''';
            } else if (runes.length == 2) {
              final rune2 = runes[1];
              values['char'] = rune2.toString();
              values['size'] = (rune2 > 0xffff ? 2 : 1).toString();
              template = '''
state.ok = state.pos < {{input}}.length && {{input}}.runeAt(state.pos) == {{char}};
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{text}};
} else {
  {{next}}
}''';
            } else {
              values['offset'] = firstRuneSize.toString();
              values['size'] = (value.length - firstRuneSize).toString();
              template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - {{offset}});
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{string}};
} else {
  {{next}}
}''';
            }
          } else {
            if (runes.length == 1) {
              template = '''
state.ok = true;''';
            } else if (runes.length == 2) {
              final rune2 = runes[1];
              values['char'] = rune2.toString();
              values['size'] = (rune2 > 0xffff ? 2 : 1).toString();
              template = '''
state.ok = state.pos < {{input}}.length && {{input}}.runeAt(state.pos) == {{char}};
if (state.ok) {
  state.pos += {{size}};
} else {
  {{next}}
}''';
            } else {
              values['offset'] = firstRuneSize.toString();
              values['size'] = (value.length - firstRuneSize).toString();
              template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - {{offset}});
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
          if (runes.length == 1) {
            template = '''
state.ok = true;
{{r}} = {{text}};''';
          } else if (runes.length == 2) {
            final rune2 = runes[1];
            values['char'] = rune2.toString();
            values['size'] = (rune2 > 0xffff ? 2 : 1).toString();
            template = '''
state.ok = state.pos < {{input}}.length && {{input}}.runeAt(state.pos) == {{char}};
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{text}};
}''';
          } else {
            values['offset'] = firstRuneSize.toString();
            values['size'] = (value.length - firstRuneSize).toString();
            template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - {{offset}});
if (state.ok) {
  state.pos += {{size}};
  {{r}} = {{string}};
}''';
          }
        } else {
          if (runes.length == 1) {
            template = '''
state.ok = true;''';
          } else if (runes.length == 2) {
            final rune2 = runes[1];
            values['char'] = rune2.toString();
            values['size'] = (rune2 > 0xffff ? 2 : 1).toString();
            template = '''
state.ok = state.pos < {{input}}.length && {{input}}.runeAt(state.pos) == {{char}};
if (state.ok) {
  state.pos += {{size}};
}''';
          } else {
            values['offset'] = firstRuneSize.toString();
            values['size'] = (value.length - firstRuneSize).toString();
            template = '''
const {{string}} = {{text}};
state.ok = {{input}}.startsWith({{string}}, state.pos - {{offset}});
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
  final {{c}} = {{input}}.runeAt(state.pos);
  state.pos += {{c}} > 0xffff ? 2 : 1;
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

    final generator2 = _OrderedChoiceGenerator2(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
      strings: strings,
    );
    return generator2.generate();
  }
}

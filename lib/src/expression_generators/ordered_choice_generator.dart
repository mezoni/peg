import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class OrderedChoiceGenerator
    extends ExpressionGenerator<OrderedChoiceExpression> {
  static const _templateNext = '''
{{p}}
if (!state.ok) {
  {{next}}
}''';

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

    final optimized = _optimize();
    if (optimized != null) {
      return optimized;
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      for (final child in children) {
        ruleGenerator.setExpressionVariable(child, variable);
      }
    }

    String plunge(int i) {
      final values = <String, String>{};
      final child = children[i];
      if (i < children.length - 1) {
        values['next'] = plunge(i + 1);
        values['p'] = generateExpression(child, false);
        return render(_templateNext, values);
      }

      return generateExpression(child, false);
    }

    return plunge(0);
  }

  String? _optimize() {
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

    final generator = _OrderedChoiceWithLiteralsGenerator(
      expression: expression,
      ruleGenerator: ruleGenerator,
      strings: strings,
    );
    return generator.generate();
  }
}

class _OrderedChoiceWithLiteralsGenerator
    extends ExpressionGenerator<Expression> {
  static const _template = '''
state.ok = false;
final {{input}} = state.input;
if (state.pos < {{input}}.length) {
  final {{c}} = {{input}}.readChar(state.pos);
  // ignore: unused_local_variable
  final {{count}} = {{input}}.count;
  switch ({{c}}) {
    {{cases}}
  }
}
if (!state.ok) {
  state.fail(const ErrorExpectedTags([{{strings}}]));
}''';

  static const _templateCase = '''
case {{charCode}}:
{{body}}
break;''';

  static const _templateNext = '''
const {{string}} = {{text}};
state.ok = {{predicate}};
if (state.ok) {
  state.pos += {{input}}.count;
  {{r}} = {{string}};
} else {
  {{next}}
}''';

  static const _templateNextNoResult = '''
const {{string}} = {{text}};
state.ok = {{predicate}};
if (state.ok) {
  state.pos += {{input}}.count;
} else {
  {{next}}
}''';

  static const _templateLast = '''
const {{string}} = {{text}};
state.ok = {{predicate}};
if (state.ok) {
  state.pos += {{input}}.count;
  {{r}} = {{string}};
}''';

  static const _templateLastNoResult = '''
const {{string}} = {{text}};
state.ok = {{predicate}};
if (state.ok) {
  state.pos += {{input}}.count;
}''';

  static const _templateLastSingleChar = '''
state.ok = true;
state.pos += {{count}};
{{r}} = {{text}};''';

  static const _templateLastSingleCharNoResult = '''
state.ok = true;
state.pos += {{count}};''';

  final List<String> strings;

  _OrderedChoiceWithLiteralsGenerator({
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
    final count = allocateName();
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
        var predicate = '';
        if (value.length > 1) {
          predicate = '$input.startsWith($string, state.pos)';
        } else {
          predicate = 'true';
        }

        values['predicate'] = predicate;
        values['string'] = string;
        values['text'] = text;
        if (i < strings.length - 1) {
          values['next'] = plunge(i + 1);
          values['input'] = input;
          var template = '';
          if (variable != null) {
            values['r'] = variable;
            template = _templateNext;
          } else {
            template = _templateNextNoResult;
          }

          return render(template, values);
        }

        var template = '';
        if (variable != null) {
          values['r'] = variable;
          if (value.length == 1) {
            values['count'] = count;
            values['text'] = text;
            template = _templateLastSingleChar;
          } else {
            template = _templateLast;
          }
        } else {
          if (value.length == 1) {
            values['count'] = count;
            template = _templateLastSingleCharNoResult;
          } else {
            template = _templateLastNoResult;
          }
        }

        return render(template, values);
      }

      final values = <String, String>{};
      values['body'] = plunge(0);
      values['charCode'] = '$key';
      values['input'] = input;
      final code = render(_templateCase, values);
      cases.add(code);
    }

    values['c'] = c;
    values['cases'] = cases.join('\n');
    values['count'] = count;
    values['input'] = input;
    values['strings'] = strings.map(helper.escapeString).join(', ');
    return render(_template, values);
  }
}

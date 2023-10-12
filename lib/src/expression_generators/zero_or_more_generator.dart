import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class ZeroOrMoreGenerator extends ExpressionGenerator<ZeroOrMoreExpression> {
  ZeroOrMoreGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    if (variable == null) {
      final optimized1 = _ZeroOrMoreGenerator2.optimize(this);
      if (optimized1 != null) {
        return optimized1;
      }
    }

    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
}
state.setOk(true);''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    ({String name, String value})? key;
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(expression.resultType!);
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(child);
      values['rv'] = getExpressionVariableWithNullCheck(child);
      key = (name: values['list']!, value: '[]');
    }

    values['p'] = generateAsyncExpression(child, true);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    {{r1}} = null;
    break;
  }
  {{list}}!.add({{rv}});
  {{r1}} = null;
}
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}
{{list}} = null;''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
}
state.setOk(true);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
  }
}

class _ZeroOrMoreGenerator2 extends ExpressionGenerator<ZeroOrMoreExpression> {
  _ZeroOrMoreGenerator2({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    throw UnimplementedError();
  }

  String? generateTil(int charCode) {
    final values = <String, String>{};
    values['index'] = allocateName();
    values['text'] = allocateName();
    values['char'] = charCode.toString();
    values['string'] = helper.escapeString(String.fromCharCode(charCode));
    const template = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
state.ok = {{index}} != -1;
if (state.ok) {
  state.pos = {{index}};
} else {
  state.failAt(state.input.length, const ErrorExpectedCharacter({{char}}));
}''';
    return render(template, values);
  }

  String? generateUntil(String string) {
    final values = <String, String>{};
    values['index'] = allocateName();
    values['text'] = allocateName();
    values['string'] = helper.escapeString(string);
    const template = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
state.ok = {{index}} != -1;
if (state.ok) {
  state.pos = {{index}};
} else {
  state.failAt(state.input.length, const ErrorExpectedTags([{{text}}]));
}''';
    return render(template, values);
  }

  static String? optimize(ZeroOrMoreGenerator generator) {
    final expression = generator.expression;
    final group = expression.expression;
    if (group is! GroupExpression) {
      return null;
    }

    final choice = group.expression;
    if (choice is! OrderedChoiceExpression) {
      return null;
    }

    if (choice.expressions.length != 1) {
      return null;
    }

    final sequence = choice.expressions[0];
    if (sequence is! SequenceExpression) {
      return null;
    }

    if (sequence.action != null) {
      return null;
    }

    final children = sequence.expressions;
    if (children.length != 2) {
      return null;
    }

    final child2 = children[1];
    if (child2.semanticVariable == null) {
      return null;
    }

    final not = children[0];
    if (not is! NotPredicateExpression) {
      return null;
    }

    if (not.semanticVariable != null) {
      return null;
    }

    final terminal = not.expression;
    if (child2 is AnyCharacterExpression) {
      if (terminal is LiteralExpression) {
        final generator2 = _ZeroOrMoreGenerator2(
          expression: expression,
          ruleGenerator: generator.ruleGenerator,
        );

        return generator2.generateUntil(terminal.string);
      } else if (terminal is CharacterClassExpression) {
        final ranges = terminal.ranges;
        if (ranges.length == 1) {
          final range = ranges[0];
          final start = range.$1;
          final end = range.$2;
          if (start == end) {
            final generator2 = _ZeroOrMoreGenerator2(
              expression: expression,
              ruleGenerator: generator.ruleGenerator,
            );

            return generator2.generateTil(start);
          }
        }
      }
    }

    return null;
  }
}

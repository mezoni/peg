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
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable == null) {
      final optimized1 = _ZeroOrMoreGenerator2.optimize(this);
      if (optimized1 != null) {
        return optimized1;
      }

      final optimized2 = _ZeroOrMoreGenerator3.optimize(this);
      if (optimized2 != null) {
        return optimized2;
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
    state.ok = true;
    break;
  }
  {{list}}.add({{rv}});
}
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.ok) {
    state.ok = true;
    break;
  }
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final list = variable == null ? '' : allocateName();
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
      asyncGenerator.addVariable(list, expression.resultType!);
      asyncGenerator.writeln('$list = [];');
    }

    var state0 = asyncGenerator.currentState;
    if (!asyncGenerator.isEmptyState) {
      state0 = asyncGenerator.moveToNewState();
    }

    asyncGenerator.loopLevel++;

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, true);
    asyncGenerator.writeln('state.input.endBuffering(state.pos);');

    asyncGenerator.loopLevel--;
    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['state'] = stateVariable;
      values['state0'] = state0;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['list'] = list;
        values['rv'] = getExpressionVariableWithNullCheck(child);
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
{{list}}!.add({{rv}});
{{state}} = {{state0}};
break;''';
      } else {
        template = '''
if (!state.ok) {
  {{state}} = {{state1}};
  break;
}
{{state}} = {{state0}};
break;''';
      }

      asyncGenerator.render(template, values);
    }

    asyncGenerator.beginState(state1);
    if (variable != null) {
      asyncGenerator.writeln('$variable = $list;');
      asyncGenerator.writeln('$list = null;');
    }

    asyncGenerator.writeln('state.ok = true;');
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

class _ZeroOrMoreGenerator3 extends ExpressionGenerator<ZeroOrMoreExpression> {
  final CharacterClassExpression characterClass;

  _ZeroOrMoreGenerator3({
    required this.characterClass,
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final ranges = characterClass.ranges;
    final negate = characterClass.negate;
    final c = allocateName();
    values['c'] = c;
    values['predicate'] = helper.rangesToPredicate(c, ranges, negate);
    const template = '''
while (state.pos < state.input.length) {
  final {{c}} = state.input.readChar(state.pos);
  state.ok = {{predicate}};
  if (!state.ok) {
    break;
  }
  state.pos += state.input.count;
}
state.fail(const ErrorUnexpectedCharacter());
state.ok = true;''';
    return render(template, values);
  }

  static String? optimize(ZeroOrMoreGenerator generator) {
    final ruleGenerator = generator.ruleGenerator;
    final expression = generator.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      return null;
    }

    final child = expression.expression;
    if (child is! CharacterClassExpression) {
      return null;
    }

    return _ZeroOrMoreGenerator3(
      characterClass: child,
      expression: expression,
      ruleGenerator: ruleGenerator,
    ).generate();
  }
}

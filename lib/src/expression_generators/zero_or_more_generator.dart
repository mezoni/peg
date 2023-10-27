import '../async_generators/action_node.dart';
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
    var optimized = _TakeWhileGenerator.optimize(this);
    if (optimized != null) {
      return optimized;
    }

    if (variable == null) {
      optimized = _ZeroOrMoreGenerator3.optimize(this);
      if (optimized != null) {
        return optimized;
      }
    }

    values['is_optional'] = allocateName();
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
final {{is_optional}} = state.isOptional;
state.isOptional = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.isOptional = {{is_optional}};
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
final {{is_optional}} = state.isOptional;
state.isOptional = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
}
state.isOptional = {{is_optional}};
state.setOk(true);''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final isOptional = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;

      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$list = <$elementType>[];';
      block << '$isOptional = state.isOptional;';
      block << 'state.isOptional = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.isOptional = $isOptional;';
      block << 'state.setOk(true);';
      block.if_('state.ok', (block) {
        block << '$variable = $list;';
      });
    } else {
      block << '$isOptional = state.isOptional;';
      block << 'state.isOptional = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
      });
      block << 'state.isOptional = $isOptional;';
      block << 'state.setOk(true);';
    }
  }
}

class _TakeWhileGenerator extends ExpressionGenerator<ZeroOrMoreExpression> {
  _TakeWhileGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression as CharacterClassExpression;
    final ranges = child.ranges;
    final negate = child.negate;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      values['list'] = allocateName();
    }

    values['char_at'] = helper.charAt(ranges, negate);
    values['adjust_state_pos'] = helper.adjustStatePos('c', ranges, negate);
    values['predicate'] = helper.rangesToPredicate('c', ranges, negate);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{list}} = <int>[];
for (var c = 0;
    state.pos < state.input.length &&
    (c = state.input.{{char_at}}(state.pos)) == c && ({{predicate}});
    {{adjust_state_pos}},
    // ignore: curly_braces_in_flow_control_structures, empty_statements
    {{list}}.add(c));
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
for (var c = 0;
    state.pos < state.input.length &&
    (c = state.input.{{char_at}}(state.pos)) == c && ({{predicate}});
    // ignore: curly_braces_in_flow_control_structures, empty_statements
    {{adjust_state_pos}});
state.setOk(true);''';
    }

    return render(template, values);
  }

  static String? optimize(ZeroOrMoreGenerator generator) {
    final expression = generator.expression;
    final child = expression.expression;
    if (child is! CharacterClassExpression) {
      return null;
    }

    final generator2 = _TakeWhileGenerator(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
    );

    return generator2.generate();
  }
}

class _ZeroOrMoreGenerator3 extends ExpressionGenerator<ZeroOrMoreExpression> {
  _ZeroOrMoreGenerator3({
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
    values['ok'] = allocateName();
    values['text'] = allocateName();
    values['string'] = helper.escapeString(String.fromCharCode(charCode));
    const template = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
final {{ok}} = {{index}} != -1;
if ({{ok}}) {
  state.pos = {{index}};
  state.setOk(true);
} else {
  state.failAt(state.input.length, const ErrorUnexpectedCharacter());
}''';
    return render(template, values);
  }

  String? generateUntil(String string) {
    final values = <String, String>{};
    values['index'] = allocateName();
    values['ok'] = allocateName();
    values['text'] = allocateName();
    values['string'] = helper.escapeString(string);
    const template = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
final {{ok}} = {{index}} != -1;
if ({{ok}}) {
  state.pos = {{index}};
  state.setOk(true);
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
        final generator2 = _ZeroOrMoreGenerator3(
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
            final generator2 = _ZeroOrMoreGenerator3(
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

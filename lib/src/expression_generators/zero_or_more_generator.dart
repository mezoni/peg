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
    var optimized = _TakeWhileGenerator.optimize(this, null);
    if (optimized != null) {
      return optimized;
    }

    if (variable == null) {
      optimized = _ZeroOrMoreGenerator3.optimize(this);
      if (optimized != null) {
        return optimized;
      }
    }

    values['ignore_errors'] = allocateName();
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(child);
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
}
state.ignoreErrors = {{ignore_errors}};
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
    final optimized = _TakeWhileGenerator.optimize(this, block);
    if (optimized != null) {
      return;
    }

    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final ignoreErrors = asyncGenerator
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
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk(true);';
      block.if_('state.ok', (block) {
        block << '$variable = $list;';
      });
    } else {
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
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

  @override
  void generateAsync(BlockNode block) {
    final child = expression.expression as CharacterClassExpression;
    final ranges = child.ranges;
    final negate = child.negate;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final handle = asyncGenerator.functionName;
    final c = allocateName();
    final ok = allocateName();
    final predicate = helper.rangesToPredicate(c, ranges, negate);
    final input = allocateName();
    final label = allocateName();
    final adjustStatePos = helper.adjustStatePos(c, ranges, negate);
    final charAt = helper.charAt(ranges, negate);
    if (variable != null) {
      final elementType = child.resultType!;
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final done = allocateName();
      block << '$list = <$elementType>[];';
      block.label(label);
      block << 'final $input = state.input;';
      block << 'var $done = false;';
      block.while_('state.pos < $input.end', (block) {
        block << 'final $c = $input.data.$charAt(state.pos - $input.start);';
        block << 'final $ok = $predicate;';
        block.if_('!$ok', (block) {
          block << '$done = true;';
          block.break_();
        });
        block << '$adjustStatePos;';
        block << '$list.add($c);';
      });
      block.if_('!$done && !$input.isClosed', (block) {
        block << '$input.sleep = true;';
        block << '$input.handle = $handle;';
        block.return_(label);
      });
      block << 'state.setOk(true);';
      block.if_('state.ok', (block) {
        block << '$variable = $list;';
      });
    } else {
      final done = allocateName();
      block.label(label);
      block << 'final $input = state.input;';
      block << 'var $done = false;';
      block.while_('state.pos < $input.end', (block) {
        block << 'final $c = $input.data.$charAt(state.pos - $input.start);';
        block << 'final $ok = $predicate;';
        block.if_('!$ok', (block) {
          block << '$done = true;';
          block.break_();
        });
        block << '$adjustStatePos;';
      });
      block.if_('!$done && !$input.isClosed', (block) {
        block << '$input.sleep = true;';
        block << '$input.handle = $handle;';
        block.return_(label);
      });
      block << 'state.setOk(true);';
    }
  }

  static String? optimize(ZeroOrMoreGenerator generator, BlockNode? block) {
    final expression = generator.expression;
    final child = expression.expression;
    if (child is! CharacterClassExpression) {
      return null;
    }

    final generator2 = _TakeWhileGenerator(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
    );

    if (block == null) {
      return generator2.generate();
    }

    generator2.generateAsync(block);
    return '';
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

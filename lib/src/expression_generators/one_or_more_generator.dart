import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class OneOrMoreGenerator extends ExpressionGenerator<OneOrMoreExpression> {
  OneOrMoreGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final optimized = _TakeWhile1Generator.optimize(this, null);
    if (optimized != null) {
      return optimized;
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
while (true) {
  state.ignoreErrors = {{list}}.isNotEmpty;
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
if ({{list}}.isNotEmpty) {
  state.setOk(true);
  {{r}} = {{list}};
}''';
    } else {
      values['ok'] = allocateName();
      template = '''
var {{ok}} = false;
final {{ignore_errors}} = state.ignoreErrors;
while (true) {
  state.ignoreErrors = {{ok}};
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
state.ignoreErrors = {{ignore_errors}};
state.setOk({{ok}});''';
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
    final optimized = _TakeWhile1Generator.optimize(this, block);
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
      block.while_('true', (block) {
        block << 'state.ignoreErrors = $list.isNotEmpty;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block.if_('$list.isNotEmpty', (block) {
        block << 'state.setOk(true);';
        block << '$variable = $list;';
      });
    } else {
      final ok = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
          .name;
      block << '$ok = false;';
      block << '$ignoreErrors = state.ignoreErrors;';
      block.while_('true', (block) {
        block << 'state.ignoreErrors = $ok;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$ok = true;';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk($ok);';
    }
  }
}

class _TakeWhile1Generator extends ExpressionGenerator<OneOrMoreExpression> {
  _TakeWhile1Generator({
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
    } else {
      values['ok'] = allocateName();
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
if ({{list}}.isNotEmpty) {
  state.setOk(true);
  {{r}} = {{list}};
} else {
  state.pos < state.input.length
      ? state.fail(const ErrorUnexpectedCharacter())
      : state.fail(const ErrorUnexpectedEndOfInput());
}''';
    } else {
      template = '''
var {{ok}} = false;
for (var c = 0;
    state.pos < state.input.length &&
    (c = state.input.{{char_at}}(state.pos)) == c && ({{predicate}});
    {{adjust_state_pos}},
    // ignore: curly_braces_in_flow_control_structures, empty_statements
    {{ok}} = true);
if ({{ok}}) {
  state.setOk({{ok}});
} else {
  state.pos < state.input.length
      ? state.fail(const ErrorUnexpectedCharacter())
      : state.fail(const ErrorUnexpectedEndOfInput());
}''';
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
      block.if_('$list.isNotEmpty', (block) {
        block << '$variable = $list;';
        block << 'state.setOk(true);';
      }).else_((block) {
        block <<
            '$input.isClosed ? state.fail(const ErrorUnexpectedEndOfInput()): state.fail(const ErrorUnexpectedCharacter());';
      });
    } else {
      final count = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      final done = allocateName();
      block << '$count = 0;';
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
        block << '$count++;';
      });
      block.if_('!$done && !$input.isClosed', (block) {
        block << '$input.sleep = true;';
        block << '$input.handle = $handle;';
        block.return_(label);
      });
      block.if_('$count != 0', (block) {
        block << 'state.setOk(true);';
      }).else_((block) {
        block <<
            '$input.isClosed ? state.fail(const ErrorUnexpectedEndOfInput()): state.fail(const ErrorUnexpectedCharacter());';
      });
    }
  }

  static String? optimize(OneOrMoreGenerator generator, BlockNode? block) {
    final expression = generator.expression;
    final child = expression.expression;
    if (child is! CharacterClassExpression) {
      return null;
    }

    final generator2 = _TakeWhile1Generator(
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

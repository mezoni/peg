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
    final optimized = _TakeWhile1Generator.optimize(this);
    if (optimized != null) {
      return optimized;
    }

    values['errorCount'] = allocateName();
    values['minErrorCount'] = allocateName();
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
if ({{list}}.isNotEmpty) {
  state.setOk(true);
  {{r}} = {{list}};
}''';
    } else {
      values['ok'] = allocateName();
      template = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{ok}} = true;
}
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
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$list = <$elementType>[];';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block.if_('$list.isNotEmpty', (block) {
        block << 'state.setOk(true);';
        block << '$variable = $list;';
      });
    } else {
      final ok = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
          .name;
      block << '$ok = false;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$ok = true;';
      });
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

  static String? optimize(OneOrMoreGenerator generator) {
    final expression = generator.expression;
    final child = expression.expression;
    if (child is! CharacterClassExpression) {
      return null;
    }

    final generator2 = _TakeWhile1Generator(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
    );

    return generator2.generate();
  }
}

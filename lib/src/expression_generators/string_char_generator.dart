import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class StringCharsGenerator extends ExpressionGenerator<StringCharsExpression> {
  StringCharsGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final normalCharacters = expression.normalCharacters;
    final escapeCharacter = expression.escapeCharacter;
    final escape = expression.escape;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(normalCharacters);
      ruleGenerator.allocateExpressionVariable(escape);
    }

    final declareVariable = variable != null;
    values['p1'] = generateExpression(normalCharacters, declareVariable);
    values['p2'] = generateExpression(escapeCharacter, false);
    values['p3'] = generateExpression(escape, declareVariable);
    var template = '';
    if (variable != null) {
      values['list'] = allocateName();
      values['pos'] = allocateName();
      values['str'] = allocateName();
      values['r'] = variable;
      values['rv1'] = getExpressionVariableWithNullCheck(normalCharacters);
      values['rv3'] = getExpressionVariableWithNullCheck(escape);
      template = '''
List<String>? {{list}};
String? {{str}};
while (true) {
  {{p1}}
  if (state.ok) {
    final v = {{rv1}};
    if ({{str}} == null) {
      {{str}} = v;
    } else if ({{list}} == null) {
      {{list}} = [{{str}}, v];
    } else {
      {{list}}.add(v);
    }
  }
  final {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
  {{p3}}
  if (!state.ok) {
    state.backtrack({{pos}});
    break;
  }
  if ({{str}} == null) {
    {{str}} = {{rv3}};
  } else {
    if ({{list}} == null) {
      {{list}} = [{{str}}, {{rv3}}];
    } else {
      {{list}}.add({{rv3}});
    }
  }
}
state.setOk(true);
if ({{str}} == null) {
  {{r}} = '';
} else if ({{list}} == null) {
  {{r}} = {{str}};
} else {
  {{r}} = {{list}}.join();
}''';
    } else {
      values['pos'] = allocateName();
      template = '''
while (true) {
  {{p1}}
  final {{pos}} = state.pos;
  {{p2}}
  if (!state.ok) {
    break;
  }
  {{p3}}
  if (!state.ok) {
    state.backtrack({{pos}});
    break;
  }
}
state.setOk(true);''';
    }

    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final normalCharacters = expression.normalCharacters;
    final escapeCharacter = expression.escapeCharacter;
    final escape = expression.escape;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(normalCharacters);
      ruleGenerator.allocateExpressionVariable(escape);
    }

    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              type: GenericType(
                  name: 'List',
                  arguments: [GenericType(name: 'String')]).getNullableType())
          .name;
      final pos = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      final str = asyncGenerator
          .allocateVariable(type: GenericType(name: 'String').getNullableType())
          .name;
      final rv1 = getExpressionVariableWithNullCheck(normalCharacters);
      final rv3 = getExpressionVariableWithNullCheck(escape);
      block << '$list = null;';
      block << '$str = null;';
      block.while_('true', (block) {
        generateAsyncExpression(block, normalCharacters, true);
        block.if_('state.ok', (block) {
          block << 'final v = $rv1;';
          block.if_('$str == null', (block) {
            block << '$str = v;';
          }).else_((block) {
            block.if_('$list == null', (block) {
              block << '$list = [$str!, v];';
            }).else_((block) {
              block << '$list!.add(v);';
            });
          });
        });
        block << '$pos = state.pos;';
        generateAsyncExpression(block, escapeCharacter, false);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        generateAsyncExpression(block, escape, true);
        block.if_('!state.ok', (block) {
          block << 'state.backtrack($pos);';
          block.break_();
        });
        block.if_('$str == null', (block) {
          block << '$str = $rv3;';
        }).else_((block) {
          block.if_('$list == null', (block) {
            block << '$list = [$str!, $rv3];';
          }).else_((block) {
            block << '$list!.add($rv3);';
          });
        });
      });
      block << 'state.setOk(true);';
      block.if_('$str == null', (block) {
        block << '$variable = \'\';';
      }).else_((block) {
        block.if_('$list == null', (block) {
          block << '$variable = $str;';
        }).else_((block) {
          block << '$variable = $list!.join();';
        });
      });
    } else {
      final pos = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block.while_('true', (block) {
        generateAsyncExpression(block, normalCharacters, true);
        block << '$pos = state.pos;';
        generateAsyncExpression(block, escapeCharacter, false);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        generateAsyncExpression(block, escape, true);
        block.if_('!state.ok', (block) {
          block << 'state.backtrack($pos);';
          block.break_();
        });
      });
      block << 'state.setOk(true);';
    }
  }
}

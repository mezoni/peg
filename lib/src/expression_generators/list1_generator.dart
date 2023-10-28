import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generator.dart';

class List1Generator extends ExpressionGenerator<List1Expression> {
  List1Generator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final first = expression.first;
    final next = expression.next;
    if (variable != null) {
      values['O'] = first.resultType.toString();
      values['list'] = allocateName();
      ruleGenerator.allocateExpressionVariable(first);
      ruleGenerator.allocateExpressionVariable(next);
      values['r'] = variable;
      values['rv1'] = getExpressionVariableWithNullCheck(first);
      values['rv2'] = getExpressionVariableWithNullCheck(next);
    } else {
      values['ok'] = allocateName();
    }

    values['ignore_errors'] = allocateName();
    values['pos'] = allocateName();
    values['p1'] = generateExpression(first, true);
    values['p2'] = generateExpression(next, true);
    var template = '';
    if (variable != null) {
      template = '''
final {{list}} = <{{O}}>[];
{{p1}}
if (state.ok) {
  {{list}}.add({{rv1}});
  final {{ignore_errors}} = state.ignoreErrors;
  state.ignoreErrors = true;
  while (true) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{list}}.add({{rv2}});
  }
  state.ignoreErrors = {{ignore_errors}};
}
state.setOk({{list}}.isNotEmpty);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
var {{ok}} = false;
{{p1}}
if (state.ok) {
  {{ok}} = true;
  final {{ignore_errors}} = state.ignoreErrors;
  state.ignoreErrors = true;
  while (true) {
    {{p2}}
    if (!state.ok) {
      break;
    }
  }
  state.ignoreErrors = {{ignore_errors}};
}
state.setOk({{ok}});''';
    }

    return render(template, values);
  }

  @override
  void generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final first = expression.first;
    final next = expression.next;
    final elementType = first.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(first);
      ruleGenerator.allocateExpressionVariable(next);
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
      final r = variable;
      final rv1 = getExpressionVariableWithNullCheck(first);
      final rv2 = getExpressionVariableWithNullCheck(next);
      block << '$list = [];';
      generateAsyncExpression(block, first, true);
      block.if_('state.ok', (block) {
        block << '$list.add($rv1);';
        block << '$ignoreErrors = state.ignoreErrors;';
        block << 'state.ignoreErrors = true;';
        block.while_('true', (block) {
          generateAsyncExpression(block, next, true);
          block.if_('!state.ok', (block) {
            block.break_();
          });
          block << '$list.add($rv2);';
        });
        block << 'state.ignoreErrors = $ignoreErrors;';
      });
      block << 'state.setOk($list.isNotEmpty);';
      block.if_('state.ok', (block) {
        block << '$r = $list;';
      });
    } else {
      final ok = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
          .name;
      block << '$ok = false;';
      generateAsyncExpression(block, first, true);
      block.if_('state.ok', (block) {
        block << '$ok = true;';
        block << '$ignoreErrors = state.ignoreErrors;';
        block << 'state.ignoreErrors = true;';
        block.while_('true', (block) {
          generateAsyncExpression(block, next, true);
          block.if_('!state.ok', (block) {
            block.break_();
          });
        });
        block << 'state.ignoreErrors = $ignoreErrors;';
      });
      block << 'state.setOk($ok);';
    }
  }
}

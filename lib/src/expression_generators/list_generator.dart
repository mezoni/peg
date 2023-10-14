import '../expressions/expressions.dart';
import 'expression_generator.dart';

class ListGenerator extends ExpressionGenerator<ListExpression> {
  ListGenerator({
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
    }

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
  while (true) {
    {{p2}}
    if (!state.ok) {
      break;
    }
    {{list}}.add({{rv2}});
  }
}
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
{{p1}}
if (state.ok) {
  while (true) {
    {{p2}}
    if (!state.ok) {
      break;
    }
  }
}
state.setOk(true);''';
    }

    return render(template, values);
  }

  @override
  String generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final first = expression.first;
    final next = expression.next;
    final elementType = first.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    values['state'] = asyncGenerator.allocateVariable(GenericType(name: 'int'));
    if (variable != null) {
      values['list'] = asyncGenerator.allocateVariable(
          GenericType(name: 'List', arguments: [elementType]));
      values['r'] = variable;
      values['r1'] = ruleGenerator.allocateExpressionVariable(first);
      values['r2'] = ruleGenerator.allocateExpressionVariable(next);
      values['rv1'] = getExpressionVariableWithNullCheck(first);
      values['rv2'] = getExpressionVariableWithNullCheck(next);
    }

    values['pos'] = pos;
    values['p1'] = generateExpression(first, true);
    values['p2'] = generateExpression(next, true);
    final key = (name: pos, value: 'state.pos');
    final initList = [
      '{{state}} = 0;',
      if (variable != null) '{{list}} = [];',
    ];

    final init = render(initList.join('\n'), values);
    var template = '';
    if (variable != null) {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      break;
    }
    {{list}}!.add({{rv1}});
    {{r1}} = null;
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      {{state}} = -1;
      break;
    }
    {{list}}!.add({{rv2}});
    {{r2}} = null;
  }
}
state.setOk(true);
if (state.ok) {
  {{r}} = {{list}};
  {{list}} = null;
}''';
    } else {
      template = '''
while (true) {
  if ({{state}} == 0) {
    {{p1}}
    if (!state.ok) {
      break;
    }
    {{state}} = 1;
  }
  if ({{state}} == 1) {
    {{p2}}
    if (!state.ok) {
      {{state}} = -1;
      break;
    }
  }
}
state.setOk(true);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
      init: init,
    );
  }
}

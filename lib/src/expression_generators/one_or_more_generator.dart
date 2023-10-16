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
state.setOk({{list}}.isNotEmpty);
if (state.ok) {
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
    } else {
      values['ok'] = asyncGenerator.allocateVariable(GenericType(name: 'bool'));
      key = (name: values['ok']!, value: 'false');
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
state.setOk({{list}}!.isNotEmpty);
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
  {{ok}} = true;
}
state.setOk({{ok}}!);''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
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
    values['assign_state_pos'] = helper.assignStatePos('c', ranges, negate);
    values['predicate'] = helper.rangesToPredicate('c', ranges, negate);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{list}} = <int>[];
for (var c = 0;
    state.pos < state.input.length &&
    (c = state.input.{{char_at}}(state.pos)) == c && ({{predicate}});
    {{assign_state_pos}},
    // ignore: curly_braces_in_flow_control_structures, empty_statements
    {{list}}.add(c));
state.pos < state.input.length
    ? state.fail(const ErrorUnexpectedCharacter())
    : state.fail(const ErrorUnexpectedEndOfInput());
state.ok = {{list}}.isNotEmpty;
if (state.ok) {
  {{r}} = {{list}};
}''';
    } else {
      template = '''
var {{ok}} = false;
for (var c = 0;
    state.pos < state.input.length &&
    (c = state.input.{{char_at}}(state.pos)) == c && ({{predicate}});
    {{assign_state_pos}},
    // ignore: curly_braces_in_flow_control_structures, empty_statements
    {{ok}} = true);
state.pos < state.input.length
    ? state.fail(const ErrorUnexpectedCharacter())
    : state.fail(const ErrorUnexpectedEndOfInput());
state.ok = {{ok}};''';
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

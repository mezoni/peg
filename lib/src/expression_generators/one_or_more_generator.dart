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
    if (variable == null) {
      final optimized1 = _OneOrMoreGenerator2.optimize(this);
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
state.ok = {{list}}.isNotEmpty;
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
state.ok = {{ok}};''';
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

    values['p'] = asyncGenerator
        .forceBuffering(() => generateAsyncExpression(child, true));
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
state.ok = {{list}}!.isNotEmpty;
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
state.ok = {{ok}}!;''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      key: key,
    );
  }
}

class _OneOrMoreGenerator2 extends ExpressionGenerator<OneOrMoreExpression> {
  final CharacterClassExpression characterClass;

  _OneOrMoreGenerator2({
    required this.characterClass,
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final ranges = characterClass.ranges;
    final negate = characterClass.negate;
    final isChar =
        !negate && ranges.length == 1 && ranges[0].$1 == ranges[0].$2;
    final c = allocateName();
    values['c'] = c;
    values['char_at'] = helper.charAt(ranges, negate);
    values['input'] = allocateName();
    values['pos'] = allocateName();
    values['predicate'] = helper.rangesToPredicate(c, ranges, negate);
    values['assign_state_pos'] = helper.assignStatePos(c, ranges, negate);
    if (isChar) {
      final char = ranges[0].$1;
      values['error'] = 'const ErrorExpectedCharacter($char)';
    } else {
      values['error'] = 'const ErrorUnexpectedCharacter()';
    }

    const template = '''
final {{pos}} = state.pos;
final {{input}} = state.input;
while (state.pos < {{input}}.length) {
  final {{c}} = {{input}}.{{char_at}}(state.pos);
  state.ok = {{predicate}};
  if (!state.ok) {
    break;
  }
  {{assign_state_pos}}
}
state.fail({{error}});
state.ok = state.pos > {{pos}};''';
    return render(template, values);
  }

  static String? optimize(OneOrMoreGenerator generator) {
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

    return _OneOrMoreGenerator2(
      characterClass: child,
      expression: expression,
      ruleGenerator: ruleGenerator,
    ).generate();
  }
}

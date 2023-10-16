import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class CharacterClassGenerator
    extends ExpressionGenerator<CharacterClassExpression> {
  CharacterClassGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final ranges = expression.ranges;
    final negate = expression.negate;
    if (ranges.length == 1 && !negate) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        return _generateChar(range.$1);
      }
    }

    return _generate(ranges, negate);
  }

  @override
  String generateAsync() {
    final ranges = expression.ranges;
    final negate = expression.negate;
    int? char;
    if (ranges.length == 1 && !negate) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        char = range.$1;
      }
    }

    if (char == null) {
      return _generateAsync();
    } else {
      return _generateAsyncChar(char);
    }
  }

  String _generate(List<(int, int)> ranges, bool negate) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final c = allocateName();
    values['c'] = c;
    values['assign_state_pos'] = helper.assignStatePos(c, ranges, negate);
    values['char_at'] = helper.charAt(ranges, negate);
    values['predicate'] = helper.rangesToPredicate(c, ranges, negate);
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
state.ok = state.pos < state.input.length;
if (state.ok) {
  final {{c}} = state.input.{{char_at}}(state.pos);
  state.ok = {{predicate}};
  if (state.ok) {
    {{assign_state_pos}};
    {{assign_result}}
  }
}
if (!state.ok) {
  state.fail(const ErrorUnexpectedCharacter());
}''';
    return render(template, values);
  }

  String _generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final ranges = expression.ranges;
    final negate = expression.negate;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final c = allocateName();
    values['c'] = c;
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    values['assign_state_pos'] = helper.assignStatePos(c, ranges, negate);
    values['char_at'] = helper.charAt(ranges, negate);
    values['predicate'] = helper.rangesToPredicate(c, ranges, negate);
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
      values['clear_result'] = '$variable = null;';
    } else {
      values['assign_result'] = '';
      values['clear_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
{{clear_result}}
state.ok = state.pos < {{input}}.end;
if (state.ok) {
  final {{c}} = {{input}}.data.{{char_at}}(state.pos - {{input}}.start);
  state.ok = {{predicate}};
  if (state.ok) {
    {{assign_state_pos}};
    {{assign_result}}
  }
}
if (!state.ok) {
  state.fail(const ErrorUnexpectedCharacter());
}''';

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }

  String _generateAsyncChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['char'] = '$char';
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    values['char_at'] = helper.charAt([(char, char)], false);
    values['adjust_state_pos'] =
        helper.assignStatePos('$char', [(char, char)], false);
    if (variable != null) {
      values['assign_result'] = '$variable = $char;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
state.ok = state.pos < {{input}}.end &&
  {{input}}.data.{{char_at}}(state.pos - {{input}}.start) == {{char}};
if (state.ok) {
  {{adjust_state_pos}};
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedCharacter());
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }

  String _generateChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['char'] = '$char';
    values['char_at'] = helper.charAt([(char, char)], false);
    values['adjust_state_pos'] =
        helper.assignStatePos('$char', [(char, char)], false);
    if (variable != null) {
      values['assign_result'] = '$variable = $char;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
state.ok = state.pos < state.input.length &&
    state.input.{{char_at}}(state.pos) == {{char}};
if (state.ok) {
  {{adjust_state_pos}};
  {{assign_result}}
} else {
  state.fail(const ErrorUnexpectedCharacter());
}''';

    return render(template, values);
  }
}

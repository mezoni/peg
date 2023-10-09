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
    {{assign_state_pos}}
    {{assign_result}}
  } else {
    state.fail(const ErrorUnexpectedCharacter());
  }
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
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
    values['read_char_async'] = helper.readCharAsync(ranges, negate);
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
final {{c}} = {{read_char_async}}(state);
{{clear_result}}
switch ({{c}}) {
  case null:
    {{input}}.sleep = true;
    {{input}}.handle = {{handle}};
    return;
  case >= 0:
    state.ok = {{predicate}};
    if (state.ok) {
      {{assign_state_pos}}
      {{assign_result}}
    } else {
      state.fail(const ErrorUnexpectedCharacter());
    }
}''';

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
    );
  }

  String _generateAsyncChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    values['char'] = '$char';
    values['handle'] = asyncGenerator.functionName;
    values['input'] = allocateName();
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchCharAsync(state, {{char}}, const ErrorExpectedCharacter({{char}}));
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
    );
  }

  String _generateChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final is32Bit = char > 0xffff;
    values['char'] = '$char';
    if (variable != null) {
      values['assign_result'] = '$variable = $char;';
    } else {
      values['assign_result'] = '';
    }

    var template = '';
    if (is32Bit) {
      template = '''
state.ok = state.pos < state.input.length && state.input.runeAt(state.pos) == {{char}};
if (state.ok) {
  state.pos += 2;
  {{assign_result}}
} else {
  state.fail(const ErrorExpectedCharacter({{char}}));
}''';
    } else {
      template = '''
state.ok = state.pos < state.input.length && state.input.codeUnitAt(state.pos) == {{char}};
if (state.ok) {
  state.pos++;
  {{assign_result}}
} else {
  state.fail(const ErrorExpectedCharacter({{char}}));
}''';
    }

    return render(template, values);
  }
}

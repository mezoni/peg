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
  void generateAsync() {
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
      _generateAsync();
    } else {
      _generateAsyncChar(char);
    }
  }

  String _generate(List<(int, int)> ranges, bool negate) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final c = allocateName();
    final predicate = helper.rangesToPredicate(c, ranges, negate);
    values['c'] = c;
    values['predicate'] = predicate;
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
state.ok = state.pos < state.input.length;
if (state.ok) {
  final {{c}} = state.input.runeAt(state.pos);
  state.ok = {{predicate}};
  if (state.ok) {
    state.pos += {{c}} > 0xffff ? 2 : 1;
    {{assign_result}}
  } else {
    state.fail(const ErrorUnexpectedCharacter());
  }
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';
    return render(template, values);
  }

  void _generateAsync() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final ranges = expression.ranges;
    final negate = expression.negate;

    {
      asyncGenerator.writeln('state.input.beginBuffering();');
      asyncGenerator.moveToNewState();
    }

    {
      final values = <String, String>{};
      values['handle'] = asyncGenerator.functionName;
      values['input'] = allocateName();
      values['predicate'] = helper.rangesToPredicate('c', ranges, negate);
      if (variable != null) {
        values['assign_result'] = '$variable = c;';
        values['clear_result'] = '$variable = null;';
      } else {
        values['assign_result'] = '';
        values['clear_result'] = '';
      }

      const template = '''
final {{input}} = state.input;
if (state.pos + 1 < {{input}}.end || {{input}}.isClosed) {
  {{clear_result}}
  state.ok = state.pos < {{input}}.end;
  if (state.pos >= {{input}}.start) {
    if (state.ok) {
      final c = {{input}}.data.runeAt(state.pos - {{input}}.start);
      state.ok = {{predicate}};
      if (state.ok) {
        state.pos += c > 0xffff ? 2 : 1;
        {{assign_result}}
      } else {
        state.fail(const ErrorUnexpectedCharacter());
      }
    } else {
      state.fail(const ErrorUnexpectedEndOfInput());
    }
  } else {
    state.fail(ErrorBacktracking(state.pos));
  }
  {{input}}.endBuffering(state.pos);
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncChar(int char) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;

    {
      asyncGenerator.writeln('state.input.beginBuffering();');
      asyncGenerator.moveToNewState();
    }

    {
      final values = <String, String>{};
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
if (state.pos + 1 < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchCharAsync(state, {{char}}, const ErrorExpectedCharacter({{char}}));
  state.input.endBuffering(state.pos);
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
      asyncGenerator.render(template, values);
    }
  }

  String _generateChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['char'] = '$char';
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
{{assign_result}}matchChar(state, {{char}}, const ErrorExpectedCharacter({{char}}));''';
    return render(template, values);
  }
}

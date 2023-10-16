import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class LiteralGenerator extends ExpressionGenerator<LiteralExpression> {
  LiteralGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    if (!expression.caseSensitive) {
      throw StateError('Case sensitive literal expression is not implemented');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final string = expression.string;
    if (string.isEmpty) {
      return _generateEmptyString(variable);
    } else if (string.length < 9) {
      return _generateShortString(string, variable);
    }

    return _generate(string, variable);
  }

  @override
  String generateAsync() {
    final string = expression.string;
    if (string.isEmpty) {
      return _generateAsyncEmptyString();
    } else if (string.length < 9) {
      return _generateAsyncShortString();
    } else {
      return _generateAsync();
    }
  }

  String _generate(String string, String? variable) {
    final values = <String, String>{};
    values['literal'] = allocateName();
    values['char'] = string.codeUnitAt(0).toString();
    values['string'] = helper.escapeString(string);
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
const {{literal}} = {{string}};
state.ok = state.pos < state.input.length &&
    state.input.codeUnitAt(state.pos) == {{char}} &&
    state.input.startsWith({{literal}}, state.pos);
if (state.ok) {
  {{adjust_state_pos}};
  {{r}} = {{literal}};
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    } else {
      template = '''
const {{literal}} = {{string}};
state.ok = state.pos < state.input.length &&
    state.input.codeUnitAt(state.pos) == {{char}} &&
    state.input.startsWith({{literal}}, state.pos);
state.ok ? {{adjust_state_pos}} : state.fail(const ErrorExpectedTags([{{literal}}]));''';
    }

    return render(template, values);
  }

  String _generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    values['input'] = allocateName();
    values['string'] = allocateName();
    values['pos'] = allocateName();
    values['handle'] = asyncGenerator.functionName;
    values['char'] = string.codeUnitAt(0).toString();
    values['literal'] = helper.escapeString(string);
    values['offset'] = (string.length - 1).toString();
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{input}} = state.input;
if (state.pos + {{offset}} >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
const {{string}} = {{literal}};
final {{pos}} = state.pos - {{input}}.start;
state.ok = state.pos < {{input}}.end &&
  {{input}}.data.codeUnitAt({{pos}}) == {{char}} &&
  {{input}}.data.startsWith({{string}}, {{pos}});
if (state.ok) {
  {{adjust_state_pos}};
  {{r}} = {{string}};
} else {
  state.fail(const ErrorExpectedTags([{{string}}]));
}''';
    } else {
      template = '''
final {{input}} = state.input;
if (state.pos + {{offset}} >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
const {{string}} = {{literal}};
final {{pos}} = state.pos - {{input}}.start;
state.ok = state.pos < {{input}}.end &&
  {{input}}.data.codeUnitAt({{pos}}) == {{char}} &&
  {{input}}.data.startsWith({{string}}, {{pos}});
state.ok ? {{adjust_state_pos}} : state.fail(const ErrorExpectedTags([{{literal}}]));''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }

  String _generateAsyncEmptyString() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      values['assign_result'] = '$variable = \'\';';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
state.ok = true;
{{assign_result}}''';
    return render(template, values);
  }

  String _generateAsyncShortString() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input = allocateName();
    values['handle'] = asyncGenerator.functionName;
    values['input'] = input;
    values['string'] = helper.escapeString(string);
    values['literal'] = allocateName();
    values['test'] = helper.testLiteral(
      codeUnits: string.codeUnits,
      end: '$input.end',
      input: '$input.data',
      start: '$input.start',
    );
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    if (string.length > 1) {
      values['size'] = ' + ${string.length - 1}';
    } else {
      values['size'] = '';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{input}} = state.input;
if (state.pos{{size}} >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
const {{literal}} = {{string}};
state.ok = {{test}};
if (state.ok) {
  {{r}} = {{literal}};
  {{adjust_state_pos}};
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    } else {
      template = '''
final {{input}} = state.input;
if (state.pos{{size}} >= {{input}}.end && !{{input}}.isClosed) {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}
const {{literal}} = {{string}};
state.ok = {{test}};
state.ok ? {{adjust_state_pos}} : state.fail(const ErrorExpectedTags([{{literal}}]));''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
    );
  }

  String _generateEmptyString(String? variable) {
    final values = <String, String>{};
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
state.ok = true;
if (state.ok) {
  {{r}} = '';
}''';
    } else {
      template = '''
state.ok = true;''';
    }
    return render(template, values);
  }

  String _generateShortString(String string, String? variable) {
    final values = <String, String>{};
    final literal = allocateName();
    values['literal'] = literal;
    values['string'] = helper.escapeString(string);
    values['test'] = helper.testLiteral(
      codeUnits: string.codeUnits,
      end: 'state.input.length',
      input: 'state.input',
    );
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
const {{literal}} = {{string}};
state.ok = {{test}};
if (state.ok) {
  {{r}} = {{literal}};
  {{adjust_state_pos}};
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    } else {
      template = '''
const {{literal}} = {{string}};
state.ok = {{test}};
state.ok ? {{adjust_state_pos}} : state.fail(const ErrorExpectedTags([{{literal}}]));''';
    }

    return render(template, values);
  }
}

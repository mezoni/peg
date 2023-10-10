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
    } else if (string.length == 1 || string.length == 2) {
      return _generateString1(string, variable);
    }

    return _generate(string, variable);
  }

  @override
  String generateAsync() {
    final string = expression.string;
    if (string.isEmpty) {
      return _generateAsyncEmptyString();
    } else if (string.length == 1 || string.length == 2) {
      return _generateAsyncString1();
    } else {
      return _generateAsync();
    }
  }

  String _generate(String string, String? variable) {
    final values = <String, String>{};
    final char = string.codeUnitAt(0);
    final literal = allocateName();
    values['char'] = '$char';
    values['length'] = string.length.toString();
    values['literal'] = literal;
    values['string'] = helper.escapeString(string);
    values['char'] = '$char';
    if (variable != null) {
      values['assign_result'] = '$variable = $literal;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
const {{literal}} = {{string}};
state.ok = state.pos < state.input.length &&
    state.input.codeUnitAt(state.pos) == {{char}} &&
    state.input.startsWith({{literal}}, state.pos);
if (state.ok) {
  state.pos += {{length}};
  {{assign_result}}
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';

    return render(template, values);
  }

  String _generateAsync() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input = allocateName();
    values['handle'] = asyncGenerator.functionName;
    values['input'] = input;
    values['length'] = string.length.toString();
    values['literal'] = helper.escapeString(string);
    values['offset'] = (string.length - 1).toString();
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
final {{input}} = state.input;
if (state.pos + {{offset}} < {{input}}.end || {{input}}.isClosed) {
  const string = {{literal}};
  {{assign_result}}matchLiteralAsync(state, string, const ErrorExpectedTags([string]));
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

  String _generateAsyncString1() {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input = allocateName();
    values['handle'] = asyncGenerator.functionName;
    values['input'] = input;
    values['string'] = helper.escapeString(string);
    values['literal'] = allocateName();
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    var template = '';
    if (string.length == 1) {
      template = '''
const {{literal}} = {{string}};
final {{input}} = state.input;
if (state.pos < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchLiteral1Async(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
    } else {
      template = '''
const {{literal}} = {{string}};
final {{input}} = state.input;
if (state.pos + 1 < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchLiteral2Async(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: asyncGenerator.buffering == 0,
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

  String _generateString1(String string, String? variable) {
    final values = <String, String>{};
    final literal = allocateName();
    values['literal'] = literal;
    values['string'] = helper.escapeString(string);
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    var template = '';
    if (string.length == 1) {
      template = '''
const {{literal}} = {{string}};
{{assign_result}}matchLiteral1(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';
    } else {
      template = '''
const {{literal}} = {{string}};
{{assign_result}}matchLiteral2(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';
    }

    return render(template, values);
  }
}

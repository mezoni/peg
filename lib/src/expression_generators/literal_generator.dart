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
    final runes = string.runes.toList();
    if (string.isEmpty) {
      return _generateEmptyString(variable);
    } else if (runes.length == 1) {
      return _generateString1(string, variable);
    }

    return _generate(string, variable);
  }

  @override
  void generateAsync() {
    final string = expression.string;
    final runes = string.runes.toList();
    if (string.isEmpty) {
      _generateAsyncEmptyString();
    } else if (runes.length == 1) {
      _generateAsyncString1();
    } else {
      _generateAsync();
    }
  }

  String _generate(String string, String? variable) {
    final values = <String, String>{};
    values['literal'] = allocateName();
    values['string'] = helper.escapeString(string);
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
const {{literal}} = {{string}};
{{assign_result}}matchLiteral(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';
    return render(template, values);
  }

  void _generateAsync() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input = allocateName();

    {
      asyncGenerator.writeln('state.input.beginBuffering();');
      asyncGenerator.moveToNewState();
    }

    {
      final values = <String, String>{};
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
  {{input}}.endBuffering(state.pos);
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncEmptyString() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    asyncGenerator.writeln('state.ok = true;');
    if (variable != null) {
      asyncGenerator.writeln('$variable = \'\';');
    }
  }

  void _generateAsyncString1() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final runes = string.runes.toList();
    final input = allocateName();

    {
      asyncGenerator.writeln('state.input.beginBuffering();');
      asyncGenerator.moveToNewState();
    }

    {
      final values = <String, String>{};
      values['char'] = runes[0].toString();
      values['handle'] = asyncGenerator.functionName;
      values['input'] = input;
      values['literal'] = helper.escapeString(string);
      if (variable != null) {
        values['assign_result'] = '$variable = ';
      } else {
        values['assign_result'] = '';
      }

      const template = '''
final {{input}} = state.input;
if (state.pos + 1 < {{input}}.end || {{input}}.isClosed) {
  {{assign_result}}matchLiteral1Async(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));
  {{input}}.endBuffering(state.pos);
} else {
  {{input}}.sleep = true;
  {{input}}.handle = {{handle}};
  return;
}''';
      asyncGenerator.render(template, values);
    }
  }

  String _generateEmptyString(String? variable) {
    final values = <String, String>{};
    values['r'] = variable ?? '';
    var template = '';
    if (variable != null) {
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
    final runes = string.runes.toList();
    values['char'] = runes[0].toString();
    values['literal'] = allocateName();
    values['string'] = helper.escapeString(string);
    if (variable != null) {
      values['assign_result'] = '$variable = ';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
const {{literal}} = {{string}};
{{assign_result}}matchLiteral1(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';
    return render(template, values);
  }
}

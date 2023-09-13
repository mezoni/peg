import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class LiteralGenerator extends ExpressionGenerator<LiteralExpression> {
  static const _template = '''
const {{literal}} = {{string}};
{{r}} = matchLiteral(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _templateNoResult = '''
const {{literal}} = {{string}};
matchLiteral(state, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _templateOneCharString = '''
const {{literal}} = {{string}};
{{r}} = matchLiteral1(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _templateOneCharStringNoResult = '''
const {{literal}} = {{string}};
matchLiteral1(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _templateEmptyString = '''
state.ok = true;
if (state.ok) {
  {{r}} = '';
''';

  static const _templateEmptyStringNoResult = '''
state.ok = true;''';

  LiteralGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final string = expression.string;
    if (string.isEmpty) {
      return _generateEmptyString(variable);
    } else if (string.length == 1) {
      return _generateOneCharString(string, variable);
    }

    return _generateString(string, variable);
  }

  String _generateEmptyString(String? variable) {
    final values = <String, String>{};
    values['r'] = variable ?? '';
    final template =
        variable != null ? _templateEmptyString : _templateEmptyStringNoResult;
    return render(template, values);
  }

  String _generateOneCharString(String string, String? variable) {
    final values = <String, String>{};
    final char = string.codeUnitAt(0);
    values['char'] = '$char';
    values['literal'] = allocateName();
    values['string'] = helper.escapeString(string);
    values['r'] = variable ?? '';
    final template = variable != null
        ? _templateOneCharString
        : _templateOneCharStringNoResult;
    return render(template, values);
  }

  String _generateString(String string, String? variable) {
    final values = <String, String>{};
    values['literal'] = allocateName();
    values['string'] = helper.escapeString(string);
    values['r'] = variable ?? '';
    final template = variable != null ? _template : _templateNoResult;
    return render(template, values);
  }
}

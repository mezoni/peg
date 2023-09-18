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

  static const _template1 = '''
const {{literal}} = {{string}};
{{r}} = matchLiteral1(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _template1NoResult = '''
const {{literal}} = {{string}};
matchLiteral1(state, {{char}}, {{literal}}, const ErrorExpectedTags([{{literal}}]));''';

  static const _template0String = '''
state.ok = true;
if (state.ok) {
  {{r}} = '';
}''';

  static const _template0NoResult = '''
state.ok = true;''';

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
    } else if (string.length == 1) {
      return _generateString1(string, variable);
    }

    return _generateString(string, variable);
  }

  String _generateEmptyString(String? variable) {
    final values = <String, String>{};
    values['r'] = variable ?? '';
    final template = variable != null ? _template0String : _template0NoResult;
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

  String _generateString1(String string, String? variable) {
    final values = <String, String>{};
    final runes = string.runes.toList();
    values['char'] = runes[0].toString();
    values['literal'] = allocateName();
    values['string'] = helper.escapeString(string);
    values['r'] = variable ?? '';
    final template = variable != null ? _template1 : _template1NoResult;
    return render(template, values);
  }
}

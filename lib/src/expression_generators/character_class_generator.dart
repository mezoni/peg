import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class CharacterClassGenerator
    extends ExpressionGenerator<CharacterClassExpression> {
  static const _template = '''
state.ok = state.pos < state.input.length;
if (state.ok) {
  final {{c}} = state.input.readChar(state.pos);
  state.ok = {{predicate}};
  if (state.ok) {
    state.pos += state.input.count;
    {{r}} = {{c}};
  }
}
if (!state.ok) {
  state.fail(const ErrorUnexpectedCharacter());
}''';

  static const _templateNoResult = '''
state.ok = state.pos < state.input.length;
if (state.ok) {
  final {{c}} = state.input.readChar(state.pos);
  state.ok = {{predicate}};
  if (state.ok) {
    state.pos += state.input.count;
  }
}
if (!state.ok) {
  state.fail(const ErrorUnexpectedCharacter());
}''';

  static const _templateChar = '''
matchChar(state, {{char}}, const ErrorUnexpectedCharacter({{char}}));
if (state.ok) {
  {{r}} = {{char}};
}''';

  static const _templateCharNoResult = '''
matchChar(state, {{char}}, const ErrorUnexpectedCharacter({{char}}));''';

  // ignore: unused_field
  static const _templateCharAsync = '''
final result = AsyncResult<int>();
final input = state.input;
void parse() {
  final data = input.data;
  final c = data.readChar(state.pos);
  state.ok = c == {{char}};
  if (state.ok) {
    state.pos += data.count;
    result.value = c;
  } else {
    state.fail(const ErrorExpectedCharacter({{char}}));
  }
  result.isComplete = true;
}

if (state.pos < input.data.end) {
  parse();
  return result;
}
if (input.closed) {
  result.isComplete = true;
  state.fail(const ErrorExpectedCharacter({{char}}));
  return result;
}
input.handle = parse;
return result;''';

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

  String _generate(List<(int, int)> ranges, bool negate) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final c = allocateName();
    final predicate = helper.rangesToPredicate(c, ranges, negate);
    values['c'] = c;
    values['predicate'] = predicate;
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = _templateNoResult;
    }

    return render(template, values);
  }

  String _generateChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['char'] = '$char';
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _templateChar;
    } else {
      template = _templateCharNoResult;
    }

    return render(template, values);
  }
}

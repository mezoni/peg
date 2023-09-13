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
state.ok = state.input.matchChar({{char}}, state.pos);
if (state.ok) {
  state.pos += state.input.count;
  {{r}} = {{char}};
} else {
  state.fail(const ErrorExpectedCharacter({{char}}));
}''';

  static const _templateCharNoResult = '''
state.ok = state.input.matchChar({{char}}, state.pos);
if (state.ok) {
  state.pos += state.input.count;
} else {
  state.fail(const ErrorExpectedCharacter({{char}}));
}''';

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

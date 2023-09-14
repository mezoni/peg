import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class SliceGenerator extends ExpressionGenerator<SliceExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  {{r}} = state.input.substring({{pos}}, state.pos);
}''';

  static const _templateUntil = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
state.ok = {{index}} != -1;
if (state.ok) {
  final {{substring}} = state.input.substring(state.pos, {{index}});
  state.pos = {{index}};
  {{r}} = {{substring}};
} else {
  state.failAt(state.input.length, const ErrorUnexpectedEndOfInput());
}''';

  static const _templateUntilNoResult = '''
const {{text}} = {{string}};
final {{index}} = state.input.indexOf({{text}}, state.pos);
state.ok = {{index}} != -1;
if (state.ok) {
  state.pos = {{index}};
} else {
  state.failAt(state.input.length, const ErrorUnexpectedEndOfInput());
}''';

  SliceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final optimized = _optimize(variable);
    if (optimized != null) {
      return optimized;
    }

    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }

  String? _optimize(String? variable) {
    final zeroOrMore = expression.expression;
    if (zeroOrMore is! ZeroOrMoreExpression) {
      return null;
    }

    final group = zeroOrMore.expression;
    if (group is! GroupExpression) {
      return null;
    }

    final choice = group.expression;
    if (choice is! OrderedChoiceExpression) {
      return null;
    }

    if (choice.expressions.length != 1) {
      return null;
    }

    final sequence = choice.expressions[0];
    if (sequence is! SequenceExpression) {
      return null;
    }

    final children = sequence.expressions;
    if (children.length != 2) {
      return null;
    }

    final child2 = children[1];
    final not = children[0];
    if (not is! NotPredicateExpression) {
      return null;
    }

    final terminal = not.expression;
    if (child2 is AnyCharacterExpression) {
      if (terminal is LiteralExpression) {
        return _optimizeToUntil(variable, terminal.string);
      } else if (terminal is CharacterClassExpression) {
        final ranges = terminal.ranges;
        if (ranges.length == 1) {
          final range = ranges[0];
          final start = range.$1;
          final end = range.$2;
          if (start == end) {
            final string = String.fromCharCode(start);
            return _optimizeToUntil(variable, string);
          }
        }
      }
    }

    return null;
  }

  String? _optimizeToUntil(String? variable, String string) {
    final values = <String, String>{};
    values['index'] = allocateName();
    values['text'] = allocateName();
    values['string'] = helper.escapeString(string);
    var template = '';
    if (variable != null) {
      values['substring'] = allocateName();
      values['r'] = variable;
      template = _templateUntil;
    } else {
      template = _templateUntilNoResult;
    }

    return render(template, values);
  }
}

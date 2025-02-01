import '../binary_search_generator/matcher_generator.dart';
import '../helper.dart' as helper;
import 'expression.dart';

class OneOrMoreExpression extends SingleExpression {
  OneOrMoreExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOneOrMore(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    var childVariable = '';
    if (variable != null) {
      childVariable = context.allocateExpressionVariable(expression);
    } else {
      if (expression case final CharacterClassExpression expression) {
        return _generateTakeWhile1(context, expression);
      }
    }

    final p = expression.generate(context);
    final values = {
      'p': p,
    };
    var template = '';
    if (variable != null) {
      values.addAll({
        'E': expression.getResultType(),
        'r1': childVariable,
        'list': context.allocate('list'),
        'rv1': expression.getResultValue(childVariable),
        'variable': variable,
      });
      template = '''
final {{list}} = <{{E}}>[];
while (true) {
  {{p}}
  if (!state.isSuccess) {
    break;
  }
  {{list}}.add({{rv1}});
}
if (state.isSuccess = {{list}}.isNotEmpty) {
  {{variable}} = {{list}};
}''';
    } else {
      values['ok'] = context.allocate();
      template = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if (!state.isSuccess) {
    break;
  }
  {{ok}} = true;
}
state.isSuccess = {{ok}};''';
    }

    return render(context, this, template, values);
  }

  String _generateTakeWhile1(
      ProductionRuleContext context, CharacterClassExpression child) {
    const pos = Expression.positionVariableKey;
    final ranges = helper.normalizeRanges(child.ranges, child.negate);
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    final matcher = MatcherGenerator().generate('c', ranges);
    final values = {
      'predicate': matcher,
    };
    var template = '';
    if (is32Bit) {
      template = '''
while (state.position < state.input.length) {
  final c = state.input.readChar(state.position);
  state.isSuccess = {{predicate}};
  if (!state.isSuccess) {
    break;
  }
  state.position += c > 0xffff ? 2 : 1;
}
if (!(state.isSuccess = {{$pos}} != state.position)) {
  state.fail();
}''';
    } else {
      template = '''
while (state.position < state.input.length) {
  final c = state.input.codeUnitAt(state.position);
  state.isSuccess = {{predicate}};
  if (!state.isSuccess) {
    break;
  }
  state.position++;
}
if (!(state.isSuccess = {{$pos}} != state.position)) {
  state.fail();
}''';
    }

    return render(context, this, template, values);
  }
}

import '../binary_search_generator/matcher_generator.dart';
import '../helper.dart' as helper;
import 'expression.dart';

class ZeroOrMoreExpression extends SingleExpression {
  ZeroOrMoreExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitZeroOrMore(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    var childVariable = '';
    if (variable != null) {
      childVariable = context.allocateExpressionVariable(expression);
    } else {
      if (expression case final CharacterClassExpression expression) {
        return _generateTakeWhile(context, expression);
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
{{variable}} = (state.isSuccess = true) ? {{list}} : null;''';
    } else {
      template = '''
while (true) {
  {{p}}
  if (!state.isSuccess) {
    break;
  }
}
state.isSuccess = true;''';
    }

    return render(context, this, template, values);
  }

  String _generateTakeWhile(
      ProductionRuleContext context, CharacterClassExpression child) {
    final ranges = helper.normalizeRanges(child.ranges, child.negate);
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    final matcher = MatcherGenerator().generate('c', ranges);
    final values = {
      'predicate': matcher,
    };
    var template = '';
    if (is32Bit) {
      template = '''
state.skip32While((int c) => {{predicate}});''';
    } else {
      template = '''
state.skip16While((int c) => {{predicate}});''';
    }

    return render(context, this, template, values);
  }
}

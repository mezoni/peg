import 'package:simple_sparse_list/ranges_helper.dart';

import '../binary_search_generator/matcher_generator.dart';
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
    final ranges = normalizeRanges(child.ranges);
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    final matcher =
        MatcherGenerator().generate('c', ranges, negate: child.negate);
    final values = {
      'predicate': matcher,
    };
    var template = '';
    if (is32Bit) {
      template = '''
state.skip32While1((int c) => {{predicate}});''';
    } else {
      template = '''
state.skip16While1((int c) => {{predicate}});''';
    }

    return render(context, this, template, values);
  }
}

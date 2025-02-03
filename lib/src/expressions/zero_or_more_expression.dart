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
    final isResultUsed = context.getExpressionResultUsage(this);
    context.copyExpressionResultUsage(this, expression);
    if (!isResultUsed) {
      if (expression case final CharacterClassExpression expression) {
        return _generateSkipWhile(context, expression);
      }
    }

    final r = context.allocateExpressionVariable(expression);
    final values = {
      'E': expression.getResultType(),
      'p': expression.generate(context),
      'r': r,
    };
    var template = '';
    if (isResultUsed) {
      final list = context.allocate('list');
      final assignment = assignResult(context, 'state.opt(($list,))');
      values.addAll({
        'list': list,
      });
      template = '''
final {{list}} = <{{E}}>[];
while (true) {
  {{p}}
  if ({{r}} == null) {
    break;
  }
  {{list}}.add({{r}}.\$1);
}
$assignment''';
    } else {
      final assignment = assignResult(context, 'state.opt((const <{{E}}>[],))');
      template = '''
while (true) {
  {{p}}
  if ({{r}} == null) {
    break;
  }
}
$assignment''';
    }

    return render(context, this, template, values);
  }

  String _generateSkipWhile(
      ProductionRuleContext context, CharacterClassExpression child) {
    final ranges = child.ranges;
    final bitDepth = helper.bitDepth(ranges);
    var predicate =
        MatcherGenerator().generate('c', ranges, negate: child.negate);
    predicate = '(int c) => $predicate';
    final template =
        assignResult(context, 'state.skip${bitDepth}While($predicate)');
    return render(context, this, template, const {});
  }
}

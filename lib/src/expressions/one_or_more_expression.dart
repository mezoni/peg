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
    final isResultUsed = context.getExpressionResultUsage(this);
    context.copyExpressionResultUsage(this, expression);
    if (!isResultUsed) {
      if (expression case final CharacterClassExpression expression) {
        return _generateSkipWhile1(context, expression);
      }
    }

    final r = context.allocateExpressionVariable(expression);
    final values = {
      'p': expression.generate(context),
      'r': r,
    };
    var template = '';
    if (isResultUsed) {
      final list = context.allocate('list');
      final assignment =
          assignResult(context, '$list.isNotEmpty ? ($list,) : null');
      values.addAll({
        'E': expression.getResultType(),
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
      final ok = context.allocate('ok');
      final assignment = assignResult(context, '$ok ? (null],) : null');
      values['ok'] = ok;
      template = '''
var {{ok}} = false;
while (true) {
  {{p}}
  if ({{r}} == null) {
    break;
  }
  {{ok}} = true;
}
$assignment''';
    }

    return render(context, this, template, values);
  }

  String _generateSkipWhile1(
      ProductionRuleContext context, CharacterClassExpression child) {
    final ranges = child.ranges;
    final bitDepth = helper.bitDepth(ranges);
    var predicate =
        MatcherGenerator().generate('c', ranges, negate: child.negate);
    predicate = '(int c) => $predicate';
    final template =
        assignResult(context, 'state.skip${bitDepth}While1($predicate)');
    return render(context, this, template, const {});
  }
}

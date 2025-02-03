import '../binary_search_generator/matcher_generator.dart';
import '../helper.dart' as helper;
import 'expression.dart';

class CharacterClassExpression extends Expression {
  final bool negate;

  final List<(int, int)> ranges;

  CharacterClassExpression({
    this.negate = false,
    required this.ranges,
  }) {
    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCharacterClass(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final bitDepth = helper.bitDepth(ranges);
    if (ranges.length == 1) {
      final range = ranges[0];
      if (range.$1 == range.$2 && !negate) {
        final template =
            assignResult(context, 'state.matchChar$bitDepth(${range.$1})');
        return render(context, this, template, const {});
      }
    }

    var predicate =
        const MatcherGenerator().generate('c', ranges, negate: negate);
    predicate = '(int c) => $predicate';
    final template =
        assignResult(context, 'state.matchChars$bitDepth($predicate)');
    return render(context, this, template, const {});
  }
}

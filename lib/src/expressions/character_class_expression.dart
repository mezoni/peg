import '../binary_search_generator/matcher_generator.dart';
import '../helper.dart';
import 'build_context.dart';

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
  String generate(BuildContext context, Variable? variable, bool isFast) {
    if (ranges.length == 1) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        return generate1(context, variable, isFast, range.$1);
      }
    }

    final sink = preprocess(context);
    final c = context.allocate();
    final predicate =
        const MatcherGenerator().generate(c, ranges, negate: negate);
    final value =
        conditional(predicate, '(state.advance(),)', 'state.fail<int>()');
    sink.statement('final $c = state.peek()');
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String generate1(
      BuildContext context, Variable? variable, bool isFast, int char) {
    final sink = preprocess(context);
    final condition =
        negate ? 'state.peek() != $char' : 'state.peek() == $char';
    final value =
        conditional(condition, '(state.advance(),)', 'state.fail<int>()');
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }
}

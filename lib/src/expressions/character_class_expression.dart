import '../binary_search_generator/matcher_generator.dart';
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
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    if (ranges.length == 1) {
      final range = ranges.first;
      if (range.$1 == range.$2) {
        _generate1(context, result, range.$1);
        return;
      }
    }

    _generate(context, result);
  }

  void _generate(BuildContext context, BuildResult result) {
    final code = result.code;
    final c = context.allocate();
    code.assign(c, 'state.peek()', 'final');
    final predicate =
        const MatcherGenerator().generate(c, ranges, negate: negate);
    final branch = code.branch(predicate);
    branch.truth.block((code) {
      code.statement('state.position += state.charSize($c)');
    });

    branch.falsity.block((code) {
      code.statement('state.fail()');
    });

    if (result.isUsed) {
      result.value = Value(c);
    }

    result.postprocess(this);
  }

  void _generate1(BuildContext context, BuildResult result, int char) {
    final code = result.code;
    final adjustPosition = 'state.position += state.charSize($char)';
    if (negate) {
      final c = context.allocate();
      code.assign(c, 'state.peek()', 'final');
      final branch = code.branch('$c != $char');
      branch.truth.block((b) {
        b.statement(adjustPosition);
      });

      branch.falsity.block((b) {
        b.statement('state.fail()');
      });
    } else {
      final branch = code.branch('state.peek() == $char');
      branch.truth.block((b) {
        b.statement(adjustPosition);
      });

      branch.falsity.block((b) {
        b.statement('state.fail()');
      });
    }

    if (result.isUsed) {
      result.value = Value('$char', isConst: true);
    }

    result.postprocess(this);
  }
}

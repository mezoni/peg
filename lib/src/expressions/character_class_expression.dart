import 'package:simple_sparse_list/ranges_helper.dart';

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
    final ranges = normalizeRanges(this.ranges);
    final bitDepth = calculateBitDepth(ranges);
    if (ranges.length == 1) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        final char = range.$1;
        return _generate1(context, variable, bitDepth, char);
      }
    }

    return _generate(context, variable, bitDepth);
  }

  String _generate(BuildContext context, Variable? variable, int bitDepth) {
    final sink = preprocess(context);
    final result = context.allocate('');
    final position = getSharedValue(context, 'state.position');
    final predicate =
        const MatcherGenerator().generate('c', ranges, negate: negate);
    sink.writeln('''
(int,)? $result;
if (state.position < state.length) {
  final c = state.nextChar$bitDepth();
  final ok = $predicate;
  $result = ok ? (c,) : null;
  $result ?? (state.position = $position);
}''');

    final value = '$result ?? state.fail<int>()';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String _generate1(
      BuildContext context, Variable? variable, int bitDepth, int char) {
    final sink = preprocess(context);
    final result = context.allocate('');
    final position = getSharedValue(context, 'state.position');
    final op = negate ? '!=' : '==';
    sink.writeln('''
(int,)? $result;
if (state.position < state.length) {
  final c = state.nextChar$bitDepth();
  $result = c $op $char ? ($char,) : null;
  $result ?? (state.position = $position);
}''');

    final value = '$result ?? state.fail<int>()';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }
}

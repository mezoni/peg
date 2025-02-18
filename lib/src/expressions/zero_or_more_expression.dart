import '../binary_search_generator/matcher_generator.dart';
import '../helper.dart';
import 'build_context.dart';

class ZeroOrMoreExpression extends SingleExpression {
  ZeroOrMoreExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitZeroOrMore(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final optimized = _optimize(context, variable, isFast);
    if (optimized != null) {
      return optimized;
    }

    final sink = preprocess(context);
    isFast = isFastOrVoid(isFast);
    var list = '';
    final childVariable = context.allocateVariable();
    final elementType = expression.getResultType();
    if (!isFast) {
      list = context.allocate('list');
      sink.statement('final $list = <$elementType>[]');
    }

    sink.writeln('while (true) {');
    sink.writeln(expression.generate(context, childVariable, isFast));
    final isFailure = expression.getStateTest(childVariable, false);
    sink.ifStatement(isFailure, (block) {
      block.statement('break');
    });
    if (!isFast) {
      sink.statement('$list.add($childVariable.\$1)');
    }

    sink.writeln('}');
    final value = !isFast ? '($list,)' : 'const ([],)';
    if (variable != null) {
      variable.assign(sink, value);
    }

    return postprocess(context, sink);
  }

  String? _optimize(BuildContext context, Variable? variable, bool isFast) {
    if (isFast) {
      if (expression case final CharacterClassExpression child) {
        final sink = preprocess(context);
        final ranges = child.ranges;
        final predicate =
            MatcherGenerator().generate('c', ranges, negate: child.negate);
        sink.writeln('''
for (var c = state.peek(); $predicate;) {
  state.advance();
  c = state.peek();
}''');
        if (variable != null) {
          const value = '(null,)';
          variable.assign(sink, value);
        }

        return postprocess(context, sink);
      }
    }

    return null;
  }
}

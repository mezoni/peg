import '../binary_search_generator/matcher_generator.dart';
import 'build_context.dart';

class ZeroOrMoreExpression extends SingleExpression {
  ZeroOrMoreExpression({required super.expression});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitZeroOrMore(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    if (_optimize(context, result)) {
      return;
    }

    if (!result.isUsed) {
      _generateUnused(context, result);
    } else {
      _generate(context, result);
    }
  }

  void _generate(BuildContext context, BuildResult result) {
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: true,
    );

    expression.generate(context, childResult);

    final list = context.allocate();
    final elementType = expression.getResultType();
    final code = result.code;
    code.assign(list, '<$elementType>[]', 'final ');
    code.writeln('while (true) {');
    code.add(childResult.code);
    code.writeln('}');

    final branch = childResult.branch();
    branch.truth.block((b) {
      final value = childResult.value;
      b.statement('$list.add($value)');
    });

    branch.falsity.block((b) {
      b.statement('break');
    });

    code.branch('true', 'false');
    result.value = Value(list);
    result.postprocess(this);
  }

  void _generateUnused(BuildContext context, BuildResult result) {
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: false,
    );

    expression.generate(context, childResult);

    final code = result.code;
    code.writeln('while (true) {');
    code.add(childResult.code);
    code.writeln('}');

    final branch = childResult.branch();
    branch.falsity.block((b) {
      b.statement('break');
    });

    code.branch('true', 'false');
    result.postprocess(this);
  }

  bool _optimize(BuildContext context, BuildResult result) {
    if (!result.isUsed) {
      if (expression case final CharacterClassExpression child) {
        final ranges = child.ranges;
        final predicate =
            MatcherGenerator().generate('c', ranges, negate: child.negate);
        final code = result.code;
        code.writeln('''
for (var c = state.peek(); $predicate;) {
  state.position += state.charSize(c);
  c = state.peek();
}''');

        code.branch('true', 'false');
        result.postprocess(this);
        return true;
      }
    }

    return false;
  }
}

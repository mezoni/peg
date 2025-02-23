import '../helper.dart';
import 'build_context.dart';

class ExpectedExpression extends SingleExpression {
  final String name;

  ExpectedExpression({
    required super.expression,
    required this.name,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitExpected(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final position = context.getSharedValue(this, Expression.position);
    context.shareValues(this, expression, [Expression.position]);
    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    final string = context.allocate();
    final failure = context.allocate();
    final nesting = context.allocate();
    final escapedName = escapeString(name, "'");
    final code = result.code;
    code.assign(string, escapedName, 'const');
    code.assign(failure, 'state.failure', 'final');
    code.assign(nesting, 'state.nesting', 'final');
    code.assign('state.failure', '$position');
    code.assign('state.nesting', '$position');
    code.add(childResult.code);

    {
      final branch = childResult.branch();
      branch.truth.block((b) {
        b.statement('state.onSuccess($string, $position, $nesting)');
      });

      branch.falsity.block((b) {
        b.statement('state.onFailure($string, $position, $nesting, $failure)');
      });
    }

    childResult.copyValueTo(result);
    result.postprocess(this);
  }
}

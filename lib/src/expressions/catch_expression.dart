import '../helper.dart';
import 'build_context.dart';

class CatchExpression extends SingleExpression {
  final String catchBlock;

  CatchExpression({
    required super.expression,
    required this.catchBlock,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCatch(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final failure = context.allocate('failure');
    sink.statement('final $failure = state.enter()');
    if (variable == null) {
      if (expression.isVariableNeedForTestState()) {
        variable = context.allocateVariable();
      }
    }

    sink.writeln(expression.generate(context, variable, isFast));
    final isFailure = expression.getStateTest(variable, false);
    sink.ifStatement(isFailure, (block) {
      block.writeln(catchBlock);
    });
    sink.statement('state.leave($failure)');
    return postprocess(context, sink);
  }
}

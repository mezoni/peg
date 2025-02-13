import '../helper.dart';
import 'build_context.dart';

class ActionExpression extends Expression {
  final String code;

  ActionExpression({required this.code});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAction(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    if (parent is VariableExpression) {
      final type = getResultType();
      sink.statement('final $type \$\$');
      sink.writeln(code);
      if (variable != null) {
        if (!isLast) {
          variable.assign(sink, '(\$\$,)');
        }
      }
    } else {
      sink.writeln(code);
      if (variable != null) {
        variable.assign(sink, '(null,)');
      }
    }

    return postprocess(context, sink);
  }
}

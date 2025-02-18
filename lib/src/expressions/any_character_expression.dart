import '../helper.dart';
import 'build_context.dart';

class AnyCharacterExpression extends Expression {
  AnyCharacterExpression();

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final value = conditional(
        'state.peek() != 0', '(state.advance(),)', 'state.fail<int>()');
    if (variable == null) {
      sink.statement(value);
    } else {
      variable.assign(sink, value);
    }

    return postprocess(context, sink);
  }
}

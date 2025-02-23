import 'build_context.dart';

class AnyCharacterExpression extends Expression {
  AnyCharacterExpression();

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAnyCharacter(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final c = context.allocate();
    final code = result.code;
    code.assign('final $c', 'state.peek()');
    final branch = code.branch('$c != 0');
    branch.truth.block((b) {
      b.statement('state.position += state.charSize($c)');
    });

    branch.falsity.block((b) {
      b.statement('state.fail()');
    });

    if (result.isUsed) {
      result.value = Value(c);
    }

    result.postprocess(this);
  }
}

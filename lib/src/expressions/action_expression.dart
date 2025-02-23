import 'build_context.dart';

class ActionExpression extends Expression {
  final String code;

  ActionExpression({required this.code});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAction(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final code = result.code;
    if (parent is VariableExpression) {
      const dollars = r'$$';
      if (this.code.contains(dollars)) {
        final type = getResultType();
        code.statement('final $type $dollars');
        code.writeln(this.code);
        if (result.isUsed) {
          result.value = Value(dollars);
        }
      } else {
        if (result.isUsed) {
          result.value = Value(this.code);
        } else {
          code.writeln(this.code);
        }
      }
    } else {
      code.writeln(this.code);
      if (result.isUsed) {
        result.value = Value('null', isConst: true);
      }
    }

    code.branch('true', 'false');
    result.postprocess(this);
  }
}

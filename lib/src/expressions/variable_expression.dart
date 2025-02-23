import 'build_context.dart';

class VariableExpression extends SingleExpression {
  final String name;

  final String operator;

  VariableExpression({
    required super.expression,
    required this.name,
    required this.operator,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitVariable(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    context.shareValues(this, expression, [Expression.position]);
    final childResult = BuildResult(
      context: context,
      expression: expression,
      isUsed: true,
    );

    expression.generate(context, childResult);

    final branch = childResult.branch();
    branch.truth.block((b) {
      final type = getResultType();
      final value = childResult.value.code.trim();
      if (value == 'null') {
        b.statement('$type $name');
      } else {
        b.assign(name, value, type);
      }
    });

    final code = result.code;
    code.add(childResult.code);
    if (result.isUsed) {
      result.value = Value(name);
    }

    result.postprocess(this);
  }
}

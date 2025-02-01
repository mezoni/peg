import 'expression.dart';

class ActionExpression extends Expression {
  final String code;

  ActionExpression({required this.code});

  @override
  String generate(ProductionRuleContext context) {
    final values = {
      'code': code,
    };

    final template = '''
state.isSuccess = true;
$code''';
    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAction(this);
  }
}

import 'expression.dart';

class ActionExpression extends Expression {
  final String code;

  ActionExpression({required this.code});

  @override
  String generate(ProductionRuleContext context) {
    final values = {
      'code': code,
    };

    var template = '';
    if (semanticVariable != null) {
      final assignment = assignResult(context, 'state.opt((\$\$,))');
      values['type'] = getResultType();
      template = '''
late {{type}} \$\$;
{{code}}
$assignment''';
    } else {
      final assignment = assignResult(context, 'state.opt((null,))');
      template = '''
{{code}}
$assignment''';
    }

    return render(context, this, template, values);
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitAction(this);
  }
}

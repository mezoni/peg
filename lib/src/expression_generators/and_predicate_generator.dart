import '../expressions/expressions.dart';
import 'expression_generator.dart';

class AndPredicateGenerator
    extends ExpressionGenerator<AndPredicateExpression> {
  AndPredicateGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    const template = '''
final {{pos}} = state.pos;
{{p}}
if (state.ok) {
  state.pos = {{pos}};
}''';
    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final pos = allocateName();
    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.writeln('$pos = state.pos;');
    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, false);
    asyncGenerator.writeln('state.input.endBuffering($pos!);');

    {
      final values = <String, String>{};
      values['pos'] = pos;
      const template = '''
 if (state.ok) {
  state.pos = {{pos}}!;
}''';
      asyncGenerator.render(template, values);
    }
  }
}

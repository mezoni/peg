import '../allocator.dart';
import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../grammar_generators/production_rule_generator.dart';
import 'expression_generator.dart';

class SymbolGenerator extends ExpressionGenerator<SymbolExpression> {
  static const _template = '''
{{r}} = {{name}}(state);''';

  static const _templateNoResult = '''
{{name}}(state);''';

  SymbolGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final reference = expression.reference!;
    if (reference.metadata case final metadata?) {
      if (metadata.contains('@inline')) {
        return _generateInline(reference);
      }
    }

    return _generate(reference);
  }

  String _generate(ProductionRule reference) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final methodName = ruleGenerator.getMethodName(reference, variable == null);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = _template;
    } else {
      template = _templateNoResult;
    }

    values['name'] = methodName;
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: ruleGenerator.generatedRules,
            isFast: variable == null,
            rule: reference)
        .generate();
    return render(template, values);
  }

  String _generateInline(ProductionRule reference) {
    final values = <String, String>{};
    final child = reference.expression;
    if (ruleGenerator.getExpressionVariable(expression) case final variable?) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    values['p'] = generateExpression(child, false);
    const template = '{{p}}';
    return render(template, values);
  }
}

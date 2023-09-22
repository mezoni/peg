import '../allocator.dart';
import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../grammar_generators/production_rule_generator.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class SymbolGenerator extends ExpressionGenerator<SymbolExpression> {
  static const _template = '''
{{r}} = {{name}}(state);''';

  static const _templateNoResult = '''
{{name}}(state);''';

  static const _templateInline = '''
beginEvent({{event}});
{{p}}
{{r}} = endEvent<{{eventType}}>({{event}}, {{r}}, state.ok);''';

  static const _templateInlineNoResult = '''
beginEvent({{event}});
{{p}}
endEvent<{{eventType}}>({{event}}, null, state.ok);''';

  SymbolGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final reference = expression.reference!;
    if (reference.metadata case final metadata?) {
      final isInline = metadata.any((e) => e.name == '@inline');
      if (isInline) {
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
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final rule = expression.reference!;
    var hasEvent = false;
    if (rule.metadata case final metadata?) {
      hasEvent = metadata.any((e) => e.name == '@event');
    }

    final resultType = rule.resultType ??
        expression.resultType ??
        GenericType(name: 'Object', isNullableType: true);
    values['p'] = generateExpression(child, false);
    values['event'] = helper.escapeString(rule.name);
    values['eventType'] = '$resultType';
    var template = '';
    if (hasEvent) {
      if (variable != null) {
        values['r'] = variable;
        template = _templateInline;
      } else {
        template = _templateInlineNoResult;
      }
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }
}

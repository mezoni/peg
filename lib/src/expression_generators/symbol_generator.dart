import '../allocator.dart';
import '../expressions/expressions.dart';
import '../grammar/production_rule.dart';
import '../grammar_generators/events_generator.dart';
import '../grammar_generators/production_rule_generator.dart';
import 'expression_generator.dart';

class SymbolGenerator extends ExpressionGenerator<SymbolExpression> {
  SymbolGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final reference = expression.reference!;
    final isInline = reference.isInline();
    if (isInline) {
      return _generateInline(reference);
    }

    return _generate(reference);
  }

  @override
  String generateAsync() {
    final reference = expression.reference!;
    final isInline = reference.isInline();
    if (isInline) {
      return _generateAsyncInline(reference);
    } else {
      return _generateAsync(reference);
    }
  }

  String _generate(ProductionRule reference) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final methodName = ruleGenerator.getMethodName(reference, variable == null);
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
{{r}} = {{name}}(state);''';
    } else {
      template = '''
{{name}}(state);''';
    }

    values['name'] = methodName;
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: ruleGenerator.generatedRules,
            isAsync: ruleGenerator.isAsync,
            isFast: variable == null,
            parserName: ruleGenerator.parserName,
            rule: reference)
        .generate();
    final buffer = StringBuffer();
    buffer.writeln(' // $expression');
    buffer.write(render(template, values));
    return buffer.toString();
  }

  String _generateAsync(ProductionRule reference) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final isFast = variable == null;
    final resultType = reference.resultType ?? reference.expression.resultType!;
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: ruleGenerator.generatedRules,
            isAsync: ruleGenerator.isAsync,
            isFast: isFast,
            parserName: ruleGenerator.parserName,
            rule: reference)
        .generate();
    final ar = asyncGenerator.allocateVariable(isFast
        ? GenericType(
            name: 'AsyncResult',
            arguments: [GenericType(name: 'Object').getNullableType()])
        : GenericType(name: 'AsyncResult', arguments: [resultType]));
    values['ar'] = ar;
    values['ar_'] = allocateName();
    values['handle'] = asyncGenerator.functionName;
    values['name'] = ruleGenerator.getAsyncMethodName(reference, isFast);
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = $ar!.value;';
    }

    const initTemplate = '''
{{ar}} = {{name}}(state);
final {{ar_}} = {{ar}}!;
if (!{{ar_}}.isComplete) {
  {{ar_}}.onComplete = {{handle}};
  return;
}''';
    final init = render(initTemplate, values);
    return asyncGenerator.renderAction(
      assignResult,
      buffering: false,
      init: init,
    );
  }

  String _generateAsyncInline(ProductionRule reference) {
    final values = <String, String>{};
    final child = reference.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final hasEvent = reference.hasEvent();
    final childVariable = ruleGenerator.getExpressionVariable(child);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    String? init;
    if (hasEvent) {
      final parserName = ruleGenerator.parserName;
      values['event'] =
          EventsGenerator.getElementFullName(reference, parserName);
      const initTemplate = '''
beginEvent({{event}});''';
      init = render(initTemplate, values);
    }

    values['p'] = generateAsyncExpression(child, false);
    if (childVariable != null) {
      ruleGenerator.setExpressionVariable(child, childVariable);
    } else {
      ruleGenerator.removeExpressionVariable(child);
    }

    var template = '';
    if (hasEvent) {
      values['type'] =
          (reference.resultType ?? expression.resultType).toString();
      if (variable != null) {
        values['r'] = variable;
        template = '''
{{p}}
{{r}} = endEvent<{{type}}>({{event}}, {{r}}, state.ok);''';
      } else {
        template = '''
{{p}}
endEvent<{{type}}>({{event}}, null, state.ok);''';
      }
    } else {
      template = '''
{{p}}''';
    }

    final source = render(template, values);
    return asyncGenerator.renderAction(
      source,
      buffering: false,
      init: init,
    );
  }

  String _generateInline(ProductionRule reference) {
    final values = <String, String>{};
    final child = reference.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final hasEvent = reference.hasEvent();
    final resultType = reference.resultType ??
        expression.resultType ??
        GenericType(name: 'Object', isNullableType: true);
    final childVariable = ruleGenerator.getExpressionVariable(child);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    final p = generateExpression(child, false);
    values['p'] = ' // $reference\n$p';
    if (childVariable != null) {
      ruleGenerator.setExpressionVariable(child, childVariable);
    } else {
      ruleGenerator.removeExpressionVariable(child);
    }

    if (hasEvent) {
      values['event'] = EventsGenerator.getElementFullName(
          reference, ruleGenerator.parserName);
      values['type'] = '$resultType';
    }

    var template = '';
    if (hasEvent) {
      if (variable != null) {
        values['r'] = variable;
        template = '''
beginEvent({{event}});
{{p}}
{{r}} = endEvent<{{type}}>({{event}}, {{r}}, state.ok);''';
      } else {
        template = '''
beginEvent({{event}});
{{p}}
endEvent<{{type}}>({{event}}, null, state.ok);''';
      }
    } else {
      template = '{{p}}';
    }

    return render(template, values);
  }
}

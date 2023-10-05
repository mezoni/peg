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
  void generateAsync() {
    final reference = expression.reference!;
    final isInline = reference.isInline();
    if (isInline) {
      _generateAsyncInline(reference);
    } else {
      _generateAsync(reference);
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

  void _generateAsync(ProductionRule reference) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final isFast = variable == null;
    final resultType = reference.resultType ?? reference.expression.resultType!;
    final asyncResult = allocateName();
    ProductionRuleGenerator(
            allocator: Allocator(),
            generatedRules: ruleGenerator.generatedRules,
            isAsync: ruleGenerator.isAsync,
            isFast: isFast,
            parserName: ruleGenerator.parserName,
            rule: reference)
        .generate();
    if (isFast) {
      asyncGenerator.addVariable(
          asyncResult,
          GenericType(
              name: 'AsyncResult',
              arguments: [GenericType(name: 'Object').getNullableType()]));
    } else {
      asyncGenerator.addVariable(asyncResult,
          GenericType(name: 'AsyncResult', arguments: [resultType]));
    }

    final state1 = asyncGenerator.allocateState();

    {
      final values = <String, String>{};
      values['ar'] = asyncResult;
      values['ar2'] = allocateName();
      values['handle'] = asyncGenerator.functionName;
      values['name'] = ruleGenerator.getAsyncMethodName(reference, isFast);
      values['state'] = asyncGenerator.stateVariable;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['r'] = variable;
        template = '''
  {{state}} = -1;
  {{ar}} = {{name}}(state);
  final {{ar2}} = {{ar}}!;
  {{state}} = {{state1}};
  if ({{ar2}}.isComplete) {
    break;
  }
  {{ar2}}.onComplete = {{handle}};
  return;''';
      } else {
        template = '''
{{state}} = -1;
  {{ar}} = {{name}}(state);
  {{state}} = {{state1}};
  final {{ar2}} = {{ar}}!;
  if ({{ar2}}.isComplete) {
    break;
  }
  {{ar2}}.onComplete = {{handle}};
  return;''';
      }

      asyncGenerator.render(template, values);
    }

    {
      final values = <String, String>{};
      asyncGenerator.beginState(state1);
      values['ar'] = asyncResult;
      values['state1'] = state1;
      var template = '';
      if (variable != null) {
        values['r'] = variable;
        template = '''
{{r}} = {{ar}}!.value;
{{ar}} = null;''';
      } else {
        template = '''
{{ar}} = null;''';
      }

      asyncGenerator.render(template, values);
    }
  }

  void _generateAsyncInline(ProductionRule reference) {
    final child = reference.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final hasEvent = reference.hasEvent();
    final childVariable = ruleGenerator.getExpressionVariable(child);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    String event = '__invalid_event__';
    if (hasEvent) {
      final parserName = ruleGenerator.parserName;
      event = EventsGenerator.getElementFullName(reference, parserName);
    }

    if (hasEvent) {
      asyncGenerator.writeln('beginEvent($event);');
    }

    generateAsyncExpression(child, false);
    if (childVariable != null) {
      ruleGenerator.setExpressionVariable(child, childVariable);
    } else {
      ruleGenerator.removeExpressionVariable(child);
    }

    if (hasEvent) {
      final values = <String, String>{};
      values['event'] = event;
      values['type'] =
          (reference.resultType ?? expression.resultType).toString();
      var template = '';
      if (hasEvent) {
        if (variable != null) {
          values['r'] = variable;
          template = '''
  {{r}} = endEvent<{{type}}>({{event}}, {{r}}, state.ok);''';
        } else {
          template = '''
  endEvent<{{type}}>({{event}}, null, state.ok);''';
        }
      }

      asyncGenerator.render(template, values);
    }
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

import '../allocator.dart';
import '../async_generators/action_node.dart';
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
  void generateAsync(BlockNode block) {
    final reference = expression.reference!;
    final isInline = reference.isInline();
    if (isInline) {
      _generateAsyncInline(block, reference);
    } else {
      _generateAsync(block, reference);
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

  void _generateAsync(BlockNode block, ProductionRule reference) {
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
    final asyncResult = asyncGenerator
        .allocateVariable(
            isLate: true,
            type: isFast
                ? GenericType(
                    name: 'AsyncResult',
                    arguments: [GenericType(name: 'Object').getNullableType()])
                : GenericType(name: 'AsyncResult', arguments: [resultType]))
        .name;
    final handle = asyncGenerator.functionName;
    final name = ruleGenerator.getAsyncMethodName(reference, isFast);
    block << '$asyncResult = $name(state);';
    final label = allocateName();
    block.if_('!$asyncResult.isComplete', (block) {
      block << '$asyncResult.onComplete = $handle;';
      block.return_(label);
    });
    block.goto_(label);
    block.label(label);
    if (variable != null) {
      block << '$variable = $asyncResult.value;';
    }
  }

  void _generateAsyncInline(BlockNode block, ProductionRule reference) {
    final child = reference.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final hasEvent = reference.hasEvent();
    final childVariable = ruleGenerator.getExpressionVariable(child);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    }

    var event = '';
    if (hasEvent) {
      final parserName = ruleGenerator.parserName;
      event = EventsGenerator.getElementFullName(reference, parserName);
      block << 'beginEvent($event);';
    }

    generateAsyncExpression(block, child, false);
    if (childVariable != null) {
      ruleGenerator.setExpressionVariable(child, childVariable);
    } else {
      ruleGenerator.removeExpressionVariable(child);
    }

    if (hasEvent) {
      final type = (reference.resultType ?? expression.resultType).toString();
      var assignResult = '';
      if (variable != null) {
        assignResult = '$variable = ';
      }

      block <<
          '${assignResult}endEvent<$type>($event, $variable, state.ok);' '';
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

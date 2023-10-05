import '../expressions/expressions.dart';
import 'expression_generator.dart';

class VerifyGenerator extends ExpressionGenerator<VerifyExpression> {
  VerifyGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    } else {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['errorCount'] = allocateName();
    values['failPos'] = allocateName();
    values['pos'] = allocateName();
    values['handler'] = expression.handler.trim();
    values['p'] = generateExpression(child, variable == null);
    if (variable != null) {
      values['rv'] = getExpressionVariableWithNullCheck(expression);
    } else {
      values['rv'] = getExpressionVariableWithNullCheck(child);
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (state.ok) {
  final pos = {{pos}};
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    if ({{failPos}} <= pos) {
      state.failPos = {{failPos}};
      state.errorCount = {{errorCount}};
    }
    state.failAt(pos, error);
  }
}
if (!state.ok) {
  {{r}} = null;
  state.pos = {{pos}};
}''';
    } else {
      template = '''
final {{pos}} = state.pos;
final {{failPos}} = state.failPos;
final {{errorCount}} = state.errorCount;
{{p}}
if (state.ok) {
  final pos = {{pos}};
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    if ({{failPos}} <= pos) {
      state.failPos = {{failPos}};
      state.errorCount = {{errorCount}};
    }
    state.failAt(pos, error);
  }
}
if (!state.ok) {
  state.pos = {{pos}};
}''';
    }

    return render(template, values);
  }

  @override
  void generateAsync() {
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.setExpressionVariable(child, variable);
    } else {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final handler = expression.handler.trim();
    final pos = allocateName();
    final failPos = allocateName();
    final errorCount = allocateName();
    asyncGenerator.addVariable(pos, GenericType(name: 'int'));
    asyncGenerator.addVariable(failPos, GenericType(name: 'int'));
    asyncGenerator.addVariable(errorCount, GenericType(name: 'int'));

    {
      final values = <String, String>{};
      values['errorCount'] = errorCount;
      values['failPos'] = failPos;
      values['pos'] = pos;
      const template = '''
{{pos}} = state.pos;
{{failPos}} = state.failPos;
{{errorCount}} = state.errorCount;''';
      asyncGenerator.render(template, values);
    }

    asyncGenerator.writeln('state.input.beginBuffering();');
    generateAsyncExpression(child, variable == null);

    {
      final values = <String, String>{};
      values['errorCount'] = errorCount;
      values['failPos'] = failPos;
      values['handler'] = handler;
      values['pos'] = pos;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      var template = '';
      if (variable != null) {
        values['r'] = variable;
        template = '''
if (state.ok) {
  final pos = {{pos}}!;
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    final failPos = {{failPos}}!;
    if (failPos <= pos) {
      state.failPos = failPos;
      state.errorCount = {{errorCount}}!;
    }
    state.failAt(pos, error);
  }
}
if (!state.ok) {
  {{r}} = null;
  state.pos = {{pos}}!;
}
state.input.endBuffering(state.pos);''';
      } else {
        template = '''
if (state.ok) {
  final pos = {{pos}}!;
  // ignore: unused_local_variable
  final \$\$ = {{rv}};
  ParseError? error;
  {{handler}}
  if (error != null) {
    final failPos = {{failPos}}!;
    if (failPos <= pos) {
      state.failPos = failPos;
      state.errorCount = {{errorCount}}!;
    }
    state.failAt(pos, error);
  }
}
if (!state.ok) {
  state.pos = {{pos}}!;
}
state.input.endBuffering(state.pos);''';
      }

      asyncGenerator.render(template, values);
    }
  }
}

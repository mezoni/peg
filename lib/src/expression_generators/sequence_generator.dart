import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SequenceGenerator extends ExpressionGenerator<SequenceExpression> {
  static const _templateActionWithVariable = '''
{{p}}
if (state.ok) {
  {{action}}
  {{r}} = \$\$;
}''';

  static const _templateActionWithoutVariable = '''
{{p}}
if (state.ok) {
  {{action}}
}''';

  static const _templateLastWithVariable = '''
{{p}}
if (state.ok) {
  {{r}} = {{result}};
}''';

  static const _templateMultiple = '''
final {{pos}} = state.pos;
{{inner}}
if (!state.ok) {
  state.pos = {{pos}};
}''';

  static const _templateNext = '''
{{p}}
if (state.ok) {
  {{next}}
}''';

  SequenceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final children = expression.expressions;
    values['pos'] = allocateName();
    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action;
    final childrenWithVariables =
        children.where((e) => e.semanticVariable != null).toList();
    var result = '';
    var declareVariable = true;
    if (childrenWithVariables.isNotEmpty) {
      if (action != null || variable != null) {
        if (childrenWithVariables.length == 1) {
          final child = childrenWithVariables[0];
          final variable = ruleGenerator.allocateExpressionVariable(child);
          result = variable;
        } else {
          final fields = <(String, String)>[];
          for (final child in childrenWithVariables) {
            final semanticVariable = child.semanticVariable!;
            ruleGenerator.allocateExpressionVariable(child);
            final value = getExpressionVariableWithNullCheck(child);
            fields.add((semanticVariable, value));
          }

          result = fields.map((e) => '${e.$1}: ${e.$2}').join(', ');
          result = '($result)';
        }
      }
    } else {
      if (action != null) {
        //
      } else if (variable != null) {
        if (children.length == 1) {
          final child = children[0];
          final resultType = expression.resultType!;
          final childResultType = child.resultType!;
          if (childResultType == resultType) {
            declareVariable = false;
            ruleGenerator.setExpressionVariable(child, variable);
            result = variable;
          } else {
            result = ruleGenerator.allocateExpressionVariable(child);
          }
        } else {
          for (final child in children) {
            ruleGenerator.allocateExpressionVariable(child);
          }

          result = children.map(getExpressionVariableWithNullCheck).join(', ');
          result = '($result)';
        }
      }
    }

    String plunge(int i) {
      final values = <String, String>{};
      final child = children[i];
      var template = '';
      values['p'] = generateExpression(child, declareVariable);
      if (i < children.length - 1) {
        values['next'] = plunge(i + 1);
        return render(_templateNext, values);
      }

      final action = expression.action;
      if (action != null) {
        values['action'] = _generateActionTemplate();
      }

      if (ruleGenerator.getExpressionVariable(expression)
          case final variable?) {
        values['r'] = variable;
        values['result'] = result;
        if (action != null) {
          template = _templateActionWithVariable;
        } else {
          template = _templateLastWithVariable;
        }
      } else {
        if (action != null) {
          template = _templateActionWithoutVariable;
        } else {
          template = '{{p}}';
        }
      }

      return render(template, values);
    }

    final inner = plunge(0);
    if (children.length == 1) {
      return inner;
    } else {
      values['inner'] = inner;
      return render(_templateMultiple, values);
    }
  }

  String _generateActionTemplate() {
    final buffer = StringBuffer();
    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action!;
    final type = action.resultType ?? getExpressionResultType(expression);
    if (variable == null) {
      buffer.writeln(' // ignore: unused_local_variable');
    }

    final nullableType = type.getNullableType();
    buffer.writeln('$nullableType \$\$;');
    final childrenWithVariables =
        expression.expressions.where((e) => e.semanticVariable != null);
    for (final child in childrenWithVariables) {
      final semanticVariable = child.semanticVariable;
      final value = getExpressionVariableWithNullCheck(child);
      buffer.writeln('final $semanticVariable = $value;');
    }

    buffer.write(action.source.trim());
    return buffer.toString();
  }
}

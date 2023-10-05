import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SequenceGenerator extends ExpressionGenerator<SequenceExpression> {
  SequenceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final values = <String, String>{};
    values['pos'] = allocateName();
    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action;
    final (declareVariable, result) = _generateResult(children);
    String plunge(int i) {
      final values = <String, String>{};
      final child = children[i];
      var template = '';
      values['p'] = generateExpression(child, declareVariable);
      if (i < children.length - 1) {
        values['next'] = plunge(i + 1);
        const template = '''
{{p}}
if (state.ok) {
  {{next}}
}''';
        return render(template, values);
      }

      if (action != null) {
        values['action'] = _generateActionTemplate();
      }

      if (variable != null) {
        values['r'] = variable;
        values['result'] = result;
        if (action != null) {
          template = '''
{{p}}
if (state.ok) {
  {{action}}
  {{r}} = \$\$;
}''';
        } else {
          if (children.length == 1) {
            template = '{{p}}';
          } else {
            template = '''
{{p}}
if (state.ok) {
  {{r}} = {{result}};
}''';
          }
        }
      } else {
        if (action != null) {
          template = '''
{{p}}
if (state.ok) {
  {{action}}
}''';
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
      const template = '''
final {{pos}} = state.pos;
{{inner}}
if (!state.ok) {
  state.pos = {{pos}};
}''';
      return render(template, values);
    }
  }

  @override
  void generateAsync() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final stateVariable = asyncGenerator.stateVariable;
    final (declareVariable, result) = _generateResult(children);
    if (children.length == 1) {
      final values = <String, String>{};
      final child = children[0];
      generateAsyncExpression(child, declareVariable);
      if (action != null) {
        values['action'] = _generateActionTemplate();
        var template = '';
        if (variable != null) {
          values['r'] = variable;
          template = '''
  if (state.ok) {
    {{action}}
    {{r}} = \$\$;
  }''';
        } else {
          template = '''
  if (state.ok) {
    {{action}}
  }''';
        }

        final source = render(template, values);
        asyncGenerator.writeln(source);
      }
    } else {
      final pos = allocateName();
      asyncGenerator.addVariable(pos, GenericType(name: 'int'));
      asyncGenerator.writeln('$pos = state.pos;');
      final endState = asyncGenerator.allocateState();
      for (var i = 0; i < children.length; i++) {
        final values = <String, String>{};
        final child = children[i];
        generateAsyncExpression(child, declareVariable);
        values['end'] = endState;
        values['state'] = stateVariable;
        var template = '';
        if (i == 0) {
          template = '''
if (!state.ok) {
  {{state}} = {{end}};
  break;
}''';
        } else {
          values['pos'] = pos;
          template = '''
if (!state.ok) {
  state.pos = {{pos}}!;
  {{state}} = {{end}};
  break;
}''';
        }

        asyncGenerator.render(template, values);
      }

      {
        final values = <String, String>{};
        values['end'] = endState;
        values['state'] = stateVariable;
        var template = '';
        if (variable != null) {
          values['r'] = variable;
          if (action != null) {
            values['action'] = _generateActionTemplate();
            template = '''
{{action}}
{{r}} = \$\$;
{{state}} = {{end}};
break;''';
          } else {
            values['result'] = result;
            template = '''
{{r}} = {{result}};
{{state}} = {{end}};
break;''';
          }
        } else {
          if (action != null) {
            values['action'] = _generateActionTemplate();
            template = '''
{{action}}
{{state}} = {{end}};
break;''';
          } else {
            template = '''
{{state}} = {{end}};
break;''';
          }
        }

        asyncGenerator.render(template, values);
        asyncGenerator.beginState(endState);
      }
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

  (bool, String) _generateResult(List<Expression> children) {
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
          if (children.length == 1) {
            if (variable != null) {
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
              result = ruleGenerator.allocateExpressionVariable(child);
            }
          } else {
            final variable = ruleGenerator.allocateExpressionVariable(child);
            result = variable;
          }
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
          result = '[$result]';
        }
      }
    }

    return (declareVariable, result);
  }
}

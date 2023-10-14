import '../expressions/expressions.dart';
import 'expression_generator.dart';

class SequenceGenerator extends ExpressionGenerator<SequenceExpression> {
  SequenceGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final values = <String, String>{};
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action;
    final (declareVariable, result) = _generateResult(children);
    final hasCutExpression = children.any((e) => e is CutExpression);
    final ok = hasCutExpression && children.length > 1 ? allocateName() : '';
    var cutExpressionCount = 0;
    values['pos'] = allocateName();
    String plunge(int i) {
      final values = <String, String>{};
      final child = children[i];
      var assignOk = '';
      if (child is CutExpression) {
        if (cutExpressionCount++ == 0) {
          if (ok.isNotEmpty) {
            assignOk = '''
$ok = false;
''';
          }
        }
      }

      var template = '';
      values['p'] = generateExpression(child, declareVariable);
      if (i < children.length - 1) {
        values['next'] = plunge(i + 1);
        const template = '''
{{p}}
if (state.ok) {
  {{next}}
}''';

        final template2 = '$assignOk$template';
        return render(template2, values);
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

      final template2 = '$assignOk$template';
      return render(template2, values);
    }

    values['inner'] = plunge(0);
    var template = '';
    values['ok'] = ok;
    values['declare_vars'] = '';
    values['set_is_recoverable'] = '';
    if (children.length == 1) {
      if (hasCutExpression) {
        template = '''
{{inner}}
if (!state.ok) {
  state.isRecoverable = false;
}''';
      } else {
        template = '''
{{inner}}''';
      }
    } else {
      if (hasCutExpression) {
        if (ok.isNotEmpty) {
          values['declare_vars'] = 'var $ok = true;';
          values['set_is_recoverable'] = '''
if (!$ok) {
  state.isRecoverable = false;
}''';
        }
      }

      template = '''
final {{pos}} = state.pos;
{{declare_vars}}
{{inner}}
if (!state.ok) {
  {{set_is_recoverable}}
  state.backtrack({{pos}});
}''';
    }

    return render(template, values);
  }

  @override
  String generateAsync() {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final action = expression.action;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final (declareVariable, result) = _generateResult(children);
    if (children.length == 1) {
      final values = <String, String>{};
      final child = children[0];
      values['p'] = generateAsyncExpression(child, declareVariable);
      var template = '';
      if (action != null) {
        values['action'] = _generateActionTemplate();
        if (variable != null) {
          values['r'] = variable;
          template = '''
  {{p}}
  if (state.ok) {
    {{action}}
    {{r}} = \$\$;
  }''';
        } else {
          template = '''
  {{p}}
  if (state.ok) {
    {{action}}
  }''';
        }
      } else {
        template = '''
{{p}}''';
      }

      if (child is CutExpression) {
        const template2 = '''
if (!state.ok) {
  state.isRecoverable = false;
}''';
        template = '$template$template2';
      }

      final source = render(template, values);
      return asyncGenerator.renderAction(
        source,
        buffering: false,
      );
    } else {
      final hasCutExpression = children.any((e) => e is CutExpression);
      final state = asyncGenerator.allocateVariable(GenericType(name: 'int'));
      final pos = asyncGenerator.allocateVariable(GenericType(name: 'int'));
      final ok = !hasCutExpression
          ? ''
          : asyncGenerator.allocateVariable(GenericType(name: 'bool'));
      var cutExpressionCount = 0;
      final initList = <String>[
        '{{state}} = 0;',
        '{{pos}} = state.pos;',
      ];
      if (hasCutExpression) {
        initList.add('{{ok}} = true;');
      }

      final init = render(initList.join('\n'), {
        'pos': pos,
        'state': state,
        if (ok.isNotEmpty) 'ok': ok,
      });
      final buffer = StringBuffer();
      for (var i = 0; i < children.length; i++) {
        final values = <String, String>{};
        final child = children[i];
        values['index'] = '$i';
        values['state'] = state;
        values['p'] = generateAsyncExpression(child, declareVariable);
        var assignOk = '';
        if (child is CutExpression) {
          if (cutExpressionCount++ == 0) {
            if (ok.isNotEmpty) {
              assignOk = '''
$ok = false;
''';
            }
          }
        }

        var template = '';
        values['assign_ok'] = assignOk;
        if (i < children.length - 1) {
          values['next_index'] = '${i + 1}';
          template = '''
if ({{state}} == {{index}}) {
  {{assign_ok}}
  {{p}}
  {{state}} = state.ok ? {{next_index}} : -1;
}''';
        } else {
          template = '''
if ({{state}} == {{index}}) {
  {{assign_ok}}
  {{p}}
  {{state}} = -1;
}''';
        }
        final source = render(template, values);
        buffer.writeln(source);
      }

      {
        final values = <String, String>{};
        values['inner'] = buffer.toString();
        values['pos'] = pos;
        values['set_is_recoverable'] = '';
        if (hasCutExpression) {
          values['set_is_recoverable'] = '''
if (!$ok!) {
  state.isRecoverable = false;
}''';
        }

        var template = '';
        if (variable != null) {
          values['r'] = variable;
          if (action != null) {
            values['action'] = _generateActionTemplate();
            template = '''
{{inner}}
if (state.ok) {
  {{action}}
  {{r}} = \$\$;
} else {
  {{set_is_recoverable}}
  state.backtrack({{pos}}!);
}''';
          } else {
            values['result'] = result;
            template = '''
{{inner}}
if (state.ok) {
  {{r}} = {{result}};
} else {
  {{set_is_recoverable}}
  state.backtrack({{pos}}!);
}''';
          }
        } else {
          if (action != null) {
            values['action'] = _generateActionTemplate();
            template = '''
{{inner}}
if (state.ok) {
  {{action}}
} else {
  {{set_is_recoverable}}
  state.backtrack({{pos}}!);
}''';
          } else {
            template = '''
{{inner}}
if (!state.ok) {
  {{set_is_recoverable}}
  state.backtrack({{pos}}!);
}''';
          }
        }

        final source = render(template, values);
        return asyncGenerator.renderAction(
          source,
          buffering: false,
          init: init,
        );
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

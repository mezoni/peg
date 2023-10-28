import '../async_generators/action_node.dart';
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
    final ok = hasCutExpression && children.length > 1
        ? allocateName()
        : '__undefined__';
    final ignoreErrors = hasCutExpression ? allocateName() : '__undefined__';
    values['pos'] = allocateName();
    String plunge(int i) {
      final values = <String, String>{};
      final child = children[i];
      values['ok'] = ok;
      values['ignore_errors'] = ignoreErrors;
      final template = StringBuffer();
      if (child is CutExpression) {
        if (children.length > 1) {
          template.writeln('{{ok}} = false;');
          template.writeln('state.ignoreErrors = false;');
        }
      }

      values['p'] = generateExpression(child, declareVariable);
      if (i < children.length - 1) {
        values['next'] = plunge(i + 1);
        template.writeln('''
{{p}}
if (state.ok) {
  {{next}}
}''');
        return render(template.toString(), values);
      }

      if (action != null) {
        values['action'] = _generateActionSource();
      }

      if (variable != null) {
        values['r'] = variable;
        values['result'] = result;
        if (action != null) {
          template.writeln('''
{{p}}
if (state.ok) {
  {{action}}
  {{r}} = \$\$;
}''');
        } else {
          if (children.length == 1) {
            template.writeln('{{p}}');
          } else {
            template.writeln('''
{{p}}
if (state.ok) {
  {{r}} = {{result}};
}''');
          }
        }
      } else {
        if (action != null) {
          template.writeln('''
{{p}}
if (state.ok) {
  {{action}}
}''');
        } else {
          template.writeln('{{p}}');
        }
      }

      return render(template.toString(), values);
    }

    values['inner'] = plunge(0);
    final template = StringBuffer();
    values['ok'] = ok;
    values['failure_handler'] = '';
    if (children.length == 1) {
      if (hasCutExpression) {
        values['ignore_errors'] = ignoreErrors;
        template.writeln('''
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = false;
{{inner}}
if (!state.ok) {
  state.isRecoverable = false;
}
state.ignoreErrors = {{ignore_errors}};''');
      } else {
        template.writeln('{{inner}}');
      }
    } else {
      template.writeln('final {{pos}} = state.pos;');
      if (hasCutExpression) {
        values['ignore_errors'] = ignoreErrors;
        template.writeln('var $ok = true;');
        template.writeln('final {{ignore_errors}} = state.ignoreErrors;');
        values['failure_handler'] = '''
if (!$ok) {
  state.isRecoverable = false;
}''';
      }

      template.writeln('''
{{inner}}
if (!state.ok) {
  {{failure_handler}}
  state.backtrack({{pos}});
}''');
    }

    if (hasCutExpression) {
      template.writeln('state.ignoreErrors = $ignoreErrors;');
    }

    return render(template.toString(), values);
  }

  @override
  void generateAsync(BlockNode block) {
    final children = expression.expressions;
    if (children.isEmpty) {
      throw StateError(
          'List of expressions must not be empty\n$expression\n$rule');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final action = expression.action;
    final (declareVariable, result) = _generateResult(children);
    final hasCutExpression = children.any((e) => e is CutExpression);
    var ignoreErrors = '';
    if (hasCutExpression) {
      ignoreErrors = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
          .name;
    }

    if (children.length == 1) {
      final child = children[0];
      if (hasCutExpression) {
        block << '$ignoreErrors = state.ignoreErrors;';
      }

      generateAsyncExpression(block, child, declareVariable);
      if (hasCutExpression) {
        block.if_('!state.ok', (block) {
          block << 'state.isRecoverable = false;';
        });
      }

      if (action != null) {
        block.if_('state.ok', (block) {
          block << _generateActionSource();
          if (variable != null) {
            block << '$variable = \$\$;';
          }
        });
      }

      if (hasCutExpression) {
        block << 'state.ignoreErrors = $ignoreErrors;';
      }
    } else {
      var ok = '';
      if (hasCutExpression) {
        ok = asyncGenerator
            .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
            .name;
      }

      final pos = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block << '$pos = state.pos;';
      if (hasCutExpression) {
        block << '$ok = true;';
        block << '$ignoreErrors = state.ignoreErrors;';
      }

      void plunge(BlockNode block, int i) {
        final child = children[i];
        if (child is CutExpression) {
          block << '$ok = false;';
          block << 'state.ignoreErrors = false;';
        }

        generateAsyncExpression(block, child, declareVariable);
        if (i < children.length - 1) {
          block.if_('state.ok', (block) {
            plunge(block, i + 1);
          });
        } else {
          if (action != null) {
            block.if_('state.ok', (block) {
              block << _generateActionSource();
              if (variable != null) {
                block << '$variable = \$\$;';
              }
            });
          } else if (variable != null) {
            block.if_('state.ok', (block) {
              block << '$variable = $result;';
            });
          }
        }
      }

      plunge(block, 0);
      block.if_('!state.ok', (block) {
        if (hasCutExpression) {
          block.if_('!$ok', (block) {
            block << 'state.isRecoverable = false;';
          });
        }

        block << 'state.backtrack($pos);';
      });
      if (hasCutExpression) {
        block << 'state.ignoreErrors = $ignoreErrors;';
      }
    }
  }

  String _generateActionSource() {
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

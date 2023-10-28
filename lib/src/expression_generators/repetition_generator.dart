import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import 'expression_generators.dart';

class RepetitionGenerator extends ExpressionGenerator<RepetitionExpression> {
  RepetitionGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final min = expression.min;
    final max = expression.max;
    if (min != null && max != null) {
      if (min != max) {
        return _generateMinMax(min, max);
      } else {
        return _generateN(min);
      }
    } else if (min != null) {
      if (min == 0) {
        return _generateMin0();
      } else {
        return _generateMin(min);
      }
    } else {
      return _generateMax(max!);
    }
  }

  @override
  void generateAsync(BlockNode block) {
    final min = expression.min;
    final max = expression.max;
    if (min != null && max != null) {
      if (min != max) {
        _generateAsyncMinMax(block, min, max);
      } else {
        _generateAsyncN(block, min);
      }
    } else if (min != null) {
      if (min == 0) {
        _generateAsyncMin0(block);
      } else {
        _generateAsyncMin(block, min);
      }
    } else {
      _generateAsyncMax(block, max!);
    }
  }

  void _generateAsyncMax(BlockNode block, int max) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$list = <$elementType>[];';
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('$list.length < $max', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk(true);';
      block.if_('state.ok', (block) {
        block << '$variable = $list;';
      });
    } else {
      final count = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block << '$count = 0;';
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('$count < $max', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$count++;';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk(true);';
    }
  }

  void _generateAsyncMin(BlockNode block, int min) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$pos = state.pos;';
      block << '$list = <$elementType>[];';
      block << '$ignoreErrors = state.ignoreErrors;';
      block.while_('true', (block) {
        block << 'state.ignoreErrors = $list.length >= $min;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block.if_('$list.length >= $min', (block) {
        block << 'state.setOk(true);';
        block << '$variable = $list;';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    } else {
      final count = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      final ok = allocateName();
      block << '$pos = state.pos;';
      block << '$count = 0;';
      block << '$ignoreErrors = state.ignoreErrors;';
      block.while_('true', (block) {
        block << 'state.ignoreErrors = $count >= $min;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$count++;';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'final $ok = $count >= $min;';
      block.if_(ok, (block) {
        block << 'state.setOk(true);';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    }
  }

  void _generateAsyncMin0(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$list = <$elementType>[];';
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk(true);';
      block.if_('state.ok', (block) {
        block << '$variable = $list;';
      });
    } else {
      block << '$ignoreErrors = state.ignoreErrors;';
      block << 'state.ignoreErrors = true;';
      block.while_('true', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block << 'state.setOk(true);';
    }
  }

  void _generateAsyncMinMax(BlockNode block, int min, int max) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final ignoreErrors = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'bool'))
        .name;
    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$pos = state.pos;';
      block << '$list = <$elementType>[];';
      block << '$ignoreErrors = state.ignoreErrors;';
      block.while_('$list.length < $max', (block) {
        block << 'state.ignoreErrors = $list.length >= $min;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block.if_('$list.length >= $min', (block) {
        block << 'state.setOk(true);';
        block << '$variable = $list;';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    } else {
      final count = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block << '$pos = state.pos;';
      block << '$count = 0;';
      block << '$ignoreErrors = state.ignoreErrors;';
      block.while_('$count < $max', (block) {
        block << 'state.ignoreErrors = $count >= $min;';
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$count++;';
      });
      block << 'state.ignoreErrors = $ignoreErrors;';
      block.if_('$count >= $min', (block) {
        block << 'state.setOk(true);';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    }
  }

  void _generateAsyncN(BlockNode block, int n) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final child = expression.expression;
    final elementType = child.resultType!;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    final pos = asyncGenerator
        .allocateVariable(isLate: true, type: GenericType(name: 'int'))
        .name;
    if (variable != null) {
      final list = asyncGenerator
          .allocateVariable(
              isLate: true,
              type: GenericType(name: 'List', arguments: [elementType]))
          .name;
      final rv1 = getExpressionVariableWithNullCheck(child);
      block << '$pos = state.pos;';
      block << '$list = <$elementType>[];';
      block.while_('$list.length < $n', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$list.add($rv1);';
      });
      block.if_('$list.length == $n', (block) {
        block << 'state.setOk(true);';
        block << '$variable = $list;';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    } else {
      final count = asyncGenerator
          .allocateVariable(isLate: true, type: GenericType(name: 'int'))
          .name;
      block << '$pos = state.pos;';
      block << '$count = 0;';
      block.while_('$count < $n', (block) {
        generateAsyncExpression(block, child, true);
        block.if_('!state.ok', (block) {
          block.break_();
        });
        block << '$count++;';
      });
      block.if_('$count == $n', (block) {
        block << 'state.setOk(true);';
      }).else_((block) {
        block << 'state.backtrack($pos);';
      });
    }
  }

  String _generateMax(int max) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['ignore_errors'] = allocateName();
    values['max'] = '$max';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while ({{list}}.length < {{max}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
state.setOk(true);
if (state.ok) {
 {{r}} = {{list}};
}''';
    } else {
      values['count'] = allocateName();
      template = '''
var {{count}} = 0;
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while ({{count}} < {{max}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ignoreErrors = {{ignore_errors}};
state.setOk(true);''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMin(int min) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['ignore_errors'] = allocateName();
    values['pos'] = allocateName();
    values['min'] = '$min';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
final {{ignore_errors}} = state.ignoreErrors;
while (true) {
  state.ignoreErrors = {{list}}.length >= {{min}};
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
if ({{list}}.length >= {{min}}) {
  state.setOk(true);
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
final {{ignore_errors}} = state.ignoreErrors;
while (true) {
  state.ignoreErrors = {{count}} >= {{min}};
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ignoreErrors = {{ignore_errors}};
if ({{count}} >= {{min}}) {
state.setOk(true);
} else  {
  state.backtrack({{pos}});
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMin0() {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['ignore_errors'] = allocateName();
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{list}} = <{{O}}>[];
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
state.setOk(true);
if (state.ok) {
 {{r}} = {{list}};
}''';
    } else {
      template = '''
final {{ignore_errors}} = state.ignoreErrors;
state.ignoreErrors = true;
while (true) {
  {{p}}
  if (!state.ok) {
    break;
  }
}
state.ignoreErrors = {{ignore_errors}};
state.setOk(true);''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateMinMax(int min, int max) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['ignore_errors'] = allocateName();
    values['pos'] = allocateName();
    values['min'] = '$min';
    values['max'] = '$max';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
final {{ignore_errors}} = state.ignoreErrors;
while ({{list}}.length < {{max}}) {
  state.ignoreErrors = {{list}}.length >= {{min}};
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
state.ignoreErrors = {{ignore_errors}};
if ({{list}}.length >= {{min}}) {
  state.setOk(true);
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
final {{ignore_errors}} = state.ignoreErrors;
while ({{count}} < {{max}}) {
  state.ignoreErrors = {{count}} >= {{min}};
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
state.ignoreErrors = {{ignore_errors}};
if ({{count}} >= {{min}}) {
  state.setOk(true);
} else {
  state.backtrack({{pos}});
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }

  String _generateN(int n) {
    final values = <String, String>{};
    final child = expression.expression;
    final variable = ruleGenerator.getExpressionVariable(expression);
    if (variable != null) {
      ruleGenerator.allocateExpressionVariable(child);
    }

    values['pos'] = allocateName();
    values['n'] = '$n';
    var template = '';
    if (variable != null) {
      values['O'] = child.resultType.toString();
      values['list'] = allocateName();
      values['r'] = variable;
      values['rv'] = getExpressionVariableWithNullCheck(child);
      template = '''
final {{pos}} = state.pos;
final {{list}} = <{{O}}>[];
while ({{list}}.length < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{list}}.add({{rv}});
}
if ({{list}}.length == {{n}}) {
  state.setOk(true);
 {{r}} = {{list}};
} else {
  state.backtrack({{pos}});
}''';
    } else {
      values['count'] = allocateName();
      template = '''
final {{pos}} = state.pos;
var {{count}} = 0;
while ({{count}} < {{n}}) {
  {{p}}
  if (!state.ok) {
    break;
  }
  {{count}}++;
}
if ({{count}} == {{n}}) {
  state.setOk(true);
} else {
  state.backtrack({{pos}});
}''';
    }

    values['p'] = generateExpression(child, true);
    return render(template, values);
  }
}

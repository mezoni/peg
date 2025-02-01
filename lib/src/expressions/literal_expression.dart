import '../helper.dart' as helper;
import 'expression.dart';

class LiteralExpression extends Expression {
  final String literal;

  final bool silent;

  LiteralExpression({
    required this.literal,
    this.silent = false,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitLiteral(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    if (literal.isEmpty) {
      return _generateEmpty(context);
    } else if (literal.length == 1) {
      if (silent) {
        return _generate1Silent(context);
      } else {
        return _generate1(context);
      }
    } else if (literal.length < 9) {
      if (silent) {
        return _generateSilent(context);
      } else {
        return _generate(context);
      }
    } else {
      if (silent) {
        return _generateSlowSilent(context);
      } else {
        return _generateSlow(context);
      }
    }
  }

  String _generate(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final pos2 = context.allocate('pos');
    final length = literal.length;
    final input = context.allocateInputVariable();
    final values = {
      'escaped': helper.escapeString(literal),
      'input': input,
      'length': '${literal.length}',
      'literal': context.allocate('literal'),
      'pos': pos2,
    };

    final predicates = List.generate(length,
        (i) => '$input.codeUnitAt($pos2++) == ${literal.codeUnitAt(i)}');
    predicates.insert(0, 'state.position + $length <= $input.length');
    values['condition'] = predicates.join(' && ');
    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
var {{pos}} = {{$pos}};
if (state.isSuccess = {{condition}}) {
  state.position += {{length}};
  {{variable}} = {{literal}};
} else {
  state.fail();
}
state.expected({{literal}}, {{$pos}});''';
    } else {
      template = '''
const {{literal}} = {{escaped}};
var {{pos}} = {{$pos}};
state.isSuccess = {{condition}};
state.isSuccess ? state.position += {{length}} : state.fail();
state.expected({{literal}}, {{$pos}});''';
    }

    return render(context, this, template, values);
  }

  String _generate1(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'escaped': helper.escapeString(literal),
      'input': context.allocateInputVariable(),
      'literal': context.allocate('literal'),
    };

    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
if (state.isSuccess = {{$pos}} < {{input}}.length && {{input}}.codeUnitAt({{$pos}}) == {{char}}) {
  state.position++;
  {{variable}} = {{literal}};
} else {
  state.fail();
}
state.expected({{literal}}, {{$pos}});''';
    } else {
      template = '''
const {{literal}} = {{escaped}};
state.isSuccess = {{$pos}} < {{input}}.length && {{input}}.codeUnitAt({{$pos}}) == {{char}};
state.isSuccess ? state.position++ : state.fail();
state.expected({{literal}}, {{$pos}});''';
    }

    return render(context, this, template, values);
  }

  String _generate1Silent(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'escaped': helper.escapeString(literal),
      'input': context.allocateInputVariable(),
      'literal': context.allocate('literal'),
    };

    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
if (state.isSuccess = {{$pos}} < {{input}}.length && {{input}}.codeUnitAt({{$pos}}) == {{char}}) {
  state.position++;
  {{variable}} = {{literal}};
} else {
  state.fail();
}''';
    } else {
      template = '''
state.isSuccess = {{$pos}} < {{input}}.length && {{input}}.codeUnitAt({{$pos}}) == {{char}};
state.isSuccess ? state.position++ : state.fail();''';
    }

    return render(context, this, template, values);
  }

  String _generateEmpty(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = <String, String>{};
    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
        }
      }

      values['variable'] = variable;
      if (canDeclare) {
        template = '''
state.isSuccess = true;
final {{variable}} = state.isSuccess ? '' : null;''';
      } else {
        template = '''
state.isSuccess = true;
{{variable}} = state.isSuccess ? '' : null;''';
      }
    } else {
      template = '''
state.isSuccess = true;''';
    }

    return render(context, this, template, values);
  }

  String _generateSilent(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final pos2 = context.allocate('pos');
    final length = literal.length;
    final input = context.allocateInputVariable();
    final values = {
      'escaped': helper.escapeString(literal),
      'input': input,
      'length': '${literal.length}',
      'literal': context.allocate('literal'),
      'pos': pos2,
    };

    final predicates = List.generate(length,
        (i) => '$input.codeUnitAt($pos2++) == ${literal.codeUnitAt(i)}');
    predicates.insert(0, 'state.position + $length <= $input.length');
    values['condition'] = predicates.join(' && ');
    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
var {{pos}} = {{$pos}};
if (state.isSuccess = {{condition}}) {
  state.position += {{length}};
  {{variable}} = {{literal}};
} else {
  state.fail();
}''';
    } else {
      template = '''
var {{pos}} = {{$pos}};
state.isSuccess = {{condition}};
state.isSuccess ? state.position += {{length}} : state.fail();''';
    }

    return render(context, this, template, values);
  }

  String _generateSlow(ProductionRuleContext context) {
    const pos = Expression.positionVariableKey;
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'escaped': helper.escapeString(literal),
      'length': '${literal.length}',
      'literal': context.allocate('literal'),
      'pos': context.allocate('pos'),
    };

    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
if (state.isSuccess = state.position + {{length}} <= state.input.length && state.input.codeUnitAt(state.position) == {{char}}) {
  state.isSuccess = state.input.startsWith({{literal}}, state.position);
  if (state.isSuccess) {
    state.position += {{length}};
    {{variable}} = {{literal}};
  }
}
if (!state.isSuccess) {
  state.fail();
}
state.expected({{literal}}, {{$pos}});''';
    } else {
      template = '''
const {{literal}} = {{escaped}};
if (state.isSuccess = state.position + {{length}} <= state.input.length && state.input.codeUnitAt(state.position) == {{char}}) {
  state.isSuccess = state.input.startsWith({{literal}}, state.position);
  if (state.isSuccess) {
    state.position += {{length}};
  }
}
if (!state.isSuccess) {
  state.fail();
}
state.expected({{literal}}, {{$pos}});''';
    }

    return render(context, this, template, values);
  }

  String _generateSlowSilent(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'escaped': helper.escapeString(literal),
      'length': '${literal.length}',
      'literal': context.allocate('literal'),
      'pos': context.allocate('pos'),
    };

    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      template = '''
const {{literal}} = {{escaped}};
if (state.isSuccess = state.position + {{length}} <= state.input.length && state.input.codeUnitAt(state.position) == {{char}}) {
  state.isSuccess = state.input.startsWith({{literal}}, state.position);
  if (state.isSuccess) {
    state.position += {{length}};
    {{variable}} = {{literal}};
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
    } else {
      template = '''
if (state.isSuccess = state.position + {{length}} <= state.input.length && state.input.codeUnitAt(state.position) == {{char}}) {
  state.isSuccess = state.input.startsWith({{literal}}, state.position);
  if (state.isSuccess) {
    state.position += {{length}};
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
    }

    return render(context, this, template, values);
  }
}

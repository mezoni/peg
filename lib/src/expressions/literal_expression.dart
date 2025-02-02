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
      return _generate1(context);
    } else if (literal.length == 2) {
      return _generate2(context);
    } else {
      return _generate(context);
    }
  }

  String _generate1(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'escaped': helper.escapeString(literal),
      'silent_arg': silent ? ', true' : '',
    };

    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      template = '''
{{declare}}{{variable}} = state.match1({{escaped}}, {{char}}{{silent_arg}});''';
    } else {
      template = '''
state.match1({{escaped}}, {{char}}{{silent_arg}});''';
    }

    return render(context, this, template, values);
  }

  String _generate2(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = {
      'char': '${literal.codeUnitAt(0)}',
      'char2': '${literal.codeUnitAt(1)}',
      'escaped': helper.escapeString(literal),
      'silent_arg': silent ? ', true' : '',
    };

    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      template = '''
{{declare}}{{variable}} = state.match2({{escaped}}, {{char}}, {{char2}}{{silent_arg}});''';
    } else {
      template = '''
state.match2({{escaped}}, {{char}}, {{char2}}{{silent_arg}});''';
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
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      template = '''
state.isSuccess = true;
{{declare}}{{variable}} = state.isSuccess ? '' : null;''';
    } else {
      template = '''
state.isSuccess = true;''';
    }

    return render(context, this, template, values);
  }

  String _generate(ProductionRuleContext context) {
    final variable = context.getExpressionVariable(this);
    final values = {
      'escaped': helper.escapeString(literal),
      'silent_arg': silent ? ', true' : '',
    };

    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      template = '''
{{declare}}{{variable}} = state.match({{escaped}}{{silent_arg}});''';
    } else {
      template = '''
state.match({{escaped}}{{silent_arg}});''';
    }

    return render(context, this, template, values);
  }
}

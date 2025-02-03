import '../allocator.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import '../parser_generator.dart';
import 'expression_printer.dart';
import 'expression_visitors.dart';

export 'expression_visitors.dart';

abstract class Expression {
  static const positionVariableKey = '__pos__';

  int? id;

  int? index;

  bool isLast = false;

  bool isGrouped = false;

  int level = 0;

  Expression? parent;

  String resultType = '';

  ProductionRule? rule;

  String? semanticVariable;

  String semanticVariableType = '';

  T accept<T>(ExpressionVisitor<T> visitor);

  String assignResult(ProductionRuleContext context, String value) {
    final variable = context.getExpressionVariable(this);
    final isVariableDeclared = context.isExpressionVariableDeclared(variable);
    var canDeclare = false;
    var code = '$variable = $value;';
    if (!isVariableDeclared) {
      canDeclare = this == context.getExpressionVariableDeclarator(variable);
      if (canDeclare) {
        context.setExpressionVariableDeclared(variable);
        code = '''
final $code''';
      }
    }

    return code;
  }

  String generate(ProductionRuleContext context);

  String getResultType() {
    if (resultType.isEmpty) {
      return 'void';
    } else {
      return resultType;
    }
  }

  String getResultValue(String name) {
    return '$name.\$1';
  }

  String render(ProductionRuleContext context, Expression expression,
      String template, Map<String, String> values) {
    final variable = context.getExpressionVariable(expression);
    final options = context.options;
    if (!context.isExpressionVariableDeclared(variable)) {
      final declarator = context.getExpressionVariableDeclarator(variable);
      if (expression == declarator) {
        context.setExpressionVariableDeclared(variable);
        final type = expression.getResultType();
        template = '''
($type,)? $variable;
$template ''';
      }
    }

    var positionDeclaration = '';
    var positionVariable = '';
    const positionKeyText = '{{$positionVariableKey}}';
    final hasPositionVariable = template.contains(positionKeyText);
    if (hasPositionVariable) {
      if (expression.index == 0) {
        // TODO
        String plunge(Expression expression) {
          final parent = expression.parent;
          if (parent != null) {
            if (parent is! OneOrMoreExpression) {
              if (parent is! ZeroOrMoreExpression) {
                if (parent.index == 0) {
                  return plunge(parent);
                }
              }
            }
          }

          final position = context.positionVariables[expression];
          if (position == null) {
            positionVariable = context.allocate('pos');
            context.positionVariables[expression] = positionVariable;
            context.positionVariableDeclarators.add(expression);
          } else {
            positionVariable = position;
          }

          return positionVariable;
        }

        positionVariable = plunge(expression);
      } else {
        positionVariable = context.allocate('pos');
        context.positionVariables[expression] = positionVariable;
        context.positionVariableDeclarators.add(expression);
      }

      values[positionVariableKey] = positionVariable;
    }

    if (context.positionVariableDeclarators.contains(expression)) {
      final position = context.positionVariables[expression]!;
      positionDeclaration = 'final $position = state.position;';
    }

    var code = helper.render(template, values);
    if (positionDeclaration.isNotEmpty) {
      code = '''
$positionDeclaration
$code''';
    }

    if (options.addComments) {
      var skip = false;
      final parent = expression.parent;
      if (parent != null) {
        skip = '$parent' == '$expression';
      }

      if (!skip) {
        code = '''
 // >> $expression
$code
 // << $expression''';
      }
    }

    return code;
  }

  @override
  String toString() {
    final printer = ExpressionPrinter();
    return printer.print(this);
  }

  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    //
  }
}

abstract class MultiExpression extends Expression {
  final List<Expression> expressions;

  MultiExpression({required this.expressions}) {
    if (expressions.isEmpty) {
      throw ArgumentError('Must bot be empty', 'expressions');
    }
  }

  @override
  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      expression.accept(visitor);
    }
  }
}

class ProductionRuleContext {
  Allocator allocator;

  final List<(Expression, String)> errors = [];

  String? inputVariable;

  final ParserGeneratorOptions options;

  final Map<Expression, String> positionVariables = {};

  final Set<Expression> positionVariableDeclarators = {};

  final Set<String> _declaredExpressionVariables = {};

  final Map<Expression, bool> _expressionResultUsage = {};

  final Map<String, Expression> _expressionVariableDeclarators = {};

  final Map<Expression, String> _expressionVariables = {};

  ProductionRuleContext({
    required this.allocator,
    required this.options,
  });

  void addError(Expression expression, String message) {
    errors.add((expression, message));
  }

  String allocate([String name = '']) => allocator.allocate(name);

  String allocateExpressionVariable(Expression expression) {
    if (_expressionVariables.containsKey(expression)) {
      throw StateError(
          'The expression variable has already been set\n$expression');
    }

    final variable = allocate();
    _expressionVariables[expression] = variable;
    _expressionVariableDeclarators[variable] = expression;
    return variable;
  }

  String allocateInputVariable() {
    inputVariable ??= allocate('input');
    return inputVariable!;
  }

  bool changeExpressionVariableDeclarator(
      String variable, Expression oldDeclarator, Expression newDeclarator) {
    final isVariableDeclared = isExpressionVariableDeclared(variable);
    if (isVariableDeclared) {
      return false;
    }

    final declarator = _expressionVariableDeclarators[variable];
    if (oldDeclarator != declarator) {
      return false;
    }

    _expressionVariableDeclarators[variable] = newDeclarator;
    return true;
  }

  bool copyExpressionResultUsage(Expression parent, Expression child) {
    final used = getExpressionResultUsage(parent);
    setExpressionResultUsage(child, used);
    return used;
  }

  bool getExpressionResultUsage(Expression expression) {
    if (!_expressionResultUsage.containsKey(expression)) {
      throw StateError(
          'The expression result usage has not been set\n$expression');
    }

    return _expressionResultUsage[expression] ?? true;
  }

  String getExpressionVariable(Expression expression) {
    if (!_expressionVariables.containsKey(expression)) {
      throw StateError('The expression variable has not been set\n$expression');
    }

    return _expressionVariables[expression]!;
  }

  Expression getExpressionVariableDeclarator(String variable) {
    if (!_expressionVariableDeclarators.containsKey(variable)) {
      throw StateError(
          'The expression variable declarator has not been set\n$variable');
    }

    return _expressionVariableDeclarators[variable]!;
  }

  bool isExpressionVariableDeclared(String variable) {
    return _declaredExpressionVariables.contains(variable);
  }

  void setExpressionResultUsage(Expression expression, bool used) {
    if (_expressionResultUsage.containsKey(expression)) {
      throw StateError(
          'The expression result usage has already been set\n$expression');
    }

    _expressionResultUsage[expression] = used;
  }

  void setExpressionVariable(Expression expression, String result) {
    if (_expressionVariables.containsKey(expression)) {
      throw StateError(
          'The expression variable has already been set\n$expression');
    }

    _expressionVariables[expression] = result;
  }

  void setExpressionVariableDeclared(String variable) {
    if (!_declaredExpressionVariables.add(variable)) {
      throw StateError('Expression variable already declared');
    }
  }

  void setExpressionVariableType(Expression expression, String type) {
    if (_expressionVariables.containsKey(expression)) {
      throw StateError(
          'The expression variable has already been set\n$expression');
    }

    _expressionVariables[expression] = type;
  }
}

abstract class SingleExpression extends Expression {
  final Expression expression;

  SingleExpression({required this.expression});

  @override
  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    expression.accept(visitor);
  }
}

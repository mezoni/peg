import '../grammar/production_rule.dart';
import '../helper.dart';
import 'build_context.dart';
import 'expression_printer.dart';

export 'expression_visitors.dart';

abstract class Expression {
  static const position = 'state.position';

  int? id;

  int? index;

  bool isAlwaysSuccessful = false;

  bool isLast = false;

  bool isNulled = true;

  int level = 0;

  bool mayNotConsume = false;

  Expression? parent;

  String resultType = '';

  ProductionRule? rule;

  T accept<T>(ExpressionVisitor<T> visitor);

  String generate(BuildContext context, Variable? variable, bool isFast);

  ({String enter, String leave}) generateEnterLeave(BuildContext context) {
    final failure = context.allocate();
    final buffer = StringBuffer();
    buffer.statement('final $failure = state.failure');
    buffer.statement('state.failure = state.position');
    final test =
        conditional('state.failure < $failure', failure, 'state.failure');
    final leave = '''
state.failure = $test;''';
    return (enter: '$buffer', leave: leave);
  }

  String getGenericParameter(Variable? variable) {
    var parameter = '';
    if (variable != null) {
      final resultType = getResultType();
      final type = variable.type;
      if (type.isEmpty || type == 'void') {
        return '<$resultType>';
      }
    } else {
      parameter = '<void>';
    }

    return parameter;
  }

  String getResultType() {
    if (resultType.isEmpty) {
      return 'void';
    } else {
      return resultType;
    }
  }

  String getReturnType() {
    final type = getResultType();
    return '($type,)?';
  }

  String getStateTest(Variable? variable, bool isSuccess) {
    if (variable != null && isNulled) {
      return isSuccess ? '$variable != null' : '$variable == null';
    }

    return '$isSuccess';
  }

  bool isFastOrVoid(bool isFast) => isFast || resultType == 'void';

  bool isVariableNeedForTestState() {
    return !isAlwaysSuccessful;
  }

  String postprocess(BuildContext context, StringSink sink) {
    final sharedValues = context.sharedValues[this] ?? const {};
    for (final entry in sharedValues.entries) {
      final value = entry.key;
      final sharedValue = entry.value;
      final name = sharedValue.name;
      if (name.isNotEmpty) {
        if (sharedValue.expression == this) {
          final temp = '$sink';
          sink = StringBuffer();
          sink.statement('final $name = $value');
          sink.write(temp);
        }
      }
    }

    return '$sink';
  }

  StringSink preprocess(BuildContext context) {
    final sink = StringBuffer();
    return sink;
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

abstract class SingleExpression extends Expression {
  final Expression expression;

  SingleExpression({required this.expression});

  @override
  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    expression.accept(visitor);
  }
}

class Variable {
  bool needDeclare;

  final String name;

  String type;

  Variable({
    required this.name,
    this.needDeclare = true,
    this.type = '',
  });

  void assign(StringSink sink, String value) {
    final buffer = StringBuffer();
    if (needDeclare) {
      needDeclare = false;
      var type = this.type;
      if (value.trimLeft().startsWith('const')) {
        type = 'const';
        value = value.trimLeft().substring('const'.length).trimLeft();
      } else {
        switch (value.trim()) {
          case 'false':
          case 'null':
          case 'true':
          case "''":
          case '""':
          case '(null,)':
            type = 'const';
            break;
          default:
        }
      }

      type = type.isEmpty ? 'final' : type;
      buffer.write('$type $name');
      if (value.isNotEmpty) {
        buffer.write(' = $value');
      }
    } else {
      buffer.write('$name = $value');
    }

    sink.statement('$buffer');
  }

  @override
  String toString() {
    return name;
  }
}

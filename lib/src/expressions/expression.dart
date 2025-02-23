import '../grammar/production_rule.dart';
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

  void generate(BuildContext context, BuildResult result);

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
          sink.writeln('final $name = $value;');
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

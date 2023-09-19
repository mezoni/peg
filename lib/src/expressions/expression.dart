import '../grammar/production_rule.dart';
import '../visitors/visitors.dart';

export '../type_system/result_type.dart';
export '../visitors/visitors.dart';

abstract class Expression {
  int? id;

  int? index;

  bool isLast = false;

  int level = 0;

  Expression? parent;

  ProductionRule? rule;

  ResultType? resultType;

  String? semanticVariable;

  bool isOptional = false;

  T accept<T>(ExpressionVisitor<T> visitor);

  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    //
  }
}

abstract class MultipleExpression extends Expression {
  final List<Expression> expressions;

  MultipleExpression({
    required this.expressions,
  });

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

  SingleExpression({
    required this.expression,
  });

  @override
  void visitChildren<T>(ExpressionVisitor<T> visitor) {
    expression.accept(visitor);
  }
}

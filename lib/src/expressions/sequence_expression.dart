import 'expression.dart';

class SemanticAction {
  final String source;

  final ResultType? resultType;

  SemanticAction({
    required this.source,
    this.resultType,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    if (resultType != null) {
      buffer.write('<$resultType>');
    }

    buffer.write('{$source}');
    return buffer.toString();
  }
}

class SequenceExpression extends MultipleExpression {
  SemanticAction? action;

  String? handler;

  SequenceExpression({
    this.action,
    required super.expressions,
    this.handler,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSequence(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(expressions.map((e) {
      final variable = e.semanticVariable;
      if (variable != null) {
        return '$variable:$e';
      }

      return '$e';
    }).join(' '));
    if (action != null) {
      //buffer.write(action);
    }

    return buffer.toString();
  }
}

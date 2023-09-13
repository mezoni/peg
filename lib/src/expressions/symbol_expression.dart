import '../grammar/production_rule.dart';
import 'expression.dart';

class SymbolExpression extends Expression {
  final String name;

  ProductionRule? reference;

  SymbolExpression({
    required this.name,
    this.reference,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitSymbol(this);
  }

  @override
  String toString() {
    return name;
  }
}

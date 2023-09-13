import '../expressions/expressions.dart';

class ExpressionFinder with ExpressionVisitorMixin<void> {
  final bool Function(Expression node) filter;

  ExpressionFinder({
    required this.filter,
  });

  @override
  void visitNode(Expression node) {
    if (!filter(node)) {
      return;
    }

    node.visitChildren(this);
    return;
  }
}

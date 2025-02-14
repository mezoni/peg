import '../helper.dart';
import 'build_context.dart';

class PredicateExpression extends Expression {
  final String code;

  final bool negate;

  PredicateExpression({
    required this.code,
    required this.negate,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitPredicate(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    var value = '';
    switch (code.trim()) {
      case 'false':
        value = !negate ? 'state.fail<void>()' : '(null,)';
        break;
      case 'true':
        value = !negate ? '(null,)' : 'state.fail<void>()';
        break;
      default:
        value = !negate
            ? conditional(code, '(null,)', 'state.fail<void>()')
            : conditional(code, 'state.fail<void>()', '(null,)');
    }

    if (variable != null) {
      variable.assign(sink, value);
    } else {
      final hasCalculation = value != '(null,)';
      if (hasCalculation) {
        sink.statement(value);
      }
    }

    return postprocess(context, sink);
  }
}

import '../expressions/expressions.dart';
import 'expression_generator.dart';

class NotPredicateGenerator
    extends ExpressionGenerator<NotPredicateExpression> {
  static const _template = '''
final {{pos}} = state.pos;
{{p}}
state.ok = !state.ok;
if (!state.ok) {
  state.pos = {{pos}};
}''';

  NotPredicateGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final optimized = _NotPredicateGenerator2.optimize(this);
    if (optimized != null) {
      return optimized;
    }

    final values = <String, String>{};
    final child = expression.expression;
    values['pos'] = allocateName();
    values['p'] = generateExpression(child, false);
    return render(_template, values);
  }
}

class _NotPredicateGenerator2
    extends ExpressionGenerator<NotPredicateExpression> {
  static const _template = '''
state.ok = state.pos >= state.input.length;
if (!state.ok) {
  state.fail(const ErrorUnexpectedCharacter());
}''';

  _NotPredicateGenerator2({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    return render(_template, const {});
  }

  static String? optimize(NotPredicateGenerator generator) {
    final expression = generator.expression;
    final child = expression.expression;
    if (child is! AnyCharacterExpression) {
      return null;
    }

    final generator2 = _NotPredicateGenerator2(
      expression: expression,
      ruleGenerator: generator.ruleGenerator,
    );
    return generator2.generate();
  }
}

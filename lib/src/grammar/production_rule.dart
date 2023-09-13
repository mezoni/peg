import '../expressions/expressions.dart';

class ProductionRule {
  final Set<ProductionRule> allCallees = {};

  final Set<SymbolExpression> allCallers = {};

  final Set<ProductionRule> directCallees = {};

  final Set<SymbolExpression> directCallers = {};

  final OrderedChoiceExpression expression;

  final List<String>? metadata;

  final List<String>? parameters;

  final String name;

  final ResultType? resultType;

  ProductionRule({
    required this.expression,
    this.metadata,
    required this.name,
    this.parameters,
    this.resultType,
  });

  bool get isFast {
    if (metadata == null) {
      return false;
    }

    return metadata!.contains('@fast');
  }

  bool get isInline {
    if (metadata == null) {
      return false;
    }

    return metadata!.contains('@inline');
  }

  bool get isMacro => parameters != null;

  @override
  String toString() {
    final buffer = StringBuffer();
    if (resultType != null) {
      buffer.write(resultType);
      buffer.write(' ');
    }

    if (metadata case final metadata?) {
      if (metadata.isNotEmpty) {
        buffer.write(metadata.join(' '));
        buffer.write(' ');
      }
    }

    buffer.write(name);
    if (parameters case final parameters?) {
      buffer.write('(');
      buffer.write(parameters.join(', '));
      buffer.write(')');
    }

    buffer.write(' = ');
    buffer.write(expression);
    buffer.write(' ;');
    return buffer.toString();
  }
}

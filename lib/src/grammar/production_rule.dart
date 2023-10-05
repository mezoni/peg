import '../expressions/expressions.dart';
import '../helper.dart' as helper;

class ProductionRule {
  final Set<ProductionRule> allCallees = {};

  final Set<SymbolExpression> allCallers = {};

  final Set<ProductionRule> directCallees = {};

  final Set<SymbolExpression> directCallers = {};

  final OrderedChoiceExpression expression;

  final List<({String name, List<Object?> arguments})>? metadata;

  final String name;

  final ResultType? resultType;

  ProductionRule({
    required this.expression,
    this.metadata,
    required this.name,
    this.resultType,
  });

  bool hasEvent() {
    if (metadata case final metadata?) {
      return metadata.any((e) => e.name == '@event');
    }

    return false;
  }

  bool isInline() {
    if (metadata case final metadata?) {
      return metadata.any((e) => e.name == '@inline');
    }

    return false;
  }

  List<String> metadataToPrintableList() {
    final result = <String>[];
    if (metadata case final metadata?) {
      for (var i = 0; i < metadata.length; i++) {
        final element = metadata[i];
        final name = element.name;
        final arguments = element.arguments;
        final buffer = StringBuffer();
        buffer.write(name);
        if (arguments.isNotEmpty) {
          buffer.write('(');
          for (final argument in arguments) {
            if (argument is String) {
              buffer.write(helper.escapeString(argument));
            } else {
              buffer.write(argument);
            }
          }

          buffer.write(')');
        }

        result.add(buffer.toString());
      }
    }

    return result;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    if (resultType != null) {
      buffer.write(resultType);
      buffer.write(' ');
    }

    if (metadata != null) {
      final list = metadataToPrintableList();
      if (list.isNotEmpty) {
        buffer.write(list.join(' '));
        buffer.write(' ');
      }
    }

    buffer.write(name);
    buffer.write(' = ');
    buffer.write(expression);
    buffer.write(' ;');
    return buffer.toString();
  }
}

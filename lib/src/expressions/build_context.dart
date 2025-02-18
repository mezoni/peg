import '../allocator.dart';
import '../parser_generator_diagnostics.dart';
import '../parser_generator_options.dart';
import 'expression.dart';

export 'expression.dart';

class BuildContext {
  Allocator allocator;

  final ParserGeneratorDiagnostics diagnostics;

  final ParserGeneratorOptions options;

  final Map<Expression, Map<String, SharedValue>> sharedValues = {};

  BuildContext({
    required this.allocator,
    required this.diagnostics,
    required this.options,
  });

  void addSharedValues(Expression expression, List<String> values) {
    final map = sharedValues[expression] ??= {};
    for (final value in values) {
      if (!map.containsKey(value)) {
        map[value] = SharedValue(expression);
      }
    }
  }

  String allocate([String name = '']) => allocator.allocate(name);

  Variable allocateVariable({
    bool condition = true,
    bool needDeclare = true,
    String type = '',
  }) {
    final variable =
        Variable(name: allocate(), needDeclare: needDeclare, type: type);
    return variable;
  }

  SharedValue getSharedValue(Expression expression, String value) {
    final values = sharedValues[expression] ??= {};
    var sharedValue = values[value];
    if (sharedValue == null) {
      sharedValue = SharedValue(expression);
      values[value] = sharedValue;
    }

    if (sharedValue.name.isEmpty) {
      sharedValue.name = allocate();
    }

    return sharedValue;
  }

  void shareValues(Expression parent, Expression child, List<String> values) {
    final parentValues = sharedValues[parent];
    if (parentValues == null) {
      return;
    }

    for (final value in values) {
      final sharedValue = parentValues[value];
      if (sharedValue != null) {
        final childValues = sharedValues[child] ??= {};
        childValues[value] = sharedValue;
      }
    }
  }
}

class SharedValue {
  final Expression expression;

  String name = '';

  SharedValue(this.expression);

  @override
  String toString() {
    return name.isNotEmpty ? name : 'UNNAMED_SHARED_VALUE';
  }
}

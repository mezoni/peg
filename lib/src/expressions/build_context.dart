import '../allocator.dart';
import '../helper.dart';
import '../parser_generator_diagnostics.dart';
import '../parser_generator_options.dart';
import 'code_gen.dart';
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

class BuildResult {
  final CodeGen code;

  final BuildContext context;

  final Expression expression;

  final bool isUsed;

  Value? _value;

  BuildResult({
    required this.context,
    required this.expression,
    required this.isUsed,
  }) : code = CodeGen(expression);

  Value get value {
    if (_value == null) {
      throw StateError('The value has not yet been set');
    }

    return _value!;
  }

  set value(Value value) {
    if (!isUsed) {
      throw StateError('The value cannot be set because the value is not used');
    }

    if (_value != null) {
      throw StateError('The value has already been set');
    }

    _value = value;
  }

  Branch branch() {
    ICodeGen code = this.code;
    while (true) {
      if (code is! CodeGen) {
        break;
      }

      if (!code.hasCode) {
        break;
      }

      final last = code.last;
      if (last is Branch) {
        return last;
      }

      code = last;
    }

    throw StateError('''
The generated code does not end with the branch.
Generator: $code
Generator type: ${code.runtimeType}''');
  }

  BuildResult copy(Expression expression) {
    return BuildResult(
      context: context,
      expression: expression,
      isUsed: isUsed,
    );
  }

  void copyValueTo(BuildResult result) {
    if (isUsed) {
      result.value = value;
    }
  }

  String getIntermediateType() {
    return getNullableType(expression.getResultType());
  }

  void postprocess(Expression expression) {
    if (expression != this.expression) {
      throw StateError('''
The result of another expression cannot be postprocessed.
Result expression: ${this.expression}
Result expression type: ${this.expression.runtimeType}
Expression: $expression
Expression type: ${expression.runtimeType}''');
    }

    if (isUsed) {
      // ignore: unused_local_variable
      final temp = value;
    }

    branch();
    final init = CodeGen();
    final sharedValues = context.sharedValues[expression] ?? const {};
    for (final entry in sharedValues.entries) {
      final value = entry.key;
      final sharedValue = entry.value;
      final name = sharedValue.name;
      if (name.isNotEmpty) {
        if (sharedValue.expression == expression) {
          init.statement('final $name = $value');
        }
      }
    }

    if (init.hasCode) {
      code.insert(init);
    }
  }

  void preprocess(Expression expression) {
    if (expression != this.expression) {
      throw StateError('''
The result of another expression cannot be preprocessed.
Result expression: ${this.expression}
Result expression type: ${this.expression.runtimeType}
Expression: $expression
Expression type: ${expression.runtimeType}''');
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

class Value {
  final String? boxed;

  final bool isConst;

  final String code;

  Value(
    this.code, {
    this.boxed,
    this.isConst = false,
  });

  @override
  String toString() {
    return code;
  }
}

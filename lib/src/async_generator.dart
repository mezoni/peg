import 'allocator.dart';
import 'async_generators/action_node.dart';
import 'type_system/result_type.dart';

class AsyncGenerator {
  final Allocator allocator;

  int _buffering = 0;

  final String functionName;

  final List<({bool isLate, String name, ResultType type, String? value})>
      variables = [];

  AsyncGenerator({
    required this.allocator,
    required this.functionName,
  });

  ({bool isLate, String name, ResultType type, String? value}) addVariable({
    bool isLate = false,
    required String name,
    required ResultType type,
    String? value,
  }) {
    final variable = (isLate: isLate, name: name, type: type, value: value);
    variables.add(variable);
    return variable;
  }

  ({bool isLate, String name, ResultType type, String? value})
      allocateVariable({
    bool isLate = false,
    required ResultType type,
    String? value,
  }) {
    final name = allocator.allocate();
    return addVariable(isLate: isLate, name: name, type: type, value: value);
  }

  void beginBuffering(BlockNode block) {
    if (_buffering++ == 0) {
      block << 'state.input.beginBuffering();';
    }
  }

  void endBuffering(BlockNode block) {
    if (--_buffering == 0) {
      block << 'state.input.endBuffering();';
    }
  }
}

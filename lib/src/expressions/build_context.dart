import '../allocator.dart';
import '../parser_generator_diagnostics.dart';
import '../parser_generator_options.dart';
import 'expression.dart';

export 'expression.dart';

class BuildContext {
  Allocator allocator;

  final ParserGeneratorDiagnostics diagnostics;

  final ParserGeneratorOptions options;

  BuildContext({
    required this.allocator,
    required this.diagnostics,
    required this.options,
  });

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
}

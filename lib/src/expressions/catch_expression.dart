import '../helper.dart';
import 'build_context.dart';

class CatchExpression extends SingleExpression {
  final String catchBlock;

  final List<(String, String)> parameters;

  CatchExpression({
    required super.expression,
    required this.catchBlock,
    this.parameters = const [],
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCatch(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    var message = 'UNKNOWN_ERROR';
    var origin = '';
    var start = 'start';
    var end = 'end';
    for (var i = 0; i < parameters.length; i++) {
      final parameter = parameters[i];
      final name = parameter.$1;
      final value = parameter.$2;
      switch (name) {
        case 'message':
          message = value;
          break;
        case 'origin':
          origin = value;
          break;
        case 'start':
          start = value;
          break;
        case 'end':
          end = value;
          break;
        default:
          throw StateError('Invalid argument: $name');
      }
    }

    Never invalidValue(String name, String value) {
      throw StateError("Invalid argument '$value' for parameter '$name'");
    }

    final originTest = switch (origin) {
      '' => 'true',
      '==start' => 'state.failure == state.position',
      '!=start' => 'state.failure != state.position',
      _ => throw invalidValue('starts', origin),
    };

    start == 'start' || start == 'end' ? null : invalidValue('start', start);
    end == 'start' || end == 'end' ? null : invalidValue('end', end);
    final span = switch ((start, end)) {
      ('end', 'end') => ', true',
      ('start', 'end') => '',
      ('start', 'start') => ', false',
      _ => '',
    };

    final enterLeave = expression.generateEnterLeave(context);
    sink.writeln(enterLeave.enter);
    if (variable == null) {
      if (expression.isVariableNeedForTestState()) {
        variable = context.allocateVariable();
      }
    }

    sink.writeln(expression.generate(context, variable, isFast));
    final isFailure = expression.getStateTest(variable, false);
    sink.ifStatement(isFailure, (block) {
      final escapedMessage = escapeString(message, "'");
      block.ifStatement(originTest, (block) {
        block.statement('state.error($escapedMessage$span)');
      });
    });
    sink.writeln(enterLeave.leave);
    return postprocess(context, sink);
  }
}

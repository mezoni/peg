import '../helper.dart';
import 'build_context.dart';

class CatchExpression extends SingleExpression {
  final List<(String, String)> parameters;

  CatchExpression({
    required super.expression,
    this.parameters = const [],
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCatch(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    context.shareValues(this, expression, [Expression.position]);
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

    Never invalidArgument(String name, String value) {
      throw StateError("Invalid argument '$value' for parameter '$name'");
    }

    final originTest = switch (origin) {
      '' => 'true',
      '== start' => 'state.failure == state.position',
      '!= start' => 'state.failure != state.position',
      _ => throw invalidArgument('origin', origin),
    };

    const flagUseStart = 1;
    const flagUseEnd = 2;
    start == 'start' || start == 'end' ? null : invalidArgument('start', start);
    end == 'start' || end == 'end' ? null : invalidArgument('end', end);
    final flag = switch ((start, end)) {
      ('end', 'end') => flagUseEnd,
      ('start', 'end') => flagUseStart | flagUseEnd,
      ('start', 'start') => flagUseStart,
      _ => flagUseStart | flagUseEnd,
    };

    final childResult = result.copy(expression);

    expression.generate(context, childResult);

    final failure = context.allocate();
    final branch = childResult.branch();
    branch.falsity.block((b) {
      final escapedMessage = escapeString(message, "'");
      final control = b.branch(originTest, '!($originTest)');
      control.truth.block((b) {
        b.statement(
            'state.error($escapedMessage, state.position, state.failure, $flag)');
      });
      b.statement('state.failure < $failure ? state.failure = $failure : null');
    });

    branch.truth.block((b) {
      b.statement('state.failure < $failure ? state.failure = $failure : null');
    });

    final code = result.code;
    code.statement('final $failure = state.failure');
    code.statement('state.failure = state.position');
    code.add(childResult.code);
    childResult.copyValueTo(result);
    result.postprocess(this);
  }
}

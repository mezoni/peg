import '../helper.dart';
import 'build_context.dart';

class LiteralExpression extends Expression {
  final String literal;

  final bool silent;

  LiteralExpression({
    required this.literal,
    this.silent = false,
  });

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitLiteral(this);
  }

  @override
  void generate(BuildContext context, BuildResult result) {
    if (literal.isEmpty) {
      _generateEmpty(context, result);
      return;
    }

    final runes = literal.runes;
    if (runes.length == 1) {
      final char = runes.first;
      _generate1(context, result, char);
    } else {
      _generate(context, result);
    }
  }

  void _generate(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final runes = literal.runes.toList();
    final char = runes.first;
    final escaped = escapeString(literal, "'");
    final code = result.code;
    final test =
        'state.peek() == $char && state.startsWith($escaped, state.position)';
    if (silent) {
      final branch = code.branch(test, '!($test)');
      branch.truth.block((b) {
        b.statement('state.position += state.strlen($escaped)');
      });

      branch.falsity.block((b) {
        b.statement('state.fail()');
      });
    } else {
      final position = context.getSharedValue(this, Expression.position);
      final branch = code.branch(test, '!($test)');
      branch.truth.block((b) {
        b.statement('state.consume($escaped, $position)');
      });

      branch.falsity.block((b) {
        b.statement('state.expected($escaped)');
      });
    }

    if (result.isUsed) {
      result.value = Value(escaped, isConst: true);
    }

    result.postprocess(this);
  }

  void _generate1(BuildContext context, BuildResult result, int char) {
    result.preprocess(this);
    final escaped = escapeString(literal, "'");
    final code = result.code;
    final branch =
        code.branch('state.peek() == $char', 'state.peek() != $char');

    if (silent) {
      branch.truth.block((b) {
        b.statement('state.position += state.charSize($char)');
      });

      branch.falsity.block((b) {
        b.statement('state.fail()');
      });
    } else {
      final position = context.getSharedValue(this, Expression.position);
      branch.truth.block((b) {
        b.statement('state.consume($escaped, $position)');
      });

      branch.falsity.block((b) {
        b.statement('state.expected($escaped)');
      });
    }

    if (result.isUsed) {
      result.value = Value(escaped, isConst: true);
    }

    result.postprocess(this);
  }

  void _generateEmpty(BuildContext context, BuildResult result) {
    result.preprocess(this);
    final code = result.code;
    code.branch('true', 'false');
    if (result.isUsed) {
      result.value = Value("''", isConst: true);
    }

    result.postprocess(this);
  }
}

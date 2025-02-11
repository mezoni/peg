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
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    final length = literal.length;
    if (silent) {
      if (length == 0) {
        return _generateEmpty(context, variable, sink);
      } else if (literal.length <= 5) {
        return _generateMatchN(context, variable, sink);
      } else {
        return _generateMatch(context, variable, sink);
      }
    }

    if (length > 0 && length <= 5) {
      return _generateLiteralN(context, variable, sink);
    } else {
      return _generateLiteral(context, variable, sink);
    }
  }

  String _generateEmpty(
      BuildContext context, Variable? variable, StringSink sink) {
    if (variable != null) {
      variable.assign(sink, "('',)");
    }

    return postprocess(context, sink);
  }

  String _generateLiteral(
      BuildContext context, Variable? variable, StringSink sink) {
    final escaped = escapeString(literal);
    final value = 'state.matchLiteral(($escaped,), $escaped)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String _generateLiteralN(
      BuildContext context, Variable? variable, StringSink sink) {
    final escaped = escapeString(literal);
    final codeUnits = literal.codeUnits;
    final length = codeUnits.length;
    final sequence = codeUnits.join(', ');
    final value = 'state.matchLiteral$length(($escaped,), $escaped, $sequence)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String _generateMatch(
      BuildContext context, Variable? variable, StringSink sink) {
    final escaped = escapeString(literal);
    final value = 'state.match(($escaped,), $escaped)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String _generateMatchN(
      BuildContext context, Variable? variable, StringSink sink) {
    final escaped = escapeString(literal);
    final codeUnits = literal.codeUnits;
    final length = codeUnits.length;
    final sequence = codeUnits.join(', ');
    final value = 'state.match$length(($escaped,), $sequence)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }
}

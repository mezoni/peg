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
      } else {
        return _generateMatch(context, variable, sink);
      }
    }

    final runes = literal.runes.toList();
    if (runes.length == 1) {
      return _generateLiteral1(context, variable, sink, runes[0]);
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
    final value = 'state.matchLiteral($escaped)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }

  String _generateLiteral1(
      BuildContext context, Variable? variable, StringSink sink, int char) {
    final escaped = escapeString(literal);
    final value = 'state.matchLiteral1($escaped, $char)';
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
    final value = 'state.match($escaped)';
    if (variable != null) {
      variable.assign(sink, value);
    } else {
      sink.statement(value);
    }

    return postprocess(context, sink);
  }
}

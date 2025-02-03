import '../helper.dart' as helper;
import 'expression.dart';

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
  String generate(ProductionRuleContext context) {
    if (literal.isEmpty) {
      return _generateEmpty(context);
    } else if (literal.length == 1) {
      return _generate1(context);
    } else if (literal.length == 2) {
      return _generate2(context);
    } else {
      return _generate(context);
    }
  }

  String _generate1(ProductionRuleContext context) {
    final escaped = helper.escapeString(literal);
    final char = literal.codeUnitAt(0);
    var template = '';
    if (silent) {
      template = assignResult(context, 'state.match1($escaped, $char, true)');
    } else {
      template = assignResult(context, 'state.match1($escaped, $char)');
    }

    return render(context, this, template, const {});
  }

  String _generate2(ProductionRuleContext context) {
    final escaped = helper.escapeString(literal);
    final char = literal.codeUnitAt(0);
    final char2 = literal.codeUnitAt(1);
    var template = '';
    if (silent) {
      template =
          assignResult(context, 'state.match2($escaped, $char, $char2, true)');
    } else {
      template = assignResult(context, 'state.match2($escaped, $char, $char2)');
    }

    return render(context, this, template, const {});
  }

  String _generateEmpty(ProductionRuleContext context) {
    final template = assignResult(context, 'state.opt((\'\',))');
    return render(context, this, template, const {});
  }

  String _generate(ProductionRuleContext context) {
    final escaped = helper.escapeString(literal);
    var template = '';
    if (silent) {
      template = assignResult(context, 'state.match($escaped, true)');
    } else {
      template = assignResult(context, 'state.match($escaped)');
    }

    return render(context, this, template, const {});
  }
}

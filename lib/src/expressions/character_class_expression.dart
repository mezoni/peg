import 'package:simple_sparse_list/ranges_helper.dart';

import '../binary_search_generator/matcher_generator.dart';
import 'expression.dart';

class CharacterClassExpression extends Expression {
  final bool negate;

  final List<(int, int)> ranges;

  CharacterClassExpression({
    this.negate = false,
    required this.ranges,
  }) {
    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCharacterClass(this);
  }

  @override
  String generate(ProductionRuleContext context) {
    final ranges = normalizeRanges(this.ranges.toList());
    final variable = context.getExpressionVariable(this);
    final matcher = MatcherGenerator();
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    if (ranges.length == 1) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        return _generate1(context, variable, range.$1);
      }
    }

    final values = {
      'predicate': matcher.generate('c', ranges, negate: negate),
    };

    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      if (is32Bit) {
        template = '''
{{declare}}{{variable}} = state.matchChars32((int c) => {{predicate}});''';
      } else {
        template = '''
{{declare}}{{variable}} = state.matchChars16((int c) => {{predicate}});''';
      }
    } else {
      if (is32Bit) {
        template = '''
state.matchChars32((int c) => {{predicate}});''';
      } else {
        template = '''
state.matchChars16((int c) => {{predicate}});''';
      }
    }

    return render(context, this, template, values);
  }

  String _generate1(ProductionRuleContext context, String? variable, int char) {
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    final values = {
      'char': '$char',
      'comment': " // '${String.fromCharCode(char)}'",
    };
    var template = '';
    if (variable != null) {
      final isVariableDeclared = context.isExpressionVariableDeclared(variable);
      var canDeclare = false;
      var declare = '';
      if (!isVariableDeclared) {
        canDeclare = this == context.getExpressionVariableDeclarator(variable);
        if (canDeclare) {
          context.setExpressionVariableDeclared(variable);
          declare = 'final ';
        }
      }

      values['declare'] = declare;
      values['variable'] = variable;
      if (is32Bit) {
        template = '''
{{comment}}
{{declare}}{{variable}} = state.matchChar32({{char}});''';
      } else {
        template = '''
{{comment}}
{{declare}}{{variable}} = state.matchChar16({{char}});''';
      }
    } else {
      if (is32Bit) {
        template = '''
{{comment}}
state.matchChar32({{char}});''';
      } else {
        template = '''
{{comment}}
state.matchChar16({{char}});''';
      }
    }

    return render(context, this, template, values);
  }
}

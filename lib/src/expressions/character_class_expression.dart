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
      values['variable'] = variable;
      if (is32Bit) {
        template = '''
state.isSuccess = state.position < state.input.length;
if (state.isSuccess) {
  final c = state.input.readChar(state.position);
  state.isSuccess = {{predicate}};
  if (state.isSuccess) {
    {{variable}} =  c;
    state.position += c > 0xffff ? 2 : 1;
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
      } else {
        template = '''
state.isSuccess = state.position < state.input.length;
if (state.isSuccess) {
  final c = state.input.codeUnitAt(state.position);
  state.isSuccess = {{predicate}};
  if (state.isSuccess) {
    {{variable}} =  c;
    state.position++;
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
      }
    } else {
      if (is32Bit) {
        template = '''
state.isSuccess = state.position < state.input.length;
if (state.isSuccess) {
  final c = state.input.readChar(state.position);
  state.isSuccess = {{predicate}};
  if (state.isSuccess) {
    state.position += c > 0xffff ? 2 : 1;
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
      } else {
        template = '''
state.isSuccess = state.position < state.input.length;
if (state.isSuccess) {
  final c = state.input.codeUnitAt(state.position);
  state.isSuccess = {{predicate}};
  if (state.isSuccess) {
    state.position++;
  }
}
if (!state.isSuccess) {
  state.fail();
}''';
      }
    }

    return render(context, this, template, values);
  }

  String _generate1(ProductionRuleContext context, String? variable, int char) {
    final is32Bit = ranges.any((e) => e.$1 > 0xffff || e.$2 > 0xffff);
    final values = {
      'char': '$char',
      'comment': ' // ${String.fromCharCode(char)}',
      'input': context.allocateInputVariable(),
    };
    var template = '';
    if (variable != null) {
      values['variable'] = variable;
      if (is32Bit) {
        template = '''
{{comment}}
if (state.isSuccess = state.position < {{input}}.length && {{input}}.readChar(state.position) == {{char}}) {
  {{variable}} = {{char}};
  state.position += 2;
} else {
  state.fail();
}''';
      } else {
        template = '''
{{comment}}
if (state.isSuccess = state.position < {{input}}.length && {{input}}.codeUnitAt(state.position) == {{char}}) {
  {{variable}} = {{char}};
  state.position++;
} else {
  state.fail();
}''';
      }
    } else {
      if (is32Bit) {
        template = '''
{{comment}}
state.isSuccess = state.position < {{input}}.length && {{input}}.readChar(state.position) == {{char}};
state.isSuccess ? state.position += 2 : state.fail();''';
      } else {
        template = '''
{{comment}}
state.isSuccess = state.position < {{input}}.length && {{input}}.codeUnitAt(state.position) == {{char}};
state.isSuccess ? state.position++ : state.fail();''';
      }
    }

    return render(context, this, template, values);
  }
}

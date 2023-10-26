import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class CharacterClassGenerator
    extends ExpressionGenerator<CharacterClassExpression> {
  CharacterClassGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    final ranges = expression.ranges;
    final negate = expression.negate;
    if (ranges.length == 1 && !negate) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        return _generateChar(range.$1);
      }
    }

    return _generate(ranges, negate);
  }

  @override
  void generateAsync(BlockNode block) {
    final ranges = expression.ranges;
    final negate = expression.negate;
    int? char;
    if (ranges.length == 1 && !negate) {
      final range = ranges[0];
      if (range.$1 == range.$2) {
        char = range.$1;
      }
    }

    if (char == null) {
      _generateAsync(block);
    } else {
      _generateAsyncChar(block, char);
    }
  }

  String _generate(List<(int, int)> ranges, bool negate) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    final c = allocateName();
    values['c'] = c;
    values['ok'] = allocateName();
    values['adjust_state_pos'] = helper.adjustStatePos(c, ranges, negate);
    values['char_at'] = helper.charAt(ranges, negate);
    values['predicate'] = helper.rangesToPredicate(c, ranges, negate);
    if (variable != null) {
      values['assign_result'] = '$variable = $c;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
if (state.pos < state.input.length) {
  final {{c}} = state.input.{{char_at}}(state.pos);
  final {{ok}} = {{predicate}};
  if ({{ok}}) {
    {{adjust_state_pos}};
    state.setOk(true);
    {{assign_result}}
  } else {
    state.fail(const ErrorUnexpectedCharacter());
  }
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';
    return render(template, values);
  }

  void _generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final ranges = expression.ranges;
    final negate = expression.negate;
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final handle = asyncGenerator.functionName;
    final input = allocateName();
    final ok = allocateName();
    final adjustStatePos = helper.adjustStatePos('c', ranges, negate);
    final charAt = helper.charAt(ranges, negate);
    final predicate = helper.rangesToPredicate('c', ranges, negate);
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = c;';
    }

    final label = allocateName();
    block.label(label);
    block << 'final $input = state.input;';
    block.if_('state.pos >= $input.end && !$input.isClosed', (block) {
      block << '$input.sleep = true;';
      block << '$input.handle = $handle;';
      block.return_(label);
    });
    block.if_('state.pos < $input.end', (block) {
      block << 'final c = $input.data.$charAt(state.pos - $input.start);';
      block << 'final $ok = $predicate;';
      block.if_(ok, (block) {
        block << '$adjustStatePos;';
        block << assignResult;
        block << 'state.setOk(true);';
      }).else_((block) {
        block << 'state.fail(const ErrorUnexpectedCharacter());';
      });
    }).else_((block) {
      block << 'state.fail(const ErrorUnexpectedEndOfInput());';
    });
  }

  void _generateAsyncChar(BlockNode block, int char) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final handle = asyncGenerator.functionName;
    final input = allocateName();
    final charAt = helper.charAt([(char, char)], false);
    final adjustStatePos =
        helper.adjustStatePos('$char', [(char, char)], false);
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = $char;';
    }

    final label = allocateName();
    block.label(label);
    block << 'final $input = state.input;';
    block.if_('state.pos >= $input.end && !$input.isClosed', (block) {
      block << '$input.sleep = true;';
      block << '$input.handle = $handle;';
      block.return_(label);
    });
    block.if_('state.pos < $input.end', (block) {
      block <<
          'final ok = $input.data.$charAt(state.pos - $input.start) == $char;';
      block.if_('ok', (block) {
        block << '$adjustStatePos;';
        block << 'state.setOk(true);';
        block << assignResult;
      }).else_((block) {
        block << 'state.fail(const ErrorUnexpectedCharacter());';
      });
    }).else_((block) {
      block << 'state.fail(const ErrorUnexpectedEndOfInput());';
    });
  }

  String _generateChar(int char) {
    final values = <String, String>{};
    final variable = ruleGenerator.getExpressionVariable(expression);
    values['char'] = '$char';
    values['char_at'] = helper.charAt([(char, char)], false);
    values['adjust_state_pos'] =
        helper.adjustStatePos('$char', [(char, char)], false);
    if (variable != null) {
      values['assign_result'] = '$variable = $char;';
    } else {
      values['assign_result'] = '';
    }

    const template = '''
if (state.pos < state.input.length) {
  final ok = state.input.{{char_at}}(state.pos) == {{char}};
  if (ok) {
    {{adjust_state_pos}};
    state.setOk(true);
    {{assign_result}}
  } else {
    state.fail(const ErrorUnexpectedCharacter());
  }
} else {
  state.fail(const ErrorUnexpectedEndOfInput());
}''';

    return render(template, values);
  }
}

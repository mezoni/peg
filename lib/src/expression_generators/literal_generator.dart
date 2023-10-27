import '../async_generators/action_node.dart';
import '../expressions/expressions.dart';
import '../helper.dart' as helper;
import 'expression_generator.dart';

class LiteralGenerator extends ExpressionGenerator<LiteralExpression> {
  LiteralGenerator({
    required super.expression,
    required super.ruleGenerator,
  });

  @override
  String generate() {
    if (!expression.caseSensitive) {
      throw StateError('Case sensitive literal expression is not implemented');
    }

    final variable = ruleGenerator.getExpressionVariable(expression);
    final string = expression.string;
    if (string.isEmpty) {
      return _generateEmptyString(variable);
    } else if (string.length < 9) {
      return _generateShortString(string, variable);
    }

    return _generate(string, variable);
  }

  @override
  void generateAsync(BlockNode block) {
    final string = expression.string;
    if (string.isEmpty) {
      _generateAsyncEmptyString(block);
    } else if (string.length < 9) {
      _generateAsyncShortString(block);
    } else {
      _generateAsync(block);
    }
  }

  String _generate(String string, String? variable) {
    final values = <String, String>{};
    values['literal'] = allocateName();
    values['ok'] = allocateName();
    values['char'] = string.codeUnitAt(0).toString();
    values['string'] = helper.escapeString(string);
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
const {{literal}} = {{string}};
final {{ok}} = state.pos < state.input.length &&
    state.input.codeUnitAt(state.pos) == {{char}} &&
    state.input.startsWith({{literal}}, state.pos);
if ({{ok}}) {
  {{adjust_state_pos}};
  state.setOk(true);
  {{r}} = {{literal}};
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    } else {
      template = '''
const {{literal}} = {{string}};
final {{ok}} = state.pos < state.input.length &&
    state.input.codeUnitAt(state.pos) == {{char}} &&
    state.input.startsWith({{literal}}, state.pos);
if ({{ok}}) {
  {{adjust_state_pos}};
  state.setOk(true);
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    }

    return render(template, values);
  }

  void _generateAsync(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input1 = allocateName();
    final input2 = allocateName();
    final literal = allocateName();
    final ok = allocateName();
    final pos = allocateName();
    final handle = asyncGenerator.functionName;
    final char = string.codeUnitAt(0).toString();
    final escapeString = helper.escapeString(string);
    final offset = (string.length - 1).toString();
    var adjustStatePos = '';
    if (string.length == 1) {
      adjustStatePos = 'state.pos++';
    } else {
      adjustStatePos = 'state.pos += ${string.length}';
    }

    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = $literal;';
    }

    final label = allocateName();
    block.label(label);
    block << 'final $input1 = state.input;';
    block.if_('state.pos + $offset >= $input1.end && !$input1.isClosed',
        (block) {
      block << '$input1.sleep = true;';
      block << '$input1.handle = $handle;';
      block.return_(label);
    });
    block << 'final $input2 = state.input;';
    block << 'const $literal = $escapeString;';
    block << 'final $pos = state.pos - $input2.start;';
    block <<
        'final $ok = state.pos < $input2.end &&  $input2.data.codeUnitAt($pos) == $char &&  $input2.data.startsWith($literal, $pos);';
    block.if_(ok, (block) {
      block << '$adjustStatePos;';
      block << 'state.setOk(true);';
      block << assignResult;
    }).else_((block) {
      block << 'state.fail(const ErrorExpectedTags([$literal]));';
    });
  }

  void _generateAsyncEmptyString(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = \'\';';
    }

    block << 'state.setOk(true);';
    block << assignResult;
  }

  void _generateAsyncShortString(BlockNode block) {
    final variable = ruleGenerator.getExpressionVariable(expression);
    final asyncGenerator = ruleGenerator.asyncGenerator;
    final string = expression.string;
    final input = allocateName();
    final handle = asyncGenerator.functionName;
    final escapedString = helper.escapeString(string);
    final literal = allocateName();
    final ok = allocateName();
    final testLiteral = helper.testLiteral(
      codeUnits: string.codeUnits,
      current: 'state.pos',
      index: 'state.pos - $input.start',
      input: '$input.data',
      length: '$input.end',
    );
    var adjustStatePos = '';
    if (string.length == 1) {
      adjustStatePos = 'state.pos++';
    } else {
      adjustStatePos = 'state.pos += ${string.length}';
    }

    var assignResult = '';
    if (variable != null) {
      assignResult = '$variable = $literal;';
    }

    var size = '';
    if (string.length > 1) {
      size = ' + ${string.length - 1}';
    } else {
      size = '';
    }

    final label = allocateName();
    block.label(label);
    block << 'final $input = state.input;';
    block.if_('state.pos$size >= $input.end && !$input.isClosed', (block) {
      block << '$input.sleep = true;';
      block << '$input.handle = $handle;';
      block.return_(label);
    });
    block << 'const $literal = $escapedString;';
    block << 'final $ok = $testLiteral;';
    block.if_(ok, (block) {
      block << '$adjustStatePos;';
      block << 'state.setOk(true);';
      block << assignResult;
    }).else_((block) {
      block << 'state.fail(const ErrorExpectedTags([$literal]));';
    });
  }

  String _generateEmptyString(String? variable) {
    final values = <String, String>{};
    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
state.setOk(true);
if (state.ok) {
  {{r}} = '';
}''';
    } else {
      template = '''
state.setOk(true);''';
    }
    return render(template, values);
  }

  String _generateShortString(String string, String? variable) {
    final values = <String, String>{};
    final literal = allocateName();
    values['literal'] = literal;
    values['ok'] = allocateName();
    values['string'] = helper.escapeString(string);
    values['test'] = helper.testLiteral(
      codeUnits: string.codeUnits,
      current: 'state.pos',
      index: 'state.pos',
      input: 'state.input',
      length: 'state.input.length',
    );
    if (string.length == 1) {
      values['adjust_state_pos'] = 'state.pos++';
    } else {
      values['adjust_state_pos'] = 'state.pos += ${string.length}';
    }

    var template = '';
    if (variable != null) {
      values['r'] = variable;
      template = '''
const {{literal}} = {{string}};
final {{ok}} = {{test}};
if ({{ok}}) {
  {{adjust_state_pos}};
  state.setOk(true);
  {{r}} = {{literal}};
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    } else {
      template = '''
const {{literal}} = {{string}};
final {{ok}} = {{test}};
if ({{ok}}) {
  {{adjust_state_pos}};
  state.setOk(true);
} else {
  state.fail(const ErrorExpectedTags([{{literal}}]));
}''';
    }

    return render(template, values);
  }
}

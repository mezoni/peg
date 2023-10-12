import 'allocator.dart';
import 'expressions/expression.dart';
import 'helper.dart' as helper;

class AsyncGenerator {
  static const _maxBits = 16;

  final Allocator allocator;

  int buffering = 0;

  final String functionName;

  ({String name, int bit})? _flag;

  final List<({String name, ResultType type, String? value})> _variables = [];

  AsyncGenerator({
    required this.allocator,
    required this.functionName,
  });

  String addVariable(String name, ResultType type, [String? value]) {
    final variable = (name: name, type: type, value: value);
    _variables.add(variable);
    return name;
  }

  ({String name, int bit}) allocateFlag() {
    if (_flag == null) {
      final variable = allocateVariable(GenericType(name: 'int'), '0');
      _flag = (name: variable, bit: 1);
      return _flag!;
    }

    var flag = _flag!;
    if (flag.bit >= _maxBits) {
      final variable = allocateVariable(GenericType(name: 'int'), '0');
      flag = (name: variable, bit: 1);
    } else {
      flag = (name: flag.name, bit: flag.bit + 1);
    }

    _flag = flag;
    return flag;
  }

  String allocateVariable(ResultType type, [String? value]) {
    final name = allocator.allocate();
    return addVariable(name, type, value);
  }

  String forceBuffering(String Function() f) {
    final values = <String, String>{};
    buffering++;
    final source = f();
    buffering--;
    var template = '';
    if (buffering == 0) {
      values['key'] =
          allocateVariable(GenericType(name: 'Object').getNullableType());
      values['source'] = source;
      template = '''
{{key}} ??= state.input.beginBuffering();
{{source}}
state.input.endBuffering();
{{key}} = null;''';
    } else {
      template = source;
    }

    return helper.render(template, values);
  }

  String generate() {
    final buffer = StringBuffer();
    for (var i = 0; i < _variables.length; i++) {
      final variable = _variables[i];
      final name = variable.name;
      final type = variable.type;
      final value = variable.value;
      if (value != null) {
        buffer.writeln('$type $name = $value;');
      } else {
        final type2 = variable.type.getNullableType();
        buffer.writeln('$type2 $name;');
      }
    }

    return buffer.toString();
  }

  String renderAction(
    String source, {
    required bool buffering,
    ({String name, String value})? key,
    String? init,
  }) {
    final values = <String, String>{};
    values['source'] = source;
    init ??= '';
    if (init.trim().isNotEmpty) {
      values['init'] = init;
    } else {
      values['init'] = '';
    }

    if (buffering) {
      values['begin_buffering'] = 'state.input.beginBuffering();';
      values['end_buffering'] = 'state.input.endBuffering();';
    } else {
      values['begin_buffering'] = '';
      values['end_buffering'] = '';
    }

    var template = '';
    if (init.isEmpty && !buffering && key == null) {
      template = source;
    } else if (init.isEmpty && buffering && key == null) {
      values['key'] =
          allocateVariable(GenericType(name: 'Object').getNullableType());
      template = '''
{{key}} ??= {{begin_buffering}}
{{source}}
{{end_buffering}}
{{key}} = null;''';
    } else if (init.isEmpty && !buffering && key != null) {
      values['key'] = key.name;
      values['value'] = key.value;
      template = '''
{{key}} ??= {{value}};
{{source}}
{{key}} = null;''';
    } else {
      if (key != null) {
        final name = key.name;
        final value = key.value;
        values['test_key'] = '$name == null';
        values['assign_key'] = '$name = $value;';
        values['reset_key'] = '$name = null;';
      } else {
        final flag = allocateFlag();
        final name = flag.name;
        final bit = flag.bit;
        final x = 1 << (bit - 1);
        final hexX = x.toRadixString(16);
        final mask = ((1 << _maxBits) - 1).toRadixString(16);
        final z = '~0x$hexX & 0x$mask';
        values['test_key'] = '$name & 0x$hexX == 0';
        values['assign_key'] = '$name |= 0x$hexX;';
        values['reset_key'] = '$name &= $z;';
      }

      template = '''
if ({{test_key}}) {
  {{assign_key}}
  {{begin_buffering}}
  {{init}}
}
{{source}}
{{end_buffering}}
{{reset_key}}''';
    }

    return helper.render(template, values);
  }
}

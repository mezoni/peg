import 'dart:math';

class Branch implements ICodeGen {
  final CodeGen falsity = CodeGen();

  final CodeGen truth = CodeGen();

  String test;

  Branch(this.test);

  @override
  void generate(StringSink sink) {
    final test = this.test.trim();
    final truthHasCode = truth.hasCode;
    final falsityHasCode = falsity.hasCode;
    if (test == 'true') {
      if (truthHasCode && falsityHasCode) {
        sink.writeln('if (true) {');
        sink.writeln(truth);
        sink.writeln('} else {');
        sink.writeln(falsity);
        sink.writeln('}');
      } else if (truthHasCode) {
        sink.writeln(truth);
      } else if (falsityHasCode) {
        sink.writeln('if (false) {');
        sink.writeln(falsity);
        sink.writeln('}');
      }
    } else if (test == 'false') {
      if (truthHasCode && falsityHasCode) {
        sink.writeln('if (true) {');
        sink.writeln(falsity);
        sink.writeln('} else {');
        sink.writeln(truth);
        sink.writeln('}');
      } else if (falsityHasCode) {
        sink.writeln(falsity);
      } else if (truthHasCode) {
        sink.writeln('if (false) {');
        sink.writeln(truth);
        sink.writeln('}');
      }
    } else {
      if (truthHasCode && falsityHasCode) {
        sink.writeln('if ($test) {');
        sink.writeln(truth);
        sink.writeln('} else {');
        sink.writeln(falsity);
        sink.writeln('}');
      } else if (truthHasCode) {
        sink.writeln('if ($test) {');
        sink.writeln(truth);
        sink.writeln('}');
      } else if (falsityHasCode) {
        var i = -1;
        final i1 = test.indexOf('!=');
        final i2 = test.indexOf('==');
        if (i1 != -1 && i2 != -1) {
          i = min(i1, i2);
        } else {
          i = max(i1, i2);
        }

        if (i == -1) {
          var quoted = test;
          if (test.contains('=') ||
              test.contains('>') ||
              test.contains('<') ||
              test.contains('?') ||
              test.contains('!')) {
            quoted = '($quoted)';
          }

          sink.writeln('if (!$quoted) {');
          sink.writeln(falsity);
          sink.writeln('}');
        } else {
          final left = test.substring(0, i);
          var op = test.substring(i, i + 2);
          final right = test.substring(i + 2);
          switch (op) {
            case '==':
              op = '!=';
              break;
            case '!=':
              op = '==';
              break;
          }

          sink.writeln('if ($left $op $right) {');
          sink.writeln(falsity);
          sink.writeln('}');
        }
      }
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    generate(buffer);
    return '$buffer';
  }
}

class CodeGen implements ICodeGen {
  final Object? _generator;

  final _list = <ICodeGen>[];

  CodeGen([Object? generator]) : _generator = generator;

  Object? get generator => _generator;

  bool get hasCode {
    if (_list.isEmpty) {
      return false;
    }

    if (_list.length == 1) {
      final first = _list.first;
      if (first is CodeGen) {
        return first.hasCode;
      }
    }

    return true;
  }

  ICodeGen get last => _list.last;

  void add(ICodeGen code) {
    _list.add(code);
  }

  void addString(String code) {
    add(StringCodeGen(code));
  }

  void assign(String lvalue, String rvalue, [String type = '']) {
    type = type.trim();
    type = type.isEmpty ? '' : '$type ';
    statement('$type$lvalue = $rvalue');
  }

  void block(void Function(CodeGen b) f) {
    f(this);
  }

  Branch branch(String ok) {
    final branch = Branch(ok);
    add(branch);
    return branch;
  }

  @override
  void generate(StringSink sink) {
    for (var i = 0; i < _list.length; i++) {
      final value = _list[i];
      value.generate(sink);
    }
  }

  void insert(ICodeGen code) {
    if (_list.isEmpty) {
      _list.add(code);
    } else {
      _list.insert(0, code);
    }
  }

  void statement(String code) {
    addString('$code;\n');
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    generate(buffer);
    return '$buffer';
  }

  void write(String code) {
    addString(code);
  }

  void writeln([String? code]) {
    if (code != null) {
      addString(code);
    }

    addString('\n');
  }
}

abstract class ICodeGen {
  void generate(StringSink sink);
}

class StringCodeGen implements ICodeGen {
  final String code;

  StringCodeGen(this.code);

  @override
  void generate(StringSink sink) {
    sink.write(code);
  }

  @override
  String toString() {
    return code;
  }
}

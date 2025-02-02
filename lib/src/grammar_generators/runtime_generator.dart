class RuntimeGenerator {
  static const _template = r'''
class State {
  /// The position of the parsing failure.
  int failure = 0;

  /// Input data for parsing.
  String input;

  /// Indicator of the success of the parsing.
  bool isSuccess = false;

  /// Indicates that parsing occurs within a `not' predicate`.
  ///
  /// When parsed within the `not predicate`, all `expected` errors are
  /// converted to `unexpected` errors.
  bool notPredicate = false;

  /// Current parsing position.
  int position = 0;

  int _errorIndex = 0;

  int _expectedIndex = 0;

  final List<String?> _expected = List.filled(128, null);

  int _farthestError = 0;

  int _farthestFailure = 0;

  int _farthestFailureLength = 0;

  int _farthestUnexpected = 0;

  final List<bool?> _locations = List.filled(128, null);

  final List<String?> _messages = List.filled(128, null);

  final List<int?> _positions = List.filled(128, null);

  int _unexpectedIndex = 0;

  final List<String?> _unexpectedElements = List.filled(128, null);

  final List<int?> _unexpectedPositions = List.filled(128, null);

  State(this.input);

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int enter() {
    final failure = this.failure;
    this.failure = position;
    return failure;
  }

  /// Registers an error at the [failure] position.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void error(String message, {bool? location}) {
    if (_farthestError > failure) {
      return;
    }

    if (_farthestError < failure) {
      _farthestError = failure;
      _errorIndex = 0;
      _expectedIndex = 0;
    }

    if (_errorIndex < _messages.length) {
      _locations[_errorIndex] = location;
      _messages[_errorIndex] = message;
      _positions[_errorIndex] = position;
      _errorIndex++;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void expected(String element, int start, [bool nested = true]) {
    if (_farthestError > position) {
      return;
    }

    if (isSuccess) {
      if (!notPredicate || _farthestUnexpected > position) {
        return;
      }

      if (_farthestUnexpected < position) {
        _farthestUnexpected = position;
        _unexpectedIndex = 0;
      }

      if (_unexpectedIndex < _unexpectedElements.length) {
        _unexpectedElements[_unexpectedIndex] = element;
        _unexpectedPositions[_unexpectedIndex] = start;
        _unexpectedIndex++;
      }
    } else {
      if (_farthestError < position) {
        _farthestError = position;
        _errorIndex = 0;
        _expectedIndex = 0;
      }

      if (!nested) {
        _expectedIndex = 0;
      }

      if (_expectedIndex < _expected.length) {
        _expected[_expectedIndex++] = element;
      }
    }
  }

  /// Causes a parsing failure and updates the [failure] and [_farthestFailure]
  /// positions.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void fail([int length = 0]) {
    isSuccess = false;
    failure < position ? failure = position : null;
    if (_farthestFailure > position) {
      return;
    }

    if (_farthestFailure < position) {
      _farthestFailure = position;
    }

    _farthestFailureLength =
        _farthestFailureLength < length ? length : _farthestFailureLength;
  }

  /// Converts error messages to errors and returns them as an error list.
  List<({int end, String message, int start})> getErrors() {
    final errors = <({int end, String message, int start})>[];
    for (var i = 0; i < _errorIndex; i++) {
      final message = _messages[i];
      if (message == null) {
        continue;
      }

      var start = _positions[i]!;
      var end = _farthestError;
      final location = _locations[i];
      switch (location) {
        case true:
          start = end;
          break;
        case false:
          end = start;
          break;
        default:
      }

      errors.add((message: message, start: start, end: end));
    }

    if (_expectedIndex > 0) {
      final names = <String>[];
      for (var i = 0; i < _expectedIndex; i++) {
        final name = _expected[i]!;
        names.add(name);
      }

      names.sort();
      final message =
          'Expected: ${names.toSet().map((e) => '\'$e\'').join(', ')}';
      errors
          .add((message: message, start: _farthestError, end: _farthestError));
    }

    if (_farthestUnexpected >= _farthestError) {
      if (_unexpectedIndex > 0) {
        for (var i = 0; i < _unexpectedIndex; i++) {
          final element = _unexpectedElements[i]!;
          final position = _unexpectedPositions[i]!;
          final message = "Unexpected '$element'";
          errors.add(
              (message: message, start: position, end: _farthestUnexpected));
        }
      }
    }

    if (errors.isEmpty) {
      errors.add((
        message: 'Unexpected input data',
        start: _farthestFailure - _farthestFailureLength,
        end: _farthestFailure
      ));
    }

    return errors.toSet().toList();
  }

  /// This method is for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void leave(int failure) {
    if (this.failure < failure) {
      this.failure = failure;
    }
  }

  /// Registers an error if the [failure] position is further than starting
  /// [position], otherwise the error will be ignored.
  ///
  /// The [location] argument specifies how the source span will be formed;
  /// - `true` ([failure], [failure])
  /// - `false` ([position], [position])
  /// - `null` ([position], [failure])
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void malformed(String message, {bool? location}) =>
      failure != position ? error(message, location: location) : null;

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match(String string, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess = position < input.length &&
        input.codeUnitAt(position) == string.codeUnitAt(0)) {
      if (isSuccess = input.startsWith(string, position)) {
        position += string.length;
        result = string;
      }
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match1(String string, int char, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess =
        position < input.length && input.codeUnitAt(position) == char) {
      position++;
      result = string;
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String? match2(String string, int char, int char2, [bool silent = false]) {
    final start = position;
    String? result;
    if (isSuccess = position + 1 < input.length &&
        input.codeUnitAt(position) == char &&
        input.codeUnitAt(position + 1) == char2) {
      position += 2;
      result = string;
    } else {
      fail();
    }

    silent ? null : expected(string, start);
    return result;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchAny() {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.readChar(position);
    }

    isSuccess ? position += c > 0xffff ? 2 : 1 : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar16(int char) {
    isSuccess = position < input.length && input.codeUnitAt(position) == char;
    isSuccess ? position++ : fail();
    return isSuccess ? char : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChar32(int char) {
    isSuccess = position + 1 < input.length && input.readChar(position) == char;
    isSuccess ? position += 2 : fail();
    return isSuccess ? char : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChars16(bool Function(int c) f) {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.codeUnitAt(position);
      isSuccess = f(c);
    }
    isSuccess ? position++ : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int? matchChars32(bool Function(int c) f) {
    var c = 0;
    if (isSuccess = position < input.length) {
      c = input.readChar(position);
      isSuccess = f(c);
    }
    isSuccess ? position += c > 0xffff ? 2 : 1 : fail();
    return isSuccess ? c : null;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip16While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position++;
    }

    isSuccess = true;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip16While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.codeUnitAt(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position++;
    }

    (isSuccess = start != position) ? null : fail();
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip32While(bool Function(int c) f) {
    while (position < input.length) {
      final c = input.readChar(position);
      if (!(isSuccess = f(c))) {
        break;
      }

      position += c > 0xffff ? 2 : 1;
    }

    isSuccess = true;
  }

  /// Intended for internal use only.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void skip32While1(bool Function(int c) f) {
    final start = position;
    while (position < input.length) {
      final c = input.readChar(position);
      if (!(isSuccess = f(c))) {
        break;
      }
      position += c > 0xffff ? 2 : 1;
    }

    (isSuccess = start != position) ? null : fail();
  }

  @override
  String toString() {
    var rest = input.length - position;
    if (rest > 80) {
      rest = 80;
    }

    var line = input.substring(position, position + rest);
    line = line.replaceAll('\n', '\n');
    return '($position)$line';
  }
}

extension on String {
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  // ignore: unused_element
  int readChar(int index) {
    final b1 = codeUnitAt(index++);
    if (b1 > 0xd7ff && b1 < 0xe000) {
      if (index < length) {
        final b2 = codeUnitAt(index);
        if ((b2 & 0xfc00) == 0xdc00) {
          return 0x10000 + ((b1 & 0x3ff) << 10) + (b2 & 0x3ff);
        }
      }

      throw FormatException('Invalid UTF-16 character', this, index - 1);
    }

    return b1;
  }
}
''';

  String generate() {
    return _template;
  }
}

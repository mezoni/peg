import 'package:peg/src/peg_parser_runtime.dart';

class Utf8Reader implements StringReader {
  @override
  final bool hasSource = false;

  final ByteReader reader;

  int _char = 0;

  int _lastIndex = -1;

  int _markerSize = 0;

  int _readDataSize = 0;

  Utf8Reader(this.reader, {bool detectBOM = true}) {
    if (detectBOM) {
      _detectBOM();
    }
  }

  @override
  int get count => _readDataSize;

  @override
  int get length => reader.length - _markerSize;

  @override
  String get source => throw UnsupportedError('get source');

  @override
  int indexOf(String string, int start) {
    _lastIndex = -1;
    _readDataSize = 0;
    if (start >= length) {
      return -1;
    }

    if (string.isEmpty) {
      return start;
    }

    final first = string.codeUnitAt(0);
    var readDataSize = 0;
    var index = start;
    while (index < length) {
      final c = _read(index);
      index += _readDataSize;
      readDataSize += _readDataSize;
      if (c != first) {
        continue;
      }

      if (string.length == 1) {
        _lastIndex = -1;
        _readDataSize = readDataSize;
        return index;
      }

      if (startsWith(string, index)) {
        _lastIndex = -1;
        _readDataSize = readDataSize;
        return index;
      }
    }

    _lastIndex = -1;
    _readDataSize = 0;
    return -1;
  }

  @override
  bool matchChar(int char, int offset) {
    if (offset < length) {
      final c = _read(offset);
      if (c == char) {
        return true;
      }
    }

    return false;
  }

  @override
  int readChar(int index) {
    if (index < 0) {
      throw ArgumentError.value(index, 'index', 'Must not be negative');
    }

    final c = _read(index);
    return c;
  }

  @override
  bool startsWith(String string, [int index = 0]) {
    var readDataSize = 0;
    final iterator = string.runes.iterator;
    while (iterator.moveNext()) {
      final c1 = iterator.current;
      final c2 = _read(index);
      if (c1 != c2) {
        return false;
      }

      index += _readDataSize;
      readDataSize += _readDataSize;
    }

    _lastIndex = -1;
    _readDataSize = readDataSize;
    return true;
  }

  @override
  String substring(int start, [int? end]) {
    if (end != null && start > end) {
      throw RangeError.range(start, 0, end, 'start');
    }

    var index = start;
    var readDataSize = 0;
    if (end != null) {
      if (start > end) {
        throw RangeError.range(start, 0, end, 'start');
      }

      if (end - start == 0) {
        _lastIndex = -1;
        _readDataSize = 0;
        return '';
      }
    }

    end ??= length;
    final charCodes = <int>[];
    while (index < end) {
      final c = _read(index);
      charCodes.add(c);
      index += _readDataSize;
      readDataSize += _readDataSize;
    }

    _lastIndex = -1;
    _readDataSize = readDataSize;
    return String.fromCharCodes(charCodes);
  }

  void _detectBOM() {
    if (length >= 3) {
      if (_readByte(0) == 0xef) {
        if (_readByte(1) == 0xbb) {
          if (_readByte(2) == 0xbf) {
            _markerSize = 3;
          }
        }
      }
    }
  }

  Never _error(int offset, int char) {
    final hexValue = char.toRadixString(16);
    throw StateError(
        'Invalid character at offset $offset: $_char (0x$hexValue)');
  }

  int _read(int index) {
    if (_lastIndex == index) {
      return _char;
    }

    final byte1 = _readByte(index + _markerSize);
    var c = 0;
    if (byte1 < 0x80) {
      _readDataSize = 1;
      c = byte1;
    } else if ((byte1 & 0xe0) == 0xc0) {
      _readDataSize = 2;
      final byte2 = _readByte(index + _markerSize + 1);
      c = ((byte1 & 0x1f) << 6) | (byte2 & 0x3f);
    } else if ((byte1 & 0xf0) == 0xe0) {
      _readDataSize = 3;
      final byte2 = _readByte(index + _markerSize + 1);
      final byte3 = _readByte(index + _markerSize + 2);
      c = ((byte1 & 0x0f) << 12) | ((byte2 & 0x3f) << 6) | (byte3 & 0x3f);
    } else if ((byte1 & 0xf8) == 0xf0 && (byte1 <= 0xf4)) {
      _readDataSize = 4;
      final byte2 = _readByte(index + _markerSize + 1);
      final byte3 = _readByte(index + _markerSize + 2);
      final byte4 = _readByte(index + _markerSize + 3);
      c = ((byte1 & 0x07) << 18) |
          ((byte2 & 0x3f) << 12) |
          ((byte3 & 0x3f) << 6) |
          (byte4 & 0x3f);
    } else {
      _error(index, c);
    }

    if (c >= 0xd800 && c <= 0xdfff) {
      _error(index, c);
    }

    _lastIndex = index;
    _char = c;
    return c;
  }

  int _readByte(int index) {
    return reader.readByte(index);
  }
}

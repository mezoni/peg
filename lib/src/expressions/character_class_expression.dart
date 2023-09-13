import '../helper.dart' as helper;
import 'expression.dart';

class CharacterClassExpression extends Expression {
  final bool negate;

  List<(int, int)> ranges = [];

  List<(int, int)> _ranges = [];

  CharacterClassExpression({
    this.negate = false,
    required List<(int, int)> ranges,
  }) {
    if (ranges.isEmpty) {
      throw ArgumentError('Must not be empty', 'ranges');
    }

    _ranges = ranges;
    this.ranges = helper.normalizeRanges(ranges);
    final start = this.ranges[0].$1;
    final end = this.ranges[this.ranges.length - 1].$2;
    RangeError.checkValidRange(start, end, 0x10FFFF, 'start', 'end');
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitCharacterClass(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    String escape(int charCode) {
      switch (charCode) {
        case 9:
          return r'\t';
        case 0xa:
          return r'\n';
        case 0xd:
          return r'\r';
        case 0x2d:
          return r'\-';
        case 0x5c:
          return r'\\';
        case 0x5d:
          return r'\]';
      }

      if (charCode < 0x20 || charCode >= 0x7f) {
        return '\\u{${charCode.toRadixString(16)}}';
      }

      return String.fromCharCode(charCode);
    }

    for (final range in _ranges) {
      final start = range.$1;
      final end = range.$2;
      if (start == end) {
        buffer.write(escape(start));
      } else {
        buffer.write(escape(start));
        buffer.write('-');
        buffer.write(escape(end));
      }
    }

    if (!negate) {
      return '[$buffer]';
    }

    return '[^$buffer]';
  }
}

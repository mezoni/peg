import 'expression.dart';

class RepetitionExpression extends SingleExpression {
  final int? max;

  final int? min;

  RepetitionExpression({
    required super.expression,
    this.max,
    this.min,
  }) {
    var min = this.min;
    var max = this.max;
    if (min == null && max == null) {
      throw ArgumentError(
          "Arguments 'min' and 'max' cannot be 'null' at the same time");
    }

    min = min ??= 0;
    max = max ??= 0x7FFFFFFF;
    RangeError.checkValueInInterval(min, 0, 0x7FFFFFFF, 'min', '$this');
    RangeError.checkValueInInterval(max, min, 0x7FFFFFFF, 'max', '$this');
  }

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitRepetition(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(expression);
    final q = switch ((min == null, max == null)) {
      (false, false) => '{$min,$max}',
      (false, true) => '{$min,}',
      (true, false) => '{,$max}',
      _ => '',
    };

    buffer.write(q);
    return buffer.toString();
  }
}

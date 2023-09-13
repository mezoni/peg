import 'package:peg/src/helper.dart' as helper;

void main() {
  var ranges = [
    (10, 11),
    (20, 21),
    (30, 31),
    (40, 41),
    (50, 51),
    (60, 61),
    (70, 71),
    (80, 81),
    (90, 91),
    (100, 101),
    (110, 111),
    (120, 121),
    (130, 131),
  ];
  ranges = helper.normalizeRanges(ranges);
  final s = helper.rangesToPredicate('c', ranges, false);
  print(s);
  _test();
}

void _test() {
  bool f(int c) => c <= 71
      ? c <= 41
          ? c <= 21
              ? c >= 10 && c <= 11 || c >= 20
              : c <= 31
                  ? c >= 30
                  : c >= 40
          : c <= 61
              ? c <= 51
                  ? c >= 50
                  : c >= 60
              : c >= 70
      : c <= 101
          ? c <= 91
              ? c <= 81
                  ? c >= 80
                  : c >= 90
              : c >= 100
          : c <= 121
              ? c <= 111
                  ? c >= 110
                  : c >= 120
              : c >= 130 && c <= 131;
  for (var i = 0; i < 200; i++) {
    if (f(i)) {
      print(i);
    }
  }
}

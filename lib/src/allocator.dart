class Allocator {
  final Map<String, int> _indexes = {};

  String allocate([String name = '']) {
    final index = _indexes[name] ??= 0;
    _indexes[name] = index + 1;
    if (index == 0 && name.isNotEmpty) {
      return '\$$name';
    }

    return '\$$name$index';
  }

  void reset() {
    _indexes.clear();
  }
}

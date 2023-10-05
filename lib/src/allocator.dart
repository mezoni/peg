class Allocator {
  int _id = 0;

  String allocate() {
    return '\$${_id++}';
  }

  void reset() {
    _id = 0;
  }
}

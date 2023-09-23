class GenericType extends ResultType {
  @override
  late final int id;

  @override
  final bool isRecordType = false;

  final String? name;

  final List<ResultType> arguments;

  GenericType({
    List<ResultType>? arguments,
    super.isNullableType,
    required this.name,
  }) : arguments = arguments ?? const [] {
    final key = toString();
    id = ResultType._registerType(key);
  }

  @override
  ResultType getNullableType() {
    if (isNullableType) {
      return this;
    }

    return GenericType(
      arguments: arguments,
      isNullableType: true,
      name: name,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(name);
    if (arguments.isNotEmpty) {
      buffer.write('<');
      buffer.write(arguments.join(', '));
      buffer.write('>');
    }

    if (isNullableType) {
      if (name != 'dynamic') {
        buffer.write('?');
      }
    }

    return buffer.toString();
  }
}

class RecordType extends ResultType {
  @override
  late final int id;

  @override
  final bool isRecordType = true;

  final List<({ResultType type, String name})> named;

  final List<({ResultType type, String? name})> positional;

  RecordType({
    super.isNullableType,
    List<({ResultType type, String name})>? named,
    List<({ResultType type, String? name})>? positional,
  })  : named = named ?? const [],
        positional = positional ?? const [] {
    if (this.positional.isEmpty && this.named.isEmpty) {
      throw ArgumentError('At least one record field must be specified.');
    }

    final buffer = StringBuffer();
    buffer.write('(');
    if (positional case final positional?) {
      final list = positional
          .map((e) => e.name != null ? '${e.type} ${e.name} ' : '${e.type}')
          .join(', ');
      buffer.write(list);
    }

    if (named case final named?) {
      if (named.isNotEmpty) {
        if (this.positional.isNotEmpty) {
          buffer.write(', ');
        }

        buffer.write('{');
        final list = named.map((e) => '${e.type} ${e.name}').toList();
        list.sort();
        buffer.write(list.join(', '));
        buffer.write('}');
      }
    }

    if (this.positional.length == 1 && this.named.isEmpty) {
      buffer.write(',');
    }

    buffer.write(')');
    if (isNullableType) {
      buffer.write('?');
    }

    final key = buffer.toString();
    id = ResultType._registerType(key);
  }

  @override
  ResultType getNullableType() {
    if (isNullableType) {
      return this;
    }

    return RecordType(
      named: named,
      isNullableType: true,
      positional: positional,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('(');
    buffer.write(positional
        .map((e) => e.name != null ? '${e.type} ${e.name}' : '${e.type}')
        .join(', '));
    if (named.isNotEmpty) {
      buffer.write('{');
      buffer.write(named.map((e) => '${e.type} ${e.name}').join(', '));
      buffer.write('}');
    }

    if (positional.length == 1 && named.isEmpty) {
      buffer.write(',');
    }

    buffer.write(')');
    if (isNullableType) {
      buffer.write('?');
    }

    return buffer.toString();
  }
}

abstract class ResultType {
  static final Map<String, int> _types = {};

  final bool isNullableType;

  ResultType({
    this.isNullableType = false,
  });

  @override
  int get hashCode => id;

  int get id;

  bool get isRecordType;

  @override
  bool operator ==(Object other) {
    if (other is! ResultType) {
      return false;
    }

    return id == other.id;
  }

  ResultType getNullableType();

  static int _registerType(String key) {
    var id = _types[key];
    if (id != null) {
      return id;
    }

    id = _types.length;
    _types[key] = id;
    return id;
  }
}

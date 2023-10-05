import 'expressions/expression.dart';
import 'helper.dart' as helper;

class AsyncGenerator {
  final String functionName;

  int loopLevel = 0;

  final String stateVariable;

  StringBuffer _buffer = StringBuffer();

  String _currentState = '0';

  bool _isNewState = true;

  int _state = 0;

  final List<(String, ResultType)> _variables = [];

  AsyncGenerator({
    required this.functionName,
    required this.stateVariable,
  });

  String get currentState => _currentState;

  bool get isEmptyState => _isNewState;

  void addVariable(String name, ResultType type) {
    _variables.add((name, type));
  }

  String allocateState() {
    final state = ++_state;
    return '$state';
  }

  void beginState(String state) {
    _buffer.writeln('case $state:');
    _currentState = state;
    _isNewState = true;
  }

  String generate() {
    final values = <String, String>{};
    final variables = <String>[];
    for (final variable in _variables) {
      final name = variable.$1;
      final type = variable.$2.getNullableType();
      final source = '$type $name;';
      variables.add(source);
    }

    variables.add('var $stateVariable = 0;');
    values['variables'] = variables.join('\n');
    values['name'] = functionName;
    values['state'] = stateVariable;
    values['cases'] = _buffer.toString().trim();
    const template = '''
{{variables}}
void {{name}}() {
  while (true) {
    switch ({{state}}) {
      case 0:
      {{cases}}
      default:
        throw StateError('Invalid state: \${{{state}}}');
    }
  }
}''';
    return helper.render(template, values);
  }

  String moveToNewState() {
    final state = allocateState();
    writeln('$stateVariable = $state;');
    writeln('break;');
    beginState(state);
    return state;
  }

  void render(String template, Map<String, String> values) {
    final source = helper.render(template, values);
    writeln(source);
  }

  void reset() {
    _buffer = StringBuffer();
    _currentState = '0';
    _state = 0;
    _variables.clear();
  }

  void write(String source) {
    _buffer.write(source);
    _isNewState = false;
  }

  void writeComment(String source) {
    _buffer.writeln(' // $source');
  }

  void writeln(String source) {
    _buffer.writeln(source);
    _isNewState = false;
  }
}

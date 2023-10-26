import '../allocator.dart';
import '../type_system/result_type.dart';
import 'action_node.dart';

class AsyncSwitchCaseGenerator extends ActionNodeVisitor<void> {
  final Allocator allocator;

  final String functionName;

  final ActionNode root;

  final String stateName;

  final List<({bool isLate, String name, ResultType type, String? value})>
      variables;

  late _Action _action;

  final List<_Action> _actions = [];

  final Map<String, _Action> _labelActions = {};

  ActionNode? _loop;

  int _loopEnd = -1;

  int _loopStart = -1;

  AsyncSwitchCaseGenerator({
    required this.allocator,
    required this.functionName,
    required this.root,
    required this.stateName,
    required this.variables,
  });

  String generate() {
    _actions.clear();
    _action = _addAction();
    _labelActions.clear();
    _loopEnd = -1;
    _loopStart = -1;
    root.accept(this);
    final buffer = StringBuffer();
    buffer.writeln('var $stateName = 0;');
    for (var i = 0; i < variables.length; i++) {
      final variable = variables[i];
      if (variable.isLate) {
        buffer.write('late ');
      }

      buffer.write(variable.type);
      buffer.write(' ');
      buffer.write(variable.name);
      if (variable.value != null) {
        buffer.write(' = ');
        buffer.write(variable.value);
      }

      buffer.writeln(';');
    }

    buffer.writeln('void $functionName() {');
    buffer.writeln('while (true) {');
    buffer.writeln('switch ($stateName) {');
    for (var i = 0; i < _actions.length; i++) {
      final action = _actions[i];
      buffer.writeln('case $i:');
      buffer.write(action);
    }

    buffer.writeln('default:');
    buffer.writeln('throw StateError(\'Invalid state: \${$stateName}\');');
    buffer.writeln('}');
    buffer.writeln('}');
    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  void visitBlock(BlockNode node) {
    node.visitChildren(this);
  }

  @override
  void visitBreak(BreakNode node) {
    final loop = _loop;
    if (loop == null) {
      throw StateError('Break statement outside of loop statement');
    }

    if (!loop.hasGaps) {
      _writeln('break;');
      return;
    }

    _goto(_loopEnd);
  }

  @override
  void visitCode(CodeNode node) {
    final source = node.source;
    _action.writeln(source);
  }

  @override
  void visitComment(CommentNode node) {
    final text = node.text;
    _action.writeComment(text);
  }

  @override
  void visitGoto(GotoNode node) {
    final label = node.label!;
    final action = _findOrCreateLabelAction(label);
    _goto(action.id);
  }

  @override
  void visitIf(IfNode node) {
    final condition = node.condition;
    final body = node.body;
    final elseBody = node.elseBody;
    final elseBodyHasGaps = elseBody == null ? false : elseBody.hasGaps;
    final hasGaps = node.hasGaps || elseBodyHasGaps;
    if (!hasGaps) {
      _writeln('if ($condition) {');
      body.accept(this);
      if (elseBody != null) {
        final nodes = elseBody.nodes;
        if (nodes.length == 1 && nodes.first is IfNode) {
          _writeln('} else ');
          elseBody.accept(this);
        } else {
          _writeln('} else {');
          elseBody.accept(this);
          _writeln('}');
        }
      } else {
        _writeln('}');
      }

      return;
    }

    if (elseBody == null) {
      final endAction = _addAction();
      final ok = _allocate();
      _writeln('final $ok = $condition;');
      _writeln('if (!$ok) {');
      _goto(endAction.id);
      _writeln('}');
      body.accept(this);
      _goto(endAction.id);
      _action = endAction;
      return;
    }

    final elseAction = _addAction();
    final endAction = _addAction();
    final ok = _allocate();
    _writeln('final $ok = $condition;');
    _writeln('if (!$ok) {');
    _goto(elseAction.id);
    _writeln('}');
    body.accept(this);
    _goto(endAction.id);
    _action = elseAction;
    elseBody.accept(this);
    _goto(endAction.id);
    _action = endAction;
  }

  @override
  void visitLabel(LabelNode node) {
    final name = node.name;
    final found = _labelActions[name];
    if (found != null) {
      _action = found;
      return;
    }

    if (!_action.isNew) {
      final action = _addAction();
      _goto(action.id);
      _action = action;
    }

    _labelActions[name] = _action;
  }

  @override
  void visitReturn(ReturnNode node) {
    final label = node.label!;
    final action = _findOrCreateLabelAction(label);
    _assignState(action.id);
    _writeln('return;');
  }

  @override
  void visitWhile(WhileNode node) {
    final condition = node.condition;
    final body = node.body;
    final loop = _loop;
    final loopEnd = _loopEnd;
    final loopStart = _loopStart;
    _loop = node;
    if (!node.hasGaps) {
      _writeln('if ($condition) {');
      body.accept(this);
      _writeln('}');
      _loop = loop;
      return;
    }

    final end = _addAction();
    final ok = _allocate();
    var start = _action;
    if (!_action.isNew) {
      start = _addAction();
      _goto(start.id);
    }

    _action = start;
    switch (condition.trim()) {
      case 'true':
        break;
      default:
        _writeln('final $ok = $condition;');
        _writeln('if (!$ok) {');
        _goto(end.id);
        _writeln('}');
    }

    _loopStart = start.id;
    _loopEnd = end.id;
    body.accept(this);
    _goto(start.id);
    _action = end;
    _loopStart = loopStart;
    _loopEnd = loopEnd;
    _loop = loop;
  }

  _Action _addAction() {
    final id = _actions.length;
    final result = _Action(id);
    _actions.add(result);
    return result;
  }

  String _allocate() {
    return allocator.allocate();
  }

  void _assignState(int id) {
    _writeln('$stateName = $id;');
  }

  _Action _findOrCreateLabelAction(LabelNode node) {
    final name = node.name;
    var action = _labelActions[name];
    if (action != null) {
      return action;
    }

    action = _addAction();
    _labelActions[name] = action;
    return action;
  }

  void _goto(int id) {
    _assignState(id);
    _writeln('break;');
  }

  void _writeln(String source) {
    _action.writeln(source);
  }
}

class _Action {
  final int id;

  final StringBuffer buffer = StringBuffer();

  bool isNew = true;

  _Action(this.id);

  @override
  String toString() {
    return buffer.toString();
  }

  void writeComment(String text) {
    buffer.writeln(text);
  }

  void writeln(String source) {
    buffer.writeln(source);
    isNew = false;
  }
}

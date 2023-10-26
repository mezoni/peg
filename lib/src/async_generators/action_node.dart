abstract class ActionNode {
  bool hasGaps = false;

  T accept<T>(ActionNodeVisitor<T> visitor);

  void visitChildren<T>(ActionNodeVisitor<T> visitor) {
    return;
  }
}

class ActionNodeInitializer extends ActionNodeVisitor<void> {
  final Map<String, LabelNode> _labels = {};

  final Map<String, Set<BranchNode>> _references = {};

  void initialize(ActionNode node) {
    _labels.clear();
    _references.clear();
    node.accept(this);
    for (final reference in _references.entries) {
      final name = reference.key;
      final nodes = reference.value;
      final label = _labels[name];
      if (label == null) {
        throw StateError('Label nof found: $name');
      }

      if (nodes.isEmpty) {
        throw StateError('Found unused label: $name');
      }

      for (final node in nodes) {
        node.label = label;
      }
    }
  }

  @override
  void visitBlock(BlockNode node) {
    node.visitChildren(this);
    final nodes = node.nodes;
    node.hasGaps = nodes.any((e) => e.hasGaps);
  }

  @override
  void visitBreak(BreakNode node) {
    node.visitChildren(this);
    node.hasGaps = false;
  }

  @override
  void visitCode(CodeNode node) {
    node.visitChildren(this);
    node.hasGaps = false;
  }

  @override
  void visitComment(CommentNode node) {
    node.visitChildren(this);
    node.hasGaps = false;
  }

  @override
  void visitGoto(GotoNode node) {
    final labelName = node.labelName;
    node.visitChildren(this);
    (_references[labelName] ??= {}).add(node);
  }

  @override
  void visitIf(IfNode node) {
    final body = node.body;
    final elseBody = node.elseBody;
    node.visitChildren(this);
    node.hasGaps = body.hasGaps;
    if (elseBody != null && elseBody.hasGaps) {
      node.hasGaps = true;
    }
  }

  @override
  void visitLabel(LabelNode node) {
    final name = node.name;
    node.visitChildren(this);
    if (_labels.containsKey(name)) {
      throw StateError('Duplicate label name: $node');
    }

    _labels[name] = node;
    node.hasGaps = true;
  }

  @override
  void visitReturn(ReturnNode node) {
    final labelName = node.labelName;
    node.visitChildren(this);
    (_references[labelName] ??= {}).add(node);
  }

  @override
  void visitWhile(WhileNode node) {
    node.visitChildren(this);
    final body = node.body;
    node.hasGaps = body.hasGaps;
  }
}

abstract class ActionNodeVisitor<T> {
  T visitBlock(BlockNode node);

  T visitBreak(BreakNode node);

  T visitCode(CodeNode node);

  T visitComment(CommentNode node);

  T visitGoto(GotoNode node);

  T visitIf(IfNode node);

  T visitLabel(LabelNode node);

  T visitReturn(ReturnNode node);

  T visitWhile(WhileNode node);
}

class BlockNode extends ActionNode {
  final List<ActionNode> nodes = [];

  BlockNode operator <<(String source) {
    if (source.isNotEmpty) {
      final node = CodeNode(source);
      nodes.add(node);
    }

    return this;
  }

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitBlock(this);
  }

  void addNode(ActionNode node) {
    nodes.add(node);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(nodes.join('\n'));
    return buffer.toString();
  }

  @override
  void visitChildren<T>(ActionNodeVisitor<T> visitor) {
    for (var i = 0; i < nodes.length; i++) {
      final child = nodes[i];
      child.accept(visitor);
    }
  }
}

abstract class BranchNode extends ActionNode {
  final String labelName;

  LabelNode? label;

  BranchNode(this.labelName);
}

class BreakNode extends ActionNode {
  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitBreak(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('break;');
    return buffer.toString();
  }
}

class CodeNode extends ActionNode {
  final String source;

  CodeNode(this.source);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitCode(this);
  }

  @override
  String toString() {
    return source;
  }
}

class CommentNode extends ActionNode {
  final String text;

  CommentNode(this.text);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitComment(this);
  }

  @override
  String toString() {
    return '// $text';
  }
}

class GotoNode extends BranchNode {
  GotoNode(super.labelName);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitGoto(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('goto $labelName;');
    return buffer.toString();
  }
}

class IfNode extends ActionNode {
  final BlockNode body = BlockNode();

  final String condition;

  BlockNode? elseBody;

  IfNode(this.condition);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitIf(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('if ($condition) {');
    buffer.write(body);
    if (elseBody != null) {
      buffer.writeln('} else {');
      buffer.write(elseBody);
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  void visitChildren<T>(ActionNodeVisitor<T> visitor) {
    body.accept(visitor);
    elseBody?.accept(visitor);
  }
}

class LabelNode extends ActionNode {
  final String name;

  LabelNode(this.name);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitLabel(this);
  }

  @override
  String toString() {
    return '$name:';
  }
}

class ReturnNode extends BranchNode {
  ReturnNode(super.labelName);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitReturn(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('return $labelName;');
    return buffer.toString();
  }
}

class WhileNode extends ActionNode {
  final BlockNode body = BlockNode();

  final String condition;

  WhileNode(this.condition);

  @override
  T accept<T>(ActionNodeVisitor<T> visitor) {
    return visitor.visitWhile(this);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('while ($condition) {');
    buffer.write(body);
    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  void visitChildren<T>(ActionNodeVisitor<T> visitor) {
    body.accept(visitor);
  }
}

extension BlockNodeExt on BlockNode {
  BreakNode break_() {
    final node = BreakNode();
    addNode(node);
    return node;
  }

  GotoNode goto_(String labelName) {
    final node = GotoNode(labelName);
    addNode(node);
    return node;
  }

  IfNode if_(String condition, void Function(BlockNode block) f) {
    final node = IfNode(condition);
    addNode(node);
    f(node.body);
    return node;
  }

  LabelNode label(String name) {
    final node = LabelNode(name);
    addNode(node);
    return node;
  }

  ReturnNode return_(String labelName) {
    final node = ReturnNode(labelName);
    addNode(node);
    return node;
  }

  WhileNode while_(String condition, void Function(BlockNode block) f) {
    final node = WhileNode(condition);
    addNode(node);
    f(node.body);
    return node;
  }
}

extension IfNodeExt on IfNode {
  BlockNode else_(void Function(BlockNode block) f) {
    if (elseBody != null) {
      throw StateError('Else body already specified');
    }

    final node = BlockNode();
    elseBody = node;
    f(node);
    return node;
  }
}

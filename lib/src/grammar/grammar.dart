import '../grammar_analyzers/grammar_initializer0.dart';
import '../grammar_analyzers/grammar_initializer1.dart';
import 'production_rule.dart';

export 'production_rule.dart';

class Grammar {
  final List<String> errors = [];

  String? globals;

  String? members;

  final Map<String, ProductionRule> ruleMap = {};

  final List<ProductionRule> rules;

  ProductionRule? start;

  final List<String> warnings = [];

  Grammar({
    required this.rules,
    this.globals,
    this.members,
  }) {
    final duplicates = <String>{};
    for (var rule in rules) {
      final name = rule.name;
      if (ruleMap.containsKey(name)) {
        duplicates.add(name);
      }

      ruleMap[rule.name] = rule;
    }

    for (final name in duplicates) {
      errors.add('Duplicate rule name: $name');
    }

    if (rules.isEmpty) {
      errors.add('No production rules defined');
      return;
    }

    _initialize();
  }

  void _initialize() {
    final grammarInitializer0 = GrammarInitializer0();
    grammarInitializer0.initialize(this);
    final grammarInitializer1 = GrammarInitializer1();
    grammarInitializer1.initialize(this);
  }
}

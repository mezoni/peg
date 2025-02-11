import 'production_rule.dart';

class Grammar {
  final String? globals;

  final String? members;

  final List<ProductionRule> rules;

  ProductionRule? start;

  Grammar({
    this.globals,
    this.members,
    required this.rules,
  });
}

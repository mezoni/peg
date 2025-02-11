import '../expression_analyzers/expression_initializer0.dart';
import '../grammar/grammar.dart';
import '../parser_generator_diagnostics.dart';
import 'invocations_resolver.dart';
import 'starting_rule_resolver.dart';

class GrammarInitializer0 {
  final ParserGeneratorDiagnostics diagnostics;

  final Grammar grammar;

  GrammarInitializer0({
    required this.diagnostics,
    required this.grammar,
  });

  void initialize() {
    final expressionInitializer0 = ExpressionInitializer0(
      diagnostics: diagnostics,
      grammar: grammar,
    );
    expressionInitializer0.initialize();
    if (diagnostics.hasErrors) {
      return;
    }

    final invocationsResolver = InvocationsResolver(grammar: grammar);
    invocationsResolver.resolve();
    final startingRulesFinder = StartingRuleResolver();
    final startingRules = startingRulesFinder.find(grammar);
    if (startingRules.isEmpty) {
      final start = grammar.rules.first;
      grammar.start = start;
    } else if (startingRules.length > 1) {
      final names = startingRules.map((e) => e.name);
      final error =
          diagnostics.error('Found several starting production rules');
      error.description('Starting production rules', names.join(', '));
    } else {
      grammar.start = startingRules.first;
    }
  }
}

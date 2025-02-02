import '../grammar/grammar.dart';
import 'result_type_resolver.dart';

class ExpressionInitializer1 {
  void initialize(Grammar grammar) {
    final resultTypesResolver = ResultTypesResolver();
    resultTypesResolver.resolve(grammar.rules);
  }
}

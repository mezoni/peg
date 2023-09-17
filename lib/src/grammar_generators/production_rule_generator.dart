import '../allocator.dart';
import '../expression_generators/expression_generators.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import '../visitors/visitors.dart';

class ProductionRuleGenerator extends ExpressionVisitor<String> {
  static const _template =
      '''
{{type}} {{name}}(State<StringReader> state) {
  {{type}} {{r}};
  {{expression}}
  return {{r}};
}''';

  static const _templateNoResult =
      '''
void {{name}}(State<StringReader> state) {
  {{expression}}
}''';

  static const _templateWithEvent =
      '''
{{type}} {{name}}(State<StringReader> state) {
  beginEvent({{event}});
  {{type}} {{r}};
  {{expression}}
  {{r}} = endEvent<{{eventType}}>({{event}}, {{r}}, state.ok);
  return {{r}};
}''';

  static const _templateWithEventNoResult =
      '''
void {{name}}(State<StringReader> state) {
  beginEvent({{event}});
  {{expression}}
  endEvent<Object?>({{event}}, null, state.ok);
}''';

  final Allocator allocator;

  final Map<String, String> generatedRules;

  final bool isFast;

  final Map<Expression, String> nodeVariables = {};

  final ProductionRule rule;

  ProductionRuleGenerator({
    required this.allocator,
    required this.generatedRules,
    required this.isFast,
    required this.rule,
  });

  String allocateExpressionVariable(Expression node) {
    final name = _allocateVariable();
    nodeVariables[node] = name;
    return name;
  }

  void generate() {
    final methodName = getMethodName(rule, isFast);
    if (generatedRules.containsKey(methodName)) {
      return;
    }

    final values = <String, String>{};
    final expression = rule.expression;
    var hasEvent = false;
    if (rule.metadata case final metadata?) {
      hasEvent = metadata.any((e) => e.name == '@event');
      if (hasEvent) {
        values['event'] = helper.escapeString(rule.name);
      }
    }

    generatedRules[methodName] = '';
    values['name'] = methodName;
    var template = '';
    if (isFast) {
      if (hasEvent) {
        template = _templateWithEventNoResult;
      } else {
        template = _templateNoResult;
      }
    } else {
      final resultType = rule.resultType ??
          expression.resultType ??
          GenericType(name: 'Object', isNullableType: true);
      values['type'] = resultType.getNullableType().toString();
      values['r'] = allocateExpressionVariable(expression);
      if (hasEvent) {
        values['eventType'] = '$resultType';
        template = _templateWithEvent;
      } else {
        template = _template;
      }
    }

    values['expression'] = expression.accept(this);
    final source = helper.render(template, values);
    generatedRules[methodName] = source;
  }

  String? getExpressionVariable(Expression node) {
    return nodeVariables[node];
  }

  String getMethodName(ProductionRule rule, bool isFast) {
    final name = rule.name;
    if (isFast) {
      return 'fastParse$name';
    }

    return 'parse$name';
  }

  String setExpressionVariable(Expression node, String variable) {
    nodeVariables[node] = variable;
    return variable;
  }

  @override
  String visitAndPredicate(AndPredicateExpression node) {
    final generator =
        AndPredicateGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitAnyCharacter(AnyCharacterExpression node) {
    final generator =
        AnyCharacterGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitCharacterClass(CharacterClassExpression node) {
    final generator =
        CharacterClassGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitErrorHandler(ErrorHandlerExpression node) {
    final generator =
        ErrorHandlerGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitGroup(GroupExpression node) {
    final generator = GroupGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitLiteral(LiteralExpression node) {
    final generator = LiteralGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitNotPredicate(NotPredicateExpression node) {
    final generator =
        NotPredicateGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitOneOrMore(OneOrMoreExpression node) {
    final generator = OneOrMoreGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitOptional(OptionalExpression node) {
    final generator = OptionalGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitOrderedChoice(OrderedChoiceExpression node) {
    final generator =
        OrderedChoiceGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitRepetition(RepetitionExpression node) {
    final generator =
        RepetitionGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitSequence(SequenceExpression node) {
    final generator = SequenceGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitSlice(SliceExpression node) {
    final generator = SliceGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitSymbol(SymbolExpression node) {
    final generator = SymbolGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitVerify(VerifyExpression node) {
    final generator = VerifyGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitZeroOrMore(ZeroOrMoreExpression node) {
    final generator =
        ZeroOrMoreGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  String _allocateVariable() {
    return allocator.allocate();
  }

  String _generate(ExpressionGenerator generator) {
    return generator.generate();
  }
}

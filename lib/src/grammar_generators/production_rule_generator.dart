import '../allocator.dart';
import '../async_generator.dart';
import '../expression_generators/expression_generators.dart';
import '../grammar/production_rule.dart';
import '../helper.dart' as helper;
import '../visitors/visitors.dart';
import 'events_generator.dart';

class ProductionRuleGenerator extends ExpressionVisitor<String> {
  final Allocator allocator;

  late final AsyncGenerator asyncGenerator;

  final Map<String, String> generatedRules;

  final bool isAsync;

  final bool isFast;

  final String parserName;

  final ProductionRule rule;

  final Map<Expression, String> _expressionVariables = {};

  bool _isAsync = false;

  ProductionRuleGenerator({
    required this.allocator,
    required this.generatedRules,
    required this.isAsync,
    required this.isFast,
    required this.parserName,
    required this.rule,
  });

  String allocateExpressionVariable(Expression node) {
    final name = _allocateVariable();
    _expressionVariables[node] = name;
    return name;
  }

  void generate() {
    final expression = rule.expression;
    final hasEvent = rule.hasEvent();
    final ruleParts = _productionRuleToPrintableList();
    final resultType = rule.resultType ?? expression.resultType!;
    var comment = '/// ';
    comment += ruleParts.join('\n/// ');
    final modes = [false, if (isAsync) true];
    for (final isAsync in modes) {
      _expressionVariables.clear();
      _isAsync = isAsync;
      allocator.reset();
      var methodName = '';
      if (!isAsync) {
        methodName = getMethodName(rule, isFast);
      } else {
        methodName = getAsyncMethodName(rule, isFast);
      }

      if (generatedRules.containsKey(methodName)) {
        continue;
      }

      final values = <String, String>{};
      String? asyncResult;
      if (isAsync) {
        asyncResult = allocator.allocate();
        final functionName = allocator.allocate();
        asyncGenerator = AsyncGenerator(
          allocator: allocator,
          functionName: functionName,
        );
        values['async_result'] = asyncResult;
        values['state_machine'] = asyncGenerator.functionName;
      }

      String? variable;
      if (!isFast) {
        variable = allocateExpressionVariable(expression);
        values['r'] = variable;
      }

      String event = '__unknown_event__';
      if (hasEvent) {
        event = EventsGenerator.getElementFullName(rule, parserName);
        values['event'] = event;
      }

      generatedRules[methodName] = '';
      values['name'] = methodName;
      values['nullable_type'] = resultType.getNullableType().toString();
      values['type'] = '$resultType';
      var template = '';
      if (isFast) {
        if (hasEvent) {
          if (!isAsync) {
            template = '''
void {{name}}(State<String> state) {
  beginEvent({{event}});
  {{expression}}
  endEvent<Object?>({{event}}, null, state.ok);
}''';
          } else {
            template = '''
AsyncResult<Object?> {{name}}(State<ChunkedParsingSink> state) {
  final {{async_result}} = AsyncResult<Object?>();
  beginEvent({{event}});
  {{expression}}
  {{state_machine}}();
  return {{async_result}};
}''';
          }
        } else {
          if (!isAsync) {
            template = '''
void {{name}}(State<String> state) {
  {{expression}}
}''';
          } else {
            template = '''
AsyncResult<Object?> {{name}}(State<ChunkedParsingSink> state) {
  final {{async_result}} = AsyncResult<Object?>();
  {{expression}}
  {{state_machine}}();
  return {{async_result}};
}''';
          }
        }
      } else {
        if (hasEvent) {
          if (!isAsync) {
            template = '''
{{nullable_type}} {{name}}(State<String> state) {
  beginEvent({{event}});
  {{nullable_type}} {{r}};
  {{expression}}
  {{r}} = endEvent<{{type}}>({{event}}, {{r}}, state.ok);
  return {{r}};
}''';
          } else {
            template = '''
AsyncResult<{{type}}> {{name}}(State<ChunkedParsingSink> state) {
  final {{async_result}} = AsyncResult<{{type}}>();
  beginEvent({{event}});
  {{nullable_type}} {{r}};
  {{expression}}
  {{state_machine}}();
  return {{async_result}};
}''';
          }
        } else {
          if (!isAsync) {
            template = '''
{{nullable_type}} {{name}}(State<String> state) {
  {{nullable_type}} {{r}};
  {{expression}}
  return {{r}};
}''';
          } else {
            template = '''
AsyncResult<{{type}}> {{name}}(State<ChunkedParsingSink> state) {
  final {{async_result}} = AsyncResult<{{type}}>();
  {{nullable_type}} {{r}};
  {{expression}}
  {{state_machine}}();
  return {{async_result}};
}''';
          }
        }
      }

      if (!isAsync) {
        values['expression'] = expression.accept(this);
      } else {
        String generateLastAction() {
          final values = <String, String>{};
          values['ar'] = asyncResult!;
          var template = '';
          if (isFast) {
            if (hasEvent) {
              values['event'] = event;
              values['type'] = '$resultType';
              template = '''
endEvent<{{type}}>({{event}}, null, state.ok);
{{ar}}.isComplete = true;
state.input.handle = {{ar}}.onComplete;
return;''';
            } else {
              template = '''
{{ar}}.isComplete = true;
state.input.handle = {{ar}}.onComplete;
return;''';
            }
          } else {
            values['r'] = variable!;
            if (hasEvent) {
              values['event'] = event;
              values['type'] = '$resultType';
              template = '''
{{r}} = endEvent<{{type}}>({{event}}, {{r}}, state.ok);
{{ar}}.value = {{r}};
{{ar}}.isComplete = true;
state.input.handle = {{ar}}.onComplete;
return;''';
            } else {
              template = '''
{{ar}}.value = {{r}};
{{ar}}.isComplete = true;
state.input.handle = {{ar}}.onComplete;
return;''';
            }
          }

          return helper.render(template, values);
        }

        final buffer = StringBuffer();
        final source = expression.accept(this);
        final action = generateLastAction();
        buffer.writeln(asyncGenerator.generate());
        buffer.writeln('void ${asyncGenerator.functionName}() {');
        buffer.writeln(source);
        buffer.writeln(action);
        buffer.writeln('}');
        values['expression'] = buffer.toString();
      }

      template = '$comment\n$template';
      final source = helper.render(template, values);
      generatedRules[methodName] = source;
    }
  }

  String getAsyncMethodName(ProductionRule rule, bool isFast) {
    final name = getMethodName(rule, isFast);
    return '$name\$Async';
  }

  String? getExpressionVariable(Expression node) {
    return _expressionVariables[node];
  }

  String getMethodName(ProductionRule rule, bool isFast) {
    final name = rule.name;
    if (isFast) {
      return 'fastParse$name';
    }

    return 'parse$name';
  }

  void removeExpressionVariable(Expression node) {
    _expressionVariables.remove(node);
  }

  String setExpressionVariable(Expression node, String variable) {
    _expressionVariables[node] = variable;
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
  String visitEof(EofExpression node) {
    final generator = EofGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitCharacterClass(CharacterClassExpression node) {
    final generator =
        CharacterClassGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitCut(CutExpression node) {
    final generator = CutGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitErrorHandler(ErrorHandlerExpression node) {
    final generator =
        ErrorHandlerGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitExpected(ExpectedExpression node) {
    final generator = ExpectedGenerator(expression: node, ruleGenerator: this);
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
  String visitMatchString(MatchStringExpression node) {
    final generator =
        MatchStringGenerator(expression: node, ruleGenerator: this);
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
  String visitList(ListExpression node) {
    final generator = ListGenerator(expression: node, ruleGenerator: this);
    return _generate(generator);
  }

  @override
  String visitList1(List1Expression node) {
    final generator = List1Generator(expression: node, ruleGenerator: this);
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
  String visitStringChars(StringCharsExpression node) {
    final generator =
        StringCharsGenerator(expression: node, ruleGenerator: this);
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
    if (!_isAsync) {
      return generator.generate();
    }

    return generator.generateAsync();
  }

  List<String> _productionRuleToPrintableList() {
    final result = <String>[];
    if (rule.metadata != null) {
      final metadata = rule.metadataToPrintableList();
      result.addAll(metadata);
    }

    if (rule.resultType case final resultType?) {
      result.add(resultType.toString());
    }

    final name = rule.name;
    result.add('$name =');
    final expression = rule.expression;
    final children = expression.expressions;
    if (children.length == 1) {
      final child = children[0];
      result.add('  $child');
    } else {
      final child = children[0];
      result.add('    $child');
      for (var i = 1; i < children.length; i++) {
        final child = children[i];
        result.add('  / $child');
      }
    }

    result.add('  ;');
    return result;
  }
}

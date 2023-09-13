import 'package:parser_builder_lite/allocator.dart';
import 'package:parser_builder_lite/expr.dart';
import 'package:parser_builder_lite/fast_build.dart';
import 'package:parser_builder_lite/parser/any_char.dart';
import 'package:parser_builder_lite/parser/choice.dart';
import 'package:parser_builder_lite/parser/delimited.dart';
import 'package:parser_builder_lite/parser/eof.dart';
import 'package:parser_builder_lite/parser/many.dart';
import 'package:parser_builder_lite/parser/many1.dart';
import 'package:parser_builder_lite/parser/mapped.dart';
import 'package:parser_builder_lite/parser/marked.dart';
import 'package:parser_builder_lite/parser/named.dart';
import 'package:parser_builder_lite/parser/not.dart';
import 'package:parser_builder_lite/parser/opt.dart';
import 'package:parser_builder_lite/parser/preceded.dart';
import 'package:parser_builder_lite/parser/predicate.dart';
import 'package:parser_builder_lite/parser/recognize.dart';
import 'package:parser_builder_lite/parser/ref.dart';
import 'package:parser_builder_lite/parser/separated_list1.dart';
import 'package:parser_builder_lite/parser/separated_pair.dart';
import 'package:parser_builder_lite/parser/sequence.dart';
import 'package:parser_builder_lite/parser/skip_while.dart';
import 'package:parser_builder_lite/parser/skip_while1.dart';
import 'package:parser_builder_lite/parser/string_chars.dart';
import 'package:parser_builder_lite/parser/tag.dart';
import 'package:parser_builder_lite/parser/take_while.dart';
import 'package:parser_builder_lite/parser/take_while1.dart';
import 'package:parser_builder_lite/parser/terminated.dart';
import 'package:parser_builder_lite/parser/tuple.dart';
import 'package:parser_builder_lite/parser/value.dart';
import 'package:parser_builder_lite/parser_builder.dart';
import 'package:parser_builder_lite/ranges.dart';
import 'package:peg/src/expressions/expressions.dart';
import 'package:peg/src/grammar/grammar.dart';

Future<void> main(List<String> args) async {
  await fastBuild(
    context: BuildContext(
      globalAllocator: Allocator('_p'),
      globalOutput: StringBuffer(),
      localAllocator: Allocator(''),
    ),
    filename: 'lib/src/peg_parser.dart',
    footer: __footer,
    header: __header,
    parsers: [
      parser,
      _blockBody_,
      _expression_,
      _type_,
    ],
  );
}

const parser = Named('parser', Delimited(_ws, _grammar, Eof()));

const __footer = '''
''';

const __header = r'''
// ignore_for_file: prefer_relative_imports

import 'expressions/expressions.dart';
import 'grammar/grammar.dart';
import 'grammar/production_rule.dart';

Grammar parse(String input) {
  final state = State(input);
  final result = parser(state);
  if (!state.ok) {
    final message = ParseError.errorMessage(input, state.failPos, state.getErrors());
    throw message;
  }
  return result!;
}
''';

const _action = Named(
    '_action',
    Choice2(
      Mapped(
        _block,
        Expr<SemanticAction>(r'SemanticAction(source: {{0}})'),
      ),
      Mapped(
        Tuple4(_lt, _type, _gt, _block),
        Expr<SemanticAction>(
            r'SemanticAction(resultType: {{0}}.$2, source: {{0}}.$4)'),
      ),
    ));

const _and = Named('_and', Terminated(Tag('&'), _ws));

const _anyCharacter = Named('_anyCharacter',
    Mapped(_dot, Expr<AnyCharacterExpression>('AnyCharacterExpression()')));

const _backslash = Named('_backslash', Terminated(Tag('/'), _ws));

const _block = Named(
    '_block ', Delimited(Tag('{'), Recognize(Many(_blockBody)), _closeBrace));

const _blockBody = Ref<String, Object?>('_blockBody');

const _blockBody_ = Named(
    '_blockBody',
    Choice2(
      Delimited(Tag('{'), Many(_blockBody), Tag('}')),
      Sequence<String, Object?>([
        (Not(Tag('}')), false),
        (AnyChar(), false),
      ]),
    ));

const _characterClass = Named(
    '_characterClass',
    Mapped(
      Delimited(
          Tag('['), Many1(Preceded(Not(Tag(']')), _range)), _closeBracket),
      Expr<CharacterClassExpression>('CharacterClassExpression(ranges: {{0}})'),
    ));

const _closeBrace = Named('_closeBrace', Terminated(Tag('}'), _ws));

const _closeBracket = Named('_closeBracket', Terminated(Tag(']'), _ws));

const _closeParenthesis = Named('_closeParenthesis', Terminated(Tag(')'), _ws));

const _colon = Named('_colon', Terminated(Tag(':'), _ws));

const _comma = Named('_comma', Terminated(Tag(','), _ws));

const _dollar = Named('_dollar', Terminated(Tag(r'$'), _ws));

const _dot = Named('_dot', Terminated(Tag('.'), _ws));

const _eq = Named('_eq', Terminated(Tag('='), _ws));

const _errorHandler = Named(
    '_errorHandler',
    Mapped(
      Tuple5(
        Terminated(Tag('@errorHandler'), _ws),
        _openParenthesis,
        _expression,
        _closeParenthesis,
        _block,
      ),
      Expr<ErrorHandlerExpression>(
          r'ErrorHandlerExpression(expression: {{0}}.$3, handler: {{0}}.$5)'),
    ));

const _escapedChar = Named(
    '_escapedChar',
    Choice7(
      Value<String, String>(Expr(r"'\n'"), Tag('n')),
      Value<String, String>(Expr(r"'\r'"), Tag('r')),
      Value<String, String>(Expr(r"'\t'"), Tag('t')),
      Value<String, String>(Expr("'\"'"), Tag('"')),
      Value<String, String>(Expr('"\'"'), Tag("'")),
      Value<String, String>(Expr("']'"), Tag(']')),
      Value<String, String>(Expr(r"'\\'"), Tag('\\')),
    ));

const _expression = Ref<String, OrderedChoiceExpression>('_expression');

const _expression_ = Named('_expression', Terminated(_orderedChoice, _ws));

const _genericType = Named(
    '_genericType ',
    Choice2(
      Mapped(
        Tuple2(_identifier, _typeArguments),
        Expr<ResultType>(r'GenericType(name: {{0}}.$1, arguments: {{0}}.$2)'),
      ),
      Mapped(
        _identifier,
        Expr<ResultType>('GenericType(name: {{0}})'),
      ),
    ));

const _globals = Named(
    '_globals',
    Delimited(
      Tag('%{'),
      Recognize(Many(_globalsBody)),
      Terminated(Tag('}%'), _ws),
    ));

const _globalsBody =
    Marked('_globalsBody', Preceded(Not(Tag('}%')), AnyChar()));

const _grammar = Named(
    '_grammar',
    Mapped(
      Tuple4(Opt(_globals), Opt(_members), Many(_productionRule), Eof()),
      Expr<Grammar>(
        r'Grammar(globals: {{0}}.$1, members: {{0}}.$2, rules: {{0}}.$3)',
      ),
    ));

const _group = Named(
    'group',
    Mapped(
      Delimited(_openParenthesis, _expression, _closeParenthesis),
      Expr<GroupExpression>('GroupExpression(expression: {{0}})'),
    ));

const _gt = Named('_gt', Terminated(Tag('>'), _ws));

const _hexValue = Named(
    '_hexValue',
    Mapped(
      Tuple3(Tag('u{'), TakeWhile1(isHexDigit), Tag('}')),
      Expr<String>(r'String.fromCharCode(int.parse({{0}}.$2, radix: 16))'),
    ));

const _identEnd = InRange([
  ('A', 'Z'),
  ('a', 'z'),
  '_',
  ('0', '9'),
]);

const _identifier = Named(
    '_identifier ',
    Terminated(
        Recognize(Sequence([
          (SkipWhile1(_identStart), false),
          (SkipWhile(_identEnd), false),
        ])),
        _ws));

const _identStart = InRange([
  ('A', 'Z'),
  ('a', 'z'),
]);

const _integer = Named(
    '_integer',
    Mapped(
      TakeWhile1(isDigit),
      Expr<int>('int.parse({{0}})'),
    ));

const _literal = Named(
    '_literal',
    Mapped(
      Delimited(Tag("'"), _literalChars, _singleQuote),
      Expr<LiteralExpression>('LiteralExpression(string: {{0}})'),
    ));

const _literalChars =
    Named('_literalChars', StringChars(_normalChars, 0x5C, _escapedChar));

const _lt = Named('_lt', Terminated(Tag('<'), _ws));

const _members = Named('_members', Terminated(_block, _ws));

const _metadata = Named('_metadata', Many1(_metadataIdentifier));

const _metadataIdentifier = Named(
    '_metadataIdentifier',
    Terminated(
        Recognize(
          Sequence([
            (Tag('@'), false),
            (TakeWhile(isAlphanumeric), false),
          ]),
        ),
        _ws));

const _minMax = Named(
    '_minMax',
    Delimited(
        _openBrace,
        Choice4(
          Mapped(
            SeparatedPair(_integer, _comma, _integer),
            Expr<(int?, int?)>(r'({{0}}.$1, {{0}}.$2)'),
          ),
          Mapped(
            Preceded(_comma, _integer),
            Expr<(int?, int?)>('(null, {{0}})'),
          ),
          Mapped(
            Terminated(_integer, _comma),
            Expr<(int?, int?)>('(null, {{0}})'),
          ),
          Mapped(
            _integer,
            Expr<(int?, int?)>('({{0}}, {{0}})'),
          ),
        ),
        _closeBrace));

const _namedFields = Named(
  '_namedFields',
  Delimited(
    _openBrace,
    Terminated(SeparatedList1(Tuple2(_type, _identifier), _comma), Opt(_comma)),
    _closeBrace,
  ),
);

const _normalChars = Expr<bool>(
    ' {{0}} >= 0x20 && {{0}} <= 0x10FFFF && {{0}} != 0x27 && {{0}} != 0x5C');

const _not = Named('_not', Terminated(Tag('!'), _ws));

const _openBrace = Named('_openBrace', Terminated(Tag('{'), _ws));

const _openParenthesis = Named('_openParenthesis', Terminated(Tag('('), _ws));

const _orderedChoice = Named(
    '_orderedChoice',
    Mapped(
        SeparatedList1(_sequence, _backslash),
        Expr<OrderedChoiceExpression>(
            'OrderedChoiceExpression(expressions: {{0}})')));

const _plus = Named('_plus', Terminated(Tag('+'), _ws));

const _positionalFields = Named(
  '_positionalFields',
  SeparatedList1(_type, _comma),
);

const _prefix = Named(
    '_prefix',
    Choice4(
      Mapped(
        Preceded(_dollar, _suffix),
        Expr<NotPredicateExpression>('SliceExpression(expression: {{0}})'),
      ),
      Mapped(
        Preceded(_not, _suffix),
        Expr<NotPredicateExpression>(
            'NotPredicateExpression(expression: {{0}})'),
      ),
      Mapped(
        Preceded(_and, _suffix),
        Expr<AndPredicateExpression>(
            'AndPredicateExpression(expression: {{0}})'),
      ),
      _suffix,
    ));

const _primary = Named(
    '_primary',
    Choice6(
      _symbol,
      _literal,
      _characterClass,
      _group,
      _anyCharacter,
      _errorHandler,
    ));

const _productionRule = Named(
    'productionRule',
    Choice2(
      Mapped(
          Tuple6(
            _type,
            Opt(_metadata),
            _identifier,
            _eq,
            _expression,
            _semicolon,
          ),
          Expr<ProductionRule>(
              r'ProductionRule(resultType: {{0}}.$1, metadata: {{0}}.$2, name: {{0}}.$3, expression: {{0}}.$5)')),
      Mapped(
          Tuple5(
            Opt(_metadata),
            _identifier,
            _eq,
            _expression,
            _semicolon,
          ),
          Expr<ProductionRule>(
              r'ProductionRule(metadata: {{0}}.$1, name: {{0}}.$2, expression: {{0}}.$4)')),
    ));

const _question = Named('_question', Terminated(Tag('?'), _ws));

const _range = Named(
    '_range',
    Choice2(
      Mapped(
        SeparatedPair(_rangeChar, Tag('-'), _rangeChar),
        Expr<(int, int)>(r'({{0}}.$1, {{0}}.$2)'),
      ),
      Mapped(
        _rangeChar,
        Expr<(int, int)>(r'({{0}}, {{0}})'),
      ),
    ));

const _rangeChar = Named(
    '_rangeChar',
    Choice2(
      Preceded(
          Tag('\\'),
          Choice2(
            Mapped(_escapedChar, Expr<int>('{{0}}.codeUnitAt(0)')),
            Mapped(_hexValue, Expr<int>('{{0}}.codeUnitAt(0)')),
          )),
      Preceded(Not(Tag('\\')), AnyChar()),
    ));

const _recordType = Named(
  '_recordType',
  Delimited(
    _openParenthesis,
    Choice4(
      Mapped(
        _namedFields,
        Expr<ResultType>(r'RecordType(named: {{0}})'),
      ),
      Mapped(
        Tuple3(
          _positionalFields,
          _comma,
          _namedFields,
        ),
        Expr<ResultType>(r'RecordType(positional: {{0}}.$1, named: {{0}}.$3)'),
      ),
      Mapped(
        Tuple4(
          _type,
          _comma,
          _positionalFields,
          Opt(_comma),
        ),
        Expr<ResultType>(r'RecordType(positional: [{{0}}.$1, ...{{0}}.$3])'),
      ),
      Mapped(
        Tuple2(
          _type,
          _comma,
        ),
        Expr<ResultType>(r'RecordType(positional: [{{0}}.$1])'),
      ),
    ),
    _closeParenthesis,
  ),
);

const _semicolon = Named('_semicolon', Terminated(Tag(';'), _ws));

const _sequence = Named(
    '_sequence',
    Mapped(
      Tuple2(SeparatedList1(_sequenceElement, _ws), Opt(_action)),
      Expr<SequenceExpression>(
          r'SequenceExpression(expressions: {{0}}.$1, action: {{0}}.$2)'),
    ));

const _sequenceElement = Named(
    '_sequenceElement',
    Choice2(
      Mapped(
        SeparatedPair(_identifier, _colon, _prefix),
        Expr<Expression>(r'{{0}}.$2..semanticVariable = {{0}}.$1'),
      ),
      _prefix,
    ));

const _singleQuote = Named('_singleQuote', Terminated(Tag("'"), _ws));

const _star = Named('_star', Terminated(Tag('*'), _ws));

const _suffix = Named(
    '_suffix',
    Choice5(
      Mapped(
        Terminated(_primary, _star),
        Expr<ZeroOrMoreExpression>('ZeroOrMoreExpression(expression: {{0}})'),
      ),
      Mapped(
        Terminated(_primary, _plus),
        Expr<OneOrMoreExpression>('OneOrMoreExpression(expression: {{0}})'),
      ),
      Mapped(
        Tuple2(_primary, _minMax),
        Expr<RepetitionExpression>(
            r'RepetitionExpression(expression: {{0}}.$1, min: {{0}}.$2.$1, max: {{0}}.$2.$2)'),
      ),
      Mapped(
        Terminated(_primary, _question),
        Expr<ZeroOrMoreExpression>('OptionalExpression(expression: {{0}})'),
      ),
      _primary,
    ));

const _symbol = Named(
    '_symbol',
    Mapped(
      _identifier,
      Expr<SymbolExpression>(r'SymbolExpression(name: {{0}})'),
    ));

const _type = Ref<String, ResultType>('_type');

const _type_ = Named(
    '_type',
    Choice2(
      _genericType,
      _recordType,
    ));

const _typeArguments = Named(
    '_typeArguments',
    Delimited(
      _lt,
      SeparatedList1(_type, _comma),
      _gt,
    ));

const _ws = Named('_ws', SkipWhile(InRange(['\t', '\r', '\n', ' '])));

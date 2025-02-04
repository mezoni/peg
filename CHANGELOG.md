# 7.0.1

- Fixed a bug in printing repetition expressions created using syntactic sugar.

# 7.0.0

- Breaking change:
  - Improved reliability by using records for result return.
  - Changed the behavior of semantic variables, Only the special variable `$` can return a result. This allows to slightly increase the speed by explicitly defining the need for the result.

# 6.0.4

- Fixed a bug in generating negated character classes.

# 6.0.3

- To make it easier to find rules for which the result type was not determined automatically, a non-nullable result type `Object` will be assigned.

# 6.0.2

- Some typos have been corrected.
- Added information about the naming convention for expression result types.
- Added information on how to generate the parser programmatically.
- The `State` class has been updated with many functions for parsing strings and characters.

# 6.0.1

- The `comment` option was not taken into account

# 6.0.0

- Everything was implemented from scratch. There are breaking changes.

# 5.0.1

- Changes in the grammar file `bin/peg.peg`.
- Added meta expression `@tag()`
- Changes in the file `README.md`.

# 5.0.0

- Error generation algorithms have been slightly reworked.
- Breaking change: Removed meta expression `@errorHandler()`.
- Breaking change: The `And Predicate` expression no longer returns a result. For consistency of these expressions `&expr == !(!expr)`.
- Added meta expression `@indicate()`.
- Added meta expression `@message()`.
- Changes in the file `README.md`.

# 4.0.7

- Removed unnecessary code from file `helper.dart`.
- Minor changes to the binary search source code.

# 4.0.6

- The code generator for generating binary search expressions (for predicates and transitions) has been implemented in a new way. It generates reliable but not optimized code. The source code is then optimized to produce an optimal source code.

# 4.0.5

- The source code for supporting the parser runtime has been reworked.
- The generated code has been optimized for some cases of using the expressions `OneOrMoreGenerator` and `ZeroOrMoreGenerator`.
- The error post-processing system has been slightly improved. With a few changes, it is now possible to reduce the number of errors generated at runtime when parsing characters, without losing information about the actual errors.  Because such errors can be recovered without any problems at the end of the parsing, if the parsing fails. This results in a slight increase in overall parsing performance (5-20%), especially in cases where increasing performance is almost impossible.
- Code generation for parsing literals has been improved.

# 4.0.4

- Fixed bug in method `matchLiteralAsync()`.
- Code generation for `OrderedChoice` consisting of literals only has been improved.
- Changes to the `csv.peg` grammar file.

# 4.0.3

 - The implementation of the generated code for the meta expression `@errorHandler` has been reworked, all calculations are performed in the handler without accessing methods of the `State` class.
 - The implementation of the generated code for the meta expression `@expected` has been reworked, all calculations are performed in the handler without accessing methods of the `State` class.
 - The source code for supporting the parser runtime has been changed. The no longer needed methods `canHandleError` and `rollbackErrors` have been removed. Added a new field `int lastFailPos` to the `State` class.
 - Changes to the `calc.peg` grammar file.

# 4.0.2

- Fixed bugs in `CutExpression`. The correct behavior is to apply this expression only to the child expressions of the parent expression `SequenceExpression` and does not apply to child expressions of child expressions of the parent. Its scope is also limited by its parent.
- Breaking changes: Meta expressions `@sepBy` and `@sepBy1` have been replaced with meta expressions `@list` and `@list1`. This was done for the reason that the old expressions did not allow the use of the expression `cut`.

# 4.0.1

- Changes in the file `README.md`.
- Changes to the `calc.peg` grammar file.
- Changes to the `csv.peg` grammar file.
- Changes to the `json.peg` grammar file.
- Due to the fact that PEG does not have the expression `character`, but only `character class`, the error class `ErrorExpectedCharacter` was removed. For the reason that there is no way to syntactically declare in the grammar whether a range of characters with one element is a character or a range of characters (with one range). Using the error class `ErrorExpectedCharacter` together with a range of characters (`character class`) can lead to ambiguous perception of such error messages.
- The source code for supporting the parser runtime has been reworked.
- Added `@eof` meta expression.
- Added `@expected` meta expression.

# 4.0.0

- Now creating a stream parser will not be difficult. Buffering of input data occurs automatically. Clearing the buffer (during parsing) of unnecessary data also occurs automatically. The new `cut` expression serves as a marker to keep track of unnecessary input data. An attempt to parse inaccessible input data (removed from the buffer) is completely excluded at the grammar level, that is, at the parsing level. The grammar developer independently determines where (in what position of parsing the input data) it is useful to cut off the input data by inserting `cut` expressions into the grammar.
- A new expression `cut` has been implemented.
- A new expression `sepBy1` has been implemented.

## 3.0.4

- Changes in the file `README.md`.
- The implementation of methods for parsing characters and strings has been reworked and improved. Also, unused methods of this type are not included in the source code of the generated parser if they are not used.

## 3.0.3

- Changed implementation of the asynchronous parsing algorithm. The source code generated by asynchronous parsers now looks more natural and readable, and at the same time it now works a little faster (about 10%). New asynchronous parsing algorithm is easier to maintain and improve.

## 3.0.2

- The generated source code for parsing terminal expressions has been optimized. The synchronous parser is now faster.

## 3.0.1

- Since support for generation of streaming parsers has been implemented, support for parsing directly from files, without using `Stream"` is no longer supported. All relevant code will be removed, resulting in a reduction in runtime code size and a slight increase in parsing performance. Accordingly, support for parsing from `virtual` strings via `StringReader` will be removed and parsing will be done directly from `String` values.

## 3.0.0

- Breaking and new features. Added implementation of automatic generation of converters. The converter is generated into a separate file. This required changes to the command line tools to unify the way classes and file names are named. To continue normal operation, it is need to rename the grammar file, removing the suffix `_parser` from the file name, if one would be used in the name of the grammar file (eg. rename `json_parser.peg` to `json.peg`).
## 2.0.2

- Changes in the file `example_parse_from_stream.dart`.
- Changes in terminal expression parsing algorithms. The order of statements has been changed.

## 2.0.1

- Changes in the file  `example_parse_from_stream.dart`.
- Implemented the ability to statistic buffer loading during streaming parsing. Added field `ChunkedParsingSink.bufferLoad`.

## 2.0.0

- Changes in the file `README.md`.
- Added example file `example_parse_from_stream.dart`.
- Implemented support for generating asynchronous code in the `ProductionRuleGenerator` generator.
- Implemented support for generating asynchronous code in the `AndPredicateGenerator` generator.
- Implemented support for generating asynchronous code in the `AnyCharacterGenerator` generator.
- Implemented support for generating asynchronous code in the `BufferGenerator` generator.
- Implemented support for generating asynchronous code in the `CharacterClassGenerator` generator.
- Implemented support for generating asynchronous code in the `ErrorHandlerClassGenerator` generator.
- Implemented support for generating asynchronous code in the `LiteralGenerator` generator.
- Implemented support for generating asynchronous code in the `NotPredicateGenerator` generator.
- Implemented support for generating asynchronous code in the `OneOrMoreGenerator` generator.
- Implemented support for generating asynchronous code in the `OptionalGenerator` generator.
- Implemented support for generating asynchronous code in the `OrderedChoiceGenerator` generator.
- Implemented support for generating asynchronous code in the `RepetitionGenerator` generator.
- Implemented support for generating asynchronous code in the `SepByGenerator` generator.
- Implemented support for generating asynchronous code in the `SequenceGenerator` generator.
- Implemented support for generating asynchronous code in the `SliceGenerator` generator.
- Implemented support for generating asynchronous code in the `StringCharsGenerator` generator.
- Implemented support for generating asynchronous code in the `VerifyGenerator` generator.
- Implemented support for generating asynchronous code in the `ZeroOrMoreGenerator` generator.

## 1.0.33

- Changes in the file `README.md`.
- Changes in the file `example/json_parser.peg`. Removed result type in rule definitions `Array`and `StringChars`.
- Added `@stringChars` meta expression. Improves the efficiency of parsing string characters. By definition, `string characters` mean the characters between the opening and closing quotes, including escape sequences.

## 1.0.32

- Fixed a bug in the `JSON` grammar example. An incorrect range of characters was specified for parsing hex numbers.

## 1.0.31

- Changes in the implementation of the `_OrderedChoiceGenerator2`.
- Changes in the implementation of the `_NotPredicateGenerator2`.
- Changes in the implementation of the `SymbolGenerator`.
- Changes in the implementation of the `_ZeroOrMoreGenerator3`.
- Changes to the `peg_parser.peg` grammar files.
- Changes in the file `README.md`.

## 1.0.30

- Changes in the file `README.md`.
- Change in project description.
- Changes in project dependencies. Removed dependency on `dart_style`.
- Changes (improvements and bug fixes) in the implementation of the `_OrderedChoiceGenerator2`.

## 1.0.29

- Breaking change. To avoid situations where error registration in the `@verify`meta expression handler may be performed incorrectly, the error registration procedure has been simplified. The local variable `ParseError? error` is now intended for this purpose. If this variable is set to a value in the handler, this will mean that the verification was completed unsuccessfully and this error must be registered.
- Breaking change. To avoid situations where error registration in the `@errorHandler`meta expression handler may be performed incorrectly, the error registration procedure has been simplified. The local variable `ParseError? error` is now intended for this purpose. Also, to implement the ability to roll back last errors, the local variable `rollbackErrors` will be available.
- Changes in the file `README.md`.

## 1.0.28

- Fixed bug in PEG grammar. Fixed errors related to incorrect implementation of parsing rules for the native type `Record`.

## 1.0.27

- Changes (improvements and bug fixes) in the implementation of the `@verify` meta expression. To correctly implement the ability to roll back errors registered during parsing, which ends successfully, the implementation of a specific mechanism is required. Such a mechanism was implemented in this meta expression. To use this mechanism, a local function `fail(ParseError error)` is declared in this meta expression. This is the function that should be used to register an error instead of directly calling the methods of the `state` instance.

## 1.0.26

- Breaking change: The value type of parsing events is now `enum`. The type name is formed from the name of the parser with the word `Event` added at the end (example, `JsonParser` => `JsonParserEvent`). Using an enumeration makes it easier to control how event values are handled in a `switch` statement. Also, the use of values of the `Enum` type increases the performance of the `switch` statement compared to processing values of the `String` type.
- Changes to the `json_parser.peg` grammar example file.

## 1.0.25

- Changes in the file `README.md`.
- Changes in the implementation of `OrderedChoiceGenerator` and `ZeroOrMoreGenerator`.
- Changes in the implementation of `CharacterClassGenerator`.
- Fixed a bug in the implementation of `SymbolGenerator`. Events were not generated for rules with the annotation `@inline`.
- Added example file `example_parse_events.dart`.

## 1.0.24

- Changes to the `peg_parser.peg` grammar files. Added a `NativeIdentifier` production rule to parse native identifier.

## 1.0.23

- Added example file `example_parse_from_file.dart`.
- Changes in the file `README.md`.
- Changes in the file `pubspec.yaml`.
- Fixed a bug in the implementation of `VerifyGenerator`.

## 1.0.22

- Breaking change: The return type of the expression `Sequence` with more than one element has changed if semantic variables are not specified. Previously, a result with type `Record` (with positional fields)  was returned, now a result with type `List<Object?>` is returned. This is done so as not to overload the system for automatically inferring the type of results returned. Because using the `Record` type as the return type by default leads to an exponential increase in the number of types for fields of the `Record` type (where the fields refer to another `Record` and so on very deeply), since the `Record` type is a very informative type and contains a huge amount of information.

## 1.0.21

- Fixed a bug in the implementation of `rangesToPredicate()`.

## 1.0.20

- Due to the large number of rules without specifying types, the automatic inference of the result type may hangs for a long time. To resolve this situation, an exception will be thrown with instructions to temporarily specify the types directly in the grammar.

## 1.0.19

- Changes to the `csv_parser.peg` and `json_parser.peg` grammar example files. For some production rules, the result type descriptions have been removed since the result types is inferred automatically.
- Changes to the `peg_parser.peg` grammar files.

## 1.0.18

- Changes to the `csv_parser.peg` and `json_parser.peg` grammar example files.
- Changes in the implementation of `CharacterClassExpression.toString()`
- Changes in the implementation of `ProductionRule.toString()`
- Breaking change: The order of the production rule attributes has been changed. Metadata must be specified before specifying the result type.
- The generator now generates documenting comments for the production rules. The rule definition is used as text.

## 1.0.17

- Changes to the `json_parser.peg` grammar example file.
- Added `@sepBy` meta expression.

## 1.0.16

- Added example file `example.dart`.
- Added the `tool/build.dart` file for generating grammar example files with the current version of the generator.
- Added example file `example/build_examples.dart`.
- Changes in the file `README.md`.
- Fixed different bugs.

## 1.0.15

- Fixed a bug in the implementation of `Utf8Reader.indexOf()`.
- Added `@matchString` meta expression.

## 1.0.14

- The files `README.md` and `CHANGELOG.md` have been translated into English.

## 1.0.12

- Added implementation examples of `Utf8Reader` and `FileReader`.

## 1.0.11

- The `AndPredicateActionExpression` expression has been removed due to the fact that the functionality of this expression can easily be implemented using the `@verify` meta-expression.

## 1.0.10

- Correction in checking the possibility of optimizing the code generated by the `OrderedChoiceGenerator` generator.
- A new PEG parser has been generated, example files have been generated.
- Added `@verify` meta expression.

## 1.0.9

- Optimization of the code generated by the `OrderedChoiceGenerator` generator.

## 1.0.8

- Changed the implementation of the error handler. The error handler is implemented through a meta expression. The new handler is also made more reliable and easier to understand.
- The concept of meta-expressions has been added to the PEG grammar syntax.

## 1.0.7

- Added `AndPredicateActionExpression`.

## 1.0.6

- Optimization of the code generated by the `SliceGenerator` generator has been cancelled.
- Changes to the `json_parser.peg` grammar example file.
- Changes to the grammar example file `calc_parser.peg`.

## 1.0.5

- Optimization of the code generated by the `OptionalGenerator` generator.
- Optimization of the code generated by the `ZeroOrMoreGenerator` generator.
- Changes to the `json_parser.peg` grammar example file.


## 1.0.4

- Added documentation for universal top-level parsing functions from `runtime` code.

## 1.0.3

- Fixed a bug in the `csv_parser.peg` grammar example.

## 1.0.2

- Changes to PEG grammar regarding escaped characters.

## 1.0.1

- Added an example of a CSV parser.

## 1.0.0

- A new version. Second life of the project.

## 0.0.54

- Fixed bug in `CharacterClassExpressionGenerator`
- Fixed bug in `LiteralExpressionGenerator`
- Modified example grammar `arithmetic.peg`

## 0.0.53

- Added grammar analyzer `PredicatesWithOptionalExpressionsFinder`
- Added grammar analyzer `PredicatesWithEmptyExpressionsFinder`

## 0.0.52

- Fixed bug in `ExpressionGenerator`

## 0.0.51

- Fixed minor bug in `InfiniteLoopFinder`

## 0.0.50

- For the better error reporting used the package `parser_error` in some parsers

## 0.0.49

- In function` _failure` corrected the conditions of the detection of `unterminated` tokens 

## 0.0.48

- Added "How to write a good PEG grammar" recommendation 'how_to_write_a_good_peg_grammar.md'
- Added a trace statistic about how and why the generator determines the kind of the production rules. Can help a lot for writing good grammar. Command line `peg stat -d high grammar.peg`
- Significant improvements in the recognition of the production rule kinds: sentences (non-terminals), lexemes (tokens) and morphemes (100% recognition)

## 0.0.47

- Removed `TODO` remarks in the generated parsers 

## 0.0.46

- Improving the mechanism for determining at runtime the ways of the elimination of the double memoization for the rules in the lowest layers. Previous way was a restriction (at the parser generation stage but not at runtime)  on the memoization for all morphemes. Now it is more adaptive and  can optimize the caching strategies at runtime for all kins of rules that allows memoization

## 0.0.45

- Disabled memoization for morphemes

## 0.0.44

- Added optional parameter `offset` in method `_text()`
- Fixed bug in `SequenceExpressionGenerator` with assigning the variable `_startPos` in sequences with single expression

## 0.0.43

- Added missing option values `lower_case` for formatter command `stylize`

## 0.0.42

- Experimental feature. Lazy memoization. Production rules that are marked by the generator as a "can be memorized" rules are turned off by default by the parser in runtime. Only on demand, when parser detects the real requirement of caching, they will be turned on. This feature allows do not perform necessarily caching of results if they was requested only once at some position. Behavior of each rule at runtime is tracked individually

## 0.0.40

- Minor changes in caching mechanics.

## 0.0.39

- Added semantic variable `$start` which point out to the beginning of the current sequence of expressions
- Experimental feature. Changing word compound of production rule name via the grammar formatter `pegfmt`. Eg. `pegfmt stylize -morpheme upper_case grammar.peg`

## 0.0.38

- Changed algorithm of determining the lexical production rules. This was required to provide correct support of results of direct recursion elimination (via `pegfmt`). From now results of these transformations fully supported by the front-end recognizer (`TerminalRulesFinder`)

## 0.0.37

- Experimental feature. Elimination of the direct left recursion via the grammar formatter `pegfmt`. Eg. `pegfmt recursion grammar.peg`

## 0.0.36

- Changes in `MethodFailureGenerator`. Improves the handling errors in method `_failure`. Error messages now more informative

## 0.0.35

- Fixed minor bugs with error messages

## 0.0.34

- Fixed bug in `StartCharactersResolver`

## 0.0.33

- Added the binary search algorithm to method `getState` (determiner of the current state through the symbol transitions) in a generated `general` parsers. This feature improves the performance of the parsing of a complex grammar with a wide range of used input symbols

## 0.0.32

- Fixed bug in `OrderedChoiceExpressionGenerator` associated with incomplete coverage of range in symbol transitions

## 0.0.31

- Added grammar formatter utility `pegfmt.dart`
- Fixed bug in `_text() => String`

## 0.0.30

- Minor (speed up) changes in `json` grammar. From now the generated `json_parser` is a fast enough parser, given the fact that it is the generated PEG parser
- Minor (speed up) changes in `peg` grammar
- Minor (speed up) changes in expression resolvers

## 0.0.29

- Fixed bug in `LeftRecursionsFinder`

## 0.0.28

- Improved implementation of the symbol transition code generation

## 0.0.27

- Added initial support and implementation of the symbol transitions. The complex grammar should be parsed faster  

## 0.0.25

- Fixed a very small bug in the creation of the parser error
- Improved statistic information in the command `stat`

## 0.0.24

- Added recognition and error reporting of the `malformed tokens` (eg, number's)
- Added recognition and error reporting of the `unterminated tokens` (eg, string's)
- Added statistic information in the command `stat` about the `expected lexemes` in the non-terminals. Can be used for visual analyzing of the quality of the developed grammar and the proposed error messages on the failures
- Fixed bugs in the grammar `example/json.peg` (thanks to the newly added recognition and error reporting of the `malformed tokens`) 

## 0.0.23

- Added function `errors() => List<ParserError>`
- Breaking change. Removed 'line' and 'column' properties.
- Refactored the entire codebase for easiest implementing several kinds of parser generators
- Started the improvements of the error messages. From now all the parser errors are an instances of `XxxParserError` type.

## 0.0.21

- Fixed bug in `_matchString`
- Removed convention on a naming terminals and non-terminals in favor to the possibility of analyzing (and control) the grammar on the subject of the auto generated representation names of terminals

## 0.0.20

- Added statistics about an auto generated names of the terminals (they used in the error messages). This feature useful for correcting grammar for better perception of the components of the grammar
- Fixed bugs in `ExpectationResolver` (error messages about the expected lexemes are now more correct)

## 0.0.19

- Added full functional example of json parser
- Fixed bug in `CharacterClassExpressionGenerator`

## 0.0.18

- Fixed bug in `AndPredicateExpressionGenerator` (was missed character `;` in the template after refactoring) 

## 0.0.16

- Added initial support of the tokens for improving the errors messages and support of the upcoming AST generator
- Was improved the basic ("expectation") error messages

## 0.0.15

- Added instruction optimizer in the interpreter parser
- Added the subordination of terminals (master, slave, master/slave). In some cases this can helps developers to writing (after the analyzing) grammar better and, also, this helps for the generator to better optimize the grammar and helps to improve error messages
- Breaking change: All methods, except the starting rules, are now private methods in all parsers. This is done for the interoperability of the generated parsers, better error messaging and performance improvement of parsing processes

## 0.0.12

- Added new parser generator: interpreter parser
- Minor bug fixes

## 0.0.11

- Restored the previous performance (which has been decreased due to the support of the Unicode characters) through the addition of a pre-generated ASCII strings table  

## 0.0.10

- Bug fixes for the full support of the Unicode characters

## 0.0.9

- Fixed bugs (the character code units are not an Unicode characters)
- Parser now supports the Unicode characters (uses 32-bit runes instead of 16-bit code units) 

## 0.0.8

- Medium improvements of performance by reducing restrictions on the prediction on optional rules without semantic actions

## 0.0.7

- Minor improvements in the expression generators (reduction of the `break` statements)

## 0.0.6

- Fixed bug in the original peg grammar in `COMMENT`

## 0.0.3

- Added an example of the usage of a simple `arithmetic` grammar
- Added an example of the usage of a simple `arithmetic` grammar

## 0.0.2

- Small fixes in `bin/peg.dart`

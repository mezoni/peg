## 1.0.0

- Новая версия. Вторая жизнь проекта.

## 0.0.54

- Fixed bug in `CharacterClassExpressionGenerator`
- Fixed bug in `LiteralExpressionGenerator`
- Modified example grammar `arithmetic.peg`

## 0.0.53

- Added grammar analyser `PredicatesWithEmptyExpressionsFinder`
- Added grammar analyser `PredicatesWithOptionalExpressionsFinder`

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
- Significant improvements in the recognition of the production rule kinds: sentences (nonterminals), lexemes (tokens) and morphemes (100% recognition)

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

- Added missign option values `lower_case` for formatter command `stylize`

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
- Added statistic information in the command `stat` about the `expected lexemes` in the nonterminals. Can be used for visual analysing of the quality of the developed grammar and the proposed error messages on the failures
- Fixed bugs in the grammar `example/json.peg` (thanks to the newly added recognition and error reporting of the `malformed tokens`) 

## 0.0.23

- Added function `errors() => List<ParserError>`
- Breaking change. Removed 'line' and 'column' properties.
- Refactored the entire codebase for easiest implementing several kinds of parser generators
- Started the improvements of the error messages. From now all the parser errors are an instances of `XxxParserError` type.

## 0.0.21

- Fixed bug in `_matchString`
- Removed convention on a naming terminals and nonterminals in favor to the possibility of analyzing (and control) the grammar on the subject of the auto generated representation names of terminals

## 0.0.20

- Added statistics about an auto generated names of the terminals (they used in the error messages). This feature useful for correcting grammar for better perception of the components of the grammar
- Fixed bugs in `ExpectationResolver` (error messages about the expected lexemes are now more correct)

## 0.0.19

- Added full functional example of json parser
- Fixed bug in `CharacterClassExpressionGenerator`

## 0.0.18

- Fixed bug in `AndPredicateExpressionGenerator` (was missed character `;` in the template after refactoring) 

## 0.0.16

- Added initial support of the tokens for improving the errors messages and support of the upcomming AST generator
- Was improved the basic ("expectation") error messages

## 0.0.15

- Added instruction optimizer in the interpreter parser
- Added the subordination of terminals (master, slave, master/slave). In some cases this can helps developers to writing (after the analysing) grammar better and, also, this helps for the generator to better optimize the grammar and helps to improve error messages
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

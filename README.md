# peg

Command line tool for generating PEG parsers with support for event-based parsing and parsing directly from files.

Version: 1.0.28

[![Pub Package](https://img.shields.io/pub/v/peg.svg)](https://pub.dev/packages/peg)
[![GitHub Issues](https://img.shields.io/github/issues/mezoni/peg.svg)](https://github.com/mezoni/peg/issues)
[![GitHub Forks](https://img.shields.io/github/forks/mezoni/peg.svg)](https://github.com/mezoni/peg/forks)
[![GitHub Stars](https://img.shields.io/github/stars/mezoni/peg.svg)](https://github.com/mezoni/peg/stargazers)
[![GitHub License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://raw.githubusercontent.com/mezoni/peg/main/LICENSE)

## About this software

This software does not contain a public API because it is a console application (command line tool).  
This tool is intended to generate the source code of PEG parsers.  
Before using this tool, it is necessary to activate it using the package manager `pub`.

## Activation and usage

To activate this command line tool, run the following command:

```bash
dart pub global activate peg
```

After activation, you can use the following command to use the command line tool:

```bash
dart pub global run peg
```

## Source code of the generated parser

All generated parsers support the following features:  
- Parse input data using events (event-based parsing) to save memory consumption
- Parse directly from files without having to load input data into memory
- Very efficient input data parsing in terms of performance and memory consumption

The source code of the generated parser consists of the following parts:
- Source code of the parser class (generated from grammar rules)
- Source code of the parser class members (defined by the grammar)
- Source code of library members (defined by grammar)
- Runtime source code

The source code of the parser class members and library members are specified directly in the grammar and are used for two purposes:
- Ensuring the operability of the parser (for example, import directives)
- Extending the capabilities and optimization of the parser by extending the capabilities of the instance of the parser class

## Grammar

To declare expressions, a syntax is used that is basically similar to the generally accepted syntax of PEG expressions and, at the same time, additional syntax is used to expand the capabilities of PEG expressions.  
A modified syntax is used to declare production rules.  
The grammar declaration uses its own syntax.  

This generator generates itself from a grammar written using its own syntax.  
For a more detailed acquaintance with the syntax, it is recommended to familiarize yourself with the syntax of the grammar used to generate this PEG parser.  
https://github.com/mezoni/peg/blob/main/bin/peg_parser.peg

Grammar declaration is made using sections, like sections for a preprocessor, but at the same time, it should be noted that preprocessing is not performed and grammar processing (parsing) occurs in one stage.  

3 sections are used to declare the grammar:
- Section for declaring directives and global members
- Section for declaring members of instances of the parser class
- Section for declaring grammar rules

Example of a grammar declaration:

```
%{

import 'foo.dart';

}%

%%

const SimpleParser();

%%

A = [A-Za-z] * ;

```

The grammar must contain at least one production rule, which means that using a section to declare grammar rules is mandatory. The use of other sections is optional and is determined by the actual needs based on the chosen method of declaring the grammar.

## Production rules

The declaration of a production rule consists in specifying (in a certain sequence) the attributes of the rule and its body and consists of the following elements:
- Metadata
- Type of the returned result
- Name of the production rule
- Symbol `=`
- Expression
- Symbol `;`

The type of the returned result and metadata are optional.  
To specify the type of the returned result of the production rule, you must use the syntax of the Dart language.  
The concept of metadata differs from that used in the Dart language and is used exclusively as instructions for the parser generator.

Example of a production rule declaration with result type and metadata:

```
- Metadata
bool
False = 'false' Spaces { $$ = false; } ;

@event
MapEntry<String, Object?>
KeyValue = k:Key Colon v:Value { $$ = MapEntry(k, v); };
```

## Expressions

Below is a list of available expressions.

Name: `Orderer choice`  
Operator: `/`  
Number of operands: 2 or more

Executes operands in the specified order, and if the execution of the next operand succeeds, this result is returned. If the execution of the next operand fails, then the next operand is executed and this happens until the execution of one of the operands succeeds. If all operands fail, then this expression fails.

Example:

```
'abc' / 'def'
```
___

Name: `Sequence`  
Operator: not used  
Number of operands: 2 or more

Executes, in the specified order, all operands, and if the execution of any operand fails, the expression immediately fails. If the execution of all operands succeeds, the result is returned, the value and type of which depend on whether semantic variables and/or semantic action were used .

Example:

```
'abc' 'def'
```
___

Name: `Optional`  
Operator: `?`  
Number of operands: 1

Executes the operand and if the execution of the operand succeeds, this result is returned. If the operand execution fails, then this expression succeeds and returns `null'.

```
'abc'?
```
___

Name: `Zero or more`  
Operator: `*`  
Number of operands: 1

Cyclically executes the operand until the execution of the operand fails. During execution, adds the results of the operand execution in a list. After the loop is completed, the expression succeeds and a list of results is returned.

```
'abc'*
```
___

Name: `One or more`  
Operator: `+`  
Number of operands: 1

Cyclically executes the operand until the execution of the operand fails. During execution, puts the results of the operand execution in a list. If the number of items in the list of results is at least 1, then the list of results is returned.

```
'abc'+
```
___

Name: `Repetition`  
Operators: `{min,max}` or `{min,}` or `{,max}` or `{n}`  
Number of operands: 1

Note: The use of spaces in the operator body (i.e., between `{` and `}`) is not allowed and will lead to syntax error.

Example of misuse:

```
[0-9A-Zza-Z]{1, 4}
```

Operator `{min,max}`:

Cyclically executes the operand at least `min` and no more than `max` times. During execution, puts the results of the operand execution in a list. If (after the end of the loop) the number of items in the list of results is at least `min`, then the list of results is returned.

```
[0-9A-Zza-Z]{1,4}
```

Operator `{min,}`:

Cyclically executes the operand at least `min` times. During execution, puts the results of the operand execution in a list. If (after the end of the loop) the number of items in the list of results is at least `min`, then the list of results is returned.

```
[0-9A-Zza-Z]{2,}
```

Operator `{,max}`:

Cyclically executes the operand no more than `max` times. During execution, puts the results of the operand execution in a list. After completing the execution of the loop, a list of results is returned.

```
[0-9A-Zza-Z]{,4}
```

Operator `{n}`:

Cyclically executes the operand `n` times. During execution, puts the results of the operand execution in a list. If (after the loop is completed) the number of items in the result list is `n`, then the result list is returned.

```
[0-9A-Zza-Z]{4}
```
___

Name: `Literal`  
Operator: not used  
Operands: string value enclosed in single quotes

Note: It is allowed to use an empty string as an operand. In this case, the expression always succeeds, without changing the current position.

Matches the input data at the current position with a string value. If the matching is successful, then the current position is incremented by the length of the string value and this string value is returned.

```
'abc'
```
___

Name: `Character class`  
Operator: not used  
Operands is a character ranges enclosed between `[` and `]` or `[^` and `]`

Note: It is not allowed to use an empty range as an operand.

Operand: character ranges enclosed between `[` and `]`

Checks the character from the input data at the current position for occurrence in one of the specified ranges. If the check is successful, the current position is increased by the length of the current character and the current character is returned.

```
[0-9A-Za-z]
```

Operand is a character ranges enclosed between `[^` and `]`

Checks the character from the input data at the current position for non-occurrence in one of the specified ranges. If the check is successful, the current position is increased by the length of the current character and the current character is returned.

```
[^0-9A-Za-z]
```
___

Name: `Slice`  
Operator: `$`  
Number of operands: 1

Executes the operand and if the execution of the operand succeeds, the text corresponding to the start and end positions of the operand is returned.

```
$([a-z])*
```
___

Name: `Symbol`  
Operator: not used  
Operand: Name of the rule

Executes an operand (a rule with the specified name) and returns the result of executing the operand.

```
$([a-z])*
```
___

Name: `AndPredicate`  
Operator: `&`  
Number of operands: 1

Executes the operand and, if the execution of the operand succeeds, returns the result of the execution of the operand. Upon completion of the operand execution, this expression restores the current position of the input data (that is, the input data is not consumed).

```
&[a-z]+
```
___

Name: `NotPredicate`  
Operator: `!`  
Number of operands: 1

Executes the operand and, if the execution of the operand fails, returns `null'. Upon completion of the operand execution, this expression restores the current position of the input data (that is, the input data is not consumed).

## Meta-expressions

Grammar parsing expressions has a fairly extensive set of expressions, which is quite enough to create complex grammars. But, given the fact that grammar is the basis for generating a top-down parser, the existing set of expressions is not enough to describe a complex parser. Meta expressions, in this case, are a means to describe the behavior of the generated parser. Meta-expressions extend the grammar with capabilities that are not present in it.  
From the point of view of grammar, meta-expressions should be considered as built-in production rules with certain behavior that cannot be implemented by existing expressions.

The following meta expression exist in the current version.
- `@errorHandler`
- `@matchString`
- `@sepBy`
- `@verify`

Name: `@ErrorHandler`  
Parameters:
- Processed expression
- Source code of the handler

The meta expression `@ErrorHandler` is intended to generate errors defined by the developer.  
The capabilities of the error handler allow you to add new errors and/or replace the last errors (that is, generated by the processed expression) with other, more informative errors.  
To replace the last errors in the handler body, a local function `replaceLastErrors(List(ParseError) errors)` is available.  
Calling this function causes the last errors to be removed and at the same time the specified errors are added instead of them.

**Warning:**  
The error handler code is not executed if the error position is not actual (that is, less than the current `failPos` position set in an instance of the `State` class).

Example:

```
HexNumber = @errorHandler(HexNumberRaw, {
final errors = [ErrorMessage(state.pos - state.failPos, 'Expected 4 digit hex number')];
replaceLastErrors(errors);
}) ;
```
___

Name: `@matchString`  
Parameters:
- Source code for expression to get string value

The meta expression `@matchString` is intended to match a string value that can be obtained directly when the expression is executed (for example, a value obtained from the parser parameters).  

Example:

```
Sep = @matchString({ separator }) ;
```
___

Name: `@sepBy`  
Parameters:
- An expression representing an `element`
- An expression representing an `separator`

The meta expression `@sepBy` parses zero or more occurrences of `element`, separated by `separator` and returns a list of elements as a result.

Example:

```
Elements = @sepBy(Element, Separator) ;
```

This is an optimized version of the following expression.

```
v:(h:Element t:(Separator v:Element)* { $$ = [h, ...t]; })? { $$ = v ?? const []; }
```

Grammar optimization is achieved by reducing grammar expressions. Optimization of the generated code is achieved by reducing array creation operations.  
As a result, the grammar becomes more readable, and the generated parser code works more efficiently.
___

Name: `@verify`  
Parameters:
- Processed expression
- Source code of the handler

**Important info**:  
To correctly implement the ability to roll back errors registered during parsing, which ends successfully, the implementation of a specific mechanism is required. Such a mechanism is implemented in this meta expression. To use this mechanism, a local function `fail(ParseError error)` is declared in this meta expression. This is the function that should be used to register an error instead of directly calling the methods of the `state` instance.

The meta expression `@verify` is intended to support the implementation of certain functions of context-sensitive grammars.  
Despite the fact that this meta-expression looks at first glance as dependent on the processed expression, nevertheless it can also be used as an independent expression, in the case of using the processed expression, which always succeeds.  
What is the meaning of the above statement?  
As follows from the name of the specified meta-expression, it verifies the result of the processed expression.  
If the processed expression fails, the verifier handler is not executed.  
If the processed expression succeeds, then the verifier handler performs two functions:  
- Verifies the value of the result of the processed expression
- Either does nothing, or generates an error based on the verification results

This meta-expression allows you to simply solve the problems that arise when creating context-dependent grammars.  
It is recommended to use an empty `Literal` as an expression that always succeeds.  
At the same time, any available data can be used as verification data (for example, user settings of the parser implemented by the developer).

Example of result verification:

```
Verify41 = @verify(Integer, {
if ($$ != 41) { fail(state.failPos, ErrorMessage(pos - state.failPos, 'error')); }
}) ;
```

Example of parser configuration verification:

```
VerifyFlag = @verify('', {
if (!flag) { state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'error')); }
}) ;
```

## Semantic variables and actions

In this implementation of the PEG parser generator, the most complex expression (for generation) is considered to be the expression `Sequence`.

This expression is (conditionally) divided into two types:
- Sequences of expressions with one expression
- Sequences of expressions with more than one expression

A quite natural question arises: "Why is a sequence of expressions with one expression a sequence?".  
The short answer to this question may sound something like this: "Because in the current implementation, only a sequence can have a semantic action."

And, since the semantic action, in this case, is not considered as an independent expression, this allows us to make semantic actions a full-fledged analogue of the `map` function, indicating the type of the returned result if required.  
At the same time, this makes it easier to implement nested expressions, due to simple `mapping`.

Before explaining the principles of semantic variables and actions, it is necessary to explain to explain the principles of forming the results of executing `Sequence` expressions.

If the sequence consists of one element, then the result of executing this element is returned as a result.

Example:

```
A = 'abc';
```

The type of the returned value is `String`, the value is 'abc'.

If the sequence consists of more than one element and does not use semantic variables then a value with the `List<Object?>` type is returned as a result, in which the results of the elements are used as list elements.

Example:

```
A = 'abc' 'def';
```

The return value type is `List<Object?>`, the value is `['abc', 'def']`.

Semantic variables allow you to designate the results used and assign names to them.

Example:

```
A = a:'abc';
```

The type of the returned value is `String`, the value is 'abc'.  
The use of a semantic variable, in this case, does not affect the type of result, because the sequence for forming the result contains one element.

Example:

```
A = a:'abc' b:'def';
```

The return value type is `(String a, String b)`, the value is `(a: 'abc', b: 'def')`.

```
A = OpenBrace v:Value CloseBrace';
```

The type of the returned value is determined by the type of the returned value by the expression `Value`.  
The use of one semantic variable, in this case, indicates that the sequence, for the formation of the result, contains one element.

Semantic actions, as mentioned above, play the role of `map` functions and are used to form a result from a sequence of expressions. The use of semantic variables, in this case, is determined by the implemented logic of the sequence.

Example of using a semantic action without variables:

```
bool
False = 'false' Spaces { $$ = false; } ;
```

Since there is no need to use variables in the above example, they are not used.

Example of using a semantic action with variables:

```
MapEntry<String, Object?>
KeyValue = k:Key Colon v:Value { $$ = MapEntry(k, v); };
```

In the above example, the semantic action uses variables to form the final result, which, in essence, works similarly to the function of the function `map(KeyType k, ValueType v)`.

Also, when using semantic shares, you can use the result type of the semantic shares value.

Example of using a semantic action with an indication of the type of result:

```
KeyValue = k:Key Colon v:Value <MapEntry<String, Object?>>{ $$ = MapEntry(k, v); };
```

## Metadata

Metadata is instructions for the generator. Metadata is optional.  
Metadata can be specified when declaring rules by specifying them before the name of the rule.

Examples of specifying metadata.

```
@inline
Foo = 'foo' ;
```

The following instructions are supported in the current version:
- @event
- @inline
- @memoize

The `@event` instruction indicates to the generator that for this rule, when parsing data, it is necessary to call the `beginEvent` and `endEvent` methods. Calling these methods actually allows for `Event-based parsing`.

The `@inline` instruction indicates to the generator that the source code of this production rule should not create a separate method in the parser class and should be generated as code embedded in the method that calls this rule.

The `@memoize` instruction is not implemented in the current version.

## Code snippets

`CheckCondition`

```
CheckCondition = @verify('', {
if (!condition) { state.failAt(state.failPos, ErrorMessage(0, 'Some error message')); }
});
```
___

`Eof`

```
Eof = !. ;
```
___

`Peak`

```
Peak = &foo ;
```
___

`SeparatedList`

```
List<ElemType>
SeparatedList = v:(h:Elem t:(Sep v:Elem)* { $$ = [h, ...t]; })? { $$ = v ?? []; } ;
```
___

`SeparatedList1`

```
List<ElemType>
SeparatedList1 = h:Elem t:(Sep v:Elem)* { $$ = [h, ...t]; } ;
```
___

`SeparatedPair`

```
SeparatedPair = k:Key Sep v:Value { $$ = (k, v); } ;
```
___

`TakeWhile`

```
TakeWhile = $[0-9]* ;
```
___

`TakeWhile1`

```
TakeWhile1 = $[0-9]+ ;
```
___

`Verify`

```
Verify = @verify(Integer, {
if ($$ > 0xff) { state.failAt(state.failPos, ErrorMessage(pos - state.failPos, 'Some error message')); }
});
```

## Examples of parsers

List of parser examples:  
[CSV parser](https://github.com/mezoni/peg/blob/main/example/csv_parser.peg)  
[Calc parser](https://github.com/mezoni/peg/blob/main/example/calc_parser.peg)  
[JSON parser](https://github.com/mezoni/peg/blob/main/example/json_parser.peg)  

## Parsing

The generated parser classes do not contain anything superfluous except the rules and class members defined by the developer.  
For the convenience of working with parser classes, it is proposed to use functions for data parsing.  
These are top-level functions and they are also in the parser library file.  
These are not generated functions, but they are universal functions.  

Below is a list of these functions.

Name: `parseString`  
Purpose: Calls the specified parsing function for the specified string and throws a `FormatException` if parsing fails. If parsing is successful, returns the result.  

Usage example:

```dart
   const source = '1 + 2 * 3';
   final parser = CalcParser();
   final result = parseString(parser.parseStart, source);
   print(result);
```

Name: `fastParseString`  
Purpose: Calls the specified fast parsing function for the specified string and throws a `FormatException` if parsing fails. If successful, returns no result.

Usage example:

```dart
   const source = '1 + 2 * 3';
   final parser = CalcParser();
   fastParseString(parser.fastParseSpaces, source);
```

Name: `parseInput`  
Purpose: Calls the specified parsing function on the specified input source and throws a `FormatException` if parsing fails. If parsing is successful, returns the result.

Usage example:

```dart
   const source = '1 + 2 * 3';
   final input = StringReader(source);
   final parser = CalcParser();
   parseInput(parser.parseStart, input);
```

Name: `tryParse`  
Purpose: Calls the specified parse function on the specified input source and returns a `ParseResult` value.

Usage example:

```dart
   const source = '1 + 2 * 3';
   final input = StringReader(source);
   final parser = CalcParser();
   final result = tryParse(parser.parseSpaces, input);
```

Name: `tryFastParse`  
Purpose: Calls the specified parse function on the specified input source and returns a `ParseResult` value.

Usage example:

```dart
   const source = '1 + 2 * 3';
   final input = StringReader(source);
   final parser = CalcParser();
   final result = tryFastParse(parser.fastParseSpaces, input);
```

# peg

A command line tool for generating (streaming, chunk, file) top-down parsers from a parsing expression grammars (PEG).

Version: 5.0.1

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
https://github.com/mezoni/peg/blob/main/bin/peg.peg

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
bool
False = 'false' Spaces { $$ = false; } ;

@event
MapEntry<String, Object?>
KeyValue = k:Key Colon v:Value { $$ = MapEntry(k, v); };
```

## Expressions

Below is a list of available expressions.

### Orderer choice

Name: `Orderer choice`  
Operator: `/`  
Number of operands: 2 or more

Executes operands in the specified order, and if the execution of the next operand succeeds, this result is returned. If the execution of the next operand fails, then the next operand is executed and this happens until the execution of one of the operands succeeds. If all operands fail, then this expression fails.

Example:

```
'abc' / 'def'
```

### Sequence

Name: `Sequence`  
Operator: not used  
Number of operands: 2 or more

Executes, in the specified order, all operands, and if the execution of any operand fails, the expression immediately fails. If the execution of all operands succeeds, the result is returned, the value and type of which depend on whether semantic variables and/or semantic action were used .

Example:

```
'abc' 'def'
```

### Optional

Name: `Optional`  
Operator: `?`  
Number of operands: 1

Executes the operand and if the execution of the operand succeeds, this result is returned. If the operand execution fails, then this expression succeeds and returns `null'.

Example:

```
'abc'?
```

### Zero or more

Name: `Zero or more`  
Operator: `*`  
Number of operands: 1

Cyclically executes the operand until the execution of the operand fails. During execution, adds the results of the operand execution in a list. After the loop is completed, the expression succeeds and a list of results is returned.

Example:

```
'abc'*
```

### One or more

Name: `One or more`  
Operator: `+`  
Number of operands: 1

Cyclically executes the operand until the execution of the operand fails. During execution, puts the results of the operand execution in a list. If the number of items in the list of results is at least 1, then the list of results is returned.

Example:

```
'abc'+
```

### Repetition

Name: `Repetition`  
Operators: `{min,max}` or `{min,}` or `{,max}` or `{n}`  
Number of operands: 1

⚠️ **Important information:**  
The use of spaces in the operator body (i.e., between `{` and `}`) is not allowed and will lead to syntax error.

Example of misuse:

```
[0-9A-Zza-Z]{1, 4}
```

Operator `{min,max}`:

Cyclically executes the operand at least `min` and no more than `max` times. During execution, puts the results of the operand execution in a list. If (after the end of the loop) the number of items in the list of results is at least `min`, then the list of results is returned.

Example:

```
[0-9A-Zza-Z]{1,4}
```

Operator `{min,}`:

Cyclically executes the operand at least `min` times. During execution, puts the results of the operand execution in a list. If (after the end of the loop) the number of items in the list of results is at least `min`, then the list of results is returned.

Example:

```
[0-9A-Zza-Z]{2,}
```

Operator `{,max}`:

Cyclically executes the operand no more than `max` times. During execution, puts the results of the operand execution in a list. After completing the execution of the loop, a list of results is returned.

Example:

```
[0-9A-Zza-Z]{,4}
```

Operator `{n}`:

Cyclically executes the operand `n` times. During execution, puts the results of the operand execution in a list. If (after the loop is completed) the number of items in the result list is `n`, then the result list is returned.

Example:

```
[0-9A-Zza-Z]{4}
```

### Literal

Name: `Literal`  
Operator: not used  
Operands: string value enclosed in single quotes

Note: It is allowed to use an empty string as an operand. In this case, the expression always succeeds, without changing the current position.

Matches the input data at the current position with a string value. If the matching is successful, then the current position is incremented by the length of the string value and this string value is returned.

Example:

```
'abc'
```

### Character class

Name: `Character class`  
Operator: not used  
Operands is a character ranges enclosed between `[` and `]` or `[^` and `]`

Note: It is not allowed to use an empty range as an operand.

Operand: character ranges enclosed between `[` and `]`

Checks the character from the input data at the current position for occurrence in one of the specified ranges. If the check is successful, the current position is increased by the length of the current character and the current character is returned.

Example:

```
[0-9A-Za-z]
```

Operand is a character ranges enclosed between `[^` and `]`

Checks the character from the input data at the current position for non-occurrence in one of the specified ranges. If the check is successful, the current position is increased by the length of the current character and the current character is returned.

Example:

```
[^0-9A-Za-z]
```

### Slice

Name: `Slice`  
Operator: `$`  
Number of operands: 1

Executes the operand and if the execution of the operand succeeds, the text corresponding to the start and end positions of the operand is returned.

Example:

```
$[a-z]*
```

### Symbol

Name: `Symbol`  
Operator: not used  
Operand: Name of the rule

Executes an operand (a rule with the specified name) and returns the result of executing the operand.

Example:

```
number
```

### AndPredicate

Name: `AndPredicate`  
Operator: `&`  
Number of operands: 1

Executes the operand and, if the execution of the operand succeeds, returns the result of the execution of the operand. Upon completion of the operand execution, this expression restores the current position of the input data (that is, the input data is not consumed).

Example:

```
&[a-z]+
```

### NotPredicate

Name: `NotPredicate`  
Operator: `!`  
Number of operands: 1

Executes the operand and, if the execution of the operand fails, returns `null'. Upon completion of the operand execution, this expression restores the current position of the input data (that is, the input data is not consumed).

Example:

```
![a-z]+
```

### Cut

Name: `Cut`  
Operator: `↑`  
Number of operands: 0

⚠️ **Important information:**  
The behavior is to apply this expression only to the child expressions of the parent expression `SequenceExpression` and does not apply to child expressions of child expressions of the parent. Its scope is also limited by its parent. If a parsing error occurs within the scope of this expression, then such an error is considered unrecoverable, resulting in termination of parsing.

Sets the internal parsing state such that parsing of input data before the current position becomes impossible.  
That is, it effectively disallow the ability to backtrack to any position less than the current (at the time this expression is executed) position.  
This expression is also used when creating grammars to parse input data asynchronously.

In the following example, the expression `cut` applies only to the sequence expression `Comma ↑ v:Field`.  
If the expression `Comma` fails, then this will not be considered an unrecoverable parse error.  
If the expression `v:Field` fails, it will be considered an unrecoverable parse error.  

```
@list(Field, Comma ↑ v:Field)
```

An example of data cutting during asynchronous parsing, to implement the ability to remove unnecessary data from the buffer.

```
OpenQuote ↑ v:Chars CloseQuote { $$ = v.join(); }
```

## Meta expressions

Grammar parsing expressions has a fairly extensive set of expressions, which is quite enough to create complex grammars. But, given the fact that grammar is the basis for generating a top-down parser, the existing set of expressions is not enough to describe a complex parser. Meta expressions, in this case, are a means to describe the behavior of the generated parser. Meta expressions extend the grammar with capabilities that are not present in it.  
From the point of view of grammar, meta expressions should be considered as built-in production rules with certain behavior that cannot be implemented by existing expressions.

The following meta expression exist in the current version.
- `@eof`
- `@expected`
- `@indicate`
- `@list`
- `@list1`
- `@matchString`
- `@message`
- `@stringChars`
- `@tag`
- `@verify`

### @eof

Name: `@eof`  

The meta expression `@eof` is the implementation of the expression `eof` as it should be, in contrast to the traditional implementation in the form of the expression `!.` (not any character).

Example:

```
@eof()
```

### @expected

Name: `@expected`  
Parameters:
- Literal value of `tag`
- Processed expression

If errors occurred at the initial position of parsing a child expression, then meta expression `@expected` replaces parsing error of the child expression with an error that displays a message that the specified tag is expected.

Example:

```
@expected('expression', Primary_)
```

Example of error output:

```
FormatException: line 1, column 5 (offset 4): Expected: 'expression'
1 + `2 * 3
    ^
```

### @indicate

Name: `indicate`  
Parameters:
- Error message
- Processed expression

The meta expression `@indicate` replaces parsing error of the child expression with specified error message.  
Also, when an error message is displayed, an indicator will be used to display the beginning and end of the input data.

Example:

```
@indicate('Expected 4 digit hex number', HexNumber_)
```

Example of error output:
```
FormatException: line 1, column 7 (offset 6): Expected 4 digit hex number
"abc\u020xyz"
      ^^^
```

### @matchString

Name: `@matchString`  
Parameters:
- Source code for expression to get string value

The meta expression `@matchString` is intended to match a string value that can be obtained directly when the expression is executed (for example, a value obtained from the parser parameters).  

Example:

```
Sep = @matchString({ separator }) ;
```

### @message

Name: `message`  
Parameters:
- Error message
- Processed expression

The meta expression `@errorMessage` replaces parsing error of the child expression with specified error message.  

Example:

```
@message(0, 'Expected 4 digit hex number', HexNumber_)
```

### @list

Name: `@list`  
Parameters:
- An expression representing the `first` element.
- An expression representing the `next` element(s).

The meta expression `@list` parses zero or more occurrences of the `first` and  `next` elements and returns a list of elements as a result.

Example:

```
Elements = @list1(Element, Separator ↑ v:Element) ;
```

Grammar optimization is achieved by reducing grammar expressions. Optimization of the generated code is achieved by reducing array creation operations.  
As a result, the grammar becomes more readable, and the generated parser code works more efficiently.

### @list1

Name: `@list1`  
Parameters:
- An expression representing the `first` element.
- An expression representing the `next` element(s).

The meta expression `@list1` parses one or more occurrences of the `first` and  `next` elements and returns a list of elements as a result.

Example:

```
Elements = @list1(Element, Separator ↑ v:Element) ;
```

Grammar optimization is achieved by reducing grammar expressions. Optimization of the generated code is achieved by reducing array creation operations.  
As a result, the grammar becomes more readable, and the generated parser code works more efficiently.

### @message

Name: `message`  
Parameters:
- Error message
- Processed expression

The meta expression `@message` replaces parsing error of the child expression with specified error message.

Example:

```
@message('Expected 4 digit hex number', HexNumber_)
```

### @stringChars

Name: `stringChars`  
Parameters:
- An expression representing an `normalCharacters`
- An expression representing an `escapeCharacter`
- An expression representing an `escape`

⚠️ **Important information:**  
The expressions `normalCharacters` and `escape` must have a result type of `String`.

The `@stringChars` meta expression is intended to add the ability to efficiently parse string characters.  
The term `string characters` in this case refers to the characters enclosed in quotation marks in string literals.  

Example:

```
StringChars = @stringChars(
    $[\u{20}-\u{21}\u{23}-\u{5b}\u{5d}-\u{10ffff}]+,
    [\\],
    (EscapeChar / EscapeHex)
  ) ;

String = '"' v:StringChars Quote ;
```

This was an example of an optimized version of the following implementation.

```
String
StringChars =
    $[\u{20}-\u{21}\u{23}-\u{5b}\u{5d}-\u{10ffff}]+
  / [\\] v:(EscapeChar / EscapeHex) ;

String
String = '"' v:StringChars* Quote { $$ = v.join(); } ;
```

### @tag

Name: `@tag`  
Parameters:
- Literal value of `tag`
- Processed expression

The meta expression `@tag` replaces parsing error of the child expression with an error that displays a message that the specified tag is expected.

Example:

```
@tag('FOR', $([Ff] [Oo] [Rr]))
```

Example of error output:

```
FormatException: line 1, column 1 (offset 0): Expected: 'FOR'
Fo
^
```

### @verify

Name: `@verify`  
Parameters:
- Error message
- Processed expression
- Predicate

The meta expression `@verify` is intended to support the implementation of certain functions of context-sensitive grammars.  
Despite the fact that this meta expression looks at first glance as dependent on the processed expression, nevertheless it can also be used as an independent expression, in the case of using the processed expression, which always succeeds.  
What is the meaning of the above statement?  
As follows from the name of the specified meta expression, it verifies the result of the processed expression.  
If the processed expression fails, the verifier handler is not executed.  
If the processed expression succeeds, then the verifier handler performs two functions:  
- Verifies the value of the result of the processed expression
- Either does nothing, or generates an error based on the verification results

This meta expression allows you to simply solve the problems that arise when creating context-dependent grammars.  
It is recommended to use an empty `Literal` as an expression that always succeeds.  
At the same time, any available data can be used as verification data (for example, user settings of the parser implemented by the developer).

Example of result verification:

```
Verify41 = @verify('Not a lucky number', SomeNumber, { $$ == 41 }) ;
```

Example of parser configuration verification:

```
VerifyFlag = @verify('Some error', SomeExpression, { flag }) ;
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
Although the generator might infer the type of this expression as `List<String>`, it will return a value with the value `List<Object?>`. This is the current design and, in this case, this was done intentionally.


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

The return value type is `({String a, String b})`, the value is `(a: 'abc', b: 'def')`.

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

## Streaming parsing

The term `streaming parsing` means the possibility of asynchronous data parsing.  
The term `asynchronous parsing` means the possibility of parsing data by chunks.  
The term `chunked parsing` means parsing data in chunks as those data chunks become available.  

Generating a stream parser requires specifying the `async` command line tool option.  

Example.

```bash
dart pub global run peg --async example/json.peg
```

In order for stream parsing to work and to work effectively requires adding the expression(s) `cut` to the grammar.  
Expressions `cut`(`↑`) very quickly inform the input data buffer that, starting from the specified (current) position, the input data will no longer be needed for parsing and can be removed from the buffer during the next operation to `clean` the buffer from unnecessary data.  
Such expressions can be called `markers` if they are used solely for buffer clearing purposes.  
Where and how many such markers need to be specified in the grammar for asynchronous parsing to work effectively is determined by the grammar developer.  

But they should be used wisely and should not be overused.  

Some examples of good and suitable places to use them.  
In all cases. Unloading the buffer and generating correct error messages.

```
Values = @sepBy(Value, Comma ↑) ;
```

In case of asynchronous parsing (to unload the buffer).

```
Array = OpenBracket ↑ v:Values CloseBracket ;

KeyValue = k:Key Colon ↑ v:Value { $$ = MapEntry(k, v); };

Object = OpenBrace ↑ kv:KeyValues CloseBrace { $$ = kv.isEmpty ? const {} : Map.fromEntries(kv); };

String = '"' ↑ v:StringChars Quote ;
```

That is, use them, if possible, inside data structures delimited by opening and closing tags immediately after the opening tag. Implementing this approach works very effectively.

## Code snippets

`CheckCondition`

```
CheckCondition = @verify('', { if (!condition) { error = ErrorMessage(0, 'error'); } }) ;
```
___

`Eof`

```
Eof = @eof() ;
```
___

`Expected`

```
Digits = @expected('digits', [0-9]+) ;
```
___

`MatchConfigurableChar`

```
TextChar = @verify([^"\n\r], { if ($$ == _separatorChar) { error = const ErrorUnexpectedCharacter(); } }) ;
```
___

`MatchConfigurableLiteral`

```
Separator = @matchString({ mySeparator }) ;
```
___

`Position`

```
int
Position = '' { $$ = state.pos; } ;
```
___

`SeparatedList`

```
SeparatedList = @list(Elem, Sep ↑ v:Elem) ;
```
___

`SeparatedList1`

```
SeparatedList1 = @list1(Elem, Sep ↑ v:Elem) ;
```
___

`SeparatedPair`

```
SeparatedPair = k:Key Sep ↑ v:Value ;
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

`Value`

```
int
Value = '' { $$ = 41; };
```
___

`Verify`

```
Verify = @verify(Integer, { if ($$ > 0xff) { error = ErrorMessage(state.pos - pos, 'Some error message'); } } );
```
___

Case insensitive tag

```
For = @tag('FOR', $([Ff] [Oo] [Rr]));
```

## Examples of parsers

List of parser examples:  
[CSV parser](https://github.com/mezoni/peg/blob/main/example/csv.peg)  
[Calc parser](https://github.com/mezoni/peg/blob/main/example/calc.peg)  
[JSON parser](https://github.com/mezoni/peg/blob/main/example/json.peg)  

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

Name: `tryParse`  
Purpose: Calls the specified parse function on the specified input source and returns a `ParseResult` value.

Usage example:

```dart
   const source = '1 + 2 * 3';
   final parser = CalcParser();
   final result = tryParse(parser.parseSpaces, source);
```

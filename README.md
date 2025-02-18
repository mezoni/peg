# peg

Command line tool for generating a PEG (with some syntactic sugar) parsers

Version: 8.1.0

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

## Structure of the grammar definition file

This generator generates itself from a grammar written using its own syntax.  
For a more detailed familiarization with the syntax, it is recommended to familiarize yourself with the syntax of the grammar used to generate this PEG parser.  
[peg.peg](https://github.com/mezoni/peg/blob/main/lib/src/peg_parser/peg.peg)

Grammar declaration is made using sections, like sections for a preprocessor, but at the same time, it should be noted that preprocessing is not performed and grammar processing (parsing) occurs in one stage.  

3 sections are used to declare the grammar:

- Section for declaring directives and global members
- Section for declaring members of instances of the parser class
- Section for declaring grammar rules

Example of a grammar declaration:

```text
%{

import 'foo.dart';

}%

%%

const SimpleParser();

%%

A => [A-Za-z]*

```

The grammar must contain at least one production rule, which means that using a section to declare grammar rules is mandatory. The use of other sections is optional and is determined by the actual needs based on the chosen method of declaring the grammar.

## Parsing expression grammar

In computer science, a parsing expression grammar (PEG) is a type of analytic formal grammar, i.e. it describes a formal language in terms of a set of rules for recognizing strings in the language.  
This information is from the Wikipedia website.  
[Parsing expression grammar](https://en.wikipedia.org/wiki/Parsing_expression_grammar)  

Everything that can be found on the Wikipedia website will not be described in detail here.  
Here will described only the additional features, the ways of their use and the implementation details.  

More detailed information can also be found on the Bryan Ford website.
[Parsing Expression Grammars: A Recognition-Based Syntactic Foundation](https://bford.info/pub/lang/peg/)

## Main characteristics

Main characteristics:

- Small size of runtime source code
- Small size of the source code of generated parsers
- Efficient built-in runtime parsing methods
- Performance optimized source code of generated parsers
- Automatic generation of standard errors
- Declarative way of describing additional errors
- Additional useful features, including the use of syntactic sugar

Creating a parser using PEG is very simple.  
There is no need to use tokenization.  
The PEG grammar definition is a combination of parsing expressions (similar to regular expressions), production rules, and regular Dart code.  

### Available examples

A trivial implementation of the formula evaluator (calculator):  
Grammar definition: [calc.peg](https://github.com/mezoni/peg/blob/main/example/calc.peg)  
Generated code: [example.dart](https://github.com/mezoni/peg/blob/main/example/example.dart)  
DartPad example: [https://dartpad.dev/?id=d720a249b378462ba36490956213225c](https://dartpad.dev/?id=d720a249b378462ba36490956213225c)

The same formula evaluator, but a little faster:  
Grammar definition:  [realtime_calc.peg](https://github.com/mezoni/peg/blob/main/example/realtime_calc.peg)  
Generated code: [realtime_calc.dart](https://github.com/mezoni/peg/blob/main/example/realtime_calc.dart)

Mathematical formula evaluator with support for variables and functions:  
This example was written in about 30 minutes, based on the code from the calculator example.  
Grammar definition:  [math.peg](https://github.com/mezoni/peg/blob/main/example/math.peg)  
Generated code: [math_parser.dart](https://github.com/mezoni/peg/blob/main/example/math_parser.dart)  
DartPad example: [https://dartpad.dev/?id=fa7cbeb8dec40ad043937a09523141d3](https://dartpad.dev/?id=fa7cbeb8dec40ad043937a09523141d3)

A number parser and an example of how to examine the generated error messages:  
Grammar definition: [number.peg](https://github.com/mezoni/peg/blob/main/example/number.peg)  
Generated code: [number.dart](https://github.com/mezoni/peg/blob/main/example/number.dart)

## Automatic error generation

Automatic error generation occurs when parsing the following grammar elements:

- The `literal` expression with `single quotes`
- Production rule that specifies the name of a `grammar element`

These grammar elements generate the errors `expected` and `unexpected`, if they are parsed with the parent expression `not predicate`.

These elements cover most of the needs for standard error messages.

The literal expression with `double quotes` is the opposite of literal with `single quotes`.  
It performs the same operations, but silently (without generating errors).  
This is very convenient when the `expected` or `unexpected` error is out of place and even incorrect.  

The most common and simple example when it is 100% necessary:

- `"\r\n"`

Because it is unlikely that a grammar element with such a name `'\r\n'` and action (`line break`) is `expected`, if it is parsed as `white space`.

The literal expression with `double quotes`and the expression `character class` can be considered `primitive` `terminal` expressions. They only signal with `failures` in case of unsuccessful parsing.

### What can be done to ensure that more errors are generated automatically?

The main recommendation is that the expression single quoted `literal` expression **must always** be used for punctuation marks.  
Do not use `primitive terminals` for these purposes under any circumstances.  
Wrong use: `[,]`, `[(]`, `":"`, `";"` etc.

Punctuation marks may include the following types (as an example):

- Separators `:`, `,`,  `|`
- Terminators `;`
- Opening and closing marks `{`, `}`, `[`, `]`, `{`, `}`,
- Surrounding marks `"`, `'`

Not recommended for use with `operators` because they are not expected.  
Good use: [+] [*] "~/" "??"

The following example demonstrates the use of the `operand` and `separator`:

```text
BooleanExpression "?" S Expression ':' S Expression
```

In this case, the `separator` is always an expected element of the grammar.

When developing a parser, it is always possible to examine what errors the parser produces.  
And make adjustments to grammar if necessary.  
Because the grammar that parses expressions is not unambiguous and it does not know the purpose of certain elements.  

By following these principles, you can ensure that error messages are of sufficient quality.  

## Declarative way of generating errors

To generate additional errors, to increase the amount of information about the causes of failures, there is a declarative way to specify when, where and how to generate errors.  
It allows to generate errors with any messages.  

The point of this method is that the error handler description specifies the parameters for generating an error.  
For these purposes, the expression `Catch` is used, which will be described below in the corresponding section.  

Below is a list of error parameters:

- `message`
- `origin`
- `start`
- `end`

The `message` parameter specifies the text of the error message.

Example:

```text
Expression Sequence
~ { message = 'Some error message' }
```

The `origin` parameter specifies the condition under which the error will be generated.  
There are two conditions:

- `== start`
- `!= start`

That is, this condition specifies where the failure should occur so that the error was generated, in the `starting` position or further than the `starting` position.  
If the `origin` parameter is not specified, the error will be generated regardless of where the failure occurred.

Example:

```text
Expression Sequence
~ { message = 'Malformed element' origin != start }
```

The `start` and `end` parameters specify what information about the error location will be registered.  
These parameters determine what portion of the input data will be displayed in the error message.  
There are two values for both parameters:

- `start`
- `end`

Essentially, this is information about the location where the error occurred (`source span` or simply `location`).  
By default, the `source span` is registered. That is, `start` = `start`, `end` = `end`.  
If an invalid combination of values ​​is specified, default values ​​will be applied.  

Example:

```text
Expression Sequence
~ { message = 'Message at the end of the failure position' start = end }
```

```text
Foo
  ^
```

```text
Expression Sequence
~ { message = 'Message at the start of the failure position' end = start }
```

```text
Foo
^
```

```text
Expression Sequence
~ { message = 'Message with source span' }
```

```text
Foo
^^^
```

## Additional features

This implementation adds additional features.  
Below is a short list of additional features:

- Action expression
- Predicate expression
- Match expression
- Catch expression (error handler)
- Sematic variable
- Special semantic result variable `$`
- Modified character class
- Typing expression
- Syntactic sugar

Some small and simple examples of additional features.

### Action expression

The expression `Action` allow to execute any code and are mainly used for computing and assigning the result of parsing.  
Syntax: `{` block of statements `}`

```text
`bool`
Boolean('boolean') =>
  $ = { $$ = false; }
  ('false' / 'true' { $ = true; })
  S
```

This example demonstrates the use of 2 blocks of source code.

```text
{ $$ = false; }
```

```text
{ $ = true; }
```

This is the regular source code that will be embedded into the parser code.

### Predicate expressions

The expression `Predicate` allow to determining the success or failure of the parsing based on the value of the specified boolean expression.  
Syntax: `&{` boolean expression `}` or `!{` boolean expression `}`

Example:

```text
Rule =>
  Expr1
  ! { state.position == position }
  Expr2
```

This expression will fail if the result of the expression `state.position == position` will be evaluated as `true`.

### Match expressions

The `Match` expression returns a string value of the data source that matches the recognized expression.  
Syntax: `<` recognition expression `>`

```text
Type('type') =>
  '`'
  $ = <
    @while (*) {
      ! [`] [a-zA-Z0-9_$<({,:})>? ]
    }
  >
  '`' S
```

### Catch expressions (error handlers)

The `Catch`expression allows to generate errors when parsing fails in preceding expressions.  
The `Catch` expression allows to specify when, where, and how to generate errors based on the specified parameters.  
The description of the parameters is given above in the text.  
Syntax: sequence expression `~ {` error parameters `}`

Example:

```text
A B C ~ { message = 'foo' } D E ~ { message = 'baz' } F
```

This expression will be executed as follows:

```text
(((A B C ~ { message = 'foo' }) D E ~ { message = 'baz' }) F)
```

### Sematic variables

Semantic variables allow to assign the results of expressions to variables for later use.  
Syntax: `n:`Expression or `n =` Expression

```text
`Expression`
Action =>
  b = Block
  $ = { $$ = ActionExpression(code: b); }
```

### Special semantic result variable `$`

Special semantic result variable `$` allow to assign the results of expressions.

Below is an example of what the result of the sequence expression will be.

```text
# B
A = B

# B
A = b:B

# No result
A = B C

# No result
A = b:B C

# No result
A = B c:C

# No result
A = b:B c:C

# $
A = $:B c:C

# $
A = b:B $:C
```

If a special semantic result variable `$` is used, the value of this variable will be used as the result.

### Modified character class

The modified `Character class` expression allows for more readable character range specifications and inverting ranges (negation).
Syntax: `[` ranges `]` or `[^` ranges `]`

The `negated` character class `[^]` is equivalent to the following sequence of expressions but much more faster:

```text
! [unexpected characters]
$ = .
```

Additional features:

```text
[^0-9]

[{20-21}{23-5b}{5d-10ffff}]

[\u{20}-\u{21}\u{23}-\u{5b}\u{5d}-\u{10ffff}]
```

### Typing expression

The expression `Typing` allows you to explicitly specify the type of the expression's result.  
Syntax:  `Type` expression

Example:

```text
`Type` n = { $$ = 41; }

`Type` { $$ = 41; }

`num` result = { $$ = num.parse(integer); }
```

This expression can be useful for subexpressions, to explicitly specify the type.

### Syntactic sugar

The `@while` expressions is syntactic sugar:

- `@while(*)` `{` e `}` it is syntactic sugar for e`*`
- `@while(+)` `{` e `}` it is syntactic sugar for e`+`

```text
`List<Object?>`
Values =>
  e = Value
  { final l = [e]; }
  @while (*) {
    ',' S
    e = Value
    { l.add(e); }
  }
  $ = { $$ = l; }
```

The `-` operator is syntactic sugar for the operator `/`  
The `-` character can be repeated as many times as necessary.

```text
`Expression`
Assignment =>
  v = (Identifier / $ = '$' S)
  ('=' S / ':' S)
  e = Prefix
  $ = { $$ = VariableExpression(expression: e, name: v); }
  ----
  Prefix
```

```text
`Expression`
Suffix =>
  $ = Primary
  (
    '*' S { $ = ZeroOrMoreExpression(expression: $); }
    ----
    '+' S { $ = OneOrMoreExpression(expression: $); }
    ----
    '?' S { $ = OptionalExpression(expression: $); }
  )?
```

## How to parse?

An example of how parsing can be implemented.

```dart
Expression? parse(String source) {
  final parser = MyParser();
  final state = State(source);
  final result = parser.parseStart(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result .$1;
}
```

This requires the use of the `source_span` package.  
This method can be generated automatically by specifying the "parse" command line option.  

Example

```bash
 dart pub global run peg bin/scanner.peg --parse=parse
```

If it is not desirable to use third-party libraries, then it can be done this way (using only `FormatException`).

```dart
Expression? parse(String source) {
  final parser = MyParser();
  final state = State(source);
  final result = parser.parseStart(state);
  if (result == null) {
    final messages = <String>[];
    for (final error in state.getErrors()) {
      final message = error.message;
      final start = error.start;
      final exception = FormatException(message, source, start);
      messages.add('$exception'.substring('FormatException'.length));
    }

    throw FormatException(messages.join('\n\n'));
  }

  return result .$1;
}
```

Unfortunately `FormatException` only support `offset` and this does not allow the use of `start` and  `end` at the same time.  
Perhaps in the future the Dart SDK developers will improve this method a little by adding the `end` parameter. Such care for Dart SDK users would be invaluable.

## Example of a simple calculator

```text
%{
// ignore_for_file: prefer_conditional_assignment, prefer_final_locals

import 'package:source_span/source_span.dart';

void main() {
  const source = ' 1 + 2 * 3 + x ';
  final result = calc(source, {'x': 5});
  print(result);
}

int calc(String source, Map<String, int> vars) {
  final parser = CalcParser(vars);
  final state = State(source);
  final result = parser.parseStart(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result.$1;
}

}%

%%

Map<String, int> vars = {};

CalcParser(this.vars);

%%

`int`
Start =>
  S
  $ = Expr
  EOF

`int`
Expr('expression') =>
  Sum

`int`
Sum =>
  $ = Product
  @while (*) {
    [+] S
    r = Product
    { $ += r; }
    ----
    [-] S
    r = Product
    { $ -= r; }
  }

`int`
Product =>
  $ = Value
  @while (*) {
    [*] S
    r = Value
    { $ *= r; }
    ----
    [/] S
    r = Value
    { $ ~/= r; }
  }

`int`
Value('expression') => (
  NUMBER
  ----
  i = ID
  $ = { $$ = vars[i]!; }
  ----
  '(' S
  $ = Expr
  ')' S
)

`int`
NUMBER =>
  n = <[0-9]+>
  S
  $ = { $$ = int.parse(n); }

`String`
ID =>
  $ = <[a-zA-Z]>
  S

`void`
EOF('end of file') =>
  ! .

`void`
S => [ \t\r\n]*

```

## Errors when generating a parser from a grammar

When developing grammar, mistakes are inevitable.  
To minimize errors, the parser generator analyzes the grammar for errors.  
Errors can be of the following kinds:

- Syntax error
- Errors in determining the type of the expression result
- Errors when there are no rules to which references are given
- Type mismatch errors in source code

### Syntax error

This type of error is occurred when the syntax is not followed. To correct it, it is required to follow the syntax.

### Errors in determining the type of the expression result

In certain cases, the grammar analyzer can determine the type of an expression or production rule.  
But this is not possible in all cases.  

There are several cases when this cannot be done:

- Expression `Action`: always
- Expression `Ordered choice`: alternatives have different types

If the result value is not specified, the default value is `void`.

All this needs to be corrected.  

If this happens for some other reason, then it is required to solve it in a radical way, by explicitly specifying the return type for the production rule.  

Example:

```text
`RuleType`
Rule => Expr
```

The easiest way is to specify types for all problematic `rules` for which the type is not determined automatically.  
But this can be done a little more complicated, but more correctly.  
Start specifying types for those rules on which the types of other rules depend.  
That is, from the bottom up.  

But if you don't want to do this, then just specify all the types of rules that are not defined (and not determined) manually.

### Errors when there are no rules to which references are given

This indicates that such a rule does not exist or the rule name is misspelled.

### Type mismatch errors in source code

This means that either the result type was not determined automatically, or it was specified manually incorrectly.

## Generating a parser programmatically

Generating a parser programmatically is possible, but it is not recommended.  
Only in exceptional cases. For example, for testing purposes.  
It is not recommended to include this package in the list of `dependencies`.  
It is acceptable to include this package in the list of `dev_dependencies`.

Below is an example of how this can be done.

```dart
import 'dart:io';

import 'package:peg/src/parser_generator.dart';

void main(List<String> args) {
  final parsers = [
    (
      'example/calc.peg',
      'example/example.dart',
      ParserGeneratorOptions(
        name: 'CalcParser',
      ),
    ),
    (
      'example/realtime_calc.peg',
      'example/realtime_calc.dart',
      ParserGeneratorOptions(
        name: 'CalcParser',
      ),
    ),
    (
      'example/number.peg',
      'example/number.dart',
      ParserGeneratorOptions(
        name: 'NumberParser',
        parseFunction: 'parse',
      ),
    ),
  ];
  final outputFiles = <String>[];
  for (final parser in parsers) {
    final inputFile = parser.$1;
    final outputFile = parser.$2;
    final options = parser.$3;
    final source = File(inputFile).readAsStringSync();
    final generator = ParserGenerator(
      options: options,
      source: source,
    );
    final result = generator.generate();
    final diagnostics = generator.diagnostics;
    for (final error in diagnostics.errors) {
      print('$error\n');
    }

    for (final warning in diagnostics.warnings) {
      print('$warning\n');
    }

    if (diagnostics.hasErrors) {
      exit(-1);
    }

    outputFiles.add(outputFile);
    File(outputFile).writeAsStringSync(result);
  }

  Process.runSync(Platform.executable, ['format', ...outputFiles]);
}

```

## Is it possible to parse from files?

Yes, it is possible.  
The generated parser does not use direct access to the input data.  
Access to data is provided through members of class `State`.  
List of these members:

- `advance`
- `match`
- `peek`
- `startsWith`
- `substring`

Thus, by creating a new class that extends the `State` class and overwriting these methods, it is possible to perform the parsing from the file.

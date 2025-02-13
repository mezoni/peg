# peg

Command line tool for generating a PEG (with some syntactic sugar) parsers

Version: 7.0.5

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
- Additional useful features, including the use of syntactic sugar

## Automatic and programmatic error generation

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

To generate errors programmatically, to improve the informativeness there is a method `error` in the class `State`.  
It allows to generate errors with any messages.  
There is also the `malformed` method. It does nothing special or just checks the position of the failure before generating an error. If an error occurs at a position further the starting parsing position, this method calls the `error` method, otherwise it does nothing.

It is equivalent to the following code:

```dart
if (state.failure > state.position) {
  state.error(message);
}
```

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

Below is an example of how to examine the behavior of the parser in the case where parsing fails.

```dart
import 'package:source_span/source_span.dart';

import 'example.dart';

void main(List<String> args) {
  final strings = ['', '1`', '1+', '(1+', '(1'];
  for (final element in strings) {
    print('Input: \'$element\'');
    print('-' * 40);
    try {
      parse(element);
    } catch (e) {
      print(e);
      print('=' * 40);
    }
  }
}

int parse(String source) {
  final parser = CalcParser(const {});
  final state = State(source);
  final result = parser.parseStart(state);
  if (result == null) {
    final file = SourceFile.fromString(source);
    throw FormatException(state
        .getErrors()
        .map((e) => file.span(e.start, e.end).message(e.message))
        .join('\n'));
  }

  return result as int;
}

```

```text
Input: ''
----------------------------------------
FormatException: line 1, column 1: Expected: 'expression'
  ╷
1 │ 
  │ ^
  ╵
========================================
Input: '1`'
----------------------------------------
FormatException: line 1, column 2: Expected: 'end of file'
  ╷
1 │ 1`
  │  ^
  ╵
========================================
Input: '1+'
----------------------------------------
FormatException: line 1, column 3: Expected: 'expression'
  ╷
1 │ 1+
  │   ^
  ╵
========================================
Input: '(1+'
----------------------------------------
FormatException: line 1, column 4: Expected: 'expression'
  ╷
1 │ (1+
  │    ^
  ╵
========================================
Input: '(1'
----------------------------------------
FormatException: line 1, column 3: Expected: ')'
  ╷
1 │ (1
  │   ^
  ╵
========================================
```

Another example:

```text
Start =>
  $ = Number
  ! .

`void`
Decimal('decimal digit') =>
  [0-9]+

`num`
Number('number') =>
  { var pos = 0; var isFatal = false; }
  n = <
    [-]?
    [0] / ([1-9] [0-9]*)
    { pos = state.position; }
    (
      [.]
      Decimal
      ~ { state.malformed('Malformed fraction'); isFatal = true; }
    )?
    (
      [eE]
      [-+]
      Decimal
      ~ { state.malformed('Malformed exponent'); isFatal = true; }
    )?
    &{ !isFatal }
  >
  $ = {
    final isInt = pos == state.position;
    $$ = isInt ? int.parse(n) : num.parse(n);
  }
  ~ { state.malformed("Malformed 'number'"); }
```

Error messages:

```text
Input: ''
----------------------------------------
FormatException: line 1, column 1: Expected: 'number'
  ╷
1 │ 
  │ ^
  ╵
========================================
Input: '-'
----------------------------------------
FormatException: line 1, column 1: Malformed 'number'
  ╷
1 │ -
  │ ^
  ╵
========================================
Input: '01'
----------------------------------------
FormatException: line 1, column 2: Unexpected input data
  ╷
1 │ 01
  │  ^
  ╵
========================================
Input: '1.'
----------------------------------------
FormatException: line 1, column 2: Malformed fraction
  ╷
1 │ 1.
  │  ^
  ╵
line 1, column 1: Malformed 'number'
  ╷
1 │ 1.
  │ ^^
  ╵
line 1, column 3: Expected: 'decimal digit'
  ╷
1 │ 1.
  │   ^
  ╵
========================================
Input: '1.0e'
----------------------------------------
FormatException: line 1, column 4: Malformed exponent
  ╷
1 │ 1.0e
  │    ^
  ╵
line 1, column 1: Malformed 'number'
  ╷
1 │ 1.0e
  │ ^^^^
  ╵
========================================
Input: '1.0e+'
----------------------------------------
FormatException: line 1, column 4: Malformed exponent
  ╷
1 │ 1.0e+
  │    ^^
  ╵
line 1, column 1: Malformed 'number'
  ╷
1 │ 1.0e+
  │ ^^^^^
  ╵
line 1, column 6: Expected: 'decimal digit'
  ╷
1 │ 1.0e+
  │      ^
  ╵
========================================
```

By following these principles, you can ensure that error messages are of sufficient quality.  

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

The `Catch` expression allows arbitrary code to be executed if one of the preceding expressions was not successfully parsed.  
The main purpose is to register errors.  
Syntax: sequence expression `~ {` error handler `}`

Example:

```text
[eE]
[-+]
Decimal
~ { state.malformed('Malformed exponent'); }
```

How it works?  
Example:

```text
A B C ~ { handler1 } D E ~ { handler2 } F
```

This expression will be executed as follows:

```text
(((A B C ~ { handler1 }) D E ~ { handler2 }) F)
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

The `-` expression is syntactic sugar for `/`  
The `-` character can be repeated as many times as necessary.

```text
`Expression`
Assignment =>
  i = (Identifier / n:'$' S)
  ('=' S / ':' S)
  e = Prefix
  $ = { $$ = e..semanticVariable = i; }
  -------------------------------------
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
If it is not desirable to use third-party libraries, then it can be done this way.

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

But if you don't want to do this, then just specify all the types of rules that are not defined (and nit determined) manually.

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
  final files = [
    ('example/calc.peg', 'example/example.dart', 'CalcParser'),
    ('example/realtime_calc.peg', 'example/realtime_calc.dart', 'CalcParser'),
  ];
  final outputFiles = <String>[];
  for (final element in files) {
    final inputFile = element.$1;
    final outputFile = element.$2;
    final name = element.$3;
    final source = File(inputFile).readAsStringSync();
    final options = ParserGeneratorOptions(
      addComments: false,
      name: name,
    );
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
List of these methods:

- `nextChar16`
- `nextChar32`
- `substring`

Thus, by creating a new class that extends the `State` class and overwriting these methods, it is possible to perform the parsing from the file.

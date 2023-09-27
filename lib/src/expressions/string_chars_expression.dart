import '../visitors/visitors.dart';
import 'expression.dart';

class StringCharsExpression extends MultipleExpression {
  final Expression escape;

  final Expression escapeCharacter;

  final Expression normalCharacters;

  StringCharsExpression({
    required this.escapeCharacter,
    required this.escape,
    required this.normalCharacters,
  }) : super(expressions: [normalCharacters, escapeCharacter, escape]);

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitStringChars(this);
  }

  @override
  String toString() {
    return '@stringChars(${expressions.join(', ')})';
  }
}

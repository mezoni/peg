class ParserGeneratorOptions {
  final bool addComments;

  final String name;

  final String? parseFunction;

  ParserGeneratorOptions({
    required this.name,
    this.addComments = false,
    this.parseFunction,
  });
}

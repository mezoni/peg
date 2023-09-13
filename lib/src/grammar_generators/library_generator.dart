import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import 'class_generator.dart';
import 'runtime_generator.dart';

class LibraryGenerator {
  static const _template = '''
{{globals}}

{{parserClass}}

{{runtime}}''';

  final String className;

  final String filename;

  final Grammar grammar;

  LibraryGenerator({
    required this.className,
    required this.filename,
    required this.grammar,
  });

  String generate() {
    final values = <String, String>{};
    values['globals'] = grammar.globals ?? '';
    final classGenerator = ClassGenerator(
      className: className,
      grammar: grammar,
    );
    values['parserClass'] = classGenerator.generate();
    final runtimeGenerator = RuntimeGenerator();
    values['runtime'] = runtimeGenerator.generate();
    return helper.render(_template, values);
  }
}

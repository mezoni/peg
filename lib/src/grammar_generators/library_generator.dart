import '../grammar/grammar.dart';
import '../helper.dart' as helper;
import 'class_generator.dart';
import 'events_generator.dart';
import 'runtime_generator.dart';

class LibraryGenerator {
  static const _template = '''
{{globals}}

{{parser_class}}

{{parser_events_enum}}

{{runtime}}''';

  final String filename;

  final Grammar grammar;

  final String parserName;

  LibraryGenerator({
    required this.filename,
    required this.grammar,
    required this.parserName,
  });

  String generate() {
    final values = <String, String>{};
    values['globals'] = grammar.globals ?? '';
    final classGenerator = ClassGenerator(
      parserName: parserName,
      grammar: grammar,
    );
    values['parser_class'] = classGenerator.generate();
    final eventsGenerator =
        EventsGenerator(grammar: grammar, parserName: parserName);
    values['parser_events_enum'] = eventsGenerator.generate();
    final runtimeGenerator = RuntimeGenerator();
    values['runtime'] = runtimeGenerator.generate();
    return helper.render(_template, values);
  }
}

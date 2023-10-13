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

  final bool addRuntime;

  final String filename;

  final Grammar grammar;

  final bool isAsync;

  final String parserName;

  LibraryGenerator({
    required this.addRuntime,
    required this.filename,
    required this.isAsync,
    required this.grammar,
    required this.parserName,
  });

  String generate() {
    final values = <String, String>{};
    values['globals'] = grammar.globals ?? '';
    final classGenerator = ClassGenerator(
      grammar: grammar,
      isAsync: isAsync,
      parserName: parserName,
    );
    values['parser_class'] = classGenerator.generate();
    final eventsGenerator =
        EventsGenerator(grammar: grammar, parserName: parserName);
    values['parser_events_enum'] = eventsGenerator.generate();
    if (addRuntime) {
      final runtimeGenerator = RuntimeGenerator();
      values['runtime'] = runtimeGenerator.generate();
    } else {
      values['runtime'] = '';
    }

    return helper.render(_template, values, removeEmptyLines: false);
  }
}

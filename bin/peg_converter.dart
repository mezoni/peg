// This code was generated by the tool, do not modify it manually
// https://pub.dev/packages/peg

import 'dart:convert';

import 'peg_parser.dart';

export 'peg_parser.dart';

/// The [PegConverter] converts data to [Grammar] value.
///
/// If event-based parsing is required, then the corresponding parser instance
/// (with event handlers) must be passed as a constructor argument.
class PegConverter with Converter<String, Grammar> {
  final PegParser _parser;

  PegConverter({
    PegParser? parser,
  }) : _parser = parser ?? PegParser();

  @override
  Grammar convert(String input) {
    final result = parseString(_parser.parseStart, input);
    return result;
  }
}
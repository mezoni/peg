import '../example/example.dart' as example_example;
import '../example/json_example.dart' as example_json_example;
import '../example/math_parser.dart' as example_math_parser;
import '../example/number.dart' as example_number;
import '../example/realtime_calc.dart' as example_realtime_calc;
import '../test/examine_errors.dart' as test_examine_errors;
import '../test/test.dart' as test_test;
import '../test/test_branch.dart' as test_test_branch;

void main(List<String> args) {
  example_example.main();
  example_json_example.main([]);
  example_math_parser.main();
  example_number.main();
  example_realtime_calc.main();
  test_examine_errors.main([]);
  test_test.main();
  test_test_branch.main();
}

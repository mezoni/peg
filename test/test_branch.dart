import 'package:peg/src/expressions/code_gen.dart';
import 'package:test/test.dart';

void main() {
  group('Branch', () {
    test('true', () {
      const test = 'true';
      {
        final branch = Branch(test, '');
        _test(branch, '');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        _test(branch, '1');
      }

      {
        final branch = Branch(test, '');
        branch.falsity.block((b) => b.write('2'));
        _test(branch, 'if(false){2}');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        branch.falsity.block((b) => b.write('2'));
        _test(branch, 'if(true){1}else{2}');
      }
    });

    test('false', () {
      const test = 'false';
      {
        final branch = Branch(test, '');
        _test(branch, '');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        _test(branch, 'if(false){1}');
      }

      {
        final branch = Branch(test, '');
        branch.falsity.block((b) => b.write('2'));
        _test(branch, '2');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        branch.falsity.block((b) => b.write('2'));
        _test(branch, 'if(true){2}else{1}');
      }
    });

    test('x', () {
      const test = 'x';
      {
        final branch = Branch(test, '');
        _test(branch, '');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        _test(branch, 'if(x){1}');
      }

      {
        final branch = Branch(test, '');
        branch.falsity.block((b) => b.write('2'));
        _test(branch, 'if(!x){2}');
      }

      {
        final branch = Branch(test, '');
        branch.truth.block((b) => b.write('1'));
        branch.falsity.block((b) => b.write('2'));
        _test(branch, 'if(x){1}else{2}');
      }
    });

    for (final pairs in const [
      ('!=', '=='),
    ]) {
      for (final pair in [(pairs.$1, pairs.$2), (pairs.$2, pairs.$1)]) {
        final op = pair.$1;
        final negated = pair.$2;
        test(op, () {
          final test = '1${op}2';
          {
            final branch = Branch(test, '');
            _test(branch, '');
          }

          {
            final branch = Branch(test, '');
            branch.truth.block((b) => b.write('1'));
            _test(branch, 'if(1${op}2){1}');
          }

          {
            final branch = Branch(test, '');
            branch.falsity.block((b) => b.write('2'));
            _test(branch, 'if(1${negated}2){2}');
          }

          {
            final branch = Branch(test, '');
            branch.truth.block((b) => b.write('1'));
            branch.falsity.block((b) => b.write('2'));
            _test(branch, 'if(1${op}2){1}else{2}');
          }
        });
      }
    }
  });
}

void _test(Branch branch, String expected) {
  final sink = StringBuffer();
  branch.generate(sink);
  var actual = '$sink';
  actual = actual.replaceAll(' ', '');
  actual = actual.replaceAll('\n', '');
  expect(actual, expected,
      reason:
          'Test: ${branch.ok}, truth code: ${branch.truth}, falsity code: ${branch.falsity}');
}

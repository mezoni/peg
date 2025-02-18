import '../helper.dart';
import 'build_context.dart';

class OrderedChoiceExpression extends MultiExpression {
  OrderedChoiceExpression({required super.expressions});

  @override
  T accept<T>(ExpressionVisitor<T> visitor) {
    return visitor.visitOrderedChoice(this);
  }

  @override
  String generate(BuildContext context, Variable? variable, bool isFast) {
    final sink = preprocess(context);
    if (expressions.length > 1) {
      if (variable != null) {
        if (variable.needDeclare) {
          if (variable.type.isEmpty) {
            variable.type = getReturnType();
          }

          variable.assign(sink, '');
        }
      } else {
        variable = context.allocateVariable(type: getReturnType());
        variable.assign(sink, '');
      }
    }

    context.addSharedValues(this, [Expression.position]);
    final blocks = <StringBuffer>[];
    for (var i = 0; i < expressions.length; i++) {
      final expression = expressions[i];
      final block = StringBuffer();
      blocks.add(block);
      context.shareValues(this, expression, [Expression.position]);
      block.writeln(expression.generate(context, variable, isFast));
    }

    var buffer = StringBuffer();
    for (var i = expressions.length - 1; i >= 0; i--) {
      final isFailure = getStateTest(variable, false);
      final block = blocks[i];
      if (i == expressions.length - 1) {
        buffer.write(block);
      } else {
        final inner = '$buffer';
        buffer = StringBuffer();
        buffer.writeln(block);
        var optimized = false;
        if (isFailure == '$variable == null') {
          if (i == expressions.length - 2) {
            var temp = inner.trim();
            if (temp.endsWith(';')) {
              if (inner.codeUnits.where((e) => e == 59).length == 1) {
                temp = temp.replaceAll(' ', '');
                temp = temp.replaceAll('\n', '');
                temp = temp.replaceAll('\r', '');
                temp = temp.replaceAll('\t', '');
                if (temp.startsWith('$variable=')) {
                  optimized = true;
                  final index = inner.indexOf('=');
                  buffer.writeln('$variable ??= ${inner.substring(index + 1)}');
                }
              }
            }
          }
        }

        if (optimized) {
          continue;
        }

        buffer.ifStatement(isFailure, (b) {
          b.writeln(inner);
        });
      }
    }

    sink.writeln(buffer);
    return postprocess(context, sink);
  }
}

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';
import 'package:dart_ast/util/logger.dart';

/// 运行时 class#method
/// 全局函数的执行体被包装在属性中[FunctionDeclaration.expression]
class AstMethod {
  static const String tag = "AstMethod";

  final MethodDeclaration node;

  ///
  AstMethod(this.node);

  /// 真正的执行方法
  ///
  Future executeExpression(AstStack stack, List params) {
    if (stack == null) stack = AstStack();
    stack.push();
    // Logger.out(tag, "node:${node.toJson()}");
    // 将传参和形参对应
    for (int i = 0; i < node.parameters.length; i++) {
      if (node.type == AstNodeType.MethodDeclaration) {
        stack.addMethod(node.parameters[i].name, params[i]);
      } else {
        stack.addVariable(node.parameters[i].name, params[i]);
      }
    }
    var result;
    for (BlockStatement statement in node.body) {
      result = _innerExecute(statement.expression, stack);
    }
    stack.pop();
    return result;
  }

  ///
  Future _innerExecute(Expression expression, AstStack stack) async {
    String type = expression.type;
    if (type == AstNodeType.BinaryExpression) {
      return await _executeBinary(expression, stack);
    } else if (type == AstNodeType.ReturnStatement) {
    } else if (type == AstNodeType.ExpressionStatement) {
      return await _executeStatement(expression, stack);
    } else if (type == AstNodeType.AssignmentExpression) {}
    return null;
  }

  ///
  dynamic _executeStatement(Expression expression, AstStack stack) {
    var rightHandSide = _executeBinary(expression.rightHandSide, stack);
    var leftHandSide = _executeBinary(expression.leftHandSide, stack);
    return _executeBinary(
      BinaryExpression(
        operator: expression.operator,
        left: leftHandSide,
        right: rightHandSide,
      ),
      stack,
    );
  }

  ///
  dynamic _executeBinary(BinaryExpression expression, AstStack stack) {
    var left = stack.get(expression.left.value);
    var right = stack.get(expression.right.value);
    //操作符
    switch (expression.operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        return left / right;
      case '<':
        return left < right;
      case '>':
        return left > right;
      case '<=':
        return left <= right;
      case '>=':
        return left >= right;
      case '==':
        return left == right;
      case '&&':
        return left && right;
      case '||':
        return left || right;
      case '%':
        return left % right;
      case '<<':
        return left << right;
      case '|':
        return left | right;
      case '&':
        return left & right;
      case '>>':
        return left >> right;
      default:
        return null;
    }
  }
}

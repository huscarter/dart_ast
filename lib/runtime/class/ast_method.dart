import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';

/// 运行时 method
class AstMethod {
  final MethodDeclaration node;

  ///
  AstMethod(this.node);

  ///
  Future invoke(List params, AstStack stack) {
    if (stack == null) stack = AstStack();
    stack.push();
    // 将传入的 param 参数值按照方法定义，保存到 stack 中
    for(var param in params){
      //
    }
    var result = _execute(stack);
    stack.pop();
    return result;
  }

  /// 真正的执行方法
  /// @param stack
  Future _execute(AstStack stack) {
    for (BlockStatement statement in node.body) {
      switch (statement.expression.type) {
        case AstNodeType.ReturnStatement:
          if(statement.expression.type == AstNodeType.BinaryExpression){
            return Future.value(3);
          }
          break;
        default:
          break;
      }
    }
    return Future.value();
  }
}

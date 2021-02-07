import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/class/ast_method.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';

/// 运行时 class
class AstClass {
  final ClassDeclaration node;

  ///
  AstClass(this.node);

  AstMethod containsMethod(String name){
    for(MethodDeclaration tempNode in node.body) {
      if (tempNode.name.value == name) {
        return AstMethod(tempNode);
      }
    }
    return null;
  }

  ///
  Future executeMethod(String name,List params, AstStack stack) {
    for(MethodDeclaration tempNode in node.body) {
      if (tempNode.name.value == name) {
        AstMethod method = AstMethod(tempNode);
        return method.executeExpression(stack,params);
      }
    }
    return Future.value();
  }


}

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/class/ast_method.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';

/// 运行时 class file，通过解析[AstNode]生成业务逻辑对象;
/// 注意:
///
/// 1. 此类是解析 class 文件，并非是单个 class 类;（一个 class 文件可能会有多个类）
/// 2. 此类出了有 class 之外还有可能定义了全局方法和变量
///
class RuntimeDart {
  final Program program;

  RuntimeDart(this.program);

  /// 存储 class中的属性和方法
  Map<String, dynamic> bodyMap = Map();

  ///
  Future callMethod(String name, List params) {
    if (program == null || program.body == null) return null;
    for (AstNode node in program.body) {
      if (node is ClassDeclaration) {
        if (node.body != null) {
          // 迭代 class 中的方法
          for (MethodDeclaration method in node.body) {
            // 找到方法 invoke
            if (method.name.value == name) {
              return AstMethod(method).invoke(params, AstStack());
            }
          }
        }
      }
      // node is function ast node.
      else if (node is MethodDeclaration) {
        // 找到方法 invoke
        if (node.name.value == name) {
          return AstMethod(node).invoke(params, AstStack());
        }
      }
    }
    return Future.value();
  }

  ///
  // Future callFunction(String name, {Map param}) {
  //   return Future.value();
  // }

}


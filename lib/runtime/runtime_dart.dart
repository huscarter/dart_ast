import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/class/ast_class.dart';
import 'package:dart_ast/runtime/class/ast_method.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';
import 'package:dart_ast/util/logger.dart';

/// 运行时 class file，通过解析[AstNode]生成业务逻辑对象;
/// 注意:
///
/// 1. 此类是解析 class 文件，并非是单个 class 类;（一个 class 文件可能会有多个类）
/// 2. 此类出了有 class 之外还有可能定义了全局方法和变量
///
class RuntimeDart {
  static const String tag = "RuntimeDart";
  final Program program;

  RuntimeDart(this.program);

  /// 存储 class中的属性和方法
  Map<String, dynamic> bodyMap = Map();

  /// 执行语句
  Future execute(String name, List params) {
    if (program.functionBody != null) {
      for (FunctionDeclaration tempNode in program.functionBody) {
        if (tempNode.name.value == name) {
          AstMethod method = AstMethod(tempNode.expression);
          return method.executeExpression(new AstStack(),params);
        }
      }
    }
    if (program.classBody != null) {
      for (ClassDeclaration tempNode in program.classBody) {
        AstClass clazz = AstClass(tempNode);
        AstMethod method = clazz.containsMethod(name);
        if (method != null) {
          return method.executeExpression(new AstStack(),params);
        }
      }
    }
    return null;
  }
}

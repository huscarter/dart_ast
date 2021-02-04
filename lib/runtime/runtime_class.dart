import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 运行时class，通过解析[AstNode]生成业务逻辑对象
class RuntimeClass {
  ///
  List<dynamic> variableStack = [];

  ///
  List<dynamic> methodStack = [];

}

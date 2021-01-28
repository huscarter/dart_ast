import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstAppBar implements AstWidget {
  @override
  String get name => "Text";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return AppBar();
    Widget title;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "title":
          break;
        default:
          break;
      }
    }
    return AppBar(title: title);
  }
}

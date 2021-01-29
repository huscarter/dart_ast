import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/runtime_widget.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstAppBar implements AstWidget {
  @override
  String get name => "AppBar";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return AppBar();
    Widget title;
    String calleeValue = node.callee.value;
    if (calleeValue == name) {
      for (TypeArgument arg in node.argumentList) {
        switch (arg.name.value) {
          case "title":
            title = RuntimeWidget().build(arg.expression);
            break;
          case "centerTitle":
            break;
          default:
            break;
        }
      }
    } else if (calleeValue == "WjsAppBar") {}
    return AppBar(title: title);
  }
}

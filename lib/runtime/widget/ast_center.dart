import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/runtime_widget.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstCenter implements AstWidget {
  @override
  String get name => "Center";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return Center();
    Widget child;
    String calleeValue = node.callee.value;
    if (calleeValue == name) {
      for (TypeArgument arg in node.argumentList) {
        switch (arg.name.value) {
          case "child":
            child = RuntimeWidget().build(arg.expression);
            break;
          default:
            break;
        }
      }
    } else if (calleeValue == "WjsAppBar") {
      //
    }
    return Center(child: child);
  }
}

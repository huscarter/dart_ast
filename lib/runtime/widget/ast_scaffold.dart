import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstScaffold implements AstWidget {
  @override
  String get name => "Text";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return Scaffold();
    Widget appBar;
    Widget body;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "appBar":
          break;
        case "body":
          break;
        default:
          break;
      }
    }
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

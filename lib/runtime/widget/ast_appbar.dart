import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstAppBar extends AstWidget {

  static final String tag = "AstAppBar";

  AstAppBar(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return AppBar();
    Widget title;
    for (NamedExpression arg in node.argumentList) {
      switch (arg.name.value) {
        case "title":
          title = RuntimeFactory.buildWidget(arg.expression);
          break;
        case "centerTitle":
          break;
        default:
          break;
      }
    }
    return AppBar(title: title);
  }
}

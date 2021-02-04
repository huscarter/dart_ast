import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstCenter extends AstWidget {
  static final String tag = "AstCenter";

  AstCenter(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return Center();
    Widget child;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "child":
          child = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    return Center(child: child);
  }
}

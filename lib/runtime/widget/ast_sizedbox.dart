import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstSizedBox extends AstWidget {
  static final String tag = "AstSizedBox";

  AstSizedBox(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return SizedBox();
    Widget child;
    double width;
    double height;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "child":
          child = RuntimeFactory.buildWidget(arg.expression);
          break;
        case "width":
          width = double.parse(arg.expression.value.toString());
          break;
        case "height":
          height = double.parse(arg.expression.value.toString());
          break;
        default:
          break;
      }
    }
    return SizedBox(
      child: child,
      width: width,
      height: height,
    );
  }
}

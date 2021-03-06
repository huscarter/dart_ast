import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_alignment.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/argument/arg_decoration.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/material.dart';

///
class AstContainer extends AstWidget {
  static final String tag = "AstContainer";

  AstContainer(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return Container();
    Widget child;
    double width;
    double height;
    Color color;
    Alignment alignment;
    Decoration decoration;
    for (NamedExpression arg in node.argumentList) {
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
        case "color":
          color = ArgColor.buildColor(arg.expression);
          break;
        case "alignment":
          alignment = ArgAlignment.buildAlignment(arg.expression);
          break;
        case "decoration":
          decoration = ArgDecoration.buildDecoration(arg.expression);
          break;
        default:
          break;
      }
    }
    return Container(
      decoration: decoration,
      child: child,
      width: width,
      height: height,
      color: color,
      alignment: alignment,
    );
  }
}

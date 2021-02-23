import 'dart:ui';
import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:flutter/material.dart';

///
class ArgDecoration {
  ///
  static Decoration buildDecoration(Expression node) {
    Border border;
    Color color;
    for (NamedExpression arg in node.argumentList) {
      switch (arg.name.value) {
        case "border":
          border = buildBorder(arg.expression);
          break;
        case "color":
          color = ArgColor.buildColor(arg.expression);
          break;
      }
    }
    return BoxDecoration(
      border: border,
      color: color,
    );
  }

  ///
  static Border buildBorder(Expression node) {
    double width;
    Color color;
    for (NamedExpression arg in node.argumentList) {
      switch (arg.name.value) {
        case "width":
          width = arg.expression.value;
          break;
        case "color":
          color = ArgColor.buildColor(arg.expression);
          break;
      }
    }
    return Border.all(
      width: width,
      color: color,
    );
  }
}

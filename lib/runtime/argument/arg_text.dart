import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:flutter/material.dart';

///
class ArgText {
  ///
  static TextStyle buildTextStyle(Expression node) {
    Color color;
    switch (node.callee.value) {
      case "TextStyle":
        for (NamedExpression arg in node.argumentList) {
          switch (arg.name.value) {
            case "color":
              color = ArgColor.buildColor(arg.expression);
              break;
            case "fontSize":
              break;
            default:
              break;
          }
        }
        break;
      default:
        break;
    }
    return TextStyle(color: color);
  }
}

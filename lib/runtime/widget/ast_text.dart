import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/ast/ast_node_type.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/runtime/argument/arg_text.dart';
import 'package:flutter/material.dart';

///
class AstText implements AstWidget {
  @override
  String get name => "Text";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return Text("");
    String text;
    TextStyle textStyle;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.type) {
        case AstNodeType.StringLiteral:
          text = arg.name.value;
          break;
        case AstNodeType.NamedExpression:
          var calleeValue = arg.name.value;
          if (calleeValue == "style") {
            textStyle = ArgText.buildTextStyle(arg.expression);
          }
          break;
        default:
          break;
      }
    }
    return Text(
      text,
      style: textStyle,
    );
  }
}

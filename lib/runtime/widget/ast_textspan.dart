import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/runtime/argument/arg_text.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

/// ```dart
/// TextSpan(
///   text: 'Hello world!',
///   style: TextStyle(color: Colors.black),
/// )
/// ```
///
class AstTextSpan extends AstWidget {
  static final String tag = "AstTextSpan";

  AstTextSpan(Expression node) : super(node);

  @override
  TextSpan build() {
    Logger.out(tag, "node:${node.toJson()}");
    if (node.argumentList == null) return TextSpan();
    String text = "";
    TextStyle textStyle;
    for (NamedExpression arg in node.argumentList) {
      switch (arg.name.value) {
        case "style":
          textStyle = ArgText.buildTextStyle(arg.expression);
          break;
        case "text":
          text = arg.expression.value;
          break;
        default:
          break;
      }
    }
    return TextSpan(
      text: text,
      style: textStyle,
    );
  }
}

import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstExpanded extends AstWidget {
  static final String tag = "AstExpanded";

  AstExpanded(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return Expanded();
    Widget child;
    int flex;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "child":
          child = RuntimeFactory.buildWidget(arg.expression);
          break;
        case "flex":
          flex = arg.expression.value;
          break;
        default:
          break;
      }
    }
    return Expanded(flex: flex, child: child);
  }
}

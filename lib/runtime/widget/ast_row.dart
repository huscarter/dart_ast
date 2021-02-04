import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstRow extends AstWidget {
  static final String tag = "AstRow";

  AstRow(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return Row();
    List<Widget> children = [];
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "children":
          for(Expression childNode in arg.expression.value){
            Widget child = RuntimeFactory.buildWidget(childNode);
            children.add(child);
          }
          break;
        default:
          break;
      }
    }
    return Row(children: children);
  }
}

import 'dart:convert';

import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstColumn extends AstWidget {
  static final String tag = "AstColumn";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return Column();
    List<Widget> children = [];
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "children":
          for(Expression childNode in arg.expression.value){
            // Logger.out(tag, "${childNode.toJson()}");
            Widget child = RuntimeFactory.buildWidget(childNode);
            children.add(child);
          }
          break;
        default:
          break;
      }
    }
    return Column(children: children);
  }
}

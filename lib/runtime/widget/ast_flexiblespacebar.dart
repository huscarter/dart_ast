import 'dart:convert';

import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstFlexibleSpaceBar extends AstWidget {
  static final String tag = "AstFlexibleSpaceBar";

  AstFlexibleSpaceBar(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return FlexibleSpaceBar();
    Widget title;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "title":
          title = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    return FlexibleSpaceBar(title: title);
  }
}

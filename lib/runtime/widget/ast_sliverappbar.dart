import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstSliverAppBar extends AstWidget {
  static final String tag = "AstSliverAppBar";

  AstSliverAppBar(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return SliverAppBar();
    bool pinned;
    double expandedHeight;
    Widget flexibleSpace;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "pinned":
          pinned = arg.expression.value;
          break;
        case "expandedHeight":
          expandedHeight = arg.expression.value;
          break;
        case "flexibleSpace":
          flexibleSpace = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    return SliverAppBar(
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }
}

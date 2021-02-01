import 'dart:convert';

import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/ast/ast_node_type.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_textspan.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/runtime/argument/arg_text.dart';
import 'package:flutter/material.dart';

///
class AstSliverGrid extends AstWidget {
  ///
  static final String tag = "AstSliverGrid";

  AstSliverGrid(Expression node) : super(node);

  @override
  Widget build() {
    // Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return SliverGrid();
    String text = "";
    TextSpan textSpan;
    TextStyle textStyle;

    for (dynamic arg in node.argumentList) {
      switch (arg.type) {
        // 使用字符串赋值
        case AstNodeType.StringLiteral:
          text = arg.value;
          break;
        // 使用TextSpan
        case AstNodeType.MethodInvocation:
          textSpan = RuntimeFactory.buildWidget(arg as Expression);
          break;
        // style:{}
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

    return SliverGrid();
  }
}

///
class AstSliverGridDelegateWithMaxCrossAxisExtent extends AstWidget {
  ///
  static final String tag = "AstSliverGridDelegateWithMaxCrossAxisExtent";

  AstSliverGridDelegateWithMaxCrossAxisExtent(Expression node) : super(node);

  @override
  SliverGridDelegateWithMaxCrossAxisExtent build() {
// Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return null;
    double maxCrossAxisExtent;
    double mainAxisSpacing;
    double crossAxisSpacing;
    double childAspectRatio;

    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "maxCrossAxisExtent":
          maxCrossAxisExtent = arg.expression.value;
          break;
        case "mainAxisSpacing":
          mainAxisSpacing = arg.expression.value;
          break;
        case "crossAxisSpacing":
          crossAxisSpacing = arg.expression.value;
          break;
        case "childAspectRatio":
          childAspectRatio = arg.expression.value;
          break;
        default:
          break;
      }
    }

    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}

class AstSliverChildBuilderDelegate extends AstWidget {
  AstSliverChildBuilderDelegate(Expression node) : super(node);

  @override
  SliverChildBuilderDelegate build() {
// Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return null;
    double maxCrossAxisExtent;
    double mainAxisSpacing;
    double crossAxisSpacing;
    double childAspectRatio;

    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "maxCrossAxisExtent":
          maxCrossAxisExtent = arg.expression.value;
          break;
        case "mainAxisSpacing":
          mainAxisSpacing = arg.expression.value;
          break;
        case "crossAxisSpacing":
          crossAxisSpacing = arg.expression.value;
          break;
        case "childAspectRatio":
          childAspectRatio = arg.expression.value;
          break;
        default:
          break;
      }
    }

    return SliverChildBuilderDelegate((BuildContext context, int index) {
      return Container();
    });
  }
}

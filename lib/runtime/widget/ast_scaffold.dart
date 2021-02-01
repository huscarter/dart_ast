import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstScaffold extends AstWidget {

  static final String tag = "AstScaffold";

  AstScaffold(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return Scaffold();
    Widget appBar;
    Widget body;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "appBar":
          appBar = RuntimeFactory.buildWidget(arg.expression);
          break;
        case "body":
          body = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    // Logger.out(tag, "body:${body.runtimeType}");
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

}

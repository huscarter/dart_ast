import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/runtime_widget.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstScaffold implements AstWidget {
  static final String tag = "AstScaffold";
  @override
  String get name => "Scaffold";

  @override
  Widget build(Expression node) {
    if (node.argumentList == null) return Scaffold();
    Widget appBar;
    Widget body;
    String calleeValue = node.callee.value;
    if (calleeValue == name) {
      for (TypeArgument arg in node.argumentList) {
        switch (arg.name.value) {
          case "appBar":
            appBar = RuntimeWidget().build(arg.expression);
            break;
          case "body":
            body = RuntimeWidget().build(arg.expression);
            break;
          default:
            break;
        }
      }
    }
    Logger.out(tag, "body:${body.runtimeType}");
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

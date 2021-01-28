import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/widget/ast_appbar.dart';
import 'package:dart_ast/runtime/widget/ast_scaffold.dart';
import 'package:dart_ast/runtime/widget/ast_text.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:flutter/cupertino.dart';

/// 通过[AstNode]生成整个 Widget Tree。
class RuntimeWidget {
  ///
  static final _instance = RuntimeWidget._();

  ///
  static final List<AstWidget> astWidgets = [
    AstText(),
    AstAppBar(),
    AstScaffold()
  ];

  RuntimeWidget._();

  factory RuntimeWidget() {
    return _instance;
  }

  /// "expression":{"type":"MethodInvocation", "callee":{"type":"Identifier", "value":"Scaffold"}, "typeArguments":null,"argumentList":{}}
  Widget build(Expression node) {
    String calleeValue = node.callee.value;
    for (AstWidget astWidget in astWidgets) {
      if (calleeValue == astWidget.name) {
        return astWidget.build(node);
      }
    }
    return Container();
  }
}

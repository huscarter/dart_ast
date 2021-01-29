import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/widget/ast_appbar.dart';
import 'package:dart_ast/runtime/widget/ast_center.dart';
import 'package:dart_ast/runtime/widget/ast_scaffold.dart';
import 'package:dart_ast/runtime/widget/ast_text.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/cupertino.dart';

/// 通过[AstNode]生成整个 Widget Tree。
class RuntimeFactory {
  static final String tag = "RuntimeFactory";

  ///
  // static final _instance = RuntimeWidget._();

  ///
  // static final List<AstWidget> astWidgets = [
  //   AstText(),
  //   AstAppBar(),
  //   AstCenter(),
  //   AstScaffold()
  // ];

  RuntimeFactory._();

  // factory RuntimeWidget() {
  //   return _instance;
  // }

  /// "expression":{"type":"MethodInvocation", "callee":{"type":"Identifier", "value":"Scaffold"}, "typeArguments":null,"argumentList":{}}
  static Widget buildWidget(Expression node) {
    try {
      String calleeValue = node.callee.value;
      if (calleeValue == getName(AstAppBar.tag)) {
        return AstAppBar().build(node);
      }else if(calleeValue == getName(AstCenter.tag)){
        return AstCenter().build(node);
      }else if(calleeValue == getName(AstScaffold.tag)){
        return AstScaffold().build(node);
      }else if(calleeValue == getName(AstText.tag)){
        return AstText().build(node);
      }
      return Container();
    } catch (e) {
      Logger.out(tag, "$e");
      return Container();
    }
  }

  /// 获取[AstWidget]代表的原生组件名称
  static String getName(String tag) {
    return tag.substring(3, tag.length);
  }
}

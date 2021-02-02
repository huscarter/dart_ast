import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/ast/ast_node_type.dart';
import 'package:dart_ast/runtime/widget/ast_appbar.dart';
import 'package:dart_ast/runtime/widget/ast_center.dart';
import 'package:dart_ast/runtime/widget/ast_column.dart';
import 'package:dart_ast/runtime/widget/ast_container.dart';
import 'package:dart_ast/runtime/widget/ast_customscrollview.dart';
import 'package:dart_ast/runtime/widget/ast_expanded.dart';
import 'package:dart_ast/runtime/widget/ast_flexiblespacebar.dart';
import 'package:dart_ast/runtime/widget/ast_row.dart';
import 'package:dart_ast/runtime/widget/ast_scaffold.dart';
import 'package:dart_ast/runtime/widget/ast_sliverappbar.dart';
import 'package:dart_ast/runtime/widget/ast_sliver.dart';
import 'package:dart_ast/runtime/widget/ast_text.dart';
import 'package:dart_ast/runtime/widget/ast_textspan.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/cupertino.dart';

/// 通过[AstNode]生成整个 Widget Tree。
class RuntimeFactory {
  static final String tag = "RuntimeFactory";

  ///
  RuntimeFactory._();

  /// "expression":{"type":"MethodInvocation", "callee":{"type":"Identifier", "value":"Scaffold"}, "typeArguments":null,"argumentList":{}}
  static dynamic buildWidget(Expression node) {
    // Logger.out(tag, "calleeValue:${node.callee.toJson()}");
    // Logger.out(tag, "node:${node.toJson()}");
    try {
      if (node.callee.type == AstNodeType.MemberExpression) {
        String property = getProperty(node.callee);
        if (property == getName(AstText.tagProperty)) {
          return AstText(node).build();
        }
      } else {
        String calleeValue = node.callee.value;
        if (calleeValue == getName(AstAppBar.tag)) {
          return AstAppBar(node).build();
        } else if (calleeValue == getName(AstCenter.tag)) {
          return AstCenter(node).build();
        } else if (calleeValue == getName(AstScaffold.tag)) {
          return AstScaffold(node).build();
        } else if (calleeValue == getName(AstText.tag)) {
          return AstText(node).build();
        } else if (calleeValue == getName(AstContainer.tag)) {
          return AstContainer(node).build();
        } else if (calleeValue == getName(AstColumn.tag)) {
          return AstColumn(node).build();
        } else if (calleeValue == getName(AstRow.tag)) {
          return AstRow(node).build();
        } else if (calleeValue == getName(AstTextSpan.tag)) {
          return AstTextSpan(node).build();
        } else if (calleeValue == getName(AstExpanded.tag)) {
          return AstExpanded(node).build();
        } else if (calleeValue == getName(AstFlexibleSpaceBar.tag)) {
          return AstFlexibleSpaceBar(node).build();
        } else if (calleeValue == getName(AstSliverAppBar.tag)) {
          return AstSliverAppBar(node).build();
        } else if (calleeValue == getName(AstCustomScrollView.tag)) {
          return AstCustomScrollView(node).build();
        } else if (calleeValue == getName(AstSliverGrid.tag)) {
          return AstSliverGrid(node).build();
        } else if (calleeValue == getName(AstSliverGridDelegateWithMaxCrossAxisExtent.tag)) {
          return AstSliverGridDelegateWithMaxCrossAxisExtent(node).build();
        } else if (calleeValue == getName(AstSliverChildBuilderDelegate.tag)) {
          return AstSliverChildBuilderDelegate(node).build();
        } else if (calleeValue == getName(AstSliverFixedExtentList.tag)) {
          return AstSliverFixedExtentList(node).build();
        }
      }
      return Center(child: Text("No ast widget matched"));
    } catch (e) {
      Logger.out(tag, "$e");
      return Center(child: Text("Ast widget build failed"));
    }
  }

  /// 获取[AstWidget]代表的原生组件名称
  static String getName(String tag) => tag.substring(3, tag.length);

  ///
  static String getProperty(Identifier node) =>
      node.target.value + "." + node.property.value;
}

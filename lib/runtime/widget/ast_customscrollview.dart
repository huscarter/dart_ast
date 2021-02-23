import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/argument/arg_color.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

/// ```dart
/// CustomScrollView(
///   slivers: <Widget>[
///     const SliverAppBar(
///       pinned: true,
///       expandedHeight: 250.0,
///       flexibleSpace: FlexibleSpaceBar(
///         title: Text('Demo'),
///       ),
///     ),
///     SliverGrid(
///       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
///         maxCrossAxisExtent: 200.0,
///         mainAxisSpacing: 10.0,
///         crossAxisSpacing: 10.0,
///         childAspectRatio: 4.0,
///       ),
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///           return Container(
///             alignment: Alignment.center,
///             color: Colors.teal[100 * (index % 9)],
///             child: Text('Grid Item $index'),
///           );
///         },
///         childCount: 20,
///       ),
///     ),
///     SliverFixedExtentList(
///       itemExtent: 50.0,
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///           return Container(
///             alignment: Alignment.center,
///             color: Colors.lightBlue[100 * (index % 9)],
///             child: Text('List Item $index'),
///           );
///         },
///       ),
///     ),
///   ],
/// )
/// ```
///
class AstCustomScrollView extends AstWidget {
  static final String tag = "AstCustomScrollView";

  AstCustomScrollView(Expression node) : super(node);

  @override
  Widget build() {
    if (node.argumentList == null) return CustomScrollView();
    List<Widget> slivers = [];

    for (NamedExpression arg in node.argumentList) {
      switch (arg.name.value) {
        case "slivers":
          for (Expression childNode in arg.expression.value) {
            Widget child = RuntimeFactory.buildWidget(childNode);
            slivers.add(child);
          }
          break;
        default:
          break;
      }
    }
    return CustomScrollView(slivers: slivers);
  }
}

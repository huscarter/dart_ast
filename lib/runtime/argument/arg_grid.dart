import 'dart:ui';
import 'package:dart_ast/ast/ast_node.dart';
import 'package:flutter/material.dart';

/// Build arguments for grid
class ArgGrid {

  ///
  static SliverGridDelegateWithMaxCrossAxisExtent
      buildSliverGridDelegateWithMaxCrossAxisExtent(Expression node) {

    double maxCrossAxisExtent;
    double mainAxisSpacing;
    double crossAxisSpacing;
    double childAspectRatio;

    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}

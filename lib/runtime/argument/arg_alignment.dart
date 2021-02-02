import 'dart:ui';
import 'package:dart_ast/ast/ast_node.dart';
import 'package:flutter/material.dart';

///
class ArgAlignment {
  static Alignment buildAlignment(Expression node) {
    String prefix = node.prefix.value;
    if (prefix == "Alignment") {
      String value = node.identifier.value;
      if (value == "center") {
        return Alignment.center;
      } else if (value == "centerRight") {
        return Alignment.centerRight;
      } else if (value == "centerLeft") {
        return Alignment.centerLeft;
      } else if (value == "bottomLeft") {
        return Alignment.bottomLeft;
      } else if (value == "bottomRight") {
        return Alignment.bottomRight;
      } else if (value == "bottomCenter") {
        return Alignment.bottomCenter;
      } else if (value == "topCenter") {
        return Alignment.topCenter;
      } else if (value == "topLeft") {
        return Alignment.topLeft;
      } else if (value == "topRight") {
        return Alignment.topRight;
      }
    }
    return Alignment.center;
  }
}

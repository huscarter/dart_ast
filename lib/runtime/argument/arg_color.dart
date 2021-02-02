import 'dart:ui';
import 'package:dart_ast/ast/ast_node.dart';
import 'package:flutter/material.dart';

///
class ArgColor {
  static Color buildColor(Expression node) {
    String prefix = node.prefix.value;
    if (prefix == "Colors") {
      String value = node.identifier.value;
      if (value == "black") {
        return Colors.black;
      } else if (value == "white") {
        return Colors.white;
      } else if (value == "blue") {
        return Colors.blue;
      } else if (value == "teal") {
        return Colors.teal;
      } else if (value == "lightBlue") {
        return Colors.lightBlue;
      }
    }
    return Colors.black;
  }
}

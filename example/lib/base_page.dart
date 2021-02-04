import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
abstract class StatelessPage extends StatelessWidget with CommonPage {}

///
abstract class StatefulPage extends StatefulWidget with CommonPage {}

///
abstract class AstState<T extends StatefulPage> extends State with CommonPage {}

///
class CommonPage {
  static final String tag = "CommonPage";

  Future<AstNode> parseAstNode(String json) {
    return Future.microtask(() {
      Map map = jsonDecode(json) as Map;
      AstNode astNode;
      try {
        astNode = Program.fromMap(map);
        return astNode;
      } catch (e) {
        print(e);
        return astNode;
      }
    });
  }

  AstNode parseAstNodeSync(String json) {
    Map map = jsonDecode(json) as Map;

    AstNode astNode;
    try {
      astNode = Program.fromMap(map);
      // Logger.out(tag, astNode.type);
      return astNode;
    } catch (e) {
      print(e);
      return astNode;
    }
  }
}

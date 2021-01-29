// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:dart_ast_example/ast_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_ast_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(MyApp());

    // Verify that platform version is retrieved.
  //   expect(
  //     find.byWidgetPredicate(
  //       (Widget widget) => widget is Scaffold,
  //     ),
  //     findsOneWidget,
  //   );

    AstNode astNode = parseAstNodeSync(AstJson.ast_page);
    Logger.out("test", astNode.type);
  });
}

AstNode parseAstNodeSync(String json) {
  Map map = jsonDecode(json) as Map;

  AstNode astNode;
  try {
    astNode = Program.fromMap(map);
    return astNode;
  } catch (e) {
    print(e);
    return astNode;
  }
}

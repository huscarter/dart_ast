import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/runtime/runtime_dart.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/runtime_page.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:dart_ast/util/navigation.dart';
import 'package:dart_ast_example/test_page.dart';
import 'package:flutter/material.dart';

import 'ast_json.dart';
import 'base_page.dart';

///
void main() {
  runApp(MyApp());
}

/// App start
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  /// Config you app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/// Home page
class HomePage extends StatelessPage {
  static final String tag = "HomePage";

  @override
  Widget build(BuildContext context) {
    // Logger.out(tag, new TestStatic().tag);

    // test runtime dart
    RuntimeDart runtimeDart =
        RuntimeFactory.buildDart(parseAstNodeSync(AstJson.ast_class));
    Future result = runtimeDart.execute("add", [1, 10]);
    if (result == null) {
      Logger.out(tag, "runtime dart result:null");
    } else {
      result.then((value) => Logger.out(tag, "runtime dart result:$value"));
    }

    // test runtime page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 48),
          Container(
            margin: EdgeInsets.all(16),
            width: double.infinity,
            height: 48,
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("static ast page"),
              onPressed: () {
                Navigation.push(context, TestPage());
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            width: double.infinity,
            height: 48,
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("dynamic ast page"),
              onPressed: () {
                Navigation.push(
                  context,
                  RuntimePage(parseAstNodeSync(AstJson.ast_page)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TestStatic extends AstWidget {
  static String name = "TestStatic";

  TestStatic(Expression node) : super(node);

  @override
  Widget build() {
    return Text("");
  }
}

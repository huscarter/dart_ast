import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/runtime/runtime_page.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:dart_ast/util/navigation.dart';
import 'package:dart_ast_example/ast_page.dart';
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
                Navigation.push(context, AstPage());
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

class TestStatic extends AstWidget{
  static String name = "TestStatic";

  @override
  Widget build(Expression node) {
    return Text("");
  }

}


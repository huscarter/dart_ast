import 'package:dart_ast/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class AstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AstPageState();
}

///
class _AstPageState extends State<AstPage> {
  // @override
  // Widget build(BuildContext context) {
  //   // test();
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("AstPage"),
  //     ),
  //     body: Center(
  //       child: Text("Hello World"),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // test();
    return Scaffold(
      appBar: AppBar(
        title: Text("AstPage"),
      ),
      body: Column(
        children: <Widget>[
          Text("1"),
          Text("2"),
        ],
      ),
    );
  }
}

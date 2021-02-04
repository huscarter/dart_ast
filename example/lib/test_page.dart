import 'package:dart_ast/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestPageState();
}

///
class _TestPageState extends State<TestPage> {
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
        title: Text("TestPage"),
      ),
      body: ListView.builder(
        itemBuilder: (_context, _index) {
          return ListTile(title: Text("item num:$_index"));
        },
        itemCount: 50,
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    // test();
    return Scaffold(
      appBar: AppBar(
        title: Text("AstPage", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }

// void test(){
//   Logger.print("msg");
// }
}

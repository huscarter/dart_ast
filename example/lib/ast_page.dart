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
    return Scaffold(
      appBar: AppBar(title: Text("AstPage")),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }
}

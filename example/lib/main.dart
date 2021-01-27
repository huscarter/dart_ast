import 'package:dart_ast/demo.dart';
import 'package:dart_ast_example/ast_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dart_ast/runtime/runtime_page.dart';
import 'package:dart_ast/util/navigation.dart';
import 'package:dart_ast/util/logger.dart';

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
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Temp temp = Temp.fromString("test");
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
              child: Text("dynamic ast page ${temp.arg}"),
              onPressed: () {
                Navigation.push(context, RuntimePage());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Temp {
  String arg;

  Temp(this.arg);

  Temp.fromString(String arg) {
    this.arg = arg;
  }
}

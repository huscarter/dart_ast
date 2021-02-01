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
      body: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar(
          //   pinned: true,
          //   expandedHeight: 250.0,
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text('Demo'),
          //   ),
          // ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('Grid Item $index'),
                );
              },
              childCount: 20,
            ),
          ),
          // SliverFixedExtentList(
          //   itemExtent: 50.0,
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         alignment: Alignment.center,
          //         color: Colors.lightBlue[100 * (index % 9)],
          //         child: Text('List Item $index'),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class RuntimePage extends StatefulWidget {
  final String map;

  RuntimePage({Key key, this.map}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RuntimePageState();
}

///
class _RuntimePageState extends State<RuntimePage> {
  Widget _astWidget;
  Widget _loadWidget;

  ///
  @override
  void initState() {
    super.initState();
    _loadWidget = Center(
        child: SizedBox.fromSize(
            size: Size.square(30), child: CircularProgressIndicator()));
  }

  ///
  void _setState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _buildAstWidget(){

  }

  ///
  @override
  Widget build(BuildContext context) {
    return _astWidget ?? _loadWidget;
  }
}

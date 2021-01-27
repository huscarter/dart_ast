import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class Navigation {
  Navigation._();

  static void push(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => widget));
  }

  // static void pushAndRemoveUntil(BuildContext context, Widget widget) {
  //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => widget));
  // }
  //
  // static void pushNamedAndRemoveUntil(BuildContext context, Widget widget) {
  //   Navigator.of(context).pushNamedAndRemoveUntil(MaterialPageRoute(builder: (_) => widget));
  // }
  //
  // static void pushNamed(BuildContext context, Widget widget) {
  //   Navigator.of(context).pushNamed(MaterialPageRoute(builder: (_) => widget));
  // }

  static void pop(BuildContext context, [dynamic obj]) {
    Navigator.of(context).pop(obj);
  }
}

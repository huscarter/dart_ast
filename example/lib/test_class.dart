import 'package:flutter/material.dart' as ms;

///
class TestClass {
  List<String> list = ["w","h"];

  ///
  int add(int a) {
    int result = 0;
    for (int i = 0; i < 10; i++) {
      result = i + result;
    }
    return result;
  }
}

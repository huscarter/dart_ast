import 'package:dart_ast/compiler/node/ast_node.dart';

///
class AstStack {
  /// [Map]用来保存一个执行块（比如方法）的变量
  List<Map<String, AstNode>> _list = [];

  ///
  void push() {
    _list.add(Map());
  }

  ///
  void pop() {
    _list.removeLast();
  }

  ///
  void add(String name, AstNode node) {
    for (int i = _list.length - 1; i > -1; i--) {
      if (_list[i].containsKey(name)) {
        _list[i][name] = node;
        return;
      }
    }
    _list.last[name] = node;
  }

  ///
  T get<T extends AstNode>(String name) {
    for (int i = _list.length - 1; i > -1; i--) {
      if (_list[i].containsKey(name)) {
        var result = _list[i][name];
        if (result is T) {
          return result;
        }
      }
    }
    return null;
  }
}

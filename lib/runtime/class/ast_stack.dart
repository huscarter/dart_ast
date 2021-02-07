import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';

///
class AstStack {

  /// [Map]用来保存一个执行块（比如方法）的变量
  List<Map<String, dynamic>> _list = [];

  AstStack();

  ///
  void push() {
    _list.add(Map());
  }

  ///
  void pop() {
    _list.removeLast();
  }

  ///
  void addVariable(String name, dynamic value) {
    for (int i = _list.length - 1; i > -1; i--) {
      if (_list[i].containsKey(name)) {
        _list[i][name] = value;
        return;
      }
    }
    _list.last[name] = value;
  }

  ///
  void addMethod(String name, dynamic value) {
    _list.last[name] = value;
  }

  ///
  T get<T>(String name) {
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

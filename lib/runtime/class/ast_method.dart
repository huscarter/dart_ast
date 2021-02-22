import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/class/ast_stack.dart';
import 'package:dart_ast/util/logger.dart';

/// 运行时 class#method
/// 全局函数的执行体被包装在属性中[FunctionDeclaration.expression]
class AstMethod {
  static const String tag = "AstMethod";

  final MethodDeclaration node;

  ///
  AstMethod(this.node);

  /// 真正的执行方法
  ///
  Future executeExpression(AstStack stack, List params) {
    if (stack == null) stack = AstStack();
    stack.push();
    // Logger.out(tag, "node:${node.toJson()}");
    // 将传参和形参对应
    for (int i = 0; i < node.parameters.length; i++) {
      if (node.type == AstNodeType.MethodDeclaration) {
        stack.addMethod(node.parameters[i].name, params[i]);
      } else {
        stack.addVariable(node.parameters[i].name, params[i]);
      }
    }
    var result;
    for (BlockStatement statement in node.body) {
      result = _innerExecute(statement.expression, stack);
    }
    stack.pop();
    return result;
  }

  /// 执行分类语句
  dynamic _innerExecute(Expression expression, AstStack stack) async {
    String type = expression.type;
    if(type == AstNodeType.Identifier){
      return stack.get(expression.value.name);
    }else if (type == AstNodeType.BinaryExpression) {
      return await _executeBinary(expression, stack);
    } else if (type == AstNodeType.ReturnStatement) {
      //
    } else if (type == AstNodeType.ExpressionStatement) {
      return await _executeStatement(expression, stack);
    } else if (type == AstNodeType.AssignmentExpression) {
      //
    } else if (type == AstNodeType.StringLiteral) {
      return expression.value;
    } else if (type == AstNodeType.DoubleLiteral) {
      return expression.value;
    } else if (type == AstNodeType.IntegerLiteral) {
      return expression.value;
    } else if (type == AstNodeType.BooleanLiteral) {
      return expression.value;
    } else if (type == AstNodeType.ListLiteral) {
      return _executeListLiteral(expression,stack);
    } else if (type == AstNodeType.SetOrMapLiteral) {
      return _executeMapLiteral(expression, stack);
    }
    return null;
  }

  /// 底层执行
  dynamic _executeStatement(Expression expression, AstStack stack) {
    var rightHandSide = _executeBinary(expression.rightHandSide, stack);
    var leftHandSide = _executeBinary(expression.leftHandSide, stack);
    return _executeBinary(
      BinaryExpression(
        operator: expression.operator,
        left: leftHandSide,
        right: rightHandSide,
      ),
      stack,
    );
  }

  /// 底层执行
  dynamic _executeBinary(BinaryExpression expression, AstStack stack) {
    var left = stack.get(expression.left.value);
    var right = stack.get(expression.right.value);
    //操作符
    switch (expression.operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        return left / right;
      case '<':
        return left < right;
      case '>':
        return left > right;
      case '<=':
        return left <= right;
      case '>=':
        return left >= right;
      case '==':
        return left == right;
      case '&&':
        return left && right;
      case '||':
        return left || right;
      case '%':
        return left % right;
      case '<<':
        return left << right;
      case '|':
        return left | right;
      case '&':
        return left & right;
      case '>>':
        return left >> right;
      default:
        return null;
    }
  } // _executeBinary

  /// 底层执行
  List _executeListLiteral(Expression expression, AstStack stack) {
    List list = [];
    for (dynamic temp in expression.value) {
      list.add(_innerExecute(temp, stack));
    }
    return list;
  } // _executeListLiteral

  /// 底层执行
  Map _executeMapLiteral(Expression expression, AstStack stack) {
    Map map = Map();
    for (MapEntry temp in expression.value) {
      map[temp.key](_innerExecute(temp.value, stack));
    }
    return map;
  } // _executeMapLiteral

  ///
  Future _executeIfStatement(BlockStatement statement, AstStack stack) async {
    bool condition;
    if(statement.condition.type == AstNodeType.Identifier){
      condition = stack.get(statement.condition.value);
    }else {
      condition = _executeBinary(statement.condition, stack);
    }
    if (condition) {
      for(BlockStatement temp in statement.thenStatement){
        if(temp.type == AstNodeType.ReturnStatement){
          return _innerExecute(temp.expression,stack);
        }else{
          _innerExecute(temp.expression,stack);
        }
      }
    } else {
      for(BlockStatement temp in statement.elseStatement){
        if(temp.type == AstNodeType.ReturnStatement){
          return _innerExecute(temp.expression,stack);
        }else{
          _innerExecute(temp.expression,stack);
        }
      }
    }
    return Future.value();
  }

}

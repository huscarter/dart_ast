import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/cupertino.dart';

import 'ast_node_key.dart';
import 'ast_node_type.dart';

/// [dart_ast.dart]生成的json数据解析称AstNode。
///
/// 1. AstNode和[dart_ast.dart]生成json数据的逻辑是强依赖的，如果[dart_ast.dart]逻辑发生变化可能会导致此类解析失败。
///
/// 2. AstNode并不完全按照json格式解析，有些为了方便对外调用会做层级缩减。
///
/// AstNode 基类。
class AstNode {
  static final String tag = "AstNode";

  ///
  String type;

  ///
  Map map;

  ///
  AstNode({String type, Map map}) {
    if (map == null) return;
    if (type == null) {
      this.type = map[AstNodeKey.type];
    } else {
      this.type = type;
    }
    this.map = map;
    // Logger.out(tag, "map:$map");
  }

  /// For json decode
  Map<String, dynamic> toJson() {
    return map;
  }
}

///
class Identifier extends AstNode {
  String value;

  Identifier target;

  Identifier property;

  Identifier.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.value = map[AstNodeKey.value];
    this.target = Identifier.fromMap(map[AstNodeKey.target]);
    this.property = Identifier.fromMap(map[AstNodeKey.property]);
  }
}

/// contains TypeName and ParameterType
class TypeName extends AstNode {
  String name;

  TypeName.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.name = map[AstNodeKey.name];
  }
}

/// 此类一般用于描述"type"为"MethodInvocation"的信息
/// 当我们通过[AstNode]生成[Widget]时，一般就是通过传入此信息来build
class Expression extends BinaryExpression {
  static final String tag = "Expression";

  Identifier callee;
  List<TypeArgument> typeArguments;

  /// 此属性为了方便调用，对原ast node json进行了层级消减（消减一级）
  /// 参数列表类型有可能的情况：TypeArgument,Expression,Identifier(TypeArgument contain Identifier)
  /// Text(Text.rich(),style:TextStyle())
  List<dynamic> argumentList;

  /// "identifier":{"type":"Identifier", "value":"black"}
  Identifier identifier;

  /// "prefix":{"type":"Identifier", "value":"Colors"}
  Identifier prefix;

  /// type of Identifier or List<Expression>
  dynamic value;

  BinaryExpression rightHandSide;

  BinaryExpression leftHandSide;

  Expression.fromMap(Map map) : super.fromMap(map) {
    if (map == null) return;
    this.callee = Identifier.fromMap(map[AstNodeKey.callee]);

    // todo typeArguments

    if (map[AstNodeKey.argumentList] != null &&
        map[AstNodeKey.argumentList][AstNodeKey.argumentList] != null) {
      argumentList = [];
      for (Map temp in map[AstNodeKey.argumentList][AstNodeKey.argumentList]) {
        // is Expression
        if (temp[AstNodeKey.type] == AstNodeType.MethodInvocation) {
          argumentList.add(Expression.fromMap(temp));
        }
        // is TypeArgument or Identifier
        else {
          argumentList.add(TypeArgument.fromMap(temp));
        }
      }
    }
    this.identifier = Identifier.fromMap(map[AstNodeKey.identifier]);
    this.prefix = Identifier.fromMap(map[AstNodeKey.prefix]);

    // for parse value
    var tempValue = map[AstNodeKey.value];
    if (tempValue != null) {
      if (tempValue is String ||
          tempValue is int ||
          tempValue is double ||
          tempValue is bool) {
        this.value = tempValue;
      } else if (tempValue is List) {
        // Logger.out(tag, "is list");
        List<Expression> tempList = [];
        for (Map tempValueMap in tempValue) {
          tempList.add(Expression.fromMap(tempValueMap));
        }
        this.value = tempList;
      }
    }

    this.rightHandSide =
        BinaryExpression.fromMap(map[AstNodeKey.rightHandSide]);

    this.leftHandSide = BinaryExpression.fromMap(map[AstNodeKey.leftHandSide]);
  } // end fromMap
}

/// for argumentList value
class TypeArgument extends AstNode {
  Identifier name;
  Expression expression;

  /// 此属性为了方便调用，对原ast node json进行了层级消减（消减一级）
  ///  {"body":{"type":"BlockStatement","statements":[{ "type":"ReturnStatement", "expression":{}}]}}
  List<BlockStatement> body;

  /// 当此argument为最后一层时，此时[value]将有具体的值，而[expression]则不会有值。
  dynamic value;

  TypeArgument.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.name = Identifier.fromMap(map[AstNodeKey.name]);

    if (map[AstNodeKey.expression] != null) {
      this.expression = Expression.fromMap(map[AstNodeKey.expression]);
    }

    this.value = map[AstNodeKey.value];

    if (map[AstNodeKey.body] != null &&
        map[AstNodeKey.body][AstNodeKey.statements] != null) {
      this.body = [];
      for (Map temp in map[AstNodeKey.body][AstNodeKey.statements]) {
        this.body.add(BlockStatement.fromMap(temp));
      }
    }
  }
}

///
class BinaryExpression extends AstNode {
  String operator;
  Identifier left;
  Identifier right;

  BinaryExpression({this.operator, this.right, this.left});

  BinaryExpression.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.operator = map[AstNodeKey.operator];
    this.left = Identifier.fromMap(map[AstNodeKey.left]);
    this.right = Identifier.fromMap(map[AstNodeKey.right]);
  }
}

/// contains ExpressionStatement and ReturnStatement
class BlockStatement extends AstNode {
  Expression expression;

  BlockStatement.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.expression = Expression.fromMap(map[AstNodeKey.expression]);
  }
}

///
class FormalParameter extends AstNode {
  String name;
  TypeName parameterType;

  FormalParameter.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.name = map[AstNodeKey.name];
    this.parameterType = TypeName.fromMap(map[AstNodeKey.parameterType]);
  }
}

/// class方法在 AstNode 中的描述
class MethodDeclaration extends AstNode {
  Identifier name;

  /// 此属性为了方便调用，对原ast node json进行了层级消减（消减一级）
  List<FormalParameter> parameters;
  List<TypeParameter> typeParameters;

  /// 此属性为了方便调用，对原ast node json进行了层级消减（消减一级）
  List<BlockStatement> body;
  bool isAsync;
  TypeName returnType;

  MethodDeclaration.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.name = Identifier.fromMap(map[AstNodeKey.name]);

    if (map[AstNodeKey.parameters] != null &&
        map[AstNodeKey.parameters][AstNodeKey.parameterList] != null) {
      parameters = [];
      for (Map temp in map[AstNodeKey.parameters][AstNodeKey.parameterList]) {
        parameters.add(FormalParameter.fromMap(temp));
      }
    }

    // todo typeParameters

    if (map[AstNodeKey.body] != null &&
        map[AstNodeKey.body][AstNodeKey.statements] != null) {
      body = [];
      for (Map temp in map[AstNodeKey.body][AstNodeKey.statements]) {
        body.add(BlockStatement.fromMap(temp));
      }
    }

    this.isAsync = map[AstNodeKey.isAsync];
    this.returnType = TypeName.fromMap(map[AstNodeKey.returnType]);
  }
}

/// 全局方法 AstNode
class FunctionDeclaration extends AstNode {
  Identifier name;

  MethodDeclaration expression;
  bool isAsync;

  FunctionDeclaration.fromMap(Map map) : super(map: map) {
    if (map == null) return;

    this.name = Identifier.fromMap(map[AstNodeKey.name]);

    this.expression = MethodDeclaration.fromMap(map[AstNodeKey.expression]);

    this.isAsync = map[AstNodeKey.isAsync];
  }
}

///
class ClassDeclaration extends AstNode {
  Identifier name;
  TypeName superClause;
  TypeName implementsClause;
  TypeName widthClause;
  List<MethodDeclaration> body;
  List metadata;

  ClassDeclaration.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.name = Identifier.fromMap(map[AstNodeKey.name]);
    this.superClause = TypeName.fromMap(map[AstNodeKey.superClause]);
    this.implementsClause = TypeName.fromMap(map[AstNodeKey.implementsClause]);
    this.widthClause = TypeName.fromMap(map[AstNodeKey.widthClause]);

    if (map[AstNodeKey.body] != null) {
      body = [];
      for (Map temp in map[AstNodeKey.body]) {
        body.add(MethodDeclaration.fromMap(temp));
      }
    }
  }
}

///
class ImportDirective extends AstNode {
  Identifier uri;
  String prefix;
  List<AstNode> combinators;

  ImportDirective.fromMap(Map map) : super(map: map) {
    if (map == null) return;
    this.uri = Identifier.fromMap(map[AstNodeKey.uri]);
    this.prefix = map[AstNodeKey.prefix];

    // todo combinators
  }
}

///
class Program extends AstNode {
  List<ClassDeclaration> classBody;
  List<FunctionDeclaration> functionBody;
  List<ImportDirective> directive;

  Program.fromMap(Map map) : super(map: map) {
    if (map == null) return;

    if (map[AstNodeKey.body] != null) {
      this.classBody = [];
      this.functionBody = [];
      for (Map temp in map[AstNodeKey.body]) {
        if (temp[AstNodeKey.type] == AstNodeType.FunctionDeclaration) {
          this.functionBody.add(FunctionDeclaration.fromMap(temp));
        } else {
          this.classBody.add(ClassDeclaration.fromMap(temp));
        }
      }
    }

    if (map[AstNodeKey.directive] != null) {
      this.directive = [];
      for (Map temp in map[AstNodeKey.directive]) {
        this.directive.add(ImportDirective.fromMap(temp));
      }
    }
  }
}

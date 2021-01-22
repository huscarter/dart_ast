import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';

///
void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag("file", negatable: false, abbr: 'f');

  var argResults = parser.parse(arguments);
  final paths = argResults.rest;
  if (paths.isEmpty) {
    stdout.writeln('File not found');
  } else {
    generate(paths[0]);
  }
}

///
Future generate(String path) async {
  if (path.isEmpty) {
    stdout.writeln("File not found");
  } else {
    stdout.writeln("File path: $path");
    try {
      var parseResult =
      parseFile(path: path, featureSet: FeatureSet.fromEnableFlags([]));
      // // stdout.writeln("File content: ${parseResult.content}");
      var compilationUnit = parseResult.unit;
      // compilationUnit.accept(DartAstVisitor());

      // var astData = compilationUnit.accept(DartAstVisitor());
      var astData = compilationUnit.accept(TestAstVisitor());
      // stdout.writeln(convert.jsonEncode(astData));
    } catch (e) {
      stdout.writeln('File parse error: ${e.toString()}');
    }
  }
}

///
class DartAstVisitor extends SimpleAstVisitor<Map> {
  ///
  Map _visitNode(AstNode node) {
    if (node == null) {
      return null;
    }
    var map = node.accept(this);
    // stdout.writeln("_visitNode map: $map");
    return map;
  }

  ///
  List<Map> _visitNodeList(NodeList<AstNode> nodes) {
    List<Map> maps = [];
    nodes = nodes ?? [];

    for (AstNode node in nodes) {
      if (node != null) {
        var map = node.accept(this);
        maps.add(map);
        // stdout.writeln("_visitNodeList map: $map");
      }
    }
    return maps;
  }

  /// 构造根节点
  Map _visitAstRoot(List<Map> body) {
    if (body.isNotEmpty) {
      return {
        "type": "Program",
        "body": body,
      };
    } else {
      return null;
    }
  }

  /// 构造代码块Block结构
  Map _visitBlock(List body) => {"type": "BlockStatement", "body": body};

  /// 构造运算表达式结构
  Map _visitBinaryExpression(Map left, Map right, String lexeme) =>
      {
        "type": "BinaryExpression",
        "operator": lexeme,
        "left": left,
        "right": right
      };

  /// 构造变量声明
  Map _visitVariableDeclaration(Map id, Map init) =>
      {
        "type": "VariableDeclarator",
        "id": id,
        "init": init,
      };

  /// 构造变量声明
  Map _visitVariableDeclarationList(Map typeAnnotation, List<Map> declarations) =>
      {
        "type": "VariableDeclarationList",
        "typeAnnotation": typeAnnotation,
        "declarations": declarations,
      };

  /// 构造标识符定义
  Map _visitIdentifier(String name) => {"type": "Identifier", "name": name};

  /// 构造数值定义
  Map _visitNumericLiteral(num value) =>
      {"type": "NumericLiteral", "value": value};

  /// 构造函数声明
  Map _visitFunctionDeclaration(Map id, Map expression) =>
      {
        "type": "FunctionDeclaration",
        "id": id,
        "expression": expression,
      };

  /// 构造函数表达式
  Map _visitFunctionExpression(Map params, Map body, {bool isAsync: false}) =>
      {
        "type": "FunctionExpression",
        "parameters": params,
        "body": body,
        "isAsync": isAsync,
      };

  /// 构造函数参数
  Map _visitFormalParameterList(List<Map> parameterList) =>
      {"type": "FormalParameterList", "parameterList": parameterList};

  /// 构造函数参数
  Map _visitSimpleFormalParameter(Map type, String name) =>
      {"type": "SimpleFormalParameter", "parameterType": type, "name": name};

  /// 构造函数参数类型
  Map _visitTypeName(String name) =>
      {
        "type": "TypeName",
        "name": name,
      };

  /// 构造返回数据定义
  Map _visitReturnStatement(Map argument) =>
      {
        "type": "ReturnStatement",
        "argument": argument,
      };

  /// 构建方法声明
  Map _visitMethodDeclaration(Map id, Map parameters, Map typeParameters,
      Map body, Map returnType,
      {bool isAsync: false}) =>
      {
        "type": "MethodDeclaration",
        "id": id,
        "parameters": parameters,
        "typeParameters": typeParameters,
        "body": body,
        "isAsync": isAsync,
        "returnType": returnType,
      };

  ///
  Map _visitNamedExpression(Map id, Map expression) =>
      {
        "type": "NamedExpression",
        "id": id,
        "expression": expression,
      };

  ///
  Map _visitPrefixedIdentifier(Map identifier, Map prefix) =>
      {
        "type": "PrefixedIdentifier",
        "identifier": identifier,
        "prefix": prefix,
      };

  ///
  Map _visitMethodInvocation(Map callee, Map typeArguments, Map argumentList) =>
      {
        "type": "MethodInvocation",
        "callee": callee,
        "typeArguments": typeArguments,
        "argumentList": argumentList,
      };

  ///
  Map _visitClassDeclaration(Map id, Map superClause, Map implementsClause,
      Map widthClause, List<Map> metadata, List<Map> body) =>
      {
        "type": "ClassDeclaration",
        "id": id,
        "superClause": superClause,
        "implementsClause": implementsClause,
        "widthClause": widthClause,
        'metadata': metadata,
        "body": body,
      };

  ///
  Map _visitArgumentList(List<Map> argumentList) =>
      {"type": "ArgumentList", "argumentList": argumentList};

  ///
  Map _visitBooleanLiteral(bool value) =>
      {"type": "BooleanLiteral", "value": value};

  ///
  Map _visitImplementsClause(List<Map> implementList) =>
      {"type": "ImplementsClause", "implements": implementList};

  ///
  Map _visitPropertyAccess(Map id, Map expression) =>
      {
        "type": "PropertyAccess",
        "id": id,
        "expression": expression,
      };

  ///
  Map _visitSimpleStringLiteral(String value) =>
      {"type": "SimpleStringLiteral", "value": value};

  ///
  Map _visitImportDirective(Map id, Map literal) =>
      {"type": "ImportDirective", "SimpleStringLiteral": literal};

  ///
  Map _visitWithClause(List<Map> widthList) => {"type":"WithClause","withs": widthList};

  @override
  Map visitCompilationUnit(CompilationUnit node) {
    // stdout.writeln("visitCompilationUnit source:${node.toSource()}");
    return _visitAstRoot(_visitNodeList(node.declarations));
  }

  @override
  Map visitBlock(Block node) {
    // stdout.writeln("visitBlock source:${node.toSource()}");
    return _visitBlock(_visitNodeList(node.statements));
  }

  @override
  Map visitBlockFunctionBody(BlockFunctionBody node) {
    // stdout.writeln("visitBlockFunctionBody source:${node.toSource()}");
    return _visitNode(node.block);
  }

  @override
  Map visitVariableDeclaration(VariableDeclaration node) {
    // stdout.writeln("visitVariableDeclaration source:${node.toSource()}");
    return _visitVariableDeclaration(
      _visitNode(node.name),
      _visitNode(node.initializer),
    );
  }

  @override
  Map visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    // stdout.writeln("visitVariableDeclarationStatement source:${node.toSource()}");
    return _visitNode(node.variables);
  }

  @override
  Map visitVariableDeclarationList(VariableDeclarationList node) {
    // stdout.writeln("visitVariableDeclarationList source:${node.toSource()}");
    return _visitVariableDeclarationList(
      _visitNode(node.type),
      _visitNodeList(node.variables),
    );
  }

  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    // stdout.writeln("visitSimpleIdentifier source:${node.toSource()}");
    return _visitIdentifier(node.name);
  }

  @override
  Map visitBinaryExpression(BinaryExpression node) {
    // stdout.writeln("visitBinaryExpression source:${node.toSource()}");
    return _visitBinaryExpression(
      _visitNode(node.leftOperand),
      _visitNode(node.rightOperand),
      node.operator.lexeme,
    );
  }

  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    // stdout.writeln("visitIntegerLiteral source:${node.toSource()}");
    return _visitNumericLiteral(node.value);
  }

  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    // stdout.writeln("visitFunctionDeclaration source:${node.toSource()}");
    return _visitFunctionDeclaration(
      _visitNode(node.name),
      _visitNode(node.functionExpression),
    );
  }

  @override
  Map visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    // stdout.writeln("visitFunctionDeclarationStatement source:${node.toSource()}");
    return _visitNode(node.functionDeclaration);
  }

  @override
  Map visitFunctionExpression(FunctionExpression node) {
    // stdout.writeln("visitFunctionExpression source:${node.toSource()}");
    return _visitFunctionExpression(
      _visitNode(node.parameters),
      _visitNode(node.body),
      isAsync: node.body.isAsynchronous,
    );
  }

  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    // stdout.writeln("visitSimpleFormalParameter source:${node.toSource()}");
    return _visitSimpleFormalParameter(
      _visitNode(node.type),
      node.identifier.name,
    );
  }

  @override
  Map visitFormalParameterList(FormalParameterList node) {
    // stdout.writeln("visitFormalParameterList source:${node.toSource()}");
    return _visitFormalParameterList(
      _visitNodeList(node.parameters),
    );
  }

  @override
  Map visitTypeName(TypeName node) {
    // stdout.writeln("visitTypeName source:${node.toSource()}");
    return _visitTypeName(node.name.name);
  }

  @override
  Map visitReturnStatement(ReturnStatement node) {
    // stdout.writeln("visitReturnStatement source:${node.toSource()}");
    return _visitReturnStatement(
      _visitNode(node.expression),
    );
  }

  @override
  Map visitMethodDeclaration(MethodDeclaration node) {
    // stdout.writeln("visitMethodDeclaration source:${node.toSource()}");
    return _visitMethodDeclaration(
        _visitNode(node.name),
        _visitNode(node.parameters),
        _visitNode(node.typeParameters),
        _visitNode(node.body),
        _visitNode(node.returnType),
        isAsync: node.body.isAsynchronous);
  }

  @override
  Map visitNamedExpression(NamedExpression node) {
    // stdout.writeln("visitNamedExpression source:${node.toSource()}");
    return _visitNamedExpression(
      _visitNode(node.name),
      _visitNode(node.expression),
    );
  }

  @override
  Map visitPrefixedIdentifier(PrefixedIdentifier node) {
    // stdout.writeln("visitPrefixedIdentifier source:${node.toSource()}");
    return _visitPrefixedIdentifier(
      _visitNode(node.identifier),
      _visitNode(node.prefix),
    );
  }

  @override
  Map visitMethodInvocation(MethodInvocation node) {
    // stdout.writeln("visitMethodInvocation source:${node.toSource()}");
    Map callee;
    if (node.target != null) {
      node.target.accept(this);
      callee = {
        "type": "MemberExpression",
        "object": _visitNode(node.target),
        "property": _visitNode(node.methodName),
      };
    } else {
      callee = _visitNode(node.methodName);
    }
    return _visitMethodInvocation(
      callee,
      _visitNode(node.typeArguments),
      _visitNode(node.argumentList),
    );
  }

  @override
  Map visitClassDeclaration(ClassDeclaration node) {
    // stdout.writeln("visitClassDeclaration source:${node.toSource()}");
    // Map id, Map superClause, Map implementsClause,  Map mixinClause, List<Map> metadata, List<Map> body
    return _visitClassDeclaration(
      _visitNode(node.name),
      _visitNode(node.extendsClause),
      _visitNode(node.implementsClause),
      _visitNode(node.withClause),
      _visitNodeList(node.metadata),
      _visitNodeList(node.members),
    );
  }

  @override
  Map visitSimpleStringLiteral(SimpleStringLiteral node) {
    // stdout.writeln("visitSimpleStringLiteral source:${node.toSource()}");
    return _visitSimpleStringLiteral(node.value);
  }

  @override
  Map visitBooleanLiteral(BooleanLiteral node) {
    // stdout.writeln("visitBooleanLiteral source:${node.toSource()}");
    return _visitBooleanLiteral(node.value);
  }

  @override
  Map visitArgumentList(ArgumentList node) {
    // stdout.writeln("visitArgumentList source:${node.toSource()}");
    return _visitArgumentList(_visitNodeList(node.arguments));
  }

  @override
  Map visitLabel(Label node) {
    // stdout.writeln("visitLabel source:${node.toSource()}");
    return _visitNode(node.label);
  }

  @override
  Map visitExtendsClause(ExtendsClause node) {
    // stdout.writeln("visitExtendsClause source:${node.toSource()}");
    return _visitNode(node.superclass);
  }

  @override
  Map visitImplementsClause(ImplementsClause node) {
    // stdout.writeln("visitImplementsClause source:${node.toSource()}");
    return _visitImplementsClause(_visitNodeList(node.interfaces));
  }

  @override
  Map visitWithClause(WithClause node) {
    stdout.writeln("visitWithClause source:${node.toSource()}");
    return _visitWithClause(_visitNodeList(node.mixinTypes));
  }

  @override
  Map visitPropertyAccess(PropertyAccess node) {
    // stdout.writeln("visitPropertyAccess source:${node.toSource()}");
    return _visitPropertyAccess(
      _visitNode(node.propertyName),
      _visitNode(node.target),
    );
  }

  @override
  Map visitImportDirective(ImportDirective node) {
    // stdout.writeln("visitImportDirective source:${node.toSource()}");
    return _visitNode(node);
  }

}

class TestAstVisitor extends GeneralizingAstVisitor<Map> {
  @override
  Map visitNode(AstNode node) {
    stdout.writeln("ast node: ${node.runtimeType}-->${node.toSource()}");
    Map map = super.visitNode(node);
    // stdout.writeln("Node json: ${jsonEncode(map)}");
    return map;
  }
}

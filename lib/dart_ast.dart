import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';
import 'util/Logger.dart';

///
void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag("file", negatable: false, abbr: 'f');

  var argResults = parser.parse(arguments);
  final paths = argResults.rest;
  if (paths.isEmpty) {
    // Logger.writeln('File not found');
  } else {
    generate(paths[0]);
  }
}

///
Future generate(String path) async {
  if (path.isEmpty) {
    Logger.writeln("File not found");
  } else {
    Logger.writeln("File path: $path");
    try {
      var parseResult =
          parseFile(path: path, featureSet: FeatureSet.fromEnableFlags([]));

      // LogUtil.writeln("File content: ${parseResult.content}");
      var compilationUnit = parseResult.unit;

      var astData = compilationUnit.accept(DartAstVisitor());
      // var astData = compilationUnit.accept(TestAstVisitor());
      Logger.writeln(convert.jsonEncode(astData));
    } catch (e) {
      // Logger.writeln('File parse error: ${e.toString()}');
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
    // LogUtil.writeln("_visitNode map: $map");
    return map;
  }

  ///
  List<Map> _visitNodeList(NodeList<AstNode> nodes) {
    if (nodes == null) {
      return null;
    }
    List<Map> maps = [];
    for (AstNode node in nodes) {
      if (node != null) {
        var map = node.accept(this);
        maps.add(map);
        // LogUtil.writeln("_visitNodeList map: $map");
      }
    }
    return maps;
  }

  /// 构造根节点
  Map visitCompilationUnit(CompilationUnit node) {
    // Logger.writeln("visitCompilationUnit source:${node.toSource()}");
    if (node.declarations.isNotEmpty) {
      return {
        "type": "Program",
        "body": _visitNodeList(node.declarations),
        "directive": _visitNodeList(node.directives),
      };
    } else {
      return null;
    }
  }

  /// 构建方法调用
  @override
  Map visitMethodInvocation(MethodInvocation node) {
    // Logger.writeln("visitMethodInvocation source:${node.toSource()}");
    Map callee;
    if (node.target != null) {
      node.target.accept(this);
      callee = {
        "type": "MemberExpression",
        "target": _visitNode(node.target),
        "property": _visitNode(node.methodName),
      };
    } else {
      callee = _visitNode(node.methodName);
    }

    Map argumentList;
    if (node.argumentList != null &&
        node.argumentList.arguments != null &&
        node.argumentList.arguments.length > 0) {
      argumentList = _visitNode(node.argumentList);
    }

    return {
      "type": "MethodInvocation",
      "callee": callee,
      "typeArguments": _visitNode(node.typeArguments),
      "argumentList": argumentList,
    };
  }

  /// 构建代码块
  @override
  Map visitBlock(Block node) {
    // Logger.writeln("visitBlock source:${node.toSource()}");
    return {
      "type": "BlockStatement",
      "statements": _visitNodeList(node.statements)
    };
  }

  @override
  Map visitBlockFunctionBody(BlockFunctionBody node) {
    // Logger.writeln("visitBlockFunctionBody source:${node.toSource()}");
    return _visitNode(node.block);
  }

  /// 构建变量声明
  @override
  Map visitVariableDeclaration(VariableDeclaration node) {
    // Logger.writeln("visitVariableDeclaration source:${node.toSource()}");
    return {
      "type": "VariableDeclarator",
      "name": _visitNode(node.name),
      "init": _visitNode(node.initializer),
    };
  }

  @override
  Map visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    // Logger.writeln("visitVariableDeclarationStatement source:${node.toSource()}");
    return _visitNode(node.variables);
  }

  /// 构建变量声明
  @override
  Map visitVariableDeclarationList(VariableDeclarationList node) {
    // Logger.writeln("visitVariableDeclarationList source:${node.toSource()}");
    return {
      "type": "VariableDeclarationList",
      "typeAnnotation": _visitNode(node.type),
      "declarations": _visitNodeList(node.variables),
    };
  }

  /// 构造标识符定义
  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    // Logger.writeln("visitSimpleIdentifier source:${node.toSource()}");
    return {"type": "Identifier", "value": node.name};
  }

  @override
  Map visitDeclaredIdentifier(DeclaredIdentifier node) {
    // Logger.writeln("visitDeclaredIdentifier source:${node.toSource()}");
    return {
      "type": "DeclaredIdentifier",
      "declared": _visitNode(node.identifier)
    };
  }

  // Map visitExpression(Expression node) {
  //   Logger.writeln("visitExpression source:${node.toSource()}");
  //   return null;
  // }

  @override
  Map visitExpressionFunctionBody(ExpressionFunctionBody node) {
    // Logger.writeln("visitExpressionFunctionBody source:${node.toSource()}");
    return {
      "type": "ExpressionFunctionBody",
      "expression": _visitNode(node.expression),
    };
  }

  @override
  Map visitExpressionStatement(ExpressionStatement node) {
    // Logger.writeln("visitExpressionStatement source:${node.toSource()}");
    return {
      "type": "ExpressionStatement",
      "expression": _visitNode(node.expression),
    };
  }

  /// 构造运算表达式结构
  @override
  Map visitBinaryExpression(BinaryExpression node) {
    // Logger.writeln("visitBinaryExpression source:${node.toSource()}");
    return {
      "type": "BinaryExpression",
      "operator": node.operator.lexeme,
      "left": _visitNode(node.leftOperand),
      "right": _visitNode(node.rightOperand)
    };
  }

  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    // Logger.writeln("visitIntegerLiteral source:${node.toSource()}");
    return {"type": "IntegerLiteral", "value": node.value};
  }

  /// 构建函数声明
  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    // Logger.writeln("visitFunctionDeclaration source:${node.toSource()}");
    return {
      "type": "FunctionDeclaration",
      "name": _visitNode(node.name),
      "expression": _visitNode(node.functionExpression),
    };
  }

  @override
  Map visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    // Logger.writeln("visitFunctionDeclarationStatement source:${node.toSource()}");
    return _visitNode(node.functionDeclaration);
  }

  /// 构建函数表达式
  @override
  Map visitFunctionExpression(FunctionExpression node) {
    // Logger.writeln("visitFunctionExpression source:${node.toSource()}");
    return {
      "type": "FunctionExpression",
      "parameters": _visitNode(node.parameters),
      "body": _visitNode(node.body),
      "isAsync": node.body.isAsynchronous,
    };
  }

  /// 构造函数参数
  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    // Logger.writeln("visitSimpleFormalParameter source:${node.toSource()}");
    return {
      "type": "SimpleFormalParameter",
      "parameterType": _visitNode(node.type),
      "name": node.identifier.name
    };
  }

  /// 构造函数参数
  @override
  Map visitFormalParameterList(FormalParameterList node) {
    // Logger.writeln("visitFormalParameterList source:${node.toSource()}");

    List<Map> parameterList;
    if (node.parameters != null && node.parameters.length > 0) {
      parameterList = _visitNodeList(node.parameters);
    }
    return {"type": "FormalParameterList", "parameterList": parameterList};
  }

  /// 构造函数参数类型
  @override
  Map visitTypeName(TypeName node) {
    // Logger.writeln("visitTypeName source:${node.toSource()}");
    return {
      "type": "TypeName",
      "name": node.name.name,
    };
  }

  /// 构建返回类型
  @override
  Map visitReturnStatement(ReturnStatement node) {
    // Logger.writeln("visitReturnStatement source:${node.toSource()}");
    return {
      "type": "ReturnStatement",
      "expression": _visitNode(node.expression),
    };
  }

  /// 构建方法
  @override
  Map visitMethodDeclaration(MethodDeclaration node) {
    // Logger.writeln("visitMethodDeclaration source:${node.toSource()}");
    return {
      "type": "MethodDeclaration",
      "name": _visitNode(node.name),
      "parameters": _visitNode(node.parameters),
      "typeParameters": _visitNode(node.typeParameters),
      "body": _visitNode(node.body),
      "isAsync": node.body.isAsynchronous,
      "returnType": _visitNode(node.returnType),
    };
  }

  @override
  Map visitNamedExpression(NamedExpression node) {
    // Logger.writeln("visitNamedExpression source:${node.toSource()}");
    return {
      "type": "NamedExpression",
      "name": _visitNode(node.name),
      "expression": _visitNode(node.expression),
    };
  }

  @override
  Map visitPrefixedIdentifier(PrefixedIdentifier node) {
    // Logger.writeln("visitPrefixedIdentifier source:${node.toSource()}");
    return {
      "type": "PrefixedIdentifier",
      "identifier": _visitNode(node.identifier),
      "prefix": _visitNode(node.prefix),
    };
  }

  @override
  Map visitClassDeclaration(ClassDeclaration node) {
    // Logger.writeln("visitClassDeclaration source:${node.toSource()}");

    List<Map> metadata;
    if (node.metadata != null && node.metadata.length > 0) {
      metadata = _visitNodeList(node.metadata);
    }
    return {
      "type": "ClassDeclaration",
      "name": _visitNode(node.name),
      "superClause": _visitNode(node.extendsClause),
      "implementsClause": _visitNode(node.implementsClause),
      "widthClause": _visitNode(node.withClause),
      'metadata': metadata,
      "body": _visitNodeList(node.members),
    };
  }

  @override
  Map visitSimpleStringLiteral(SimpleStringLiteral node) {
    // Logger.writeln("visitSimpleStringLiteral source:${node.toSource()}");
    return {"type": "StringLiteral", "value": node.value};
  }

  @override
  Map visitBooleanLiteral(BooleanLiteral node) {
    // Logger.writeln("visitBooleanLiteral source:${node.toSource()}");
    return {"type": "BooleanLiteral", "value": node.value};
  }

  @override
  Map visitArgumentList(ArgumentList node) {
    // Logger.writeln("visitArgumentList source:${node.toSource()}");
    return {
      "type": "ArgumentList",
      "argumentList": _visitNodeList(node.arguments)
    };
  }

  @override
  Map visitLabel(Label node) {
    // Logger.writeln("visitLabel source:${node.toSource()}");
    return _visitNode(node.label);
  }

  @override
  Map visitExtendsClause(ExtendsClause node) {
    // Logger.writeln("visitExtendsClause source:${node.toSource()}");
    return _visitNode(node.superclass);
  }

  @override
  Map visitImplementsClause(ImplementsClause node) {
    // Logger.writeln("visitImplementsClause source:${node.toSource()}");
    return {
      "type": "ImplementsClause",
      "implements": _visitNodeList(node.interfaces)
    };
  }

  @override
  Map visitWithClause(WithClause node) {
    // Logger.writeln("visitWithClause source:${node.toSource()}");
    return {"type": "WithClause", "withs": _visitNodeList(node.mixinTypes)};
  }

  @override
  Map visitPropertyAccess(PropertyAccess node) {
    // Logger.writeln("visitPropertyAccess source:${node.toSource()}");
    return {
      "type": "PropertyAccess",
      "name": _visitNode(node.propertyName),
      "target": _visitNode(node.target),
    };
  }

  @override
  Map visitHideCombinator(HideCombinator node) {
    // Logger.writeln("visitHideCombinator source:${node.toSource()}");
    return {
      "type": "HideCombinator ",
      "hiddenNames": _visitNodeList(node.hiddenNames)
    };
  }

  @override
  Map visitShowCombinator(ShowCombinator node) {
    // Logger.writeln("visitShowCombinator source:${node.toSource()}");
    return {
      "type": "ShowCombinator ",
      "shownNames": _visitNodeList(node.shownNames)
    };
  }

  /// 构建import数据组
  @override
  Map visitImportDirective(ImportDirective node) {
    // Logger.writeln("visitImportDirective source:${node.toSource()}");

    // LogUtil.writeln( "visitImportDirective uri:${node.uri}, asKeyword:${node.asKeyword}, prefix:${node.prefix}");

    List<Map> combinators;
    if (node.combinators != null) {
      combinators = _visitNodeList(node.combinators);
    }

    return {
      "type": "ImportDirective",
      "uri": _visitNode(node.uri),
      "prefix": _visitNode(node.prefix), // prefix为 as 的昵称
      "combinators": combinators
    };
  }
}

class TestAstVisitor extends GeneralizingAstVisitor<Map> {
  @override
  Map visitNode(AstNode node) {
    Logger.writeln("ast node: ${node.runtimeType}-->${node.toSource()}");
    Map map = super.visitNode(node);
    return map;
  }
}

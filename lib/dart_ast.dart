import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';
import 'util/Logger.dart';
import 'compiler/node/ast_node_key.dart';
import 'compiler/node/ast_node_type.dart';

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
      // var astData = compilationUnit.accept(OrgAstVisitor());
      Logger.writeln(convert.jsonEncode(astData));
    } catch (e) {
      Logger.writeln('File parse error: ${e.toString()}');
    }
  }
}

/// compiler.ast 生成器
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
    if (node.declarations.isEmpty) return null;
    List<Map> declarations;
    List<Map> directives;
    if (node.declarations != null && node.declarations.length > 0) {
      declarations = _visitNodeList(node.declarations);
    }
    if (node.directives != null && node.directives.length > 0) {
      directives = _visitNodeList(node.directives);
    }
    return {
      AstNodeKey.type: AstNodeType.Program,
      AstNodeKey.body: declarations,
      AstNodeKey.directive: directives,
    };
  }

  /// 构建方法调用
  @override
  Map visitMethodInvocation(MethodInvocation node) {
    // Logger.writeln("visitMethodInvocation source:${node.toSource()}");
    Map callee;
    if (node.target != null) {
      node.target.accept(this);
      callee = {
        AstNodeKey.type: AstNodeType.MemberExpression,
        AstNodeKey.target: _visitNode(node.target),
        AstNodeKey.property: _visitNode(node.methodName),
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
      AstNodeKey.type: AstNodeType.MethodInvocation,
      AstNodeKey.callee: callee,
      AstNodeKey.typeArguments: _visitNode(node.typeArguments),
      AstNodeKey.argumentList: argumentList,
    };
  }

  /// 构建代码块
  @override
  Map visitBlock(Block node) {
    // Logger.writeln("visitBlock source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.BlockStatement,
      AstNodeKey.statements: _visitNodeList(node.statements)
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
      AstNodeKey.type: AstNodeType.VariableDeclarator,
      AstNodeKey.name: _visitNode(node.name),
      AstNodeKey.init: _visitNode(node.initializer),
    };
  }

  @override
  Map visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    // Logger.writeln("visitVariableDeclarationStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.VariableDeclarationStatement,
      AstNodeKey.variables: _visitNode(node.variables),
    };
    return _visitNode(node.variables);
  }

  /// 构建变量声明
  @override
  Map visitVariableDeclarationList(VariableDeclarationList node) {
    // Logger.writeln("visitVariableDeclarationList source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.VariableDeclarationList,
      AstNodeKey.typeAnnotation: _visitNode(node.type),
      AstNodeKey.declarations: _visitNodeList(node.variables),
    };
  }

  /// 构造标识符定义
  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    // Logger.writeln("visitSimpleIdentifier source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.Identifier,
      AstNodeKey.value: node.name,
    };
  }

  @override
  Map visitDeclaredIdentifier(DeclaredIdentifier node) {
    // Logger.writeln("visitDeclaredIdentifier source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.DeclaredIdentifier,
      AstNodeKey.identifier: _visitNode(node.identifier)
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
      AstNodeKey.type: AstNodeType.ExpressionFunctionBody,
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  @override
  Map visitExpressionStatement(ExpressionStatement node) {
    // Logger.writeln("visitExpressionStatement source:${node.toSource()}");
    if (node.expression == null) {
      return null;
    }
    return {
      AstNodeKey.type: AstNodeType.ExpressionStatement,
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  @override
  Map visitAssignmentExpression(AssignmentExpression node) {
    return {
      AstNodeKey.type: AstNodeType.ExpressionStatement,
      AstNodeKey.rightHandSide: _visitNode(node.rightHandSide),
      AstNodeKey.leftHandSide: _visitNode(node.leftHandSide),
      AstNodeKey.operator: node.operator.lexeme,
    };
  }

  @override
  Map visitTryStatement(TryStatement node) {
    // Logger.writeln("visitTryStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.TryStatement,
      AstNodeKey.body: _visitNode(node.body),
      AstNodeKey.finallyBlock: _visitNode(node.finallyBlock),
      AstNodeKey.catchClauses: _visitNodeList(node.catchClauses),
    };
  }

  @override
  Map visitTypeArgumentList(TypeArgumentList node) {
    // Logger.writeln("visitTypeArgumentList source:${node.toSource()}");
    if (node.arguments == null || node.arguments.length == 0) {
      return null;
    }
    return {
      AstNodeKey.type: AstNodeType.ArgumentList,
      AstNodeKey.arguments: _visitNodeList(node.arguments),
    };
  }

  @override
  Map visitStringInterpolation(StringInterpolation node) {
    // Logger.writeln("visitStringInterpolation source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.StringInterpolation,
      AstNodeKey.elements: _visitNodeList(node.elements),
    };
  }

  @override
  Map visitInterpolationExpression(InterpolationExpression node) {
    // Logger.writeln("visitInterpolationExpression source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.InterpolationExpression,
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  @override
  Map visitInterpolationString(InterpolationString node) {
    // Logger.writeln("visitInterpolationString source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.InterpolationString,
      AstNodeKey.value: node.value,
    };
  }

  /// 构造运算表达式结构
  @override
  Map visitBinaryExpression(BinaryExpression node) {
    // Logger.writeln("visitBinaryExpression source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.BinaryExpression,
      AstNodeKey.operator: node.operator.lexeme,
      AstNodeKey.left: _visitNode(node.leftOperand),
      AstNodeKey.right: _visitNode(node.rightOperand)
    };
  }

  @override
  Map visitSimpleStringLiteral(SimpleStringLiteral node) {
    // Logger.writeln("visitSimpleStringLiteral source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.StringLiteral,
      AstNodeKey.value: node.value,
    };
  }

  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    // Logger.writeln("visitIntegerLiteral source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.IntegerLiteral,
      AstNodeKey.value: node.value,
    };
  }

  @override
  Map visitBooleanLiteral(BooleanLiteral node) {
    // Logger.writeln("visitBooleanLiteral source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.BooleanLiteral,
      AstNodeKey.value: node.value,
    };
  }

  @override
  Map visitDoubleLiteral(DoubleLiteral node) {
    // Logger.writeln("visitDoubleLiteral source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.DoubleLiteral,
      AstNodeKey.value: node.value,
    };
  }

  ///  {"expression":{"type":"ListLiteral","value":[]}}
  @override
  Map visitListLiteral(ListLiteral node) {
    // Logger.writeln("visitListLiteral source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ListLiteral,
      AstNodeKey.value: _visitNodeList(node.elements),
    };
  }

  @override
  Map visitMapLiteralEntry(MapLiteralEntry node) {
    // Logger.writeln("visitMapLiteralEntry source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.SetOrMapLiteral,
      AstNodeKey.key: _visitNode(node.key),
      AstNodeKey.value: _visitNode(node.value),
    };
  }

  /// 构建函数声明
  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    // Logger.writeln("visitFunctionDeclaration source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.FunctionDeclaration,
      AstNodeKey.name: _visitNode(node.name),
      AstNodeKey.expression: _visitNode(node.functionExpression),
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
    Map parameters;
    if (node.parameters != null && node.parameters.length > 0) {
      parameters = _visitNode(node.parameters);
    }
    return {
      AstNodeKey.type: AstNodeType.FunctionExpression,
      AstNodeKey.parameters: parameters,
      AstNodeKey.body: _visitNode(node.body),
      AstNodeKey.isAsync: node.body.isAsynchronous,
    };
  }

  /// 构造函数参数
  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    // Logger.writeln("visitSimpleFormalParameter source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.SimpleFormalParameter,
      AstNodeKey.parameterType: _visitNode(node.type),
      AstNodeKey.name: node.identifier.name
    };
  }

  /// 构造函数参数
  @override
  Map visitFormalParameterList(FormalParameterList node) {
    // Logger.writeln("visitFormalParameterList source:${node.toSource()}");

    List<Map> parameterList;
    if (node.parameters != null && node.parameters.length > 0) {
      return {
        AstNodeKey.type: AstNodeType.FormalParameterList,
        AstNodeKey.parameterList: _visitNodeList(node.parameters)
      };
    }
    return null;
  }

  /// 构造函数参数类型
  @override
  Map visitTypeName(TypeName node) {
    // Logger.writeln("visitTypeName source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.TypeName,
      AstNodeKey.name: node.name.name,
    };
  }

  /// 构建返回类型
  @override
  Map visitReturnStatement(ReturnStatement node) {
    // Logger.writeln("visitReturnStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ReturnStatement,
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  /// 构建方法
  @override
  Map visitMethodDeclaration(MethodDeclaration node) {
    // Logger.writeln("visitMethodDeclaration source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.MethodDeclaration,
      AstNodeKey.name: _visitNode(node.name),
      AstNodeKey.parameters: _visitNode(node.parameters),
      AstNodeKey.typeParameters: _visitNode(node.typeParameters),
      AstNodeKey.body: _visitNode(node.body),
      AstNodeKey.isAsync: node.body.isAsynchronous,
      AstNodeKey.returnType: _visitNode(node.returnType),
    };
  }

  @override
  Map visitNamedExpression(NamedExpression node) {
    // Logger.writeln("visitNamedExpression source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.NamedExpression,
      AstNodeKey.name: _visitNode(node.name),
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  @override
  Map visitPrefixedIdentifier(PrefixedIdentifier node) {
    // Logger.writeln("visitPrefixedIdentifier source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.PrefixedIdentifier,
      AstNodeKey.identifier: _visitNode(node.identifier),
      AstNodeKey.prefix: _visitNode(node.prefix),
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
      AstNodeKey.type: AstNodeType.ClassDeclaration,
      AstNodeKey.name: _visitNode(node.name),
      AstNodeKey.superClause: _visitNode(node.extendsClause),
      AstNodeKey.implementsClause: _visitNode(node.implementsClause),
      AstNodeKey.widthClause: _visitNode(node.withClause),
      AstNodeKey.metadata: metadata,
      AstNodeKey.body: _visitNodeList(node.members),
    };
  }

  @override
  Map visitArgumentList(ArgumentList node) {
    // Logger.writeln("visitArgumentList source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeKey.argumentList,
      AstNodeKey.argumentList: _visitNodeList(node.arguments)
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
      AstNodeKey.type: AstNodeType.ImplementsClause,
      AstNodeKey.implements: _visitNodeList(node.interfaces)
    };
  }

  @override
  Map visitWithClause(WithClause node) {
    // Logger.writeln("visitWithClause source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.WithClause,
      "withs": _visitNodeList(node.mixinTypes),
    };
  }

  @override
  Map visitPropertyAccess(PropertyAccess node) {
    // Logger.writeln("visitPropertyAccess source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.PropertyAccess,
      AstNodeKey.name: _visitNode(node.propertyName),
      "target": _visitNode(node.target),
    };
  }

  @override
  Map visitHideCombinator(HideCombinator node) {
    // Logger.writeln("visitHideCombinator source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.HideCombinator,
      AstNodeKey.hiddenNames: _visitNodeList(node.hiddenNames)
    };
  }

  @override
  Map visitShowCombinator(ShowCombinator node) {
    // Logger.writeln("visitShowCombinator source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ShowCombinator,
      AstNodeKey.shownNames: _visitNodeList(node.shownNames)
    };
  }

  /// 构建import数据组
  @override
  Map visitImportDirective(ImportDirective node) {
    // Logger.writeln("visitImportDirective source:${node.toSource()}");

    // LogUtil.writeln( "visitImportDirective uri:${node.uri}, asKeyword:${node.asKeyword}, prefix:${node.prefix}");

    List<Map> combinators;
    if (node.combinators != null && node.combinators.length > 0) {
      combinators = _visitNodeList(node.combinators);
    }

    return {
      AstNodeKey.type: AstNodeType.ImportDirective,
      AstNodeKey.uri: _visitNode(node.uri),
      AstNodeKey.prefix: _visitNode(node.prefix), // prefix为 as 的昵称
      AstNodeKey.combinators: combinators
    };
  }

  @override
  Map visitIfStatement(IfStatement node) {
    // Logger.writeln("visitIfStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.IfStatement,
      AstNodeKey.condition: _visitNode(node.condition),
      AstNodeKey.thenStatement: _visitNode(node.thenStatement),
      AstNodeKey.elseStatement: _visitNode(node.elseStatement),
    };
  }

  @override
  Map visitSwitchCase(SwitchCase node) {
    // Logger.writeln("visitSwitchCase source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.SwitchCase,
      AstNodeKey.expression: _visitNode(node.expression),
    };
  }

  @override
  Map visitSwitchDefault(SwitchDefault node) {
    // Logger.writeln("visitSwitchDefault source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.SwitchDefault,
      AstNodeKey.labels: _visitNodeList(node.labels),
      AstNodeKey.statements: _visitNodeList(node.statements),
    };
  }

  @override
  Map visitSwitchStatement(SwitchStatement node) {
    // Logger.writeln("visitSwitchStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.SwitchStatement,
      AstNodeKey.expression: _visitNode(node.expression),
      AstNodeKey.members: _visitNodeList(node.members),
    };
  }

  @override
  Map visitBreakStatement(BreakStatement node) {
    // Logger.writeln("visitBreakStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.BreakStatement,
      AstNodeKey.label: "break",
    };
  }

  @override
  Map visitForStatement(ForStatement node) {
    // Logger.writeln("visitForStatement source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ForStatement,
      AstNodeKey.body: _visitNode(node.body),
      AstNodeKey.forLoopParts: _visitNode(node.forLoopParts),
    };
  }

  @override
  Map visitForPartsWithDeclarations(ForPartsWithDeclarations node) {
    // Logger.writeln("visitForPartsWithDeclarations source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ForPartsWithDeclarations,
      AstNodeKey.variables: _visitNode(node.variables),
    };
  }

  @override
  Map visitForPartsWithExpression(ForPartsWithExpression node) {
    // Logger.writeln("visitForPartsWithExpression source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.ForPartsWithExpression,
      AstNodeKey.initialization: _visitNode(node.initialization),
    };
  }

  @override
  Map visitPostfixExpression(PostfixExpression node) {
    // Logger.writeln("visitPostfixExpression source:${node.toSource()}");
    return {
      AstNodeKey.type: AstNodeType.PostfixExpression,
      AstNodeKey.operand: _visitNode(node.operand),
    };
  }
  
} // end DartAstVisitor

/// 用于未封装前的[AstNode]数据展示，通过输出[AstNode.runtimeType]可以判断需要封住的内容
class OrgAstVisitor extends GeneralizingAstVisitor<Map> {
  @override
  Map visitNode(AstNode node) {
    Logger.writeln("ast node: ${node.runtimeType}-->${node.toSource()}");
    Map map = super.visitNode(node);
    return map;
  }
}

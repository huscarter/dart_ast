import 'dart:convert';

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_textspan.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/runtime/argument/arg_text.dart';
import 'package:dart_ast/util/logger.dart';
import 'package:flutter/material.dart';

///
class AstSliverGrid extends AstWidget {
  ///
  static final String tag = "AstSliverGrid";

  AstSliverGrid(Expression node) : super(node);

  @override
  Widget build() {
    // Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return SliverGrid();

    SliverGridDelegateWithMaxCrossAxisExtent gridDelegate;
    SliverChildBuilderDelegate delegate;
    // all is [NamedExpression]
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        // 使用字符串赋值
        case "gridDelegate":
          gridDelegate = RuntimeFactory.buildWidget(arg.expression);
          break;
        case "delegate":
          delegate = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    return SliverGrid(
      gridDelegate: gridDelegate,
      delegate: delegate,
    );
  }
}

///
class AstSliverGridDelegateWithMaxCrossAxisExtent extends AstWidget {
  ///
  static final String tag = "AstSliverGridDelegateWithMaxCrossAxisExtent";

  AstSliverGridDelegateWithMaxCrossAxisExtent(Expression node) : super(node);

  @override
  SliverGridDelegateWithMaxCrossAxisExtent build() {
// Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return null;
    double maxCrossAxisExtent;
    double mainAxisSpacing;
    double crossAxisSpacing;
    double childAspectRatio;

    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
        case "maxCrossAxisExtent":
          maxCrossAxisExtent = arg.expression.value;
          break;
        case "mainAxisSpacing":
          mainAxisSpacing = arg.expression.value;
          break;
        case "crossAxisSpacing":
          crossAxisSpacing = arg.expression.value;
          break;
        case "childAspectRatio":
          childAspectRatio = arg.expression.value;
          break;
        default:
          break;
      }
    }

    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}

///{
///     "type":"MethodInvocation",
///     "callee":{
///         "type":"Identifier",
///         "value":"SliverChildBuilderDelegate"
///     },
///     "typeArguments":null,
///     "argumentList":{
///         "type":"argumentList",
///         "argumentList":[
///             {
///                 "type":"FunctionExpression",
///                 "parameters":{
///                     "type":"FormalParameterList",
///                     "parameterList":[
///                         {
///                             "type":"SimpleFormalParameter",
///                             "parameterType":{
///                                 "type":"TypeName",
///                                 "name":"BuildContext"
///                             },
///                             "name":"context"
///                         },
///                         {
///                             "type":"SimpleFormalParameter",
///                             "parameterType":{
///                                 "type":"TypeName",
///                                 "name":"int"
///                             },
///                             "name":"index"
///                         }
///                     ]
///                 },
///                 "body":{
///                     "type":"BlockStatement",
///                     "statements":[
///                         {
///                             "type":"ReturnStatement",
///                             "expression":{
///                                 "type":"MethodInvocation",
///                                 "callee":{
///                                     "type":"Identifier",
///                                     "value":"Container"
///                                 },
///                                 "typeArguments":null,
///                                 "argumentList":{
///                                     "type":"argumentList",
///                                     "argumentList":[
///                                         {
///                                             "type":"NamedExpression",
///                                             "name":{
///                                                 "type":"Identifier",
///                                                 "value":"alignment"
///                                             },
///                                             "expression":{
///                                                 "type":"PrefixedIdentifier",
///                                                 "identifier":{
///                                                     "type":"Identifier",
///                                                     "value":"center"
///                                                 },
///                                                 "prefix":{
///                                                     "type":"Identifier",
///                                                     "value":"Alignment"
///                                                 }
///                                             }
///                                         },
///                                         {
///                                             "type":"NamedExpression",
///                                             "name":{
///                                                 "type":"Identifier",
///                                                 "value":"color"
///                                             },
///                                             "expression":null
///                                         },
///                                         {
///                                             "type":"NamedExpression",
///                                             "name":{
///                                                 "type":"Identifier",
///                                                 "value":"child"
///                                             },
///                                             "expression":{
///                                                 "type":"MethodInvocation",
///                                                 "callee":{
///                                                     "type":"Identifier",
///                                                     "value":"Text"
///                                                 },
///                                                 "typeArguments":null,
///                                                 "argumentList":{
///                                                     "type":"argumentList",
///                                                     "argumentList":[
///                                                         null
///                                                     ]
///                                                 }
///                                             }
///                                         }
///                                     ]
///                                 }
///                             }
///                         }
///                     ]
///                 },
///                 "isAsync":false
///             },
///             {
///                 "type":"NamedExpression",
///                 "name":{
///                     "type":"Identifier",
///                     "value":"childCount"
///                 },
///                 "expression":{
///                     "type":"IntegerLiteral",
///                     "value":20
///                 }
///             }
///         ]
///     }
/// }
///
class AstSliverChildBuilderDelegate extends AstWidget {
  ///
  static final String tag = "AstSliverChildBuilderDelegate";

  AstSliverChildBuilderDelegate(Expression node) : super(node);

  @override
  SliverChildBuilderDelegate build() {
// Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return null;
    int childCount;
    List<BlockStatement> astNodes;
    for (TypeArgument arg in node.argumentList) {
      switch (arg.type) {
        case AstNodeType.NamedExpression:
          if (arg.name.value == "childCount") {
            childCount = arg.expression.value;
          }
          break;
        case AstNodeType.FunctionExpression:
          astNodes = arg.body;
          break;
        default:
          break;
      }
    }

    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        Expression widgetExpression;
        for (BlockStatement tempNode in astNodes) {
          if (tempNode.type == AstNodeType.ReturnStatement) {
            widgetExpression = tempNode.expression;
            break;
          }
        }
        // Logger.out(tag, msg);
        return RuntimeFactory.buildWidget(widgetExpression);
      },
      childCount: childCount,
    );
  }
}

///
class AstSliverFixedExtentList extends AstWidget {
  ///
  static final String tag = "AstSliverFixedExtentList";

  AstSliverFixedExtentList(Expression node) : super(node);

  @override
  Widget build() {
    // Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return SliverFixedExtentList();

    double itemExtent;
    SliverChildBuilderDelegate delegate;
    // all is [NamedExpression]
    for (TypeArgument arg in node.argumentList) {
      switch (arg.name.value) {
      // 使用字符串赋值
        case "itemExtent":
          itemExtent = arg.expression.value;
          break;
        case "delegate":
          delegate = RuntimeFactory.buildWidget(arg.expression);
          break;
        default:
          break;
      }
    }
    return SliverFixedExtentList(
      itemExtent: itemExtent,
      delegate: delegate,
    );
  }
}

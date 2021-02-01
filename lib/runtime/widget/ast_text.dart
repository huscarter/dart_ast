import 'dart:convert';

import 'package:dart_ast/ast/ast_node.dart';
import 'package:dart_ast/ast/ast_node_type.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:dart_ast/runtime/widget/ast_textspan.dart';
import 'package:dart_ast/runtime/widget/ast_widget.dart';
import 'package:dart_ast/runtime/argument/arg_text.dart';
import 'package:flutter/material.dart';

/// ```dart
/// Text(
///   'Hello, $_name! How are you?',
///   textAlign: TextAlign.center,
///   overflow: TextOverflow.ellipsis,
///   style: TextStyle(fontWeight: FontWeight.bold),
/// )
/// ```
/// {@end-tool}
///
/// Using the [Text.rich] constructor, the [Text] widget can
/// display a paragraph with differently styled [TextSpan]s. The sample
/// that follows displays "Hello beautiful world" with different styles
/// for each word.
///
/// {@tool snippet}
///
/// ![The word "Hello" is shown with the default text styles. The word "beautiful" is italicized. The word "world" is bold.](https://flutter.github.io/assets-for-api-docs/assets/widgets/text_rich.png)
///
/// ```dart
/// const Text.rich(
///   TextSpan(
///     text: 'Hello', // default text style
///     children: <TextSpan>[
///       TextSpan(text: ' beautiful ', style: TextStyle(fontStyle: FontStyle.italic)),
///       TextSpan(text: 'world', style: TextStyle(fontWeight: FontWeight.bold)),
///     ],
///   ),
/// )
/// ```
///
///
class AstText extends AstWidget {
  ///
  static final String tag = "AstText";
  ///
  static final String tagProperty = "AstText.rich";

  AstText(Expression node) : super(node);

  @override
  Widget build() {
    // Logger.out(tag, "node:${jsonEncode(node)}");
    if (node.argumentList == null) return Text("");
    String text = "";
    TextSpan textSpan;
    TextStyle textStyle;

    for (dynamic arg in node.argumentList) {
      switch (arg.type) {
        // 使用字符串赋值
        case AstNodeType.StringLiteral:
          text = arg.value;
          break;
        // 使用TextSpan
        case AstNodeType.MethodInvocation:
          textSpan = RuntimeFactory.buildWidget(arg as Expression);
          break;
        // style:{}
        case AstNodeType.NamedExpression:
          var calleeValue = arg.name.value;
          if (calleeValue == "style") {
            textStyle = ArgText.buildTextStyle(arg.expression);
          }
          break;
        default:
          break;
      }
    }

    // use Text.rich
    // {"type":"MemberExpression", "target":{"type":"Identifier", "value":"Text"}, "property":{"type":"Identifier","value":"rich"}}
    if (node.callee.type == AstNodeType.MemberExpression) {
      return Text.rich(
        textSpan,
        style: textStyle,
      );
    }
    // use Text
    else {
      return Text(
        text,
        style: textStyle,
      );
    } // end else if not Text.rich
  }
}

import 'package:dart_ast/compiler/node/ast_node.dart';
import 'package:dart_ast/compiler/node/ast_node_type.dart';
import 'package:dart_ast/runtime/runtime_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 运行时page，通过解析[AstNode]生成页面布局
class RuntimePage extends StatefulWidget {
  final AstNode astNode;

  RuntimePage(this.astNode, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RuntimePageState();
}

///
class _RuntimePageState extends State<RuntimePage> {
  Widget _astWidget;
  Widget _loadWidget;

  ///
  @override
  void initState() {
    super.initState();
    //
    _loadWidget = Center(
      child: SizedBox.fromSize(
        size: Size.square(30),
        child: CircularProgressIndicator(),
      ),
    );

    _buildAstWidget();
  }

  ///
  void _setState() {
    if (mounted) {
      setState(() {});
    }
  }

  /// [widget.astNode]是整个页面dart文件的数据，真正页面布局的数据是在"build"方法里，
  /// 所以构建widget时需要取出build方法里的内容交给[RuntimeFactory]处理。
  void _buildAstWidget() async {
    Program program = widget.astNode as Program;
    for (ClassDeclaration body in program.classBody) {
      if (isBuildClass(body.superClause.name)) {
        // 是布局class
        for (MethodDeclaration method in body.body) {
          // 是布局方法"build"
          if (method.name.value == "build") {
            for (BlockStatement statement in method.body) {
              // 是返回体widget
              if (statement.type == AstNodeType.ReturnStatement) {
                _astWidget = RuntimeFactory.buildWidget(statement.expression);
                _setState();
                break;
              }
            }
          }
        }
        break;
      }
    }
  }

  /// 判断布局class
  bool isBuildClass(String name) {
    return name == "StatelessWidget" ||
        name == "StatelessPage" ||
        name == "State" ||
        name == "BaseState";
  }

  ///
  @override
  Widget build(BuildContext context) => _astWidget ?? _loadWidget;
}

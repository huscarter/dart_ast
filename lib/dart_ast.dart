import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag("file", negatable: false, abbr: 'f');

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
    try {
      var parseResult =
      parseFile(path: path, featureSet: FeatureSet.fromEnableFlags([]));
      var compilationUnit = parseResult.unit;
      compilationUnit.accept(TestAstVisitor());
    } catch (e) {
      stdout.writeln('File parse error: ${e.toString()}');
    }
  }
}

///
class DartAst extends SimpleAstVisitor<Map> {
  ///
  Map _visitNode(AstNode node) {
    if (node == null) {
      return null;
    }
    return node.accept(this);
  }

  ///
  List<Map> _visitNodeList(NodeList<AstNode> nodes) {
    List<Map> maps = [];
    nodes = nodes ?? [];

    for (AstNode node in nodes) {
      if (node != null) {
        maps.add(node.accept(this));
      }
    }
    return maps;
  }
}

class TestAstVisitor extends GeneralizingAstVisitor<Map>{
  @override
  Map visitNode(AstNode node){
    stdout.write(node.accept(this));
    return super.visitNode(node);
  }
}

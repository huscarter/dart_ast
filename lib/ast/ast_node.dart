///
class AstNode {
  String type;

  Map map;

  AstNode({String type, Map map}) {
    if (this.type == null) {
      this.type = map == null ? null : map["type"];
    } else {
      this.type = type;
    }
    this.map = map;
  }
}

///
class Program extends AstNode {
  List<AstNode> body;
  List<AstNode> directive;

  Program.fromMap(Map map) :super(map:map){
    body = [];
    for (Map map in map["body"]) {
      body.add(AstNode(map: map));
    }

    directive = [];
    for (Map map in map["body"]) {
      directive.add(AstNode(map: map));
    }
  }
}

///
class Identifier extends AstNode {
  String name;

  Identifier(String name, {Map map}) : super(map: map) {
    this.name = name;
  }
}

///
class ParameterType extends AstNode{
  String name;

  ParameterType(String name, {Map map}) : super(map: map) {
    this.name = name;
  }
}

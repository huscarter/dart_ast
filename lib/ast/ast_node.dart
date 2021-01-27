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

  Program(List<AstNode> body, List<AstNode> directive, {Map map})
      : super(map: map);

  Program.fromMap(Map map) {
    List<AstNode> bodies = [];
    for (Map map in map["body"]) {
      bodies.add(AstNode(map: map));
    }

    List<AstNode> directives = [];
    for (Map map in map["body"]) {
      directives.add(AstNode(map: map));
    }

    Program(bodies, directives, map: map);
  }
}

///
class Identifier extends AstNode {
  String name;

  Identifier(String name, {Map map}) : super(map: map) {
    this.name = name;
  }
}

///
class AstNodeKey {
  AstNodeKey._();

  ///
  static const String type = "type";

  ///
  static const String body = "body";
  static const String name = "name";
  static const String superClause = "superClause";
  static const String implementsClause = "implementsClause";
  static const String widthClause = "widthClause";
  static const String metadata = "metadata";
  static const String fields = "fields";
  static const String isStatic = "isStatic";

  ///
  static const String parameters = "parameters";
  static const String parameterType = "parameterType";
  static const String parameterList = "parameterList";
  static const String typeParameters = "typeParameters";
  static const String isAsync = "isAsync";
  static const String returnType = "returnType";

  ///
  static const String expression = "expression";
  static const String callee = "callee";
  static const String argumentList = "argumentList";
  static const String typeArguments = "typeArguments";
  static const String value = "value";
  static const String key = "key";
  static const String combinators = "combinators";
  static const String arguments = "arguments";
  static const String elements = "elements";

  /// import [uri]
  static const String uri = "uri";

  /// import 'x/x' as [prefix] or [prefix].black.
  static const String prefix = "prefix";

  /// for the method block statement
  static const String statements = "statements";
  static const String directive = "directive";
  static const String identifier = "identifier";
  static const String target = "target";
  static const String property = "property";
  static const String init = "init";
  static const String typeAnnotation = "typeAnnotation";
  static const String declarations = "declarations";
  static const String operator = "operator";
  static const String left = "left";
  static const String right = "right";
  static const String implements = "implements";
  static const String hiddenNames = "hiddenNames";
  static const String shownNames = "shownNames";

  ///
  static const String finallyBlock = "finallyBlock";
  static const String catchClauses = "catchClauses";

  ///
  static const String leftHandSide = "leftHandSide";
  static const String rightHandSide = "rightHandSide";

  ///
  static const String condition = "condition";
  static const String updaters = "updaters";
  static const String thenElement = "thenElement";
  static const String elseElement = "elseElement";
  static const String thenStatement = "thenStatement";
  static const String elseStatement = "elseStatement";

  ///
  static const String labels = "labels";
  static const String members = "members";
  static const String label = "label";

  ///
  static const String forLoopParts = "forLoopParts";
  static const String variables = "variables";
  // static const String initialization = "initialization"; // use init
  // static const String initializer = "initializer"; // use init
  static const String isConst = "isConst";
  static const String isFinal = "isFinal";
  static const String isLate = "isLate";
  static const String operand = "operand";
  static const String loopVariable = "loopVariable";

}

///
class AstNodeKey{
  AstNodeKey._();

  ///
  static const String type = "type";
  static const String body = "body";
  static const String name = "name";
  static const String superClause = "superClause";
  static const String implementsClause = "implementsClause";
  static const String widthClause = "widthClause";
  static const String metadata = "metadata";
  static const String parameters = "parameters";
  static const String parameterType = "parameterType";
  static const String parameterList = "parameterList";
  static const String typeParameters = "typeParameters";
  static const String isAsync = "isAsync";
  static const String returnType = "returnType";
  static const String expression = "expression";
  static const String callee = "callee";
  static const String argumentList = "argumentList";
  static const String typeArguments = "typeArguments";
  static const String value = "value";
  static const String combinators = "combinators";
  static const String uri = "uri"; // import [uri]
  static const String prefix = "prefix"; // import 'x/x' as [prefix] or [prefix].black.
  static const String statements = "statements"; // for the method block statement
  static const String directive = "directive";
  static const String identifier = "identifier";


}
///
class AstNodeType{
  AstNodeType._();

  ///
  static const String Program = "Program";

  ///
  static const String Annotation = "Annotation";

  ///
  static const String ClassDeclaration = "ClassDeclaration";
  static const String MethodDeclaration = "MethodDeclaration";
  static const String FunctionDeclaration = "FunctionDeclaration";
  static const String FieldDeclaration = "FieldDeclaration";
  static const String VariableDeclarator = "VariableDeclarator";
  static const String VariableDeclarationList = "VariableDeclarationList";

  ///
  static const String MethodInvocation = "MethodInvocation";

  ///
  static const String SimpleFormalParameter = "SimpleFormalParameter";
  static const String FormalParameterList = "FormalParameterList";
  static const String ArgumentList = "ArgumentList";
  static const String TypeName = "TypeName";
  static const String Identifier = "Identifier";

  ///
  static const String StringLiteral = "StringLiteral";
  static const String BooleanLiteral = "BooleanLiteral";
  static const String DoubleLiteral = "DoubleLiteral";
  static const String IntegerLiteral = "IntegerLiteral";
  static const String ListLiteral = "ListLiteral";
  static const String NullLiteral = "NullLiteral";
  static const String SetOrMapLiteral = "SetOrMapLiteral";
  static const String PrefixedIdentifier = "PrefixedIdentifier";

  ///
  static const String NamedExpression = "NamedExpression";
  static const String MemberExpression = "MemberExpression";
  static const String BinaryExpression = "BinaryExpression";
  static const String AssignmentExpression = "AssignmentExpression";
  static const String FunctionExpression = "FunctionExpression";
  static const String PrefixExpression = "PrefixExpression";
  static const String AwaitExpression = "AwaitExpression";
  static const String IndexExpression = "IndexExpression";

  ///
  static const String PropertyAccess = "PropertyAccess";

  ///
  static const String BlockStatement = "BlockStatement";
  static const String ReturnStatement = "ReturnStatement";
  static const String ExpressionStatement = "ExpressionStatement";

  ///
  static const String IfStatement = "IfStatement";
  static const String ForStatement = "ForStatement";
  static const String SwitchStatement = "SwitchStatement";
  static const String SwitchCase = "SwitchCase";
  static const String SwitchDefault = "SwitchDefault";

  static const String ImportDirective = "ImportDirective";
  static const String ShowCombinator = "ShowCombinator";
  static const String HideCombinator = "HideCombinator";
  static const String WithClause = "WithClause";
  static const String ImplementsClause = "ImplementsClause";
  static const String ExpressionFunctionBody = "ExpressionFunctionBody";
  static const String DeclaredIdentifier = "DeclaredIdentifier";

}
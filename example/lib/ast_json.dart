///
class AstJson {
  static const String Ast_page = '''{"type":"Program","body":[{"type":"ClassDeclaration","name":{"type":"Identifier","name":"AstPage"},"superClause":{"type":"TypeName","name":"StatefulWidget"},"implementsClause":null,"widthClause":null,"metadata":[],"members":[{"type":"MethodDeclaration","name":{"type":"Identifier","name":"createState"},"parameters":{"type":"FormalParameterList","parameterList":[]},"typeParameters":null,"body":null,"isAsync":false,"returnType":{"type":"TypeName","name":"State"}}]},{"type":"ClassDeclaration","name":{"type":"Identifier","name":"_AstPageState"},"superClause":{"type":"TypeName","name":"State"},"implementsClause":null,"widthClause":null,"metadata":[],"members":[{"type":"MethodDeclaration","name":{"type":"Identifier","name":"build"},"parameters":{"type":"FormalParameterList","parameterList":[{"type":"SimpleFormalParameter","parameterType":{"type":"TypeName","name":"BuildContext"},"name":"context"}]},"typeParameters":null,"body":{"type":"BlockStatement","statements":[{"type":"ReturnStatement","expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Scaffold"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","name":{"type":"Identifier","name":"appBar"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"AppBar"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","name":{"type":"Identifier","name":"title"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Text"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"SimpleStringLiteral","value":"AstPage"}]}}}]}}},{"type":"NamedExpression","name":{"type":"Identifier","name":"body"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Center"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","name":{"type":"Identifier","name":"child"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Text"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"SimpleStringLiteral","value":"Hello World"}]}}}]}}}]}}}]},"isAsync":false,"returnType":{"type":"TypeName","name":"Widget"}}]}],"directive":[{"type":"ImportDirective","uri":{"type":"SimpleStringLiteral","value":"package:flutter/cupertino.dart"},"prefix":null,"combinators":[]},{"type":"ImportDirective","uri":{"type":"SimpleStringLiteral","value":"package:flutter/material.dart"},"prefix":null,"combinators":[]}]}''';
}
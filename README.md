# dart_ast
利用ast实现flutter动态化的方案。主要实现三个步骤：将dart文件编译成json数据文件，解析运行json数据文件，实现json数据文件的版本更新控制。

## AstNode
### AstNode 各种节点说明
1. AstNode
最基础的节点，接受了原始的节点数据json，以及所有节点都具有的type属性。

2. Program
最顶点的节点，一般对应整个dart文件。里面包含classBody（class列表）、functionBody<>（全局方法列表）、directive（依赖引入列表）
```
{"type":"Program","body":[{"type":"ClassDeclaration","name":{"type":"Identifier","value":"TestClass"},"superClause":null,}],"directive":[{"type":"ImportDirective"}]}
```

3. ImportDirective
依赖引入列表内容，服务于 Program 的 directive 字段，它具有的属性如下。
- uri 引入路径
```
{"type":"StringLiteral","value":"package:dart_ast/util/logger.dart"},
```
- prefix 昵称字段
```
{"type":"Identifier","value":"ms"}
```

4. ClassDeclaration
对应 Program 的 classBody 内容；用于描述我们常见的类，它具有的属性如下。
- name 类名称
```
{"type":"Identifier","value":"TestPage"}
```
- body 类的内容，一般是 MethodDeclaration 和 FieldDeclaration。

```
{"type":"Identifier","value":"ms"}
```


## Getting Started

1. 编译dart文件
```
dart lib/dart_ast.dart -f example/lib/test_class.dart
```

2. 调转到flutter动态化的UI页面
```
Navigation.push(context, RuntimePage(parseAstNodeSync("dart json")),
```

3. 调用flutter动态化的dart业务逻辑类
```
RuntimeDart runtimeDart = RuntimeFactory.buildDart(parseAstNodeSync("dart json"));
Future result = runtimeDart.execute("add", [1, 10]); // add：方法，[1,10]：对应的实参列表
```
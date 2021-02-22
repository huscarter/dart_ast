import 'package:dart_ast/test/plugin_test.dart';
import 'package:dart_ast/test/plugin_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_ast/dart_ast.dart';

void main() {
  const MethodChannel channel = MethodChannel('dart_ast');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PluginTest.platformVersion, '42');
  });
}

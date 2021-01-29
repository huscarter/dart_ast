import 'package:flutter/services.dart';

class PluginTest {
  static const MethodChannel _channel = const MethodChannel('dart_ast');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

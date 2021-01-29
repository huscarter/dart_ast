import 'dart:io' as io;

/// 日志管理类
class Logger {
  static final isDebug = true;

  /// terminal 日志输出
  static void writeln(String msg) {
    if (isDebug) {
      io.stdout.writeln(msg);
    }
  }

  static void write(String msg) {
    if (isDebug) {
      io.stdout.write(msg);
    }
  }

  /// logcat 日志输出
  static void out(String tag, String msg) {
    if (isDebug) {
      print("$tag, $msg");
    }
  }
}

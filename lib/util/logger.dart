import 'dart:io';

/// 日志管理类
class Logger{
  static final isDebug = true;

  /// terminal 日志输出
  static void writeln(String msg){
    if(isDebug){
      stdout.writeln(msg);
    }
  }

  static void write(String msg){
    if(isDebug){
      stdout.write(msg);
    }
  }

  /// logcat 日志输出
  static void print(String msg){
    if(isDebug){
      print(msg);
    }
  }

  static void println(String msg){
    if(isDebug){
      println(msg);
    }
  }

}
import 'dart:io';

class Logger{
  static final isDebug = true;

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


}
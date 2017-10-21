import 'dart:html';
import 'package:logging/logging.dart';

class Debug{
  static void printTrace(){
    StackTrace stackTrace = StackTrace.current;

    List<String> traces = stackTrace.toString().split('\n');
    for (String trace in traces) {

      List<String> contentTrace = trace.split(' ');
      String lineString = contentTrace[0].replaceAllMapped('#', (_)=>'');
      print('lineString : $lineString');
//      int lineNumber = int.parse(lineString, onError: (s)=> null);
      print(trace);
    }
  }

  static void log(String message, Function function){
    if (message != null && message.length > 0) {
      print('##################################################################');
      print('### $message');
      print('##################################################################');
    }
    function();
    if (message != null && message.length > 0) {
      print('##################################################################');
    }
  }
}

class DebugStackTrace extends StackTrace{

  int get count => StackTrace.current.toString().split('\n').length;
}

Logger _ng1nDebugLogger = new Logger('debug');
_StackTraceInfo _stackTraceInfo = new _StackTraceInfo(StackTrace.current);

class _StackTraceInfo {
  List<_StackTraceLineInfo> lines = new List();

  _StackTraceInfo(StackTrace stackTrace) {
    Logger.root.onRecord.listen((LogRecord rec) {
      window.console.log('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }

  String get objectCall => _stackTraceInfo.lines[2].objectCall.trim();
  String get  methodCall => _stackTraceInfo.lines[2].methodCall.trim();

  String get currentFunction =>
      '$objectCall${objectCall != "" && methodCall != ""
          ? '.'
          : ''}$methodCall';

  void update() {
    lines.clear();
    for (String lineTrace in StackTrace.current.toString().split('\n')) {
      lineTrace = lineTrace.replaceAll('&', '_');

      RegExp exp = new RegExp(r"#([0-9]*)\s*(.*)\((.*)\)");
      Iterable<Match> matches = exp.allMatches(lineTrace);
      for (Match m in matches) {
        int id = int.parse(m.group(1));
        List<String> origin = m.group(2).split('.');
        String objectCall = origin[0];
        String methodCall = "";
        if (origin.length > 1) {
          methodCall = origin[1];
        }

        List<String> packageParts = m.group(3).split(':');

        int column = int.parse(packageParts.removeLast());
        int line;
        if (int.parse(packageParts.last, onError: (e) => null) != null) {
          line = int.parse(packageParts.removeLast());
        } else {
          line = column;
          column = null;
        }
        String package = packageParts.join(':');

        _StackTraceLineInfo stackTraceLineInfo = new _StackTraceLineInfo()
          ..id = id
          ..objectCall = objectCall
          ..methodCall = methodCall
          ..package = package
          ..line = line
          ..column = column;
        lines.add(stackTraceLineInfo);
      }
    }
  }
}

class _StackTraceLineInfo {
  int id;
  String objectCall;
  String methodCall;
  String package;
  int line;
  int column;

  @override
  String toString() {
    return '$id | $objectCall | $methodCall | $package | ($line, $column)';
  }
}

bool logInDebug = false;
void logCurrentFunction() {
  if(logInDebug) {
    _stackTraceInfo.update();
    _ng1nDebugLogger.info(_stackTraceInfo.currentFunction);
  }
}


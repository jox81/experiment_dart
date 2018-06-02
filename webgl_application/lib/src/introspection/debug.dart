import 'dart:collection';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

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

//class DebugStackTrace extends StackTrace{
//  int get count => StackTrace.current.toString().split('\n').length;
//}


///>

_StackTraceInfo _stackTraceInfo = new _StackTraceInfo();
_StackTraceInfo get stackTraceInfo => _stackTraceInfo;

class _StackTraceInfo {
  Logger _debugLogger = Logger.root;

  _StackTraceInfo() {
    _debugLogger.onRecord.listen((LogRecord rec) {
      print('${rec.time} : ${rec.message}');/*[${rec.level.name}] :  :   */
    });
  }

  Queue<String> stackFunctionName = new Queue();
  int depth = 0;
  bool debugLogCurrentFunction = false;

  void logCurrentFunction([String message]) {

    int baseIndex = 2;
    int currentIndex = 0;
    Trace trace = new Trace.current(baseIndex);

    Frame currentFrame = trace.frames[currentIndex];

    String currentFunctionName = '${currentFrame.member}';
    String lastLoggedFunctionName = stackFunctionName.length > 0 ?  stackFunctionName.first : null;
    String parentFunctionName;

    if(trace.frames.length > 1){
      Frame parentFrame;
      parentFrame = new Trace.current(baseIndex).frames[1];
      parentFunctionName = '${parentFrame.member}';
    }

    if(debugLogCurrentFunction) {
      print('/>');
      print('currentFunctionName : $currentFunctionName');
      print('parentFunctionName : $parentFunctionName');
      print('lastLoggedFunctionName : ${stackFunctionName.length > 0 ?  stackFunctionName.first : null}');
      print('stackFunctionName : $stackFunctionName');
      //    print(StackTrace.current);
      print('/<');
    }

    if(stackFunctionName.length == 0 || parentFunctionName == lastLoggedFunctionName) {
      stackFunctionName.addFirst(currentFunctionName);
    }else{
      while(stackFunctionName.length > 0 && parentFunctionName != stackFunctionName.first){
        stackFunctionName.removeFirst();
      }
      stackFunctionName.addFirst(currentFunctionName);
    }

    if(debugLogCurrentFunction) {
      print('$stackFunctionName');
    }

    String paddingString = '# ';
    for(int i = 0; i < stackFunctionName.length - 1; i++){
      paddingString = '$paddingString\t';
    }

    _debugLogger.info('$paddingString$currentFunctionName ${message != null ? ' > $message' : ''} ${debugLogCurrentFunction ?'$stackFunctionName | parent : $parentFunctionName' :'' }');

    if(debugLogCurrentFunction) {
      print('\n-------------------------');
    }
  }
}

bool isDebug = true;

void logCurrentFunction([String message]) {
  if(isDebug) {
    stackTraceInfo.logCurrentFunction(message);
  }
}

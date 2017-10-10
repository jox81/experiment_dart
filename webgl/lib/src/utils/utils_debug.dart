class Debug{
  static void printTrace(){
    StackTrace stackTrace = StackTrace.current;

    List<String> traces = stackTrace.toString().split('\n');
    for (String trace in traces) {

      List<String> contentTrace = trace.split(' ');
      String lineString = contentTrace[0].replaceAllMapped('#', (_)=>'');
      print('lineString : $lineString');
      int lineNumber = int.parse(lineString, onError: (s)=> null);
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


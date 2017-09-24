class Debug{
  static void printTrace(){
    StackTrace stackTrace = StackTrace.current;

    List<String> traces = stackTrace.toString().split('\n');
    for (String trace in traces) {

      List<String> contentTrace = trace.split(' ');
      int lineNumber = int.parse(contentTrace[0].replaceAllMapped('#', (_)=>''));
      print(trace);
    }
  }
}

class DebugStackTrace extends StackTrace{

  int get count => StackTrace.current.toString().split('\n').length;
}
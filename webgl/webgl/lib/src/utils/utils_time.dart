import 'dart:async';

Future delayedFuture(num delay) {
  Completer completer = new Completer<dynamic>();
  Future.delayed(new Duration(milliseconds: (delay * 1000.0).toInt()), completer.complete);
  return completer.future;
}

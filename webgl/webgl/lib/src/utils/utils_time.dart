import 'dart:async';

Future delayedFuture(num delay) {
  Completer completer = new Completer();
  Future.delayed(new Duration(seconds: delay), completer.complete);
  return completer.future;
}

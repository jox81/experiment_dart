@JS()
library statsjs;

import 'dart:html';
import "package:js/js.dart";

@JS('Stats')
class Stats{
  external Element get dom;
  external set dom(Element v);

  external Stats ();
  external void update();
  external void begin();
  external void end();
}

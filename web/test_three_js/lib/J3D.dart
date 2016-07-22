@JS('J3D')
library j3d;

import "package:js/js.dart";
import 'threejs.dart';
import 'dart:async';

typedef Future CallBack();

@JS()
class Loader {
  external factory Loader();

  external static Future<Object3D> loadJSON(path, CallBack onLoadedFunc);
  external static parseJSONScene(WebGLRenderer renderer, Scene scene, jscene, jmeshes, [jsanim]);
}


//@anonymous
//@JS()
//class base {}

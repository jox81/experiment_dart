import 'package:webgl/src/introspection.dart';
//@MirrorsUsed(
//    targets: const [
//      WebGLObject,
//    ],
//    override: '*')
//import 'dart:mirrors';

abstract class WebGLObject extends IEditElement {
  bool invalidated;
  void delete();
}
//@MirrorsUsed(
//    targets: const [
//      WebGLObject,
//    ],
//    override: '*')
//import 'dart:mirrors';

abstract class WebGLObject{
  bool invalidated;
  void delete();
}
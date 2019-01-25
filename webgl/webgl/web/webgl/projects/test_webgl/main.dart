//import 'dart:async';
//import 'dart:html';
//import 'dart:web_gl';
//
//import 'package:webgl/src/context.dart';
//
//Future main() async {
//
//  final CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
//  Context.init(canvas);
//
//  Program program;
//  bool result;
//
//  /// if no program exist, result is null
//  result = gl.getProgramParameter(program, WebGL.DELETE_STATUS) as bool;
//  assert(result == null);
//
//  program = gl.createProgram();
//
//  result = gl.getProgramParameter(program, WebGL.DELETE_STATUS) as bool;
//  assert(result == false);
//
//  gl.deleteProgram(program);
//
//  /// when deleted, program doesn't exist anymore, result is null
//  result = gl.getProgramParameter(program, WebGL.DELETE_STATUS) as bool;
//  assert(result == null);
//}

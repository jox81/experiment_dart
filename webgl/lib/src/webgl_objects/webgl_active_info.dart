import 'dart:web_gl' as WebGL;

import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

///The WebGLActiveInfo represents the information returned from the getActiveAttrib and getActiveUniform calls in a WebGlProgram.
class WebGLActiveInfo{

  final WebGL.ActiveInfo _webGLActiveInfo;

  WebGLActiveInfo.fromWebGL(this._webGLActiveInfo);

  ///The name of the requested variable.
  String get name => _webGLActiveInfo.name;

  ///The data type of the requested variable.
  ShaderVariableType get type => ShaderVariableType.getByIndex(_webGLActiveInfo.type);

  ///The size of the requested variable.
  int get size => _webGLActiveInfo.size;

  @override
  String toString(){
    return 'name : $name, type : $type, size : $size ';
  }
}
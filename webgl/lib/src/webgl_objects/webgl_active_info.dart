import 'dart:web_gl' as WebGL;

import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

class WebGLActiveInfo{
  ShaderVariableType shaderVariableType;
  WebGL.ActiveInfo activeInfo;
  WebGLActiveInfo(this.activeInfo) {}
}
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/webgl_objects/webgl_shader.dart';

class WebGLActiveInfo{
  ShaderVariableType shaderVariableType;
  WebGl.ActiveInfo activeInfo;
  WebGLActiveInfo(this.activeInfo) {}
}
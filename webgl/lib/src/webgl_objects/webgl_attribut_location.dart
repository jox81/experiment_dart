import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

class WebGLAttributLocation{
  int location;
  WebGLAttributLocation(this.location);

  void vertexAttrib4f(double x, double y, double z, double w) {
    gl.ctx.vertexAttrib4f(location, x, y, z, w);
  }

  void vertexAttrib1f(num data) {
    gl.ctx.vertexAttrib1f(location, data);
  }

  void disableVertexAttribArray() {
    gl.ctx.disableVertexAttribArray(location);
  }

  void enableVertexAttribArray() {
    gl.ctx.enableVertexAttribArray(location);
  }

  void vertexAttribPointer(int size, ShaderVariableType type, bool normalized, int stride, int offset) {
    gl.ctx.vertexAttribPointer(location, size, type.index, normalized, stride, offset);
  }
}
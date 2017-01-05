import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

class WebGLAttributLocation{
  int location;
  WebGLAttributLocation(this.location);

  void disableVertexAttribArray() {
    gl.ctx.disableVertexAttribArray(location);
  }

  void enableVertexAttribArray() {
    gl.ctx.enableVertexAttribArray(location);
  }

  void vertexAttribPointer(int size, ShaderVariableType type, bool normalized, int stride, int offset) {
    gl.ctx.vertexAttribPointer(location, size, type.index, normalized, stride, offset);
  }
  
  //float
  void vertexAttrib1f(num x) {
    gl.ctx.vertexAttrib1f(location, x);
  }
  
  void vertexAttrib2f(num x, num y) {
    gl.ctx.vertexAttrib2f(location, x, y);
  }
  
  void vertexAttrib3f(num x, num y, num z) {
    gl.ctx.vertexAttrib3f(location, x, y, z);
  }

  void vertexAttrib4f(num x, num y, num z, num w) {
    gl.ctx.vertexAttrib4f(location, x, y, z, w);
  }
  
  //List float
  void vertexAttrib1fv(Float32List data) {
    gl.ctx.vertexAttrib1fv(location, data);
  }
  
  void vertexAttrib2fv(Float32List  data) {
    gl.ctx.vertexAttrib2fv(location, data);
  }
  
  void vertexAttrib3fv(Float32List  data) {
    gl.ctx.vertexAttrib3fv(location, data);
  }

  void vertexAttrib4fv(Float32List data) {
    gl.ctx.vertexAttrib4fv(location, data);
  }

}
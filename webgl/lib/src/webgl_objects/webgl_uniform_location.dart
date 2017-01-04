import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class WebGLUniformLocation{
  WebGL.UniformLocation webGLUniformLocation;
  WebGLUniformLocation(this.webGLUniformLocation);

  void uniform2fv(data) {
    gl.ctx.uniform2fv(webGLUniformLocation, data);
  }

  void uniform3fv(data) {
    gl.ctx.uniform3fv(webGLUniformLocation, data);
  }

  void uniform3f(num data1, num data2, num data3) {
    gl.ctx.uniform3f(webGLUniformLocation, data1, data2, data3);
  }

  void uniform4fv(data) {
    gl.ctx.uniform4fv(webGLUniformLocation, data);
  }

  void uniform4f(num x, num y, num z, num w) {
    gl.ctx.uniform4f(webGLUniformLocation, x, y, z, w);
  }

  void uniform1i(int data) {
    gl.ctx.uniform1i(webGLUniformLocation, data);
  }

  void uniform1f(num data) {
    gl.ctx.uniform1f(webGLUniformLocation, data);
  }

  void uniformMatrix3fv(bool transpose, array) {
    gl.ctx.uniformMatrix3fv(webGLUniformLocation, transpose, array);
  }

  void uniformMatrix4fv(bool transpose, array) {
    gl.ctx.uniformMatrix4fv(webGLUniformLocation, transpose, array);
  }
}
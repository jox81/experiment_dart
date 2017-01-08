import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

///The WebGLUniformLocation interface represents the location of a uniform variable in a shader program.
class WebGLUniformLocation{
  WebGL.UniformLocation webGLUniformLocation;
  WebGLUniformLocation(this.webGLUniformLocation);

  //Float
  void uniform1f(num x) {
    gl.ctx.uniform1f(webGLUniformLocation, x);
  }
  void uniform2f(num x, num y) {
    gl.ctx.uniform2f(webGLUniformLocation, x, y);
  }

  void uniform3f(num x, num y, num z) {
    gl.ctx.uniform3f(webGLUniformLocation, x, y, z);
  }

  void uniform4f(num x, num y, num z, num w) {
    gl.ctx.uniform4f(webGLUniformLocation, x, y, z, w);
  }

  //int
  void uniform1i(int x) {
    gl.ctx.uniform1i(webGLUniformLocation, x);
  }

  void uniform2i(int x, int y) {
    gl.ctx.uniform2i(webGLUniformLocation, x, y);
  }

  void uniform3i(int x, int y, int z) {
    gl.ctx.uniform3i(webGLUniformLocation, x, y, z);
  }

  void uniform4i(int x, int y, int z, int w) {
    gl.ctx.uniform4i(webGLUniformLocation, x, y, z, w);
  }

  //float vector
  void uniform1fv(Float32List data) {
    gl.ctx.uniform1fv(webGLUniformLocation, data);
  }
  void uniform2fv(Float32List data) {
    gl.ctx.uniform2fv(webGLUniformLocation, data);
  }

  void uniform3fv(Float32List data) {
    gl.ctx.uniform3fv(webGLUniformLocation, data);
  }

  void uniform4fv(Float32List data) {
    gl.ctx.uniform4fv(webGLUniformLocation, data);
  }

  //int vector
  void uniform1iv(Int32List data) {
    gl.ctx.uniform1iv(webGLUniformLocation, data);
  }
  void uniform2iv(Int32List data) {
    gl.ctx.uniform2iv(webGLUniformLocation, data);
  }

  void uniform3iv(Int32List data) {
    gl.ctx.uniform3iv(webGLUniformLocation, data);
  }

  void uniform4iv(Int32List data) {
    gl.ctx.uniform4iv(webGLUniformLocation, data);
  }
  
  //matrix float
  void uniformMatrix2fv(bool transpose, Float32List array) {
    gl.ctx.uniformMatrix3fv(webGLUniformLocation, transpose, array);
  }

  void uniformMatrix3fv(bool transpose, Float32List array) {
    gl.ctx.uniformMatrix3fv(webGLUniformLocation, transpose, array);
  }

  void uniformMatrix4fv(bool transpose, Float32List array) {
    gl.ctx.uniformMatrix4fv(webGLUniformLocation, transpose, array);
  }
}
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:test_webgl/src/context.dart';
@MirrorsUsed(
    targets: const [
      WebGLUniformLocation,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:test_webgl/src/webgl_objects/webgl_program.dart';

///The WebGLUniformLocation represents the location of a uniform
///variable in a shader program.
///
///The WebGL.UniformLocation object does not define any methods or properties of
///its own and its content is not directly accessible.
///
///Mistake : Before a value can be set, the program must be used()
class WebGLUniformLocation{
  final WebGLProgram program;
  final String variableName;

  WebGL.UniformLocation _webGLUniformLocation;

  dynamic data;

  WebGL.UniformLocation get webGLUniformLocation => _webGLUniformLocation;

  WebGLUniformLocation(this.program, this.variableName){
    _webGLUniformLocation = gl.getUniformLocation(program?.webGLProgram, variableName);
  }

  //Float
  void uniform1f(num x) {
    gl.uniform1f(_webGLUniformLocation, x);
  }
  void uniform2f(num x, num y) {
    gl.uniform2f(_webGLUniformLocation, x, y);
  }

  void uniform3f(num x, num y, num z) {
    gl.uniform3f(_webGLUniformLocation, x, y, z);
  }

  void uniform4f(num x, num y, num z, num w) {
    gl.uniform4f(_webGLUniformLocation, x, y, z, w);
  }

  //int
  void uniform1i(int x) {
    gl.uniform1i(_webGLUniformLocation, x);
  }

  void uniform2i(int x, int y) {
    gl.uniform2i(_webGLUniformLocation, x, y);
  }

  void uniform3i(int x, int y, int z) {
    gl.uniform3i(_webGLUniformLocation, x, y, z);
  }

  void uniform4i(int x, int y, int z, int w) {
    gl.uniform4i(_webGLUniformLocation, x, y, z, w);
  }

  //float vector
  void uniform1fv(Float32List data) {
    gl.uniform1fv(_webGLUniformLocation, data);
  }
  void uniform2fv(Float32List data) {
    gl.uniform2fv(_webGLUniformLocation, data);
  }

  void uniform3fv(Float32List data) {
    gl.uniform3fv(_webGLUniformLocation, data);
  }

  void uniform4fv(Float32List data) {
    gl.uniform4fv(_webGLUniformLocation, data);
  }

  //int vector
  void uniform1iv(Int32List data) {
    gl.uniform1iv(_webGLUniformLocation, data);
  }
  void uniform2iv(Int32List data) {
    gl.uniform2iv(_webGLUniformLocation, data);
  }

  void uniform3iv(Int32List data) {
    gl.uniform3iv(_webGLUniformLocation, data);
  }

  void uniform4iv(Int32List data) {
    gl.uniform4iv(_webGLUniformLocation, data);
  }
  
  //matrix float
  void uniformMatrix2fv(Matrix2 matrix, bool transpose) {
    gl.uniformMatrix3fv(_webGLUniformLocation, transpose, matrix?.storage);
  }

  void uniformMatrix3fv(Matrix3 matrix, bool transpose) {
    gl.uniformMatrix3fv(_webGLUniformLocation, transpose, matrix?.storage);
  }

  void uniformMatrix4fv(Matrix4 matrix, bool transpose) {
    gl.uniformMatrix4fv(_webGLUniformLocation, transpose, matrix?.storage);
  }
}
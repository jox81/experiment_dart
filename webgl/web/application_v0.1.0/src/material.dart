import 'dart:html';
import 'dart:web_gl';
import 'application.dart';
import 'mesh.dart';

abstract class Material {

  RenderingContext get gl => Application.gl;

  Program program;

  Material(vsSource, fsSource) {
    _initShaderProgram(vsSource, fsSource);
  }

  void _initShaderProgram(String vsSource, String fsSource) {
    // vertex shader compilation
    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vsSource);
    gl.compileShader(vs);

    // fragment shader compilation
    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fsSource);
    gl.compileShader(fs);

    // attach shaders to a WebGL program
    Program _program = gl.createProgram();
    gl.attachShader(_program, vs);
    gl.attachShader(_program, fs);
    gl.linkProgram(_program);

    /**
     * Check if shaders were compiled properly. This is probably the most painful part
     * since there's no way to "debug" shader compilation
     */
    if (!gl.getShaderParameter(vs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(vs));
      return;
    }

    if (!gl.getShaderParameter(fs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(fs));
      return;
    }

    if (!gl.getProgramParameter(_program, RenderingContext.LINK_STATUS)) {
      print(gl.getProgramInfoLog(_program));
      window.alert("Could not initialise shaders");
      return;
    }

    program = _program;
  }

  render(Mesh mesh);
}

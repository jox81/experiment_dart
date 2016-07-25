import 'dart:html';
import 'dart:web_gl';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/mesh.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils.dart';
import 'dart:async';
import 'package:webgl/src/utils_shader.dart';

abstract class Material {
  /// GLSL Pragmas
  static const String GLSL_PRAGMA_DEBUG_ON = "#pragma debug(on)\n";
  static const String GLSL_PRAGMA_DEBUG_OFF = "#pragma debug(off)\n"; //Default
  static const String GLSL_PRAGMA_OPTIMIZE_ON =
      "#pragma optimize(on)\n"; //Default
  static const String GLSL_PRAGMA_OPTIMIZE_OFF = "#pragma optimize(off)\n";

  RenderingContext get gl => Application.gl;

  Program program;

  List<String> attributsNames = new List();
  Map<String, int> attributes = new Map();

  List<String> uniformsNames = [];
  Map<String, UniformLocation> uniforms = new Map();

  List<String> buffersNames = [];
  Map<String, Buffer> buffers = new Map();

  Material(vsSource, fsSource) {

    vsSource = ((Application.debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((Application.debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
    initShaderProgram(vsSource, fsSource);
    initBuffers();
    getShaderSettings();
  }

  //Not working loading from an exetnal file

//  Material(vsPath, fsPath) {
//    Utils.loadGlslShader(vsPath)
//        .then((vs) {
//      String vsSource = vs;
//      Utils.loadGlslShader(fsPath)
//          .then((fs) {
//        String fsSource = fs;
//        {
//          vsSource = ((Application.debugging)
//              ? Material.GLSL_PRAGMA_DEBUG_ON + GLSL_PRAGMA_OPTIMIZE_OFF
//              : "") +
//              vsSource;
//          fsSource = ((Application.debugging)
//              ? Material.GLSL_PRAGMA_DEBUG_ON + GLSL_PRAGMA_OPTIMIZE_OFF
//              : "") +
//              fsSource;
//          _initShaderProgram(vsSource, fsSource);
//          _initBuffers();
//          _getShaderSettings();
//        }
//      });
//    });
//  }


//  static Future<Material> fromUrls(String vsPath, String fsPath) {
//    String vsSource;
//    String fsSource;
//    return Utils.loadGlslShader(vsPath)
//        .then((vs) {
//      vsSource = vs;
//      Utils.loadGlslShader(fsPath).then((fs) {
//        return new Material(vsSource, fsSource);
//      });
//    });
//  }

  void initShaderProgram(String vsSource, String fsSource) {
    // vertex shader compilation
    Shader vs = gl.createShader(GL.VERTEX_SHADER);
    gl.shaderSource(vs, vsSource);
    gl.compileShader(vs);

    // fragment shader compilation
    Shader fs = gl.createShader(GL.FRAGMENT_SHADER);
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
    if (!gl.getShaderParameter(vs, GL.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(vs));
      return;
    }

    if (!gl.getShaderParameter(fs, GL.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(fs));
      return;
    }

    if (!gl.getProgramParameter(_program, GL.LINK_STATUS)) {
      print(gl.getProgramInfoLog(_program));
      window.alert("Could not initialise shaders");
      return;
    }

    program = _program;
  }

  void initBuffers() {
    for (String name in buffersNames) {
      buffers[name] = gl.createBuffer();
    }
  }

  void getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    for (String name in attributsNames) {
      attributes[name] = gl.getAttribLocation(program, name);
    }
  }

  void _getShaderUniformSettings() {
    for (String name in uniformsNames) {
      uniforms[name] = gl.getUniformLocation(program, name);
    }
  }

  render(Mesh mesh) {
    gl.useProgram(program);
    setShaderSettings(mesh);

    if (mesh.indices.length > 0) {
      gl.drawElements(GL.TRIANGLES, mesh.indices.length, GL.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }
    disableVertexAttributs();
  }

  setShaderSettings(Mesh mesh) {
    setShaderAttributs(mesh);
    setShaderUniforms(mesh);
  }

  setShaderAttributs(Mesh mesh);
  setShaderUniforms(Mesh mesh);

  disableVertexAttributs() {
    for (String name in attributsNames) {
      gl.disableVertexAttribArray(attributes[name]);
    }
  }
}

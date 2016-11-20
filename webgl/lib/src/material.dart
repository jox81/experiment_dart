import 'dart:html';
import 'dart:web_gl';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/mesh.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils.dart';
import 'dart:async';
import 'package:webgl/src/utils_shader.dart';
import 'dart:typed_data';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';

abstract class Material {
  /// GLSL Pragmas
  static const String GLSL_PRAGMA_DEBUG_ON = "#pragma debug(on)\n";
  static const String GLSL_PRAGMA_DEBUG_OFF = "#pragma debug(off)\n"; //Default
  static const String GLSL_PRAGMA_OPTIMIZE_ON =
      "#pragma optimize(on)\n"; //Default
  static const String GLSL_PRAGMA_OPTIMIZE_OFF = "#pragma optimize(off)\n";

  String name;
  Program program;

  ProgramInfo programInfo;

  List<String> attributsNames = new List();
  Map<String, int> attributes = new Map();

  List<String> uniformsNames = new List();
  Map<String, UniformLocation> uniforms = new Map();

  List<String> buffersNames = new List();
  Map<String, Buffer> buffers = new Map();

  Material(vsSource, fsSource) {
    vsSource = ((Application.debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((Application.debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
    initShaderProgram(vsSource, fsSource);

    programInfo = UtilsShader.getProgramInfo(program);
    attributsNames =  programInfo.attributes.map((a)=> a.activeInfo.name).toList();
    uniformsNames = programInfo.uniforms.map((a)=> a.activeInfo.name).toList();

    initBuffers();

    getShaderSettings();
  }

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
      gl.drawElements(mesh.mode, mesh.indices.length, GL.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }
    disableVertexAttributs();
  }

  void setShaderAttributWithName(String attributName, {arrayBuffer, dimension, elemetArrayBuffer, data}) {

    if (arrayBuffer!= null && dimension != null) {
      gl.bindBuffer(GL.ARRAY_BUFFER, buffers[attributName]);
      gl.enableVertexAttribArray(attributes[attributName]);
      gl.bufferData(
          GL.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), GL.STATIC_DRAW);
      gl.vertexAttribPointer(
          attributes[attributName], dimension, GL.FLOAT, false, 0, 0);
    } else if(elemetArrayBuffer != null){
        gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, buffers[attributName]);
        gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elemetArrayBuffer),
            GL.STATIC_DRAW);
    }else{
      ActiveInfoCustom activeInfo = programInfo.attributes.firstWhere((a)=> a.activeInfo.name == attributName, orElse:() => null);

      if(activeInfo != null) {
        switch (activeInfo.typeName) {
          case 'FLOAT_VEC3':

            break;
          case 'FLOAT':
              gl.vertexAttrib1f(attributes[attributName], data);
            break;

          default:
            print(
                'setShaderAttributWithName not set in material.dart for : ${activeInfo.typeName}');
            break;
        }
      }



    }
  }

  void setShaderUniformWithName(String uniformName, data, [data1, data2]) {

    ActiveInfoCustom activeInfo = programInfo.uniforms.firstWhere((a)=> a.activeInfo.name == uniformName, orElse:() => null);

    if(activeInfo != null) {
      switch (activeInfo.typeName) {
        case 'FLOAT_VEC2':
          if (data1 == null && data2 == null) {
            gl.uniform2fv(uniforms[uniformName], data);
          }
          break;
        case 'FLOAT_VEC3':
          if (data1 == null && data2 == null) {
            gl.uniform3fv(uniforms[uniformName], data);
          } else {
            gl.uniform3f(uniforms[uniformName], data, data1, data2);
          }
          break;
        case 'BOOL':
        case 'SAMPLER_2D':

          gl.uniform1i(uniforms[uniformName], data);
          break;
        case 'FLOAT':
          gl.uniform1f(uniforms[uniformName], data);
          break;
        case 'FLOAT_MAT3':
          gl.uniformMatrix3fv(uniforms[uniformName], false, data);
          break;
        case 'FLOAT_MAT4':
          gl.uniformMatrix4fv(uniforms[uniformName], false, data);
          break;
        default:
          print(
              'setShaderUniformWithName not set in material.dart for : ${activeInfo.typeName}');
          break;
      }
    }
  }

  disableVertexAttributs() {
    for (String name in attributsNames) {
      gl.disableVertexAttribArray(attributes[name]);
    }
  }

  setShaderSettings(Mesh mesh) {
    setShaderAttributs(mesh);
    setShaderUniforms(mesh);
  }

  setShaderAttributs(Mesh mesh);
  setShaderUniforms(Mesh mesh);


}


import 'dart:collection';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/meshes.dart';

import 'package:webgl/src/models.dart';
import 'package:webgl/src/shaders.dart';
import 'dart:typed_data';

abstract class Material extends IEditElement {
  static bool debugging = false;

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
    vsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
    initShaderProgram(vsSource, fsSource);

    programInfo = UtilsShader.getProgramInfo(gl, program);
    attributsNames =  programInfo.attributes.map((a)=> a.activeInfo.name).toList();
    uniformsNames = programInfo.uniforms.map((a)=> a.activeInfo.name).toList();

    initBuffers();

    getShaderSettings();
  }

  void initShaderProgram(String vsSource, String fsSource) {
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

  render(Model model) {

    _mvPushMatrix();

    Context.mvMatrix.multiply(model.transform);

    gl.useProgram(program);
    setShaderSettings(model.mesh);

    if (model.mesh.indices.length > 0) {
      gl.drawElements(model.mesh.mode, model.mesh.indices.length, RenderingContext.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(model.mesh.mode, 0, model.mesh.vertexCount);
    }
    disableVertexAttributs();

    _mvPopMatrix();
  }

  //Animation
  Queue<Matrix4> _mvMatrixStack = new Queue();

  void _mvPushMatrix() {
    _mvMatrixStack.addFirst(Context.mvMatrix.clone());
  }

  void _mvPopMatrix() {
    if (0 == _mvMatrixStack.length) {
      throw new Exception("Invalid popMatrix!");
    }
    Context.mvMatrix = _mvMatrixStack.removeFirst();
  }

  void setShaderAttributWithName(String attributName, {arrayBuffer, dimension, elemetArrayBuffer, data}) {

    if (arrayBuffer!= null && dimension != null) {
      gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buffers[attributName]);
      gl.enableVertexAttribArray(attributes[attributName]);
      gl.bufferData(
          RenderingContext.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), RenderingContext.STATIC_DRAW);
      gl.vertexAttribPointer(
          attributes[attributName], dimension, RenderingContext.FLOAT, false, 0, 0);
    } else if(elemetArrayBuffer != null){
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, buffers[attributName]);
        gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elemetArrayBuffer),
            RenderingContext.STATIC_DRAW);
    }else{
      ActiveInfoCustom activeInfo = programInfo.attributes.firstWhere((a)=> a.activeInfo.name == attributName, orElse:() => null);

      if(activeInfo != null) {
        switch (activeInfo.typeName) {
          case 'FLOAT_VEC3':
            break;
          case 'FLOAT_VEC4':
            Vector4 vector4Value = data;
            gl.vertexAttrib4f(attributes[attributName], vector4Value.x, vector4Value.y, vector4Value.z, vector4Value.w);
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

  void setShaderUniformWithName(String uniformName, data, [data1, data2, data3]) {

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
        case 'FLOAT_VEC4':
          if (data1 == null && data2 == null && data3 == null) {
            gl.uniform4fv(uniforms[uniformName], data);
          } else {
            gl.uniform4f(uniforms[uniformName], data, data1, data2, data3);
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


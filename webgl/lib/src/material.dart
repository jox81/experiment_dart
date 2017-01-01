import 'dart:collection';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
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
  WebGLProgram program;

  ProgramInfo programInfo;

  List<String> attributsNames = new List();
  Map<String, int> attributes = new Map();

  List<String> uniformsNames = new List();
  Map<String, UniformLocation> uniforms = new Map();

  List<String> buffersNames = new List();
  Map<String, WebGLBuffer> buffers = new Map();

  Material(vsSource, fsSource) {
    vsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
    program = initShaderProgram(vsSource, fsSource);

    programInfo = program.getProgramInfo();
    attributsNames =  programInfo.attributes.map((a)=> a.activeInfo.name).toList();
    uniformsNames = programInfo.uniforms.map((a)=> a.activeInfo.name).toList();

    initBuffers();

    getShaderSettings();
  }

  WebGLProgram initShaderProgram(String vsSource, String fsSource) {
    WebGLShader vs = new WebGLShader(ShaderType.VERTEX_SHADER);
      vs
      ..setSource(vsSource)
      ..compile();

    WebGLShader fs = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..setSource(fsSource)
      ..compile();

    WebGLProgram _program = new WebGLProgram()
    ..attachShader(vs)
    ..attachShader(fs)
    ..link();

    return _program;
  }

  void initBuffers() {
    for (String name in buffersNames) {
      buffers[name] = new WebGLBuffer();
    }
  }

  void getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    for (String name in attributsNames) {
      attributes[name] = program.getAttribLocation(name);
    }
  }

  void _getShaderUniformSettings() {
    for (String name in uniformsNames) {
      uniforms[name] = program.getUniformLocation(name);
    }
  }

  render(Model model) {

    _mvPushMatrix();

    Context.mvMatrix.multiply(model.transform);

    program.use();
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
      WebGLContext.bindBuffer(BufferType.ARRAY_BUFFER, buffers[attributName]);
      gl.enableVertexAttribArray(attributes[attributName]);
      WebGLContext.bufferData(
          BufferType.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), UsageType.STATIC_DRAW);
      gl.vertexAttribPointer(
          attributes[attributName], dimension, RenderingContext.FLOAT, false, 0, 0);
    } else if(elemetArrayBuffer != null){
      WebGLContext.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, buffers[attributName]);
      WebGLContext.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elemetArrayBuffer),
          UsageType.STATIC_DRAW);
    }else{
      WebGLActiveInfo activeInfo = programInfo.attributes.firstWhere((a)=> a.activeInfo.name == attributName, orElse:() => null);

      if(activeInfo != null) {
        switch (activeInfo.shaderVariableType) {
          case ShaderVariableType.FLOAT_VEC3:
            break;
          case ShaderVariableType.FLOAT_VEC4:
            Vector4 vector4Value = data;
            gl.vertexAttrib4f(attributes[attributName], vector4Value.x, vector4Value.y, vector4Value.z, vector4Value.w);
            break;
          case ShaderVariableType.FLOAT:
              gl.vertexAttrib1f(attributes[attributName], data);
            break;
          default:
            print(
                'setShaderAttributWithName not set in material.dart for : ${activeInfo}');
            break;
        }
      }
    }
  }

  void setShaderUniformWithName(String uniformName, data, [data1, data2, data3]) {

    WebGLActiveInfo activeInfo = programInfo.uniforms.firstWhere((a)=> a.activeInfo.name == uniformName, orElse:() => null);

    if(activeInfo != null) {
      switch (activeInfo.shaderVariableType) {
        case ShaderVariableType.FLOAT_VEC2:
          if (data1 == null && data2 == null) {
            gl.uniform2fv(uniforms[uniformName], data);
          }
          break;
        case ShaderVariableType.FLOAT_VEC3:
          if (data1 == null && data2 == null) {
            gl.uniform3fv(uniforms[uniformName], data);
          } else {
            gl.uniform3f(uniforms[uniformName], data, data1, data2);
          }
          break;
        case ShaderVariableType.FLOAT_VEC4:
          if (data1 == null && data2 == null && data3 == null) {
            gl.uniform4fv(uniforms[uniformName], data);
          } else {
            gl.uniform4f(uniforms[uniformName], data, data1, data2, data3);
          }
          break;
        case ShaderVariableType.BOOL:
        case ShaderVariableType.SAMPLER_2D:

          gl.uniform1i(uniforms[uniformName], data);
          break;
        case ShaderVariableType.FLOAT:
          gl.uniform1f(uniforms[uniformName], data);
          break;
        case ShaderVariableType.FLOAT_MAT3:
          gl.uniformMatrix3fv(uniforms[uniformName], false, data);
          break;
        case ShaderVariableType.FLOAT_MAT4:
          gl.uniformMatrix4fv(uniforms[uniformName], false, data);
          break;
        default:
          print(
              'setShaderUniformWithName not set in material.dart for : ${activeInfo}');
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


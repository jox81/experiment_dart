import 'dart:collection';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/geometry/models.dart';
import 'dart:typed_data';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
@MirrorsUsed(
    targets: const [
      Material,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

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
  List<WebGLShader> shaders;

  Map<String, WebGLBuffer> buffers = new Map();

  List<String> _attributsNames = new List();
  Map<String, WebGLAttributLocation> attributes = new Map();

  List<String> _uniformsNames = new List();
  Map<String, WebGLUniformLocation> uniformLocations = new Map();

  Material(String vsSource, String fsSource) {
    vsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;

    program = initShaderProgram(vsSource, fsSource);
    programInfo = program.getProgramInfo();
    _attributsNames =  programInfo.attributes.map((a)=> a.name).toList();
    _uniformsNames = programInfo.uniforms.map((a)=> a.name).toList();

    getShaderSettings();
  }

  WebGLProgram initShaderProgram(String vsSource, String fsSource) {
    WebGLShader vs = new WebGLShader(ShaderType.VERTEX_SHADER);
      vs
      ..source = vsSource
      ..compile();

    WebGLShader fs = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = fsSource
      ..compile();

    shaders = [vs, fs];
    WebGLProgram _program = new WebGLProgram()
    ..attachShader(vs)
    ..attachShader(fs)
    ..link()
    ..validate();

    return _program;
  }

  void getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    for (String name in _attributsNames) {
      attributes[name] = program.getAttribLocation(name);
    }
  }

  void _getShaderUniformSettings() {
    for (String name in _uniformsNames) {
      uniformLocations[name] = program.getUniformLocation(name);
    }
  }

  // >> Attributs

  void setShaderAttributArrayBuffer(String attributName, List arrayBuffer, int dimension){
    if(buffers[attributName] == null) buffers[attributName] = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, buffers[attributName]);
    attributes[attributName].enabled = true;

    if(buffers[attributName].data != arrayBuffer) {
      buffers[attributName].data = arrayBuffer;
      gl.bufferData(
          BufferType.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), BufferUsageType.STATIC_DRAW);
    }

    attributes[attributName].vertexAttribPointer(dimension, ShaderVariableType.FLOAT, false, 0, 0);
  }

  void setShaderAttributElementArrayBuffer(String attributName, List<int> elementArrayBuffer){
    if(buffers[attributName] == null) buffers[attributName] = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, buffers[attributName]);

    if(buffers[attributName].data != elementArrayBuffer) {
      buffers[attributName].data = elementArrayBuffer;
      gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elementArrayBuffer),
      BufferUsageType.STATIC_DRAW);
    }
  }

  void setShaderAttributData(String attributName, data) {

    WebGLActiveInfo activeInfo = programInfo.attributes.firstWhere((a)=> a.name == attributName, orElse:() => null);

    if(activeInfo != null) {
      switch (activeInfo.type) {
        case ShaderVariableType.FLOAT:
          num vector1Value = data;
          attributes[attributName].vertexAttrib1f(vector1Value);
          break;
        case ShaderVariableType.FLOAT_VEC2:
          Vector2 vector2Value = data;
          attributes[attributName].vertexAttrib2f(vector2Value.x, vector2Value.y);
          break;
        case ShaderVariableType.FLOAT_VEC3:
          Vector3 vector3Value = data;
          attributes[attributName].vertexAttrib3f(vector3Value.x, vector3Value.y, vector3Value.z);
          break;
        case ShaderVariableType.FLOAT_VEC4:
          Vector4 vector4Value = data;
          attributes[attributName].vertexAttrib4f(vector4Value.x, vector4Value.y, vector4Value.z, vector4Value.w);
          break;

        default:
          print(
              'setShaderAttributWithName not set in material.dart for : ${activeInfo}');
          break;
      }
    }
  }

  // >> Uniforms

  void setShaderUniform(String uniformName, data, [data1, data2, data3]) {
    window.console.time('material::setShaderUniform');
    if(uniformLocations[uniformName] == null){
      print(uniformName);
    }

    if(uniformLocations[uniformName].data != data){

      WebGLActiveInfo activeInfo = programInfo.uniforms.firstWhere((a)=> a.name == uniformName, orElse:() => null);

      uniformLocations[uniformName].data = data;

      if(activeInfo != null) {
        switch (activeInfo.type) {
          case ShaderVariableType.FLOAT_VEC2:
            if (data1 == null) {
              uniformLocations[uniformName].uniform2fv(data);
            }else{
              uniformLocations[uniformName].uniform2f(data, data1);
            }
            break;
          case ShaderVariableType.FLOAT_VEC3:
            if (data1 == null && data2 == null) {
              uniformLocations[uniformName].uniform3fv(data);
            } else {
              uniformLocations[uniformName].uniform3f( data, data1, data2);
            }
            break;
          case ShaderVariableType.FLOAT_VEC4:
            if (data1 == null && data2 == null && data3 == null) {
              uniformLocations[uniformName].uniform4fv(data);
            } else {
              uniformLocations[uniformName].uniform4f(data, data1, data2, data3);
            }
            break;
          case ShaderVariableType.BOOL:
          case ShaderVariableType.SAMPLER_2D:
          case ShaderVariableType.SAMPLER_CUBE:
            uniformLocations[uniformName].uniform1i(data);
            break;
          case ShaderVariableType.FLOAT:
            uniformLocations[uniformName].uniform1f(data);
            break;
          case ShaderVariableType.FLOAT_MAT3:
            uniformLocations[uniformName].uniformMatrix3fv(data, false);
            break;
          case ShaderVariableType.FLOAT_MAT4:
            uniformLocations[uniformName].uniformMatrix4fv(data, false);
            break;
          default:
            print(
                'setShaderUniformWithName not set in material.dart for : ${activeInfo}');
            break;
        }
      }

    }
    window.console.timeEnd('material::setShaderUniform');
  }

  // > Animation and Hierarchy
  Queue<Matrix4> _mvMatrixStack = new Queue();

  void _mvPushMatrix() {
    _mvMatrixStack.addFirst(Context.modelViewMatrix.clone());
  }

  void _mvPopMatrix() {
    if (0 == _mvMatrixStack.length) {
      throw new Exception("Invalid popMatrix!");
    }
    Context.modelViewMatrix = _mvMatrixStack.removeFirst();
  }

  // >> Rendering

  render(Model model) {
    window.console.time('material::render');
    _mvPushMatrix();
    Context.modelViewMatrix.multiply(model.transform);

    window.console.time('material::beforeRender');
    beforeRender(model);
    window.console.timeEnd('material::beforeRender');

    window.console.time('material::draw');
    if (model.mesh.indices.length > 0 && model.mesh.mode != DrawMode.POINTS) {
      gl.drawElements(model.mesh.mode, model.mesh.indices.length, BufferElementType.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(model.mesh.mode, 0, model.mesh.vertexCount);
    }
    window.console.timeEnd('material::draw');

    window.console.time('material::afterRender');
    afterRender(model);
    window.console.timeEnd('material::afterRender');

    _mvPopMatrix();
    window.console.timeEnd('material::render');
  }

  beforeRender(Model model) {
    window.console.time('material::beforeRender:program.use');
    program.use();
    window.console.timeEnd('material::beforeRender:program.use');

    window.console.time('material::beforeRender:setShaderAttributs');
    setShaderAttributs(model);
    window.console.timeEnd('material::beforeRender:setShaderAttributs');

    window.console.time('material::beforeRender:setShaderUniforms');
    setShaderUniforms(model);
    window.console.timeEnd('material::beforeRender:setShaderUniforms');

    window.console.time('material::beforeRender:setupBeforeRender');
    setupBeforeRender();
    window.console.timeEnd('material::beforeRender:setupBeforeRender');
  }

  setShaderAttributs(Model model);
  setShaderUniforms(Model model);
  setupBeforeRender(){}
  setupAfterRender(){}

  afterRender(Model model){
    setupAfterRender();
    disableVertexAttributs();
  }

  disableVertexAttributs() {
    for (String name in _attributsNames) {
      attributes[name].enabled = false;
    }
  }

}

import 'dart:collection';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
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

  void setShaderAttributArrayBuffer(String attributName, List<double> arrayBuffer, int dimension){
    if(buffers[attributName] == null) buffers[attributName] = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, buffers[attributName]);
    attributes[attributName].enabled = true;

    if(buffers[attributName].data != arrayBuffer) {
      buffers[attributName].data = arrayBuffer;
      print(new Float32List.fromList(arrayBuffer));
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

  void setShaderAttributData(String attributName, dynamic data) {

    WebGLActiveInfo activeInfo = programInfo.attributes.firstWhere((a)=> a.name == attributName, orElse:() => null);

    if(activeInfo != null) {
      switch (activeInfo.type) {
        case ShaderVariableType.FLOAT:
          num vector1Value = data as num;
          attributes[attributName].vertexAttrib1f(vector1Value);
          break;
        case ShaderVariableType.FLOAT_VEC2:
          Vector2 vector2Value = data as Vector2;
          attributes[attributName].vertexAttrib2f(vector2Value.x, vector2Value.y);
          break;
        case ShaderVariableType.FLOAT_VEC3:
          Vector3 vector3Value = data as Vector3;
          attributes[attributName].vertexAttrib3f(vector3Value.x, vector3Value.y, vector3Value.z);
          break;
        case ShaderVariableType.FLOAT_VEC4:
          Vector4 vector4Value = data as Vector4;
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

  void setShaderUniform(String uniformName, dynamic data, [dynamic data1, dynamic data2, dynamic data3]) {
//    window.console.time('05_03_01_material::setShaderUniform');
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
              uniformLocations[uniformName].uniform2fv(data as Float32List);
            }else{
              uniformLocations[uniformName].uniform2f(data as num, data1 as num);
            }
            break;
          case ShaderVariableType.FLOAT_VEC3:
            if (data1 == null && data2 == null) {
              uniformLocations[uniformName].uniform3fv(data as Float32List);
            } else {
              uniformLocations[uniformName].uniform3f( data as num, data1 as num, data2 as num);
            }
            break;
          case ShaderVariableType.FLOAT_VEC4:
            if (data1 == null && data2 == null && data3 == null) {
              uniformLocations[uniformName].uniform4fv(data as Float32List);
            } else {
              uniformLocations[uniformName].uniform4f(data as num, data1 as num, data2 as num, data3 as num);
            }
            break;
          case ShaderVariableType.BOOL:
          case ShaderVariableType.SAMPLER_2D:
          case ShaderVariableType.SAMPLER_CUBE:
            uniformLocations[uniformName].uniform1i(data as int);
            break;
          case ShaderVariableType.FLOAT:
            uniformLocations[uniformName].uniform1f(data as num);
            break;
          case ShaderVariableType.FLOAT_MAT3:
            uniformLocations[uniformName].uniformMatrix3fv(data as Matrix3, false);
            break;
          case ShaderVariableType.FLOAT_MAT4:
            uniformLocations[uniformName].uniformMatrix4fv(data as Matrix4, false);
            break;
          default:
            print(
                'setShaderUniformWithName not set in material.dart for : ${activeInfo}');
            break;
        }
      }

    }
//    window.console.timeEnd('05_03_01_material::setShaderUniform');
  }

  // > Animation and Hierarchy
  Queue<Matrix4> _mvMatrixStack = new Queue();

  void _mvPushMatrix() {
    _mvMatrixStack.addFirst(Context.modelMatrix.clone());
  }

  void _mvPopMatrix() {
    if (_mvMatrixStack.length == 0) {
      throw new Exception("Invalid popMatrix!"); /// ça veut dire qu'on a fait un pop de trop.
    }
    Context.modelMatrix = _mvMatrixStack.removeFirst();
  }

  void update(Model model) {
//    window.console.time('04_00_material::render');
//    _mvPushMatrix();
//    Context.modelViewMatrix.multiply(model.transform);
//
//    window.console.time('04_01_material::beforeRender');
//    beforeRender(model);
//    window.console.timeEnd('04_01_material::beforeRender');
  }

  // >> Rendering

  void render(Model model) {
//    window.console.time('04_00_material::render');
    _mvPushMatrix();
//    Context.modelMatrix.multiply(model.transform);
//    idem :
    Context.modelMatrix = (Context.modelMatrix * model.transform) as Matrix4;

//    window.console.time('04_01_material::beforeRender');
    beforeRender(model);
//    window.console.timeEnd('04_01_material::beforeRender');

//    window.console.time('04_02_material::render');
    if (model.mesh.indices.length > 0 && model.mesh.mode != DrawMode.POINTS) {
      gl.drawElements(model.mesh.mode, model.mesh.indices.length, BufferElementType.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(model.mesh.mode, 0, model.mesh.vertexCount);
    }
//    window.console.timeEnd('04_02_material::render');

//    window.console.time('04_03_material::afterRender');
    afterRender(model);
//    window.console.timeEnd('04_03_material::afterRender');

    _mvPopMatrix();
//    window.console.timeEnd('04_00_material::render');
  }

  void beforeRender(Model model) {
//    window.console.time('05_01_material::beforeRender:program.use');
    program.use();
//    window.console.timeEnd('05_01_material::beforeRender:program.use');

//    window.console.time('05_02_material::beforeRender:setShaderAttributs');
    setShaderAttributs(model);
//    window.console.timeEnd('05_02_material::beforeRender:setShaderAttributs');

//    window.console.time('05_03_material::beforeRender:setShaderUniforms');
    setShaderUniforms(model);
//    window.console.timeEnd('05_03_material::beforeRender:setShaderUniforms');

//    window.console.time('05_04_material::beforeRender:setupBeforeRender');
    setupBeforeRender();
//    window.console.timeEnd('05_04_material::beforeRender:setupBeforeRender');
  }

  void setShaderAttributs(Model model);
  void setShaderUniforms(Model model);
  void setupBeforeRender(){}
  void setupAfterRender(){}

  void afterRender(Model model){
    setupAfterRender();
    disableVertexAttributs();
  }

  void disableVertexAttributs() {
    for (String name in _attributsNames) {
      attributes[name].enabled = false;
    }
  }

}


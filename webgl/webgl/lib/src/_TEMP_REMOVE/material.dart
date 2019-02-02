//import 'dart:collection';
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/webgl_objects/context.dart';
//import 'package:webgl/src/gltf/accessor/accessor.dart';
//import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
//import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
//import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
//import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
//import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
//import 'package:webgl/src/webgl_objects/webgl_program.dart';
//import 'package:webgl/src/webgl_objects/webgl_shader.dart';
//import 'package:webgl/src/introspection/introspection.dart';
//import 'package:webgl/src/geometry/mesh.dart';
//import 'dart:typed_data';
//import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
//
//abstract class MaterialTMP{
//  static bool debugging = false;
//
//  /// GLSL Pragmas
//  static const String GLSL_PRAGMA_DEBUG_ON = "#pragma debug(on)\n";
//  static const String GLSL_PRAGMA_DEBUG_OFF = "#pragma debug(off)\n"; //Default
//  static const String GLSL_PRAGMA_OPTIMIZE_ON =
//  "#pragma optimize(on)\n"; //Default
//  static const String GLSL_PRAGMA_OPTIMIZE_OFF = "#pragma optimize(off)\n";
//
//  String name;
//
//  WebGLProgram program;
//  ProgramInfo programInfo;
//  List<WebGLShader> shaders;
//
//  Map<String, WebGLBuffer> buffers = new Map();
//
//  List<String> _attributsNames = new List();
//  Map<String, WebGLAttributLocation> attributes = new Map();
//
//  List<String> _uniformsNames = new List();
//  Map<String, WebGLUniformLocation> uniformLocations = new Map();
//
//  Material(String vsSource, String fsSource) {
//    vsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
//    fsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
//
//    program = initShaderProgram(vsSource, fsSource);
//    programInfo = program.getProgramInfo();
//    _attributsNames =  programInfo.attributes.map((a)=> a.name).toList();
//    _uniformsNames = programInfo.uniforms.map((a)=> a.name).toList();
//
//    getShaderSettings();
//  }
//



//
//  void getShaderSettings() {
//    _getShaderAttributSettings();
//    _getShaderUniformSettings();
//  }
//
//  void _getShaderAttributSettings() {
//    for (String name in _attributsNames) {
//      attributes[name] = program.getAttribLocation(name);
//    }
//  }
//
//  void _getShaderUniformSettings() {
//    for (String name in _uniformsNames) {
//      uniformLocations[name] = program.getUniformLocation(name);
//    }
//  }
//
//  // >> Attributs
//
//  void setShaderAttributArrayBuffer(String attributName, List<double> arrayBuffer, int dimension){
//    if(buffers[attributName] == null) buffers[attributName] = new WebGLBuffer();
//    gl.bindBuffer(BufferType.ARRAY_BUFFER, buffers[attributName].webGLBuffer);
//    if(attributes[attributName] == null) throw "setShaderAttributArrayBuffer null";
//    attributes[attributName].enabled = true;
//
//    if(buffers[attributName].data != arrayBuffer) {
//      buffers[attributName].data = arrayBuffer;
//      gl.bufferData(
//          BufferType.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), BufferUsageType.STATIC_DRAW);
//    }
//
//    attributes[attributName].vertexAttribPointer(dimension, ShaderVariableType.FLOAT, false, 0, 0);
//  }
//
//  void setShaderAttributElementArrayBuffer(String attributName, List<int> elementArrayBuffer){
//    if(buffers[attributName] == null) buffers[attributName] = new WebGLBuffer();
//    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, buffers[attributName].webGLBuffer);
//
//    if(buffers[attributName].data != elementArrayBuffer) {
//      buffers[attributName].data = elementArrayBuffer;
//      gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elementArrayBuffer),
//      BufferUsageType.STATIC_DRAW);
//    }
//  }
//
//  void setShaderAttributData(String attributName, dynamic data) {
//
//    WebGLActiveInfo activeInfo = programInfo.attributes.firstWhere((a)=> a.name == attributName, orElse:() => null);
//
//    if(activeInfo != null) {
//      switch (activeInfo.type) {
//        case ShaderVariableType.FLOAT:
//          num vector1Value = data as num;
//          attributes[attributName].vertexAttrib1f(vector1Value);
//          break;
//        case ShaderVariableType.FLOAT_VEC2:
//          Vector2 vector2Value = data as Vector2;
//          attributes[attributName].vertexAttrib2f(vector2Value.x, vector2Value.y);
//          break;
//        case ShaderVariableType.FLOAT_VEC3:
//          Vector3 vector3Value = data as Vector3;
//          attributes[attributName].vertexAttrib3f(vector3Value.x, vector3Value.y, vector3Value.z);
//          break;
//        case ShaderVariableType.FLOAT_VEC4:
//          Vector4 vector4Value = data as Vector4;
//          attributes[attributName].vertexAttrib4f(vector4Value.x, vector4Value.y, vector4Value.z, vector4Value.w);
//          break;
//
//        default:
//          print(
//              'setShaderAttributWithName not set in material.dart for : ${activeInfo}');
//          break;
//      }
//    }
//  }
//
//  // >> Uniforms
//
//  void setShaderUniform(String uniformName, dynamic data, [dynamic data1, dynamic data2, dynamic data3]) {
//    if(uniformLocations[uniformName] == null){
//      print(uniformName);
//    }
//
//    if(uniformLocations[uniformName].data != data){
//
//      WebGLActiveInfo activeInfo = programInfo.uniforms.firstWhere((a)=> a.name == uniformName, orElse:() => null);
//
//      uniformLocations[uniformName].data = data;
//
//      if(activeInfo != null) {
//        switch (activeInfo.type) {
//          case ShaderVariableType.FLOAT_VEC2:
//            if (data1 == null) {
//              uniformLocations[uniformName].uniform2fv(data as Float32List);
//            }else{
//              uniformLocations[uniformName].uniform2f(data as num, data1 as num);
//            }
//            break;
//          case ShaderVariableType.FLOAT_VEC3:
//            if (data1 == null && data2 == null) {
//              uniformLocations[uniformName].uniform3fv(data as Float32List);
//            } else {
//              uniformLocations[uniformName].uniform3f( data as num, data1 as num, data2 as num);
//            }
//            break;
//          case ShaderVariableType.FLOAT_VEC4:
//            if (data1 == null && data2 == null && data3 == null) {
//              uniformLocations[uniformName].uniform4fv(data as Float32List);
//            } else {
//              uniformLocations[uniformName].uniform4f(data as num, data1 as num, data2 as num, data3 as num);
//            }
//            break;
//          case ShaderVariableType.BOOL:
//          case ShaderVariableType.SAMPLER_2D:
//          case ShaderVariableType.SAMPLER_CUBE:
//            uniformLocations[uniformName].uniform1i(data as int);
//            break;
//          case ShaderVariableType.FLOAT:
//            uniformLocations[uniformName].uniform1f(data as num);
//            break;
//          case ShaderVariableType.FLOAT_MAT3:
//            uniformLocations[uniformName].uniformMatrix3fv(data as Matrix3, false);
//            break;
//          case ShaderVariableType.FLOAT_MAT4:
//            uniformLocations[uniformName].uniformMatrix4fv(data as Matrix4, false);
//            break;
//          default:
//            print(
//                'setShaderUniformWithName not set in material.dart for : ${activeInfo}');
//            break;
//        }
//      }
//
//    }
//  }



  // > Animation and Hierarchy
//  Queue<Matrix4> _mvMatrixStack = new Queue();
//
//  void _mvPushMatrix() {
//    _mvMatrixStack.addFirst(Context.modelMatrix.clone());
//  }
//
//  void _mvPopMatrix() {
//    if (_mvMatrixStack.length == 0) {
//      throw new Exception("Invalid popMatrix!"); /// ça veut dire qu'on a fait un pop de trop.
//    }
//    Context.modelMatrix = _mvMatrixStack.removeFirst();
//  }
//
//  void update(Mesh model) {
//    _mvPushMatrix();
//    Context.modelViewMatrix.multiply(model.transform);
//
//    beforeRender(model);
//  }



  // >> Rendering
//
//  void render(Mesh model) {
//    _mvPushMatrix();
//    idem :
//    Context.modelMatrix = (Context.modelMatrix * model.matrix) as Matrix4;
//
//    beforeRender(model);
//
//    GLTFMeshPrimitive primitive = new GLTFMeshPrimitive()
//      ..drawMode = model.primitive.mode
//      ..attributes['POSITION'] = new GLTFAccessor(
//          byteOffset : 0,
//          count : model.primitive.vertexCount
//      );
//
//    if(model.primitive.indices.length > 0) {
//      GLTFAccessor accessorIndices = new GLTFAccessor(
//          count: model.primitive.indices.length,
//          componentType: BufferElementType.UNSIGNED_SHORT
//      );
//      primitive.indicesAccessor = accessorIndices;
//    }
//
//    _drawPrimitive(primitive);
//
//    afterRender(model);
//
//    _mvPopMatrix();
//  }


//  void beforeRender(Mesh model) {
//    program.use();
//
//    setShaderAttributs(model);
//    setShaderUniforms(model);
//    setupBeforeRender();
//  }
//
//  void setShaderAttributs(Mesh model);
//  void setShaderUniforms(Mesh model);
//  void setupBeforeRender(){}
//  void setupAfterRender(){}
//
//  void afterRender(Mesh model){
//    setupAfterRender();
//    disableVertexAttributs();
//  }
//
//  void disableVertexAttributs() {
//    for (String attributName in _attributsNames) {
//      attributes[attributName].enabled = false;
//    }
//  }
//
//}
import 'dart:collection';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/models.dart';
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

  static void assignMaterialTypeToModel(MaterialType materialType, Model model) {
    switch(materialType){
//      case MaterialType.MaterialCustom:
//        newMaterial = new MaterialCustom();
//        break;
      case MaterialType.MaterialPoint:
        model
          ..mesh.mode = DrawMode.POINTS
          ..material = new MaterialPoint(pointSize:5.0, color:new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBase:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBase();
        break;
      case MaterialType.MaterialBaseColor:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBaseColor(new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBaseVertexColor:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBaseVertexColor();
        break;
      case MaterialType.MaterialBaseTexture:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBaseTexture();
        break;
      case MaterialType.MaterialBaseTextureNormal:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBaseTextureNormal();
        break;
//      case MaterialType.MaterialPBR:
//        newMaterial = new MaterialPBR();
//        break;
      case MaterialType.MaterialDepthTexture:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialDepthTexture();
        break;
      case MaterialType.MaterialSkyBox:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialSkyBox();
        break;
      case MaterialType.MaterialReflection:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialReflection();
        break;
      default:
        break;
    }
  }

  List<WebGLShader> shaders;

  String name;
  WebGLProgram program;

  ProgramInfo programInfo;

  List<String> attributsNames = new List();
  Map<String, WebGLAttributLocation> attributes = new Map();

  List<String> uniformsNames = new List();
  Map<String, WebGLUniformLocation> uniformLocations = new Map();

  List<String> buffersNames = new List();
  Map<String, WebGLBuffer> buffers = new Map();

  Material(String vsSource, String fsSource) {
    vsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON +  GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + vsSource;
    fsSource = ((debugging)? Material.GLSL_PRAGMA_DEBUG_ON  + GLSL_PRAGMA_OPTIMIZE_OFF : "" ) + fsSource;
    program = initShaderProgram(vsSource, fsSource);

    programInfo = program.getProgramInfo();
    attributsNames =  programInfo.attributes.map((a)=> a.name).toList();
    uniformsNames = programInfo.uniforms.map((a)=> a.name).toList();

    initBuffers();

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
      uniformLocations[name] = program.getUniformLocation(name);
    }
  }

  render(Model model) {

    _mvPushMatrix();

    if(model is SkyBoxModel)gl.depthTest = false;

    Context.modelViewMatrix.multiply(model.transform);
    program.use();
    setShaderSettings(model);

    //Todo : trouver une meilleur condition pour savoir si on utilise l'un ou l'autre
    if (model.mesh.indices.length > 0 && model.mesh.mode != DrawMode.POINTS) {
      gl.drawElements(model.mesh.mode, model.mesh.indices.length, BufferElementType.UNSIGNED_SHORT, 0);
    } else {
      gl.drawArrays(model.mesh.mode, 0, model.mesh.vertexCount);
    }
    disableVertexAttributs();

    if(model is SkyBoxModel)gl.depthTest = true;

    _mvPopMatrix();
  }

  //Animation
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

  //Todo : Améliorer le process, le rendre plus clair !!
  void setShaderAttributWithName(String attributName, {arrayBuffer, dimension, elementArrayBuffer, data}) {

    if (arrayBuffer!= null && dimension != null) {
      gl.bindBuffer(BufferType.ARRAY_BUFFER, buffers[attributName]);
      attributes[attributName].enabled = true;
      gl.bufferData(
          BufferType.ARRAY_BUFFER, new Float32List.fromList(arrayBuffer), BufferUsageType.STATIC_DRAW);
      attributes[attributName].vertexAttribPointer(dimension, ShaderVariableType.FLOAT, false, 0, 0);
    } else if(elementArrayBuffer != null){
      gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, buffers[attributName]);
      gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(elementArrayBuffer),
          BufferUsageType.STATIC_DRAW);
    }else{
      WebGLActiveInfo activeInfo = programInfo.attributes.firstWhere((a)=> a.name == attributName, orElse:() => null);

      if(activeInfo != null) {
        switch (activeInfo.type) {
          case ShaderVariableType.FLOAT_VEC2:
            break;
          case ShaderVariableType.FLOAT_VEC3:
            break;
          case ShaderVariableType.FLOAT_VEC4:
            Vector4 vector4Value = data;
            attributes[attributName].vertexAttrib4f(vector4Value.x, vector4Value.y, vector4Value.z, vector4Value.w);
            break;
          case ShaderVariableType.FLOAT:
            attributes[attributName].vertexAttrib1f(data);
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
    WebGLActiveInfo activeInfo = programInfo.uniforms.firstWhere((a)=> a.name == uniformName, orElse:() => null);

    if(activeInfo != null) {
      switch (activeInfo.type) {
        case ShaderVariableType.FLOAT_VEC2:
          if (data1 == null && data2 == null) {
            uniformLocations[uniformName].uniform2fv(data);
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

  disableVertexAttributs() {
    for (String name in attributsNames) {
      attributes[name].enabled = false;
    }
  }

  setShaderSettings(Model model) {
    setShaderAttributs(model);
    setShaderUniforms(model);
  }

  setShaderAttributs(Model model);
  setShaderUniforms(Model model);


}


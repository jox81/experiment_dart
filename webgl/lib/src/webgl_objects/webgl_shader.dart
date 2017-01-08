import 'dart:async';
import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';

class ShaderVariableType extends WebGLEnum{

  ShaderVariableType._init(int index, String name):super(index, name){
    types[index] = this;
  }

  static Map<int, WebGLEnum> types = new Map();
  static ShaderVariableType getByIndex(int index){
    types.forEach((k, v)=> print('$k : $v'));
    return types[index];
  }

  static ShaderVariableType FLOAT_VEC2 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_VEC2, 'FLOAT_VEC2');
  static ShaderVariableType FLOAT_VEC3 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_VEC3, 'FLOAT_VEC3');
  static ShaderVariableType FLOAT_VEC4 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_VEC4, 'FLOAT_VEC4');
  static ShaderVariableType INT_VEC2 = new ShaderVariableType._init(WebGL.RenderingContext.INT_VEC2, 'INT_VEC2');
  static ShaderVariableType INT_VEC3 = new ShaderVariableType._init(WebGL.RenderingContext.INT_VEC3, 'INT_VEC3');
  static ShaderVariableType INT_VEC4 = new ShaderVariableType._init(WebGL.RenderingContext.INT_VEC4, 'INT_VEC4');
  static ShaderVariableType BOOL = new ShaderVariableType._init(WebGL.RenderingContext.BOOL, 'BOOL');
  static ShaderVariableType BOOL_VEC2 = new ShaderVariableType._init(WebGL.RenderingContext.BOOL_VEC2, 'BOOL_VEC2');
  static ShaderVariableType BOOL_VEC3 = new ShaderVariableType._init(WebGL.RenderingContext.BOOL_VEC3, 'BOOL_VEC3');
  static ShaderVariableType BOOL_VEC4 = new ShaderVariableType._init(WebGL.RenderingContext.BOOL_VEC4, 'BOOL_VEC4');
  static ShaderVariableType FLOAT_MAT2 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_MAT2, 'FLOAT_MAT2');
  static ShaderVariableType FLOAT_MAT3 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_MAT3, 'FLOAT_MAT3');
  static ShaderVariableType FLOAT_MAT4 = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT_MAT4, 'FLOAT_MAT4');
  static ShaderVariableType SAMPLER_2D = new ShaderVariableType._init(WebGL.RenderingContext.SAMPLER_2D, 'SAMPLER_2D');
  static ShaderVariableType SAMPLER_CUBE = new ShaderVariableType._init(WebGL.RenderingContext.SAMPLER_CUBE, 'SAMPLER_CUBE');
  static ShaderVariableType BYTE = new ShaderVariableType._init(WebGL.RenderingContext.BYTE, 'BYTE');
  static ShaderVariableType UNSIGNED_BYTE = new ShaderVariableType._init(WebGL.RenderingContext.UNSIGNED_BYTE, 'UNSIGNED_BYTE');
  static ShaderVariableType SHORT = new ShaderVariableType._init(WebGL.RenderingContext.SHORT, 'SHORT');
  static ShaderVariableType UNSIGNED_SHORT = new ShaderVariableType._init(WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static ShaderVariableType INT = new ShaderVariableType._init(WebGL.RenderingContext.INT, 'INT');
  static ShaderVariableType UNSIGNED_INT = new ShaderVariableType._init(WebGL.RenderingContext.UNSIGNED_INT, 'UNSIGNED_INT');
  static ShaderVariableType FLOAT = new ShaderVariableType._init(WebGL.RenderingContext.FLOAT, 'FLOAT');

  //Todo : remove this
  // Taken from the WebGL spec:
  // http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
  static Map enumTypes = {
    0x8B50: ShaderVariableType.FLOAT_VEC2,
    0x8B51: ShaderVariableType.FLOAT_VEC3,
    0x8B52: ShaderVariableType.FLOAT_VEC4,
    0x8B53: ShaderVariableType.INT_VEC2,
    0x8B54: ShaderVariableType.INT_VEC3,
    0x8B55: ShaderVariableType.INT_VEC4,
    0x8B56: ShaderVariableType.BOOL,
    0x8B57: ShaderVariableType.BOOL_VEC2,
    0x8B58: ShaderVariableType.BOOL_VEC3,
    0x8B59: ShaderVariableType.BOOL_VEC4,
    0x8B5A: ShaderVariableType.FLOAT_MAT2,
    0x8B5B: ShaderVariableType.FLOAT_MAT3,
    0x8B5C: ShaderVariableType.FLOAT_MAT4,
    0x8B5E: ShaderVariableType.SAMPLER_2D,
    0x8B60: ShaderVariableType.SAMPLER_CUBE,
    0x1400: ShaderVariableType.BYTE,
    0x1401: ShaderVariableType.UNSIGNED_BYTE,
    0x1402: ShaderVariableType.SHORT,
    0x1403: ShaderVariableType.UNSIGNED_SHORT,
    0x1404: ShaderVariableType.INT,
    0x1405: ShaderVariableType.UNSIGNED_INT,
    0x1406: ShaderVariableType.FLOAT
  };
}

class PrecisionType extends WebGLEnum{

  PrecisionType._init(int index, String name):super(index, name){
    types[index] = this;
  }

  static Map<int, WebGLEnum> types = new Map();
  static PrecisionType getByIndex(int index) => types[index];

  static PrecisionType LOW_INT = new PrecisionType._init(WebGL.RenderingContext.LOW_INT, 'LOW_INT');
  static PrecisionType LOW_FLOAT = new PrecisionType._init(WebGL.RenderingContext.LOW_FLOAT, 'LOW_FLOAT');
  static PrecisionType MEDIUM_INT = new PrecisionType._init(WebGL.RenderingContext.MEDIUM_INT, 'MEDIUM_INT');
  static PrecisionType MEDIUM_FLOAT = new PrecisionType._init(WebGL.RenderingContext.MEDIUM_FLOAT, 'MEDIUM_FLOAT');
  static PrecisionType HIGH_INT = new PrecisionType._init(WebGL.RenderingContext.HIGH_INT, 'HIGH_INT');
  static PrecisionType HIGH_FLOAT = new PrecisionType._init(WebGL.RenderingContext.HIGH_FLOAT, 'HIGH_FLOAT');
}

class ShaderType extends WebGLEnum{

  ShaderType._init(int index, String name):super(index, name){
    types[index] = this;
  }

  static Map<int, WebGLEnum> types = new Map();
  static ShaderType getByIndex(int index) => types[index];

  static ShaderType FRAGMENT_SHADER = new ShaderType._init(WebGL.RenderingContext.FRAGMENT_SHADER, 'FRAGMENT_SHADER');
  static ShaderType VERTEX_SHADER = new ShaderType._init(WebGL.RenderingContext.VERTEX_SHADER, 'VERTEX_SHADER');
}

class ShaderParameters extends WebGLEnum{

  ShaderParameters._init(int index, String name):super(index, name){
    types[index] = this;
  }

  static Map<int, WebGLEnum> types = new Map();
  static ShaderParameters getByIndex(int index) => types[index];

  static ShaderParameters DELETE_STATUS = new ShaderParameters._init(WebGL.RenderingContext.DELETE_STATUS, 'DELETE_STATUS');
  static ShaderParameters COMPILE_STATUS = new ShaderParameters._init(WebGL.RenderingContext.COMPILE_STATUS, 'COMPILE_STATUS');
  static ShaderParameters SHADER_TYPE = new ShaderParameters._init(WebGL.RenderingContext.SHADER_TYPE, 'SHADER_TYPE');
}

class VertexAttribGlEnum extends WebGLEnum{

  VertexAttribGlEnum._init(int index, String name):super(index, name){
    types[index] = this;
  }

  static Map<int, WebGLEnum> types = new Map();
  static VertexAttribGlEnum getByIndex(int index) => types[index];

  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED, 'VERTEX_ATTRIB_ARRAY_ENABLED');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE, 'VERTEX_ATTRIB_ARRAY_SIZE');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE, 'VERTEX_ATTRIB_ARRAY_STRIDE');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE, 'VERTEX_ATTRIB_ARRAY_TYPE');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED, 'VERTEX_ATTRIB_ARRAY_NORMALIZED');
  static VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER = new VertexAttribGlEnum._init(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER, 'VERTEX_ATTRIB_ARRAY_POINTER');
  static VertexAttribGlEnum CURRENT_VERTEX_ATTRIB = new VertexAttribGlEnum._init(WebGL.RenderingContext.CURRENT_VERTEX_ATTRIB, 'CURRENT_VERTEX_ATTRIB');
}

class WebGLShader{

  WebGL.Shader webGLShader;

  bool get isShader => gl.ctx.isShader(webGLShader);

  WebGLShader(ShaderType shaderType){
    webGLShader = gl.ctx.createShader(shaderType.index);
  }

  void delete(){
    gl.ctx.deleteShader(webGLShader);
    webGLShader = null;
  }

  String get infoLog{
    return gl.ctx.getShaderInfoLog(webGLShader);
  }

  String get source => gl.ctx.getShaderSource(webGLShader);
  set source(String shaderSource) => gl.ctx.shaderSource(webGLShader, shaderSource);

  void compile(){
    gl.ctx.compileShader(webGLShader);

    if (!compileStatus) {
      print(infoLog);
      window.alert("Could not compile vertex shaders");
    }
  }


  // >>> Parameteres


  dynamic getParameter(ShaderParameters parameter){
    dynamic result =  gl.ctx.getShaderParameter(webGLShader,parameter.index);
    return result;
  }

  // >>> single getParameter

  // > DELETE_STATUS
  bool get deleteStatus => gl.ctx.getShaderParameter(webGLShader,ShaderParameters.DELETE_STATUS.index);
  // > COMPILE_STATUS
  bool get compileStatus => gl.ctx.getShaderParameter(webGLShader,ShaderParameters.COMPILE_STATUS.index);
  // > SHADER_TYPE
  ShaderType get shaderType => ShaderType.getByIndex(gl.ctx.getShaderParameter(webGLShader,ShaderParameters.SHADER_TYPE.index));

  //Why no webGLShader ref ? >>>

  WebGL.ShaderPrecisionFormat getShaderPrecisionFormat(ShaderType shaderType, PrecisionType precisionType){
    return gl.ctx.getShaderPrecisionFormat(shaderType.index, precisionType.index);
  }

  //Todo return multiType...
  dynamic getVertexAttrib(int vertexAttributePosition, VertexAttribGlEnum vertexAttribGlEnum){
    return gl.ctx.getVertexAttrib(vertexAttributePosition,vertexAttribGlEnum.index);
  }

  //placer dans attribut_location ?
  int getVertexAttribOffset(int vertexAttributePosition){
    return gl.ctx.getVertexAttribOffset(vertexAttributePosition, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_POINTER.index);
  }

}

class ShaderSource{
  static Map<String , List<String>> shadersPath = {
    'material_point' :[
      '/application/shaders/material_point/material_point.vs.glsl',
      '/application/shaders/material_point/material_point.fs.glsl'
    ],
    'material_base' :[
      '/application/shaders/material_base/material_base.vs.glsl',
      '/application/shaders/material_base/material_base.fs.glsl'
    ],
    'material_base_color' :[
      '/application/shaders/material_base_color/material_base_color.vs.glsl',
      '/application/shaders/material_base_color/material_base_color.fs.glsl'
    ],
    'material_base_vertex_color' :[
      '/application/shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl',
      '/application/shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl'
    ],
    'material_base_texture' :[
      '/application/shaders/material_base_texture/material_base_texture.vs.glsl',
      '/application/shaders/material_base_texture/material_base_texture.fs.glsl'
    ],
    'material_base_texture_normal' :[
      '/application/shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl',
      '/application/shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl'
    ],
    'material_pbr' :[
      '/application/shaders/material_pbr/material_pbr.vs.glsl',
      '/application/shaders/material_pbr/material_pbr.fs.glsl'
    ]
  };
  static Map<String, ShaderSource> sources = new Map();

  static Future loadShaders() async {

    for(String key in shadersPath.keys){

      ShaderSource shaderSource = new ShaderSource()
        ..shaderType = key
        ..vertexShaderPath = shadersPath[key][0]
        ..fragmentShaderPath = shadersPath[key][1];
      await shaderSource._loadShader();

      sources[shaderSource.shaderType] = shaderSource;
    }
  }

  String shaderType;

  String vertexShaderPath;
  String fragmentShaderPath;

  String vsCode;
  String fsCode;

  ShaderSource();

  Future _loadShader()async {
    vsCode = await Utils.loadGlslShader(vertexShaderPath);
    fsCode = await Utils.loadGlslShader(fragmentShaderPath);
  }
}
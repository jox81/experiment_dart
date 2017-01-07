import 'dart:async';
import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';

class ShaderVariableType{
  final int index;
  const ShaderVariableType(this.index);

  static const ShaderVariableType FLOAT_VEC2 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC2);
  static const ShaderVariableType FLOAT_VEC3 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC3);
  static const ShaderVariableType FLOAT_VEC4 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_VEC4);
  static const ShaderVariableType INT_VEC2 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC2);
  static const ShaderVariableType INT_VEC3 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC3);
  static const ShaderVariableType INT_VEC4 = const ShaderVariableType(WebGL.RenderingContext.INT_VEC4);
  static const ShaderVariableType BOOL = const ShaderVariableType(WebGL.RenderingContext.BOOL);
  static const ShaderVariableType BOOL_VEC2 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC2);
  static const ShaderVariableType BOOL_VEC3 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC3);
  static const ShaderVariableType BOOL_VEC4 = const ShaderVariableType(WebGL.RenderingContext.BOOL_VEC4);
  static const ShaderVariableType FLOAT_MAT2 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT2);
  static const ShaderVariableType FLOAT_MAT3 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT3);
  static const ShaderVariableType FLOAT_MAT4 = const ShaderVariableType(WebGL.RenderingContext.FLOAT_MAT4);
  static const ShaderVariableType SAMPLER_2D = const ShaderVariableType(WebGL.RenderingContext.SAMPLER_2D);
  static const ShaderVariableType SAMPLER_CUBE = const ShaderVariableType(WebGL.RenderingContext.SAMPLER_CUBE);
  static const ShaderVariableType BYTE = const ShaderVariableType(WebGL.RenderingContext.BYTE);
  static const ShaderVariableType UNSIGNED_BYTE = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_BYTE);
  static const ShaderVariableType SHORT = const ShaderVariableType(WebGL.RenderingContext.SHORT);
  static const ShaderVariableType UNSIGNED_SHORT = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_SHORT);
  static const ShaderVariableType INT = const ShaderVariableType(WebGL.RenderingContext.INT);
  static const ShaderVariableType UNSIGNED_INT = const ShaderVariableType(WebGL.RenderingContext.UNSIGNED_INT);
  static const ShaderVariableType FLOAT = const ShaderVariableType(WebGL.RenderingContext.FLOAT);

  get name => null;

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

class PrecisionType{
  final index;
  const PrecisionType(this.index);

  static const PrecisionType LOW_INT = const PrecisionType(WebGL.RenderingContext.LOW_INT);
  static const PrecisionType LOW_FLOAT = const PrecisionType(WebGL.RenderingContext.LOW_FLOAT);
  static const PrecisionType MEDIUM_INT = const PrecisionType(WebGL.RenderingContext.MEDIUM_INT);
  static const PrecisionType MEDIUM_FLOAT = const PrecisionType(WebGL.RenderingContext.MEDIUM_FLOAT);
  static const PrecisionType HIGH_INT = const PrecisionType(WebGL.RenderingContext.HIGH_INT);
  static const PrecisionType HIGH_FLOAT = const PrecisionType(WebGL.RenderingContext.HIGH_FLOAT);
}

class ShaderType{
  final index;
  const ShaderType(this.index);

  static const ShaderType FRAGMENT_SHADER = const ShaderType(WebGL.RenderingContext.FRAGMENT_SHADER);
  static const ShaderType VERTEX_SHADER = const ShaderType(WebGL.RenderingContext.VERTEX_SHADER);
}

class ShaderParameters{
  final index;
  const ShaderParameters(this.index);

  static const ShaderParameters DELETE_STATUS = const ShaderParameters(WebGL.RenderingContext.DELETE_STATUS);
  static const ShaderParameters COMPILE_STATUS = const ShaderParameters(WebGL.RenderingContext.COMPILE_STATUS);
  static const ShaderParameters SHADER_TYPE = const ShaderParameters(WebGL.RenderingContext.SHADER_TYPE);
}

class VertexAttribGlEnum{
  final index;
  const VertexAttribGlEnum(this.index);

  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER = const VertexAttribGlEnum(WebGL.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER);
  static const VertexAttribGlEnum CURRENT_VERTEX_ATTRIB = const VertexAttribGlEnum(WebGL.RenderingContext.CURRENT_VERTEX_ATTRIB);
}

class WebGLShader{

  WebGL.Shader webGLShader;

  bool get isBuffer => gl.ctx.isShader(webGLShader);

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

  String get source{
    return gl.ctx.getShaderSource(webGLShader);
  }

  set source(String shaderSource){
    gl.ctx.shaderSource(webGLShader, shaderSource);
  }

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
  ShaderType get shaderType => new ShaderType(gl.ctx.getShaderParameter(webGLShader,ShaderParameters.SHADER_TYPE.index));

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
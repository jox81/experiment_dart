import 'dart:async';
import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';

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
import 'dart:async';
import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_shader_precision_format.dart';
@MirrorsUsed(
    targets: const [
      WebGLShader,
      ShaderSource,
    ],
    override: '*')
import 'dart:mirrors';

class WebGLShader extends WebGLObject{

  final WebGL.Shader webGLShader;

  WebGLShader(ShaderType shaderType):this.webGLShader = gl.ctx.createShader(shaderType.index);
  WebGLShader.fromWebGL(this.webGLShader);

  @override
  void delete() => gl.ctx.deleteShader(webGLShader);

  void attach(WebGLProgram webGLProgram){
    gl.ctx.attachShader(webGLProgram.webGLProgram, webGLShader);
  }

  void detachShader(WebGLProgram webGLProgram){
    gl.ctx.detachShader(webGLProgram.webGLProgram, webGLShader);
  }

  ////

  bool get isShader => gl.ctx.isShader(webGLShader);

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

  //Why no webGLShader ref ? should be in program or in renderingcontext ?>>>

  WebGLShaderPrecisionFormat getShaderPrecisionFormat(ShaderType shaderType, PrecisionType precisionType){
    return new WebGLShaderPrecisionFormat.fromWebGL(gl.ctx.getShaderPrecisionFormat(shaderType.index, precisionType.index));
  }



  //placer dans attribut_location ?
  ///returns the address of a specified vertex attribute.
  int getVertexAttribOffset(int vertexAttributeIndex){
    return gl.ctx.getVertexAttribOffset(vertexAttributeIndex, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_POINTER.index);
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

  void logShaderInfos() {
    Utils.log("Shader Infos", () {
      print('shaderType : ${shaderType}');
      print('isShader : ${isShader}');
      print('compileStatus : ${compileStatus}');
      print('deleteStatus : ${deleteStatus}');
      print('infoLog : ${infoLog}');
      print('source : \n\n${source}');
    });
  }
}

class ShaderSource{
  static Map<String , List<String>> shadersPath = {
    'material_point' :[
      '/shaders/material_point/material_point.vs.glsl',
      '/shaders/material_point/material_point.fs.glsl'
    ],
    'material_base' :[
      '/shaders/material_base/material_base.vs.glsl',
      '/shaders/material_base/material_base.fs.glsl'
    ],
    'material_base_color' :[
      '/shaders/material_base_color/material_base_color.vs.glsl',
      '/shaders/material_base_color/material_base_color.fs.glsl'
    ],
    'material_base_vertex_color' :[
      '/shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl',
      '/shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl'
    ],
    'material_base_texture' :[
      '/shaders/material_base_texture/material_base_texture.vs.glsl',
      '/shaders/material_base_texture/material_base_texture.fs.glsl'
    ],
    'material_depth_texture' :[
      '/shaders/material_depth_texture/material_depth_texture.vs.glsl',
      '/shaders/material_depth_texture/material_depth_texture.fs.glsl'
    ],
    'material_base_texture_normal' :[
      '/shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl',
      '/shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl'
    ],
    'material_pbr' :[
      '/shaders/material_pbr/material_pbr.vs.glsl',
      '/shaders/material_pbr/material_pbr.fs.glsl'
    ],
    'material_skybox' :[
      '/shaders/material_skybox/material_skybox.vs.glsl',
      '/shaders/material_skybox/material_skybox.fs.glsl'
    ],
    'material_reflection' :[
      '/shaders/reflection/reflection.vs.glsl',
      '/shaders/reflection/reflection.fs.glsl'
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
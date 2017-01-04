import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/shaders.dart';

class ProgramParameterGlEnum{
  final index;
  const ProgramParameterGlEnum(this.index);

  static const ProgramParameterGlEnum DELETE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.DELETE_STATUS);
  static const ProgramParameterGlEnum LINK_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.LINK_STATUS);
  static const ProgramParameterGlEnum VALIDATE_STATUS = const ProgramParameterGlEnum(WebGL.RenderingContext.VALIDATE_STATUS);
  static const ProgramParameterGlEnum ATTACHED_SHADERS = const ProgramParameterGlEnum(WebGL.RenderingContext.ATTACHED_SHADERS);
  static const ProgramParameterGlEnum ACTIVE_ATTRIBUTES = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_ATTRIBUTES);
  static const ProgramParameterGlEnum ACTIVE_UNIFORMS = const ProgramParameterGlEnum(WebGL.RenderingContext.ACTIVE_UNIFORMS);
}

class WebGLProgram{

  WebGL.Program webGLProgram;

  bool get isBuffer => gl.ctx.isProgram(webGLProgram);

  WebGLProgram(){
    webGLProgram = gl.ctx.createProgram();
  }

  void delete(){
    gl.ctx.deleteProgram(webGLProgram);
  }

  WebGL.ActiveInfo getActiveAttrib(int activeAttributIndex){
    return gl.ctx.getActiveAttrib(webGLProgram, activeAttributIndex);
  }

  WebGL.ActiveInfo getActiveUniform(int activeUniformIndex){
    return gl.ctx.getActiveUniform(webGLProgram, activeUniformIndex);
  }

  int getAttribLocation(String variableName){
    return gl.ctx.getAttribLocation(webGLProgram, variableName);
  }

  String get infoLog{
    return gl.ctx.getProgramInfoLog(webGLProgram);
  }

  WebGL.UniformLocation getUniformLocation(String variableName){
    return gl.ctx.getUniformLocation(webGLProgram,variableName);
  }

  String getUniform(WebGL.UniformLocation location){
    return gl.ctx.getUniform(webGLProgram, location);
  }

  List<WebGL.Shader> get attachedShaders{
    return gl.ctx.getAttachedShaders(webGLProgram);
  }

  void attachShader(WebGLShader shader){
    gl.ctx.attachShader(webGLProgram, shader.webGLShader);
  }

  void link(){
    gl.ctx.linkProgram(webGLProgram);

    if (!linkStatus) {
      print(infoLog);
      window.alert("Could not initialise shaders");
    }
  }

  void use(){
    gl.ctx.useProgram(webGLProgram);
  }

  void validate(){
    gl.ctx.validateProgram(webGLProgram);

    if (!linkStatus) {
      print(infoLog);
      window.alert("Could not compile program");
    }
  }

  dynamic getParameter(ProgramParameterGlEnum parameter){
    return gl.ctx.getProgramParameter(webGLProgram, parameter.index);
  }
  bool get deleteStatus{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.DELETE_STATUS.index);
  }
  bool get linkStatus{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.LINK_STATUS.index);
  }
  bool get validateStatus{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.VALIDATE_STATUS.index);
  }
  int get attachedShadersCount{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ATTACHED_SHADERS.index);
  }
  int get activeAttributsCount{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_ATTRIBUTES.index);
  }
  int get activeUnifromsCount{
    return gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_UNIFORMS.index);
  }

  //Custom
  ProgramInfo getProgramInfo(){
    return UtilsShader.getProgramInfo(this);
  }
}

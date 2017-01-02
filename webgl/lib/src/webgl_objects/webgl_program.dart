import 'dart:html';
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/shaders.dart';

class ProgramParameterGlEnum{
  final index;
  const ProgramParameterGlEnum(this.index);

  static const ProgramParameterGlEnum DELETE_STATUS = const ProgramParameterGlEnum(WebGl.RenderingContext.DELETE_STATUS);
  static const ProgramParameterGlEnum LINK_STATUS = const ProgramParameterGlEnum(WebGl.RenderingContext.LINK_STATUS);
  static const ProgramParameterGlEnum VALIDATE_STATUS = const ProgramParameterGlEnum(WebGl.RenderingContext.VALIDATE_STATUS);
  static const ProgramParameterGlEnum ATTACHED_SHADERS = const ProgramParameterGlEnum(WebGl.RenderingContext.ATTACHED_SHADERS);
  static const ProgramParameterGlEnum ACTIVE_ATTRIBUTES = const ProgramParameterGlEnum(WebGl.RenderingContext.ACTIVE_ATTRIBUTES);
  static const ProgramParameterGlEnum ACTIVE_UNIFORMS = const ProgramParameterGlEnum(WebGl.RenderingContext.ACTIVE_UNIFORMS);
}

class WebGLProgram{

  WebGl.Program webGLProgram;

  WebGLProgram(){
    webGLProgram = gl.ctx.createProgram();
  }

  WebGl.ActiveInfo getActiveAttrib(int activeAttributIndex){
    return gl.ctx.getActiveAttrib(webGLProgram, activeAttributIndex);
  }

  WebGl.ActiveInfo getActiveUniform(int activeUniformIndex){
    return gl.ctx.getActiveUniform(webGLProgram, activeUniformIndex);
  }

  int getAttribLocation(String variableName){
    return gl.ctx.getAttribLocation(webGLProgram, variableName);
  }

  String get infoLog{
    return gl.ctx.getProgramInfoLog(webGLProgram);
  }

  WebGl.UniformLocation getUniformLocation(String variableName){
    return gl.ctx.getUniformLocation(webGLProgram,variableName);
  }

  String getUniform(WebGl.UniformLocation location){
    return gl.ctx.getUniform(webGLProgram, location);
  }

  List<WebGl.Shader> get attachedShaders{
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

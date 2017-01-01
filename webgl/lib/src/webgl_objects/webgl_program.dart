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
    webGLProgram = gl.createProgram();
  }

  WebGl.ActiveInfo getActiveAttrib(int activeAttributIndex){
    return gl.getActiveAttrib(webGLProgram, activeAttributIndex);
  }

  WebGl.ActiveInfo getActiveUniform(int activeUniformIndex){
    return gl.getActiveUniform(webGLProgram, activeUniformIndex);
  }

  int getAttribLocation(String variableName){
    return gl.getAttribLocation(webGLProgram, variableName);
  }

  String get infoLog{
    return gl.getProgramInfoLog(webGLProgram);
  }

  WebGl.UniformLocation getUniformLocation(String variableName){
    return gl.getUniformLocation(webGLProgram,variableName);
  }

  String getUniform(WebGl.UniformLocation location){
    return gl.getUniform(webGLProgram, location);
  }

  List<WebGl.Shader> get attachedShaders{
    return gl.getAttachedShaders(webGLProgram);
  }

  void attachShader(WebGLShader shader){
    gl.attachShader(webGLProgram, shader.webGLShader);
  }

  void link(){
    gl.linkProgram(webGLProgram);

    if (!linkStatus) {
      print(infoLog);
      window.alert("Could not initialise shaders");
    }
  }

  void use(){
    gl.useProgram(webGLProgram);
  }

  dynamic getParameter(ProgramParameterGlEnum parameter){
    return gl.getProgramParameter(webGLProgram, parameter.index);
  }
  bool get deleteStatus{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.DELETE_STATUS.index);
  }
  bool get linkStatus{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.LINK_STATUS.index);
  }
  bool get validateStatus{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.VALIDATE_STATUS.index);
  }
  int get attachedShadersCount{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ATTACHED_SHADERS.index);
  }
  int get activeAttributsCount{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_ATTRIBUTES.index);
  }
  int get activeUnifromsCount{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_UNIFORMS.index);
  }

  //Custom
  ProgramInfo getProgramInfo(){
    return UtilsShader.getProgramInfo(this);
  }
}

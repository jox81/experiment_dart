import 'dart:html';
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/gl_objects/shader.dart';
import 'package:webgl/src/shaders.dart';

class ProgramParameterGlEnum{
  final index;
  const ProgramParameterGlEnum(this.index);

  static ProgramParameterGlEnum get DELETE_STATUS => new ProgramParameterGlEnum(WebGl.RenderingContext.DELETE_STATUS);
  static ProgramParameterGlEnum get LINK_STATUS => new ProgramParameterGlEnum(WebGl.RenderingContext.LINK_STATUS);
  static ProgramParameterGlEnum get VALIDATE_STATUS => new ProgramParameterGlEnum(WebGl.RenderingContext.VALIDATE_STATUS);
  static ProgramParameterGlEnum get ATTACHED_SHADERS => new ProgramParameterGlEnum(WebGl.RenderingContext.ATTACHED_SHADERS);
  static ProgramParameterGlEnum get ACTIVE_ATTRIBUTES => new ProgramParameterGlEnum(WebGl.RenderingContext.ACTIVE_ATTRIBUTES);
  static ProgramParameterGlEnum get ACTIVE_UNIFORMS => new ProgramParameterGlEnum(WebGl.RenderingContext.ACTIVE_UNIFORMS);
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

  bool get linkStatus{
    return gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.LINK_STATUS.index);
  }

  void use(){
    gl.useProgram(webGLProgram);
  }

  dynamic getParameter(ProgramParameterGlEnum parameter){
    return gl.getProgramParameter(webGLProgram, parameter.index);
  }



  //Custom
  ProgramInfo getProgramInfo(){
    return UtilsShader.getProgramInfo(webGLProgram);
  }
}

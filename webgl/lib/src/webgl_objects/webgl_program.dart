import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_uniform_location.dart';

class WebGLProgram{

  WebGL.Program webGLProgram;

  bool get isBuffer => gl.ctx.isProgram(webGLProgram);

  WebGLProgram(){
    webGLProgram = gl.ctx.createProgram();
  }
  WebGLProgram.fromWebgl(this.webGLProgram);

  void delete(){
    gl.ctx.deleteProgram(webGLProgram);
    webGLProgram = null;
  }

  WebGL.ActiveInfo getActiveAttrib(int activeAttributIndex){
    return gl.ctx.getActiveAttrib(webGLProgram, activeAttributIndex);
  }

  WebGL.ActiveInfo getActiveUniform(int activeUniformIndex){
    return gl.ctx.getActiveUniform(webGLProgram, activeUniformIndex);
  }

  WebGLAttributLocation getAttribLocation(String variableName){
    return new WebGLAttributLocation(gl.ctx.getAttribLocation(webGLProgram, variableName));
  }

  WebGLUniformLocation getUniformLocation(String variableName){
    return new WebGLUniformLocation(gl.ctx.getUniformLocation(webGLProgram,variableName));
  }

  //Todo return multitype...
  dynamic getUniform(WebGL.UniformLocation location){
    return gl.ctx.getUniform(webGLProgram, location);
  }

  List<WebGL.Shader> get attachedShaders{
    return gl.ctx.getAttachedShaders(webGLProgram);
  }

  void attachShader(WebGLShader shader){
    gl.ctx.attachShader(webGLProgram, shader.webGLShader);
  }

  void detachShader(WebGLShader shader){
    gl.ctx.detachShader(webGLProgram, shader.webGLShader);
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

  void bindAttribLocation(WebGLAttributLocation attributLocation, String variableName){
    gl.ctx.bindAttribLocation(webGLProgram, attributLocation.location, variableName);
  }


  String get infoLog => gl.ctx.getProgramInfoLog(webGLProgram);


  // >>> Parameteres


  dynamic getParameter(ProgramParameterGlEnum parameter){
    return gl.ctx.getProgramParameter(webGLProgram, parameter.index);
  }

  // >>> single getParameter

  // > DELETE_STATUS
  bool get deleteStatus => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.DELETE_STATUS.index);
  // > LINK_STATUS
  bool get linkStatus => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.LINK_STATUS.index);
  // > VALIDATE_STATUS
  bool get validateStatus => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.VALIDATE_STATUS.index);
  // > ATTACHED_SHADERS
  int get attachedShadersCount => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ATTACHED_SHADERS.index);
  // > ACTIVE_ATTRIBUTES
  int get activeAttributsCount => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_ATTRIBUTES.index);
  // > ACTIVE_UNIFORMS
  int get activeUnifromsCount => gl.ctx.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_UNIFORMS.index);

  //Custom
  ProgramInfo getProgramInfo(){
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    for (var i = 0; i < activeAttributsCount; i++) {
      WebGLActiveInfo attribute = new WebGLActiveInfo(getActiveAttrib(i));
      attribute.shaderVariableType = ShaderVariableType.enumTypes[attribute.activeInfo.type];
      result.attributes.add(attribute);
      result.attributeCount += attribute.activeInfo.size;
    }

    // Loop through active uniforms
    var activeUniforms = getParameter(ProgramParameterGlEnum.ACTIVE_UNIFORMS);
    for (var i = 0; i < activeUniforms; i++) {
      WebGLActiveInfo uniform = new WebGLActiveInfo(getActiveUniform(i));
      uniform.shaderVariableType = ShaderVariableType.enumTypes[uniform.activeInfo.type];
      result.uniforms.add(uniform);
      result.uniformCount += uniform.activeInfo.size;
    }

    return result;
  }

}

import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_uniform_location.dart';

class WebGLProgram extends WebGLObject{

  final WebGL.Program webGLProgram;

  WebGLProgram() : this.webGLProgram = gl.ctx.createProgram();
  WebGLProgram.fromWebGL(this.webGLProgram);

  @override
  void delete() => gl.ctx.deleteProgram(webGLProgram);

  List<WebGL.Shader> get attachedShaders{
    return gl.ctx.getAttachedShaders(webGLProgram);
  }

  void attachShader(WebGLShader shader){
    gl.ctx.attachShader(webGLProgram, shader.webGLShader);
  }

  void detachShader(WebGLShader shader){
    gl.ctx.detachShader(webGLProgram, shader.webGLShader);
  }

  void use(){
    gl.ctx.useProgram(webGLProgram);
  }
  ////


  bool get isProgram => gl.ctx.isProgram(webGLProgram);

  WebGLActiveInfo getActiveAttrib(int activeAttributIndex){
    return new WebGLActiveInfo.fromWebGL(gl.ctx.getActiveAttrib(webGLProgram, activeAttributIndex));
  }

  WebGLActiveInfo getActiveUniform(int activeUniformIndex){
    return new WebGLActiveInfo.fromWebGL(gl.ctx.getActiveUniform(webGLProgram, activeUniformIndex));
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


  void link(){
    gl.ctx.linkProgram(webGLProgram);

    if (!linkStatus) {
      print(infoLog);
      window.alert("Could not initialise shaders");
    }
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

  //Custom
  ProgramInfo getProgramInfo(){
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    for (var i = 0; i < activeAttributsCount; i++) {
      WebGLActiveInfo attribute = getActiveAttrib(i);
      result.attributes.add(attribute);
      result.attributeCount += attribute.size;//??
    }

    // Loop through active uniforms
    for (var i = 0; i < activeUnifromsCount; i++) {
      WebGLActiveInfo uniform = getActiveUniform(i);
      result.uniforms.add(uniform);
      result.uniformCount += uniform.size;//??
    }

    return result;
  }


  // >>> Parameteres
  //dynamic getParameter(ProgramParameterGlEnum parameter){
  //  return gl.ctx.getProgramParameter(webGLProgram, parameter.index);
  //}
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

  void logProgramInfos() {
    Utils.log("Program Infos", () {
      print('isProgram : ${isProgram}');
      print('linkStatus : ${linkStatus}');
      print('validateStatus : ${validateStatus}');
      print('deleteStatus : ${deleteStatus}');
      print('attachedShadersCount : ${attachedShadersCount}');

      print('activeAttributsCount : ${activeAttributsCount}');
      for (var i = 0; i < activeAttributsCount; i++) {
        print('-$i- ${getActiveAttrib(i)}');
      }

      print('activeUnifromsCount : ${activeUnifromsCount}');
      for (var i = 0; i < activeUnifromsCount; i++) {
        print('-$i- ${getActiveUniform(i)}');
      }

    });
  }
}

import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
@MirrorsUsed(
    targets: const [
      ProgramInfo,
      WebGLProgram,
    ],
    override: '*')
import 'dart:mirrors';

class ProgramInfo extends IEditElement {
  int attributeCount = 0;
  List<WebGLActiveInfo> attributes = new List();

  int uniformCount = 0;
  List<WebGLActiveInfo> uniforms = new List();
}

class WebGLProgram extends WebGLObject{

  final WebGL.Program webGLProgram;

  WebGLProgram() : this.webGLProgram = gl.ctx.createProgram();
  WebGLProgram.fromWebGL(this.webGLProgram);

  @override
  void delete() => gl.ctx.deleteProgram(webGLProgram);

  List<WebGLShader> get attachedShaders{
    return gl.ctx.getAttachedShaders(webGLProgram).map((s)=> new WebGLShader.fromWebGL(s)).toList();
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
  String get infoLog => gl.ctx.getProgramInfoLog(webGLProgram);

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

  //Attributs

  ///Returns a new WebGLActiveInfo object describing the size, type and name of
  ///the vertex attribute at the passed index of the passed program object.
  WebGLActiveInfo getActiveAttribInfo(int activeAttributIndex){
    return new WebGLActiveInfo.fromWebGL(gl.ctx.getActiveAttrib(webGLProgram, activeAttributIndex));
  }

  ///Return a new WebGLUniformLocation that represents the location of a
  ///specific vertex attribut variable within a program object.
  WebGLAttributLocation getAttribLocation(String variableName){
    return new WebGLAttributLocation(gl.ctx.getAttribLocation(webGLProgram, variableName));
  }

  ///associate a generic vertex attribute index with a named attribute variable
  //??
  void bindAttribLocation(WebGLAttributLocation attributLocation, String variableName){
    gl.ctx.bindAttribLocation(webGLProgram, attributLocation.location, variableName);
  }

  //Uniforms

  ///Returns a new WebGLActiveInfo object describing the size, type and name of
  ///the uniform at the passed index of the passed program object
  WebGLActiveInfo getActiveUniform(int activeUniformIndex){
    return new WebGLActiveInfo.fromWebGL(gl.ctx.getActiveUniform(webGLProgram, activeUniformIndex));
  }

  ///Return a new WebGLUniformLocation that represents the location of a
  ///specific uniform variable within a program object.
  WebGLUniformLocation getUniformLocation(String variableName){
    return new WebGLUniformLocation(this,variableName);
  }

  ///Return the uniform value at the passed location in the passed program.
  ///The type returned is dependent on the uniform type
  dynamic getUniformValue(WebGLUniformLocation location){
    return gl.ctx.getUniform(webGLProgram, location.webGLUniformLocation);
  }

  //Custom
  ProgramInfo getProgramInfo(){
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    for (var i = 0; i < activeAttributsCount; i++) {
      WebGLActiveInfo attribute = getActiveAttribInfo(i);
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
    UtilsAssets.log("Program Infos", () {
      print('isProgram : ${isProgram}');
      print('linkStatus : ${linkStatus}');
      print('validateStatus : ${validateStatus}');
      print('deleteStatus : ${deleteStatus}');
      print('attachedShadersCount : ${attachedShadersCount}');

      print('##################################################################');
      print('activeAttributsCount : ${activeAttributsCount}');
      for (var i = 0; i < activeAttributsCount; i++) {
        print('-$i-');
        WebGLActiveInfo attribute = getActiveAttribInfo(i);
        print('${attribute}');
        WebGLAttributLocation attribLocation = getAttribLocation(attribute.name);
        attribLocation.logVertexAttributInfos();
      }

      print('##################################################################');
      print('activeUnifromsCount : ${activeUnifromsCount}');
      for (var i = 0; i < activeUnifromsCount; i++) {
        print('-$i-');
        WebGLActiveInfo activeInfo = getActiveUniform(i);
        print('${activeInfo}');
        WebGLUniformLocation uniformLocation = getUniformLocation(activeInfo.name);
//        print('getUniformLocation : ${uniformLocation}'); //Inutile car il n'y a aucune infos associées
        print('getUniformValue : ${getUniformValue(uniformLocation)}');
      }

    });
  }
}

import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_shader_precision_format.dart';

class WebGLShader extends WebGLObject{

  final WebGL.Shader webGLShader;

  /// ShaderType shaderType
  WebGLShader(int shaderType):this.webGLShader = gl.createShader(shaderType);
  WebGLShader.fromWebGL(this.webGLShader);

  bool get isShader => gl.isShader(webGLShader);

  // > SHADER_TYPE
  /// ShaderType shaderType
  int get shaderType => gl.getShaderParameter(webGLShader,ShaderParameters.SHADER_TYPE) as int;
  // > COMPILE_STATUS
  bool get compileStatus => gl.getShaderParameter(webGLShader,ShaderParameters.COMPILE_STATUS) as bool;


  String get source => gl.getShaderSource(webGLShader);
  set source(String shaderSource) => gl.shaderSource(webGLShader, shaderSource);

  String get infoLog{
    return gl.getShaderInfoLog(webGLShader);
  }

  // > DELETE_STATUS
  bool get deleteStatus => gl.getShaderParameter(webGLShader,ShaderParameters.DELETE_STATUS) as bool;

  @override
  void delete() => gl.deleteShader(webGLShader);

  void attach(WebGLProgram webGLProgram){
    gl.attachShader(webGLProgram.webGLProgram, webGLShader);
  }

  void detachShader(WebGLProgram webGLProgram){
    gl.detachShader(webGLProgram.webGLProgram, webGLShader);
  }

  void compile(){
    gl.compileShader(webGLShader);

    if (!compileStatus) {
      print(infoLog);
      window.alert("Could not compile vertex shaders");
    }
  }

  /// ShaderType shaderType
  /// PrecisionType precisionType
  WebGLShaderPrecisionFormat getShaderPrecisionFormat(int shaderType, int precisionType){
    return new WebGLShaderPrecisionFormat.fromWebGL(gl.getShaderPrecisionFormat(shaderType, precisionType));
  }

  //placer dans attribut_location ?
  ///returns the address of a specified vertex attribute.
  int getVertexAttribOffset(int vertexAttributeIndex){
    return gl.getVertexAttribOffset(vertexAttributeIndex, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_POINTER);
  }

  /// ShaderParameters parameter
  dynamic getParameter(int parameter){
    dynamic result =  gl.getShaderParameter(webGLShader,parameter);
    return result;
  }

  void logShaderInfos() {
    Debug.log("Shader Infos", () {
      print('shaderType : ${shaderType}');
      print('isShader : ${isShader}');
      print('compileStatus : ${compileStatus}');
      print('deleteStatus : ${deleteStatus}');
      print('infoLog : ${infoLog}');
      print('source : \n\n${source}');
    });
  }
}

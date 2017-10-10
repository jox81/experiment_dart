import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_shader_precision_format.dart';
@MirrorsUsed(
    targets: const [
      WebGLShader,
    ],
    override: '*')
import 'dart:mirrors';

class WebGLShader extends WebGLObject{

  final WebGL.Shader webGLShader;

  WebGLShader(ShaderType shaderType):this.webGLShader = gl.ctx.createShader(shaderType.index);
  WebGLShader.fromWebGL(this.webGLShader);

  bool get isShader => gl.ctx.isShader(webGLShader);

  // > SHADER_TYPE
  ShaderType get shaderType => ShaderType.getByIndex(gl.ctx.getShaderParameter(webGLShader,ShaderParameters.SHADER_TYPE.index) as int) as ShaderType;
  // > COMPILE_STATUS
  bool get compileStatus => gl.ctx.getShaderParameter(webGLShader,ShaderParameters.COMPILE_STATUS.index) as bool;


  String get source => gl.ctx.getShaderSource(webGLShader);
  set source(String shaderSource) => gl.ctx.shaderSource(webGLShader, shaderSource);

  String get infoLog{
    return gl.ctx.getShaderInfoLog(webGLShader);
  }

  // > DELETE_STATUS
  bool get deleteStatus => gl.ctx.getShaderParameter(webGLShader,ShaderParameters.DELETE_STATUS.index) as bool;

  @override
  void delete() => gl.ctx.deleteShader(webGLShader);

  void attach(WebGLProgram webGLProgram){
    gl.ctx.attachShader(webGLProgram.webGLProgram, webGLShader);
  }

  void detachShader(WebGLProgram webGLProgram){
    gl.ctx.detachShader(webGLProgram.webGLProgram, webGLShader);
  }

  void compile(){
    gl.ctx.compileShader(webGLShader);

    if (!compileStatus) {
      print(infoLog);
      window.alert("Could not compile vertex shaders");
    }
  }

  WebGLShaderPrecisionFormat getShaderPrecisionFormat(ShaderType shaderType, PrecisionType precisionType){
    return new WebGLShaderPrecisionFormat.fromWebGL(gl.ctx.getShaderPrecisionFormat(shaderType.index, precisionType.index));
  }

  //placer dans attribut_location ?
  ///returns the address of a specified vertex attribute.
  int getVertexAttribOffset(int vertexAttributeIndex){
    return gl.ctx.getVertexAttribOffset(vertexAttributeIndex, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_POINTER.index);
  }

  dynamic getParameter(ShaderParameters parameter){
    dynamic result =  gl.ctx.getShaderParameter(webGLShader,parameter.index);
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

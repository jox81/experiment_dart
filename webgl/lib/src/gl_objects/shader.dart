import 'dart:html';
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';

class PrecisionType{
  final index;
  const PrecisionType(this.index);

  static PrecisionType get LOW_FLOAT => new PrecisionType(WebGl.RenderingContext.LOW_FLOAT);
  static PrecisionType get MEDIUM_FLOAT => new PrecisionType(WebGl.RenderingContext.MEDIUM_FLOAT);
  static PrecisionType get HIGH_FLOAT => new PrecisionType(WebGl.RenderingContext.HIGH_FLOAT);
  static PrecisionType get LOW_INT => new PrecisionType(WebGl.RenderingContext.LOW_INT);
  static PrecisionType get MEDIUM_INT => new PrecisionType(WebGl.RenderingContext.MEDIUM_INT);
  static PrecisionType get HIGH_INT => new PrecisionType(WebGl.RenderingContext.HIGH_INT);
}

class ShaderType{
  final index;
  const ShaderType(this.index);

  static ShaderType get FRAGMENT_SHADER => new ShaderType(WebGl.RenderingContext.FRAGMENT_SHADER);
  static ShaderType get VERTEX_SHADER => new ShaderType(WebGl.RenderingContext.VERTEX_SHADER);
}

class ShaderParameterGlEnum{
  final index;
  const ShaderParameterGlEnum(this.index);

  static ShaderParameterGlEnum get DELETE_STATUS => new ShaderParameterGlEnum(WebGl.RenderingContext.DELETE_STATUS);
  static ShaderParameterGlEnum get COMPILE_STATUS => new ShaderParameterGlEnum(WebGl.RenderingContext.COMPILE_STATUS);
  static ShaderParameterGlEnum get SHADER_TYPE => new ShaderParameterGlEnum(WebGl.RenderingContext.SHADER_TYPE);
}

class VertexAttribGlEnum{
  final index;
  const VertexAttribGlEnum(this.index);

  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_BUFFER_BINDING => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_ENABLED => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_SIZE => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_STRIDE => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_TYPE => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_NORMALIZED => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED);
  static VertexAttribGlEnum get VERTEX_ATTRIB_ARRAY_POINTER => new VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER);
  static VertexAttribGlEnum get CURRENT_VERTEX_ATTRIB => new VertexAttribGlEnum(WebGl.RenderingContext.CURRENT_VERTEX_ATTRIB);
}

class WebGLShader{

  WebGl.Shader webGLShader;

  WebGLShader(ShaderType shaderType){
    webGLShader = gl.createShader(shaderType.index);
  }

  String get infoLog{
    return gl.getShaderInfoLog(webGLShader);
  }

  String get source{
    return gl.getShaderSource(webGLShader);
  }

  void setSource(String shaderSource){
    gl.shaderSource(webGLShader, shaderSource);
  }

  void compile(){
    gl.compileShader(webGLShader);

    if (!compileStatus) {
      print(infoLog);
      window.alert("Could not compile vertex shaders");
    }
  }

  dynamic getShaderParameter(ShaderParameterGlEnum parameter){
    dynamic result =  gl.getShaderParameter(webGLShader,parameter.index);
    return result;
  }

  bool get compileStatus{
    return gl.getShaderParameter(webGLShader,ShaderParameterGlEnum.COMPILE_STATUS.index);
  }

  //Why no webGLShader ref ? >>>

  WebGl.ShaderPrecisionFormat getShaderPrecisionFormat(ShaderType shaderType, PrecisionType precisionType){
    return gl.getShaderPrecisionFormat(shaderType.index, precisionType.index);
  }

  dynamic getVertexAttrib(int vertexAttributePosition, VertexAttribGlEnum vertexAttribGlEnum){
    return gl.getVertexAttrib(vertexAttributePosition,vertexAttribGlEnum.index);
  }

  int getVertexAttribOffset(int vertexAttributePosition){
    return gl.getVertexAttribOffset(vertexAttributePosition, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_POINTER.index);
  }

}

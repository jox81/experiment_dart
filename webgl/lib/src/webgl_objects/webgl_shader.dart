import 'dart:html';
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';

class ShaderVariableType{
  final int index;
  const ShaderVariableType(this.index);

  static const ShaderVariableType FLOAT_VEC2 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_VEC2);
  static const ShaderVariableType FLOAT_VEC3 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_VEC3);
  static const ShaderVariableType FLOAT_VEC4 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_VEC4);
  static const ShaderVariableType INT_VEC2 = const ShaderVariableType(WebGl.RenderingContext.INT_VEC2);
  static const ShaderVariableType INT_VEC3 = const ShaderVariableType(WebGl.RenderingContext.INT_VEC3);
  static const ShaderVariableType INT_VEC4 = const ShaderVariableType(WebGl.RenderingContext.INT_VEC4);
  static const ShaderVariableType BOOL = const ShaderVariableType(WebGl.RenderingContext.BOOL);
  static const ShaderVariableType BOOL_VEC2 = const ShaderVariableType(WebGl.RenderingContext.BOOL_VEC2);
  static const ShaderVariableType BOOL_VEC3 = const ShaderVariableType(WebGl.RenderingContext.BOOL_VEC3);
  static const ShaderVariableType BOOL_VEC4 = const ShaderVariableType(WebGl.RenderingContext.BOOL_VEC4);
  static const ShaderVariableType FLOAT_MAT2 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_MAT2);
  static const ShaderVariableType FLOAT_MAT3 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_MAT3);
  static const ShaderVariableType FLOAT_MAT4 = const ShaderVariableType(WebGl.RenderingContext.FLOAT_MAT4);
  static const ShaderVariableType SAMPLER_2D = const ShaderVariableType(WebGl.RenderingContext.SAMPLER_2D);
  static const ShaderVariableType SAMPLER_CUBE = const ShaderVariableType(WebGl.RenderingContext.SAMPLER_CUBE);
  static const ShaderVariableType BYTE = const ShaderVariableType(WebGl.RenderingContext.BYTE);
  static const ShaderVariableType UNSIGNED_BYTE = const ShaderVariableType(WebGl.RenderingContext.UNSIGNED_BYTE);
  static const ShaderVariableType SHORT = const ShaderVariableType(WebGl.RenderingContext.SHORT);
  static const ShaderVariableType UNSIGNED_SHORT = const ShaderVariableType(WebGl.RenderingContext.UNSIGNED_SHORT);
  static const ShaderVariableType INT = const ShaderVariableType(WebGl.RenderingContext.INT);
  static const ShaderVariableType UNSIGNED_INT = const ShaderVariableType(WebGl.RenderingContext.UNSIGNED_INT);
  static const ShaderVariableType FLOAT = const ShaderVariableType(WebGl.RenderingContext.FLOAT);

  get name => null;
}

class PrecisionType{
  final index;
  const PrecisionType(this.index);

  static const PrecisionType LOW_FLOAT = const PrecisionType(WebGl.RenderingContext.LOW_FLOAT);
  static const PrecisionType MEDIUM_FLOAT = const PrecisionType(WebGl.RenderingContext.MEDIUM_FLOAT);
  static const PrecisionType HIGH_FLOAT = const PrecisionType(WebGl.RenderingContext.HIGH_FLOAT);
  static const PrecisionType LOW_INT = const PrecisionType(WebGl.RenderingContext.LOW_INT);
  static const PrecisionType MEDIUM_INT = const PrecisionType(WebGl.RenderingContext.MEDIUM_INT);
  static const PrecisionType HIGH_INT = const PrecisionType(WebGl.RenderingContext.HIGH_INT);
}

class ShaderType{
  final index;
  const ShaderType(this.index);

  static const ShaderType FRAGMENT_SHADER = const ShaderType(WebGl.RenderingContext.FRAGMENT_SHADER);
  static const ShaderType VERTEX_SHADER = const ShaderType(WebGl.RenderingContext.VERTEX_SHADER);
}

class ShaderParameterGlEnum{
  final index;
  const ShaderParameterGlEnum(this.index);

  static const ShaderParameterGlEnum DELETE_STATUS = const ShaderParameterGlEnum(WebGl.RenderingContext.DELETE_STATUS);
  static const ShaderParameterGlEnum COMPILE_STATUS = const ShaderParameterGlEnum(WebGl.RenderingContext.COMPILE_STATUS);
  static const ShaderParameterGlEnum SHADER_TYPE = const ShaderParameterGlEnum(WebGl.RenderingContext.SHADER_TYPE);
}

class VertexAttribGlEnum{
  final index;
  const VertexAttribGlEnum(this.index);

  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_ENABLED = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_SIZE = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_SIZE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_STRIDE = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_TYPE = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_TYPE);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_NORMALIZED = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED);
  static const VertexAttribGlEnum VERTEX_ATTRIB_ARRAY_POINTER = const VertexAttribGlEnum(WebGl.RenderingContext.VERTEX_ATTRIB_ARRAY_POINTER);
  static const VertexAttribGlEnum CURRENT_VERTEX_ATTRIB = const VertexAttribGlEnum(WebGl.RenderingContext.CURRENT_VERTEX_ATTRIB);
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

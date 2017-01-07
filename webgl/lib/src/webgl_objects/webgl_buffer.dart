import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class BufferType{
  final index;
  const BufferType(this.index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ARRAY_BUFFER);
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER);
}

class BufferParameterGlEnum{
  final index;
  const BufferParameterGlEnum(this.index);

  static const BufferParameterGlEnum BUFFER_SIZE = const BufferParameterGlEnum(WebGL.RenderingContext.BUFFER_SIZE);
  static const BufferParameterGlEnum BUFFER_USAGE = const BufferParameterGlEnum(WebGL.RenderingContext.BUFFER_USAGE);
}

class WebGLBuffer{

  WebGL.Buffer webGLBuffer;

  bool get isBuffer => gl.ctx.isBuffer(webGLBuffer);

  WebGLBuffer(){
    webGLBuffer = gl.ctx.createBuffer();
  }

  void delete(){
    gl.ctx.deleteBuffer(webGLBuffer);
  }

  void bind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, webGLBuffer);
  }

  void unbind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, null);
  }

  dynamic getParameter(BufferType target, BufferParameterGlEnum parameter){
    dynamic result =  gl.ctx.getBufferParameter(target.index.index,parameter.index);
    return result;
  }

  //Todo add single parameter


}

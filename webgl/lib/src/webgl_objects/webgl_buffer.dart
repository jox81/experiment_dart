import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class BufferType{
  final index;
  const BufferType(this.index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ARRAY_BUFFER);
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER);
}

class BufferUsageType {
  final index;
  const BufferUsageType(this.index);

  static const BufferUsageType STATIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STATIC_DRAW);
  static const BufferUsageType DYNAMIC_DRAW =
  const BufferUsageType(WebGL.RenderingContext.DYNAMIC_DRAW);
  static const BufferUsageType STREAM_DRAW =
  const BufferUsageType(WebGL.RenderingContext.STREAM_DRAW);
}

class BufferParameters{
  final index;
  const BufferParameters(this.index);

  static const BufferParameters BUFFER_SIZE = const BufferParameters(WebGL.RenderingContext.BUFFER_SIZE);
  static const BufferParameters BUFFER_USAGE = const BufferParameters(WebGL.RenderingContext.BUFFER_USAGE);
}

class WebGLBuffer{

  WebGL.Buffer webGLBuffer;

  bool get isBuffer => gl.ctx.isBuffer(webGLBuffer);

  WebGLBuffer(){
    webGLBuffer = gl.ctx.createBuffer();
  }
  WebGLBuffer.fromWebgl(this.webGLBuffer){
  }

  void delete(){
    gl.ctx.deleteBuffer(webGLBuffer);
    webGLBuffer = null;
  }

  void bind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, webGLBuffer);
  }

  void unbind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, null);
  }


  // >>> Parameteres


  dynamic getParameter(BufferType target, BufferParameters parameter){
    dynamic result =  gl.ctx.getBufferParameter(target.index.index,parameter.index);
    return result;
  }

  // >>> single getParameter

  // >> ARRAY_BUFFER
  // > BUFFER_SIZE
  int get arrayBufferSize => gl.ctx.getBufferParameter(BufferType.ARRAY_BUFFER.index,BufferParameters.BUFFER_SIZE.index);
  // > BUFFER_USAGE
  BufferUsageType get arrayBufferUsage => new BufferUsageType(gl.ctx.getBufferParameter(BufferType.ARRAY_BUFFER.index,BufferParameters.BUFFER_USAGE.index));

  // >> ELEMENT_ARRAY_BUFFER
  // > BUFFER_SIZE
  int get elementArrayBufferSize => gl.ctx.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER.index,BufferParameters.BUFFER_SIZE.index);
  // > BUFFER_USAGE
  BufferUsageType get elementArrayBufferUsage => new BufferUsageType(gl.ctx.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER.index,BufferParameters.BUFFER_USAGE.index));

}

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

class BufferTarget{
  final index;
  const BufferTarget(this.index);

  static const BufferTarget ARRAY_BUFFER = const BufferTarget(WebGL.RenderingContext.ARRAY_BUFFER);
  static const BufferTarget ELEMENT_ARRAY_BUFFER = const BufferTarget(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER);
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

  dynamic getParameter(BufferTarget target, BufferParameterGlEnum parameter){
    dynamic result =  gl.ctx.getBufferParameter(target.index.index,parameter.index);
    return result;
  }

  //Todo add single parameter


}

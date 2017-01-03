import 'dart:html';
import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class BufferType{
  final index;
  const BufferType(this.index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ARRAY_BUFFER);
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER);
}

class WebGLBuffer{

  WebGL.Buffer webGLBuffer;

  WebGLBuffer(){
    webGLBuffer = gl.ctx.createBuffer();
  }

}

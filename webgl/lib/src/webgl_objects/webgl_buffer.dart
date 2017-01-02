import 'dart:html';
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';

class BufferType{
  final index;
  const BufferType(this.index);

  static const BufferType ARRAY_BUFFER = const BufferType(WebGl.RenderingContext.ARRAY_BUFFER);
  static const BufferType ELEMENT_ARRAY_BUFFER = const BufferType(WebGl.RenderingContext.ELEMENT_ARRAY_BUFFER);
}

class WebGLBuffer{

  WebGl.Buffer webGLBuffer;

  WebGLBuffer(){
    webGLBuffer = gl.ctx.createBuffer();
  }

}

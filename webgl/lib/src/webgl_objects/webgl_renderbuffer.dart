import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class RenderBufferParameterGlEnum{
  final index;
  const RenderBufferParameterGlEnum(this.index);

  static const RenderBufferParameterGlEnum RENDERBUFFER_WIDTH = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_WIDTH);
  static const RenderBufferParameterGlEnum RENDERBUFFER_HEIGHT = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_HEIGHT);
  static const RenderBufferParameterGlEnum RENDERBUFFER_INTERNAL_FORMAT = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_INTERNAL_FORMAT);
  static const RenderBufferParameterGlEnum RENDERBUFFER_GREEN_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_GREEN_SIZE);
  static const RenderBufferParameterGlEnum RENDERBUFFER_BLUE_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_BLUE_SIZE);
  static const RenderBufferParameterGlEnum RENDERBUFFER_RED_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_RED_SIZE);
  static const RenderBufferParameterGlEnum RENDERBUFFER_ALPHA_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_ALPHA_SIZE);
  static const RenderBufferParameterGlEnum RENDERBUFFER_DEPTH_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_DEPTH_SIZE);
  static const RenderBufferParameterGlEnum RENDERBUFFER_STENCIL_SIZE = const RenderBufferParameterGlEnum(WebGL.RenderingContext.RENDERBUFFER_STENCIL_SIZE);
}

class RenderBufferTarget{
  final index;
  const RenderBufferTarget(this.index);

  static const RenderBufferTarget RENDERBUFFER = const RenderBufferTarget(WebGL.RenderingContext.RENDERBUFFER);
}

class WebGLRenderBuffer{

  WebGL.Renderbuffer webGLRenderBuffer;

  bool get isBuffer => gl.ctx.isRenderbuffer(webGLRenderBuffer);

  WebGLRenderBuffer(){
    webGLRenderBuffer = gl.ctx.createRenderbuffer();
  }

  void delete(){
    gl.ctx.deleteRenderbuffer(webGLRenderBuffer);
  }

  dynamic getParameter(RenderBufferParameterGlEnum parameter){
    dynamic result =  gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,parameter.index);
    return result;
  }

  //Todo : get single parameter
}

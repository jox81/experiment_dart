import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';

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

class InternalFormatType{
  final index;
  const InternalFormatType(this.index);

  static const InternalFormatType RGBA4 = const InternalFormatType(WebGL.RenderingContext.RGBA4);
  static const InternalFormatType RGB565 = const InternalFormatType(WebGL.RenderingContext.RGB565);
  static const InternalFormatType RGB5_A1 = const InternalFormatType(WebGL.RenderingContext.RGB5_A1);
  static const InternalFormatType DEPTH_COMPONENT16 = const InternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT16);
  static const InternalFormatType STENCIL_INDEX8 = const InternalFormatType(WebGL.RenderingContext.STENCIL_INDEX8);
  static const InternalFormatType DEPTH_STENCIL = const InternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL);
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

  void bind() {
    gl.ctx.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER.index, webGLRenderBuffer);
  }

  void unBind() {
    //Todo : il se peut que ce render buffer ne soit pas celui qui est bindé à ce moment. du coup, c'est un autre qui le sera. vérifier ça !
    gl.ctx.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER.index, null);
  }

  void renderbufferStorage(RenderBufferTarget renderbuffer, InternalFormatType internalFormat, int width, int heigth) {
    gl.ctx.renderbufferStorage(renderbuffer.index, internalFormat.index, width, heigth);
  }

  void framebufferRenderbuffer(FrameBufferTarget target, FrameBufferAttachment attachment, RenderBufferTarget renderBufferTarget){
    gl.ctx.framebufferRenderbuffer(target.index, attachment.index, renderBufferTarget.index, webGLRenderBuffer);
  }
}

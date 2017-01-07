import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';

class RenderBufferParameters{
  final index;
  const RenderBufferParameters(this.index);

  static const RenderBufferParameters RENDERBUFFER_WIDTH = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_WIDTH);
  static const RenderBufferParameters RENDERBUFFER_HEIGHT = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_HEIGHT);
  static const RenderBufferParameters RENDERBUFFER_INTERNAL_FORMAT = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_INTERNAL_FORMAT);
  static const RenderBufferParameters RENDERBUFFER_GREEN_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_GREEN_SIZE);
  static const RenderBufferParameters RENDERBUFFER_BLUE_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_BLUE_SIZE);
  static const RenderBufferParameters RENDERBUFFER_RED_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_RED_SIZE);
  static const RenderBufferParameters RENDERBUFFER_ALPHA_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_ALPHA_SIZE);
  static const RenderBufferParameters RENDERBUFFER_DEPTH_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_DEPTH_SIZE);
  static const RenderBufferParameters RENDERBUFFER_STENCIL_SIZE = const RenderBufferParameters(WebGL.RenderingContext.RENDERBUFFER_STENCIL_SIZE);
}

class RenderBufferTarget{
  final index;
  const RenderBufferTarget(this.index);

  static const RenderBufferTarget RENDERBUFFER = const RenderBufferTarget(WebGL.RenderingContext.RENDERBUFFER);
}

class RenderBufferInternalFormatType{
  final index;
  const RenderBufferInternalFormatType(this.index);

  static const RenderBufferInternalFormatType RGBA4 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGBA4);
  static const RenderBufferInternalFormatType RGB565 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGB565);
  static const RenderBufferInternalFormatType RGB5_A1 = const RenderBufferInternalFormatType(WebGL.RenderingContext.RGB5_A1);
  static const RenderBufferInternalFormatType DEPTH_COMPONENT16 = const RenderBufferInternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT16);
  static const RenderBufferInternalFormatType STENCIL_INDEX8 = const RenderBufferInternalFormatType(WebGL.RenderingContext.STENCIL_INDEX8);
  static const RenderBufferInternalFormatType DEPTH_STENCIL = const RenderBufferInternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL);
}

class WebGLRenderBuffer{

  WebGL.Renderbuffer webGLRenderBuffer;

  WebGLRenderBuffer.fromWebgl(this.webGLRenderBuffer);

  WebGLRenderBuffer(){
    webGLRenderBuffer = gl.ctx.createRenderbuffer();
  }

  bool get isBuffer => gl.ctx.isRenderbuffer(webGLRenderBuffer);

  void delete(){
    gl.ctx.deleteRenderbuffer(webGLRenderBuffer);
    webGLRenderBuffer = null;
  }

  // >>> Parameteres

  dynamic getParameter(RenderBufferParameters parameter){
    return gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,parameter.index);
  }

  // >>> single getParameter

  // > RENDERBUFFER_WIDTH
  int get renderBufferWidth => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_WIDTH.index);
  // > RENDERBUFFER_HEIGHT
  int get renderBufferHeight => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_HEIGHT.index);
  // > RENDERBUFFER_RED_SIZE
  int get renderBufferRedSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_RED_SIZE.index);
  // > RENDERBUFFER_GREEN_SIZE
  int get renderBufferGreenSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_GREEN_SIZE.index);
  // > RENDERBUFFER_BLUE_SIZE
  int get renderBufferBlueSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_BLUE_SIZE.index);
  // > RENDERBUFFER_ALPHA_SIZE
  int get renderBufferAlphaSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_ALPHA_SIZE.index);
  // > RENDERBUFFER_DEPTH_SIZE
  int get renderBufferDepthSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_DEPTH_SIZE.index);
  // > RENDERBUFFER_STENCIL_SIZE
  int get renderBufferStencilSize => gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_STENCIL_SIZE.index);
  // > RENDERBUFFER_INTERNAL_FORMAT
  RenderBufferInternalFormatType get renderBufferInterrnalFormat => new RenderBufferInternalFormatType(gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_INTERNAL_FORMAT.index));

  //Bind
  void bind() {
    gl.ctx.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER.index, webGLRenderBuffer);
  }

  void unBind() {
    //Todo : il se peut que ce render buffer ne soit pas celui qui est bindé à ce moment. du coup, c'est un autre qui le sera. vérifier ça !
    gl.ctx.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER.index, null);
  }

  void renderbufferStorage(RenderBufferTarget renderbuffer, RenderBufferInternalFormatType internalFormat, int width, int heigth) {
    gl.ctx.renderbufferStorage(renderbuffer.index, internalFormat.index, width, heigth);
  }

  void framebufferRenderbuffer(FrameBufferTarget target, FrameBufferAttachment attachment, RenderBufferTarget renderBufferTarget){
    gl.ctx.framebufferRenderbuffer(target.index, attachment.index, renderBufferTarget.index, webGLRenderBuffer);
  }
}

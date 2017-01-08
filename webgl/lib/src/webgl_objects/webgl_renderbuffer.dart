import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';

class WebGLRenderBuffer{

  WebGL.Renderbuffer webGLRenderBuffer;

  WebGLRenderBuffer.fromWebgl(this.webGLRenderBuffer);

  WebGLRenderBuffer(){
    webGLRenderBuffer = gl.ctx.createRenderbuffer();
  }

  bool get isRenderbuffer => gl.ctx.isRenderbuffer(webGLRenderBuffer);

  void delete(){
    gl.ctx.deleteRenderbuffer(webGLRenderBuffer);
    webGLRenderBuffer = null;
  }


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
  RenderBufferInternalFormatType get renderBufferInterrnalFormat => RenderBufferInternalFormatType.getByIndex(gl.ctx.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER.index,RenderBufferParameters.RENDERBUFFER_INTERNAL_FORMAT.index));

  void logRenderBufferInfos() {
    Utils.log("RenderBuffer Infos", () {
      print('isRenderbuffer : ${isRenderbuffer}');
      print('renderBufferWidth : ${renderBufferWidth}');
      print('renderBufferHeight : ${renderBufferHeight}');
      print('renderBufferRedSize : ${renderBufferRedSize}');
      print('renderBufferGreenSize : ${renderBufferGreenSize}');
      print('renderBufferBlueSize : ${renderBufferBlueSize}');
      print('renderBufferAlphaSize : ${renderBufferAlphaSize}');
      print('renderBufferDepthSize : ${renderBufferDepthSize}');
      print('renderBufferStencilSize : ${renderBufferStencilSize}');
      print('renderBufferInterrnalFormat : ${renderBufferInterrnalFormat}');
    });
  }
}

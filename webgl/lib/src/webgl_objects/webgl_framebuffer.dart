import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class FrameBufferStatus{
  final index;
  const FrameBufferStatus(this.index);

  static const FrameBufferStatus FRAMEBUFFER_COMPLETE = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_COMPLETE);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_DIMENSIONS = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS);
  static const FrameBufferStatus FRAMEBUFFER_UNSUPPORTED = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_UNSUPPORTED);
}

class FrameBufferTarget{
  final index;
  const FrameBufferTarget(this.index);

  static const FrameBufferTarget FRAMEBUFFER = const FrameBufferTarget(WebGL.RenderingContext.FRAMEBUFFER);
}

class FrameBufferAttachment{
  final index;
  const FrameBufferAttachment(this.index);

  static const FrameBufferAttachment COLOR_ATTACHMENT0 = const FrameBufferAttachment(WebGL.RenderingContext.COLOR_ATTACHMENT0);
  static const FrameBufferAttachment DEPTH_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.DEPTH_ATTACHMENT);
  static const FrameBufferAttachment STENCIL_ATTACHMENT = const FrameBufferAttachment(WebGL.RenderingContext.STENCIL_ATTACHMENT);
}

class FrameBufferAttachmentQuery{
  final index;
  const FrameBufferAttachmentQuery(this.index);

  static const FrameBufferAttachmentQuery FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = const FrameBufferAttachmentQuery(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE);
  static const FrameBufferAttachmentQuery FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = const FrameBufferAttachmentQuery(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME);
  static const FrameBufferAttachmentQuery FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = const FrameBufferAttachmentQuery(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL);
  static const FrameBufferAttachmentQuery FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = const FrameBufferAttachmentQuery(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE);
}

class TextureAttachmentTarget{
  final index;
  const TextureAttachmentTarget(this.index);

  static const TextureAttachmentTarget TEXTURE_2D = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_2D);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_X = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_X = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Y = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Y = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_POSITIVE_Z = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z);
  static const TextureAttachmentTarget TEXTURE_CUBE_MAP_NEGATIVE_Z = const TextureAttachmentTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z);
}

class WebGLFrameBuffer{

  WebGL.Framebuffer webGLFrameBuffer;

  bool get isBuffer => gl.ctx.isFramebuffer(webGLFrameBuffer);

  WebGLFrameBuffer(){
    webGLFrameBuffer = gl.ctx.createFramebuffer();
  }

  void delete(){
    gl.ctx.deleteFramebuffer(webGLFrameBuffer);
  }

  FrameBufferStatus checkStatus(){
    return new FrameBufferStatus(gl.ctx.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER.index));
  }

  void bind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, webGLFrameBuffer);
  }
  void unBind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, null);
  }

  //Parameters
  dynamic getAttachmentParameter(FrameBufferAttachment attachment, FrameBufferAttachmentQuery query){
    gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index,attachment.index, query.index);
  }
  //todo : add multiparameters
}

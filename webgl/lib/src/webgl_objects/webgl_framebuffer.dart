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

class FrameBufferAttachmentType{
  final index;
  const FrameBufferAttachmentType(this.index);

  static const FrameBufferAttachmentType TEXTURE = const FrameBufferAttachmentType(WebGL.RenderingContext.TEXTURE);
  static const FrameBufferAttachmentType RENDERBUFFER = const FrameBufferAttachmentType(WebGL.RenderingContext.RENDERBUFFER);
  static const FrameBufferAttachmentType NONE = const FrameBufferAttachmentType(WebGL.RenderingContext.NONE);
}

class FrameBufferAttachmentParameters{
  final index;
  const FrameBufferAttachmentParameters(this.index);

  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE);
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME);
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL);
  static const FrameBufferAttachmentParameters FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = const FrameBufferAttachmentParameters(WebGL.RenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE);
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
  WebGLFrameBuffer.fromWebgl(this.webGLFrameBuffer);

  void delete(){
    gl.ctx.deleteFramebuffer(webGLFrameBuffer);
    webGLFrameBuffer = null;
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


  // >>> Parameteres


  dynamic getAttachmentParameter(FrameBufferAttachment attachment, FrameBufferAttachmentParameters query){
    return gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index,attachment.index, query.index);
  }

  // >>> single getParameter

  // >> COLOR_ATTACHMENT0
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForColor0 => new FrameBufferAttachmentType(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForColor0 => new TextureAttachmentTarget(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));
  
  // >> DEPTH_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForDepth => new FrameBufferAttachmentType(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForDepth => new TextureAttachmentTarget(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));

  // >> STENCIL_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForStencil => new FrameBufferAttachmentType(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForStencil => new TextureAttachmentTarget(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));

}

import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';

class WebGLFrameBuffer{

  WebGL.Framebuffer webGLFrameBuffer;

  bool get isFramebuffer => gl.ctx.isFramebuffer(webGLFrameBuffer);

  WebGLFrameBuffer(){
    webGLFrameBuffer = gl.ctx.createFramebuffer();
  }
  WebGLFrameBuffer.fromWebgl(this.webGLFrameBuffer);

  void delete(){
    gl.ctx.deleteFramebuffer(webGLFrameBuffer);
    webGLFrameBuffer = null;
  }

  FrameBufferStatus checkStatus(){
    return FrameBufferStatus.getByIndex(gl.ctx.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER.index));
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
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForColor0 => FrameBufferAttachmentType.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForColor0 => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));
  
  // >> DEPTH_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForDepth => FrameBufferAttachmentType.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForDepth => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));

  // >> STENCIL_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForStencil => FrameBufferAttachmentType.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index));
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForStencil => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));

  void logFrameBufferInfos() {
    Utils.log("FrameBuffer Infos", () {
      print('isFramebuffer : ${isFramebuffer}');
    });
  }

}

import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class WebGLFrameBuffer extends WebGLObject{

  final WebGL.Framebuffer webGLFrameBuffer;

  WebGLFrameBuffer():this.webGLFrameBuffer = gl.ctx.createFramebuffer();
  WebGLFrameBuffer.fromWebGL(this.webGLFrameBuffer);

  @override
  void delete() => gl.ctx.deleteFramebuffer(webGLFrameBuffer);

  void bind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, webGLFrameBuffer);
  }
  void unBind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, null);
  }

  ////


  FrameBufferStatus checkStatus(){
    return FrameBufferStatus.getByIndex(gl.ctx.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER.index));
  }

  bool get isFramebuffer => gl.ctx.isFramebuffer(webGLFrameBuffer);

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


  void framebufferTexture2D(FrameBufferTarget target, FrameBufferAttachment attachment, TextureAttachmentTarget attachementTarget, WebGLTexture webGLTexture, int mipMapLevel){
    gl.ctx.framebufferTexture2D(target.index, attachment.index, attachementTarget.index, webGLTexture.webGLTexture, mipMapLevel);
  }

  void logFrameBufferInfos() {
    Utils.log("FrameBuffer Infos", () {
      print('isFramebuffer : ${isFramebuffer}');
      print('checkStatus() : ${checkStatus()}');
      print('###  Color0 Attachment  ############################################');
      print('frameBufferAttachmentObjectTypeForColor0 : ${frameBufferAttachmentObjectTypeForColor0}');
      print('frameBufferAttachmentObjectNameForColor0 : ${frameBufferAttachmentObjectNameForColor0}');
      print('frameBufferAttachmentTextureLevelForColor0 : ${frameBufferAttachmentTextureLevelForColor0}');
      print('frameBufferAttachmentTextureCubeMapFaceForColor0 : ${frameBufferAttachmentTextureCubeMapFaceForColor0}');
      print('###  Depth  Attachment  ###########################################');
      print('frameBufferAttachmentObjectTypeForDepth : ${frameBufferAttachmentObjectTypeForDepth}');
      print('frameBufferAttachmentObjectNameForDepth : ${frameBufferAttachmentObjectNameForDepth}');
      print('frameBufferAttachmentTextureLevelForDepth : ${frameBufferAttachmentTextureLevelForDepth}');
      print('frameBufferAttachmentTextureCubeMapFaceForDepth : ${frameBufferAttachmentTextureCubeMapFaceForDepth}');
      print('###  Stencil Attachment  ##########################################');
      print('frameBufferAttachmentObjectTypeForStencil : ${frameBufferAttachmentObjectTypeForStencil}');
      print('frameBufferAttachmentObjectNameForStencil : ${frameBufferAttachmentObjectNameForStencil}');
      print('frameBufferAttachmentTextureLevelForStencil : ${frameBufferAttachmentTextureLevelForStencil}');
      print('frameBufferAttachmentTextureCubeMapFaceForStencil : ${frameBufferAttachmentTextureCubeMapFaceForStencil}');
    });
  }

}

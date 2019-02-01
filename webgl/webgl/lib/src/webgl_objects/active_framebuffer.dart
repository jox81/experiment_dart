import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class ActiveFrameBuffer{
  static ActiveFrameBuffer _instance;
  ActiveFrameBuffer._init();

  static ActiveFrameBuffer get instance {
    if(_instance == null){
      _instance = new ActiveFrameBuffer._init();
    }
    return _instance;
  }

  // Bindings

  // > FRAMEBUFFER_BINDING
  WebGLFrameBuffer get boundFrameBuffer{
    WebGL.Framebuffer webGLFrameBuffer = gl.getParameter(ContextParameter.FRAMEBUFFER_BINDING) as WebGL.Framebuffer;
    if(webGLFrameBuffer != null && gl.isFramebuffer(webGLFrameBuffer)){
      return new WebGLFrameBuffer.fromWebGL(webGLFrameBuffer);
    }
    return null;
  }

  void bind(WebGLFrameBuffer webGLframeBuffer) {
    gl.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER, webGLframeBuffer?.webGLFrameBuffer);
  }

  void unBind(){
    gl.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER, null);
  }

  int checkFramebufferStatus(){
    return gl.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER);
  }

  // >>> Parameteres

  ///FrameBufferAttachment attachment
  ///FrameBufferAttachmentParameters query
  Object getFramebufferAttachmentParameter(int attachment, int query){
    return gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER,attachment, query);
  }

  // >>> single getParameter

  // >> COLOR_ATTACHMENT0
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  ///The type which contains the attached image.
  /// FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForColor0
  int get frameBufferAttachmentObjectTypeForColor0{
    int resultIndex = gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE) as int;
    if(resultIndex != null){
      return resultIndex;
    }
    return null;
  }
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForColor0 => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForColor0 => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL) as int;
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  /// TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForColor0
  int get frameBufferAttachmentTextureCubeMapFaceForColor0 => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE) as int;

  // >> DEPTH_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  /// FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForDepth
  int get frameBufferAttachmentObjectTypeForDepth => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE)as int;
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForDepth => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME);

//Todo : not valid with depth, or not valid with renderBuffer ?
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
//  int get frameBufferAttachmentTextureLevelForDepth => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL);
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
//  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForDepth => TextureAttachmentTarget.getByIndex(gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE));

  // >> STENCIL_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  /// FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForStencil
  int get frameBufferAttachmentObjectTypeForStencil => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE)as int;
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForStencil => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME);

//Todo : not valid with stencil, or not valid with renderBuffer ?
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
//  int get frameBufferAttachmentTextureLevelForStencil => gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL);
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
//  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForStencil => TextureAttachmentTarget.getByIndex(gl.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.STENCIL_ATTACHMENT, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE));


  // > Bind Attachments

  /// Attaches a texture to a WebGLFramebuffer.
  ///
  /// FrameBufferTarget target
  /// FrameBufferAttachment attachment
  /// TextureAttachmentTarget attachementTarget
  /// WebGLTexture webGLTexture, int mipMapLevel
  void framebufferTexture2D(int target, int attachment, int attachementTarget, WebGLTexture webGLTexture, int mipMapLevel){
    gl.framebufferTexture2D(target, attachment, attachementTarget, webGLTexture.webGLTexture, mipMapLevel);
  }

  /// FrameBufferTarget target
  /// FrameBufferAttachment attachment
  /// RenderBufferTarget renderBufferTarget
  /// WebGLRenderBuffer webGLRenderBuffer){
  void framebufferRenderbuffer(int target, int attachment, int renderBufferTarget, WebGLRenderBuffer webGLRenderBuffer){
    gl.framebufferRenderbuffer(target, attachment, renderBufferTarget, webGLRenderBuffer.webGLRenderBuffer);
  }

  // > Logs

  void logActiveFrameBufferInfos() {
    Debug.log('ActiveFrameBuffer', (){
      print('### frameBuffer bindings ############################################');
      WebGLFrameBuffer frameBuffer = boundFrameBuffer;
      print('boundFrameBuffer : ${frameBuffer}');
      int status = checkFramebufferStatus();
      print('checkFramebufferStatus() : ${GLEnum.FrameBufferStatus.getByIndex(status)}');

      if(frameBuffer != null) {
        if(frameBufferAttachmentObjectTypeForColor0 != FrameBufferAttachmentType.NONE) {
          print(
              '###  Color0 Attachment  ############################################');
          print(
              'frameBufferAttachmentObjectTypeForColor0 : ${frameBufferAttachmentObjectTypeForColor0}');
          print(
              'frameBufferAttachmentObjectNameForColor0 : ${frameBufferAttachmentObjectNameForColor0}');
          print(
              'frameBufferAttachmentTextureLevelForColor0 : ${frameBufferAttachmentTextureLevelForColor0}');
          print(
              'frameBufferAttachmentTextureCubeMapFaceForColor0 : ${frameBufferAttachmentTextureCubeMapFaceForColor0}');
        }else{
          print('###  no Color0 Attachment');
        }

        if(frameBufferAttachmentObjectTypeForDepth != FrameBufferAttachmentType.NONE) {
          print(
              '###  Depth  Attachment  ############################################');
          print(
              'frameBufferAttachmentObjectTypeForDepth : ${frameBufferAttachmentObjectTypeForDepth}');
          print(
              'frameBufferAttachmentObjectNameForDepth : ${frameBufferAttachmentObjectNameForDepth}');
          //Todo : not valid with depth, or not valid with renderBuffer ?
//          print(
//              'frameBufferAttachmentTextureLevelForDepth : ${frameBufferAttachmentTextureLevelForDepth}');
//          print(
//              'frameBufferAttachmentTextureCubeMapFaceForDepth : ${frameBufferAttachmentTextureCubeMapFaceForDepth}');
        }else{
          print('###  no Depth Attachment');
        }

        if(frameBufferAttachmentObjectTypeForStencil != FrameBufferAttachmentType.NONE) {
          print(
              '###  Stencil Attachment  ##########################################');
          print(
              'frameBufferAttachmentObjectTypeForStencil : ${frameBufferAttachmentObjectTypeForStencil}');
          print(
              'frameBufferAttachmentObjectNameForStencil : ${frameBufferAttachmentObjectNameForStencil}');
          //Todo : not valid with depth, or not valid with renderBuffer ?
//          print(
//              'frameBufferAttachmentTextureLevelForStencil : ${frameBufferAttachmentTextureLevelForStencil}');
//          print(
//              'frameBufferAttachmentTextureCubeMapFaceForStencil : ${frameBufferAttachmentTextureCubeMapFaceForStencil}');
        }else{
          print('###  no Stencil Attachment');
        }
      }else{
        print('### no frameBuffer bound');
      }
    });
  }
}
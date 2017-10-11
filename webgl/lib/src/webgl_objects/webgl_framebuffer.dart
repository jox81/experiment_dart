import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      ActiveFrameBuffer,
      WebGLFrameBuffer,
    ],
    override: '*')
import 'dart:mirrors';

class ActiveFrameBuffer extends IEditElement {
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
    WebGL.Framebuffer webGLFrameBuffer = gl.ctx.getParameter(ContextParameter.FRAMEBUFFER_BINDING.index) as WebGL.Framebuffer;
    if(webGLFrameBuffer != null && gl.ctx.isFramebuffer(webGLFrameBuffer)){
      return new WebGLFrameBuffer.fromWebGL(webGLFrameBuffer);
    }
    return null;
  }

  void bind(WebGLFrameBuffer webGLframeBuffer) {
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, webGLframeBuffer?.webGLFrameBuffer);
  }

  void unBind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, null);
  }

  FrameBufferStatus checkStatus(){
    return FrameBufferStatus.getByIndex(gl.ctx.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER.index));
  }

  // >>> Parameteres

  dynamic getAttachmentParameter(FrameBufferAttachment attachment, FrameBufferAttachmentParameters query){
    return gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index,attachment.index, query.index);
  }

  // >>> single getParameter

  // >> COLOR_ATTACHMENT0
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  ///The type which contains the attached image.
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForColor0{
    int resultIndex = gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index) as int;
    if(resultIndex != null){
      return FrameBufferAttachmentType.getByIndex(resultIndex);
    }
    return null;
  }
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
  int get frameBufferAttachmentTextureLevelForColor0 => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index) as int;
  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForColor0 => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.COLOR_ATTACHMENT0.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index) as int);

  // >> DEPTH_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForDepth => FrameBufferAttachmentType.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index)as int);
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);

//Todo : not valid with depth, or not valid with renderBuffer ?
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
//  int get frameBufferAttachmentTextureLevelForDepth => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
//  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForDepth => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.DEPTH_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));

  // >> STENCIL_ATTACHMENT
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
  FrameBufferAttachmentType get frameBufferAttachmentObjectTypeForStencil => FrameBufferAttachmentType.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE.index)as int);
  // > FRAMEBUFFER_ATTACHMENT_OBJECT_NAME : Todo : return the webGlTexture or the webGLRenderBuffer attached
  dynamic get frameBufferAttachmentObjectNameForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME.index);

//Todo : not valid with stencil, or not valid with renderBuffer ?
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL
//  int get frameBufferAttachmentTextureLevelForStencil => gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL.index);
//  // > FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE
//  TextureAttachmentTarget get frameBufferAttachmentTextureCubeMapFaceForStencil => TextureAttachmentTarget.getByIndex(gl.ctx.getFramebufferAttachmentParameter(FrameBufferTarget.FRAMEBUFFER.index, FrameBufferAttachment.STENCIL_ATTACHMENT.index, FrameBufferAttachmentParameters.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE.index));


  // > Bind Attachments

  void framebufferTexture2D(FrameBufferTarget target, FrameBufferAttachment attachment, TextureAttachmentTarget attachementTarget, WebGLTexture webGLTexture, int mipMapLevel){
    gl.ctx.framebufferTexture2D(target.index, attachment.index, attachementTarget.index, webGLTexture.webGLTexture, mipMapLevel);
  }

  void framebufferRenderbuffer(FrameBufferTarget target, FrameBufferAttachment attachment, RenderBufferTarget renderBufferTarget, WebGLRenderBuffer webGLRenderBuffer){
    gl.ctx.framebufferRenderbuffer(target.index, attachment.index, renderBufferTarget.index, webGLRenderBuffer.webGLRenderBuffer);
  }

  // > Logs

  void logActiveFrameBufferInfos() {
    Debug.log('ActiveFrameBuffer', (){
      print('### frameBuffer bindings ############################################');
      WebGLFrameBuffer frameBuffer = boundFrameBuffer;
      print('boundFrameBuffer : ${frameBuffer}');
      print('checkStatus() : ${checkStatus()}');
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

class WebGLFrameBuffer extends WebGLObject{

  final WebGL.Framebuffer webGLFrameBuffer;

  WebGLFrameBuffer():this.webGLFrameBuffer = gl.ctx.createFramebuffer();
  WebGLFrameBuffer.fromWebGL(this.webGLFrameBuffer);

  @override
  void delete() => gl.ctx.deleteFramebuffer(webGLFrameBuffer);

  bool get isFramebuffer => gl.ctx.isFramebuffer(webGLFrameBuffer);

  void logFrameBufferInfos() {
    Debug.log("FrameBuffer Infos", () {
      print('isFramebuffer : ${isFramebuffer}');
    });
  }

}

import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';

class WebGLTexture {
  WebGL.Texture webGLTexture;

  bool get isBuffer => gl.ctx.isTexture(webGLTexture);

  WebGLTexture() {
    webGLTexture = gl.ctx.createTexture();
  }
  WebGLTexture.fromWebgl(this.webGLTexture);

  void delete() {
    gl.ctx.deleteTexture(webGLTexture);
    webGLTexture = null;
  }


  // >>> Parameteres


  dynamic getParameter(TextureTarget target, TextureParameterGlEnum parameter) {
    dynamic result =
        gl.ctx.getTexParameter(target.index, parameter.index);
    return result;
  }

  // >>> single getParameter

  // > TEXTURE_MAG_FILTER
  TextureMagType get texture2DTextureMagFilter => TextureMagType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameterGlEnum.TEXTURE_MAG_FILTER.index));
  TextureMagType get textureCubeMapTextureMagFilter => TextureMagType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameterGlEnum.TEXTURE_MAG_FILTER.index));
  // > TEXTURE_MIN_FILTER
  TextureMinType get texture2DTextureMinFilter => TextureMinType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameterGlEnum.TEXTURE_MIN_FILTER.index));
  TextureMinType get textureCubeMapTextureMinFilter => TextureMinType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameterGlEnum.TEXTURE_MIN_FILTER.index));
  // > TEXTURE_WRAP_S
  TextureWrapType get texture2DTextureWrapS => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameterGlEnum.TEXTURE_WRAP_S.index));
  TextureWrapType get textureCubeMapTextureWrapS => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameterGlEnum.TEXTURE_WRAP_S.index));
  // > TEXTURE_WRAP_T
  TextureWrapType get texture2DTextureWrapT => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_2D.index,TextureParameterGlEnum.TEXTURE_WRAP_T.index));
  TextureWrapType get textureCubeMapTextureWrapT => TextureWrapType.getByIndex(gl.ctx.getTexParameter(TextureTarget.TEXTURE_CUBE_MAP.index,TextureParameterGlEnum.TEXTURE_WRAP_T.index));

  void setParameterFloat(
      TextureTarget target, TextureParameterGlEnum parameter, num value) {
    gl.ctx.texParameterf(target.index, parameter.index, value);
  }

  void setParameterInt(
      TextureTarget target, TextureParameterGlEnum parameter, TextureSetParameterType value) {
    gl.ctx.texParameteri(target.index, parameter.index, value.index);
  }

  void bind(TextureTarget target) {
    gl.ctx.bindTexture(target.index, webGLTexture);
  }

  void unBind(TextureTarget target) {
    gl.ctx.bindTexture(target.index, null);
  }

  void framebufferTexture2D(FrameBufferTarget target, FrameBufferAttachment attachment, TextureAttachmentTarget attachementTarget, int mipMapLevel){
    gl.ctx.framebufferTexture2D(target.index, attachment.index, attachementTarget.index, webGLTexture, mipMapLevel);
  }
  void generateMipmap(TextureTarget target){
    gl.ctx.generateMipmap(target.index);
  }
}

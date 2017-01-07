import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';

class TextureParameterGlEnum {
  final index;
  const TextureParameterGlEnum(this.index);

  static const TextureParameterGlEnum TEXTURE_MAG_FILTER =
      const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MAG_FILTER);
  static const TextureParameterGlEnum TEXTURE_MIN_FILTER =
      const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_MIN_FILTER);
  static const TextureParameterGlEnum TEXTURE_WRAP_S =
      const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_S);
  static const TextureParameterGlEnum TEXTURE_WRAP_T =
      const TextureParameterGlEnum(WebGL.RenderingContext.TEXTURE_WRAP_T);
  //todo add if extension ?
}

class TextureTarget {
  final index;
  const TextureTarget(this.index);

  static const TextureTarget TEXTURE_2D =
      const TextureTarget(WebGL.RenderingContext.TEXTURE_2D);
  static const TextureTarget TEXTURE_CUBE_MAP =
      const TextureTarget(WebGL.RenderingContext.TEXTURE_CUBE_MAP);
}

abstract class TextureSetParameterType {
  final int index;
  const TextureSetParameterType(this.index);
}
class TextureFilterType extends TextureSetParameterType {
  const TextureFilterType(int index):super(index);
}

class TextureMagType extends TextureFilterType {
  const TextureMagType(int index):super(index);

  static const TextureMagType LINEAR =
  const TextureMagType(WebGL.RenderingContext.LINEAR);
  static const TextureMagType NEAREST =
  const TextureMagType(WebGL.RenderingContext.NEAREST);
}

class TextureMinType extends TextureFilterType {
  const TextureMinType(int index):super(index);

  static const TextureMinType LINEAR =
  const TextureMinType(WebGL.RenderingContext.LINEAR);
  static const TextureMinType NEAREST =
  const TextureMinType(WebGL.RenderingContext.NEAREST);
  static const TextureMinType NEAREST_MIPMAP_NEAREST =
  const TextureMinType(WebGL.RenderingContext.NEAREST_MIPMAP_NEAREST);
  static const TextureMinType LINEAR_MIPMAP_NEAREST =
  const TextureMinType(WebGL.RenderingContext.LINEAR_MIPMAP_NEAREST);
  static const TextureMinType NEAREST_MIPMAP_LINEAR =
  const TextureMinType(WebGL.RenderingContext.NEAREST_MIPMAP_LINEAR);
  static const TextureMinType LINEAR_MIPMAP_LINEAR =
  const TextureMinType(WebGL.RenderingContext.LINEAR_MIPMAP_LINEAR);
}

class TextureInternalFormatType{
  final index;
  const TextureInternalFormatType(this.index);

  static const TextureInternalFormatType ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.ALPHA);
  static const TextureInternalFormatType RGB = const TextureInternalFormatType(WebGL.RenderingContext.RGB);
  static const TextureInternalFormatType RGBA = const TextureInternalFormatType(WebGL.RenderingContext.RGBA);
  static const TextureInternalFormatType LUMINANCE = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE);
  static const TextureInternalFormatType LUMINANCE_ALPHA = const TextureInternalFormatType(WebGL.RenderingContext.LUMINANCE_ALPHA);
}

//Todo move in extension
class WEBGL_depth_texture_InternalFormatType extends TextureInternalFormatType{
  const WEBGL_depth_texture_InternalFormatType(int index):super(index);

  static const WEBGL_depth_texture_InternalFormatType DEPTH_COMPONENT = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_COMPONENT);
  static const WEBGL_depth_texture_InternalFormatType DEPTH_STENCIL = const WEBGL_depth_texture_InternalFormatType(WebGL.RenderingContext.DEPTH_STENCIL);
}

class TextureWrapType extends TextureSetParameterType{
  const TextureWrapType(int index):super(index);

  static const TextureWrapType REPEAT =
      const TextureWrapType(WebGL.RenderingContext.REPEAT);
  static const TextureWrapType CLAMP_TO_EDGE =
      const TextureWrapType(WebGL.RenderingContext.CLAMP_TO_EDGE);
  static const TextureWrapType MIRRORED_REPEAT =
      const TextureWrapType(WebGL.RenderingContext.MIRRORED_REPEAT);
}

class TexelDataType{
  final index;
  const TexelDataType(this.index);

  static const TexelDataType UNSIGNED_BYTE = const TexelDataType(WebGL.RenderingContext.UNSIGNED_BYTE);
  static const TexelDataType UNSIGNED_SHORT_5_6_5 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_6_5);
  static const TexelDataType UNSIGNED_SHORT_4_4_4_4 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_4_4_4_4);
  static const TexelDataType UNSIGNED_SHORT_5_5_5_1 = const TexelDataType(WebGL.RenderingContext.UNSIGNED_SHORT_5_5_5_1);
}

class TextureUnit {
  final index;
  const TextureUnit(this.index);

  static const TextureUnit TEXTURE0 = const TextureUnit(WebGL.RenderingContext.TEXTURE0);
  static const TextureUnit TEXTURE1 = const TextureUnit(WebGL.RenderingContext.TEXTURE1);
  static const TextureUnit TEXTURE2 = const TextureUnit(WebGL.RenderingContext.TEXTURE2);
  static const TextureUnit TEXTURE3 = const TextureUnit(WebGL.RenderingContext.TEXTURE3);
  static const TextureUnit TEXTURE4 = const TextureUnit(WebGL.RenderingContext.TEXTURE4);
  static const TextureUnit TEXTURE5 = const TextureUnit(WebGL.RenderingContext.TEXTURE5);
  static const TextureUnit TEXTURE6 = const TextureUnit(WebGL.RenderingContext.TEXTURE6);
  static const TextureUnit TEXTURE7 = const TextureUnit(WebGL.RenderingContext.TEXTURE7);
  static const TextureUnit TEXTURE8 = const TextureUnit(WebGL.RenderingContext.TEXTURE8);
  static const TextureUnit TEXTURE9 = const TextureUnit(WebGL.RenderingContext.TEXTURE9);
  static const TextureUnit TEXTURE10 = const TextureUnit(WebGL.RenderingContext.TEXTURE10);
  static const TextureUnit TEXTURE11 = const TextureUnit(WebGL.RenderingContext.TEXTURE11);
  static const TextureUnit TEXTURE12 = const TextureUnit(WebGL.RenderingContext.TEXTURE12);
  static const TextureUnit TEXTURE13 = const TextureUnit(WebGL.RenderingContext.TEXTURE13);
  static const TextureUnit TEXTURE14 = const TextureUnit(WebGL.RenderingContext.TEXTURE14);
  static const TextureUnit TEXTURE15 = const TextureUnit(WebGL.RenderingContext.TEXTURE15);
  static const TextureUnit TEXTURE16 = const TextureUnit(WebGL.RenderingContext.TEXTURE16);
  static const TextureUnit TEXTURE17 = const TextureUnit(WebGL.RenderingContext.TEXTURE17);
  static const TextureUnit TEXTURE18 = const TextureUnit(WebGL.RenderingContext.TEXTURE18);
  static const TextureUnit TEXTURE19 = const TextureUnit(WebGL.RenderingContext.TEXTURE19);
  static const TextureUnit TEXTURE20 = const TextureUnit(WebGL.RenderingContext.TEXTURE20);
  static const TextureUnit TEXTURE21 = const TextureUnit(WebGL.RenderingContext.TEXTURE21);
  static const TextureUnit TEXTURE22 = const TextureUnit(WebGL.RenderingContext.TEXTURE22);
  static const TextureUnit TEXTURE23 = const TextureUnit(WebGL.RenderingContext.TEXTURE23);
  static const TextureUnit TEXTURE24 = const TextureUnit(WebGL.RenderingContext.TEXTURE24);
  static const TextureUnit TEXTURE25 = const TextureUnit(WebGL.RenderingContext.TEXTURE25);
  static const TextureUnit TEXTURE26 = const TextureUnit(WebGL.RenderingContext.TEXTURE26);
  static const TextureUnit TEXTURE27 = const TextureUnit(WebGL.RenderingContext.TEXTURE27);
  static const TextureUnit TEXTURE28 = const TextureUnit(WebGL.RenderingContext.TEXTURE28);
  static const TextureUnit TEXTURE29 = const TextureUnit(WebGL.RenderingContext.TEXTURE29);
  static const TextureUnit TEXTURE30 = const TextureUnit(WebGL.RenderingContext.TEXTURE30);
  static const TextureUnit TEXTURE31 = const TextureUnit(WebGL.RenderingContext.TEXTURE31);
}

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

  dynamic getParameter(TextureTarget target, TextureParameterGlEnum parameter) {
    dynamic result =
        gl.ctx.getTexParameter(target.index.index, parameter.index);
    return result;
  }

  //Todo add single parameter

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

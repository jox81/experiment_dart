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
abstract class TextureFilterType extends TextureSetParameterType {
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

class TextureWrapType extends TextureSetParameterType{
  const TextureWrapType(int index):super(index);

  static const TextureWrapType REPEAT =
      const TextureWrapType(WebGL.RenderingContext.REPEAT);
  static const TextureWrapType CLAMP_TO_EDGE =
      const TextureWrapType(WebGL.RenderingContext.CLAMP_TO_EDGE);
  static const TextureWrapType MIRRORED_REPEAT =
      const TextureWrapType(WebGL.RenderingContext.MIRRORED_REPEAT);
}

class WebGLTexture {
  WebGL.Texture webGLTexture;

  bool get isBuffer => gl.ctx.isTexture(webGLTexture);

  WebGLTexture() {
    webGLTexture = gl.ctx.createTexture();
  }

  void delete() {
    gl.ctx.deleteTexture(webGLTexture);
  }

  dynamic getParameter(TextureTarget target, TextureParameterGlEnum parameter) {
    dynamic result =
        gl.ctx.getRenderbufferParameter(target.index.index, parameter.index);
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

  void framebufferTexture2D(FrameBufferTarget target, FrameBufferAttachment attachment, AttachmentTextureTarget attachementTarget, int mipMapLevel){
    gl.ctx.framebufferTexture2D(target.index, attachment.index, attachementTarget.index, webGLTexture, mipMapLevel);
  }
}

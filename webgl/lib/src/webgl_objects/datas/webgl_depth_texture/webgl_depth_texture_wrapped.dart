import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';
@MirrorsUsed(
    targets: const [
      WEBGL_depth_texture_InternalFormat,
      WEBGL_depth_texture_TexelDataType,
      WEBGL_depth_texture_TextureAttachmentTarget,
    ],
    override: '*')
import 'dart:mirrors';

//Extension : WEBGL_depth_texture
//From https://www.khronos.org/registry/webgl/extensions/WEBGL_depth_texture/
//!! This extension is only available to WebGL1 contexts.
// In WebGL2, the functionality of this extension is available on the WebGL2 context by default.
class WEBGL_depth_texture_InternalFormat extends TextureInternalFormat {
  const WEBGL_depth_texture_InternalFormat(int index, String name)
      : super(index, name);
  static WebGLEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(WEBGL_depth_texture_InternalFormat, index);

  static const WEBGL_depth_texture_InternalFormat DEPTH_COMPONENT =
  const WEBGL_depth_texture_InternalFormat(
      WebGL.RenderingContext.DEPTH_COMPONENT, 'DEPTH_COMPONENT');

  static const WEBGL_depth_texture_InternalFormat DEPTH_STENCIL =
  const WEBGL_depth_texture_InternalFormat(
      WebGL.RenderingContext.DEPTH_STENCIL, 'DEPTH_STENCIL');

}

class WEBGL_depth_texture_TexelDataType extends TexelDataType {
  const WEBGL_depth_texture_TexelDataType(int index, String name)
      : super(index, name);
  static WebGLEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(WEBGL_depth_texture_TexelDataType, index);

  ///Unsigned integer type for 24-bit depth texture data.
  static const WEBGL_depth_texture_TexelDataType UNSIGNED_INT_24_8_WEBGL =
  const WEBGL_depth_texture_TexelDataType(
      WebGL.DepthTexture.UNSIGNED_INT_24_8_WEBGL, 'UNSIGNED_INT_24_8_WEBGL');

  static const WEBGL_depth_texture_TexelDataType UNSIGNED_SHORT = const WEBGL_depth_texture_TexelDataType(
      WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const WEBGL_depth_texture_TexelDataType UNSIGNED_INT = const WEBGL_depth_texture_TexelDataType(
      WebGL.RenderingContext.UNSIGNED_INT, 'UNSIGNED_INT');
}

class WEBGL_depth_texture_TextureAttachmentTarget extends TextureAttachmentTarget {
  const WEBGL_depth_texture_TextureAttachmentTarget(int index, String name)
      : super(index, name);
  static WebGLEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(WEBGL_depth_texture_TextureAttachmentTarget, index);

  static const WEBGL_depth_texture_TextureAttachmentTarget DEPTH_ATTACHMENT = const WEBGL_depth_texture_TextureAttachmentTarget(
      WebGL.RenderingContext.DEPTH_ATTACHMENT, 'DEPTH_ATTACHMENT');
  static const WEBGL_depth_texture_TextureAttachmentTarget DEPTH_STENCIL_ATTACHMENT = const WEBGL_depth_texture_TextureAttachmentTarget(
      WebGL.RenderingContext.DEPTH_STENCIL_ATTACHMENT, 'DEPTH_STENCIL_ATTACHMENT');
}
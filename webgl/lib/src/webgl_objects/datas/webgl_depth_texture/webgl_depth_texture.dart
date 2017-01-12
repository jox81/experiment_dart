import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

//Extension : WEBGL_depth_texture
//From https://www.khronos.org/registry/webgl/extensions/WEBGL_depth_texture/
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

  static const WEBGL_depth_texture_TexelDataType UNSIGNED_INT_24_8_WEBGL =
  const WEBGL_depth_texture_TexelDataType(
      WebGL.DepthTexture.UNSIGNED_INT_24_8_WEBGL, 'UNSIGNED_INT_24_8_WEBGL');
  static const WEBGL_depth_texture_TexelDataType UNSIGNED_SHORT = const WEBGL_depth_texture_TexelDataType(
      WebGL.RenderingContext.UNSIGNED_SHORT, 'UNSIGNED_SHORT');
  static const WEBGL_depth_texture_TexelDataType UNSIGNED_INT = const WEBGL_depth_texture_TexelDataType(
      WebGL.RenderingContext.UNSIGNED_INT, 'UNSIGNED_INT');
}